# Requirements Document: SOKDEE POS

## Introduction

SOKDEE POS เป็นระบบ SaaS Point-of-Sale ที่ออกแบบมาสำหรับผู้ใช้ในประเทศลาว รองรับหลายประเภทร้านค้า ได้แก่ ร้านอาหาร (เล็ก/กลาง/ใหญ่), ร้านค้าทั่วไป, คลังสินค้า, และร้านอะไหล่รถ ระบบทำงานบน Flutter app รองรับ Android tablet/phone และ Flutter Web สำหรับ iOS/iPad โดย Super Admin (เจ้าของระบบ) เป็นผู้สร้างบัญชีและกำหนดขอบเขตการใช้งานให้ลูกค้าแต่ละราย

> **หมายเหตุ v1 Scope:** Customer Management (การจัดการข้อมูลลูกค้า) และ Loyalty Points (ระบบสะสมแต้ม) ไม่อยู่ใน scope ของ v1 และจะรองรับใน v2

---

## Glossary

- **SOKDEE_POS**: ระบบ SaaS POS หลักที่ครอบคลุมทุก module
- **Super_Admin**: ผู้ดูแลระบบสูงสุด (เจ้าของ SOKDEE POS) มีสิทธิ์จัดการลูกค้าทั้งหมด
- **Owner**: เจ้าของร้านค้า มีสิทธิ์สูงสุดในขอบเขตร้านของตน
- **Manager**: ผู้จัดการร้าน มีสิทธิ์จัดการสินค้า พนักงาน และรายงาน
- **Cashier**: พนักงานแคชเชียร์ มีสิทธิ์รับออเดอร์และชำระเงิน
- **Kitchen_Staff**: พนักงานครัว มีสิทธิ์ดู/อัปเดตสถานะออเดอร์ใน KDS
- **Tenant**: ร้านค้าหนึ่งรายที่ใช้งาน SOKDEE POS ภายใต้ subscription plan
- **KDS**: Kitchen Display System จอแสดงออเดอร์ในครัว เฉพาะร้านอาหาร
- **Subscription_Plan**: แพ็กเกจการใช้งานที่กำหนดขอบเขต features และจำนวนผู้ใช้
- **Sync_Engine**: ระบบ synchronization ข้อมูลระหว่าง local device และ backend server
- **Local_DB**: ฐานข้อมูลบน device สำหรับรองรับการทำงาน offline
- **Backend**: Custom backend server บน VPS ของ SOKDEE POS
- **LAK**: กีบลาว สกุลเงินหลักของระบบ
- **THB**: บาทไทย สกุลเงินรอง
- **USD**: ดอลลาร์สหรัฐ สกุลเงินรอง
- **APK**: Android Package ไฟล์ติดตั้งแอปสำหรับ Android
- **Setup_Wizard**: ขั้นตอนการตั้งค่าร้านค้าครั้งแรกโดย Super Admin
- **Order**: รายการสั่งซื้อสินค้าหรืออาหารจากลูกค้า
- **Receipt**: ใบเสร็จรับเงินที่พิมพ์ออกจาก thermal printer
- **Stock**: จำนวนสินค้าคงคลังในระบบ
- **Void**: การยกเลิก transaction ที่เพิ่งเกิดขึ้น ภายใน shift เดียวกันหรือวันเดียวกัน ก่อนปิด shift
- **Refund**: การคืนเงินให้ลูกค้าหลังจาก transaction ปิดแล้ว เมื่อลูกค้านำสินค้ามาคืน
- **Refund_Receipt**: ใบเสร็จคืนเงินที่แยกต่างหากจาก Receipt ปกติ

---

## Requirements

### Requirement 1: การจัดการ Subscription Plans

**User Story:** As a Super_Admin, I want to manage subscription plans with different feature tiers, so that I can offer appropriate packages to different types of businesses.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL รองรับ subscription plans 4 ระดับ ได้แก่ Starter, Basic, Pro, และ Enterprise
2. WHEN Super_Admin กำหนด Starter plan, THE SOKDEE_POS SHALL จำกัดจำนวนพนักงานไม่เกิน 3 คน, สินค้าไม่เกิน 100 รายการ, และเปิดใช้งานเฉพาะ POS พื้นฐาน
3. WHEN Super_Admin กำหนด Basic plan, THE SOKDEE_POS SHALL จำกัดจำนวนพนักงานไม่เกิน 10 คน, สินค้าไม่เกิน 500 รายการ, และเปิดใช้งาน POS, inventory management, และ basic reports
4. WHEN Super_Admin กำหนด Pro plan, THE SOKDEE_POS SHALL จำกัดจำนวนพนักงานไม่เกิน 30 คน, สินค้าไม่เกิน 2000 รายการ, และเปิดใช้งานทุก feature รวมถึง KDS และ advanced reports
5. WHEN Super_Admin กำหนด Enterprise plan, THE SOKDEE_POS SHALL ไม่จำกัดจำนวนพนักงานและสินค้า และเปิดใช้งานทุก feature พร้อม priority support
6. WHEN Tenant พยายามเพิ่มพนักงานเกินขีดจำกัดของ plan, THE SOKDEE_POS SHALL แสดงข้อความแจ้งเตือนและปฏิเสธการดำเนินการ
7. WHEN Super_Admin เปลี่ยน plan ของ Tenant, THE SOKDEE_POS SHALL อัปเดตขอบเขตการใช้งานภายใน 5 นาที


