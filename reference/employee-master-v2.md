# Employee Master v2

*บริษัท หมอยาสุรินทร์ จำกัด | Reference file*

> **Status:** 🔒 Updated — 25 เม.ย. 2569
> **Source of Truth:** Official Headcount & Roles (Master Data page)
> **Usage:** Reference สำหรับ Dev migration M1

---

## Summary

| Metric | Count |
|--------|-------|
| Total in system | 32 |
| Payroll run | 29 |
| Attendance tracking | 28 |
| LIFF Access | 29 |
| SSO contribution | 27 |

---

## Group A: Directors / Delegates (3 คน) — Payroll ✅ | Attendance ❌ | SSO ❌/✅

| Code | ชื่อเล่น | ชื่อ-นามสกุล | Role | เงินเดือน | SSO | หมายเหตุ |
|------|---------|------------|------|---------|-----|---------|
| — | เฮีย | อมร | Owner (Director) | 20,000 | ❌ | ⚠️ ไม่อยู่ใน Humansoft — add ตอน M1 |
| — | ไนซ์ | (ภรรยาเฮีย) | Owner Delegate (Director) | 20,000 | ❌ | ⚠️ ไม่อยู่ใน Humansoft — add ตอน M1 |
| CEO02 | จิว | ศศิ เกียรติคุณรัตน์ | Owner Delegate (Executive) | 30,000 | ✅ 750 | ⚠️ Humansoft salary=0 → set 30,000 ตอน M1 |

---

## Group B: Supervisors (5 คน) — Payroll ✅ | Attendance ✅ | SSO ✅

| Code | ชื่อเล่น | ชื่อ-นามสกุล | Role | Cost Center | เงินเดือน |
|------|---------|------------|------|------------|---------|
| MY04 | ติ๋ง | ศิริรัตน์ ผิวขาว | Supervisor WH | CC-SUPPORT-WH | 12,444 |
| MY05 | เมล์ | ภัทราภรณ์ ปัสสาวะกัง | Co-Supervisor HQ-WS | CC-HQ-WS | 10,820 |
| MY11 | จอย | ศิราพร สิทธิรัมย์ | Supervisor + เภสัชกร | CC-04 | 34,000 |
| MY14 | ค๊อป | กษิดิศ สงึมรัมย์ | Supervisor + เภสัชกร | CC-01 | 31,000 |
| MY23 | เดือน | ดวงหทัย ปวนใต้ | Co-Supervisor HQ-WS | CC-HQ-WS | 16,200 |

---

## Group C: Staff (20 คน) — Payroll ✅ | Attendance ✅ | SSO ✅

### CC-HQ-WS (ขายส่ง) — 6 คน

| Code | ชื่อเล่น | ชื่อ-นามสกุล | เงินเดือน |
|------|---------|------------|---------|
| MY06 | น็อต | ปรเมศร์ มีทอง | 10,600 |
| MY08 | อุ้ม | สุวิมล แสงสุข | 10,530 |
| MY10 | เยียร์ | พนัสโชค มีทองแสน | 10,530 |
| MY17 | เค้ก | ณัฐรียา พิมพ์สวัสดิ์ | 10,530 |
| MY19 | ต้อม | อรรถพล คำเบ้า | 10,530 |
| MY22 | เป็ด | ศริพงศ์ ทองแดง | 12,000 |

### CC-01 (ขายปลีก HQ) — 2 คน

| Code | ชื่อเล่น | ชื่อ-นามสกุล | เงินเดือน |
|------|---------|------------|---------|
| MY15 | ปิง | ศศินาพร สุดเอี่ยม | 10,530 |
| MY24 | พิ้ง | ขวัญหทัย กระสันดี | 10,530 |

### CC-04 (สาขา 04) — 2 คน

| Code | ชื่อเล่น | ชื่อ-นามสกุล | เงินเดือน |
|------|---------|------------|---------|
| MY12 | ขิง | ทิพย์วิมล สติมั่น | 10,530 |
| MY26 | หน่อย | สุธิตา ลาภเหลือ | 15,000 |

