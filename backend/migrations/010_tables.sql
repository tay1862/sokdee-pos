-- +migrate Up
CREATE TABLE restaurant_tables (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID        NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  zone          VARCHAR(100),
  table_number  VARCHAR(20) NOT NULL,
  capacity      INT,
  status        VARCHAR(20) NOT NULL DEFAULT 'available',
  opened_at     TIMESTAMPTZ,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tables_tenant_id ON restaurant_tables(tenant_id);
CREATE INDEX idx_tables_status ON restaurant_tables(tenant_id, status);

ALTER TABLE restaurant_tables ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON restaurant_tables
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS restaurant_tables;
