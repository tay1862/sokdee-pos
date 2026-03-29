package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/go-chi/chi/v5"
	chimw "github.com/go-chi/chi/v5/middleware"
	"github.com/sokdee/pos-backend/internal/auth"
	"github.com/sokdee/pos-backend/internal/database"
	"github.com/sokdee/pos-backend/internal/inventory"
	"github.com/sokdee/pos-backend/internal/kds"
	appMiddleware "github.com/sokdee/pos-backend/internal/middleware"
	"github.com/sokdee/pos-backend/internal/pos"
	"github.com/sokdee/pos-backend/internal/tenant"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// ── Database ──────────────────────────────────────────────────────────────
	ctx := context.Background()
	db, err := database.Connect(ctx)
	if err != nil {
		log.Fatalf("failed to connect to database: %v", err)
	}
	defer db.Close()
	log.Println("Database connected")

	// ── Repositories ──────────────────────────────────────────────────────────
	authRepo := auth.NewPgRepository(db)
	tenantPlanRepo := tenant.NewPgPlanRepository(db)
	tenantRepo := tenant.NewPgTenantRepository(db)
	userRepo := tenant.NewPgUserRepository(db)
	inventoryRepo := inventory.NewPgRepository(db)
	posRepo := pos.NewPgRepository(db)
	shiftRepo := pos.NewPgShiftRepository(db)
	exchangeRateRepo := pos.NewPgExchangeRateRepository(db)

	// ── Handlers ──────────────────────────────────────────────────────────────
	authHandler := auth.NewHandler(authRepo)
	planHandler := tenant.NewPlanHandler(tenantPlanRepo)
	tenantHandler := tenant.NewTenantHandler(tenantRepo)
	userHandler := tenant.NewUserHandler(userRepo)
	inventoryHandler := inventory.NewHandler(inventoryRepo, func(tenantID string) (*int, error) {
		plan, err := userRepo.GetTenantPlan(context.Background(), tenantID)
		if err != nil || plan == nil {
			return nil, err
		}
		return plan.MaxProducts, nil
	})
	posHandler := pos.NewHandler(posRepo)
	shiftHandler := pos.NewShiftHandler(shiftRepo)
	exchangeRateHandler := pos.NewExchangeRateHandler(exchangeRateRepo)

	// ── KDS Hub ───────────────────────────────────────────────────────────────
	kdsHub := kds.NewHub()
	kdsHandler := kds.NewHandler(kdsHub)

	// ── Router ────────────────────────────────────────────────────────────────
	r := chi.NewRouter()

	r.Use(chimw.RequestID)
	r.Use(chimw.RealIP)
	r.Use(chimw.Logger)
	r.Use(chimw.Recoverer)
	r.Use(chimw.Timeout(60 * time.Second))

	// CORS for Flutter Web
	r.Use(func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Access-Control-Allow-Origin", "*")
			w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")
			if r.Method == http.MethodOptions {
				w.WriteHeader(http.StatusNoContent)
				return
			}
			next.ServeHTTP(w, r)
		})
	})

	// ── Health ────────────────────────────────────────────────────────────────
	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"status":"ok","service":"sokdee-pos"}`))
	})

	// ── WebSocket KDS ─────────────────────────────────────────────────────────
	r.Get("/ws/kds", kdsHandler.ServeWS)

	// ── API v1 ────────────────────────────────────────────────────────────────
	r.Route("/api/v1", func(r chi.Router) {

		// Public auth routes
		r.Post("/auth/login", authHandler.Login)
		r.Post("/auth/refresh", authHandler.Refresh)
		r.Post("/auth/logout", authHandler.Logout)

		// Authenticated routes
		r.Group(func(r chi.Router) {
			r.Use(appMiddleware.Authenticate)
			r.Use(appMiddleware.TenantIsolation(db))

			// Device management
			r.Post("/auth/device/register", authHandler.RegisterDevice)
			r.Delete("/auth/device/{deviceId}", authHandler.RevokeDevice)

			// Users
			r.Get("/users", userHandler.ListUsers)
			r.Post("/users", userHandler.CreateUser)
			r.Patch("/users/{id}", userHandler.UpdateUser)
			r.Delete("/users/{id}", userHandler.DeactivateUser)
			r.Patch("/users/{id}/pin", userHandler.ChangePIN)

			// Products & Inventory
			r.Get("/products", inventoryHandler.ListProducts)
			r.Post("/products", inventoryHandler.CreateProduct)
			r.Get("/products/{id}", inventoryHandler.GetProduct)
			r.Patch("/products/{id}", inventoryHandler.UpdateProduct)
			r.Delete("/products/{id}", inventoryHandler.DeleteProduct)
			r.Post("/products/import", inventoryHandler.ImportCSV)
			r.Get("/categories", inventoryHandler.ListCategories)
			r.Post("/categories", inventoryHandler.CreateCategory)
			r.Post("/stock/in", inventoryHandler.StockIn)
			r.Post("/stock/adjust", inventoryHandler.StockAdjust)
			r.Get("/stock/transactions", inventoryHandler.ListStockTransactions)

			// Orders & POS
			r.Get("/orders", posHandler.ListOrders)
			r.Post("/orders", posHandler.CreateOrder)
			r.Get("/orders/{id}", posHandler.GetOrder)
			r.Patch("/orders/{id}", notImplemented)
			r.Post("/orders/{id}/pay", posHandler.ProcessPayment)
			r.Post("/orders/{id}/void", posHandler.VoidOrder)
			r.Post("/orders/{id}/refund", posHandler.RefundOrder)

			// Tables
			r.Get("/tables", notImplemented)
			r.Post("/tables", notImplemented)
			r.Patch("/tables/{id}", notImplemented)
			r.Post("/tables/merge", notImplemented)
			r.Post("/tables/{id}/move", notImplemented)

			// Shifts
			r.Get("/shifts", shiftHandler.ListShifts)
			r.Post("/shifts/open", shiftHandler.OpenShift)
			r.Post("/shifts/{id}/close", shiftHandler.CloseShift)
			r.Get("/shifts/{id}/summary", shiftHandler.GetShiftSummary)

			// Discounts
			r.Get("/discounts", notImplemented)
			r.Post("/discounts", notImplemented)
			r.Patch("/discounts/{id}", notImplemented)

			// Reports
			r.Get("/reports/sales/daily", notImplemented)
			r.Get("/reports/sales/monthly", notImplemented)
			r.Get("/reports/pnl", notImplemented)
			r.Get("/reports/stock", notImplemented)
			r.Get("/reports/cashier", notImplemented)
			r.Get("/reports/export", notImplemented)

			// Sync
			r.Post("/sync/push", notImplemented)
			r.Get("/sync/pull", notImplemented)
			r.Get("/sync/conflicts", notImplemented)
			r.Post("/sync/conflicts/{id}/resolve", notImplemented)

			// Settings & Exchange Rates
			r.Get("/settings", notImplemented)
			r.Patch("/settings", notImplemented)
			r.Get("/settings/exchange-rates", exchangeRateHandler.GetRates)
			r.Post("/settings/exchange-rates", exchangeRateHandler.SetRate)

			// Notifications
			r.Get("/notifications", notImplemented)
			r.Patch("/notifications/{id}/read", notImplemented)

			// Super Admin routes
			r.Group(func(r chi.Router) {
				r.Use(appMiddleware.RequireSuperAdmin)
				r.Get("/admin/tenants", tenantHandler.ListTenants)
				r.Post("/admin/tenants", tenantHandler.CreateTenant)
				r.Get("/admin/tenants/{id}", tenantHandler.GetTenant)
				r.Patch("/admin/tenants/{id}", tenantHandler.UpdateTenant)
				r.Patch("/admin/tenants/{id}/suspend", tenantHandler.SuspendTenant)
				r.Patch("/admin/tenants/{id}/activate", tenantHandler.ActivateTenant)
				r.Get("/admin/plans", planHandler.ListPlans)
				r.Post("/admin/plans", planHandler.CreatePlan)
				r.Patch("/admin/plans/{id}", planHandler.UpdatePlan)
			})
		})
	})

	// ── Server ────────────────────────────────────────────────────────────────
	srv := &http.Server{
		Addr:         ":" + port,
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	done := make(chan os.Signal, 1)
	signal.Notify(done, os.Interrupt, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		log.Printf("SOKDEE POS backend starting on :%s", port)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("listen: %s", err)
		}
	}()

	<-done
	log.Println("Shutting down...")
	shutCtx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	_ = srv.Shutdown(shutCtx)
	log.Println("Server stopped")
}

func notImplemented(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusNotImplemented)
	_, _ = w.Write([]byte(`{"error":{"code":"not_implemented","message":"endpoint coming soon"}}`))
}