### Requirement 2: การจัดการ Tenant โดย Super Admin

**User Story:** As a Super_Admin, I want to create and manage tenant accounts, so that I can onboard new customers and control their system access.

#### Acceptance Criteria

1. THE Super_Admin SHALL สร้างบัญชี Tenant ใหม่ผ่าน Setup_Wizard โดยระบุชื่อร้าน, ประเภทร้าน, subscription plan, จำนวนพนักงานสูงสุด, และจำนวนโต๊ะ (กรณีร้านอาหาร)
2. WHEN Super_Admin สร้าง Tenant สำเร็จ, THE SOKDEE_POS SHALL สร้าง Tenant ID และ credentials เริ่มต้นสำหรับ Owner และส่งให้ Super_Admin เพื่อมอบให้ลูกค้า
3. THE Super_Admin SHALL ระงับ (suspend) หรือเปิดใช้งาน (activate) บัญชี Tenant ได้ตลอดเวลา
4. WHEN Super_Admin ระงับบัญชี Tenant, THE SOKDEE_POS SHALL ป้องกันการ login ของผู้ใช้ทุกคนใน Tenant นั้น ยกเว้นข้อมูลที่ sync ไว้ใน Local_DB ก่อนหน้า
5. THE Super_Admin SHALL ดูรายการ Tenant ทั้งหมด พร้อมสถานะ subscription, วันหมดอายุ, และจำนวนผู้ใช้งานปัจจุบัน
6. WHEN subscription ของ Tenant หมดอายุ, THE SOKDEE_POS SHALL แจ้งเตือน Super_Admin และ Owner ล่วงหน้า 7 วัน
7. IF subscription ของ Tenant หมดอายุโดยไม่ต่ออายุ, THEN THE SOKDEE_POS SHALL จำกัดการเข้าถึงเฉพาะ read-only mode และแสดงข้อความแจ้งให้ต่ออายุ

---

### Requirement 3: User Roles และ Access Control

**User Story:** As an Owner, I want to manage staff roles and permissions, so that each employee can access only the features relevant to their job.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL รองรับ 5 roles ได้แก่ Super_Admin, Owner, Manager, Cashier, และ Kitchen_Staff
2. THE Owner SHALL สร้าง, แก้ไข, และลบบัญชีพนักงานภายใน Tenant ของตน โดยไม่เกินจำนวนที่ subscription plan กำหนด
3. THE Manager SHALL จัดการสินค้า, ดูรายงาน, และจัดการ shift ของพนักงาน แต่ไม่สามารถแก้ไขการตั้งค่าระบบหรือ subscription ได้
4. THE Cashier SHALL รับออเดอร์, ประมวลผลการชำระเงิน, และพิมพ์ใบเสร็จ แต่ไม่สามารถดูรายงานกำไรขาดทุนหรือแก้ไขราคาสินค้าได้
5. THE Kitchen_Staff SHALL ดูและอัปเดตสถานะออเดอร์ใน KDS เท่านั้น
6. WHEN ผู้ใช้พยายามเข้าถึง feature ที่เกินสิทธิ์ของ role ตน, THE SOKDEE_POS SHALL ปฏิเสธการเข้าถึงและแสดงข้อความแจ้งเตือน
7. THE Owner SHALL กำหนด PIN 4-6 หลักสำหรับแต่ละพนักงาน เพื่อใช้ login บน POS terminal

---

### Requirement 4: การตั้งค่าร้านค้าและ Setup Wizard

**User Story:** As a Super_Admin, I want a guided setup wizard for new tenants, so that new stores can be configured quickly and correctly.

#### Acceptance Criteria

