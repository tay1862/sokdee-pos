package tenant

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	apperrors "github.com/sokdee/pos-backend/pkg/errors"
	"github.com/sokdee/pos-backend/pkg/models"
)

// TenantRepository defines data access for tenants
type TenantRepository interface {
	ListTenants(ctx context.Context) ([]*TenantSummary, error)
	GetTenant(ctx context.Context, id string) (*models.Tenant, error)
	CreateTenant(ctx context.Context, req CreateTenantRequest) (*models.Tenant, *OwnerCredentials, error)
	UpdateTenant(ctx context.Context, id string, updates map[string]any) (*models.Tenant, error)
	SetTenantStatus(ctx context.Context, id, status string) error
	GetPlan(ctx context.Context, id string) (*models.SubscriptionPlan, error)
}

// TenantSummary is a lightweight tenant view for listing
type TenantSummary struct {
	ID          string     `json:"id"`
	Name        string     `json:"name"`
	StoreType   string     `json:"store_type"`
	PlanName    string     `json:"plan_name"`
	Status      string     `json:"status"`
	ExpiresAt   *time.Time `json:"expires_at"`
	UserCount   int        `json:"user_count"`
}

// CreateTenantRequest holds wizard input for creating a new tenant
type CreateTenantRequest struct {
	Name           string  `json:"name"`
	StoreType      string  `json:"store_type"`
	PlanID         string  `json:"plan_id"`
	MaxEmployees   int     `json:"max_employees"`
	TableCount     int     `json:"table_count"`      // restaurant only
	EnableKDS      bool    `json:"enable_kds"`       // restaurant only
	DefaultLang    string  `json:"default_lang"`
	BaseCurrency   string  `json:"base_currency"`
	ExpiresAt      *time.Time `json:"expires_at"`
}

// OwnerCredentials are returned after tenant creation
type OwnerCredentials struct {
	TenantID string `json:"tenant_id"`
	Username string `json:"username"`
	PIN      string `json:"pin"` // plain PIN shown once
}

// TenantHandler handles tenant management endpoints
type TenantHandler struct {
	repo TenantRepository
}

// NewTenantHandler creates a new tenant handler
func NewTenantHandler(repo TenantRepository) *TenantHandler {
	return &TenantHandler{repo: repo}
}

// ListTenants handles GET /api/v1/admin/tenants
func (h *TenantHandler) ListTenants(w http.ResponseWriter, r *http.Request) {
	tenants, err := h.repo.ListTenants(r.Context())
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list tenants")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"tenants": tenants})
}

// CreateTenant handles POST /api/v1/admin/tenants
func (h *TenantHandler) CreateTenant(w http.ResponseWriter, r *http.Request) {
	var req CreateTenantRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	if req.Name == "" || req.StoreType == "" || req.PlanID == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "name, store_type, and plan_id are required")
		return
	}

	if req.DefaultLang == "" {
		req.DefaultLang = "lo"
	}
	if req.BaseCurrency == "" {
		req.BaseCurrency = models.CurrencyLAK
	}

	tenant, creds, err := h.repo.CreateTenant(r.Context(), req)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create tenant")
		return
	}

	apperrors.RespondJSON(w, http.StatusCreated, map[string]any{
		"tenant":      tenant,
		"credentials": creds,
	})
}

// GetTenant handles GET /api/v1/admin/tenants/:id
func (h *TenantHandler) GetTenant(w http.ResponseWriter, r *http.Request) {
	id := extractID(r.URL.Path, "/api/v1/admin/tenants/")
	tenant, err := h.repo.GetTenant(r.Context(), id)
	if err != nil || tenant == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "tenant not found")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, tenant)
}

// UpdateTenant handles PATCH /api/v1/admin/tenants/:id
func (h *TenantHandler) UpdateTenant(w http.ResponseWriter, r *http.Request) {
	id := extractID(r.URL.Path, "/api/v1/admin/tenants/")

	var updates map[string]any
	if err := json.NewDecoder(r.Body).Decode(&updates); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	tenant, err := h.repo.UpdateTenant(r.Context(), id, updates)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to update tenant")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, tenant)
}

// SuspendTenant handles PATCH /api/v1/admin/tenants/:id/suspend
func (h *TenantHandler) SuspendTenant(w http.ResponseWriter, r *http.Request) {
	id := extractID(r.URL.Path, "/api/v1/admin/tenants/")
	id = strings.TrimSuffix(id, "/suspend")

	if err := h.repo.SetTenantStatus(r.Context(), id, "suspended"); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to suspend tenant")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"status": "suspended"})
}

// ActivateTenant handles PATCH /api/v1/admin/tenants/:id/activate
func (h *TenantHandler) ActivateTenant(w http.ResponseWriter, r *http.Request) {
	id := extractID(r.URL.Path, "/api/v1/admin/tenants/")
	id = strings.TrimSuffix(id, "/activate")

	if err := h.repo.SetTenantStatus(r.Context(), id, "active"); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to activate tenant")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"status": "active"})
}

func extractID(path, prefix string) string {
	return strings.TrimPrefix(path, prefix)
}
