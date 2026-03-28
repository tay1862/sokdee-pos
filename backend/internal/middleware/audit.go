package middleware

import (
	"context"
	"net/http"

	"github.com/sokdee/pos-backend/internal/auth"
)

// AuditLogger defines the interface for writing audit log entries
type AuditLogger interface {
	Log(ctx context.Context, entry AuditLogEntry) error
}

// AuditLogEntry represents a single audit event
type AuditLogEntry struct {
	TenantID   string
	UserID     string
	Action     string
	EntityType string
	EntityID   string
	Details    map[string]any
	IPAddress  string
	DeviceID   string
}

// AuditAction wraps a handler and writes an audit log entry after it completes
func AuditAction(logger AuditLogger, action, entityType string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			next.ServeHTTP(w, r)

			claims, ok := auth.ClaimsFromContext(r.Context())
			if !ok {
				return
			}

			_ = logger.Log(r.Context(), AuditLogEntry{
				TenantID:   claims.TenantID,
				UserID:     claims.Subject,
				Action:     action,
				EntityType: entityType,
				IPAddress:  r.RemoteAddr,
				DeviceID:   claims.DeviceID,
			})
		})
	}
}

// AuditableActions lists all actions that must be logged per requirements 14.5
var AuditableActions = []string{
	"user.login",
	"user.login_failed",
	"user.locked",
	"order.void",
	"order.refund",
	"stock.adjust",
	"product.price_change",
	"shift.open",
	"shift.close",
	"device.registered",
	"device.revoked",
	"settings.exchange_rate",
}