1. THE Setup_Wizard SHALL นำ Super_Admin ผ่านขั้นตอนการตั้งค่า ได้แก่ ชื่อร้าน, ประเภทร้าน, subscription plan, จำนวนพนักงานสูงสุด, และจำนวนโต๊ะ (กรณีร้านอาหาร)
2. WHEN ประเภทร้านเป็น "ร้านอาหาร", THE Setup_Wizard SHALL แสดงขั้นตอนเพิ่มเติมสำหรับกำหนดจำนวนโต๊ะ, layout โซน, และเปิดใช้งาน KDS
3. WHEN ประเภทร้านไม่ใช่ "ร้านอาหาร", THE Setup_Wizard SHALL ข้ามขั้นตอนที่เกี่ยวกับโต๊ะและ KDS
4. THE SOKDEE_POS SHALL รองรับการตั้งค่าภาษาหลักของร้านเป็น ลาว, ไทย, หรือ อังกฤษ
5. THE SOKDEE_POS SHALL รองรับการตั้งค่าสกุลเงินหลักเป็น LAK และสกุลเงินรองเพิ่มเติมได้ถึง 2 สกุล (THB, USD)
6. WHEN Setup_Wizard เสร็จสมบูรณ์, THE SOKDEE_POS SHALL สร้างข้อมูลเริ่มต้นของ Tenant และพร้อมใช้งานทันที

---

### Requirement 5: Core POS - การรับออเดอร์และชำระเงิน

**User Story:** As a Cashier, I want to take orders and process payments efficiently, so that customers are served quickly and accurately.

#### Acceptance Criteria

1. THE Cashier SHALL เพิ่มสินค้าลงใน Order โดยการค้นหาชื่อ, สแกน barcode, หรือเลือกจากหมวดหมู่
2. WHEN Cashier สแกน barcode ที่ไม่มีในระบบ, THE SOKDEE_POS SHALL แสดงข้อความแจ้งว่าไม่พบสินค้าและเสนอให้เพิ่มสินค้าใหม่
3. THE Cashier SHALL แก้ไขจำนวน, ลบรายการ, หรือเพิ่ม discount ต่อรายการใน Order ก่อนชำระเงิน
4. THE SOKDEE_POS SHALL คำนวณยอดรวม, ส่วนลด, และภาษี (ถ้ามี) แบบ real-time ทุกครั้งที่ Order เปลี่ยนแปลง
5. WHEN Cashier เลือกชำระเงินด้วยเงินสด, THE SOKDEE_POS SHALL คำนวณเงินทอนและแสดงผลทันที
6. WHEN Cashier เลือกชำระเงินด้วย QR Code, THE SOKDEE_POS SHALL แสดง static QR Code (PromptPay หรือเลขบัญชีธนาคารของร้าน) ให้ลูกค้าสแกนโอนเงิน และรอให้ Cashier กด confirm ด้วยตนเองหลังลูกค้าโอนเงินแล้ว โดยไม่มีการ verify อัตโนมัติจากธนาคาร
7. WHEN Cashier เลือกชำระเงินด้วยการโอนเงิน, THE SOKDEE_POS SHALL บันทึกข้อมูลการโอนและรอการยืนยัน
8. THE Owner หรือ Manager SHALL ตั้งค่า QR image หรือเลขบัญชีธนาคาร/PromptPay ของร้านในระบบได้
9. THE SOKDEE_POS SHALL รองรับการชำระเงินแบบผสม (split payment) ระหว่างสกุลเงิน LAK, THB, และ USD ในออเดอร์เดียวกัน
10. WHEN การชำระเงินสำเร็จ, THE SOKDEE_POS SHALL บันทึก Order, อัปเดต Stock, และพิมพ์ Receipt อัตโนมัติ
11. THE Cashier SHALL ยกเลิก Order ที่ยังไม่ชำระเงินได้ โดยต้องระบุเหตุผล
12. WHEN Manager หรือ Owner ต้องการ void transaction ที่ชำระแล้ว, THE SOKDEE_POS SHALL บันทึก void log พร้อม timestamp และ user ที่ดำเนินการ


### Requirement 6: Table Management (ร้านอาหาร)

**User Story:** As a Cashier or Manager in a restaurant, I want to manage tables and orders per table, so that I can track which table has ordered what and handle the billing correctly.

#### Acceptance Criteria

