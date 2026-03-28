package pos

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// Repository defines data access for POS operations
type Repository interface {
	CreateOrder(ctx context.Context, order *Order) error
	GetOrder(ctx context.Context, tenantID, id string) (*Order, error)
	ListOrders(ctx context.Context, tenantID string, status string) ([]*Order, error)
	UpdateOrderStatus(ctx context.Context, tenantID, id, status string) error
	AddOrderItems(ctx context.Context, items []OrderItem) error
	ProcessPayment(ctx context.Context, tenantID, orderID string, payments []PaymentLine) error
	VoidOrder(ctx context.Context, tenantID, orderID, reason, userID, shiftID string) error
	RefundOrder(ctx context.Context, tenantID, orderID string, req RefundRequest) error
	GetActiveShiftID(ctx context.Context, tenantID, cashierID string) (*string, error)
	GetExchangeRate(ctx context.Context, tenantID, currency string) (float64, error)
}

// Handler handles POS HTTP endpoints
type Handler struct {
	repo Repository
}

// NewHandler creates a new POS handler
func NewHandler(repo Repository) *Handler {
	return &Handler{repo: repo}
}

// ─── Orders ───────────────────────────────────────────────────────────────────

// CreateOrder handles POST /api/v1/orders
func (h *Handler) CreateOrder(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())

	var order Order
	if err := json.NewDecoder(r.Body).Decode(&order); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	order.TenantID = claims.TenantID
	order.CashierID = claims.Subject
	order.Status = "open"
	order.CreatedAt = time.Now()

	// Attach active shift
	shiftID, _ := h.repo.GetActiveShiftID(r.Context(), claims.TenantID, claims.Subject)
	order.ShiftID = shiftID

	if err := h.repo.CreateOrder(r.Context(), &order); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create order")
		return
	}

	apperrors.RespondJSON(w, http.StatusCreated, order)
}

// GetOrder handles GET /api/v1/orders/:id
func (h *Handler) GetOrder(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	id := extractID(r.URL.Path)

	order, err := h.repo.GetOrder(r.Context(), claims.TenantID, id)
	if err != nil || order == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "order not found")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, order)
}

// ListOrders handles GET /api/v1/orders
func (h *Handler) ListOrders(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	status := r.URL.Query().Get("status")

	orders, err := h.repo.ListOrders(r.Context(), claims.TenantID, status)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list orders")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"orders": orders})
}

// ─── Payment ──────────────────────────────────────────────────────────────────

// ProcessPayment handles POST /api/v1/orders/:id/pay
func (h *Handler) ProcessPayment(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	orderID := extractOrderID(r.URL.Path, "/pay")

	order, err := h.repo.GetOrder(r.Context(), claims.TenantID, orderID)
	if err != nil || order == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "order not found")
		return
	}
	if order.Status != "open" {
		apperrors.RespondError(w, http.StatusConflict, "order_not_open", "order is not open")
		return
	}

	var req PaymentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	// Validate exchange rates for non-LAK currencies
	for i, p := range req.Payments {
		if p.Currency != "LAK" {
			rate, err := h.repo.GetExchangeRate(r.Context(), claims.TenantID, p.Currency)
			if err != nil || rate == 0 {
				apperrors.RespondError(w, http.StatusConflict, apperrors.ErrCurrencyNotSet,
					"exchange rate not configured for "+p.Currency)
				return
			}
			req.Payments[i].ExchangeRate = rate
		} else {
			req.Payments[i].ExchangeRate = 1
		}
	}

	// Validate total paid >= order total
	var totalPaidLAK float64
	for _, p := range req.Payments {
		totalPaidLAK += p.Amount * p.ExchangeRate
	}
	if totalPaidLAK < order.Total {
		apperrors.RespondError(w, http.StatusConflict, "insufficient_payment",
			"payment amount is less than order total",
			map[string]any{"required": order.Total, "paid": totalPaidLAK})
		return
	}

	if err := h.repo.ProcessPayment(r.Context(), claims.TenantID, orderID, req.Payments); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to process payment")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]any{
		"order_id": orderID,
		"status":   "paid",
		"total":    order.Total,
	})
}

// ─── Void ─────────────────────────────────────────────────────────────────────

// VoidOrder handles POST /api/v1/orders/:id/void
func (h *Handler) VoidOrder(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	orderID := extractOrderID(r.URL.Path, "/void")

	order, err := h.repo.GetOrder(r.Context(), claims.TenantID, orderID)
	if err != nil || order == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "order not found")
		return
	}

	// Void only allowed within the same active shift
	shiftID, _ := h.repo.GetActiveShiftID(r.Context(), claims.TenantID, claims.Subject)
	if shiftID == nil || order.ShiftID == nil || *shiftID != *order.ShiftID {
		apperrors.RespondError(w, http.StatusConflict, "void_not_allowed",
			"void is only allowed within the same active shift; use refund instead")
		return
	}

	var req VoidRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.Reason == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "reason is required")
		return
	}

	if err := h.repo.VoidOrder(r.Context(), claims.TenantID, orderID, req.Reason, claims.Subject, *shiftID); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to void order")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"status": "voided"})
}

// ─── Refund ───────────────────────────────────────────────────────────────────

// RefundOrder handles POST /api/v1/orders/:id/refund
func (h *Handler) RefundOrder(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	orderID := extractOrderID(r.URL.Path, "/refund")

	order, err := h.repo.GetOrder(r.Context(), claims.TenantID, orderID)
	if err != nil || order == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "order not found")
		return
	}
	if order.Status != "paid" {
		apperrors.RespondError(w, http.StatusConflict, "refund_not_allowed", "only paid orders can be refunded")
		return
	}

	var req RefundRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	if req.Reason == "" || req.ApprovedBy == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "reason and approved_by are required")
		return
	}

	if err := h.repo.RefundOrder(r.Context(), claims.TenantID, orderID, req); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to process refund")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"status": "refunded"})
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

func extractID(path string) string {
	return extractLastSegment(path)
}

func extractOrderID(path, suffix string) string {
	// trim the action suffix (e.g. "/pay", "/void") then get the order ID
	idx := len(path) - len(suffix)
	if idx > 0 {
		path = path[:idx]
	}
	return extractLastSegment(path)
}
