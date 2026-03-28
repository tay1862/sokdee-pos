# Implementation Plan: SOKDEE POS

## Overview

แผนการ implement SOKDEE POS แบบ incremental โดยเริ่มจาก infrastructure และ backend core ก่อน ตามด้วย Flutter app และ feature modules ต่างๆ แต่ละ phase สร้างต่อยอดจาก phase ก่อนหน้า และ wire เข้าด้วยกันในขั้นตอนสุดท้าย

Stack: Flutter (Android APK + Web) + Go backend + PostgreSQL + SQLite/Drift + Riverpod + GoRouter + WebSocket

---

## Tasks

- [x] 1. Phase 1: Project Setup & Infrastructure
  - [x] 1.1 สร้าง Flutter project พร้อม folder structure ตาม feature-based architecture
    - สร้าง `lib/core/` และ `lib/features/` ตาม design document
    - เพิ่ม dependencies: `flutter_riverpod`, `go_router`, `drift`, `dio`, `web_socket_channel`, `flutter_localizations`
    - ตั้งค่า `analysis_options.yaml` และ linting rules
    - _Requirements: 15.1, 15.2, 15.4_

  - [x] 1.2 ตั้งค่า Go backend project structure
    - สร้าง `cmd/server/`, `internal/`, `pkg/` ตาม design document
    - เพิ่ม dependencies: `chi` router, `pgx` PostgreSQL driver, `golang-jwt/jwt`, `bcrypt`, `gorilla/websocket`
    - สร้าง `Makefile` สำหรับ build, test, migrate commands
    - _Requirements: 15.1_

  - [x] 1.3 ตั้งค่า PostgreSQL database และ migration system
    - สร้าง migration files สำหรับทุก table ตาม Data Models ใน design document
    - ลำดับ migration: `subscription_plans` → `tenants` → `users` → `device_registrations` → `categories` → `products` → `product_variants` → `product_modifiers` → `stock_transactions` → `tables` → `shifts` → `orders` → `order_items` → `payments` → `exchange_rates` → `kds_orders` → `discounts` → `sync_queue` → `conflict_logs` → `audit_logs` → `refunds` → `void_logs` → `shift_summaries` → `tenant_subscriptions`
    - เพิ่ม RLS policies สำหรับทุก tenant-scoped table
    - สร้าง indexes สำหรับ `tenant_id`, `created_at`, `status` columns
    - _Requirements: 2.1, 14.4_

  - [x] 1.4 ตั้งค่า Drift local database บน Flutter
    - สร้าง Drift schema ที่ mirror PostgreSQL schema พร้อม `is_synced` และ `local_updated_at` columns
    - สร้าง `AppDatabase` class และ DAOs สำหรับแต่ละ entity
    - ตั้งค่า database migrations สำหรับ schema versioning
    - _Requirements: 10.1, 20.4_

  - [ ]* 1.5 ตั้งค่า CI/CD pipeline (GitHub Actions)
    - Flutter: `flutter test`, `flutter build apk`, `flutter build web`
    - Go: `go test ./...`, `go build`
    - _Requirements: 15.1_

