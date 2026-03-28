-- +migrate Up
CREATE TABLE audit_logs (
  id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    UUID         REFERENCES tenants(id) ON DELETE CASCADE,
  user_id      UUID         REFERENCES users(id),
  action       VARCHAR(100) NOT NULL,
  entity_type  VARCHAR(100),
  entity_id    UUID,
  details      JSONB,
  ip_address   VARCHAR(45),
  device_id    VARCHAR(255),
  created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_tenant_id ON audit_logs(tenant_id);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(tenant_id, created_at);
CREATE INDEX idx_audit_logs_action ON audit_logs(tenant_id, action);

-- Note: No RLS on audit_logs — super admin needs full access
-- Tenant isolation enforced at application layer

-- +migrate Down
DROP TABLE IF EXISTS audit_logs;
