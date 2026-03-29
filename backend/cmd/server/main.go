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
	"github.com/sokdee/pos-backend/internal/kds"
	appMiddleware "github.com/sokdee/pos-backend/internal/middleware"
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

	// ── Handlers ──────────────────────────────────────────────────────────────
	authHandler := auth.NewHandler(authRepo)

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
			r.Get("/users", notImplemented)
			r.Post("/users", notImplemented)
			r.Patch("/users/{id}", notImplemented)
			r.Delete("/users/{id}", notImplemented)
			r.Patch("/users/{id}/pin", notImplemented)

			// Products & Inventory
			r.Get("/products", notImplemented)
			r.Post("/products", notImplemented)
			r.Patch("/products/{id}", notImplemented)
			r.Delete("/products/{id}", notImplemented)
			r.Post("/products/import", notImplemented)
			r.Get("/categories", notImplemented)
			r.Post("/categories", notImplemented)
			r.Post("/stock/in", notImplemented)
			r.Post("/stock/adjust", notImplemented)
			r.Get("/stock/transactions", notImplemented)

			// Orders & POS
			r.Get("/orders", notImplemented)
			r.Post("/orders", notImplemented)
			r.Get("/orders/{id}", notImplemented)
			r.Patch("/orders/{id}", notImplemented)
			r.Post("/orders/{id}/pay", notImplemented)
			r.Post("/orders/{id}/void", notImplemented)
			r.Post("/orders/{id}/refund", notImplemented)

			// Tables
			r.Get("/tables", notImplemented)
			r.Post("/tables", notImplemented)
			r.Patch("/tables/{id}", notImplemented)
			r.Post("/tables/merge", notImplemented)
			r.Post("/tables/{id}/move", notImplemented)

			// Shifts
			r.Get("/shifts", notImplemented)
			r.Post("/shifts/open", notImplemented)
			r.Post("/shifts/{id}/close", notImplemented)
			r.Get("/shifts/{id}/summary", notImplemented)

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

			// Settings
			r.Get("/settings", notImplemented)
			r.Patch("/settings", notImplemented)
			r.Get("/settings/exchange-rates", notImplemented)
			r.Post("/settings/exchange-rates", notImplemented)

			// Notifications
			r.Get("/notifications", notImplemented)
			r.Patch("/notifications/{id}/read", notImplemented)

			// Super Admin routes
			r.Group(func(r chi.Router) {
				r.Use(appMiddleware.RequireSuperAdmin)
				r.Get("/admin/tenants", notImplemented)
				r.Post("/admin/tenants", notImplemented)
				r.Get("/admin/tenants/{id}", notImplemented)
				r.Patch("/admin/tenants/{id}", notImplemented)
				r.Patch("/admin/tenants/{id}/suspend", notImplemented)
				r.Patch("/admin/tenants/{id}/activate", notImplemented)
				r.Get("/admin/plans", notImplemented)
				r.Post("/admin/plans", notImplemented)
				r.Patch("/admin/plans/{id}", notImplemented)
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
