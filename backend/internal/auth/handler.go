package auth

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	apperrors "github.com/sokdee/pos-backend/pkg/errors"
	"github.com/sokdee/pos-backend/pkg/models"
)

// Repository defines the data access interface for auth
type Repository interface {
	GetUserByUsername(ctx context.Context, tenantID, username string) (*UserRecord, error)
	GetUserByID(ctx context.Context, userID string) (*UserRecord, error)
	IncrementFailedAttempts(ctx context.Context, userID string) error
	ResetFailedAttempts(ctx context.Context, userID string) error
	LockUser(ctx context.Context, userID string, until time.Time) error
	GetTenantByID(ctx context.Context, tenantID string) (*models.Tenant, error)
	StoreRefreshToken(ctx context.Context, userID, token string, expiresAt time.Time) error
	RevokeRefreshToken(ctx context.Context, token string) error
	IsRefreshTokenValid(ctx context.Context, token string) (bool, error)
	RegisterDevice(ctx context.Context, reg DeviceRegistration) error
	RevokeDevice(ctx context.Context, tenantID, deviceID string) error
	IsDeviceRegistered(ctx context.Context, tenantID, deviceID string) (bool, error)
	CreateAuditLog(ctx context.Context, log AuditEntry) error
}

// UserRecord is the DB representation of a user for auth purposes
type UserRecord struct {
	ID                string
	TenantID          string
	Username          string
	DisplayName       string
	Role              string
	PINHash           string
	IsActive          bool
	FailedPINAttempts int
	LockedUntil       *time.Time
}

// DeviceRegistration holds device info for registration
type DeviceRegistration struct {
	TenantID   string
	UserID     string
	DeviceID   string
	DeviceName string
	OSVersion  string
}

// AuditEntry represents an audit log record
type AuditEntry struct {
	TenantID   string
	UserID     string
	Action     string
	EntityType string
	EntityID   string
	Details    map[string]any
	IPAddress  string
	DeviceID   string
}

// Handler handles auth HTTP endpoints
type Handler struct {
	repo Repository
}

// NewHandler creates a new auth handler
func NewHandler(repo Repository) *Handler {
	return &Handler{repo: repo}
}

// ─── Request/Response types ───────────────────────────────────────────────────

type loginRequest struct {
	TenantID string `json:"tenant_id"`
	Username string `json:"username"`
	PIN      string `json:"pin"`
	DeviceID string `json:"device_id"`
}

type refreshRequest struct {
	RefreshToken string `json:"refresh_token"`
}

type logoutRequest struct {
	RefreshToken string `json:"refresh_token"`
}

type registerDeviceRequest struct {
	DeviceID   string `json:"device_id"`
	DeviceName string `json:"device_name"`
	OSVersion  string `json:"os_version"`
}

// ─── Login ────────────────────────────────────────────────────────────────────

// Login handles POST /api/v1/auth/login
func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	var req loginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	if req.TenantID == "" || req.Username == "" || req.PIN == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "tenant_id, username, and pin are required")
		return
	}

	ctx := r.Context()

	// Check tenant status
	tenant, err := h.repo.GetTenantByID(ctx, req.TenantID)
	if err != nil || tenant == nil {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "invalid credentials")
		return
	}
	if tenant.Status == "suspended" {
		apperrors.RespondError(w, http.StatusForbidden, apperrors.ErrTenantSuspended, "tenant account is suspended")
		return
	}
	if tenant.ExpiresAt != nil && tenant.ExpiresAt.Before(time.Now()) {
		apperrors.RespondError(w, http.StatusForbidden, apperrors.ErrTenantExpired, "subscription has expired")
		return
	}

	// Get user
	user, err := h.repo.GetUserByUsername(ctx, req.TenantID, req.Username)
	if err != nil || user == nil || !user.IsActive {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "invalid credentials")
		return
	}

	// Check lockout
	if user.LockedUntil != nil && user.LockedUntil.After(time.Now()) {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrAccountLocked,
			"account is locked, try again later",
			map[string]any{"locked_until": user.LockedUntil})
		return
	}

	// Verify PIN
	if !VerifyPIN(req.PIN, user.PINHash) {
		_ = h.repo.IncrementFailedAttempts(ctx, user.ID)
		newAttempts := user.FailedPINAttempts + 1
		if newAttempts >= 5 {
			lockUntil := time.Now().Add(15 * time.Minute)
			_ = h.repo.LockUser(ctx, user.ID, lockUntil)
		}
		_ = h.repo.CreateAuditLog(ctx, AuditEntry{
			TenantID: req.TenantID,
			UserID:   user.ID,
			Action:   "user.login_failed",
			IPAddress: r.RemoteAddr,
			DeviceID: req.DeviceID,
		})
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrInvalidPIN, "invalid PIN")
		return
	}

	// Reset failed attempts on success
	_ = h.repo.ResetFailedAttempts(ctx, user.ID)

	// Check device registration
	if req.DeviceID != "" {
		registered, _ := h.repo.IsDeviceRegistered(ctx, req.TenantID, req.DeviceID)
		if !registered {
			// Auto-register on first login
			_ = h.repo.RegisterDevice(ctx, DeviceRegistration{
				TenantID: req.TenantID,
				UserID:   user.ID,
				DeviceID: req.DeviceID,
			})
			_ = h.repo.CreateAuditLog(ctx, AuditEntry{
				TenantID:   req.TenantID,
				UserID:     user.ID,
				Action:     "device.registered",
				EntityType: "device",
				EntityID:   req.DeviceID,
				IPAddress:  r.RemoteAddr,
				DeviceID:   req.DeviceID,
			})
		}
	}

	// Generate tokens
	pair, err := GenerateTokenPair(user.ID, user.TenantID, user.Role, req.DeviceID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to generate tokens")
		return
	}

	// Store refresh token
	_ = h.repo.StoreRefreshToken(ctx, user.ID, pair.RefreshToken, time.Now().Add(refreshTokenTTL))

	_ = h.repo.CreateAuditLog(ctx, AuditEntry{
		TenantID:  req.TenantID,
		UserID:    user.ID,
		Action:    "user.login",
		IPAddress: r.RemoteAddr,
		DeviceID:  req.DeviceID,
	})

	apperrors.RespondJSON(w, http.StatusOK, pair)
}

