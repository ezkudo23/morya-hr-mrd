# Section 4: กฎพื้นฐาน (Foundational Rules)

*กฎสำหรับ Payroll + Attendance + Leave + OT + Compliance | อัปเดต: 25 เม.ย. 2569*

> Section นี้เป็น foundation — workflow ทั้งหมดอ้างอิง rules ใน section นี้

---

## 4.1 Payroll Configuration

### Payroll Cycle

- **รอบจ่าย:** 2 รอบ/เดือน (Round 1 + Round 2)
- **หลัก: /30 fixed:** ค่าแรงต่อวัน = salary / 30 (ไม่ขึ้นกับเดือนมี 28/29/30/31 วัน)
- **การคำนวณรายชม.:** /8 ชม.
- **การปัดเศษ:** คณิตศาสตร์ (≥0.5 ปัดขึ้น, <0.5 ปัดลง) — ทศนิยม 2 ตำแหน่ง
- **Internal storage:** DECIMAL(10, 2)

### Hybrid Salary Logic (🔒 Locked 24 เม.ย. 2569)

```javascript
พนักงานใหม่/ลาออก (เดือนแรก/สุดท้าย):
  salary = base × (worked_days / 30)
  (Days Worked method)

พนักงานเก่า (ทำงานครบเดือน หรือลา):
  deduction = base × (absent_days / 30)
  salary = base - deduction
  (Days Absent method — ทำงานเต็มเดือน = จ่ายเต็ม ไม่ว่าเดือนนั้นกี่วัน)

SSO base = max(1650, min(salary_actual, 15000))
SSO = base × 5% (ปัดคณิต 2 ตำแหน่ง)
```

### วันที่สำคัญ (🔒 Locked 24 เม.ย. 2569)

```
Round 1 (Salary Base):
├── วันที่ 28-สิ้นเดือน  — Finance คำนวณ + ตั้งโอนล่วงหน้า
├── วันที่ 1 (เดือนถัดไป) — เงิน Round 1 เข้าบัญชี (auto)
└── วันที่ 1-7           — Owner approve grace period

Round 2 (Commission + Variable):
├── วันที่ 1-14  — Finance (นา) ดึง commission + OT + เบี้ยขยัน
├── วันที่ 15    — Deadline ตั้งโอน + ยื่น สปส.1-10
└── วันที่ 16    — เงิน Round 2 เข้าบัญชี + payslips
```

### Core Principle: ทำงานก่อน จ่ายทีหลัง

- วันที่ 1 ก.พ. = จ่ายเงินเดือนของ ม.ค. (ที่เพิ่งทำงานเสร็จ)
- Round 1 = salary base (fixed, รู้ล่วงหน้าได้)
- Round 2 = variable (commission, OT, adjustments)

### Onboarding Cut-off

- **เริ่มงาน ≤ วันที่ 28**: เข้า Round 1 เดือนถัดไป (prorated)
- **เริ่มงาน > วันที่ 28**: รอ Round 1 อีกเดือน (skip 1 เดือน)

### ประเภทการจ้าง

| ประเภท | SSO | ปกส. | หมายเหตุ |
|--------|-----|------|---------|
| Regular Salary (ม.40(1)) | ✅ 5%+5% cap 750 | ✅ | Staff, Supervisor, Finance, HR, IT |
| Director Salary (เฮีย, ไนซ์) | ❌ | ❌ | ม.40(1) ไม่เข้า ปกส. |
| Executive (จิว CEO02) | ✅ 750 | ✅ | ม.40(1) regular |

---

## 4.2 OT Rules

### อัตราค่าแรง OT

| ประเภท | อัตรา | เงื่อนไข |
|--------|-------|---------|
| Weekday OT | 1.5x | หลังเวลางานปกติ (ม.61) |
| Holiday Substitute (ร้านเปิดปกติ) | 1.0x + token | รวมอยู่ในแปดแล้ว |
| Holiday Changed (work) | 2.0x | พลิกจาก closed → open — ต้องมี consent |
| OT in Holiday Changed | 3.0x | พนักงานทำเกินกะ |

### OT Cap

- **สูงสุด 36 ชม./สัปดาห์** (hard cap — ระบบ block ถ้าเกิน)

