# Section 6: Payroll 💰

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 6*

> **Status:** ✅ Locked — อัปเดต 1 พ.ค. 2569
> **Scope:** Payroll engine + Payslip + รายการหักพิเศษ
> **Dependencies:** Section 4 (กฎพื้นฐาน), Section 5 (Workflow), Section 7 (Attendance)

---

## 6.1 Payroll Overview

### Two-Round System (🔒 D6-D8)

```
วันที่ 28-สิ้นเดือน: Finance คำนวณ Round 1 + ตั้งโอน
วันที่ 1:            Round 1 เงินเข้าบัญชี (auto)
วันที่ 1-7:          Owner approve grace period
วันที่ 1-14:         Prep Round 2 (OT + commission + เบี้ยขยัน)
วันที่ 15:           ยื่น สปส.1-10 + ตั้งโอน Round 2
วันที่ 16:           Round 2 เงินเข้าบัญชี + Payslips ออก
```

### Headcount

- **Payroll run:** 29 คน (ไม่รวม สังวาลย์ + 3 PC)
- **SSO contribution:** 27 คน (ไม่รวม เฮีย + ไนซ์ ที่ exempt)

---

## 6.2 Salary Calculation — Hybrid Logic (🔒 D9)

```
IF พนักงานใหม่ (เดือนแรก) OR ลาออก (เดือนสุดท้าย):
  USE Days Worked:
    salary = base × (worked_days / 30)

ELSE (พนักงานเก่า):
  USE Days Absent:
    deduction = base × (absent_days / 30)
    salary = base - deduction
```

**หารด้วย 30 fixed เสมอ** — ไม่ว่าเดือนไหนจะมีกี่วัน

### Attendance Exempt

- Director (เฮีย, ไนซ์, จิว) → `absent_days = 0` รับเงินเต็ม
- SSO Exempt (เฮีย, ไนซ์) → ไม่หัก SSO

---

## 6.3 SSO Formula (🔒 D10)

```
base = max(1,650, min(salary_actual, 15,000))
sso  = round(base × 5%, 2)

Cases:
├── salary ≤ 1,650 → SSO = 82.50 (floor)
├── 1,650 < salary < 15,000 → SSO = salary × 5%
└── salary ≥ 15,000 → SSO = 750.00 (cap)
```

Config ใน `system_config` category = `'payroll'`:
```
sso_rate_percent = 5
sso_min_base     = 1650
sso_max_base     = 15000
```

---

## 6.4 Diligence Bonus (เบี้ยขยัน)

**Amount:** 600 บาท/เดือน (DB-driven — `system_config.diligence_amount`)

**ตัดเต็มถ้าเข้าข้อใดข้อหนึ่ง (🔒 C-03, C-04):**
- ❌ ลาป่วย ≥ 1 ครั้ง/เดือน (ไม่ว่ากี่วัน ไม่ว่ามีใบหรือไม่)
- ❌ สาย + ลืม check-in/out + correction รวมกัน ≥ 3/เดือน
- ❌ ลากิจ/ลาพักร้อนไม่แจ้งล่วงหน้า

**Eligibility:**
- ✅ Regular salary ผ่าน Probation + ทำงานครบเดือน
- ❌ Directors, Executives, Probation, เข้า/ออกกลางเดือน, PC, สังวาลย์

---

## 6.5 OT Calculation

**Standard:** `ot_amount = (salary_base / 30 / 8) × rate × hours`

**Rate:**
- `normal` (วันทำงาน) → 1.5x
- `holiday` (วันหยุด) → 3.0x
- เภสัชกร (ค๊อป, จอย) → Fix 150 บาท/ชม. ไม่ว่า type ใด 🔒 D17

**OT Type:** auto-detect จาก `holiday_calendar` (ดู Section 5.3)

---

## 6.6 Commission (🔒 D8)

- Type: 40(1) — **ไม่ใช่ 50 ทวิ** (illegal)
- Phase 1: Manual entry จาก Bluenote (Finance นา)
- Payout: Round 2 เท่านั้น
- ✅ ได้ commission ระหว่าง Probation ปกติ

