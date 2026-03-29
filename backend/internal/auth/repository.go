package auth

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/sokdee/pos-backend/pkg/models"
)

// PgRepository implements Repository using PostgreSQL
type PgRepository struct{ db *pgxpool.Pool }

// NewPgRepository creates a new PostgreSQL auth repository
func NewPgRepository(db *pgxpool.Pool) *PgRepository { return &PgRepository{db: db} }

func (r *PgRepository) GetUserByUsername(ctx context.Context, tenantID, username string) (*UserRecord, error) {
	var u UserRecord
	err := r.db.QueryRow(ctx,
		`SELECT id, tenant_id, username, display_name, role, pin_hash,
		        is_active, failed_pin_attempts, locked_until
		 FROM users WHERE tenant_id=$1 AND username=$2 AND is_active=true`,
		tenantID, username,
	).Scan(&u.ID, &u.TenantID, &u.Username, &u.DisplayName, &u.Role,
		&u.PINHash, &u.IsActive, &u.FailedPINAttempts, &u.LockedUntil)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &u, err
}

func (r *PgRepository) GetUserByID(ctx context.Context, userID string) (*UserRecord, error) {
	var u UserRecord
	err := r.db.QueryRow(ctx,
		`SELECT id, tenant_id, username, display_name, role, pin_hash,
		        is_active, failed_pin_attempts, locked_until
		 FROM users WHERE id=$1`,
		userID,
	).Scan(&u.ID, &u.TenantID, &u.Username, &u.DisplayName, &u.Role,
		&u.PINHash, &u.IsActive, &u.FailedPINAttempts, &u.LockedUntil)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &u, err
}

func (r *PgRepository) IncrementFailedAttempts(ctx context.Context, userID string) error {
	_, err := r.db.Exec(ctx,
		`UPDATE users SET failed_pin_attempts = failed_pin_attempts + 1 WHERE id=$1`,
		userID)
	return err
}

func (r *PgRepository) ResetFailedAttempts(ctx context.Context, userID string) error {
	_, err := r.db.Exec(ctx,
		`UPDATE users SET failed_pin_attempts=0, locked_until=NULL WHERE id=$1`,
		userID)
	return err
}

func (r *PgRepository) LockUser(ctx context.Context, userID string, until time.Time) error {
	_, err := r.db.Exec(ctx,
		`UPDATE users SET locked_until=$1 WHERE id=$2`,
		until, userID)
	return err
}

func (r *PgRepository) GetTenantByID(ctx context.Context, tenantID string) (*models.Tenant, error) {
	var t models.Tenant
	var expiresAt *time.Time
	err := r.db.QueryRow(ctx,
		`SELECT id, status, expires_at FROM tenants WHERE id=$1`,
		tenantID,
	).Scan(&t.ID, &t.Status, &expiresAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	t.ExpiresAt = expiresAt
	return &t, err
}

func (r *PgRepository) StoreRefreshToken(ctx context.Context, userID, token string, expiresAt time.Time) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO refresh_tokens (user_id, token, expires_at)
		 VALUES ($1, $2, $3)
		 ON CONFLICT (token) DO NOTHING`,
		userID, token, expiresAt)
	return err
}

func (r *PgRepository) RevokeRefreshToken(ctx context.Context, token string) error {
	_, err := r.db.Exec(ctx, `DELETE FROM refresh_tokens WHERE token=$1`, token)
	return err
}

func (r *PgRepository) IsRefreshTokenValid(ctx context.Context, token string) (bool, error) {
	var count int
	err := r.db.QueryRow(ctx,
		`SELECT COUNT(*) FROM refresh_tokens WHERE token=$1 AND expires_at > NOW()`,
		token,
	).Scan(&count)
	return count > 0, err
}

func (r *PgRepository) RegisterDevice(ctx context.Context, reg DeviceRegistration) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO device_registrations (tenant_id, user_id, device_id, device_name, os_version)
		 VALUES ($1, $2, $3, $4, $5)
		 ON CONFLICT (tenant_id, device_id) DO UPDATE
		   SET last_seen_at=NOW(), is_revoked=false`,
		reg.TenantID, reg.UserID, reg.DeviceID, reg.DeviceName, reg.OSVersion)
	return err
}

func (r *PgRepository) RevokeDevice(ctx context.Context, tenantID, deviceID string) error {
	_, err := r.db.Exec(ctx,
		`UPDATE device_registrations SET is_revoked=true
		 WHERE tenant_id=$1 AND device_id=$2`,
		tenantID, deviceID)
	return err
}

func (r *PgRepository) IsDeviceRegistered(ctx context.Context, tenantID, deviceID string) (bool, error) {
	var count int
	err := r.db.QueryRow(ctx,
		`SELECT COUNT(*) FROM device_registrations
		 WHERE tenant_id=$1 AND device_id=$2 AND is_revoked=false`,
		tenantID, deviceID,
	).Scan(&count)
	return count > 0, err
}

func (r *PgRepository) CreateAuditLog(ctx context.Context, entry AuditEntry) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO audit_logs (tenant_id, user_id, action, entity_type, entity_id, details, ip_address, device_id)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
		nilIfEmpty(entry.TenantID), nilIfEmpty(entry.UserID),
		entry.Action, nilIfEmpty(entry.EntityType), nilIfEmpty(entry.EntityID),
		entry.Details, entry.IPAddress, entry.DeviceID)
	return err
}

func nilIfEmpty(s string) interface{} {
	if s == "" {
		return nil
	}
	return s
}
