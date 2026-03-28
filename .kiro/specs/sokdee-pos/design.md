# Technical Design Document: SOKDEE POS

## Overview

SOKDEE POS เป็นระบบ SaaS Point-of-Sale แบบ multi-tenant ออกแบบสำหรับตลาดลาว รองรับร้านค้าหลายประเภท ได้แก่ ร้านอาหาร, ร้านค้าทั่วไป, คลังสินค้า, และร้านอะไหล่รถ ระบบทำงานบน Flutter (Android APK + Flutter Web) พร้อม offline-first architecture และ sync engine สำหรับ synchronization ข้อมูลกับ backend server บน VPS

### เป้าหมายหลักของ Design

- **Offline-first**: ทำงานได้เต็มรูปแบบแม้ไม่มีอินเทอร์เน็ต
- **Multi-tenant isolation**: ข้อมูลของแต่ละ Tenant แยกกันอย่างสมบูรณ์
- **Feature gating**: ควบคุม feature ตาม subscription plan
- **Cross-platform**: Android APK + Flutter Web (iOS/iPad)
- **Real-time KDS**: แสดงออเดอร์ครัวแบบ real-time ผ่าน WebSocket

---

## Architecture

### High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                                  │
│                                                                      │
│  ┌──────────────────────┐        ┌──────────────────────────────┐   │
│  │   Flutter Android    │        │      Flutter Web (iOS/iPad)  │   │
│  │   (APK - Tablet/Phone│        │      (Chrome/Safari/Edge)    │   │
│  │                      │        │                              │   │
│  │  ┌────────────────┐  │        │  ┌────────────────────────┐  │   │
│  │  │  Local DB      │  │        │  │  IndexedDB / Memory    │  │   │
│  │  │  (SQLite/Drift) │  │        │  │  (Limited offline)     │  │   │
│  │  └────────────────┘  │        │  └────────────────────────┘  │   │
│  └──────────┬───────────┘        └──────────────┬───────────────┘   │
└─────────────┼────────────────────────────────────┼───────────────────┘
              │  HTTPS/TLS + WebSocket              │
┌─────────────▼────────────────────────────────────▼───────────────────┐
│                        BACKEND LAYER (VPS)                            │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │                    API Gateway / Load Balancer                   │ │
│  │                    (Nginx reverse proxy)                         │ │
│  └──────────────────────────┬──────────────────────────────────────┘ │
│                             │                                         │
│  ┌──────────────────────────▼──────────────────────────────────────┐ │
│  │                    Backend Application                           │ │
│  │                    (Go / Node.js)                                │ │
│  │                                                                  │ │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────────────────┐ │ │
│  │  │ Auth     │ │ Tenant   │ │ Sync     │ │ WebSocket (KDS)    │ │ │
│  │  │ Service  │ │ Service  │ │ Service  │ │ Service            │ │ │
│  │  └──────────┘ └──────────┘ └──────────┘ └────────────────────┘ │ │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────────────────┐ │ │
│  │  │ POS      │ │ Inventory│ │ Report   │ │ Notification       │ │ │
│  │  │ Service  │ │ Service  │ │ Service  │ │ Service            │ │ │
│  │  └──────────┘ └──────────┘ └──────────┘ └────────────────────┘ │ │
│  └──────────────────────────┬──────────────────────────────────────┘ │
│                             │                                         │
│  ┌──────────────────────────▼──────────────────────────────────────┐ │
│  │                    PostgreSQL Database                           │ │
│  │              (Multi-tenant with Row-Level Security)              │ │
│  └─────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────────┘
```

### Multi-Tenancy Architecture

ใช้ **Shared Database, Shared Schema** พร้อม Row-Level Security (RLS) ใน PostgreSQL:

- ทุก table มี column `tenant_id` (UUID)
- Backend middleware inject `tenant_id` จาก JWT token ทุก request
- PostgreSQL RLS policy บังคับ `tenant_id` ทุก query อัตโนมัติ
- Super Admin ใช้ special role ที่ bypass RLS เพื่อจัดการ tenant ทั้งหมด

### Offline-First Architecture

```
Flutter App
    │
    ▼
┌─────────────────────────────────────────┐
│           Data Layer (Repository)        │
│                                          │
│  ┌──────────────┐    ┌────────────────┐  │
│  │  Local Repo  │    │  Remote Repo   │  │
│  │  (Drift/     │    │  (REST API     │  │
│  │   SQLite)    │    │   Client)      │  │
│  └──────┬───────┘    └───────┬────────┘  │
│         │                    │           │
│  ┌──────▼────────────────────▼────────┐  │
│  │         Sync Engine                │  │
│  │  - SyncQueue (pending operations)  │  │
│  │  - Conflict Detector               │  │
│  │  - Idempotency Key Manager         │  │
│  └────────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

**กฎ offline-first:**
1. Write ไปที่ Local DB ก่อนเสมอ
2. เพิ่ม operation เข้า SyncQueue
3. เมื่อ online: flush SyncQueue ไปยัง Backend
4. Backend response อัปเดต Local DB (reconcile)

---

## Components and Interfaces

### Flutter App — Feature-Based Folder Structure

```
lib/
├── core/
│   ├── auth/           # PIN auth, JWT, device registration
│   ├── database/       # Drift DB setup, migrations
│   ├── network/        # HTTP client, WebSocket client
│   ├── sync/           # Sync engine, SyncQueue, conflict resolution
│   ├── i18n/           # Localization (lo/th/en)
│   ├── router/         # GoRouter navigation
│   ├── theme/          # App theme, responsive breakpoints
│   └── utils/          # Helpers, extensions
│
├── features/
│   ├── super_admin/    # Tenant management, subscription management
│   ├── setup_wizard/   # Guided setup flow
│   ├── pos/            # Core POS: order taking, payment
│   ├── tables/         # Floor plan, table management (restaurant)
│   ├── kds/            # Kitchen Display System
│   ├── inventory/      # Products, categories, stock management
│   ├── shifts/         # Shift open/close, shift summary
│   ├── discounts/      # Discount & promotion management
│   ├── reports/        # Sales, P&L, stock reports
│   ├── settings/       # Store settings, hardware, currency, users
│   ├── notifications/  # In-app alerts
│   └── refunds/        # Refund & void management
│
└── main.dart
```

### State Management — Riverpod

ใช้ **Riverpod** เป็น state management หลัก:

- `StateNotifierProvider` สำหรับ mutable state (cart, shift, order)
- `FutureProvider` สำหรับ async data loading
- `StreamProvider` สำหรับ real-time data (KDS WebSocket, connectivity)
- `Provider` สำหรับ services และ repositories

```dart
// ตัวอย่าง: Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.read(orderRepositoryProvider));
});

// ตัวอย่าง: KDS Stream Provider
final kdsOrdersProvider = StreamProvider<List<KDSOrder>>((ref) {
  return ref.read(kdsServiceProvider).ordersStream;
});
```

### Navigation — GoRouter

```dart
// Route structure
/login                    → LoginScreen
/setup-wizard             → SetupWizardScreen (Super Admin)
/super-admin/             → SuperAdminDashboard
  tenants/                → TenantListScreen
  tenants/:id             → TenantDetailScreen
/pos/                     → POSScreen (main POS)
  tables/                 → TableFloorPlanScreen
  order/:tableId          → OrderScreen
  payment/:orderId        → PaymentScreen
/kds/                     → KDSScreen
/inventory/               → InventoryScreen
/reports/                 → ReportsScreen
/settings/                → SettingsScreen
/shifts/                  → ShiftManagementScreen
```

### Responsive Layout Strategy

| Breakpoint | Device | Layout |
|---|---|---|
| < 600px | Phone | Single column, bottom nav |
| 600–1024px | Tablet portrait | Split view (categories + items) |
| > 1024px | Tablet landscape / Web | Full POS layout (3 columns) |

ใช้ `LayoutBuilder` + custom `ResponsiveWidget` wrapper:

```dart
class ResponsiveWidget extends StatelessWidget {
  final Widget phone;
  final Widget tablet;
  final Widget? desktop;
  // ...
}
```

### Backend API — Service Interfaces

Backend เขียนด้วย **Go** (เหมาะกับ VPS performance, low memory footprint, concurrency สำหรับ WebSocket):

```
cmd/
  server/         # main entry point
internal/
  auth/           # JWT, PIN hashing, device registration
  tenant/         # Tenant CRUD, subscription management
  pos/            # Order, payment processing
  inventory/      # Product, stock management
  kds/            # WebSocket hub, KDS order management
  sync/           # Sync endpoint, conflict detection
  reports/        # Report generation
  middleware/     # Auth, tenant isolation, rate limiting
  database/       # PostgreSQL connection, migrations
pkg/
  models/         # Shared data models
  errors/         # Custom error types
```

---

## Data Models

### Core Entities (PostgreSQL Schema)

#### Subscription Plans & Tenants

```sql
-- Subscription Plans
CREATE TABLE subscription_plans (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          VARCHAR(50) NOT NULL,  -- starter, basic, pro, enterprise
  max_users     INT,                   -- NULL = unlimited
  max_products  INT,                   -- NULL = unlimited
  features      JSONB NOT NULL,        -- feature flags
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Tenants
CREATE TABLE tenants (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            VARCHAR(255) NOT NULL,
  store_type      VARCHAR(50) NOT NULL,  -- restaurant, retail, warehouse, auto_parts
  plan_id         UUID REFERENCES subscription_plans(id),
  status          VARCHAR(20) DEFAULT 'active',  -- active, suspended, expired
  default_lang    VARCHAR(5) DEFAULT 'lo',
  base_currency   VARCHAR(3) DEFAULT 'LAK',
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  expires_at      TIMESTAMPTZ
);

-- Tenant Subscriptions (history)
CREATE TABLE tenant_subscriptions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  plan_id     UUID REFERENCES subscription_plans(id),
  started_at  TIMESTAMPTZ NOT NULL,
  expires_at  TIMESTAMPTZ NOT NULL,
  created_by  UUID  -- super admin user id
);
```

#### Users & Roles

```sql
CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  username      VARCHAR(100) NOT NULL,
  display_name  VARCHAR(255) NOT NULL,
  role          VARCHAR(30) NOT NULL,  -- super_admin, owner, manager, cashier, kitchen_staff
  pin_hash      VARCHAR(255) NOT NULL, -- bcrypt hash of 4-6 digit PIN
  is_active     BOOLEAN DEFAULT TRUE,
  failed_pin_attempts INT DEFAULT 0,
  locked_until  TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(tenant_id, username)
);

CREATE TABLE device_registrations (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  user_id       UUID REFERENCES users(id),
  device_id     VARCHAR(255) NOT NULL,
  device_name   VARCHAR(255),
  os_version    VARCHAR(100),
  is_revoked    BOOLEAN DEFAULT FALSE,
  registered_at TIMESTAMPTZ DEFAULT NOW(),
  last_seen_at  TIMESTAMPTZ
);
```

#### Products & Inventory

```sql
CREATE TABLE categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  parent_id   UUID REFERENCES categories(id),
  name        VARCHAR(255) NOT NULL,
  sort_order  INT DEFAULT 0,
  is_active   BOOLEAN DEFAULT TRUE
);

CREATE TABLE products (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  name          VARCHAR(255) NOT NULL,
  description   TEXT,
  barcode       VARCHAR(100),
  sell_price    NUMERIC(15,2) NOT NULL,
  cost_price    NUMERIC(15,2),
  unit          VARCHAR(50),
  min_stock     INT DEFAULT 0,
  is_active     BOOLEAN DEFAULT TRUE,
  has_variants  BOOLEAN DEFAULT FALSE,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE product_categories (
  product_id  UUID REFERENCES products(id),
  category_id UUID REFERENCES categories(id),
  PRIMARY KEY (product_id, category_id)
);

CREATE TABLE product_variants (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id  UUID REFERENCES products(id),
  tenant_id   UUID REFERENCES tenants(id),
  name        VARCHAR(255) NOT NULL,  -- e.g. "Large", "Red"
  barcode     VARCHAR(100),
  sell_price  NUMERIC(15,2),          -- override parent price if set
  cost_price  NUMERIC(15,2),
  stock_qty   INT DEFAULT 0
);

CREATE TABLE product_modifiers (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  product_id  UUID REFERENCES products(id),
  name        VARCHAR(255) NOT NULL,  -- e.g. "Spice Level"
  options     JSONB NOT NULL,         -- ["mild","medium","hot"]
  is_required BOOLEAN DEFAULT FALSE
);

CREATE TABLE stock_transactions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  product_id    UUID REFERENCES products(id),
  variant_id    UUID REFERENCES product_variants(id),
  type          VARCHAR(30) NOT NULL,  -- sale, stock_in, adjustment, refund, void
  quantity      INT NOT NULL,          -- positive = in, negative = out
  cost_price    NUMERIC(15,2),
  reason        TEXT,
  reference_id  UUID,                  -- order_id or adjustment_id
  performed_by  UUID REFERENCES users(id),
  created_at    TIMESTAMPTZ DEFAULT NOW()
);
```

#### Orders & Payments

```sql
CREATE TABLE tables (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  zone        VARCHAR(100),
  table_number VARCHAR(20) NOT NULL,
  capacity    INT,
  status      VARCHAR(20) DEFAULT 'available',  -- available, occupied, waiting_payment
  opened_at   TIMESTAMPTZ
);

CREATE TABLE orders (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  order_number    VARCHAR(50) NOT NULL,
  table_id        UUID REFERENCES tables(id),
  cashier_id      UUID REFERENCES users(id),
  shift_id        UUID REFERENCES shifts(id),
  status          VARCHAR(30) DEFAULT 'open',  -- open, paid, voided, refunded
  subtotal        NUMERIC(15,2) DEFAULT 0,
  discount_amount NUMERIC(15,2) DEFAULT 0,
  tax_amount      NUMERIC(15,2) DEFAULT 0,
  total           NUMERIC(15,2) DEFAULT 0,
  notes           TEXT,
  idempotency_key VARCHAR(255) UNIQUE,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  paid_at         TIMESTAMPTZ
);

CREATE TABLE order_items (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id      UUID REFERENCES orders(id),
  tenant_id     UUID REFERENCES tenants(id),
  product_id    UUID REFERENCES products(id),
  variant_id    UUID REFERENCES product_variants(id),
  product_name  VARCHAR(255) NOT NULL,  -- snapshot at time of sale
  unit_price    NUMERIC(15,2) NOT NULL,
  quantity      INT NOT NULL,
  discount      NUMERIC(15,2) DEFAULT 0,
  line_total    NUMERIC(15,2) NOT NULL,
  modifiers     JSONB,                  -- selected modifier options
  notes         TEXT,
  kds_status    VARCHAR(20) DEFAULT 'pending'  -- pending, preparing, done
);

CREATE TABLE payments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id        UUID REFERENCES orders(id),
  tenant_id       UUID REFERENCES tenants(id),
  method          VARCHAR(30) NOT NULL,  -- cash, qr, transfer
  currency        VARCHAR(3) NOT NULL,
  amount          NUMERIC(15,2) NOT NULL,
  amount_lak      NUMERIC(15,2) NOT NULL,  -- always in LAK
  exchange_rate   NUMERIC(10,4) DEFAULT 1,
  change_amount   NUMERIC(15,2) DEFAULT 0,
  confirmed_by    UUID REFERENCES users(id),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE exchange_rates (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  currency    VARCHAR(3) NOT NULL,  -- THB, USD
  rate        NUMERIC(10,4) NOT NULL,  -- 1 THB = X LAK
  set_by      UUID REFERENCES users(id),
  effective_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### KDS Orders

```sql
CREATE TABLE kds_orders (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  order_id    UUID REFERENCES orders(id),
  table_id    UUID REFERENCES tables(id),
  status      VARCHAR(20) DEFAULT 'pending',  -- pending, preparing, ready, served
  received_at TIMESTAMPTZ DEFAULT NOW(),
  ready_at    TIMESTAMPTZ,
  served_at   TIMESTAMPTZ
);
```

#### Shifts

```sql
CREATE TABLE shifts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  cashier_id      UUID REFERENCES users(id),
  device_id       VARCHAR(255),
  opening_balance NUMERIC(15,2) NOT NULL,
  closing_balance NUMERIC(15,2),
  status          VARCHAR(20) DEFAULT 'open',  -- open, closed
  opened_at       TIMESTAMPTZ DEFAULT NOW(),
  closed_at       TIMESTAMPTZ
);

