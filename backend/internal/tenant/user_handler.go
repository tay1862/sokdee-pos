package tenant

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
	"github.com/sokdee/pos-backend/pkg/models"
)

// UserRepository defines data access for user management
type UserRepository interface {
	ListUsers(ctx context.Context, tenantID string) ([]*models.User, error)
	GetUser(ctx context.Context, id string) (*models.User, error)
	CreateUser(ctx context.Context, user CreateUserRequest) (*models.User, error)
	UpdateUser(ctx context.Context, id string, updates map[string]any) (*models.User, error)
	DeactivateUser(ctx context.Context, id string) error
	UpdatePIN(ctx context.Context, id, pinHash string) error
	CountActiveUsers(ctx context.Context, tenantID string) (int, error)
	GetTenantPlan(ctx context.Context, tenantID string) (*models.SubscriptionPlan, error)
}

// CreateUserRequest holds data for creating a new user
type CreateUserRequest struct {
	TenantID    string `json:"tenant_id"`
	Username    string `json:"username"`
	DisplayName string `json:"display_name"`
	Role        string `json:"role"`
	PIN         string `json:"pin"`
}

// UserHandler handles user management endpoints
type UserHandler struct {
	repo UserRepository
}

// NewUserHandler creates a new user handler
func NewUserHandler(repo UserRepository) *UserHandler {
	return &UserHandler{repo: repo}
}

// ListUsers handles GET /api/v1/users
func (h *UserHandler) ListUsers(w http.ResponseWriter, r *http.Request) {
	claims, ok := auth.ClaimsFromContext(r.Context())
	if !ok {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "unauthorized")
		return
	}

	users, err := h.repo.ListUsers(r.Context(), claims.TenantID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list users")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"users": users})
}

// CreateUser handles POST /api/v1/users
func (h *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
	claims, ok := auth.ClaimsFromContext(r.Context())
	if !ok {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "unauthorized")
		return
	}

	var req CreateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	req.TenantID = claims.TenantID

	if req.Username == "" || req.DisplayName == "" || req.Role == "" || req.PIN == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "username, display_name, role, and pin are required")
		return
	}

	// Validate PIN format
	if err := auth.ValidatePIN(req.PIN); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, err.Error())
		return
	}

	// Check plan user limit
	plan, err := h.repo.GetTenantPlan(r.Context(), claims.TenantID)
	if err == nil && plan != nil && plan.MaxUsers != nil {
		count, _ := h.repo.CountActiveUsers(r.Context(), claims.TenantID)
		if count >= *plan.MaxUsers {
			apperrors.RespondError(w, http.StatusConflict, apperrors.ErrPlanLimitExceeded,
				"cannot add more users, plan limit reached",
				map[string]any{
					"current_count": count,
					"max_allowed":   *plan.MaxUsers,
					"plan":          plan.Name,
				})
			return
		}
	}

	user, err := h.repo.CreateUser(r.Context(), req)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create user")
		return
	}

	apperrors.RespondJSON(w, http.StatusCreated, user)
}

// UpdateUser handles PATCH /api/v1/users/:id
func (h *UserHandler) UpdateUser(w http.ResponseWriter, r *http.Request) {
	id := extractUserID(r.URL.Path)

	var updates map[string]any
	if err := json.NewDecoder(r.Body).Decode(&updates); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	// Prevent PIN update through this endpoint
	delete(updates, "pin")
	delete(updates, "pin_hash")

	user, err := h.repo.UpdateUser(r.Context(), id, updates)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to update user")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, user)
}

// DeactivateUser handles DELETE /api/v1/users/:id
func (h *UserHandler) DeactivateUser(w http.ResponseWriter, r *http.Request) {
	id := extractUserID(r.URL.Path)

	if err := h.repo.DeactivateUser(r.Context(), id); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to deactivate user")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"message": "user deactivated"})
}

// ChangePIN handles PATCH /api/v1/users/:id/pin
func (h *UserHandler) ChangePIN(w http.ResponseWriter, r *http.Request) {
	id := strings.TrimSuffix(extractUserID(r.URL.Path), "/pin")

	var body struct {
		PIN string `json:"pin"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	if err := auth.ValidatePIN(body.PIN); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, err.Error())
		return
	}

	hash, err := auth.HashPIN(body.PIN)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to hash PIN")
		return
	}

	if err := h.repo.UpdatePIN(r.Context(), id, hash); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to update PIN")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"message": "PIN updated"})
}

func extractUserID(path string) string {
	parts := strings.Split(strings.TrimPrefix(path, "/api/v1/users/"), "/")
	return parts[0]
}