// ─── Refresh ──────────────────────────────────────────────────────────────────

// Refresh handles POST /api/v1/auth/refresh
func (h *Handler) Refresh(w http.ResponseWriter, r *http.Request) {
	var req refreshRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	claims, err := ParseRefreshToken(req.RefreshToken)
	if err != nil {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "invalid refresh token")
		return
	}

	ctx := r.Context()

	valid, err := h.repo.IsRefreshTokenValid(ctx, req.RefreshToken)
	if err != nil || !valid {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrTokenRevoked, "refresh token has been revoked")
		return
	}

	// Revoke old refresh token (rotation)
	_ = h.repo.RevokeRefreshToken(ctx, req.RefreshToken)

	// Issue new pair
	pair, err := GenerateTokenPair(claims.Subject, claims.TenantID, claims.Role, claims.DeviceID)
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to generate tokens")
		return
	}

	_ = h.repo.StoreRefreshToken(ctx, claims.Subject, pair.RefreshToken, time.Now().Add(refreshTokenTTL))

	apperrors.RespondJSON(w, http.StatusOK, pair)
}

// ─── Logout ───────────────────────────────────────────────────────────────────

// Logout handles POST /api/v1/auth/logout
func (h *Handler) Logout(w http.ResponseWriter, r *http.Request) {
	var req logoutRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	_ = h.repo.RevokeRefreshToken(r.Context(), req.RefreshToken)
	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"message": "logged out"})
}

// ─── Device Registration ──────────────────────────────────────────────────────

// RegisterDevice handles POST /api/v1/auth/device/register
func (h *Handler) RegisterDevice(w http.ResponseWriter, r *http.Request) {
	claims, ok := ClaimsFromContext(r.Context())
	if !ok {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "unauthorized")
		return
	}

	var req registerDeviceRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "invalid request body")
		return
	}

	err := h.repo.RegisterDevice(r.Context(), DeviceRegistration{
		TenantID:   claims.TenantID,
		UserID:     claims.Subject,
		DeviceID:   req.DeviceID,
		DeviceName: req.DeviceName,
		OSVersion:  req.OSVersion,
	})
	if err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to register device")
		return
	}

	_ = h.repo.CreateAuditLog(r.Context(), AuditEntry{
		TenantID:   claims.TenantID,
		UserID:     claims.Subject,
		Action:     "device.registered",
		EntityType: "device",
		EntityID:   req.DeviceID,
		IPAddress:  r.RemoteAddr,
		DeviceID:   req.DeviceID,
	})

	apperrors.RespondJSON(w, http.StatusCreated, map[string]string{"message": "device registered"})
}

// RevokeDevice handles DELETE /api/v1/auth/device/:deviceId
func (h *Handler) RevokeDevice(w http.ResponseWriter, r *http.Request) {
	claims, ok := ClaimsFromContext(r.Context())
	if !ok {
		apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "unauthorized")
		return
	}

	// Extract deviceId from URL path
	deviceID := strings.TrimPrefix(r.URL.Path, "/api/v1/auth/device/")
	if deviceID == "" {
		apperrors.RespondError(w, http.StatusBadRequest, apperrors.ErrValidation, "device_id is required")
		return
	}

	if err := h.repo.RevokeDevice(r.Context(), claims.TenantID, deviceID); err != nil {
		apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to revoke device")
		return
	}

	_ = h.repo.CreateAuditLog(r.Context(), AuditEntry{
		TenantID:   claims.TenantID,
		UserID:     claims.Subject,
		Action:     "device.revoked",
		EntityType: "device",
		EntityID:   deviceID,
		IPAddress:  r.RemoteAddr,
	})

	apperrors.RespondJSON(w, http.StatusOK, map[string]string{"message": "device revoked"})
}
