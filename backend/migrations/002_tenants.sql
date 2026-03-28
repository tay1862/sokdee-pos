-- +migrate Up
CREATE TABLE tenants (
  id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  name           VARCHAR(255) NOT NULL,
  store_type     VARCHAR(50)  NOT NULL,
  plan_id        UUID         REFERENCES subscription_plans(id),
  status         VARCHAR(20)  NOT NULL DEFAULT 'active',
  default_lang   VARCHAR(5)   NOT NULL DEFAULT 'lo',
  base_currency  VARCHAR(3)   NOT NULL DEFAULT 'LAK',
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  expires_at     TIMESTAMPTZ,
  updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tenants_status ON tenants(status);
CREATE INDEX idx_tenants_expires_at ON tenants(expires_at);

-- +migrate Down
DROP TABLE IF EXISTS tenants;
