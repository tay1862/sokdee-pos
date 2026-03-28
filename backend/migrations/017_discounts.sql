-- +migrate Up
CREATE TABLE discounts (
  id                UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255)  NOT NULL,
  type              VARCHAR(20)   NOT NULL,
  value             NUMERIC(10,4) NOT NULL,
  scope             VARCHAR(20)   NOT NULL,
  product_id        UUID          REFERENCES products(id),
  starts_at         TIMESTAMPTZ,
  ends_at           TIMESTAMPTZ,
  is_active         BOOLEAN       NOT NULL DEFAULT TRUE,
  requires_approval BOOLEAN       NOT NULL DEFAULT FALSE,
  created_by        UUID          REFERENCES users(id),
  updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_discounts_tenant_id ON discounts(tenant_id);
CREATE INDEX idx_discounts_active ON discounts(tenant_id, is_active);

ALTER TABLE discounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON discounts
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS discounts;