### เภสัชกร (Pharmacist) Special Rate

- **Fix 150 บาท/ชม.** ทั้ง 2 คน (ค๊อป + จอย)
- 🔒 **Locked D17 — Owner accepts legal risk** (ปรึกษาทนายแล้ว ยืนยันตามสัญญาจ้าง)

### OT Request Model (🔒 Locked 25 เม.ย. 2569)

- **Flexible Timing:** "ทำได้ก่อน ขออนุมัติภายหลังภายใน **72 ชม.**"
- **Staff submit เอง** — ตามม.24 (consent)
- **Reject → ชั่วโมงไม่นับ** (ไม่ได้เงิน)
- **OT type:** Auto-detect จากวัน/เวลา (ไม่ต้อง user select)

#### ข้อยกเว้น (Pre-approved)

- **Sale Admin Extended (17:30-18:30):** Owner approve ตารางรายเดือน (วันที่ 28)
- **Holiday Pivot (พลิกปิด → เปิด):** Owner init + ≥7 วันล่วงหน้า + consent พนักงาน

---

## 4.3 Leave Rules

### Leave Types: 9 ประเภท (🔒 Locked 25 เม.ย. 2569)

| # | ประเภทลา | โควตา | จ่าย | กฎหมาย | Half-day | Backdate |
|---|---------|-------|------|--------|---------|---------|
| 1 | ลาพักร้อน | 6 วัน/ปี | ✅ | ม.30 (หลัง 1 ปี) | ✅ | ❌ |
| 2 | ลาป่วย | 30 วัน/ปี | ✅ | ม.32 (3+ วันติด → ใบรับรองแพทย์) | ✅ | ✅ (3 วัน) |
| 3 | ลากิจ | 3 วัน/ปี | ✅ | ม.57/1 | ✅ | ❌ |
| 4 | ลาคลอด | 45+45 วัน | ✅ | ม.41 | ❌ | ❌ |
| 5 | ลาบวช | 15 วัน | ✅ | — | ❌ | ❌ |
| 6 | ลาสมรส | 3 วัน | ✅ | — | ❌ | ❌ |
| 7 | ลาฌาปนกิจ | 5 วัน | ✅ | — | ❌ | ❌ |
| 8 | ลาทหาร (รับราชการ) | ตามหมายเรียก | ✅ (ไม่เกิน 60 วัน) | ม.35 | ❌ | ❌ |
| 9 | ลาฝึกอบรม/วิชาชีพ | 30 วัน/ปี | ✅ | ม.34 | ❌ | ❌ |

> **หมายเหตุ:** ลาไม่ตรงตามประเภทข้างบน (เช่น ลาดูแลบิดา, ลาทำหมัน) → HR ใช้ ลากิจ / ลาฝึกอบรม แทน + manual entry พร้อม note

### รอบโควตาลา

- **รอบ:** ม.ค. - ธ.ค. (ปีปฏิทิน)
- **ไม่สะสมปีถัดไป** — use-or-lose (Model B1)

### Advance Notice (แจ้งล่วงหน้า)

- ลาพักร้อน: **7 วัน**
- ลาป่วย: ทันที (backdate ภายใน 3 วัน + ใบรับรองแพทย์ถ้า 3+ วัน)
- อื่นๆ: **3 วัน**

### Probation (ทดลองงาน)

- **ระยะเวลา:** 119 วัน (เลี่ยง ม.118 severance)
- ✅ เงินเดือน + ปกส. + ลาป่วย
- ❌ ลากิจ (ถือเป็น LWP), ❌ ลาพักร้อน (ยังไม่ครบ 1 ปี)

### Resignation

- **แจ้งล่วงหน้า:** 30 วัน (ม.17)

---

## 4.4 Attendance Rules

### Grace Period & GPS

| Rule | Value |
|------|-------|
| Grace period | **0 นาที** (strict) |
| GPS radius | **100 เมตร** ทุก location |
| Duplicate prevention | **5 นาที** window |

### Partial Shift (Hybrid B2+B3)

```
ชั่วโมงทำงานจริง:
   ├── ≥ 6 ชม.  → full day ✅
   ├── 3-6 ชม. → half day (ต้องมี leave request)
   └── < 3 ชม.  → full day (warning — possible penalty)
```

