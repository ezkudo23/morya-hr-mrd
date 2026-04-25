# Section 6: เงินเดือนและการจ่ายค่าตอบแทน (Payroll)

> **Notion ref**: https://www.notion.so/34c9e022ec8081d2afe0ccf9cd896ae9
> **Status**: ✅ Locked — 25 เม.ย. 2569
> **Scope**: ระบบคำนวณและจ่ายค่าตอบแทนพนักงาน 30 คน
> **Dependencies**: Section 4 (Rules), Section 7 (Attendance)

---

## 6.1 ภาพรวม

### วัตถุประสงค์
ระบบคำนวณและจ่ายค่าตอบแทนพนักงาน 30 คน (20 staff + 5 supervisor + 1 facility + 3 director/delegate + 1 Executive จิว) ให้:
- ถูกต้องตามกฎหมาย (กรมสวัสดิการฯ, ปกส., สรรพากร)
- ตรงเวลาทุกเดือน (no delay)
- โปร่งใส พนักงานตรวจสอบได้
- ลดงาน HR (target: 16 ชม. → 4 ชม./เดือน)

### Cycle 2 รอบ — D6, D7, D8
```
Payroll Cycle: 1-31 ของเดือนก่อนหน้า
├── ก่อนวันที่ 28:                  Finance pre-check
├── วันที่ 28-สิ้นเดือน:              Finance ตั้งโอนล่วงหน้า
├── Round 1 (วันที่ 1 เดือนใหม่):    เงินเดือนฐาน + หัก ปกส. + WHT baseline (auto)
├── วันที่ 1-7:                     Owner approve grace period
├── Prep Window (วันที่ 1-14):       OT + คอม + เบี้ยขยัน
├── วันที่ 15:                       ยื่น สปส.1-10
└── Round 2 (วันที่ 16):             OT + คอม + เบี้ยขยัน + WHT recalc + payslips
```

### ผู้เกี่ยวข้อง

| Role | หน้าที่ |
|---|---|
| **Finance (นา + ก้อย + แอ๊ด)** | คำนวณ, ตั้งโอน, ยื่นภาษี, ยื่น ปกส. |
| **HR Admin (การ์ตูน)** | เคลียร์ corrections, นับเบี้ยขยัน, ดูแล payslip |
| **Owner (เฮีย/ไนซ์)** | Approve payroll run (grace 1-7) |
| **พนักงาน** | ดูสลิปผ่าน LIFF (ตลอดอายุงาน) |

### Employee Groups

```
Group A: Regular Payroll (27 คน)
├── 40(1) + SSO + เบี้ยขยัน + OT + คอม
└── 5 Sup + 20 Staff + 1 Facility + 1 Executive จิว

Group B: Director Exempt (2 คน: เฮีย, ไนซ์)
├── 40(1) + ไม่มี SSO + ไม่มีเบี้ยขยัน + ไม่มี OT
├── ไม่อยู่ใน Humansoft — migrate เข้า MYHR ตอน M1
└── ยื่น ภ.ง.ด.1, 50 ทวิ ปกติ

Group C: Executive (1 คน: จิว CEO02)
├── 40(1) + SSO 750 + ไม่มีเบี้ยขยัน + ไม่มี OT
└── ยื่นภาษีปกติ

Group D: Not in Payroll (4 คน)
├── 3 PC: คอมล้วน จ่ายตามรอบของ Principal
└── สังวาลย์: active_no_payroll (SSO contribution only)
```

> 📌 **Total Payroll: 30 คน** (27A + 2B + 1C)

---

## 6.2 องค์ประกอบเงินเดือน

### รายได้ (Income)

| # | ประเภท | ฐาน | Type | SSO | WHT |
|---|---|---|---|---|---|
| 1 | เงินเดือน (Base) | ต่อเดือน | 40(1) | ✅ | ✅ |
| 2 | OT | ตามชั่วโมง | 40(1) | ❌ | ✅ |
| 3 | คอมมิชชัน | ตามยอดขาย | 40(1) | ❌ | ✅ |
| 4 | เบี้ยขยัน | 600 fixed | 40(1) | ❌ | ✅ |
| 5 | ค่าใบประกอบวิชาชีพ | ตามสัญญา | 40(1) | ❌ | ✅ |
| 6 | โบนัส | per event | 40(1) | ❌ | ✅ |

