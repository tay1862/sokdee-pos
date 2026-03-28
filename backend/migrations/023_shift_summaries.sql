-- +migrate Up
CREATE TABLE shift_summaries (
  id                 UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  shift_id           UUID          NOT NULL REFERENCES shifts(id),
  tenant_id          UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  total_sales        NUMERIC(15,2) NOT NULL DEFAULT 0,
  total_cash         NUMERIC(15,2) NOT NULL DEFAULT 0,
  total_qr           NUMERIC(15,2) NOT NULL DEFAULT 0,
  total_transfer     NUMERIC(15,2) NOT NULL DEFAULT 0,
  expected_cash      NUMERIC(15,2) NOT NULL DEFAULT 0,
  actual_cash        NUMERIC(15,2) NOT NULL DEFAULT 0,
  cash_difference    NUMERIC(15,2) NOT NULL DEFAULT 0,
  transaction_count  INT           NOT NULL DEFAULT 0,
  void_count         INT           NOT NULL DEFAULT 0,
  refund_count       INT           NOT NULL DEFAULT 0,
  created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_shift_summaries_tenant_id ON shift_summaries(tenant_id);
CREATE INDEX idx_shift_summaries_shift_id ON shift_summaries(shift_id);

ALTER TABLE shift_summaries ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON shift_summaries
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS shift_summaries;
