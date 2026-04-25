# Section 2: ผู้มีส่วนได้ส่วนเสียและผู้ใช้งาน (Stakeholders & Users)

*อัปเดต: 24 เม.ย. 2569*

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

ผู้แทนเจ้าของมีสิทธิ์เต็มระบบเหมือน Owner — ทั้ง approve, override การ์ตูน, และ run payroll ได้ | Audit log แยกระบุชื่อแต่ละคน

#### 2a. ไนซ์ (ภรรยาเฮีย)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | Owner Delegate |
| ประเภทเงินเดือน | Director (40(1), ไม่เข้า ปกส.) |
| เงินเดือน | 20,000 บาท/เดือน |
| Time Attendance | ❌ Exempt (ไม่ต้อง check-in) |
| Focus | กำกับดูแล HR + การดำเนินงานประจำวัน |

#### 2b. จิว (CEO02 — น้องชายเฮีย)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | Owner Delegate |
| ประเภท | Regular Salary (40(1), มี ปกส. 750/เดือน) |
| เงินเดือน | 30,000 บาท/เดือน |
| Time Attendance | ❌ Exempt |
| Focus | Strategic advisor + กำกับดูแล |

**สิทธิ์ร่วมกัน (ทั้ง 2 คน):** Approve ลา/OT ทุกระดับ | Override การ์ตูนได้ | Run payroll | ดู audit log เต็ม | แก้ master data

---

### Persona 3: HR Admin — การ์ตูน (MY07)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | HR Admin |
| ประเภท | Regular Salary (40(1), มี ปกส.) |
| เงินเดือน | 15,453 บาท/เดือน |
| Cost Center | CC-SUPPORT-HR (primary — ช่วย FIN บ้าง) |
| อายุงาน | ~8 ปี (เริ่ม 26/02/2018) |
| อุปกรณ์ | Admin Panel (Desktop) เท่านั้น |

**หน้าที่หลัก:** จัดการ master data | Approve ลา/OT ≤7 วัน | Upload/จัดการเอกสาร | จัดการ PDPA consent | ติดตามใบประกอบวิชาชีพเภสัชกร | ทำ resignation checklist

---

### Persona 4: Finance — นา (MY16)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | Finance |
| ประเภท | Regular Salary (40(1), มี ปกส.) |
| เงินเดือน | 10,530 บาท/เดือน |
| Cost Center | CC-SUPPORT-FIN |
| อายุงาน | ~4 ปี (เริ่ม 10/08/2022) |
| อุปกรณ์ | Admin Panel (Desktop) |
| ความถี่ | รายเดือน (หนัก) + รายวัน (เบา) |

**ทีม:** Finance Assistant 2 คน — ก้อย (MY02, 14,484 บาท) และ แอ๊ด (MY21, 10,530 บาท)

**หน้าที่หลัก:** Run payroll (Round 1 + Round 2) | ยื่น ปกส. (สปส.1-10) วันที่ 15 | สร้างไฟล์ภาษี (ภ.ง.ด.1 + ภ.ง.ด.1ก) | ออก 50 ทวิ | ประสานงานสำนักงานบัญชี | จัดการ WHT

---

### Persona 5: IT Support — บอส (MY25)

| ข้อมูล | รายละเอียด |
|--------|-----------|
| ตำแหน่ง | IT Support |
| ประเภท | Regular Salary (40(1), มี ปกส.) |
| เงินเดือน | 12,500 บาท/เดือน |
| Cost Center | CC-SUPPORT-IT |
| อายุงาน | ~1 ปี (เริ่ม 01/08/2025) |
| ความถี่ | Ad-hoc |

**ขอบเขตสิทธิ์:** ❌ Approve ลา/OT | ❌ ดู payroll | ✅ ดู audit log (technical) | ✅ จัดการ device registration

---

### Persona 6: Supervisors (5 คน)

**ประเภท:** Regular Salary (40(1), มี ปกส.) | อุปกรณ์: Mobile (LINE LIFF) | ความถี่: ทุกวัน

| รหัส | ชื่อเล่น | ชื่อ-นามสกุล | เงินเดือน | ดูแลทีม | Cost Center |
|------|---------|------------|---------|---------|------------|
| MY04 | ติ๋ง | ศิริรัตน์ ผิวขาว | 12,444 | Warehouse (6 คน) | CC-SUPPORT-WH |
| MY05 | เมล์ | ภัทราภรณ์ ปัสสาวะกัง | 10,820 | ขายส่ง (Co-Sup) | CC-HQ-WS |
| MY11 | จอย | ศิราพร สิทธิรัมย์ | 34,000 | สาขา 04 + เภสัชกร | CC-04 |
| MY14 | ค๊อป | กษิดิศ สงึมรัมย์ | 31,000 | ขายปลีก HQ + PC + เภสัชกร | CC-01 |
| MY23 | เดือน | ดวงหทัย ปวนใต้ | 16,200 | ขายส่ง (Co-Sup) | CC-HQ-WS |

