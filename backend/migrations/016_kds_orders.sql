-- +migrate Up
CREATE TABLE kds_orders (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    UUID        NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  order_id     UUID        NOT NULL REFERENCES orders(id),
  table_id     UUID        REFERENCES restaurant_tables(id),
  status       VARCHAR(20) NOT NULL DEFAULT 'pending',
  received_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ready_at     TIMESTAMPTZ,
  served_at    TIMESTAMPTZ
);

CREATE INDEX idx_kds_orders_tenant_id ON kds_orders(tenant_id);
CREATE INDEX idx_kds_orders_status ON kds_orders(tenant_id, status);

ALTER TABLE kds_orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON kds_orders
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS kds_orders;