1. WHERE ประเภทร้านเป็น "ร้านอาหาร", THE SOKDEE_POS SHALL แสดง floor plan ของโต๊ะทั้งหมดพร้อมสถานะ (ว่าง, มีลูกค้า, รอชำระเงิน)
2. WHEN Cashier เลือกโต๊ะที่ว่าง, THE SOKDEE_POS SHALL เปิด Order ใหม่สำหรับโต๊ะนั้นและเปลี่ยนสถานะเป็น "มีลูกค้า"
3. THE Cashier SHALL เพิ่มรายการอาหารเข้า Order ของโต๊ะได้หลายรอบ (multiple rounds) โดยไม่ต้องชำระเงินก่อน
4. THE Cashier SHALL ย้าย Order จากโต๊ะหนึ่งไปยังอีกโต๊ะหนึ่งได้ โดยต้องได้รับการยืนยันจาก Manager
5. THE Cashier SHALL รวม Order จากหลายโต๊ะเป็น bill เดียวได้ (merge tables)
6. WHEN Cashier สั่งอาหารเพิ่มในโต๊ะที่มี Order อยู่แล้ว, THE SOKDEE_POS SHALL ส่งรายการใหม่ไปยัง KDS ทันที
7. THE SOKDEE_POS SHALL แสดงเวลาที่โต๊ะนั้นเปิด Order บน floor plan เพื่อให้พนักงานทราบระยะเวลาที่ลูกค้านั่ง

---

### Requirement 7: Kitchen Display System (KDS)

**User Story:** As a Kitchen_Staff, I want to see incoming orders on a display, so that I can prepare food in the correct order and mark items as done.

#### Acceptance Criteria

1. WHERE ประเภทร้านเป็น "ร้านอาหาร" และ subscription plan เป็น Pro หรือ Enterprise, THE SOKDEE_POS SHALL เปิดใช้งาน KDS
2. WHEN Cashier ยืนยัน Order, THE KDS SHALL แสดงรายการอาหารใหม่บนหน้าจอครัวภายใน 3 วินาที
3. THE KDS SHALL แสดงข้อมูลต่อไปนี้สำหรับแต่ละ Order: หมายเลขโต๊ะ, รายการอาหาร, จำนวน, หมายเหตุพิเศษ, และเวลาที่รับออเดอร์
4. THE Kitchen_Staff SHALL กดยืนยันรายการอาหารแต่ละรายการเมื่อเตรียมเสร็จ
5. WHEN รายการอาหารทุกรายการใน Order ถูกยืนยันว่าเสร็จแล้ว, THE KDS SHALL แสดงสถานะ "พร้อมเสิร์ฟ" และแจ้งเตือน Cashier
6. WHEN Order ค้างอยู่ใน KDS นานกว่า 15 นาที, THE KDS SHALL เปลี่ยนสีแสดงเป็นสีเหลืองเพื่อเตือน
7. WHEN Order ค้างอยู่ใน KDS นานกว่า 30 นาที, THE KDS SHALL เปลี่ยนสีแสดงเป็นสีแดงเพื่อเตือนเร่งด่วน
8. THE Kitchen_Staff SHALL พิมพ์ใบออเดอร์ที่ครัวได้จาก KDS สำหรับ Order ที่เข้ามาใหม่

---

### Requirement 8: Inventory Management

**User Story:** As a Manager or Owner, I want to manage product inventory, so that I can track stock levels and prevent selling out-of-stock items.

#### Acceptance Criteria

1. THE Manager SHALL เพิ่ม, แก้ไข, และลบสินค้าในระบบ โดยระบุชื่อ, หมวดหมู่, ราคาขาย, ราคาทุน, หน่วย, และ barcode
2. THE SOKDEE_POS SHALL อัปเดต Stock อัตโนมัติทุกครั้งที่มีการขายสินค้า
3. WHEN Stock ของสินค้าลดลงถึงระดับ minimum ที่กำหนด, THE SOKDEE_POS SHALL แจ้งเตือน Manager และ Owner
4. WHEN Stock ของสินค้าเป็น 0, THE SOKDEE_POS SHALL แสดงสถานะ "หมด" บนหน้าจอ POS และป้องกัน Cashier เพิ่มสินค้านั้นลงใน Order
5. THE Manager SHALL บันทึกการรับสินค้าเข้า (stock in) พร้อมระบุจำนวน, ราคาทุน, และวันที่
6. THE Manager SHALL บันทึกการตัดสต็อก (stock adjustment) พร้อมระบุเหตุผล เช่น สินค้าเสียหาย หรือนับสต็อกจริง
7. THE SOKDEE_POS SHALL รองรับสินค้าที่มีหลาย variant เช่น ขนาด หรือสี โดยแต่ละ variant มี Stock แยกกัน
8. THE Manager SHALL นำเข้าข้อมูลสินค้าจากไฟล์ CSV ได้
9. FOR ALL stock transactions, THE SOKDEE_POS SHALL บันทึก audit log ที่ระบุ user, timestamp, และรายละเอียดการเปลี่ยนแปลง

---