**Co-Supervisor Model (เมล์ + เดือน):** สิทธิ์เท่าเทียม — ใคร approve ก่อน = final | Audit log ระบุชื่อ | ไม่มี primary/secondary

---

### Persona 7: Staff (19 คน)

**ประเภท:** Regular Salary (40(1), มี ปกส.) | สิทธิ์: Self-service เท่านั้น | อุปกรณ์: Mobile (LINE LIFF เท่านั้น) | ความถี่: ทุกวัน (check-in/out)

---

### Persona 8: Product Consultants — PC01-03 (3 คน)

**ตำแหน่ง:** PC (ไม่มี login) | Sponsor: NBD / Blackmores / Wellgate | Cost Center: CC-01 | Supervisor: ค๊อป

| รหัส | ชื่อเล่น | ชื่อ-นามสกุล | Sponsor | เริ่มงาน |
|------|---------|------------|---------|---------|
| PC01 | ชมพู่ | กัญญาวีร์ สุราช | NBD | 15/03/2021 |
| PC02 | ต่าย | เมตตา แฝงทรัพย์ | Blackmores | 01/10/2025 |
| PC03 | พลอย | เต็มตรอง พิจารณ์ | Wellgate | 20/04/2026 |

**ลักษณะ:** ✅ Track ใน employee master (reference) | ❌ ไม่อยู่ใน payroll run | ❌ ไม่มี LINE LIFF access | ❌ ไม่ต้อง check-in/out | Commission จาก Bluenote (manual)

---

### Persona 9 (Special): Active No Payroll — สังวาลย์

| ข้อมูล | รายละเอียด |
|--------|-----------|
| สถานะ | active_no_payroll |
| เงินเดือน | ไม่มี |
| ปกส. | 8,000 บาท/ปี (บริษัทจ่าย contribution) |
| สิทธิ์เข้าถึง | ไม่มี |

⚠️ **สถานะทางกฎหมาย: รอปรึกษาทนาย**

---

## 2.2 User Roles & RBAC Matrix

### 6 Roles

```typescript
type UserRole =
  | 'owner'           // เฮีย (1)
  | 'owner_delegate'  // ไนซ์ + จิว (2)
  | 'hr_admin'        // การ์ตูน (1)
  | 'finance'         // นา (1) + Finance Assistants
  | 'it_support'      // บอส (1)
  | 'supervisor'      // 5 คน (รวม Co-Sup)
  | 'staff'           // 19 คน
```

**รวม: 6 roles, 30 user accounts** (+ 3 PC reference + 1 special สังวาลย์ = 33 total)

**คำอธิบาย:** ✅ เข้าถึงเต็ม | 👁️ ดูอย่างเดียว | ⚡ มีเงื่อนไข | ❌ ไม่มีสิทธิ์

### ข้อมูลพนักงาน

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ดูพนักงานทั้งหมด | ✅ | ✅ | ✅ | 👁️ | 👁️ | 👁️ ทีม | 👁️ ตัวเอง |
| เพิ่มพนักงาน | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| แก้ master data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| แก้เงินเดือน | ✅ | ✅ | ⚡ | ❌ | ❌ | ❌ | ❌ |
| Offboard | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### การลงเวลา (Attendance)

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| Check-in/out | ❌ yv | ❌ yv | ✅ | ✅ | ✅ | ✅ | ✅ |
| ดู attendance ทีม | ✅ | ✅ | ✅ | 👁️ | ❌ | ✅ ทีม | 👁️ ตัวเอง |
| แก้ attendance | ✅ | ✅ | ✅ | ❌ | ❌ | ⚡ ทีม | ❌ |
| แก้ shift schedule | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ ทีม | ❌ |

### ลา/OT

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ขอลา/OT | ❌ yv | ❌ yv | ✅ | ✅ | ✅ | ✅ | ✅ |
| Approve ≤3 วัน | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ ทีม | ❌ |
| Approve 4-7 วัน | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Approve 8+ วัน | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Approve OT | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ ทีม | ❌ |
| Override approval | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Payroll

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ดู payroll data | ✅ | ✅ | 👁️ | ✅ | ❌ | ❌ | 👁️ ตัวเอง |
| Run Round 1 | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Run Round 2 | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Configure WHT | ✅ | ✅ | ⚡ | ✅ | ❌ | ❌ | ❌ |
| ดู payslip | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ ตัวเอง | ✅ ตัวเอง |