CREATE TABLE shift_summaries (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shift_id          UUID REFERENCES shifts(id),
  tenant_id         UUID REFERENCES tenants(id),
  total_sales       NUMERIC(15,2),
  total_cash        NUMERIC(15,2),
  total_qr          NUMERIC(15,2),
  total_transfer    NUMERIC(15,2),
  expected_cash     NUMERIC(15,2),
  actual_cash       NUMERIC(15,2),
  cash_difference   NUMERIC(15,2),
  transaction_count INT,
  void_count        INT,
  refund_count      INT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);
```

#### Discounts & Promotions

```sql
CREATE TABLE discounts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  name          VARCHAR(255) NOT NULL,
  type          VARCHAR(20) NOT NULL,  -- percentage, fixed
  value         NUMERIC(10,4) NOT NULL,
  scope         VARCHAR(20) NOT NULL,  -- item, order
  product_id    UUID REFERENCES products(id),  -- NULL = applies to all
  starts_at     TIMESTAMPTZ,
  ends_at       TIMESTAMPTZ,
  is_active     BOOLEAN DEFAULT TRUE,
  requires_approval BOOLEAN DEFAULT FALSE,
  created_by    UUID REFERENCES users(id)
);
```

#### Sync & Audit

```sql
CREATE TABLE sync_queue (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  device_id       VARCHAR(255),
  entity_type     VARCHAR(100) NOT NULL,
  entity_id       UUID NOT NULL,
  operation       VARCHAR(20) NOT NULL,  -- create, update, delete
  payload         JSONB NOT NULL,
  idempotency_key VARCHAR(255) UNIQUE NOT NULL,
  status          VARCHAR(20) DEFAULT 'pending',  -- pending, synced, conflict, failed
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  synced_at       TIMESTAMPTZ
);

