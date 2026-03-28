-- +migrate Up
CREATE TABLE order_items (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id      UUID          NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  tenant_id     UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  product_id    UUID          NOT NULL REFERENCES products(id),
  variant_id    UUID          REFERENCES product_variants(id),
  product_name  VARCHAR(255)  NOT NULL,
  unit_price    NUMERIC(15,2) NOT NULL,
  quantity      INT           NOT NULL,
  discount      NUMERIC(15,2) NOT NULL DEFAULT 0,
  line_total    NUMERIC(15,2) NOT NULL,
  modifiers     JSONB,
  notes         TEXT,
  kds_status    VARCHAR(20)   NOT NULL DEFAULT 'pending'
);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_tenant_id ON order_items(tenant_id);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON order_items
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS order_items;