### Requirement 9: Hardware Integration

**User Story:** As a Cashier, I want the POS to work seamlessly with hardware peripherals, so that I can print receipts, scan barcodes, and open the cash drawer without manual steps.

#### Acceptance Criteria

1. WHEN การชำระเงินสำเร็จ, THE SOKDEE_POS SHALL ส่งคำสั่งเปิด cash drawer อัตโนมัติ (กรณีชำระด้วยเงินสด)
2. THE SOKDEE_POS SHALL พิมพ์ Receipt ผ่าน thermal printer โดย Receipt ต้องมี: ชื่อร้าน, วันที่/เวลา, รายการสินค้า, ยอดรวม, ส่วนลด, ยอดที่ชำระ, เงินทอน, และหมายเลข Order
3. THE Cashier SHALL พิมพ์ Receipt ซ้ำได้สำหรับ Order ที่ชำระแล้ว
4. WHEN Cashier เชื่อมต่อ barcode scanner, THE SOKDEE_POS SHALL รับข้อมูล barcode และค้นหาสินค้าในระบบทันที
5. IF thermal printer ไม่ตอบสนอง, THEN THE SOKDEE_POS SHALL แสดงข้อความแจ้งเตือนและเสนอให้ลองพิมพ์ใหม่หรือข้ามการพิมพ์
6. THE SOKDEE_POS SHALL รองรับการเชื่อมต่อ thermal printer ผ่าน USB, Bluetooth, และ WiFi
7. THE SOKDEE_POS SHALL รองรับ Receipt template ที่ปรับแต่งได้ เช่น เพิ่ม logo ร้าน หรือข้อความท้ายใบเสร็จ


### Requirement 10: Offline Support และ Data Synchronization

**User Story:** As a Cashier, I want the POS to continue working when the internet is unavailable, so that sales are not interrupted during connectivity issues.

#### Acceptance Criteria

1. WHILE internet connection ไม่พร้อมใช้งาน, THE SOKDEE_POS SHALL ทำงานได้เต็มรูปแบบโดยใช้ Local_DB บน device
2. WHILE ทำงาน offline, THE SOKDEE_POS SHALL แสดงสัญลักษณ์แจ้งเตือนสถานะ offline ที่มองเห็นได้ชัดเจน
3. WHEN internet connection กลับมาพร้อมใช้งาน, THE Sync_Engine SHALL sync ข้อมูลที่ค้างอยู่ทั้งหมดไปยัง Backend ภายใน 60 วินาที
4. WHEN เกิด data conflict ระหว่าง sync (เช่น Stock ติดลบ), THE Sync_Engine SHALL บันทึก conflict log และแจ้งเตือน Manager เพื่อแก้ไขด้วยตนเอง
5. THE SOKDEE_POS SHALL มีหน้า Conflict Resolution ที่แสดงรายการ conflict ทั้งหมด พร้อมข้อมูล: สินค้าที่มีปัญหา, ยอด local vs server, และตัวเลือกให้ Manager เลือก (ใช้ค่า local / ใช้ค่า server / ระบุค่าใหม่)
6. THE Sync_Engine SHALL sync ข้อมูลแบบ incremental (เฉพาะข้อมูลที่เปลี่ยนแปลง) เพื่อลด bandwidth
7. THE SOKDEE_POS SHALL เก็บข้อมูล transaction ใน Local_DB ย้อนหลังอย่างน้อย 30 วัน
8. FOR ALL sync operations, THE Sync_Engine SHALL ใช้ idempotent operations เพื่อป้องกันการบันทึกข้อมูลซ้ำ
9. WHEN device ถูก sync ครั้งแรกหรือ reset, THE Sync_Engine SHALL ดาวน์โหลดข้อมูลสินค้าและการตั้งค่าทั้งหมดจาก Backend ก่อนเปิดใช้งาน

---

### Requirement 11: Multi-Currency Support