- [x] 2. Phase 2: Core Backend — Auth, Multi-Tenancy & Subscription
  - [x] 2.1 Implement PIN authentication และ JWT token management (Go)
    - สร้าง `internal/auth/` package: `HashPIN`, `VerifyPIN` ด้วย bcrypt cost 12
    - Implement `POST /api/v1/auth/login` — PIN login → Access Token (1h) + Refresh Token (30d)
    - Implement `POST /api/v1/auth/refresh` — rotate refresh token
    - Implement `POST /api/v1/auth/logout` — revoke refresh token
    - JWT payload: `sub`, `tenant_id`, `role`, `device_id`, `exp`
    - _Requirements: 14.1, 14.4_

  - [ ]* 2.2 Write property test for PIN hashing
    - **Property 6: PIN Length Validation**
    - **Validates: Requirements 3.7**

  - [x] 2.3 Implement device registration endpoints (Go)
    - `POST /api/v1/auth/device/register` — บันทึก device_id, device_name, os_version
    - `DELETE /api/v1/auth/device/:id` — revoke device
    - ตรวจสอบ unregistered device login → trigger Owner notification
    - _Requirements: 14.8, 14.9, 14.10_

  - [x] 2.4 Implement multi-tenancy middleware และ RLS (Go)
    - สร้าง `TenantMiddleware`: extract JWT → set `tenant_id` ใน context → `SET app.current_tenant`
    - สร้าง `RoleMiddleware`: ตรวจสอบ role ก่อน handler
    - สร้าง `PlanEnforcementMiddleware`: ตรวจสอบ feature flag ตาม plan
    - _Requirements: 1.7, 3.6_

  - [ ]* 2.5 Write property test for role-based access control
    - **Property 5: Role-Based Access Control**
    - **Validates: Requirements 3.3, 3.4, 3.5, 3.6**

  - [x] 2.6 Implement subscription plan management API (Go)
    - `GET/POST /api/v1/admin/plans` — list และ create plans
    - `PATCH /api/v1/admin/plans/:id` — update plan features/limits
    - Plan feature flags: `kds`, `advanced_reports`, `inventory`, `multi_currency`, `table_management`, `max_users`, `max_products`
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

  - [ ]* 2.7 Write property test for plan user limit enforcement
    - **Property 1: Plan User Limit Enforcement**
    - **Validates: Requirements 1.2, 1.3, 1.4, 1.6, 3.2**

  - [x] 2.8 Implement tenant CRUD API (Go)
    - `GET/POST /api/v1/admin/tenants` — list และ create tenants
    - `GET/PATCH /api/v1/admin/tenants/:id` — get detail และ update
    - `PATCH /api/v1/admin/tenants/:id/suspend` และ `/activate`
    - Tenant creation สร้าง Owner credentials เริ่มต้น
    - _Requirements: 2.1, 2.2, 2.3, 2.5_

  - [ ]* 2.9 Write property test for tenant creation uniqueness
    - **Property 2: Tenant Creation Returns Unique ID**
    - **Validates: Requirements 2.2**

  - [ ]* 2.10 Write property test for suspended tenant login blocking
    - **Property 3: Suspended Tenant Blocks Login**
    - **Validates: Requirements 2.4**

  - [ ]* 2.11 Write property test for expired tenant read-only enforcement
    - **Property 4: Expired Tenant Read-Only Enforcement**
    - **Validates: Requirements 2.7**

  - [x] 2.12 Implement user management API (Go)
    - `GET/POST /api/v1/users` — list และ create users (tenant-scoped)
    - `PATCH /api/v1/users/:id` — update user
    - `DELETE /api/v1/users/:id` — deactivate user
    - `PATCH /api/v1/users/:id/pin` — change PIN
    - ตรวจสอบ plan user limit ก่อน create
    - _Requirements: 3.2, 3.7_

  - [x] 2.13 Implement PIN lockout mechanism (Go)
    - นับ `failed_pin_attempts` ใน users table
    - หลัง 5 ครั้ง: set `locked_until = NOW() + 15 minutes`
    - ตรวจสอบ `locked_until` ก่อน verify PIN ทุกครั้ง
    - _Requirements: 14.2_

  - [ ]* 2.14 Write property test for PIN lockout
    - **Property 21: PIN Lockout After Failed Attempts**
    - **Validates: Requirements 14.2**

  - [x] 2.15 Implement audit log middleware (Go)
    - สร้าง `AuditLogger` ที่บันทึก action, entity_type, entity_id, user_id, ip_address, device_id
    - Wrap handlers สำหรับ: login, void, refund, stock adjust, price change, shift open/close, device register/revoke
    - _Requirements: 14.5, 14.6_

  - [ ]* 2.16 Write property test for audit log completeness
    - **Property 14: Audit Log Completeness**
    - **Validates: Requirements 8.9, 14.5**

  - [x] 2.17 Checkpoint — ทดสอบ auth flow ครบวงจร
    - Ensure all tests pass, ask the user if questions arise.

