# Section 2: ผู้มีส่วนได้ส่วนเสียและผู้ใช้งาน (Stakeholders & Users) 2️⃣

*อัปเดต: 25 เม.ย. 2569*

---

## 2.1 User Personas

### Persona 1: Owner — เฮีย (อมร)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | Owner (เจ้าของบริษัท) |
| ประเภทเงินเดือน | Director (40(1), ไม่เข้า ปกส.) |
| เงินเดือน | 20,000 บาท/เดือน |
| สิทธิ์เข้าถึง | เต็มระบบ |
| อุปกรณ์หลัก | Admin Panel (Desktop) + Mobile (LINE LIFF) |
| ความถี่ใช้งาน | ทุกวัน (สูง) |
| ระดับเทคนิค | สูง (dev + pair programming กับ Claude Code) |

**หน้าที่หลัก:** ตัดสินใจเชิงกลยุทธ์ | Final approval ลา 8+ วัน | Review dashboards | ดูแลระบบ + พัฒนา | กำกับ legal compliance

---

### Persona 2: Owner Delegates — ไนซ์ + จิว (2 คน)

ผู้แทนเจ้าของ มีสิทธิ์เต็มระบบเหมือน Owner — approve, override การ์ตูน, และ run payroll ได้ | Audit log แยกระบุชื่อแต่ละคน

#### ไนซ์ (ภรรยาเฮีย)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | Owner Delegate (Director) |
| ประเภทเงินเดือน | Director (40(1), ไม่เข้า ปกส.) |
| เงินเดือน | 20,000 บาท/เดือน |
| Time Attendance | ❌ Exempt |
| Focus | กำกับดูแล HR + การดำเนินงานประจำวัน |

#### จิว (CEO02 — น้องชายเฮีย)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | Owner Delegate (Executive) |
| ประเภท | Regular Salary (40(1), มี ปกส. 750/เดือน) |
| เงินเดือน | 30,000 บาท/เดือน |
| Time Attendance | ❌ Exempt |
| Focus | Strategic advisor + กำกับดูแล |

**สิทธิ์ร่วมกัน:** Approve ลา/OT ทุกระดับ | Override การ์ตูน | Run payroll | ดู audit log เต็ม | แก้ master data

---

### Persona 3: HR Admin — การ์ตูน (MY07)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | HR Admin |
| เงินเดือน | 15,453 บาท/เดือน |
| Cost Center | CC-SUPPORT-HR |
| อายุงาน | ~8 ปี (เริ่ม 26/02/2018) |
| อุปกรณ์ | Admin Panel (Desktop) เท่านั้น |

**หน้าที่หลัก:** จัดการ master data | Approve ลา/OT ≤7 วัน | PDPA consent | ติดตามใบประกอบวิชาชีพ | Resignation checklist

---

### Persona 4: Finance — นา (MY16)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | Finance |
| เงินเดือน | 10,530 บาท/เดือน |
| Cost Center | CC-SUPPORT-FIN |
| อายุงาน | ~4 ปี (เริ่ม 10/08/2022) |
| อุปกรณ์ | Admin Panel (Desktop) |

**ทีม:** Finance Assistant — ก้อย (MY02, 14,484) และ แอ๊ด (MY21, 10,530)

**หน้าที่หลัก:** Run payroll | ยื่น ปกส. วันที่ 15 | ภ.ง.ด.1 + ภ.ง.ด.1ก + 50 ทวิ | WHT

---

### Persona 5: IT Support — บอส (MY25)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | IT Support |
| เงินเดือน | 12,500 บาท/เดือน |
| Cost Center | CC-SUPPORT-IT |
| อายุงาน | ~1 ปี (เริ่ม 01/08/2025) |

**สิทธิ์:** ❌ Approve ลา/OT | ❌ ดู payroll | ✅ Audit log (technical) | ✅ Device registration

---

### Persona 6: Supervisors (5 คน)

