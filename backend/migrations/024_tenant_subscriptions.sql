-- +migrate Up
CREATE TABLE tenant_subscriptions (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID        NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  plan_id     UUID        NOT NULL REFERENCES subscription_plans(id),
  started_at  TIMESTAMPTZ NOT NULL,
  expires_at  TIMESTAMPTZ NOT NULL,
  created_by  UUID        REFERENCES users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tenant_subs_tenant_id ON tenant_subscriptions(tenant_id);
CREATE INDEX idx_tenant_subs_expires_at ON tenant_subscriptions(expires_at);

-- +migrate Down
DROP TABLE IF EXISTS tenant_subscriptions;
