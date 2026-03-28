package pos

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// Shift represents a cashier work shift
type Shift struct {
	ID             string     `json:"id"`
	TenantID       string     `json:"tenant_id"`
	CashierID      string     `json:"cashier_id"`
	DeviceID       *string    `json:"device_id"`
	OpeningBalance float64    `json:"opening_balance"`
	ClosingBalance *float64   `json:"closing_balance"`
	Status         string     `json:"status"` // open, closed
	OpenedAt       time.Time  `json:"opened_at"`
	ClosedAt       *time.Time `json:"closed_at"`
}

// ShiftSummary holds end-of-shift reconciliation data
type ShiftSummary struct {
	ShiftID          string  `json:"shift_id"`
	TotalSales       float64 `json:"total_sales"`
	TotalCash        float64 `json:"total_cash"`
	TotalQR          float64 `json:"total_qr"`
	TotalTransfer    float64 `json:"total_transfer"`
	ExpectedCash     float64 `json:"expected_cash"`
	ActualCash       float64 `json:"actual_cash"`
	CashDifference   float64 `json:"cash_difference"`
	TransactionCount int     `json:"transaction_count"`
	VoidCount        int     `json:"void_count"`
	RefundCount      int     `json:"refund_count"`
}

// ShiftRepository defines data access for shifts
type ShiftRepository interface {
	GetActiveShift(ctx context.Context, tenantID, cashierID string) (*Shift, error)
	CreateShift(ctx context.Context, shift *Shift) error
	CloseShift(ctx context.Context, tenantID, shiftID string, closingBalance float64) error
	ListShifts(ctx context.Context, tenantID string) ([]*Shift, error)
	GetShiftSummary(ctx context.Context, tenantID, shiftID string) (*ShiftSummary, error)
}

// ShiftHandler handles shift endpoints
type ShiftHandler struct{ repo ShiftRepository }

// NewShiftHandler creates a new shift handler
func NewShiftHandler(repo ShiftRepository) *ShiftHandler { return &ShiftHandler{repo: repo} }

// OpenShift handles POST /api/v1/shifts/open
func (h *ShiftHandler) OpenShift(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())

	// Check for existing active shift
	existing, _ := h.repo.GetActiveShift(r.Context(), claims.TenantID, claims.Subject)
	if existing != nil {
		apperrors.RespondError(w, http.StatusConflict, apperrors.ErrShiftAlreadyOpen,
			"cashier already has an active shift",
			map[string]any{"shift_id": existing.ID})
		return
	}

	var req struct {
		OpeningBalance float64 `json:"opening_balance"`
		DeviceID       *string `json:"device_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	shift := &Shift{
		TenantID:       claims.TenantID,
		CashierID:      claims.Subject,
		DeviceID:       req.DeviceID,
		OpeningBalance: req.OpeningBalance,
		Status:         "open",
		OpenedAt:       time.Now(),
	}

	if err := h.repo.CreateShift(r.Context(), shift); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to open shift")
		return
	}

	apperrors.RespondJSON(w, http.StatusCreated, shift)
}

// CloseShift handles POST /api/v1/shifts/:id/close
func (h *ShiftHandler) CloseShift(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	shiftID := strings.TrimSuffix(extractLastSegment(r.URL.Path), "/close")
	parts := strings.Split(strings.TrimPrefix(r.URL.Path, "/api/v1/shifts/"), "/")
	if len(parts) >= 1 {
		shiftID = parts[0]
	}

	var req struct {
		ClosingBalance float64 `json:"closing_balance"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	if err := h.repo.CloseShift(r.Context(), claims.TenantID, shiftID, req.ClosingBalance); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to close shift")
		return
	}

	summary, err := h.repo.GetShiftSummary(r.Context(), claims.TenantID, shiftID)
	if err != nil {
		apperrors.RespondJSON(w, http.StatusOK, map[string]string{"status": "closed"})
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]any{
		"status":  "closed",
		"summary": summary,
	})
}

// ListShifts handles GET /api/v1/shifts
func (h *ShiftHandler) ListShifts(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	shifts, err := h.repo.ListShifts(r.Context(), claims.TenantID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list shifts")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"shifts": shifts})
}

// GetShiftSummary handles GET /api/v1/shifts/:id/summary
func (h *ShiftHandler) GetShiftSummary(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	parts := strings.Split(strings.TrimPrefix(r.URL.Path, "/api/v1/shifts/"), "/")
	shiftID := parts[0]

	summary, err := h.repo.GetShiftSummary(r.Context(), claims.TenantID, shiftID)
	if err != nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "shift summary not found")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, summary)
}