### เบี้ยขยัน (Diligence Bonus)

- **600 บาท/เดือน** (configurable)

### 🔒 เงื่อนไขตัดเบี้ยขยัน (Locked 25 เม.ย. 2569)

ตัดเบี้ยขยันเต็มจำนวน ถ้าเข้าข้อใดข้อหนึ่ง:

**❌ C-03 (Locked Option A):** ลาป่วย ≥ 1 ครั้ง/เดือน → ตัดเต็ม
> (ไม่ว่าจะกี่วัน ไม่ว่าจะมีใบรับรองแพทย์หรือไม่)

**❌ C-04 (Locked):** สาย + ลืม check-in/out + correction request ≥ 3 ครั้ง/เดือน **รวมกัน** → ตัดเต็ม
> ตัวอย่าง: สาย 1 ครั้ง + ลืม check-out 1 ครั้ง + correction 1 ครั้ง = 3 → ตัด

**❌** ลากิจ/ลาพักร้อนไม่แจ้งล่วงหน้า → ตัดเต็ม

**ลาที่ไม่ตัดเบี้ยขยัน:**
✅ ลาพักร้อน, ลากิจ, ลาคลอด, ลาบวช, ลาสมรส, ลาฌาปนกิจ, ลาทหาร (ม.35), ลาฝึกอบรม (ม.34)

> **ระบุชัดใน "ข้อบังคับการทำงาน" + พนักงานลงลายมือชื่อรับทราบ**

### สาย & ลืม Check-in

- **สาย:** เกิน grace (0 นาที) → นับครั้ง **ไม่หักเงิน**
- **ลืม check-in/out:** นับทุกครั้ง = correction request
- **Counter นับรวม:** สาย + ลืม + correction ≥ 3/เดือน → ตัดเบี้ยขยัน

---

## 4.5 Holiday Rules

### ปี 2569: 13 วัน

```
ร้านปิด (~5 วัน): พนักงานไม่ต้อง check-in รับเงินเดือนปกติ
├── 1 ม.ค. (ปีใหม่)
├── 30 ธ.ค., 31 ธ.ค. (สิ้นปี)
└── +อื่นๆ ตาม Owner decide

ร้านเปิด (~8 วัน): ทำงาน → ได้ substitute token 1.0x
└── ผู้ที่ check-in รับ token ใช้แลกวันหยุดภายใน 30 วัน
```

### Substitute Token Rules

- **Expire:** 30 วัน strict (use-or-lose)
- **แลกวันหยุด:** 1:1 only
- **ไม่แลกเงิน ไม่สะสมข้ามปี**
- **Approval:** Supervisor only

---

## 4.6 Approval Flow

### Sequential Model

```
≤ 3 วัน  → Supervisor
4-7 วัน → Supervisor → HR Admin
8+ วัน  → Supervisor → HR Admin → Owner
```

### SLA

- **4 ชม./ระดับ**
- **Quiet hours (22:00–08:00):** SLA pause → เริ่มใหม่ 08:00
- **Auto-escalation:** 4 ชม. overdue → HR Admin

---

## 4.7 Owner/Delegate Override

### Force Proceed / Emergency Unlock

```yaml
authorized_actors: [Owner, Owner Delegates]
required:
  - reason_note: min 50 chars
  - affected_items: listed
  - confirmation: 2-click
notifications_to: [Owner, All Delegates, HR Admin, Finance]
channel: LINE OA critical (override quiet hours)
audit: Level 2, 2 years retention
```

### Emergency Unlock (Payroll → Draft)

- **2-person approval:** Owner + 1 Delegate (sequential within 1 hr)
- **ใช้ได้ทั้ง before & after ปกส. filed** (🔒 Locked D14)
- **Required reason:** min 100 chars
- **After ปกส. filed:** ต้องยื่น สปส.6-09 แก้ย้อนด้วย

---

## 4.8 Exception Handling

### Correction Window (🔒 Locked — C-06)

