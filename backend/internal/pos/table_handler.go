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

// RestaurantTable represents a dining table
type RestaurantTable struct {
	ID          string     `json:"id"`
	TenantID    string     `json:"tenant_id"`
	Zone        *string    `json:"zone"`
	TableNumber string     `json:"table_number"`
	Capacity    *int       `json:"capacity"`
	Status      string     `json:"status"` // available, occupied, waiting_payment
	OpenedAt    *time.Time `json:"opened_at"`
	ActiveOrder *string    `json:"active_order_id,omitempty"`
}

// TableRepository defines data access for table management
type TableRepository interface {
	ListTables(ctx context.Context, tenantID string) ([]*RestaurantTable, error)
	GetTable(ctx context.Context, tenantID, id string) (*RestaurantTable, error)
	CreateTable(ctx context.Context, t *RestaurantTable) error
	UpdateTable(ctx context.Context, t *RestaurantTable) error
	SetTableStatus(ctx context.Context, tenantID, id, status string, openedAt *time.Time) error
	MergeTables(ctx context.Context, tenantID string, tableIDs []string, targetOrderID string) error
	MoveOrder(ctx context.Context, tenantID, fromTableID, toTableID, approvedBy string) error
}

// TableHandler handles restaurant table endpoints
type TableHandler struct {
	repo TableRepository
}

// NewTableHandler creates a new table handler
func NewTableHandler(repo TableRepository) *TableHandler {
	return &TableHandler{repo: repo}
}

// ListTables handles GET /api/v1/tables
func (h *TableHandler) ListTables(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	tables, err := h.repo.ListTables(r.Context(), claims.TenantID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to list tables")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"tables": tables})
}

// CreateTable handles POST /api/v1/tables
func (h *TableHandler) CreateTable(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	var t RestaurantTable
	if err := json.NewDecoder(r.Body).Decode(&t); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	t.TenantID = claims.TenantID
	t.Status = "available"
	if t.TableNumber == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "table_number is required")
		return
	}
	if err := h.repo.CreateTable(r.Context(), &t); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to create table")
		return
	}
	apperrors.RespondJSON(w, http.StatusCreated, t)
}

// UpdateTable handles PATCH /api/v1/tables/:id
func (h *TableHandler) UpdateTable(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	id := extractLastSegment(r.URL.Path)

	existing, err := h.repo.GetTable(r.Context(), claims.TenantID, id)
	if err != nil || existing == nil {
		apperrors.RespondError(w, http.StatusNotFound, apperrors.ErrNotFound, "table not found")
		return
	}
	if err := json.NewDecoder(r.Body).Decode(existing); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	existing.ID = id
	existing.TenantID = claims.TenantID
	if err := h.repo.UpdateTable(r.Context(), existing); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to update table")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, existing)
}

// MergeTables handles POST /api/v1/tables/merge
func (h *TableHandler) MergeTables(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	var req struct {
		TableIDs      []string `json:"table_ids"`
		TargetOrderID string   `json:"target_order_id"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	if len(req.TableIDs) < 2 {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "at least 2 tables required to merge")
		return
	}
	if err := h.repo.MergeTables(r.Context(), claims.TenantID, req.TableIDs, req.TargetOrderID); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to merge tables")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"message": "tables merged"})
}

// MoveOrder handles POST /api/v1/tables/:id/move
func (h *TableHandler) MoveOrder(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	fromTableID := strings.TrimSuffix(extractLastSegment(r.URL.Path), "/move")
	// Re-extract properly
	parts := strings.Split(strings.TrimPrefix(r.URL.Path, "/api/v1/tables/"), "/")
	if len(parts) >= 1 {
		fromTableID = parts[0]
	}

	var req struct {
		ToTableID  string `json:"to_table_id"`
		ApprovedBy string `json:"approved_by"` // Manager user ID
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}
	if req.ToTableID == "" || req.ApprovedBy == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "to_table_id and approved_by are required")
		return
	}
	if err := h.repo.MoveOrder(r.Context(), claims.TenantID, fromTableID, req.ToTableID, req.ApprovedBy); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to move order")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"message": "order moved"})
}
