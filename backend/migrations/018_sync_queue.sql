-- +migrate Up
CREATE TABLE sync_queue (
  id               UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id        UUID         NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  device_id        VARCHAR(255),
  entity_type      VARCHAR(100) NOT NULL,
  entity_id        UUID         NOT NULL,
  operation        VARCHAR(20)  NOT NULL,
  payload          JSONB        NOT NULL,
  idempotency_key  VARCHAR(255) NOT NULL UNIQUE,
  status           VARCHAR(20)  NOT NULL DEFAULT 'pending',
  created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  synced_at        TIMESTAMPTZ
);

CREATE INDEX idx_sync_queue_tenant_id ON sync_queue(tenant_id);
CREATE INDEX idx_sync_queue_status ON sync_queue(tenant_id, status);

ALTER TABLE sync_queue ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON sync_queue
  USING (tenant_id = current_setting('app.current_tenant', TRUE)::UUID);

-- +migrate Down
DROP TABLE IF EXISTS sync_queue;