| รหัส | ชื่อเล่น | ชื่อ-นามสกุล | เงินเดือน | ดูแลทีม | Cost Center |
|------|---------|------------|---------|---------|------------|
| MY04 | ติ๋ง | ศิริรัตน์ ผิวขาว | 12,444 | Warehouse (5 คน) | CC-SUPPORT-WH |
| MY05 | เมล์ | ภัทราภรณ์ ปัสสาวะกัง | 10,820 | ขายส่ง (Co-Sup) | CC-HQ-WS |
| MY11 | จอย | ศิราพร สิทธิรัมย์ | 34,000 | สาขา 04 + เภสัชกร | CC-04 |
| MY14 | ค๊อป | กษิดิศ สงึมรัมย์ | 31,000 | ขายปลีก HQ + PC + เภสัชกร | CC-01 |
| MY23 | เดือน | ดวงหทัย ปวนใต้ | 16,200 | ขายส่ง (Co-Sup) | CC-HQ-WS |

**Co-Supervisor (เมล์ + เดือน):** สิทธิ์เท่าเทียม — ใครว่างก่อน approve ก่อน | Audit log ระบุชื่อ

---

### Persona 7: Staff (20 คน)

สิทธิ์: Self-service เท่านั้น | อุปกรณ์: Mobile (LINE LIFF เท่านั้น) | ความถี่: ทุกวัน

---

### Persona 8: Product Consultants — PC01-03 (3 คน)

| รหัส | ชื่อเล่น | ชื่อ-นามสกุล | Sponsor | เริ่มงาน |
|------|---------|------------|---------|---------|
| PC01 | ชมพู่ | กัญญาวีร์ สุราช | NBD | 15/03/2021 |
| PC02 | ต่าย | เมตตา แฝงทรัพย์ | Blackmores | 01/10/2025 |
| PC03 | พลอย | เต็มตรอง พิจารณ์ | Wellgate | 20/04/2026 |

- ✅ Track ใน employee master (reference)
- ❌ ไม่อยู่ใน payroll
- ⚡ **LIFF access จำกัด — ดู self-attendance เท่านั้น** (เพื่อยืนยัน sponsor) ← C-15 Fixed
- ✅ อยู่ใต้ Supervisor ค๊อป (CC-01)

---

### Persona 9 (Special): Active No Payroll — สังวาลย์

| สถานะ | active_no_payroll |
|-------|-----------------|
| เงินเดือน | ไม่มี |
| ปกส. | บริษัทจ่าย contribution |
| สิทธิ์เข้าถึง | ไม่มี |

⚠️ **สถานะทางกฎหมาย: รอปรึกษาทนาย**

---

## 2.2 User Roles & RBAC

### 6 Roles

```typescript
type UserRole =
  | 'owner'           // เฮีย (1)
  | 'owner_delegate'  // ไนซ์ + จิว (2)
  | 'hr_admin'        // การ์ตูน (1)
  | 'finance'         // นา (1) + Finance Assistants
  | 'it_support'      // บอส (1)
  | 'supervisor'      // 5 คน (รวม Co-Sup)
  | 'staff'           // 20 คน
```

**รวม: 6 roles, 29 user accounts** (+ 3 PC limited access + สังวาลย์ SSO-only = 32 total in system) ← C-08 Fixed

**คำอธิบาย:** ✅ เต็ม | 👁️ Read-only | ⚡ มีเงื่อนไข | ❌ ไม่มีสิทธิ์

### ข้อมูลพนักงาน

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ดูพนักงานทั้งหมด | ✅ | ✅ | ✅ | 👁️ | 👁️ | 👁️ ทีม | 👁️ ตัวเอง |
| เพิ่มพนักงาน | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| แก้ master data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| แก้เงินเดือน | ✅ | ✅ | ⚡ | ❌ | ❌ | ❌ | ❌ |
| Offboard | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Attendance

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| Check-in/out | ❌ yv | ❌ yv | ✅ | ✅ | ✅ | ✅ | ✅ |
| ดู attendance ทีม | ✅ | ✅ | ✅ | 👁️ | ❌ | ✅ ทีม | 👁️ ตัวเอง |
| แก้ attendance | ✅ | ✅ | ✅ | ❌ | ❌ | ⚡ ทีม | ❌ |

