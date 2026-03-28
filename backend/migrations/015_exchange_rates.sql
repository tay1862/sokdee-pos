-- +migrate Up
CREATE TABLE exchange_rates (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  currency      VARCHAR(3)    NOT NULL,
  rate          NUMERIC(10,4) NOT NULL,
  set_by        UUID          REFERENCES users(id),
  effective_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  UNIQUE(tenant_id, currency)
);

CREATE INDEX idx_exchange_rates_tenant_id ON exchange_rates(tenant_id);

ALTER TABLE exchange_rates ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON exchange_rates
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS exchange_rates;
