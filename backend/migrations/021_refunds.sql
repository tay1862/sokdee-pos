-- +migrate Up
CREATE TABLE refunds (
  id                 UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id          UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  original_order_id  UUID          NOT NULL REFERENCES orders(id),
  reason             TEXT          NOT NULL,
  approved_by        UUID          NOT NULL REFERENCES users(id),
  total_refund       NUMERIC(15,2) NOT NULL,
  currency           VARCHAR(3)    NOT NULL,
  created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_refunds_tenant_id ON refunds(tenant_id);
CREATE INDEX idx_refunds_order_id ON refunds(original_order_id);

ALTER TABLE refunds ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON refunds
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS refunds;
