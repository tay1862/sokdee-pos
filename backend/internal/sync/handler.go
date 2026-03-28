package sync

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

// SyncOperation represents a single operation from a device
type SyncOperation struct {
	EntityType     string         `json:"entity_type"`
	EntityID       string         `json:"entity_id"`
	Operation      string         `json:"operation"` // create, update, delete
	Payload        map[string]any `json:"payload"`
	IdempotencyKey string         `json:"idempotency_key"`
}

// SyncConflict represents a detected conflict
type SyncConflict struct {
	EntityType  string         `json:"entity_type"`
	EntityID    string         `json:"entity_id"`
	LocalValue  map[string]any `json:"local_value"`
	ServerValue map[string]any `json:"server_value"`
}

// Repository defines data access for sync operations
type Repository interface {
	IsIdempotencyKeyUsed(ctx context.Context, key string) (bool, error)
	MarkIdempotencyKey(ctx context.Context, key, tenantID string) error
	ApplyOperation(ctx context.Context, tenantID string, op SyncOperation) error
	DetectConflict(ctx context.Context, tenantID string, op SyncOperation) (*SyncConflict, error)
	GetChangesSince(ctx context.Context, tenantID string, since time.Time, entities []string) (map[string]any, error)
	GetConflicts(ctx context.Context, tenantID string) ([]map[string]any, error)
	ResolveConflict(ctx context.Context, tenantID, conflictID, resolution, resolvedBy string, customValue *string) error
}

// Handler handles sync endpoints
type Handler struct{ repo Repository }

// NewHandler creates a new sync handler
func NewHandler(repo Repository) *Handler { return &Handler{repo: repo} }

// Push handles POST /api/v1/sync/push
func (h *Handler) Push(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())

	var body struct {
		Operations []SyncOperation `json:"operations"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	var synced []string
	var conflicts []SyncConflict

	for _, op := range body.Operations {
		// Idempotency check
		used, _ := h.repo.IsIdempotencyKeyUsed(r.Context(), op.IdempotencyKey)
		if used {
			synced = append(synced, op.IdempotencyKey) // already applied
			continue
		}

		// Conflict detection
		conflict, _ := h.repo.DetectConflict(r.Context(), claims.TenantID, op)
		if conflict != nil {
			conflicts = append(conflicts, *conflict)
			continue
		}

		// Apply operation
		if err := h.repo.ApplyOperation(r.Context(), claims.TenantID, op); err != nil {
			continue
		}

		_ = h.repo.MarkIdempotencyKey(r.Context(), op.IdempotencyKey, claims.TenantID)
		synced = append(synced, op.IdempotencyKey)
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]any{
		"synced":    synced,
		"conflicts": conflicts,
	})
}

// Pull handles GET /api/v1/sync/pull
func (h *Handler) Pull(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())

	sinceStr := r.URL.Query().Get("since")
	entitiesStr := r.URL.Query().Get("entities")

	var since time.Time
	if sinceStr != "" {
		since, _ = time.Parse(time.RFC3339, sinceStr)
	}

	entities := strings.Split(entitiesStr, ",")
	if len(entities) == 0 || entities[0] == "" {
		entities = []string{"products", "categories", "settings"}
	}

	data, err := h.repo.GetChangesSince(r.Context(), claims.TenantID, since, entities)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to pull changes")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, data)
}

// GetConflicts handles GET /api/v1/sync/conflicts
func (h *Handler) GetConflicts(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	conflicts, err := h.repo.GetConflicts(r.Context(), claims.TenantID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to get conflicts")
		return
	}
	apperrors.RespondJSON(w, http.StatusOK, map[string]any{"conflicts": conflicts})
}

// ResolveConflict handles POST /api/v1/sync/conflicts/:id/resolve
func (h *Handler) ResolveConflict(w http.ResponseWriter, r *http.Request) {
	claims, _ := auth.ClaimsFromContext(r.Context())
	parts := strings.Split(strings.TrimPrefix(r.URL.Path, "/api/v1/sync/conflicts/"), "/")
	conflictID := parts[0]

	var body struct {
		Resolution  string  `json:"resolution"`
		CustomValue *string `json:"custom_value"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	if err := h.repo.ResolveConflict(r.Context(), claims.TenantID, conflictID, body.Resolution, claims.Subject, body.CustomValue); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to resolve conflict")
		return
	}

	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"status": "resolved"})
}
