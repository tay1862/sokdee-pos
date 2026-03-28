-- +migrate Up
CREATE TABLE orders (
  id               UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        UUID          NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  order_number     VARCHAR(50)   NOT NULL,
  table_id         UUID          REFERENCES restaurant_tables(id),
  cashier_id       UUID          NOT NULL REFERENCES users(id),
  shift_id         UUID          REFERENCES shifts(id),
  status           VARCHAR(30)   NOT NULL DEFAULT 'open',
  subtotal         NUMERIC(15,2) NOT NULL DEFAULT 0,
  discount_amount  NUMERIC(15,2) NOT NULL DEFAULT 0,
  tax_amount       NUMERIC(15,2) NOT NULL DEFAULT 0,
  total            NUMERIC(15,2) NOT NULL DEFAULT 0,
  notes            TEXT,
  idempotency_key  VARCHAR(255)  UNIQUE,
  created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  paid_at          TIMESTAMPTZ,
  updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_orders_tenant_id ON orders(tenant_id);
CREATE INDEX idx_orders_status ON orders(tenant_id, status);
CREATE INDEX idx_orders_cashier_id ON orders(cashier_id);
CREATE INDEX idx_orders_created_at ON orders(tenant_id, created_at);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON orders
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS orders;
