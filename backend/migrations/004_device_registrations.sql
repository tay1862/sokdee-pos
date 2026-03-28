-- +migrate Up
CREATE TABLE device_registrations (
  id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id      UUID         NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id        UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  device_id      VARCHAR(255) NOT NULL,
  device_name    VARCHAR(255),
  os_version     VARCHAR(100),
  is_revoked     BOOLEAN      NOT NULL DEFAULT FALSE,
  registered_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  last_seen_at   TIMESTAMPTZ,
  UNIQUE(tenant_id, device_id)
);

CREATE INDEX idx_device_reg_tenant_id ON device_registrations(tenant_id);
CREATE INDEX idx_device_reg_user_id ON device_registrations(user_id);

ALTER TABLE device_registrations ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON device_registrations
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS device_registrations;
