-- +migrate Up
CREATE TABLE stock_transactions (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  product_id    UUID          NOT NULL REFERENCES products(id),
  variant_id    UUID          REFERENCES product_variants(id),
  type          VARCHAR(30)   NOT NULL,
  quantity      INT           NOT NULL,
  cost_price    NUMERIC(15,2),
  reason        TEXT,
  reference_id  UUID,
  performed_by  UUID          REFERENCES users(id),
  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_stock_tx_tenant_id ON stock_transactions(tenant_id);
CREATE INDEX idx_stock_tx_product_id ON stock_transactions(product_id);
CREATE INDEX idx_stock_tx_created_at ON stock_transactions(created_at);

ALTER TABLE stock_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON stock_transactions
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS stock_transactions;