- [x] 3. Phase 3: Flutter Core — Architecture, Auth & Super Admin UI
  - [x] 3.1 ตั้งค่า Riverpod providers และ app architecture
    - สร้าง `core/` providers: `authProvider`, `tenantProvider`, `connectivityProvider`
    - สร้าง `AppErrorHandler` สำหรับ global error handling (UnauthorizedException, NetworkException, BusinessException)
    - ตั้งค่า `ProviderScope` ใน `main.dart`
    - _Requirements: 15.4_

  - [x] 3.2 ตั้งค่า GoRouter navigation
    - สร้าง route structure ตาม design: `/login`, `/setup-wizard`, `/super-admin/*`, `/pos/*`, `/kds`, `/inventory`, `/reports`, `/settings`, `/shifts`
    - Implement route guards: redirect to `/login` ถ้าไม่ได้ auth, redirect ตาม role
    - _Requirements: 3.6_

  - [x] 3.3 ตั้งค่า i18n (Lao/Thai/English)
    - สร้าง ARB files สำหรับ `lo`, `th`, `en`
    - ตั้งค่า `flutter_localizations` และ `intl`
    - สร้าง `LocaleProvider` ที่เปลี่ยนภาษาได้ทันทีโดยไม่ restart
    - _Requirements: 13.1, 13.2, 13.3, 13.4_

  - [x] 3.4 สร้าง responsive layout framework
    - สร้าง `AppBreakpoints` constants: phone (600), tablet (1024), desktop (1440)
    - สร้าง `ResponsiveWidget` wrapper ที่รับ `phone`, `tablet`, `desktop` widgets
    - สร้าง `LayoutBuilder`-based adaptive layouts
    - _Requirements: 15.4_

  - [x] 3.5 Implement PIN login screen
    - สร้าง `LoginScreen` พร้อม PIN numpad (4-6 หลัก)
    - แสดง error message เมื่อ PIN ผิด, แสดง lockout countdown เมื่อถูกล็อก
    - เรียก `POST /api/v1/auth/login` และเก็บ JWT ใน secure storage
    - Auto-logout หลัง idle 10 นาที (configurable)
    - _Requirements: 14.1, 14.2, 14.3_

  - [x] 3.6 Implement Super Admin module
    - สร้าง `SuperAdminDashboard` พร้อม sidebar navigation
    - สร้าง `TenantListScreen`: แสดง tenant list พร้อม plan, status, วันหมดอายุ
    - สร้าง `TenantDetailScreen`: แสดง tenant detail, suspend/activate actions
    - สร้าง `PlanManagementScreen`: CRUD subscription plans
    - _Requirements: 2.3, 2.5, 1.1_

  - [x] 3.7 Implement Setup Wizard UI
    - สร้าง multi-step wizard: ชื่อร้าน → ประเภทร้าน → subscription plan → จำนวนพนักงาน → (ถ้าร้านอาหาร: จำนวนโต๊ะ + KDS)
    - ข้ามขั้นตอนโต๊ะ/KDS อัตโนมัติถ้าไม่ใช่ร้านอาหาร
    - เรียก `POST /api/v1/admin/tenants` เมื่อ wizard เสร็จ
    - _Requirements: 4.1, 4.2, 4.3, 4.6_

  - [x] 3.8 Implement FeatureGate widget
    - สร้าง `FeatureGate` widget ที่ตรวจสอบ plan feature flags
    - สร้าง `featureProvider` ที่ดึง features จาก JWT/tenant settings
    - แสดง `UpgradePlanBanner` เมื่อ feature ไม่พร้อมใช้งาน
    - _Requirements: 1.6, 1.7_

  - [x] 3.9 Checkpoint — ทดสอบ auth flow และ navigation ครบวงจร
    - Ensure all tests pass, ask the user if questions arise.