CREATE TABLE conflict_logs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  entity_type   VARCHAR(100) NOT NULL,
  entity_id     UUID NOT NULL,
  local_value   JSONB,
  server_value  JSONB,
  resolution    VARCHAR(20),  -- use_local, use_server, manual
  resolved_by   UUID REFERENCES users(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  resolved_at   TIMESTAMPTZ
);

CREATE TABLE audit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  user_id     UUID REFERENCES users(id),
  action      VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100),
  entity_id   UUID,
  details     JSONB,
  ip_address  VARCHAR(45),
  device_id   VARCHAR(255),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

#### Refunds & Voids

```sql
CREATE TABLE refunds (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  original_order_id UUID REFERENCES orders(id),
  refund_order_id UUID REFERENCES orders(id),
  reason          TEXT NOT NULL,
  approved_by     UUID REFERENCES users(id),
  total_refund    NUMERIC(15,2) NOT NULL,
  currency        VARCHAR(3) NOT NULL,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE void_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  order_id    UUID REFERENCES orders(id),
  reason      TEXT NOT NULL,
  voided_by   UUID REFERENCES users(id),
  shift_id    UUID REFERENCES shifts(id),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### Local DB Schema (Drift/SQLite)

Local DB บน device มี schema เดียวกับ PostgreSQL แต่เพิ่ม:
- `is_synced BOOLEAN DEFAULT FALSE` ทุก table
- `local_updated_at TIMESTAMPTZ` สำหรับ conflict detection
- ไม่มี RLS (tenant isolation ทำผ่าน app layer)
- เก็บเฉพาะข้อมูลของ tenant ที่ login อยู่

---

## Backend API Design

### Authentication Strategy

```
POST /api/v1/auth/login          # PIN login → JWT + refresh token
POST /api/v1/auth/refresh        # Refresh access token
POST /api/v1/auth/logout         # Revoke refresh token
POST /api/v1/auth/device/register # Register new device
DELETE /api/v1/auth/device/:id   # Revoke device
```

**JWT Payload:**
```json
{
  "sub": "user_id",
  "tenant_id": "tenant_uuid",
  "role": "cashier",
  "device_id": "device_fingerprint",
  "exp": 1234567890
}
```

- Access token TTL: 1 ชั่วโมง
- Refresh token TTL: 30 วัน
- PIN hash: bcrypt cost factor 12

### Multi-Tenancy Middleware

```go
// ทุก request ต้องผ่าน middleware นี้
func TenantMiddleware(next http.Handler) http.Handler {
    // 1. Extract JWT
    // 2. Validate token
    // 3. Set tenant_id ใน context
    // 4. PostgreSQL SET app.current_tenant = tenant_id
    // 5. RLS policy จะ filter ข้อมูลอัตโนมัติ
}
```

### API Endpoints (Grouped by Module)

#### Super Admin
```
GET    /api/v1/admin/tenants              # List all tenants
POST   /api/v1/admin/tenants              # Create tenant
GET    /api/v1/admin/tenants/:id          # Get tenant detail
PATCH  /api/v1/admin/tenants/:id          # Update tenant
PATCH  /api/v1/admin/tenants/:id/suspend  # Suspend tenant
PATCH  /api/v1/admin/tenants/:id/activate # Activate tenant
GET    /api/v1/admin/plans                # List subscription plans
POST   /api/v1/admin/plans                # Create plan
PATCH  /api/v1/admin/plans/:id            # Update plan
```

#### Users & Roles
```
GET    /api/v1/users                      # List users (tenant-scoped)
POST   /api/v1/users                      # Create user
PATCH  /api/v1/users/:id                  # Update user
DELETE /api/v1/users/:id                  # Deactivate user
PATCH  /api/v1/users/:id/pin              # Change PIN
```

#### Products & Inventory
```
GET    /api/v1/products                   # List products
POST   /api/v1/products                   # Create product
PATCH  /api/v1/products/:id               # Update product
DELETE /api/v1/products/:id               # Delete product
POST   /api/v1/products/import            # CSV import
GET    /api/v1/categories                 # List categories
POST   /api/v1/categories                 # Create category
POST   /api/v1/stock/in                   # Stock in
POST   /api/v1/stock/adjust               # Stock adjustment
GET    /api/v1/stock/transactions         # Stock transaction history
```

#### Orders & POS
```
GET    /api/v1/orders                     # List orders
POST   /api/v1/orders                     # Create order
GET    /api/v1/orders/:id                 # Get order
PATCH  /api/v1/orders/:id                 # Update order (add items)
POST   /api/v1/orders/:id/pay             # Process payment
POST   /api/v1/orders/:id/void            # Void order
POST   /api/v1/orders/:id/refund          # Refund order
GET    /api/v1/orders/:id/receipt         # Get receipt data
```

#### Tables (Restaurant)
```
GET    /api/v1/tables                     # List tables with status
POST   /api/v1/tables                     # Create table
PATCH  /api/v1/tables/:id                 # Update table
POST   /api/v1/tables/merge               # Merge tables
POST   /api/v1/tables/:id/move            # Move order to another table
```

#### Shifts
```
POST   /api/v1/shifts/open                # Open shift
POST   /api/v1/shifts/:id/close          # Close shift
GET    /api/v1/shifts                     # List shifts
GET    /api/v1/shifts/:id/summary         # Get shift summary
```

#### Reports
```
GET    /api/v1/reports/sales/daily        # Daily sales report
GET    /api/v1/reports/sales/monthly      # Monthly sales report
GET    /api/v1/reports/pnl                # P&L report (Owner only)
GET    /api/v1/reports/stock              # Stock report
GET    /api/v1/reports/cashier            # Cashier performance
GET    /api/v1/reports/export             # Export PDF/CSV
```

#### Sync
```
POST   /api/v1/sync/push                  # Push local changes to server
GET    /api/v1/sync/pull                  # Pull server changes since timestamp
GET    /api/v1/sync/conflicts             # List unresolved conflicts
POST   /api/v1/sync/conflicts/:id/resolve # Resolve conflict
```

#### Settings
```
GET    /api/v1/settings                   # Get tenant settings
PATCH  /api/v1/settings                   # Update settings
GET    /api/v1/settings/exchange-rates    # Get exchange rates
POST   /api/v1/settings/exchange-rates    # Set exchange rate
```

### Rate Limiting

```
- General API: 100 req/min per tenant
- Auth endpoints: 10 req/min per IP
- Sync push: 30 req/min per device
- Report export: 5 req/min per user
```

---

## Sync Engine Design

### Sync Strategy: Last-Write-Wins with Conflict Detection

ใช้ **Last-Write-Wins (LWW)** เป็น default strategy พร้อม manual conflict resolution สำหรับ critical data:

```
┌─────────────────────────────────────────────────────────┐
│                    Sync Flow                             │
│                                                          │
│  Device                          Backend                 │
│    │                                │                    │
│    │  1. Write to Local DB          │                    │
│    │  2. Add to SyncQueue           │                    │
│    │     (idempotency_key = UUID)   │                    │
│    │                                │                    │
│    │  [When online]                 │                    │
│    │──── POST /sync/push ──────────►│                    │
│    │     {operations: [...]}        │                    │
│    │                                │                    │
│    │                    3. Validate │                    │
│    │                    4. Apply    │                    │
│    │                    5. Detect   │                    │
│    │                       conflicts│                    │
│    │                                │                    │
│    │◄─── {synced: [...],           │                    │
│    │      conflicts: [...]} ────────│                    │
│    │                                │                    │
│    │  6. Update Local DB            │                    │
│    │  7. Show conflict UI           │                    │
│    │     (if any)                   │                    │
└─────────────────────────────────────────────────────────┘
```

### Conflict Detection Rules

| Entity | Conflict Condition | Auto-Resolution |
|---|---|---|
| Stock | qty < 0 หลัง apply | Manual (Manager) |
| Order | order_id ซ้ำ | Idempotency key (skip) |
| Product price | เปลี่ยนพร้อมกัน 2 device | LWW (latest timestamp) |
| Exchange rate | เปลี่ยนพร้อมกัน | LWW (latest timestamp) |
| Shift | 2 shifts open พร้อมกัน | Manual (Manager PIN) |

### SyncQueue Management

```dart
class SyncQueue {
  // เพิ่ม operation เข้า queue
  Future<void> enqueue(SyncOperation op);
  
