-- +migrate Up
CREATE TABLE void_logs (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID        NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  order_id    UUID        NOT NULL REFERENCES orders(id),
  reason      TEXT        NOT NULL,
  voided_by   UUID        NOT NULL REFERENCES users(id),
  shift_id    UUID        REFERENCES shifts(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_void_logs_tenant_id ON void_logs(tenant_id);
CREATE INDEX idx_void_logs_order_id ON void_logs(order_id);

ALTER TABLE void_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON void_logs
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS void_logs;