### ลา/OT

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ขอลา/OT | ❌ yv | ❌ yv | ✅ | ✅ | ✅ | ✅ | ✅ |
| Approve ≤3 วัน | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ ทีม | ❌ |
| Approve 4-7 วัน | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Approve 8+ วัน | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Override | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Payroll

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ดู payroll | ✅ | ✅ | 👁️ | ✅ | ❌ | ❌ | 👁️ ตัวเอง |
| Run Round 1+2 | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| ดู payslip | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ ตัวเอง | ✅ ตัวเอง |

### System

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ดู audit log | ✅ เต็ม | ✅ เต็ม | 👁️ จำกัด | 👁️ payroll | 👁️ tech | ❌ | ❌ |
| จัดการ user account | ✅ | ✅ | ⚡ | ❌ | ✅ | ❌ | ❌ |

---

## 2.3 Access Patterns

| ผู้ใช้ | Interface | Primary Device |
|--------|----------|----------------|
| Staff (20) | LINE LIFF เท่านั้น | Mobile |
| Supervisors (5) | LINE LIFF เป็นหลัก | Mobile |
| HR Admin | Admin Panel เท่านั้น | Desktop |
| Finance | Admin Panel | Desktop |
| IT | Admin Panel | Desktop |
| Owner / Delegates | Admin Panel + LIFF | Desktop + Mobile |
| PC01-03 | LIFF (limited — attendance only) | Mobile |

---

## 2.4 แผนการสื่อสาร

**รายวัน:** 08:00 Quiet ends | 09:00 Supervisor digest | 18:00 สรุป | 22:00 Quiet starts

**รายเดือน:** วันที่ 1 Payroll R1 | วันที่ 15 ปกส. | วันที่ 16 Payroll R2 + payslips | วันที่ 20 KPI review

---

## 2.5 External Stakeholders

| คู่ค้า | วัตถุประสงค์ | ความถี่ |
|--------|-----------|---------|
| ทนายแรงงาน | กฎหมาย | ❗ TBD — ก่อน go-live |
| สำนักงานบัญชี | ภาษี | รายเดือน |
| สปส. | ยื่น ปกส. | รายเดือน (วันที่ 15) |
| กรมสรรพากร | ยื่นภาษี | รายเดือน + รายปี |
| Humansoft | ยกเลิกสัญญา | ม.ค. 2570 |

### Vendors (Tech)

| Vendor | Cost/ปี |
|--------|---------|
| Supabase | 10,800 |
| LINE Corp | 16,435 |
| Anthropic (Claude API) | ~2,400 |
| Cloudflare | 70 |
| GitHub + Sentry | 0 |

---

## 2.6 Onboarding — Learn-by-Doing

1. **UX ที่ดี** — Navigation ง่าย, Inline help, ภาษาไทย
2. **Documentation** — FAQ, Video walkthroughs, Cheat sheets
3. **Ad-hoc Q&A ผ่าน LINE** — LINE group "MYHR Support"
4. **Parallel Run (ธ.ค. 2569)** — Humansoft + MYHR รันคู่กัน

---

## 2.7 Open Action Items

- [ ] หาทนายแรงงาน (critical)
- [ ] Verify hire dates: MY23, สังวาลย์, เฮีย, ไนซ์
- [ ] สร้าง LINE group "MYHR Support"
- [ ] Map supervisor → team members (M1)

---

## 2.8 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | เฮีย | Pending |
| Delegate | ไนซ์ | Pending |
| Delegate | จิว | Pending |
| HR Admin | การ์ตูน | Pending |
| Finance | นา | Pending |
| Legal | TBD | Pending |

---

*Last updated: 25 เม.ย. 2569 | C-08 (headcount 29), C-15 (PC LIFF limited) resolved*
