-- +migrate Up
CREATE TABLE conflict_logs (
  id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID         NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  entity_type   VARCHAR(100) NOT NULL,
  entity_id     UUID         NOT NULL,
  local_value   JSONB,
  server_value  JSONB,
  resolution    VARCHAR(20),
  resolved_by   UUID         REFERENCES users(id),
  created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  resolved_at   TIMESTAMPTZ
);

CREATE INDEX idx_conflict_logs_tenant_id ON conflict_logs(tenant_id);
CREATE INDEX idx_conflict_logs_unresolved ON conflict_logs(tenant_id, resolved_at) WHERE resolved_at IS NULL;

ALTER TABLE conflict_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON conflict_logs
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS conflict_logs;
