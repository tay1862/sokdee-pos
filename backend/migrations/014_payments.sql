-- +migrate Up
CREATE TABLE payments (
  id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id       UUID          NOT NULL REFERENCES orders(id),
  tenant_id      UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  method         VARCHAR(30)   NOT NULL,
  currency       VARCHAR(3)    NOT NULL,
  amount         NUMERIC(15,2) NOT NULL,
  amount_lak     NUMERIC(15,2) NOT NULL,
  exchange_rate  NUMERIC(10,4) NOT NULL DEFAULT 1,
  change_amount  NUMERIC(15,2) NOT NULL DEFAULT 0,
  confirmed_by   UUID          REFERENCES users(id),
  created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_tenant_id ON payments(tenant_id);
CREATE INDEX idx_payments_created_at ON payments(tenant_id, created_at);

ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON payments
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS payments;