  // Flush queue ไปยัง backend (เรียกเมื่อ online)
  Future<SyncResult> flush();
  
  // Retry failed operations (exponential backoff)
  Future<void> retryFailed();
  
  // ลบ operations ที่ synced แล้ว (เก็บไว้ 7 วัน)
  Future<void> cleanup();
}
```

### Idempotency

ทุก write operation มี `idempotency_key` = `{device_id}:{entity_type}:{entity_id}:{timestamp}`

Backend จะ:
1. ตรวจสอบ `idempotency_key` ใน database
2. ถ้าพบแล้ว: return cached response (ไม่ process ซ้ำ)
3. ถ้าไม่พบ: process และ store key พร้อม response

### Incremental Sync

```
GET /api/v1/sync/pull?since=2024-01-15T10:00:00Z&entities=products,categories,settings
```

- ดึงเฉพาะ records ที่ `updated_at > since`
- Client เก็บ `last_sync_at` ใน local settings
- Initial sync (device ใหม่): ดึงข้อมูลทั้งหมดของ tenant

---

## KDS Real-time Design

### WebSocket Architecture

```
Flutter KDS Screen
      │
      │  ws://backend/ws/kds?tenant_id=X&token=JWT
      │
      ▼
┌─────────────────────────────────────────┐
│           WebSocket Hub (Go)             │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │  Tenant Room: {tenant_id}        │   │
│  │  ┌──────────┐  ┌──────────────┐  │   │
│  │  │ KDS      │  │ POS          │  │   │
│  │  │ Clients  │  │ Clients      │  │   │
│  │  └──────────┘  └──────────────┘  │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

