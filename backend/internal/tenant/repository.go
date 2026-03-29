package tenant

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/sokdee/pos-backend/internal/auth"
	"github.com/sokdee/pos-backend/pkg/models"
)

// PgPlanRepository implements PlanRepository
type PgPlanRepository struct{ db *pgxpool.Pool }

func NewPgPlanRepository(db *pgxpool.Pool) *PgPlanRepository { return &PgPlanRepository{db: db} }

func (r *PgPlanRepository) ListPlans(ctx context.Context) ([]*models.SubscriptionPlan, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, name, max_users, max_products, features FROM subscription_plans ORDER BY name`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var plans []*models.SubscriptionPlan
	for rows.Next() {
		var p models.SubscriptionPlan
		var featJSON []byte
		if err := rows.Scan(&p.ID, &p.Name, &p.MaxUsers, &p.MaxProducts, &featJSON); err != nil {
			return nil, err
		}
		_ = json.Unmarshal(featJSON, &p.Features)
		plans = append(plans, &p)
	}
	return plans, nil
}

func (r *PgPlanRepository) GetPlan(ctx context.Context, id string) (*models.SubscriptionPlan, error) {
	var p models.SubscriptionPlan
	var featJSON []byte
	err := r.db.QueryRow(ctx,
		`SELECT id, name, max_users, max_products, features FROM subscription_plans WHERE id=$1`,
		id,
	).Scan(&p.ID, &p.Name, &p.MaxUsers, &p.MaxProducts, &featJSON)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	_ = json.Unmarshal(featJSON, &p.Features)
	return &p, err
}

func (r *PgPlanRepository) CreatePlan(ctx context.Context, plan *models.SubscriptionPlan) error {
	featJSON, _ := json.Marshal(plan.Features)
	return r.db.QueryRow(ctx,
		`INSERT INTO subscription_plans (name, max_users, max_products, features)
		 VALUES ($1, $2, $3, $4) RETURNING id`,
		plan.Name, plan.MaxUsers, plan.MaxProducts, featJSON,
	).Scan(&plan.ID)
}

func (r *PgPlanRepository) UpdatePlan(ctx context.Context, plan *models.SubscriptionPlan) error {
	featJSON, _ := json.Marshal(plan.Features)
	_, err := r.db.Exec(ctx,
		`UPDATE subscription_plans SET name=$1, max_users=$2, max_products=$3, features=$4 WHERE id=$5`,
		plan.Name, plan.MaxUsers, plan.MaxProducts, featJSON, plan.ID)
	return err
}

// ─── Tenant Repository ────────────────────────────────────────────────────────

// PgTenantRepository implements TenantRepository
type PgTenantRepository struct{ db *pgxpool.Pool }

func NewPgTenantRepository(db *pgxpool.Pool) *PgTenantRepository {
	return &PgTenantRepository{db: db}
}

func (r *PgTenantRepository) ListTenants(ctx context.Context) ([]*TenantSummary, error) {
	rows, err := r.db.Query(ctx,
		`SELECT t.id, t.name, t.store_type, COALESCE(p.name,''), t.status, t.expires_at,
		        (SELECT COUNT(*) FROM users u WHERE u.tenant_id=t.id AND u.is_active=true)
		 FROM tenants t LEFT JOIN subscription_plans p ON t.plan_id=p.id
		 ORDER BY t.created_at DESC`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []*TenantSummary
	for rows.Next() {
		var s TenantSummary
		if err := rows.Scan(&s.ID, &s.Name, &s.StoreType, &s.PlanName,
			&s.Status, &s.ExpiresAt, &s.UserCount); err != nil {
			return nil, err
		}
		list = append(list, &s)
	}
	return list, nil
}

func (r *PgTenantRepository) GetTenant(ctx context.Context, id string) (*models.Tenant, error) {
	var t models.Tenant
	err := r.db.QueryRow(ctx,
		`SELECT id, name, store_type, plan_id, status, default_lang, base_currency, created_at, expires_at
		 FROM tenants WHERE id=$1`, id,
	).Scan(&t.ID, &t.Name, &t.StoreType, &t.PlanID, &t.Status,
		&t.DefaultLang, &t.BaseCurrency, &t.CreatedAt, &t.ExpiresAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &t, err
}

func (r *PgTenantRepository) CreateTenant(ctx context.Context, req CreateTenantRequest) (*models.Tenant, *OwnerCredentials, error) {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return nil, nil, err
	}
	defer tx.Rollback(ctx)

	// Create tenant
	var tenant models.Tenant
	err = tx.QueryRow(ctx,
		`INSERT INTO tenants (name, store_type, plan_id, default_lang, base_currency, expires_at)
		 VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, name, store_type, plan_id, status, default_lang, base_currency, created_at, expires_at`,
		req.Name, req.StoreType, req.PlanID, req.DefaultLang, req.BaseCurrency, req.ExpiresAt,
	).Scan(&tenant.ID, &tenant.Name, &tenant.StoreType, &tenant.PlanID, &tenant.Status,
		&tenant.DefaultLang, &tenant.BaseCurrency, &tenant.CreatedAt, &tenant.ExpiresAt)
	if err != nil {
		return nil, nil, err
	}

	// Create owner account with random PIN
	pin := generatePIN()
	pinHash, err := auth.HashPIN(pin)
	if err != nil {
		return nil, nil, err
	}

	var ownerID string
	err = tx.QueryRow(ctx,
		`INSERT INTO users (tenant_id, username, display_name, role, pin_hash)
		 VALUES ($1, 'owner', 'Store Owner', 'owner', $2) RETURNING id`,
		tenant.ID, pinHash,
	).Scan(&ownerID)
	if err != nil {
		return nil, nil, err
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, nil, err
	}

	creds := &OwnerCredentials{
		TenantID: tenant.ID,
		Username: "owner",
		PIN:      pin,
	}
	return &tenant, creds, nil
}

func (r *PgTenantRepository) UpdateTenant(ctx context.Context, id string, updates map[string]any) (*models.Tenant, error) {
	// Build dynamic UPDATE — only allowed fields
	allowed := map[string]bool{"name": true, "store_type": true, "plan_id": true,
		"default_lang": true, "base_currency": true, "expires_at": true}

	i := 1
	setClauses := ""
	args := []any{}
	for k, v := range updates {
		if !allowed[k] {
			continue
		}
		if setClauses != "" {
			setClauses += ", "
		}
		setClauses += fmt.Sprintf("%s=$%d", k, i)
		args = append(args, v)
		i++
	}
	if setClauses == "" {
		return r.GetTenant(ctx, id)
	}
	args = append(args, id)
	_, err := r.db.Exec(ctx,
		fmt.Sprintf("UPDATE tenants SET %s, updated_at=NOW() WHERE id=$%d", setClauses, i),
		args...)
	if err != nil {
		return nil, err
	}
	return r.GetTenant(ctx, id)
}

func (r *PgTenantRepository) SetTenantStatus(ctx context.Context, id, status string) error {
	_, err := r.db.Exec(ctx, `UPDATE tenants SET status=$1 WHERE id=$2`, status, id)
	return err
}

func (r *PgTenantRepository) GetPlan(ctx context.Context, id string) (*models.SubscriptionPlan, error) {
	repo := NewPgPlanRepository(r.db)
	return repo.GetPlan(ctx, id)
}

// ─── User Repository ──────────────────────────────────────────────────────────

// PgUserRepository implements UserRepository
type PgUserRepository struct{ db *pgxpool.Pool }

func NewPgUserRepository(db *pgxpool.Pool) *PgUserRepository { return &PgUserRepository{db: db} }

func (r *PgUserRepository) ListUsers(ctx context.Context, tenantID string) ([]*models.User, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, tenant_id, username, display_name, role, is_active, created_at
		 FROM users WHERE tenant_id=$1 ORDER BY created_at`,
		tenantID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []*models.User
	for rows.Next() {
		var u models.User
		if err := rows.Scan(&u.ID, &u.TenantID, &u.Username, &u.DisplayName,
			&u.Role, &u.IsActive, &u.CreatedAt); err != nil {
			return nil, err
		}
		users = append(users, &u)
	}
	return users, nil
}