- [x] 4. Phase 4: POS Core — Products, Orders & Payments
  - [x] 4.1 Implement product & category management API (Go)
    - `GET/POST/PATCH/DELETE /api/v1/products` — CRUD products
    - `GET/POST /api/v1/categories` — CRUD categories (รองรับ parent_id สำหรับ sub-categories)
    - `POST /api/v1/products/import` — CSV import
    - ตรวจสอบ plan product limit ก่อน create
    - _Requirements: 8.1, 18.1, 18.2, 18.3_

  - [x] 4.2 Implement product & category management UI (Flutter)
    - สร้าง `InventoryScreen` พร้อม product list, search, filter by category
    - สร้าง product form: ชื่อ, หมวดหมู่, ราคาขาย, ราคาทุน, หน่วย, barcode, min_stock
    - สร้าง category management: CRUD categories พร้อม sort_order
    - สร้าง modifier management สำหรับร้านอาหาร (ระดับความเผ็ด, ตัวเลือกพิเศษ)
    - _Requirements: 8.1, 18.4, 18.5_

  - [x] 4.3 Implement core POS screen (Flutter)
    - สร้าง `POSScreen` พร้อม 3-column layout (categories | products | order summary)
    - สร้าง `CartNotifier` (StateNotifierProvider): add item, update qty, remove item, apply discount
    - แสดง real-time order total, discount, tax calculation
    - ซ่อนสินค้าที่ stock = 0 และแสดง "หมด" badge
    - _Requirements: 5.1, 5.3, 5.4, 8.4_

  - [ ]* 4.4 Write property test for order total calculation
    - **Property 7: Order Total Calculation Correctness**
    - **Validates: Requirements 5.4**

  - [x] 4.5 Implement barcode scanner integration (Flutter)
    - สร้าง `BarcodeInputHandler` ที่ตรวจจับ HID keyboard input (< 100ms per character)
    - เมื่อสแกน barcode: ค้นหาสินค้าใน local DB → เพิ่มลงใน cart
    - ถ้าไม่พบ: แสดง dialog "ไม่พบสินค้า" พร้อมเสนอเพิ่มสินค้าใหม่
    - _Requirements: 5.1, 5.2, 9.4_

  - [x] 4.6 Implement payment processing (Go + Flutter)
    - Go: `POST /api/v1/orders` — create order พร้อม idempotency_key
    - Go: `POST /api/v1/orders/:id/pay` — process payment (cash, qr, transfer)
    - Flutter: `PaymentScreen` พร้อม 3 payment methods
    - Cash: คำนวณเงินทอน real-time
    - QR: แสดง static QR image + confirm button
    - Transfer: บันทึกข้อมูลการโอน + confirm
    - Split payment: รองรับ LAK + THB + USD ในออเดอร์เดียว
    - _Requirements: 5.5, 5.6, 5.7, 5.9_

  - [ ]* 4.7 Write property test for cash change calculation
    - **Property 8: Cash Change Calculation**
    - **Validates: Requirements 5.5**

  - [ ]* 4.8 Write property test for split payment currency sum
    - **Property 9: Split Payment Currency Sum**
    - **Validates: Requirements 5.9**

  - [x] 4.9 Implement stock deduction on sale (Go)
    - หลัง payment สำเร็จ: สร้าง `stock_transactions` records (type = 'sale', quantity = negative)
    - อัปเดต `product_variants.stock_qty` หรือ product stock
    - _Requirements: 5.10, 8.2_

  - [ ]* 4.10 Write property test for sale decreases stock
    - **Property 10: Sale Decreases Stock**
    - **Validates: Requirements 5.10, 8.2**

  - [x] 4.11 Implement thermal printer integration (Flutter)
    - สร้าง `PrinterService` abstract class พร้อม USB, Bluetooth, WiFi implementations
    - สร้าง `PrinterFactory` สำหรับ create printer ตาม connection type
    - Implement ESC/POS receipt template ตาม design (ชื่อร้าน, วันที่, รายการ, ยอด, เงินทอน)
    - รองรับ customizable template (logo, footer text)
    - แสดง error dialog ถ้า printer ไม่ตอบสนอง
    - _Requirements: 9.2, 9.3, 9.5, 9.6, 9.7_

  - [x] 4.12 Implement cash drawer integration (Flutter)
    - ส่ง ESC/POS command `[0x1B, 0x70, 0x00, 0x19, 0xFA]` ผ่าน printer
    - เรียกอัตโนมัติเมื่อชำระด้วยเงินสดสำเร็จ
    - _Requirements: 9.1_

  - [x] 4.13 Implement void order (Go + Flutter)
    - Go: `POST /api/v1/orders/:id/void` — บันทึก void_log พร้อม reason, user, timestamp
    - ตรวจสอบว่า order อยู่ใน active shift เดียวกัน
    - Flutter: void confirmation dialog พร้อม reason input
    - _Requirements: 5.11, 5.12_

  - [ ]* 4.14 Write property test for void within shift only
    - **Property 26: Void Within Shift Only**
    - **Validates: Requirements 21.5**

  - [x] 4.15 Implement exchange rate management (Go + Flutter)
    - Go: `GET/POST /api/v1/settings/exchange-rates` — get และ set exchange rates
    - Flutter: exchange rate settings screen สำหรับ Owner/Manager
    - ปิดการใช้งานสกุลเงินที่ยังไม่มี exchange rate
    - _Requirements: 11.2, 11.6, 11.7, 11.8_

  - [ ]* 4.16 Write property test for currency conversion correctness
    - **Property 18: Currency Conversion Correctness**
    - **Validates: Requirements 11.3**

  - [ ]* 4.17 Write property test for exchange rate temporal isolation
    - **Property 19: Exchange Rate Temporal Isolation**
    - **Validates: Requirements 11.6**

  - [ ]* 4.18 Write property test for unconfigured currency rejection
    - **Property 20: Unconfigured Currency Rejection**
    - **Validates: Requirements 11.7**

  - [x] 4.19 Checkpoint — ทดสอบ POS flow ครบวงจร (order → payment → receipt → stock)
    - Ensure all tests pass, ask the user if questions arise.