**สำคัญ:**
- **SSO ฐาน = เงินเดือนประจำเท่านั้น** (ไม่รวม OT/คอม/เบี้ย)
- **WHT ฐาน = รายได้ทั้งหมด 40(1)** × 12 → ขั้นบันได
- **Commission ใช้ 40(1) เสมอ** — NEVER ใช้ 50 ทวิ

### รายการหัก (Deductions)

| # | ประเภท | อัตรา | หัก Round |
|---|---|---|---|
| 1 | ปกส. (SSO) | 5% ฐานเงินเดือน, cap 750, floor 82.50 | Round 1 |
| 2 | WHT | ขั้นบันได × 12 | Round 1 + Round 2 (recalc) |
| 3 | กยศ. | ตามยอดแจ้ง | Round 1 |
| 4 | คำสั่งศาล | ตามคำสั่ง | Round 1 |
| 5 | LWP | ตามวันลา | Round 1 |
| 6 | ตัดเบี้ยขยัน | -600 | Round 2 (ไม่จ่าย) |

---

## 6.3 การคำนวณ Prorated — Hybrid Logic D9

### หลักการ
```
เงินเดือนรายวัน    = เงินเดือน ÷ 30 (fixed)
เงินเดือนรายชั่วโมง = เงินเดือนรายวัน ÷ 8
```

**เหตุผลใช้ ÷ 30:**
- มาตรฐานราชการไทย
- ลด dispute (ทุกคนได้เท่ากันต่อวัน)
- ตรงกับ Humansoft เดิม
- ทำงานครบเดือน = จ่ายเต็ม (ไม่ขึ้นกับ ก.พ. 28 หรือ ม.ค. 31)

### Examples (Hybrid Logic)

> 💡 ใช้ Days Worked สำหรับพนักงานใหม่/ลาออก — ใช้ Days Absent สำหรับพนักงานเก่าที่ลา

**Case 1: พนักงานใหม่ — Days Worked**
```
นาย A เข้า 15 มี.ค., เงินเดือน 15,000, ทำ 17 วัน
salary = 15,000 × (17/30) = 8,500
SSO = 8,500 × 5% = 425
```

**Case 2: ลาออกกลางเดือน — Days Worked**
```
นาง B ลาออก 20 พ.ค., เงินเดือน 20,000, ทำ 20 วัน
salary = 20,000 × (20/30) = 13,333.33
SSO = 13,333.33 × 5% = 666.67
```

**Case 3: พนักงานเก่า LWP — Days Absent**
```
นาย C (เก่า, ทำงานมาหลายปี), เงินเดือน 18,000, LWP 2 วัน
deduction = 18,000 × (2/30) = 1,200
salary = 18,000 - 1,200 = 16,800
SSO = 16,800 × 5% = 750 (cap)
```

**Case 4: พนักงานเก่า ทำงานครบเดือน ก.พ. — Days Absent**
```
นาง D ทำงานครบเดือน ก.พ. (28 วัน), เงินเดือน 10,530
deduction = 0 (ทำงานครบเดือน)
salary = 10,530 เต็ม (ไม่ว่า ก.พ. จะมี 28/29 วัน)
SSO = 10,530 × 5% = 526.50
```

**Case 5: SSO Floor — Days Worked + ฐานต่ำสุด 1,650**
```
นาย E เริ่มงาน 28 มี.ค., เงินเดือน 10,530, ทำ 4 วัน
salary = 10,530 × (4/30) = 1,404
SSO base = max(1,650, 1,404) = 1,650 (ใช้ฐานต่ำสุดตาม ปกส. ม.47)
SSO = 1,650 × 5% = 82.50
Net = 1,404 - 82.50 = 1,321.50
```