### CC-SUPPORT-HR — 1 คน

| Code | ชื่อเล่น | ชื่อ-นามสกุล | Role | เงินเดือน |
|------|---------|------------|------|---------|
| MY07 | การ์ตูน | เกวลี สุระวิทย์ | HR Admin | 15,453 |

> ⚠️ Humansoft = "บัญชี" → ใช้จริง = HR Admin

### CC-SUPPORT-FIN — 3 คน

| Code | ชื่อเล่น | ชื่อ-นามสกุล | Role | เงินเดือน |
|------|---------|------------|------|---------|
| MY02 | ก้อย | รัตนาวดี มั่นหมาย | Finance Assistant | 14,484 |
| MY16 | นา | พรนภา โนนสาลี | Finance | 10,530 |
| MY21 | แอ๊ด | ลัดดา สติภา | Finance Assistant | 10,530 |

> ⚠️ ก้อย: Humansoft = "หัวหน้าคลัง" → Finance Assistant
> ⚠️ นา: Role = "Finance" (ไม่ใช่ Finance Lead)

### CC-SUPPORT-IT — 1 คน

| Code | ชื่อเล่น | ชื่อ-นามสกุล | Role | เงินเดือน |
|------|---------|------------|------|---------|
| MY25 | บอส | นนทวัฒน์ บุญปลั่ง | IT Support | 12,500 |

> ⚠️ Humansoft = "คลัง" → IT Support

### CC-SUPPORT-WH — 5 คน

| Code | ชื่อเล่น | ชื่อ-นามสกุล | เงินเดือน |
|------|---------|------------|---------|
| MY01 | ตา | สุจิตรา ทรายทอง | 14,280 |
| MY09 | ปู | สุนัย เลือดขุนทด | 10,530 |
| MY13 | นัด | ธนภัทร ขอชนะ | 10,530 |
| MY18 | ต้อม (เอ) | เอ สีดอน | 10,530 |
| MY20 | ไอซ์ | รวีโรจน์ ใจงาม | 10,530 |

> ⚠️ ติ๋ง (MY04): Humansoft = "พนักงาน" → Supervisor WH

---

## Group D: Facility (0 คน)

> ⚠️ **อัปเดต 25 เม.ย. 2569:** จำเนียร เชิดกลิ่น **ออกจากระบบ** — จ้างแม่บ้านส่วนตัวนอกระบบ
> - ❌ ไม่สร้าง employee record ใน MYHR
> - ✅ CC-SUPPORT-FAC ยังคงอยู่ใน `cost_centers` table เผื่ออนาคต

---

## Group E: Active No Payroll (1 คน)

| Code | ชื่อเล่น | ชื่อ-นามสกุล | SSO |
|------|---------|------------|-----|
| — | สังวาลย์ | สังวาลย์ หาญเหี้ยม | ✅ บริษัทจ่าย contribution |

> ⚠️ สถานะทางกฎหมาย: รอปรึกษาทนายแรงงาน ก่อน go-live

---

## Group F: Product Consultants (3 คน) — Attendance ✅ | Payroll ❌

| Code | ชื่อเล่น | ชื่อ-นามสกุล | Sponsor | เริ่มงาน | LIFF |
|------|---------|------------|---------|---------|------|
| PC01 | ชมพู่ | กัญญาวีร์ สุราช | NBD | 15/03/2021 | ⚡ Limited |
| PC02 | ต่าย | เมตตา แฝงทรัพย์ | Blackmores | 01/10/2025 | ⚡ Limited |
| PC03 | พลอย | เต็มตรอง พิจารณ์ | Wellgate | 20/04/2026 | ⚡ Limited |

