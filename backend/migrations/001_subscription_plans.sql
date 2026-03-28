-- +migrate Up
CREATE TABLE subscription_plans (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          VARCHAR(50)  NOT NULL,
  max_users     INT,
  max_products  INT,
  features      JSONB        NOT NULL DEFAULT '{}',
  created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

INSERT INTO subscription_plans (name, max_users, max_products, features) VALUES
  ('starter',    3,    100,  '{"kds":false,"advanced_reports":false,"inventory":false,"multi_currency":false,"table_management":false}'),
  ('basic',      10,   500,  '{"kds":false,"advanced_reports":false,"inventory":true,"multi_currency":true,"table_management":false}'),
  ('pro',        30,   2000, '{"kds":true,"advanced_reports":true,"inventory":true,"multi_currency":true,"table_management":true}'),
  ('enterprise', NULL, NULL, '{"kds":true,"advanced_reports":true,"inventory":true,"multi_currency":true,"table_management":true}');

-- +migrate Down
DROP TABLE IF EXISTS subscription_plans;