- [ ] 5. Phase 5: Restaurant Features — Tables & KDS
  - [x] 5.1 Implement table management API (Go)
    - `GET/POST/PATCH /api/v1/tables` — CRUD tables
    - `POST /api/v1/tables/merge` — merge tables
    - `POST /api/v1/tables/:id/move` — move order to another table (requires Manager PIN)
    - _Requirements: 6.4, 6.5_

  - [x] 5.2 Implement floor plan UI (Flutter)
    - สร้าง `TableFloorPlanScreen` แสดง grid ของโต๊ะพร้อมสถานะ (ว่าง/มีลูกค้า/รอชำระ)
    - แสดงเวลาที่เปิด order บนแต่ละโต๊ะ
    - Tap โต๊ะว่าง → เปิด order ใหม่, tap โต๊ะที่มีลูกค้า → เปิด order screen
    - FeatureGate: แสดงเฉพาะ store_type = restaurant
    - _Requirements: 6.1, 6.2, 6.7_

  - [x] 5.3 Implement multi-round ordering (Flutter)
    - สร้าง `OrderScreen` ที่รองรับการเพิ่มรายการหลายรอบโดยไม่ต้องชำระก่อน
    - ส่งรายการใหม่ไปยัง KDS ทันทีเมื่อ confirm
    - _Requirements: 6.3, 6.6_

  - [x] 5.4 Implement KDS WebSocket hub (Go)
    - สร้าง `internal/kds/` package: WebSocket hub พร้อม tenant rooms
    - Implement `ws://backend/ws/kds?tenant_id=X&token=JWT` endpoint
    - Message types: `new_order`, `add_items`, `item_ready`, `order_ready`
    - Broadcast ไปยัง clients ใน tenant room เดียวกัน
    - _Requirements: 7.1, 7.2_

  - [x] 5.5 Implement KDS screen (Flutter)
    - สร้าง `KDSScreen` พร้อม StreamProvider สำหรับ WebSocket orders
    - แสดง order cards: หมายเลขโต๊ะ, order number, รายการ, เวลา, สถานะแต่ละรายการ
    - สีตาม elapsed time: ปกติ → เหลือง (>15 นาที) → แดง (>30 นาที)
    - Kitchen staff กด confirm รายการ → ส่ง `item_ready` message
    - เมื่อทุกรายการเสร็จ → แสดง "พร้อมเสิร์ฟ" + แจ้งเตือน cashier
    - _Requirements: 7.3, 7.4, 7.5, 7.6, 7.7_

  - [ ]* 5.6 Write property test for KDS order required fields
    - **Property 11: KDS Order Contains Required Fields**
    - **Validates: Requirements 7.3**

  - [x] 5.7 Implement kitchen ticket printing (Flutter)
    - สร้าง `printKDSTicket` ใน PrinterService
    - พิมพ์อัตโนมัติเมื่อ KDS รับ order ใหม่
    - _Requirements: 7.8_

  - [x] 5.8 Checkpoint — ทดสอบ restaurant flow (table → order → KDS → payment)
    - Ensure all tests pass, ask the user if questions arise.

