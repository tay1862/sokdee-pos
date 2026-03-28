package notifications

import (
	"context"
	"net/http"
	"time"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// Notification represents an in-app notification
type Notification struct {
	ID        string    `json:"id"`
	TenantID  string    `json:"tenant_id"`
	UserRole  string    `json:"user_role"`
	Title     string    `json:"title"`
	Body      string    `json:"body"`
	IsRead    bool      `json:"is_read"`
	CreatedAt time.Time `json:"created_at"`
}

// Repository defines data access for notifications
type Repository interface {
	ListNotifications(ctx context.Context, tenantID, userRole string) ([]*Notification, error)
	MarkRead(ctx context.Context, tenantID, id string) error
	CreateNotification(ctx context.Context, tenantID, userRole, title, body string) error
	CheckExpiringSubscriptions(ctx context.Context) error
}

// Handler handles notification endpoints
type Handler struct{ repo Repository }

// NewHandler creates a new notifications handler
func NewHandler(repo Repository) *Handler { return &Handler{repo: repo} }

// ListNotifications handles GET /api/v1/notifications
func (h *Handler) ListNotifications(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	notifs, err := h.repo.ListNotifications(r.Context(), claims.TenantID, claims.Role)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list notifications")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"notifications": notifs})
}

// MarkRead handles PATCH /api/v1/notifications/:id/read
func (h *Handler) MarkRead(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	id := r.URL.Query().Get("id")
	if id == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "id is required")
		return
	}
	if err := h.repo.MarkRead(r.Context(), claims.TenantID, id); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to mark notification as read")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"status": "read"})
}