**User Story:** As a Cashier, I want to accept payment in multiple currencies, so that I can serve customers who pay with Thai Baht or US Dollars.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL แสดงราคาสินค้าในสกุลเงินหลัก (LAK) เสมอ
2. THE Owner หรือ Manager SHALL กำหนดอัตราแลกเปลี่ยน THB/LAK และ USD/LAK ในระบบ
3. WHEN Cashier เลือกรับชำระเงินด้วย THB หรือ USD, THE SOKDEE_POS SHALL แปลงยอดเป็นสกุลเงินนั้นโดยใช้อัตราแลกเปลี่ยนที่กำหนดไว้
4. THE SOKDEE_POS SHALL บันทึกยอดขายทั้งในสกุลเงินที่รับชำระและสกุลเงินหลัก (LAK) สำหรับรายงาน
5. THE Receipt SHALL แสดงยอดที่ชำระในสกุลเงินที่ลูกค้าจ่าย และยอดเทียบเท่าใน LAK
6. WHEN อัตราแลกเปลี่ยนถูกอัปเดต, THE SOKDEE_POS SHALL ใช้อัตราใหม่สำหรับ transaction ที่เกิดขึ้นหลังจากนั้นเท่านั้น
7. WHEN อัตราแลกเปลี่ยนของสกุลเงินใดยังไม่ได้ตั้งค่า, THE SOKDEE_POS SHALL ปิดการใช้งานสกุลเงินนั้นและแสดงข้อความแจ้งให้ Owner หรือ Manager ตั้งค่าก่อน
8. THE SOKDEE_POS SHALL ไม่อนุญาตให้ Cashier รับชำระเงินด้วยสกุลเงินที่ยังไม่มี exchange rate กำหนดไว้

---

### Requirement 12: Reporting และ Analytics

**User Story:** As an Owner or Manager, I want to view sales reports and analytics, so that I can make informed business decisions.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL สร้างรายงานยอดขายรายวัน แสดง: ยอดขายรวม, จำนวน transaction, สินค้าขายดี, และยอดแยกตามวิธีชำระเงิน
2. THE SOKDEE_POS SHALL สร้างรายงานยอดขายรายเดือน แสดง: ยอดขายรวม, เปรียบเทียบกับเดือนก่อน, และ trend graph
3. THE SOKDEE_POS SHALL สร้างรายงานกำไร-ขาดทุน โดยคำนวณจากราคาขายหักราคาทุนของสินค้าที่ขายได้
4. THE SOKDEE_POS SHALL สร้างรายงานสต็อกสินค้า แสดง: จำนวนคงเหลือ, มูลค่าสต็อก, และสินค้าที่ใกล้หมด
5. THE Owner SHALL export รายงานเป็นไฟล์ PDF หรือ CSV ได้
6. WHEN Manager ดูรายงาน, THE SOKDEE_POS SHALL แสดงเฉพาะข้อมูลยอดขายและสต็อก ไม่แสดงข้อมูลกำไร-ขาดทุน (เฉพาะ Owner เท่านั้น)
7. THE SOKDEE_POS SHALL รองรับการกรองรายงานตามช่วงวันที่, หมวดหมู่สินค้า, และพนักงาน
8. THE SOKDEE_POS SHALL เก็บข้อมูลยอดขายต่อ Cashier ได้แก่: จำนวน transaction, ยอดขายรวม, ยอดเฉลี่ยต่อ transaction, และจำนวน void/refund ที่ดำเนินการ
9. THE Manager และ Owner SHALL ดูรายงาน performance ของ Cashier แต่ละคนได้

---

### Requirement 13: Multi-Language Support

**User Story:** As a store owner, I want the POS interface to be available in Lao, Thai, and English, so that all staff can use the system in their preferred language.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL รองรับ 3 ภาษา ได้แก่ ลาว (lo), ไทย (th), และ อังกฤษ (en)
2. THE SOKDEE_POS SHALL ใช้ภาษาที่ตั้งค่าไว้สำหรับ Tenant เป็นค่าเริ่มต้น
3. THE ผู้ใช้ SHALL เปลี่ยนภาษาของ interface ได้ทันทีโดยไม่ต้อง restart แอป
4. WHEN ภาษาถูกเปลี่ยน, THE SOKDEE_POS SHALL แสดง UI ทั้งหมดในภาษาใหม่ภายใน 1 วินาที
5. THE Receipt SHALL พิมพ์ในภาษาที่ตั้งค่าไว้สำหรับ Tenant

---

### Requirement 14: Security และ Authentication