- [x] 6. Phase 6: Inventory Management
  - [x] 6.1 Implement stock in และ adjustment API (Go)
    - `POST /api/v1/stock/in` — stock in พร้อม quantity, cost_price, date
    - `POST /api/v1/stock/adjust` — stock adjustment พร้อม reason
    - `GET /api/v1/stock/transactions` — transaction history
    - บันทึก audit log ทุก stock transaction
    - _Requirements: 8.5, 8.6, 8.9_

  - [x] 6.2 Implement stock management UI (Flutter)
    - สร้าง stock in form: เลือกสินค้า, จำนวน, ราคาทุน, วันที่
    - สร้าง stock adjustment form: เลือกสินค้า, จำนวน, เหตุผล
    - สร้าง stock transaction history list
    - _Requirements: 8.5, 8.6_

  - [x] 6.3 Implement product variants (Go + Flutter)
    - Go: CRUD `product_variants` — name, barcode, sell_price, cost_price, stock_qty
    - Flutter: variant management UI ใน product form
    - POS screen: แสดง variant selector เมื่อสินค้ามี `has_variants = true`
    - _Requirements: 8.7_

  - [ ]* 6.4 Write property test for variant stock independence
    - **Property 13: Variant Stock Independence**
    - **Validates: Requirements 8.7**

  - [x] 6.5 Implement CSV product import (Go + Flutter)
    - Go: `POST /api/v1/products/import` — parse CSV, validate, bulk insert
    - Flutter: file picker + import progress UI
    - _Requirements: 8.8_

  - [x] 6.6 Implement low stock notification trigger (Go)
    - หลัง stock transaction: ตรวจสอบ `stock_qty <= min_stock`
    - ถ้าใช่: สร้าง notification record สำหรับ Manager และ Owner ของ tenant
    - _Requirements: 8.3, 19.1_

  - [ ]* 6.7 Write property test for low stock notification trigger
    - **Property 12: Low Stock Notification Trigger**
    - **Validates: Requirements 8.3**

- [x] 7. Phase 7: Offline Support & Sync Engine
  - [x] 7.1 Implement SyncQueue ใน Flutter
    - สร้าง `SyncQueue` class: `enqueue(SyncOperation)`, `flush()`, `retryFailed()`, `cleanup()`
    - ทุก write operation เพิ่มเข้า local `sync_queue` table พร้อม `idempotency_key = {device_id}:{entity_type}:{entity_id}:{timestamp}`
    - Exponential backoff สำหรับ retry failed operations
    - Cleanup synced operations หลัง 7 วัน
    - _Requirements: 10.1, 10.8_

  - [ ]* 7.2 Write property test for offline operations succeed
    - **Property 15: Offline Operations Succeed**
    - **Validates: Requirements 10.1**

  - [x] 7.3 Implement sync push endpoint (Go)
    - `POST /api/v1/sync/push` — รับ batch operations จาก device
    - ตรวจสอบ idempotency_key ก่อน process
    - Apply operations ตาม entity_type
    - Detect conflicts ตาม rules ใน design (stock < 0, duplicate order, concurrent price change)
    - Return `{synced: [...], conflicts: [...]}`
    - _Requirements: 10.3, 10.4, 10.8_

  - [ ]* 7.4 Write property test for sync idempotency
    - **Property 16: Sync Idempotency**
    - **Validates: Requirements 10.8**

  - [ ]* 7.5 Write property test for offline-online round trip
    - **Property 17: Offline-Online Round Trip**
    - **Validates: Requirements 10.3**

  - [x] 7.6 Implement incremental sync pull endpoint (Go)
    - `GET /api/v1/sync/pull?since=TIMESTAMP&entities=products,categories,settings`
    - ดึงเฉพาะ records ที่ `updated_at > since`
    - Initial sync (device ใหม่): ดึงข้อมูลทั้งหมดของ tenant
    - _Requirements: 10.6, 10.9_

  - [x] 7.7 Implement conflict resolution UI (Flutter)
    - สร้าง `ConflictResolutionScreen`: แสดง conflict list พร้อม local vs server values
    - ตัวเลือก: ใช้ค่า local / ใช้ค่า server / ระบุค่าใหม่
    - `POST /api/v1/sync/conflicts/:id/resolve`
    - _Requirements: 10.4, 10.5_

  - [x] 7.8 Implement connectivity monitoring (Flutter)
    - สร้าง `connectivityProvider` (StreamProvider) ที่ monitor network status
    - แสดง offline indicator ที่มองเห็นชัดเจนเมื่อ offline
    - เมื่อ online: trigger `SyncQueue.flush()` อัตโนมัติภายใน 60 วินาที
    - _Requirements: 10.2, 10.3_

  - [x] 7.9 Implement local DB encryption (Flutter)
    - ตั้งค่า SQLCipher ผ่าน `drift_sqflite_encryption`
    - Key = `SHA256(device_id + tenant_id + app_secret)`
    - เก็บ key ใน Android Keystore
    - _Requirements: 20.4_

  - [x] 7.10 Checkpoint — ทดสอบ offline → online sync flow ครบวงจร
    - Ensure all tests pass, ask the user if questions arise.

