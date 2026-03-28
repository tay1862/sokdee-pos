-- +migrate Up
CREATE TABLE product_modifiers (
  id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID         NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  product_id  UUID         NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  options     JSONB        NOT NULL DEFAULT '[]',
  is_required BOOLEAN      NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_product_modifiers_product_id ON product_modifiers(product_id);
CREATE INDEX idx_product_modifiers_tenant_id ON product_modifiers(tenant_id);

ALTER TABLE product_modifiers ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON product_modifiers
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS product_modifiers;
