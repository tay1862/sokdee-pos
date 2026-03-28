package tenant

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"

	apperrors "github.com/sokdee/pos-backend/pkg/errors"
	"github.com/sokdee/pos-backend/pkg/models"
)

// PlanRepository defines data access for subscription plans
type PlanRepository interface {
	ListPlans(ctx context.Context) ([]*models.SubscriptionPlan, error)
	GetPlan(ctx context.Context, id string) (*models.SubscriptionPlan, error)
	CreatePlan(ctx context.Context, plan *models.SubscriptionPlan) error
	UpdatePlan(ctx context.Context, plan *models.SubscriptionPlan) error
}

// PlanHandler handles subscription plan endpoints
type PlanHandler struct {
	repo PlanRepository
}

// NewPlanHandler creates a new plan handler
func NewPlanHandler(repo PlanRepository) *PlanHandler {
	return &PlanHandler{repo: repo}
}

// ListPlans handles GET /api/v1/admin/plans
func (h *PlanHandler) ListPlans(w http.ResponseWriter, r *http.Request) {
	plans, err := h.repo.ListPlans(r.Context())
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list plans")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"plans": plans})
}

// CreatePlan handles POST /api/v1/admin/plans
func (h *PlanHandler) CreatePlan(w http.ResponseWriter, r *http.Request) {
	var plan models.SubscriptionPlan
	if err := json.NewDecoder(r.Body).Decode(&plan); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	if plan.Name == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "plan name is required")
		return
	}

	if err := h.repo.CreatePlan(r.Context(), &plan); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create plan")
		return
	}

	apperrors.RespondJSON(w, http.StatusCreated, plan)
}

// UpdatePlan handles PATCH /api/v1/admin/plans/:id
func (h *PlanHandler) UpdatePlan(w http.ResponseWriter, r *http.Request) {
	id := strings.TrimPrefix(r.URL.Path, "/api/v1/admin/plans/")
	if id == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "plan id is required")
		return
	}

	existing, err := h.repo.GetPlan(r.Context(), id)
	if err != nil || existing == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "plan not found")
		return
	}

	if err := json.NewDecoder(r.Body).Decode(existing); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	existing.ID = id

	if err := h.repo.UpdatePlan(r.Context(), existing); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to update plan")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, existing)
}