- ✅ check-in/out (GPS — ยืนยัน sponsor)
- ⚡ LIFF = view self-attendance only
- ❌ ไม่มี payroll, leave, OT
- อยู่ใต้ Supervisor ค๊อป (CC-01)
- Dev: สร้าง role `pc_staff`

---

## System Access Matrix

| Person/Group | Payroll | Attendance | LIFF | SSO | WHT |
|-------------|---------|-----------|------|-----|-----|
| เฮีย | ✅ 20,000 | ❌ | ✅ | ❌ | ✅ Auto |
| ไนซ์ | ✅ 20,000 | ❌ | ✅ | ❌ | ✅ Auto |
| จิว (CEO02) | ✅ 30,000 | ❌ | ✅ | ✅ 750 | ✅ Auto |
| Supervisors (5) | ✅ | ✅ | ✅ | ✅ | ✅ Auto |
| Staff (20) | ✅ | ✅ | ✅ | ✅ | ✅ Auto |
| จำเนียร | ❌ ออกแล้ว | ❌ | ❌ | ❌ | ❌ |
| สังวาลย์ | ❌ | ❌ | ❌ | ✅ | ❌ |
| PC01-03 | ❌ | ✅ Track | ⚡ Limited | ❌ | ❌ |

---

## Supervisor → Team Mapping

| Supervisor | CC | Team Members |
|-----------|-----|-------------|
| ติ๋ง (MY04) | CC-SUPPORT-WH | MY01, MY09, MY13, MY18, MY20 |
| เมล์ (MY05) + เดือน (MY23) | CC-HQ-WS | MY06, MY08, MY10, MY17, MY19, MY22 |
| ค๊อป (MY14) | CC-01 | MY15, MY24, PC01, PC02, PC03 |
| จอย (MY11) | CC-04 | MY12, MY26 |

---

## Migration Notes for M1

### Manual Add (ไม่อยู่ใน Humansoft)

เตรียมข้อมูลต่อไปนี้สำหรับ add manual ตอน M1:
- **เฮีย:** ชื่อเต็ม, เลข ปชช., วันเริ่มงาน, บัญชีธนาคาร, วันเกิด
- **ไนซ์:** ชื่อเต็ม, เลข ปชช., วันเริ่มงาน, บัญชีธนาคาร, วันเกิด

### Role Corrections from Humansoft

| Employee | Humansoft (ผิด) | MYHR (ถูก) |
|---------|----------------|-----------|
| ก้อย MY02 | หัวหน้าคลัง | Finance Assistant |
| การ์ตูน MY07 | บัญชี | HR Admin |
| บอส MY25 | คลัง | IT Support |
| ติ๋ง MY04 | พนักงาน | Supervisor WH |
| นา MY16 | พนักงาน | Finance |
| จิว CEO02 | salary=0 | 30,000 |

### Pending Info (ต้องเก็บก่อน M1)

- [ ] Verify hire dates: MY23 (เดือน), สังวาลย์, เฮีย, ไนซ์
- [ ] เลข ปชช. + วันเกิด: เฮีย, ไนซ์
- [ ] บัญชีธนาคาร: เฮีย, ไนซ์
- [ ] License number + expiry: ค๊อป (MY14), จอย (MY11)
- [ ] GPS coordinates: HQ-00, HQ-01, CC-04

---

## Change Log

### 25 เม.ย. 2569

- ❌ จำเนียร เชิดกลิ่น ออกจากระบบ (จ้างนอกระบบ)
- ✅ Total: 33 → 32 | Payroll: 30 → 29 | Attendance: 29 → 28
- ✅ C-03 Locked: ลาป่วย ≥1 ครั้ง = ตัดเบี้ยขยัน (Option A)
- ✅ PC LIFF clarified: limited access (attendance only)

### 24 เม.ย. 2569

- ✅ Initial lock — confirmed by เฮีย
- ✅ Resolved 5 role discrepancies
- ✅ Confirmed PC ต้อง track attendance

---

*🔒 Reference file | อ้างอิง Master Data page สำหรับ source of truth*
