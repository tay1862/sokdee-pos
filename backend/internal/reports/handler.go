package reports

import (
	"context"
	"net/http"
	"time"

	"github.com/sokdee/pos-backend/internal/auth"
	"github.com/sokdee/pos-backend/pkg/models"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// DailySalesReport holds daily sales data
type DailySalesReport struct {
	Date             string             `json:"date"`
	TotalSales       float64            `json:"total_sales"`
	TransactionCount int                `json:"transaction_count"`
	TopProducts      []TopProduct       `json:"top_products"`
	ByPaymentMethod  map[string]float64 `json:"by_payment_method"`
}

// TopProduct is a best-selling product entry
type TopProduct struct {
	ProductName string  `json:"product_name"`
	Quantity    int     `json:"quantity"`
	Revenue     float64 `json:"revenue"`
}

// MonthlySalesReport holds monthly sales data
type MonthlySalesReport struct {
	Month        string    `json:"month"`
	TotalSales   float64   `json:"total_sales"`
	PrevMonth    float64   `json:"prev_month_sales"`
	GrowthPct    float64   `json:"growth_pct"`
	DailyTrend   []float64 `json:"daily_trend"`
}

// PnLReport holds profit and loss data
type PnLReport struct {
	Period   string  `json:"period"`
	Revenue  float64 `json:"revenue"`
	COGS     float64 `json:"cogs"`
	GrossProfit float64 `json:"gross_profit"`
	GrossMargin float64 `json:"gross_margin_pct"`
}

// StockReport holds inventory status
type StockReport struct {
	TotalProducts  int           `json:"total_products"`
	TotalValue     float64       `json:"total_value"`
	LowStockItems  []StockItem   `json:"low_stock_items"`
	OutOfStockItems []StockItem  `json:"out_of_stock_items"`
}

// StockItem is a product stock entry
type StockItem struct {
	ProductName string  `json:"product_name"`
	StockQty    int     `json:"stock_qty"`
	MinStock    int     `json:"min_stock"`
	Value       float64 `json:"value"`
}

// CashierReport holds per-cashier performance
type CashierReport struct {
	CashierName      string  `json:"cashier_name"`
	TransactionCount int     `json:"transaction_count"`
	TotalSales       float64 `json:"total_sales"`
	AvgTransaction   float64 `json:"avg_transaction"`
	VoidCount        int     `json:"void_count"`
	RefundCount      int     `json:"refund_count"`
}

// Repository defines data access for reports
type Repository interface {
	GetDailySales(ctx context.Context, tenantID string, date time.Time) (*DailySalesReport, error)
	GetMonthlySales(ctx context.Context, tenantID string, year, month int) (*MonthlySalesReport, error)
	GetPnL(ctx context.Context, tenantID string, from, to time.Time) (*PnLReport, error)
	GetStockReport(ctx context.Context, tenantID string) (*StockReport, error)
	GetCashierReport(ctx context.Context, tenantID string, from, to time.Time) ([]*CashierReport, error)
}

// Handler handles report endpoints
type Handler struct{ repo Repository }

// NewHandler creates a new reports handler
func NewHandler(repo Repository) *Handler { return &Handler{repo: repo} }

// DailySales handles GET /api/v1/reports/sales/daily
func (h *Handler) DailySales(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	dateStr := r.URL.Query().Get("date")
	date := time.Now()
	if dateStr != "" {
		if d, err := time.Parse("2006-01-02", dateStr); err == nil {
			date = d
		}
	}
	report, err := h.repo.GetDailySales(r.Context(), claims.TenantID, date)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to generate report")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, report)
}

// MonthlySales handles GET /api/v1/reports/sales/monthly
func (h *Handler) MonthlySales(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	now := time.Now()
	report, err := h.repo.GetMonthlySales(r.Context(), claims.TenantID, now.Year(), int(now.Month()))
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to generate report")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, report)
}

// PnL handles GET /api/v1/reports/pnl (Owner only)
func (h *Handler) PnL(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	if models.RoleLevel(claims.Role) < models.RoleLevel(models.RoleOwner) {
		apperrors.RespondError(w, http.StatusForbidden, apperrors.ErrForbidden, "P&L report is restricted to owners")
		return
	}
	now := time.Now()
	from := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, time.UTC)
	report, err := h.repo.GetPnL(r.Context(), claims.TenantID, from, now)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to generate report")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, report)
}

// StockReport handles GET /api/v1/reports/stock
func (h *Handler) StockReport(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	report, err := h.repo.GetStockReport(r.Context(), claims.TenantID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to generate report")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, report)
}

// CashierReport handles GET /api/v1/reports/cashier
func (h *Handler) CashierReport(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	now := time.Now()
	from := now.AddDate(0, -1, 0)
	reports, err := h.repo.GetCashierReport(r.Context(), claims.TenantID, from, now)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to generate report")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"cashiers": reports})
}

// Export handles GET /api/v1/reports/export
func (h *Handler) Export(w http.ResponseWriter, r *http.Request) {
	reportType := r.URL.Query().Get("report")
	format := r.URL.Query().Get("type") // pdf or csv

	// Placeholder — actual PDF/CSV generation in production
	w.Header().Set("Content-Type", "application/json")
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{
		"message": "export queued",
		"report":  reportType,
		"format":  format,
	})
}