| Window | Action | Approver |
|--------|--------|---------|
| 0–24 ชม. | Self-correct via LIFF | Supervisor เท่านั้น |
| 25–72 ชม. | Correction request flow ปกติ | Supervisor → HR Admin |
| > 72 ชม. | HR manual entry | HR Admin + Owner approve |

### Payroll Exception

- **Round 1 pending approvals:** BLOCK → จัดการให้หมดก่อน
- **เหตุผล:** payroll integrity

### Commission

- **Phase 1:** Manual กรอกรายบุคคล (Finance นา)
- **Phase 2:** Bluenote API (pending)
- **Payout:** เข้า Round 2 เท่านั้น

---

## 4.9 PDPA Compliance

### Retention Tier Model (🔒 Locked 25 เม.ย. 2569)

| ระดับ | ข้อมูล | Retention |
|-------|-------|----------|
| 1 | Audit Level 1 (Notification, Login, Read) | 1 ปี → hard delete |
| 2 | Audit Level 2 (Override, Payroll changes, Permission) | 2 ปี → hard delete |
| 3 | Attendance Logs (ตาม พ.ร.บ. ม.115) | 2 ปี |
| 4 | Payroll Records (ตามกฎหมายภาษี) | 7 ปี |
| 5 | Employee Records | ระยะเวลาทำงาน + 2 ปี |

> **Payslip:** เก็บตลอดอายุงาน + 2 ปีหลังออก (สำหรับสมัครสินเชื่อ) — legal minimum = 7 ปี

### Auto-deletion

```
Daily cron (02:00):
├── Scan records past retention period
├── Soft delete → archive 30 วัน
└── Hard delete หลัง 30 วัน

Exception: Legal Hold → Owner/HR freeze record
```

---

## 4.10 Legal Compliance

### กฎหมายที่ใช้

- พ.ร.บ. คุ้มครองแรงงาน 2541
- PDPA 2562
- กฎหมายประกันสังคม

### Filings ที่ต้องทำ

| Filing | ความถี่ | Due Date |
|--------|---------|---------|
| สปส.1-10 (ปกส.) | รายเดือน | วันที่ 15 |
| ภ.ง.ด.1 | รายเดือน | วันที่ 7 เดือนถัดไป |
| ภ.ง.ด.1ก | รายปี | ก.พ. (ปีถัดไป) |
| 50 ทวิ | รายปี | ก.พ. (ปีถัดไป) |

---

## 4.11 สรุปการตัดสินใจสำคัญ

| หัวข้อ | ค่า | อ้างอิง |
|--------|-----|---------|
| Payroll cycle | 2 รอบ/เดือน | 🔒 Locked |
| Salary logic | Hybrid (Days Worked / Days Absent) | 🔒 Locked |
| OT cap | 36 ชม./สัปดาห์ | Hard |
| OT request window | **72 ชม.** | 🔒 Locked |
| เภสัชกร OT | 150 บาท/ชม. fix | 🔒 D17 |
| ลาป่วย ตัดเบี้ยขยัน | ≥ 1 ครั้ง/เดือน = ตัดเต็ม | 🔒 C-03 Option A |
| Counter ตัดเบี้ย | สาย + ลืม + correction รวม ≥ 3 | 🔒 C-04 |
| Correction window | 24hr (self), 72hr (flow), >72hr (manual) | 🔒 C-06 |
| Grace check-in | 0 นาที | Strict |
| GPS radius | 100 เมตร | Fixed |
| Token expire | 30 วัน | Use-or-lose |
| Approval SLA | 4 ชม./ระดับ | — |
| Quiet hours | 22:00–08:00 | 🔒 |
| Probation | 119 วัน | เลี่ยง ม.118 |

---

## 4.12 Open Items

- [ ] Legal consult สำหรับ risks ที่เหลือ (สังวาลย์, Holiday forfeit)
- [ ] ข้อบังคับการทำงาน — update ก่อน go-live (บังคับ)
- [ ] วันหยุด 2570 — กำหนดก่อน 15 ธ.ค. 2569

---

## 4.13 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | เฮีย | Pending |
| HR Admin | การ์ตูน | Pending |
| Finance | นา | Pending |
| Legal | TBD | Pending |

---

*Last updated: 25 เม.ย. 2569 | C-03, C-04, C-06 resolved*
