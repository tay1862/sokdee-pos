-- +migrate Up
CREATE TABLE users (
  id                   UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id            UUID         NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  username             VARCHAR(100) NOT NULL,
  display_name         VARCHAR(255) NOT NULL,
  role                 VARCHAR(30)  NOT NULL,
  pin_hash             VARCHAR(255) NOT NULL,
  is_active            BOOLEAN      NOT NULL DEFAULT TRUE,
  failed_pin_attempts  INT          NOT NULL DEFAULT 0,
  locked_until         TIMESTAMPTZ,
  created_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  UNIQUE(tenant_id, username)
);

CREATE INDEX idx_users_tenant_id ON users(tenant_id);
CREATE INDEX idx_users_role ON users(tenant_id, role);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON users
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS users;