---

## 6.7 LWP (Leave Without Pay)

- หักตาม `lwp_days`: `lwp_deduction = base × (lwp_days / 30)`
- ต่างจาก `adjustment_amount` — LWP หักตามวันลา ไม่ใช่การปรับยอดข้ามรอบ

---

## 6.8 Adjustment (ปรับยอดข้ามรอบ)

`adjustment_amount` ใน `payroll_details` ใช้สำหรับ:
- ปรับยอดที่คำนวณผิดจาก Round 1 → แก้ใน Round 2
- อาจเป็นบวก (จ่ายเพิ่ม) หรือลบ (หักคืน)
- บันทึกเหตุผลใน `adjustment_note`

> **ต่างจาก `payroll_deductions`** — adjustment ปรับยอดจาก error ส่วน deductions หักรายการพิเศษรายบุคคล

---

## 6.9 รายการหักพิเศษ — payroll_deductions (🔴 ใหม่ 1 พ.ค. 2569)

### ที่มาของ Decision

พนักงานบางคนมีรายการหักพิเศษที่ไม่ใช่ SSO/WHT/LWP เช่น กยศ. หรือคำพิพากษาศาล ต้องการ table แยกเพื่อ:
- รองรับหลายรายการต่อพนักงาน
- DB-driven — HR Admin เพิ่ม/ลบได้จาก Admin Panel
- แสดงใน Payslip แยก section ชัดเจน

### Schema

```sql
payroll_deductions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payroll_detail_id UUID NOT NULL REFERENCES payroll_details(id) ON DELETE CASCADE,
  payroll_run_id    UUID NOT NULL REFERENCES payroll_runs(id) ON DELETE CASCADE,
  employee_id       UUID NOT NULL REFERENCES employees(id),
  deduction_type    TEXT NOT NULL,   -- FK logical → system_config category='deduction'
  label_th          TEXT NOT NULL,   -- ชื่อที่แสดงใน slip เช่น "กยศ." "คำพิพากษาศาล"
  amount            DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  note              TEXT,
  created_by        UUID REFERENCES auth.users(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
)
```

**Link กับ `payroll_details`** (ไม่ใช่ `payroll_runs` โดยตรง) เพราะ net_pay ต้องรวม deductions ด้วย และ audit trail ชัดกว่า

### Deduction Types (DB-driven ใน system_config)

```
category = 'deduction'
student_loan  = กยศ. (กองทุนเงินให้กู้ยืมเพื่อการศึกษา)
court_order   = คำพิพากษาศาล
union_fee     = ค่าสมาชิกสหภาพแรงงาน
advance       = เงินยืมทดรองจ่าย
other         = หักอื่นๆ
```

HR Admin เพิ่ม type ใหม่ได้จาก Admin Panel โดยไม่แตะโค้ด

---

## 6.10 Payslip (🔴 อัปเดต 1 พ.ค. 2569)

### Rules (จาก MRD)

| Item | Value |
|------|-------|
| ออกกี่ใบ | 1 ใบ/เดือน รวม Round 1 + Round 2 |
| ออกวันไหน | วันที่ 16 หลัง Round 2 เงินเข้า |
| Delivery | ผ่าน LIFF + Download PDF |
| PDF Engine | Puppeteer |
| Retention | 7 ปี (tax) / 10 ปี (ม.115) |
| ลายเซ็น | ไม่บังคับตามกฎหมาย — ใช้ชื่อ+ตำแหน่งผู้มีอำนาจแทน |

### รายได้ที่แสดงใน Slip

```
เงินเดือน (prorated_salary จาก R1+R2)
OT (ot_amount จาก R1+R2)
Commission (commission_amount จาก R2 เท่านั้น)
เบี้ยขยัน (diligence_bonus — แสดง "* ถูกตัด" ถ้า diligence_forfeited=true)
รายได้อื่นๆ (other_income)
ปรับยอด (adjustment_amount R1 + R2 + notes)
รวมรายได้ (gross_income)
```

