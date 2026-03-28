package middleware

import (
	"net/http"
	"strings"

	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
	"github.com/sokdee/pos-backend/pkg/models"
)

// Authenticate validates the Bearer JWT and injects claims into context
func Authenticate(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		header := r.Header.Get("Authorization")
		if header == "" || !strings.HasPrefix(header, "Bearer ") {
			apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "missing authorization header")
			return
		}

		tokenStr := strings.TrimPrefix(header, "Bearer ")
		claims, err := auth.ParseAccessToken(tokenStr)
		if err != nil {
			apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "invalid or expired token")
			return
		}

		ctx := auth.WithClaims(r.Context(), claims)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// RequireRole rejects requests where the user's role level is below the minimum
func RequireRole(minRole string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			claims, ok := auth.ClaimsFromContext(r.Context())
			if !ok {
				apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "unauthorized")
				return
			}

			if models.RoleLevel(claims.Role) < models.RoleLevel(minRole) {
				apperrors.RespondError(w, http.StatusForbidden, apperrors.ErrForbidden,
					"insufficient permissions",
					map[string]any{
						"required_role": minRole,
						"current_role":  claims.Role,
					})
				return
			}

			next.ServeHTTP(w, r)
		})
	}
}

// RequireSuperAdmin is a convenience wrapper for super_admin only routes
func RequireSuperAdmin(next http.Handler) http.Handler {
	return RequireRole(models.RoleSuperAdmin)(next)
}