**Message Types:**
```json
// POS → KDS: New order
{"type": "new_order", "payload": {"order_id": "...", "table": "5", "items": [...]}}

// POS → KDS: Add items to existing order
{"type": "add_items", "payload": {"order_id": "...", "items": [...]}}

// KDS → POS: Item ready
{"type": "item_ready", "payload": {"order_id": "...", "item_id": "..."}}

// KDS → POS: Order ready
{"type": "order_ready", "payload": {"order_id": "...", "table": "5"}}
```

### KDS Screen Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  SOKDEE KDS                    [🔴 3 pending] [🟡 1 warning]    │
├──────────────┬──────────────┬──────────────┬────────────────────┤
│  โต๊ะ 3      │  โต๊ะ 7      │  โต๊ะ 1      │  โต๊ะ 12           │
│  #ORD-045    │  #ORD-046    │  #ORD-047    │  #ORD-048          │
│  12:30       │  12:35       │  12:45       │  12:50             │
│  ─────────── │  ─────────── │  ─────────── │  ──────────────    │
│  ✅ ข้าวผัด  │  🔄 ต้มยำ   │  ⏳ ผัดไทย  │  ⏳ ข้าวมันไก่     │
│  ✅ ไข่ดาว   │  ⏳ ข้าวสวย │  ⏳ น้ำเปล่า │  ⏳ น้ำส้ม         │
│  ⏳ น้ำเปล่า │             │             │                    │
│              │             │             │                    │
│  [พร้อมเสิร์ฟ]│             │             │                    │
│  🟡 15 นาที  │  🔴 32 นาที │  5 นาที     │  2 นาที            │
└──────────────┴──────────────┴──────────────┴────────────────────┘
```

- สีเขียว: เสร็จแล้ว
- สีเหลือง: > 15 นาที (warning)
- สีแดง: > 30 นาที (urgent)
- แต่ละ card แสดง: หมายเลขโต๊ะ, order number, เวลา, รายการ, สถานะแต่ละรายการ

---

## Hardware Integration Design

### Thermal Printer Abstraction Layer

```dart
abstract class PrinterService {
  Future<bool> connect(PrinterConfig config);
  Future<void> printReceipt(ReceiptData data);
  Future<void> printKDSTicket(KDSTicketData data);
  Future<void> openCashDrawer();
  Future<PrinterStatus> getStatus();
  Future<void> disconnect();
}

// Implementations
class UsbPrinterService implements PrinterService { ... }
class BluetoothPrinterService implements PrinterService { ... }
class WifiPrinterService implements PrinterService { ... }