func (r *PgUserRepository) GetUser(ctx context.Context, id string) (*models.User, error) {
	var u models.User
	err := r.db.QueryRow(ctx,
		`SELECT id, tenant_id, username, display_name, role, is_active, created_at
		 FROM users WHERE id=$1`, id,
	).Scan(&u.ID, &u.TenantID, &u.Username, &u.DisplayName, &u.Role, &u.IsActive, &u.CreatedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &u, err
}

func (r *PgUserRepository) CreateUser(ctx context.Context, req CreateUserRequest) (*models.User, error) {
	pinHash, err := auth.HashPIN(req.PIN)
	if err != nil {
		return nil, err
	}
	var u models.User
	err = r.db.QueryRow(ctx,
		`INSERT INTO users (tenant_id, username, display_name, role, pin_hash)
		 VALUES ($1, $2, $3, $4, $5)
		 RETURNING id, tenant_id, username, display_name, role, is_active, created_at`,
		req.TenantID, req.Username, req.DisplayName, req.Role, pinHash,
	).Scan(&u.ID, &u.TenantID, &u.Username, &u.DisplayName, &u.Role, &u.IsActive, &u.CreatedAt)
	return &u, err
}

func (r *PgUserRepository) UpdateUser(ctx context.Context, id string, updates map[string]any) (*models.User, error) {
	if name, ok := updates["display_name"].(string); ok {
		_, err := r.db.Exec(ctx, `UPDATE users SET display_name=$1 WHERE id=$2`, name, id)
		if err != nil {
			return nil, err
		}
	}
	return r.GetUser(ctx, id)
}

func (r *PgUserRepository) DeactivateUser(ctx context.Context, id string) error {
	_, err := r.db.Exec(ctx, `UPDATE users SET is_active=false WHERE id=$1`, id)
	return err
}

func (r *PgUserRepository) UpdatePIN(ctx context.Context, id, pinHash string) error {
	_, err := r.db.Exec(ctx, `UPDATE users SET pin_hash=$1 WHERE id=$2`, pinHash, id)
	return err
}

func (r *PgUserRepository) CountActiveUsers(ctx context.Context, tenantID string) (int, error) {
	var count int
	err := r.db.QueryRow(ctx,
		`SELECT COUNT(*) FROM users WHERE tenant_id=$1 AND is_active=true`, tenantID,
	).Scan(&count)
	return count, err
}

func (r *PgUserRepository) GetTenantPlan(ctx context.Context, tenantID string) (*models.SubscriptionPlan, error) {
	var planID string
	err := r.db.QueryRow(ctx, `SELECT COALESCE(plan_id::text,'') FROM tenants WHERE id=$1`, tenantID).Scan(&planID)
	if err != nil || planID == "" {
		return nil, err
	}
	repo := NewPgPlanRepository(r.db)
	return repo.GetPlan(ctx, planID)
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

func generatePIN() string {
	// Simple 6-digit PIN — in production use crypto/rand
	return fmt.Sprintf("%06d", time.Now().UnixNano()%1000000)
}