### รายการหักที่แสดงใน Slip

```
ลาไม่รับค่าจ้าง LWP (lwp_deduction — ไม่ใช่ "ลา" กว้างๆ)
ประกันสังคม (sso_employee)
ภาษี ณ ที่จ่าย (wht_amount)
รายการหักพิเศษ (payroll_deductions array — loop แสดงทุกรายการ)
รวมหัก
```

### YTD ที่แสดง

```
รายได้สะสม (gross_income YTD)
ภาษีสะสม (wht YTD)
SSO ลูกจ้างสะสม
SSO นายจ้างสมทบสะสม
```

### หมายเหตุ / ผู้มีอำนาจลงนาม

```
payslip_note          — HR Admin กรอกรายบุคคล แสดงเฉพาะถ้ามีข้อมูล
authorized_signer_name     — ดึงจาก system_config category='payslip'
authorized_signer_position — ดึงจาก system_config category='payslip'
```

### ขนาด / Layout

```
A4 แนวตั้ง (210×297mm)
├── Mobile View: Scroll แนวตั้ง section by section
└── PDF/Print: A4 แนวตั้ง พิมพ์ได้ทันที
```

---

## 6.11 get_payslip RPC (🔴 ใหม่ 1 พ.ค. 2569)

### Signature

```sql
get_payslip(
  p_employee_id UUID,
  p_year        INTEGER DEFAULT EXTRACT(YEAR FROM CURRENT_DATE),
  p_month       INTEGER DEFAULT EXTRACT(MONTH FROM CURRENT_DATE)
) RETURNS JSONB
```

### Logic

- **Authorization:** พนักงานดูของตัวเองได้ผ่าน `auth.uid()` | owner/delegate/hr_admin/finance ดูของคนอื่นได้
- **Merge:** Round 1 + Round 2 → 1 slip (ถ้า R2 ยังไม่มี → คืน `PAYSLIP_NOT_READY`)
- **YTD:** `SUM` ย้อนหลังตั้งแต่ต้นปีถึงเดือนปัจจุบัน
- **Company info:** ดึงจาก `system_config` category=`'company'`
- **Authorized signer:** ดึงจาก `system_config` category=`'payslip'`
- **Special deductions:** loop จาก `payroll_deductions` ของ Round 2

### Response Structure

```json
{
  "success": true,
  "company": { "name", "address", "tax_id", "tel" },
  "employee": { "employee_code", "full_name_th", "position_th", "cost_center", "bank_name", "bank_account" },
  "income": { "base_salary", "worked_days", "absent_days", "prorated_salary", "ot_amount", "commission", "diligence_bonus", "diligence_forfeited", "other_income", "adjustment_r1", "adjustment_r2", "gross_income" },
  "deductions": { "lwp_days", "lwp_deduction", "sso_base", "sso_employee", "sso_employer", "wht_amount", "special_deductions": [] },
  "net_pay": 20000,
  "payslip_note": null,
  "ytd": { "gross_income", "wht", "sso_employee", "sso_employer" },
  "payment": { "period_start", "period_end", "r1_date", "r2_date" },
  "authorized_signer": { "name", "position" }
}
```

---

## 6.12 system_config — Payroll & Company Info

### category = 'company' (🔴 ใหม่ 1 พ.ค. 2569)

```
name    = บริษัท หมอยาสุรินทร์ จำกัด
address = 30,32 ถนนกรุงศรีใน ตำบลในเมือง อำเภอเมืองสุรินทร์ จังหวัดสุรินทร์ 32000
tax_id  = 0325557000531
tel     = 0800891000
```

### category = 'payslip' (🔴 ใหม่ 1 พ.ค. 2569)

```
authorized_signer_name     = อมร เกียรติคุณรัตน์
authorized_signer_position = กรรมการผู้จัดการ
```

### category = 'payroll' (มีอยู่แล้ว)

