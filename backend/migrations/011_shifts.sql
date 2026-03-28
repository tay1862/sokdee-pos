-- +migrate Up
CREATE TABLE shifts (
  id               UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  cashier_id       UUID          NOT NULL REFERENCES users(id),
  device_id        VARCHAR(255),
  opening_balance  NUMERIC(15,2) NOT NULL,
  closing_balance  NUMERIC(15,2),
  status           VARCHAR(20)   NOT NULL DEFAULT 'open',
  opened_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  closed_at        TIMESTAMPTZ,
  updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_shifts_tenant_id ON shifts(tenant_id);
CREATE INDEX idx_shifts_cashier_id ON shifts(cashier_id);
CREATE INDEX idx_shifts_status ON shifts(tenant_id, status);

ALTER TABLE shifts ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON shifts
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS shifts;
