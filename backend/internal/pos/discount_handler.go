package pos

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// Discount represents a discount rule
type Discount struct {
	ID               string     `json:"id"`
	TenantID         string     `json:"tenant_id"`
	Name             string     `json:"name"`
	Type             string     `json:"type"`  // percentage, fixed
	Value            float64    `json:"value"`
	Scope            string     `json:"scope"` // item, order
	ProductID        *string    `json:"product_id"`
	StartsAt         *time.Time `json:"starts_at"`
	EndsAt           *time.Time `json:"ends_at"`
	IsActive         bool       `json:"is_active"`
	RequiresApproval bool       `json:"requires_approval"`
}

// DiscountRepository defines data access for discounts
type DiscountRepository interface {
	ListDiscounts(ctx context.Context, tenantID string, activeOnly bool) ([]*Discount, error)
	CreateDiscount(ctx context.Context, d *Discount) error
	UpdateDiscount(ctx context.Context, d *Discount) error
	GetActiveDiscountsForProduct(ctx context.Context, tenantID, productID string) ([]*Discount, error)
}

// DiscountHandler handles discount endpoints
type DiscountHandler struct{ repo DiscountRepository }

// NewDiscountHandler creates a new discount handler
func NewDiscountHandler(repo DiscountRepository) *DiscountHandler {
	return &DiscountHandler{repo: repo}
}

// ListDiscounts handles GET /api/v1/discounts
func (h *DiscountHandler) ListDiscounts(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	discounts, err := h.repo.ListDiscounts(r.Context(), claims.TenantID, false)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list discounts")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"discounts": discounts})
}

// CreateDiscount handles POST /api/v1/discounts
func (h *DiscountHandler) CreateDiscount(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	var d Discount
	if err := json.NewDecoder(r.Body).Decode(&d); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	d.TenantID = claims.TenantID
	if d.Name == "" || d.Value <= 0 {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "name and value are required")
		return
	}
	if err := h.repo.CreateDiscount(r.Context(), &d); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create discount")
		return
	}
	apperrors.RespondJSON(w, http.StatusCreated, d)
}

// UpdateDiscount handles PATCH /api/v1/discounts/:id
func (h *DiscountHandler) UpdateDiscount(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	id := extractLastSegment(r.URL.Path)
	var d Discount
	if err := json.NewDecoder(r.Body).Decode(&d); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	d.ID = id
	d.TenantID = claims.TenantID
	if err := h.repo.UpdateDiscount(r.Context(), &d); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to update discount")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, d)
}