- [x] 8. Phase 8: Financial Features — Discounts, Shifts & Refunds
  - [x] 8.1 Implement discount & promotion management (Go + Flutter)
    - Go: `GET/POST/PATCH /api/v1/discounts` — CRUD discounts (percentage/fixed, item/order scope)
    - Go: ตรวจสอบ active discounts เมื่อเพิ่มสินค้าลงใน order
    - Flutter: discount management screen สำหรับ Manager
    - Flutter: ใช้ discount อัตโนมัติเมื่อสินค้ามี active discount
    - Flutter: special discount ต้องการ Manager/Owner PIN approval
    - _Requirements: 16.1, 16.2, 16.3, 16.4, 16.5_

  - [x] 8.2 Implement shift management API (Go)
    - `POST /api/v1/shifts/open` — เปิด shift พร้อม opening_balance
    - `POST /api/v1/shifts/:id/close` — ปิด shift พร้อม closing_balance
    - `GET /api/v1/shifts` — list shifts
    - `GET /api/v1/shifts/:id/summary` — get shift summary
    - ตรวจสอบ: cashier ต้องไม่มี active shift ก่อนเปิดใหม่ (ยกเว้น Manager approve)
    - _Requirements: 17.1, 17.2, 17.6, 17.7, 17.8_

  - [x] 8.3 Implement shift summary calculation (Go)
    - คำนวณ: total_sales, total_cash, total_qr, total_transfer, expected_cash, actual_cash, cash_difference
    - แจ้งเตือน Manager ถ้า cash_difference เกิน threshold
    - _Requirements: 17.3, 17.4, 17.5_

  - [ ]* 8.4 Write property test for shift summary correctness
    - **Property 22: Shift Summary Correctness**
    - **Validates: Requirements 17.3**

  - [ ]* 8.5 Write property test for single active shift per cashier
    - **Property 23: Single Active Shift Per Cashier**
    - **Validates: Requirements 17.6**

  - [x] 8.6 Implement shift management UI (Flutter)
    - สร้าง `ShiftManagementScreen`: open shift form (opening balance), close shift form (closing balance)
    - แสดง shift summary หลังปิด shift
    - Manager view: ดู shift summary ของพนักงานทุกคน
    - _Requirements: 17.1, 17.2, 17.3, 17.4_

  - [x] 8.7 Implement refund management (Go + Flutter)
    - Go: `POST /api/v1/orders/:id/refund` — process refund พร้อม reason, approved_by
    - Go: อัปเดต stock กลับคืนหลัง refund
    - Go: บันทึก refund_log
    - Flutter: refund screen พร้อม Manager/Owner PIN approval
    - Flutter: พิมพ์ Refund_Receipt แยกต่างหาก
    - _Requirements: 21.1, 21.2, 21.3, 21.4, 21.5, 21.6, 21.7_

  - [ ]* 8.8 Write property test for refund requires authorization
    - **Property 24: Refund Requires Authorization**
    - **Validates: Requirements 21.1, 21.7**

  - [ ]* 8.9 Write property test for refund restores stock
    - **Property 25: Refund Restores Stock**
    - **Validates: Requirements 21.3**

  - [x] 8.10 Checkpoint — ทดสอบ shift open → sales → close → summary flow
    - Ensure all tests pass, ask the user if questions arise.