### OT Rate Calculation
```
OT Base Rate = เงินเดือน ÷ 30 ÷ 8

Example: 15,000 → 62.50 บาท/ชม.
1.5x (Weekday):          93.75
1.0x (Holiday sub):      62.50
2.0x (Holiday changed):  125.00
3.0x (OT in holiday):    187.50

Pharmacist: Fix 150 บาท/ชม. (Locked — Owner accepts legal risk, D17)
```

---

## 6.4 ประกันสังคม (SSO) — D10

### หลักการ
```
อัตรา:            5% ลูกจ้าง + 5% นายจ้าง
ฐาน:             เงินเดือนประจำเท่านั้น
ฐานต่ำสุด:        1,650 (SSO 82.50)
ฐานสูงสุด:        15,000 (SSO 750 cap)
```

### Matrix

| เงินเดือน (จริง/prorated) | ฐาน | หัก |
|---|---|---|
| < 1,650 | 1,650 | 82.50 |
| 9,000 | 9,000 | 450 |
| 10,530 | 10,530 | 526.50 |
| 12,500 | 12,500 | 625 |
| 15,000+ | 15,000 | 750 (cap) |

### Edge Cases
- **พนักงานใหม่กลางเดือน:** ฐาน = prorated salary
- **LWP:** ฐาน = เงินเดือนหลัง LWP
- **Director (เฮีย/ไนซ์):** ยกเว้น ปกส.
- **จิว (CEO02):** regular_salary → SSO 750

### การยื่น สปส.1-10
```
วันที่ 15 ของเดือน: ยื่นออนไลน์ (deadline)
วันที่ 16: ชำระเงินผ่าน bank e-payment
```

---

## 6.5 ภาษี ณ ที่จ่าย (WHT) — Pure Auto Mode

### LOCKED: Option C — Pure Auto
```
✅ Auto calculate ทุกคน ทุกเดือน
❌ ไม่มี toggle เปิด/ปิด
✅ Compliant ม.50, ม.52, ม.54
```

### ฐานกฎหมาย
- **ม.50(1):** "ให้หักภาษี" — Duty not Right
- **ม.52:** ห้ามตกลงยกเว้น (โมฆะ)
- **ม.54:** นายจ้างรับผิดร่วม ถ้าไม่หัก

### สูตรคำนวณ
```
Step 1: Projected Annual Income
  = (Base + OT + คอม + เบี้ยขยัน) × 12

Step 2: หักค่าใช้จ่าย 50% (cap 100,000)

Step 3: หักลดหย่อน
  Default: ส่วนตัว 60,000 + SSO ทั้งปี
  Optional: RMF/SSF, ประกัน, ดอกเบี้ยบ้าน

Step 4: ขั้นบันได
  0-150K: 0%, 150K-300K: 5%, 300K-500K: 10%, ...

Step 5: ÷ 12 = WHT/เดือน (Half-Up)
```

### Two-Stage Calculation
```
Round 1 (วันที่ 1):
  ฐาน = Base × 12
  หัก WHT baseline

Round 2 (วันที่ 16):
  ฐาน = (Base + OT + คอม + เบี้ยขยัน) × 12
  Recalc → หักส่วนต่าง
  (ถ้าน้อยกว่า ไม่คืน สะสมไว้เดือนถัดไป)
```

### Expected WHT Matrix

| Employee | Salary | Expected WHT/เดือน |
|---|---|---|
| เฮีย | 20,000 | 0 (240K < เกณฑ์) |
| ไนซ์ | 20,000 | 0 |
| จิว | 30,000 | ~0-50 (borderline) |
| ค๊อบ | 31,000 | ~220 |
| จอย | 34,000 | ~370 |
| Staff ทั่วไป | <20K | 0 |

**Insight:** ~80% ของพนักงาน WHT = 0 auto

---

## 6.6 เบี้ยขยัน (Diligence Bonus) — D16

### Configuration
```
Default: 600 บาท/เดือน
Type: 40(1) income (เข้า WHT, ไม่เข้า SSO)
จ่ายรอบ: Round 2 (วันที่ 16)
```