// Factory
class PrinterFactory {
  static PrinterService create(ConnectionType type) { ... }
}
```

**Receipt Template (ESC/POS commands):**
```
[LOGO - ถ้ามี]
[ชื่อร้าน - CENTER, BOLD]
[ที่อยู่/เบอร์โทร]
================================
วันที่: DD/MM/YYYY HH:MM
Order: #ORD-XXXXX
Cashier: [ชื่อ]
================================
[รายการสินค้า]
ชื่อสินค้า    จำนวน    ราคา
--------------------------------
[ส่วนลด]
[ยอดรวม]
================================
ชำระ: [จำนวน] [สกุลเงิน]
เงินทอน: [จำนวน]
================================
[ข้อความท้ายใบเสร็จ]
[QR Code ถ้ามี]
```

### Barcode Scanner

Barcode scanner ทำงานเป็น **HID keyboard input** — ไม่ต้องใช้ plugin พิเศษ:

```dart
// ใช้ RawKeyboardListener หรือ Focus widget
// Scanner ส่ง barcode + Enter key
// App ตรวจจับ input ที่มาเร็วผิดปกติ (< 100ms ต่อ character)
// เพื่อแยกแยะจาก keyboard input ปกติ

class BarcodeInputHandler {
  static const int scanThresholdMs = 100;
  
  void handleKeyEvent(RawKeyEvent event) {
    // Buffer characters, detect Enter
    // If buffer filled in < threshold → treat as barcode scan
    // Trigger product lookup
  }
}
```

### Cash Drawer

Cash drawer เชื่อมต่อผ่าน thermal printer (DK port):

```dart
// ESC/POS command: ESC p m t1 t2
// m = 0 (pin 2) หรือ 1 (pin 5)
// t1, t2 = pulse timing
Future<void> openCashDrawer() async {
  final command = [0x1B, 0x70, 0x00, 0x19, 0xFA];
  await printer.sendRaw(command);
}
```

---

## Security Design

### PIN Hashing

```go
// bcrypt cost factor 12
func HashPIN(pin string) (string, error) {
    return bcrypt.GenerateFromPassword([]byte(pin), 12)
}

func VerifyPIN(pin, hash string) bool {
    return bcrypt.CompareHashAndPassword([]byte(hash), []byte(pin)) == nil
}
```

### Device Fingerprinting

```dart
// Android: Android ID + Build.FINGERPRINT
// Web: Browser fingerprint (user agent + screen + timezone)
String generateDeviceId() {
  final components = [
    Platform.isAndroid ? androidId : webFingerprint,
    deviceModel,
    osVersion,
  ];
  return sha256(components.join('|'));
}
```

### JWT Token Lifecycle

```
Login (PIN) → Access Token (1h) + Refresh Token (30d)
                    │
                    ▼
              [API Requests]
                    │
              Token expires?
                    │
              ┌─────┴──────┐
              │             │
           Yes (401)      No
              │
    POST /auth/refresh
    (Refresh Token)
              │
    New Access Token
    (Refresh Token rotated)
```

### Local DB Encryption

```dart
// ใช้ SQLCipher ผ่าน drift_sqflite_encryption
// Key = SHA256(device_id + tenant_id + app_secret)
// เก็บ key ใน Android Keystore / iOS Secure Enclave

final db = await openEncryptedDatabase(
  path: 'sokdee_pos.db',
  password: await generateDbKey(),
);
```

### Audit Log Actions

| Action | Trigger |
|---|---|
| `user.login` | PIN login สำเร็จ |
| `user.login_failed` | PIN ผิด |
| `user.locked` | ล็อกบัญชี |
| `order.void` | Void transaction |
| `order.refund` | Refund transaction |
| `stock.adjust` | Stock adjustment |
| `product.price_change` | เปลี่ยนราคาสินค้า |
| `shift.open` | เปิด shift |
| `shift.close` | ปิด shift |
| `device.registered` | ลงทะเบียน device ใหม่ |
| `device.revoked` | Revoke device |
| `settings.exchange_rate` | เปลี่ยน exchange rate |

---

## Subscription & Feature Gating

### Feature Flag System

```dart
// Feature flags per plan
const planFeatures = {
  'starter': {
    'kds': false,
    'advanced_reports': false,
    'inventory': false,
    'multi_currency': false,
    'table_management': false,
    'max_users': 3,
    'max_products': 100,
  },
  'basic': {
    'kds': false,
    'advanced_reports': false,
    'inventory': true,
    'multi_currency': true,
    'table_management': false,
    'max_users': 10,
    'max_products': 500,
  },
  'pro': {
    'kds': true,
    'advanced_reports': true,
    'inventory': true,
    'multi_currency': true,
    'table_management': true,
    'max_users': 30,
    'max_products': 2000,
  },
  'enterprise': {
    'kds': true,
    'advanced_reports': true,
    'inventory': true,
    'multi_currency': true,
    'table_management': true,
    'max_users': null,    // unlimited
    'max_products': null, // unlimited
  },
};
```

### Feature Gate Widget

```dart
class FeatureGate extends StatelessWidget {
  final String feature;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final hasFeature = ref.watch(featureProvider(feature));
    if (hasFeature) return child;
    return fallback ?? const SizedBox.shrink();
  }
}