### Compliance

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| Generate ปกส. | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Generate tax | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| ออก 50 ทวิ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |

### Dashboard

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ดู labor cost | ✅ | ✅ | 👁️ | ✅ | ❌ | ❌ | ❌ |
| ดู KPIs | ✅ | ✅ | ✅ | 👁️ | ❌ | 👁️ ทีม | ❌ |
| Export Excel/PDF | ✅ | ✅ | ✅ | ✅ | ❌ | ⚡ ทีม | ❌ |

### ระบบ (System)

| Permission | Owner | Delegate | HR Admin | Finance | IT | Sup | Staff |
|------------|-------|----------|---------|---------|-----|-----|-------|
| ดู audit log | ✅ เต็ม | ✅ เต็ม | 👁️ จำกัด | 👁️ payroll | 👁️ tech | ❌ | ❌ |
| จัดการ user account | ✅ | ✅ | ⚡ | ❌ | ✅ | ❌ | ❌ |
| แก้ system config | ✅ | ✅ | ❌ | ❌ | ⚡ | ❌ | ❌ |
| ใบประกอบวิชาชีพ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | 👁️ ตัวเอง |

### Conditional Access (⚡) Notes

- **HR Admin แก้เงินเดือน:** เสนอได้ → รอ Owner/Delegate approve
- **Supervisor แก้ attendance:** เฉพาะ missing check-in (ไม่แก้ record ที่มีแล้ว)
- **HR Admin configure WHT:** Toggle ได้ แต่ต้องมีเหตุผลใน audit log
- **HR Admin จัดการ user account:** สร้าง/deactivate ได้ แต่เปลี่ยน role ไม่ได้
- **IT Support system config:** จำกัดเฉพาะ technical settings
- **Supervisor export:** เฉพาะข้อมูลทีมตัวเอง

---

## 2.3 Access Patterns

| ผู้ใช้ | Interface | Primary Device |
|--------|----------|----------------|
| Staff (19) | LINE LIFF เท่านั้น | Mobile |
| Supervisors (5) | LINE LIFF เป็นหลัก | Mobile |
| HR Admin | Admin Panel เท่านั้น | Desktop |
| Finance | Admin Panel | Desktop |
| IT Support | Admin Panel | Desktop |
| Owner | Admin Panel + LIFF | Desktop + Mobile |
| Owner Delegate (ไนซ์) | Admin Panel + LIFF | Desktop + Mobile |
| Owner Delegate (จิว) | Admin Panel + LIFF | Desktop + Mobile |

---

## 2.4 แผนการสื่อสาร (Communication Plan)

**รายวัน:**
- 08:00 — Quiet hours สิ้นสุด
- 09:30 — Supervisor daily digest
- 18:00 — สรุปการลงเวลาสิ้นวัน
- 22:00 — Quiet hours เริ่ม

**รายเดือน:**
- วันที่ 1 — Payroll Round 1
- วันที่ 15 — ยื่น ปกส.
- วันที่ 16 — Payroll Round 2 + payslips
- วันที่ 20 — Monthly KPI review

---

## 2.5 ผู้เกี่ยวข้องภายนอก (External Stakeholders)

| คู่ค้า | วัตถุประสงค์ | ความถี่ |
|--------|-----------|---------|
| **ทนายแรงงาน** | กฎหมาย | ❗ TBD — ก่อน go-live |
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

## 2.6 แนวทาง Onboarding — Learn-by-Doing

ไม่มี formal training — เรียนรู้ผ่าน 4 เสาหลัก:

1. **UX ที่ดี** — Navigation ง่าย, Inline help/tooltips, ภาษาไทยเป็นหลัก
2. **Documentation** — FAQ (LIFF + Admin Panel), Video walkthroughs, Cheat sheets
3. **Ad-hoc Q&A ผ่าน LINE** — LINE group "MYHR Support", Owner + HR Admin ตอบ
4. **Parallel Run (ธ.ค. 2569)** — Humansoft + MYHR run คู่กัน, มี fallback

---

## 2.7 Open Action Items

- [ ] หาทนายแรงงาน (critical — ก่อน go-live)
- [ ] Verify hire dates: MY23, สังวาลย์, จำเนียร, เฮีย, ไนซ์
- [ ] สร้าง LINE group "MYHR Support"
- [ ] สร้าง FAQ content (M4–M6)
- [ ] ถ่าย video walkthroughs (M6–M7)
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

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked*