### เงื่อนไขการตัดเบี้ยขยัน (4 ข้อ) — Locked 25 เม.ย. 2569
```
ตัดเบี้ยขยันเต็มจำนวน ถ้าเข้าข้อใดข้อหนึ่ง:

❌ ลาป่วย ≥1 ครั้ง/เดือน (ติดต่อ 3 วัน ไม่มีใบรับรองแพทย์ → ตัด)
❌ สาย ≥3 ครั้ง/เดือน
❌ ลืมลงเวลา + Correction request ≥3 ครั้ง (รวมกัน)
❌ ลากิจ/ลาพักร้อนไม่แจ้งล่วงหน้า

(เข้า 1 ข้อ = ตัดทั้ง 600 — ไม่ตัดซ้ำ)
```

### ลาที่ไม่ตัดเบี้ยขยัน
```
✅ ลาพักร้อน, ลากิจ, ลาคลอด, ลาบวช, ลาสมรส, ลาฌาปนกิจ,
   ลาทหาร (ม.35), ลาฝึกอบรม/อบรมวิชาชีพ (ม.34)

❌ ลาป่วย ≥1 ครั้ง: ตัด — เจตนา: ดูแลสุขภาพตัวเอง
   ยกเว้น: ติดต่อ 3 วัน + ไม่มีใบรับรอง → ตัด
```

### Eligibility
```
✅ พนักงาน regular_salary ผ่าน Probation + ทำงานครบเดือน

❌ Owner + Delegate (Director), Executive, พนักงาน probation,
   เข้า/ออกกลางเดือน, PC, สังวาลย์
```

### Legal
```
✅ เบี้ยขยัน = สวัสดิการ, ไม่ใช่ค่าจ้าง
✅ นายจ้างมีสิทธิ์กำหนดเงื่อนไข
⚠️ ต้องระบุใน "ข้อบังคับการทำงาน" + พนักงานลงลายมือชื่อ
```

---

## 6.7 ค่าปรับ (Penalties) — Round 1

```
1. Leave Without Pay (LWP):
   - หัก (salary ÷ 30) × จำนวนวัน
   - ใช้เมื่อ: ลาเกิน quota, ขาดงาน, ไม่มีลา

2. ตัดเบี้ยขยัน (ไม่จ่าย Round 2):
   - 600 บาท (default)
   - Trigger: 4 เงื่อนไขข้างต้น

3. OT ไม่ได้รับอนุมัติ:
   - ชั่วโมงไม่นับ (ไม่ได้เงิน)
   - Trigger: supervisor reject OT request
```

### ไม่มีค่าปรับเพิ่ม
```
❌ ไม่มีค่าปรับสายเป็นเงิน
❌ ไม่มีค่าปรับลืม check-in (ใช้ตัดเบี้ยขยันแทน)

เหตุผล: ม.76 จำกัดการลงโทษทางเงิน
```

---

## 6.8 คอมมิชชัน (Commission) — D8

### หลักการ
```
Type: 40(1) income
Input: Manual entry จาก Bluenote (Phase 1)
เข้ารอบ: Round 2 (วันที่ 16)

❌ NOT 50 ทวิ — ผิดกฎหมายสำหรับลูกจ้าง
```

### Workflow
```
วันที่ 1-14: Finance ดึง commission report จาก Bluenote + verify + input
วันที่ 15: Deadline ตั้งโอน Round 2
วันที่ 16: จ่ายใน Round 2 + เข้า WHT recalc
```

### During Probation
```
✅ ได้ commission ปกติ — performance-based
(ต่างจากเบี้ยขยันที่ต้องผ่าน Probation ก่อน)
```

---

## 6.9 Payroll Schedule (2 รอบ)