**User Story:** As an Owner, I want the system to be secure and auditable, so that I can protect business data and track staff actions.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL ต้องการ authentication ก่อนเข้าใช้งานทุกครั้ง โดยรองรับ PIN 4-6 หลัก
2. WHEN ผู้ใช้ใส่ PIN ผิดเกิน 5 ครั้งติดต่อกัน, THE SOKDEE_POS SHALL ล็อกบัญชีนั้นเป็นเวลา 15 นาที
3. THE SOKDEE_POS SHALL logout อัตโนมัติเมื่อไม่มีการใช้งานนานกว่า 10 นาที (configurable โดย Owner)
4. THE SOKDEE_POS SHALL เข้ารหัสข้อมูลที่ส่งระหว่าง device และ Backend ด้วย HTTPS/TLS
5. THE SOKDEE_POS SHALL เก็บ audit log ของทุก action ที่สำคัญ เช่น login, void transaction, stock adjustment, และการเปลี่ยนแปลงราคา
6. THE Owner SHALL ดู audit log ย้อนหลังได้อย่างน้อย 90 วัน
7. IF ตรวจพบการ login จาก device ที่ไม่รู้จัก, THEN THE SOKDEE_POS SHALL แจ้งเตือน Owner ผ่าน notification
8. THE SOKDEE_POS SHALL ลงทะเบียน device โดยอัตโนมัติเมื่อ login สำเร็จครั้งแรก โดยบันทึก device ID, device name, และ OS version
9. THE Owner SHALL ดูรายการ registered devices และ revoke access ของ device ใดก็ได้
10. WHEN มีการ login จาก device ที่ไม่อยู่ใน registered devices list, THE SOKDEE_POS SHALL แจ้งเตือน Owner และขอการยืนยันก่อนอนุญาตให้เข้าใช้งาน

---

### Requirement 15: Platform และ Distribution

**User Story:** As a Super_Admin, I want to distribute the app to customers easily, so that onboarding new tenants is straightforward.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL ทำงานบน Android tablet และ Android phone ผ่าน APK ที่ Super_Admin ส่งให้ลูกค้าโดยตรง
2. THE SOKDEE_POS SHALL ทำงานบน iOS และ iPad ผ่าน Flutter Web โดยไม่ต้องติดตั้งแอป
3. THE SOKDEE_POS SHALL รองรับ Android เวอร์ชัน 8.0 (API level 26) ขึ้นไป
4. THE SOKDEE_POS SHALL ปรับ layout อัตโนมัติสำหรับหน้าจอขนาดต่างกัน (phone vs tablet) โดยใช้ responsive design
5. WHEN มีการอัปเดต APK เวอร์ชันใหม่, THE SOKDEE_POS SHALL แจ้งเตือน Owner และ Manager ให้ดาวน์โหลดเวอร์ชันใหม่
6. THE SOKDEE_POS SHALL ทำงานได้บน Flutter Web ด้วย browser Chrome, Safari, และ Edge เวอร์ชันล่าสุด


### Requirement 16: Discount และ Promotion Management

**User Story:** As a Manager or Owner, I want to create discounts and promotions, so that I can attract customers and manage special pricing.

#### Acceptance Criteria

1. THE Manager SHALL สร้าง discount แบบ percentage (%) หรือ fixed amount สำหรับสินค้าแต่ละรายการหรือทั้ง Order
2. THE Manager SHALL กำหนดช่วงเวลาที่ discount มีผล (start date, end date)
3. WHEN Cashier เพิ่มสินค้าที่มี discount ที่ active อยู่ลงใน Order, THE SOKDEE_POS SHALL ใช้ราคา discount อัตโนมัติ
4. THE Cashier SHALL ให้ discount พิเศษต่อ Order ได้ โดยต้องได้รับการอนุมัติจาก Manager หรือ Owner (ผ่าน PIN)
5. THE Receipt SHALL แสดงราคาเต็ม, ส่วนลด, และราคาสุทธิอย่างชัดเจน

---

### Requirement 17: Shift Management

**User Story:** As a Manager, I want to manage cashier shifts and end-of-day reconciliation, so that I can track cash flow and staff performance.

#### Acceptance Criteria

1. THE Cashier SHALL เปิด shift โดยระบุยอดเงินเริ่มต้นใน cash drawer (opening balance)
2. THE Cashier SHALL ปิด shift โดยนับเงินสดจริงและระบุยอด (closing balance)
3. WHEN Cashier ปิด shift, THE SOKDEE_POS SHALL สร้าง shift summary แสดง: ยอดขายรวม, ยอดแยกตามวิธีชำระเงิน, ยอดเงินสดที่ควรมี, และผลต่างระหว่างยอดจริงกับยอดที่ควรมี
4. THE Manager SHALL ดู shift summary ของพนักงานทุกคนได้
5. WHEN ผลต่างของเงินสดเกิน threshold ที่กำหนด (configurable), THE SOKDEE_POS SHALL แจ้งเตือน Manager
6. THE SOKDEE_POS SHALL อนุญาตให้ Cashier 1 คนมีได้ 1 shift ที่ active ในเวลาเดียวกัน
7. THE SOKDEE_POS SHALL อนุญาตให้ device 1 เครื่องมีหลาย Cashier ผลัดกันเปิด/ปิด shift ได้
8. WHEN Cashier คนใหม่พยายามเปิด shift บน device ที่มี shift อื่น active อยู่, THE SOKDEE_POS SHALL แจ้งเตือนและต้องปิด shift เดิมก่อน หรือ Manager อนุมัติผ่าน PIN เพื่อเปิด shift ซ้อนได้