// Usage
FeatureGate(
  feature: 'kds',
  child: KDSButton(),
  fallback: UpgradePlanBanner(),
)
```

### Plan Enforcement Middleware (Backend)

```go
func PlanEnforcementMiddleware(feature string) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            tenant := getTenantFromContext(r.Context())
            if !tenant.Plan.HasFeature(feature) {
                respondError(w, 403, "feature_not_available", 
                    "Upgrade your plan to access this feature")
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```

---

## UX/UI Layout Strategy

### POS หน้าหลัก (Tablet Landscape)

```
┌─────────────────────────────────────────────────────────────────────┐
│  SOKDEE POS  [โต๊ะ 5]  [Cashier: ສົມໃຈ]  [🔴 Offline]  [⚙️]      │
├──────────────────────────────────┬──────────────────────────────────┤
│  CATEGORIES          PRODUCTS    │  ORDER SUMMARY                   │
│  ┌──────┐ ┌──────┐  ┌──┐ ┌──┐  │  ─────────────────────────────   │
│  │อาหาร │ │เครื่อง│  │  │ │  │  │  ข้าวผัดหมู x2      60,000 ₭   │
│  │จาน   │ │ดื่ม  │  └──┘ └──┘  │  ไข่ดาว x1          10,000 ₭   │
│  └──────┘ └──────┘  ┌──┐ ┌──┐  │  น้ำเปล่า x2        10,000 ₭   │
│  ┌──────┐ ┌──────┐  │  │ │  │  │  ─────────────────────────────   │
│  │ของว่าง│ │อื่นๆ │  └──┘ └──┘  │  ส่วนลด:            -5,000 ₭   │
│  └──────┘ └──────┘              │  รวม:               75,000 ₭   │
│                                  │                                  │
│  [🔍 ค้นหา / สแกน barcode]      │  [💳 ชำระเงิน]                  │
│                                  │  [🗑️ ยกเลิก Order]              │
└──────────────────────────────────┴──────────────────────────────────┘
```

### Super Admin Dashboard

```
┌─────────────────────────────────────────────────────────────────────┐
│  SOKDEE POS — Super Admin                              [Logout]      │
├────────────┬────────────────────────────────────────────────────────┤
│  📊 Overview│  Tenants                                               │
│  👥 Tenants │  ┌──────────────────────────────────────────────────┐ │
│  📦 Plans   │  │ ชื่อร้าน    │ Plan    │ สถานะ  │ หมดอายุ │ Action│ │
│  ⚙️ Settings│  │ ร้านข้าวดี  │ Pro     │ Active │ 30 วัน  │ [...]  │ │
│             │  │ ร้านค้าลาว  │ Basic   │ Active │ 7 วัน ⚠️│ [...]  │ │
│             │  │ คลังสินค้า  │ Starter │ Suspend│ หมดแล้ว │ [...]  │ │
│             │  └──────────────────────────────────────────────────┘ │
│             │  [+ สร้าง Tenant ใหม่]                                │
└────────────┴────────────────────────────────────────────────────────┘
```

### Responsive Breakpoints

```dart
class AppBreakpoints {
  static const double phone = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

// Phone: Bottom navigation bar, single column
// Tablet portrait: Side drawer, 2-column POS
// Tablet landscape / Web: Full 3-column POS layout
```

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system — essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

---

### Property 1: Plan User Limit Enforcement

*For any* tenant with a non-Enterprise subscription plan, attempting to add users beyond the plan's maximum user count should be rejected, and the user count should remain unchanged.

**Validates: Requirements 1.2, 1.3, 1.4, 1.6, 3.2**

---

### Property 2: Tenant Creation Returns Unique ID

*For any* valid tenant creation request submitted by Super Admin, the system should return a unique Tenant ID that does not conflict with any existing tenant, along with initial Owner credentials.

**Validates: Requirements 2.2**

---

### Property 3: Suspended Tenant Blocks Login

*For any* tenant in suspended status, any login attempt by any user belonging to that tenant should be rejected with an appropriate error.

**Validates: Requirements 2.4**

---

### Property 4: Expired Tenant Read-Only Enforcement

*For any* tenant whose subscription has expired, all write operations (create order, update stock, add user) should be rejected, while read operations should succeed.

**Validates: Requirements 2.7**

---

### Property 5: Role-Based Access Control

*For any* user and any action, if that action requires a role higher than the user's assigned role, the system should reject the request with an authorization error.

**Validates: Requirements 3.3, 3.4, 3.5, 3.6**

---

### Property 6: PIN Length Validation

*For any* PIN string with length outside the range [4, 6] digits, or containing non-numeric characters, the system should reject it and not store it.

**Validates: Requirements 3.7**

---

### Property 7: Order Total Calculation Correctness

*For any* order containing any combination of items, discounts, and tax rates, the calculated total should equal: sum(item.unit_price × item.quantity) − sum(discounts) + tax_amount.

**Validates: Requirements 5.4**

---

### Property 8: Cash Change Calculation

*For any* cash payment where the tendered amount is greater than or equal to the order total, the change returned should equal tendered_amount − order_total, and should never be negative.

**Validates: Requirements 5.5**

---

### Property 9: Split Payment Currency Sum

*For any* split payment across multiple currencies, the sum of all payment amounts converted to LAK using their respective exchange rates should equal the order total in LAK.

**Validates: Requirements 5.9**

---

### Property 10: Sale Decreases Stock

*For any* completed payment containing product items with stock tracking enabled, the stock quantity of each sold product (or variant) should decrease by exactly the sold quantity after the transaction.

**Validates: Requirements 5.10, 8.2**

---

### Property 11: KDS Order Contains Required Fields

*For any* KDS order, the rendered display data should contain: table number, order number, list of items with quantities, special notes (if any), and the time the order was received.

**Validates: Requirements 7.3**

---

### Property 12: Low Stock Notification Trigger

*For any* product where the current stock quantity is less than or equal to the configured minimum stock level, a notification should exist in the system for the tenant's Manager and Owner.

**Validates: Requirements 8.3**

---

### Property 13: Variant Stock Independence

*For any* product with multiple variants, selling one variant should decrease only that variant's stock quantity, leaving all other variants' stock quantities unchanged.

**Validates: Requirements 8.7**

---

### Property 14: Audit Log Completeness

*For any* important action (login, void transaction, refund, stock adjustment, price change, shift open/close, device registration), an audit log entry should exist containing the user ID, timestamp, action type, and relevant entity details.

**Validates: Requirements 8.9, 14.5**

---

### Property 15: Offline Operations Succeed

*For any* POS operation (create order, add item, process payment) performed while the device is in offline mode, the operation should complete successfully using Local DB data and be added to the SyncQueue.

**Validates: Requirements 10.1**

---

### Property 16: Sync Idempotency

*For any* sync operation applied to the backend multiple times with the same idempotency key, the resulting backend state should be identical to applying the operation exactly once.

**Validates: Requirements 10.8**

---

### Property 17: Offline-Online Round Trip

*For any* set of operations performed offline and subsequently synced, the backend state after sync should reflect all offline operations without duplication or data loss (excluding conflict cases).

**Validates: Requirements 10.3**

---

### Property 18: Currency Conversion Correctness

*For any* payment amount in a foreign currency (THB or USD) with a configured exchange rate, the converted LAK amount should equal amount × exchange_rate, rounded to the nearest whole LAK.

**Validates: Requirements 11.3**

---

### Property 19: Exchange Rate Temporal Isolation

*For any* two transactions T1 and T2 where T1 is created before an exchange rate update and T2 is created after, T1 should use the old rate and T2 should use the new rate.

**Validates: Requirements 11.6**

---

### Property 20: Unconfigured Currency Rejection

*For any* currency that has no exchange rate configured in the system, any attempt to use that currency for payment should be rejected.

**Validates: Requirements 11.7**

---

### Property 21: PIN Lockout After Failed Attempts

*For any* user account, after exactly 5 consecutive failed PIN attempts, the account should be locked and all subsequent login attempts (including correct PIN) should be rejected until the lockout period expires.

**Validates: Requirements 14.2**

---

### Property 22: Shift Summary Correctness

*For any* closed shift, the shift summary's total_sales should equal the sum of all paid order totals within that shift, and cash_difference should equal actual_cash − expected_cash.

**Validates: Requirements 17.3**

---

### Property 23: Single Active Shift Per Cashier

*For any* cashier who already has an active (open) shift, attempting to open a second shift should be rejected unless a Manager approves via PIN.

**Validates: Requirements 17.6**

---

### Property 24: Refund Requires Authorization

*For any* refund request initiated by a Cashier without Manager or Owner PIN approval, the system should reject the request and not process the refund.

**Validates: Requirements 21.1, 21.7**

---

### Property 25: Refund Restores Stock

*For any* refund of a product with stock tracking enabled, the product's stock quantity should increase by exactly the refunded quantity after the refund is processed.

**Validates: Requirements 21.3**

---

### Property 26: Void Within Shift Only

*For any* void operation, it should only be permitted when the target order belongs to the currently active shift. Attempting to void an order from a closed shift should be rejected (use refund instead).

**Validates: Requirements 21.5**

---

## Error Handling

### Error Response Format (Backend)

```json
{
  "error": {
    "code": "plan_limit_exceeded",
    "message": "Cannot add more users. Your plan allows maximum 10 users.",
    "details": {
      "current_count": 10,
      "max_allowed": 10,
      "plan": "basic"
    }
  }
}
```

### Error Categories

| Category | HTTP Status | Examples |
|---|---|---|
| Authentication | 401 | Invalid/expired token, wrong PIN |
| Authorization | 403 | Role insufficient, plan feature not available |
| Validation | 422 | Invalid PIN length, missing required fields |
| Business Logic | 409 | Plan limit exceeded, stock = 0, currency not configured |
| Not Found | 404 | Product not found, order not found |
| Server Error | 500 | Database error, sync failure |

### Flutter Error Handling

```dart
// Global error handler ใน Riverpod
class AppErrorHandler {
  void handle(Object error, StackTrace stack) {
    if (error is UnauthorizedException) {
      // Redirect to login
    } else if (error is NetworkException) {
      // Switch to offline mode
    } else if (error is BusinessException) {
      // Show user-friendly message
    } else {
      // Log to crash reporting
    }
  }
}
```

### Offline Error Handling

- Network timeout → switch to offline mode อัตโนมัติ
- Sync conflict → เพิ่มเข้า conflict_logs, แจ้งเตือน Manager
- Printer error → แสดง dialog ให้ retry หรือ skip
- Barcode not found → แสดง "ไม่พบสินค้า" พร้อมเสนอเพิ่มสินค้าใหม่

---

## Testing Strategy

### Dual Testing Approach

ระบบใช้ทั้ง **Unit Tests** และ **Property-Based Tests** ร่วมกัน:

- **Unit Tests**: ตรวจสอบ specific examples, edge cases, integration points
- **Property Tests**: ตรวจสอบ universal properties ด้วย random inputs จำนวนมาก

### Property-Based Testing Library

- **Dart/Flutter**: `package:glados` หรือ `package:fast_check` (Dart port ของ fast-check)
- **Go (Backend)**: `gopter` หรือ `rapid`
- แต่ละ property test ต้องรัน **อย่างน้อย 100 iterations**

### Property Test Configuration

```dart
// ตัวอย่าง property test ด้วย glados
// Feature: sokdee-pos, Property 7: Order Total Calculation Correctness
test('order total = sum(items) - discounts + tax', () {
  Glados2<List<OrderItem>, Discount>().test(
    'order total calculation',
    (items, discount) {
      final order = Order(items: items, discount: discount);
      final expected = items.fold(0.0, (sum, i) => sum + i.lineTotal)
          - discount.amount
          + order.taxAmount;
      expect(order.total, closeTo(expected, 0.01));
    },
  );
});
```

```go
// ตัวอย่าง property test ด้วย rapid (Go)
// Feature: sokdee-pos, Property 16: Sync Idempotency
func TestSyncIdempotency(t *testing.T) {
    rapid.Check(t, func(t *rapid.T) {
        op := generateSyncOperation(t)
        
        result1 := applySync(op)
        result2 := applySync(op) // apply ซ้ำ
        
        assert.Equal(t, result1, result2)
    })
}
```

### Tag Format

ทุก property test ต้องมี comment tag:
```
// Feature: sokdee-pos, Property {N}: {property_title}
```

### Unit Test Focus Areas

- **Specific examples**: การคำนวณเงินทอน, การแปลงสกุลเงิน
- **Edge cases**: Stock = 0, PIN ผิดครั้งที่ 5, Enterprise plan (unlimited)
- **Integration**: Order → Payment → Stock update flow
- **Error conditions**: Suspended tenant login, expired subscription write

### Test Coverage Targets

| Module | Unit Test | Property Test |
|---|---|---|
| Order calculation | ✅ | ✅ Property 7, 8, 9 |
| Stock management | ✅ | ✅ Property 10, 13, 25 |
| Auth & PIN | ✅ | ✅ Property 6, 21 |
| Sync engine | ✅ | ✅ Property 16, 17 |
| Currency conversion | ✅ | ✅ Property 18, 19, 20 |
| Role-based access | ✅ | ✅ Property 5 |
| Plan enforcement | ✅ | ✅ Property 1, 4 |
| Shift management | ✅ | ✅ Property 22, 23 |
| Refund/Void | ✅ | ✅ Property 24, 25, 26 |
| Audit log | ✅ | ✅ Property 14 |
| KDS display | ✅ | ✅ Property 11 |