### Full Timeline
```
เดือน N (เดือนก่อนหน้า):
├── 1-31: พนักงานทำงาน
├── วันที่ 28-สิ้นเดือน: Finance คำนวณ + ตั้งโอนล่วงหน้า ⭐
└── 31: ปิดรอบ attendance

เดือน N+1:
├── วันที่ 1: ROUND 1 เงินเข้าบัญชี (auto — scheduled transfer)
│   ตามคอนเซ็ปต์ "ทำงานก่อน จ่ายทีหลัง"
│
├── วันที่ 1-7: OWNER APPROVE GRACE PERIOD
│   ├── Owner approve ได้ภายหลัง
│   └── ถ้าพบ error → adjust ใน Round 2
│
├── วันที่ 1-14: PREP WINDOW (Round 2)
│   ├── Finance (นา) รวบรวม OT + คอม + เบี้ยขยัน
│   └── HR เคลียร์ corrections
│
├── วันที่ 15: FILE SSO + ตั้งโอน ROUND 2
│   ├── ยื่น สปส.1-10 ออนไลน์
│   └── Deadline ตั้งโอน Round 2
│
├── วันที่ 16: ROUND 2 เงินเข้าบัญชี (auto)
│   ├── OT + commission + เบี้ยขยัน
│   ├── WHT recalc ส่วนต่าง
│   └── ส่งสลิปรวม Round 1+2 (1 ใบ/เดือน)
│
└── วันที่ 7 (เดือน N+2):
    └── ยื่น ภ.ง.ด.1 เดือน N
```

### Round 1 Pre-Check (วันที่ 28)
```
Finance ต้องเคลียร์ก่อนตั้งโอน:
├── Pending corrections ของเดือนก่อนหน้า
├── Pending OT approvals เกิน 72 ชม.
├── Incomplete attendance logs (ลืม check-in/out)
└── Bank account พนักงานใหม่ยังไม่มี

Action:
- ถ้ามีปัญหา → HR/Finance เคลียร์ก่อน 28
- ตั้งโอนไปแล้วพบ error → adjust ใน Round 2
- ถ้า issue ใหญ่ → Emergency Unlock
```

### Owner Approve Grace (วันที่ 1-7)
```
หลังเงินเข้าบัญชีแล้ว (วันที่ 1):
├── Owner approve ได้ถึงวันที่ 7
├── ถ้า approve ผ่าน → lock Round 1
└── ถ้าพบ issue → adjust Round 2
```

---

## 6.10 สลิปเงินเดือน (Payslip)

### Configuration (Locked)
```
✅ ออก 1 ใบ/เดือน (รวม Round 1 + Round 2)
✅ ออกวันที่ 16 (หลัง Round 2)
✅ Retention: ตลอดอายุงาน (สำหรับสมัครสินเชื่อ)
✅ Delivery: ผ่าน LIFF (download PDF)
```

### Layout Requirements
```
Section 1: ข้อมูลทั่วไป
├── บริษัท (หมอยาสุรินทร์, 0325557000531)
├── พนักงาน (ชื่อ, รหัส, ตำแหน่ง, สาขา)
└── งวด (เดือน/ปี, วันที่ออก)

Section 2: รายได้
├── เงินเดือนฐาน, OT (ระบุชม. + rate), คอมมิชชัน
├── เบี้ยขยัน (หรือ -600 ถ้าถูกตัด)
└── รวมรายได้

Section 3: รายการหัก
├── ปกส. (5%), WHT (Round 1 + ส่วนต่าง R2)
├── LWP (ถ้ามี), กยศ./คำสั่งศาล (ถ้ามี)
└── รวมหัก

Section 4: สรุป
├── เงินสุทธิ Round 1 + Round 2
├── บัญชีธนาคาร (4 ตัวท้าย)
└── Cumulative YTD

Section 5: Footer (QR verify, ติดต่อ HR)
```