---

### Requirement 18: Product Categories และ Menu Management

**User Story:** As a Manager, I want to organize products into categories, so that cashiers can find items quickly during busy periods.

#### Acceptance Criteria

1. THE Manager SHALL สร้าง, แก้ไข, และลบหมวดหมู่สินค้า (categories) และหมวดหมู่ย่อย (sub-categories)
2. THE Manager SHALL กำหนดสินค้าให้อยู่ในหมวดหมู่ได้หลายหมวดหมู่พร้อมกัน
3. THE Manager SHALL กำหนดลำดับการแสดงผลของหมวดหมู่และสินค้าบนหน้าจอ POS
4. WHERE ประเภทร้านเป็น "ร้านอาหาร", THE Manager SHALL กำหนด modifier สำหรับเมนู เช่น ระดับความเผ็ด, ไม่ใส่ผัก, หรือเพิ่มพิเศษ
5. WHEN Manager ปิดการใช้งานสินค้า (inactive), THE SOKDEE_POS SHALL ซ่อนสินค้านั้นจากหน้าจอ POS ทันที

---

### Requirement 19: Notification และ Alerts

**User Story:** As an Owner or Manager, I want to receive important alerts, so that I can respond to critical situations promptly.

#### Acceptance Criteria

1. THE SOKDEE_POS SHALL ส่ง in-app notification เมื่อ Stock ของสินค้าถึงระดับ minimum
2. THE SOKDEE_POS SHALL ส่ง in-app notification เมื่อ subscription ใกล้หมดอายุ (7 วัน และ 1 วันก่อนหมด)
3. WHEN เกิด sync error ที่ต้องการการแก้ไขด้วยตนเอง, THE SOKDEE_POS SHALL แสดง notification พร้อมรายละเอียดของ conflict
4. THE SOKDEE_POS SHALL แสดง notification เมื่อ Order ใน KDS ค้างนานเกิน threshold ที่กำหนด (เฉพาะร้านอาหาร)

---

### Requirement 20: Data Backup และ Recovery

**User Story:** As an Owner, I want my business data to be backed up regularly, so that I don't lose critical information in case of device failure.

#### Acceptance Criteria

1. THE Backend SHALL สำรองข้อมูลของ Tenant ทุกวันอัตโนมัติ
2. THE Super_Admin SHALL restore ข้อมูลของ Tenant ได้จาก backup ย้อนหลังอย่างน้อย 30 วัน
3. WHEN device ถูกเปลี่ยนหรือ reset, THE SOKDEE_POS SHALL restore ข้อมูลจาก Backend ได้หลังจาก login สำเร็จ
4. THE SOKDEE_POS SHALL เข้ารหัสข้อมูลใน Local_DB เพื่อป้องกันการเข้าถึงโดยไม่ได้รับอนุญาต


---

### Requirement 21: Refund Management

**User Story:** As a Manager or Owner, I want to process refunds for returned items, so that customers can get their money back after a completed transaction.

#### Acceptance Criteria

1. THE Manager หรือ Owner SHALL ดำเนินการ refund สำหรับ transaction ที่ปิดแล้ว โดยต้องอนุมัติผ่าน Manager/Owner PIN ก่อนทุกครั้ง
2. WHEN ดำเนินการ refund, THE SOKDEE_POS SHALL บันทึก refund log ที่ระบุ: เหตุผล, user ที่ดำเนินการ, timestamp, และ transaction อ้างอิง
3. WHEN refund สินค้าที่มีการติดตาม Stock, THE SOKDEE_POS SHALL อัปเดต Stock กลับคืนอัตโนมัติตามจำนวนที่ refund
4. WHEN refund สำเร็จ, THE SOKDEE_POS SHALL พิมพ์ Refund_Receipt แยกต่างหากจาก Receipt ปกติ โดยระบุยอดที่คืน, เหตุผล, และ reference ถึง transaction เดิม
5. THE SOKDEE_POS SHALL แยก refund ออกจาก void อย่างชัดเจน โดย void ใช้สำหรับยกเลิก transaction ภายใน shift เดียวกัน ส่วน refund ใช้สำหรับ transaction ที่ปิดแล้ว
6. THE SOKDEE_POS SHALL แสดงรายการ refund ใน shift summary และรายงานยอดขาย โดยหักออกจากยอดขายรวม
7. THE Cashier SHALL ไม่สามารถดำเนินการ refund ได้โดยไม่มีการอนุมัติจาก Manager หรือ Owner