- [x] 9. Phase 9: Reporting
  - [x] 9.1 Implement sales reports API (Go)
    - `GET /api/v1/reports/sales/daily` — ยอดขายรวม, จำนวน transaction, สินค้าขายดี, แยกตามวิธีชำระ
    - `GET /api/v1/reports/sales/monthly` — ยอดขายรวม, เปรียบเทียบเดือนก่อน
    - รองรับ query params: `date_from`, `date_to`, `category_id`, `cashier_id`
    - _Requirements: 12.1, 12.2, 12.7_

  - [x] 9.2 Implement P&L และ stock reports API (Go)
    - `GET /api/v1/reports/pnl` — กำไร-ขาดทุน (Owner only, ตรวจสอบ role)
    - `GET /api/v1/reports/stock` — จำนวนคงเหลือ, มูลค่าสต็อก, สินค้าใกล้หมด
    - `GET /api/v1/reports/cashier` — performance ต่อ cashier
    - _Requirements: 12.3, 12.4, 12.6, 12.8, 12.9_

  - [x] 9.3 Implement report export (Go)
    - `GET /api/v1/reports/export?type=pdf|csv&report=sales|pnl|stock`
    - Rate limit: 5 req/min per user
    - _Requirements: 12.5_

  - [x] 9.4 Implement reports UI (Flutter)
    - สร้าง `ReportsScreen` พร้อม date range picker และ filter options
    - Daily/Monthly sales: แสดง summary cards + top products list
    - P&L: แสดงเฉพาะ Owner (FeatureGate by role)
    - Stock report: แสดง low stock items highlighted
    - Cashier performance: แสดง per-cashier stats
    - Export button: PDF/CSV download
    - _Requirements: 12.1, 12.2, 12.3, 12.4, 12.5, 12.6, 12.7, 12.8, 12.9_

- [x] 10. Phase 10: Security, Notifications & Polish
  - [x] 10.1 Implement in-app notification system (Go + Flutter)
    - Go: สร้าง notifications table และ `NotificationService`
    - Go: trigger notifications สำหรับ: low stock, subscription expiry (7 วัน + 1 วัน), sync conflict, KDS timeout, unregistered device login
    - Flutter: `NotificationProvider` (StreamProvider) ที่ poll หรือรับผ่าน WebSocket
    - Flutter: notification badge + notification list screen
    - _Requirements: 19.1, 19.2, 19.3, 19.4, 14.7_

  - [x] 10.2 Implement subscription expiry notifications (Go)
    - Background job ตรวจสอบ `expires_at` ทุกวัน
    - แจ้งเตือน Super_Admin และ Owner เมื่อเหลือ 7 วัน และ 1 วัน
    - _Requirements: 2.6_

  - [x] 10.3 Implement APK version update notification (Flutter)
    - ตรวจสอบ version จาก backend endpoint เมื่อ app เปิด
    - แสดง update notification ถ้ามีเวอร์ชันใหม่
    - _Requirements: 15.5_

  - [x] 10.4 Implement auto-logout on idle (Flutter)
    - ตั้งค่า idle timer (default 10 นาที, configurable โดย Owner)
    - Reset timer เมื่อมี user interaction
    - Redirect ไป `/login` เมื่อ timeout
    - _Requirements: 14.3_

  - [x] 10.5 Implement tenant settings API (Go + Flutter)
    - Go: `GET/PATCH /api/v1/settings` — tenant settings (language, currency, QR image, receipt template, idle timeout, cash difference threshold)
    - Flutter: `SettingsScreen` พร้อม sections: ร้านค้า, ภาษา, สกุลเงิน, hardware, ความปลอดภัย
    - _Requirements: 4.4, 4.5, 5.8, 9.7, 14.3, 17.5_

  - [x] 10.6 Build Android APK configuration
    - ตั้งค่า `build.gradle` สำหรับ release APK
    - ตั้งค่า signing key
    - ตรวจสอบ minimum SDK version 26 (Android 8.0)
    - _Requirements: 15.1, 15.3_

  - [x] 10.7 Build Flutter Web configuration
    - ตั้งค่า `web/` folder สำหรับ Chrome, Safari, Edge
    - ตั้งค่า PWA manifest
    - _Requirements: 15.2, 15.6_

  - [x] 10.8 Checkpoint สุดท้าย — ทดสอบ end-to-end ทุก flow
    - Ensure all tests pass, ask the user if questions arise.

---

## Notes

- Tasks ที่มี `*` เป็น optional สามารถข้ามได้สำหรับ MVP เร็วขึ้น
- แต่ละ task อ้างอิง requirements เฉพาะเพื่อ traceability
- Checkpoints ช่วย validate ความถูกต้องแบบ incremental
- Property tests ใช้ `package:glados` (Flutter/Dart) และ `gopter`/`rapid` (Go) อย่างน้อย 100 iterations ต่อ property
- Unit tests ครอบคลุม specific examples, edge cases, และ error conditions
- ทุก property test ต้องมี comment tag: `// Feature: sokdee-pos, Property {N}: {title}`
- Local DB encryption ใช้ SQLCipher ผ่าน `drift_sqflite_encryption`
- WebSocket KDS ใช้ tenant-scoped rooms เพื่อ isolation