### Example Payslip
```
═══════════════════════════════════════
      บริษัท หมอยาสุรินทร์ จำกัด
       0325557000531
       PAYSLIP — งวดเดือน มี.ค. 2570
       (ออกสลิปวันที่ 16 เม.ย.)
═══════════════════════════════════════

พนักงาน: MY14 กษิดิศ สงึมรัมย์ (ค๊อบ)
ตำแหน่ง: Supervisor + เภสัชกร CC-01
งวด: 1-31 มี.ค. 2570
ออกสลิป: 16 เม.ย. 2570

─── รายได้ ──────────────────────────
เงินเดือน                     31,000.00
OT (6 ชม. × 1.5x)                810.00
เบี้ยขยัน                        600.00
─────────────────────────────────────
รวมรายได้:                    32,410.00

─── รายการหัก ──────────────────────
ปกส. (5%)                       -750.00
WHT (Round 1 + Round 2)         -240.00
─────────────────────────────────────
รวมหัก:                          -990.00

─── สรุป ─────────────────────────────
Net Pay Round 1 (จ่าย 1 เม.ย.):  30,010.00
Net Pay Round 2 (จ่าย 16 เม.ย.):  1,410.00
Round total:                  31,420.00

Bank: SCB 4 ตัวท้าย: 1234

─── YTD Summary ────────────────────
รายได้สะสมปีนี้:           97,230.00
ภาษีสะสมปีนี้:                720.00
ปกส.สะสมปีนี้:              2,250.00
═══════════════════════════════════════
```

---

## 6.11 Data Model

```sql
payroll_runs
├── id (UUID)
├── period_year, period_month, round (1 or 2)
├── status ('draft', 'approved', 'transferred', 'locked')
├── approved_by, approved_at, transferred_at
├── total_gross, total_deductions, total_net
├── employee_count
└── created_at, updated_at

payroll_details (per employee per round)
├── employee_id (FK)
├── base_salary, prorated_days, prorated_salary
├── ot_hours_*, ot_amount_total
├── commission_amount, diligence_bonus
├── diligence_forfeited, diligence_forfeit_reason
├── license_fee (pharmacist), bonus
├── gross_income
├── sso_base, sso_deduction
├── wht_projected_annual, wht_deduction_round_1, wht_deduction_round_2
├── lwp_days, lwp_amount
├── other_deductions (JSON), net_pay
├── bank_account (last 4 digits), payslip_url
└── created_at, updated_at

wht_declarations (ลย.01)
├── employee_id, year
├── personal_allowance (default 60K)
├── spouse_allowance, child_allowance, parent_allowance
├── insurance_premium, rmf_ssf_amount, home_loan_interest
├── other_allowances (JSON), total_allowances
├── submitted_at, approved_by (HR)
└── created_at, updated_at
```

### RLS
```sql
-- พนักงานเห็นสลิปตัวเองเท่านั้น
CREATE POLICY payslip_self_only
ON payroll_details FOR SELECT
USING (employee_id = current_user_employee_id());

-- Finance + HR + Owner เห็นทั้งหมด
CREATE POLICY payslip_admin
ON payroll_details FOR SELECT
USING (current_user_role() IN ('finance', 'hr_admin', 'owner', 'owner_delegate'));
```

---

## 6.12 Edge Cases

```
1. ✅ พนักงานใหม่ → Days Worked (prorate ÷ 30)
2. ✅ ลาออกกลางเดือน → Days Worked + settle outstanding
3. ✅ LWP พนักงานเก่า → Days Absent
4. ✅ Round 1 error → Round 2 adjust (ไม่ใช้ Emergency Unlock เว้นเคสใหญ่)
5. ✅ พนักงานไม่มี bank account → Finance contact + pending
6. ✅ Late approval → Owner grace period 1-7
7. ✅ เภสัชกร OT → Fix 150 (Owner accepted risk, D17)
8. ✅ กุมภาพันธ์ (28 วัน) → ÷30 คงเดิม + ทำงานครบเดือน = จ่ายเต็ม
9. ✅ WHT > salary → cap 95% ของ gross
10. ✅ Commission > salary → Round 2 สามารถ > Round 1 ได้
```

---

## 🔗 Related Sections
- Section 4: กฎพื้นฐาน (formulas, rates)
- Section 7: Time & Attendance (OT, Leave sources)
- Section 8: Notification (Payslip delivery)
- Section 10: Audit Log (Payroll audit trail)

## 🔗 Legal References
- ประมวลรัษฎากร ม.50(1), ม.52, ม.54: rd.go.th
- คำสั่ง ป.91/2542: rd.go.th
- พ.ร.บ.ประกันสังคม ม.33, 47: SSO
- พ.ร.บ.คุ้มครองแรงงาน ม.23, 61, 76, 115: กรมสวัสดิการฯ
