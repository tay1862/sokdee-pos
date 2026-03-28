package middleware

import (
	"context"
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/sokdee/pos-backend/internal/auth"
	apperrors "github.com/sokdee/pos-backend/pkg/errors"
)

type tenantContextKey string

const dbConnKey tenantContextKey = "tenant_db_conn"

// TenantIsolation sets the PostgreSQL session variable `app.current_tenant`
// so that Row-Level Security policies filter data to the authenticated tenant.
func TenantIsolation(pool *pgxpool.Pool) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			claims, ok := auth.ClaimsFromContext(r.Context())
			if !ok {
				apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "unauthorized")
				return
			}

			// Acquire a dedicated connection for this request so we can set
			// the session-level variable without affecting other requests.
			conn, err := pool.Acquire(r.Context())
			if err != nil {
				apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "database unavailable")
				return
			}
			defer conn.Release()

			_, err = conn.Exec(r.Context(),
				"SELECT set_config('app.current_tenant', $1, TRUE)",
				claims.TenantID,
			)
			if err != nil {
				apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to set tenant context")
				return
			}

			// Store the scoped connection in context so handlers can use it
			ctx := context.WithValue(r.Context(), dbConnKey, conn)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// PlanFeatureGate rejects requests if the tenant's plan does not include the feature
func PlanFeatureGate(feature string, getPlan func(ctx context.Context, tenantID string) ([]string, error)) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			claims, ok := auth.ClaimsFromContext(r.Context())
			if !ok {
				apperrors.RespondError(w, http.StatusUnauthorized, apperrors.ErrUnauthorized, "unauthorized")
				return
			}

			features, err := getPlan(r.Context(), claims.TenantID)
			if err != nil {
				apperrors.RespondError(w, http.StatusInternalServerError, apperrors.ErrInternal, "failed to check plan")
				return
			}

			for _, f := range features {
				if f == feature {
					next.ServeHTTP(w, r)
					return
				}
			}

			apperrors.RespondError(w, http.StatusForbidden, "feature_not_available",
				"upgrade your plan to access this feature",
				map[string]any{"feature": feature})
		})
	}
}