```
round1_cutoff_day        = 28
round1_grace_end_day     = 7
round2_commission_end_day = 14
salary_divisor           = 30
sso_rate_percent         = 5
sso_min_base             = 1650
sso_max_base             = 15000
```

---

## 6.13 DB Schema — Payroll Tables

### payroll_runs

```
id, period_year, period_month, round (1|2),
status (draft/approved/transferred/locked/closed),
total_employees, total_gross, total_net,
total_sso_employee, total_sso_employer, total_wht,
approved_by, approved_at, transferred_at, locked_at,
is_unlocked, unlock_approver_1/2, unlock_reason, unlocked_at,
note, created_by, created_at, updated_at
```

### payroll_details

```
id, payroll_run_id, employee_id,
base_salary, worked_days, absent_days, prorated_salary,
lwp_days, lwp_deduction,
ot_amount, commission_amount,
diligence_bonus, diligence_forfeited,
other_income, adjustment_amount, adjustment_note,
gross_income,
sso_base, sso_employee, sso_employer,
wht_amount, wht_ytd,
net_pay, calculation_method,
payslip_note,     ← ใหม่ 1 พ.ค. 2569
created_at
```

### payroll_deductions (🔴 ใหม่ 1 พ.ค. 2569)

```
id, payroll_detail_id, payroll_run_id, employee_id,
deduction_type, label_th, amount, note,
created_by, created_at
```

---

## 6.14 Payroll Rollback Procedure

```sql
-- 1. ลบ details ก่อน
DELETE FROM payroll_details WHERE payroll_run_id = '{id}';

-- 2. ลบ run
DELETE FROM payroll_runs WHERE id = '{id}';

-- 3. Run ใหม่ได้เลย
-- หมายเหตุ: FATAL_ERROR จะ auto DELETE payroll_runs
```

---

## 6.15 Holiday Guard (🔴 ใหม่ 1 พ.ค. 2569)

ก่อน run payroll รอบแรกของปีใหม่:
- ระบบตรวจ `holiday_calendar` ว่ามีวันหยุดของปีนั้นครบหรือไม่
- ถ้าน้อยกว่า threshold → แสดง warning บน Payroll page + block run
- วัตถุประสงค์: ป้องกันคำนวณ absent_days ผิดเพราะไม่มีวันหยุดในระบบ
- **Deadline seed:** ก่อน run payroll เดือน ม.ค. ของปีนั้น

---

## 6.16 สรุปการตัดสินใจ

| หัวข้อ | ค่า | อ้างอิง |
|--------|-----|---------|
| Payroll cycle | 2 รอบ/เดือน | 🔒 D6 |
| Salary logic | Hybrid (Days Worked / Days Absent) | 🔒 D9 |
| SSO | max(1650, min(salary, 15000)) × 5% | 🔒 D10 |
| เภสัชกร OT | 150 บาท/ชม. fix | 🔒 D17 ✅ Legal |
| Commission | 40(1), Round 2 only | 🔒 D8 |
| Payslip | 1 ใบ/เดือน, วันที่ 16 | ✅ |
| Payslip layout | A4 แนวตั้ง | ✅ |
| รายการหักพิเศษ | payroll_deductions table | ✅ ใหม่ |
| ลายเซ็น slip | ไม่บังคับ กม. — ใช้ชื่อ+ตำแหน่ง | ✅ |
| Holiday Guard | Block payroll ถ้าไม่มีวันหยุดปีนั้น | ⏳ Pending |

---

## 6.17 Open Items

- [ ] Payroll Summary UI
- [ ] Payroll Rollback UI
- [ ] Payslip Page (LIFF)
- [ ] PDF export (Puppeteer)
- [ ] Holiday Guard implement บน Payroll page
- [ ] Initialize `leave_balances` ปี 2570 ก่อน Go-Live
- [ ] Diligence amount → DB-driven (ตอนนี้ hardcode 500 → ควรเป็น 600 ตาม MRD)

---

*Last updated: 1 พ.ค. 2569 | เพิ่ม payroll_deductions, payslip spec, get_payslip RPC, company/payslip system_config, holiday guard*
