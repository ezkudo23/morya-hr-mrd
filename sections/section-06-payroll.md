# Section 6: เงินเดือนและการจ่ายค่าตอบแทน (Payroll) 💰

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 6*

> **Status:** ✅ Locked — 24 เม.ย. 2569 (อัปเดต 25 เม.ย. 2569)
> **Scope:** ระบบคำนวณและจ่ายค่าตอบแทนพนักงาน **29 คน**
> **Dependencies:** Section 4 (Rules), Section 7 (Attendance)

---

## 6.1 ภาพรวมระบบเงินเดือน

### วัตถุประสงค์

ระบบคำนวณและจ่ายค่าตอบแทนพนักงาน **29 คน** (3 Directors + 5 Supervisor + 20 Staff) ให้ถูกต้องตามกฎหมาย ตรงเวลา โปร่งใส และลดงาน HR manual

> **C-08 Fixed:** Payroll headcount = **29 คน** (ไม่ใช่ 30) เนื่องจากจำเนียรออกจากระบบ (จ้างนอกระบบ)

### Cycle การจ่ายเงิน (2 รอบ)

```
Round 1 (วันที่ 1):    จ่ายเงินเดือนฐาน + หัก ปกส. + WHT baseline
Prep Window (1-14):    รวบรวม OT + คอม + นับเบี้ยขยัน
วันที่ 15:             ยื่น สปส.1-10
Round 2 (วันที่ 16):   จ่าย OT + คอม + เบี้ยขยัน + WHT ส่วนต่าง + ออกสลิป
```

### Employee Groups สำหรับ Payroll

```
Group A: Regular Payroll (26 คน)
├── 40(1) + SSO + เบี้ยขยัน + OT + คอม
└── 5 Sup + 20 Staff + 1 Executive (จิว)

Group B: Exempt — Director (2 คน: เฮีย, ไนซ์)
├── 40(1) + ไม่มี SSO + ไม่มีเบี้ยขยัน + ไม่มี OT
└── ⚠️ ไม่อยู่ใน Humansoft → ต้อง migrate เข้า MYHR ตอน M1

Group C: Not in Payroll (4 คน)
├── 3 PC: คอมล้วน จ่ายโดย Principal
└── สังวาลย์: active_no_payroll (ปกส. contribution only)

❌ จำเนียร: ออกจากระบบ (จ้างนอกระบบ) — ไม่มี employee record ใน MYHR
```

> **Total Payroll: 29 คน** (26 Group A + 2 Group B + 1 Group C จิว)

---

## 6.2 องค์ประกอบเงินเดือน

### รายได้ (Income)

| # | ประเภท | เข้า SSO | เข้า WHT |
|---|--------|---------|---------|
| 1 | เงินเดือน (Base) | ✅ | ✅ |
| 2 | OT | ❌ | ✅ |
| 3 | คอมมิชชัน | ❌ | ✅ |
| 4 | เบี้ยขยัน | ❌ | ✅ |
| 5 | ค่าใบประกอบวิชาชีพ | ❌ | ✅ |
| 6 | โบนัส | ❌ | ✅ |

> **SSO ฐาน = เงินเดือนประจำเท่านั้น** (ไม่รวม OT/คอม/เบี้ยขยัน/โบนัส)

### รายการหัก (Deductions)

| # | ประเภท | อัตรา | Round |
|---|--------|-------|-------|
| 1 | ปกส. (SSO) | 5% cap 750 | Round 1 |
| 2 | WHT | ขั้นบันได × 12 | Round 1 + Round 2 |
| 3 | LWP | salary/30 × วัน | Round 1 |
| 4 | ตัดเบี้ยขยัน | -600 | Round 2 (ไม่จ่าย) |

---

## 6.3 การคำนวณ Prorated

```
เงินเดือนรายวัน    = เงินเดือน ÷ 30
เงินเดือนรายชั่วโมง = เงินเดือนรายวัน ÷ 8
Rounding: Half-Up
```

### OT Rate

```
OT Base Rate = เงินเดือน ÷ 30 ÷ 8
1.5x Weekday:         base × 1.5
1.0x Holiday sub:     base × 1.0
2.0x Holiday changed: base × 2.0
3.0x OT in holiday:   base × 3.0
Pharmacist:           Fix 150 บาท/ชม. 🔒 D17
```

---

## 6.4 ประกันสังคม (SSO)

```
อัตรา:     5% ลูกจ้าง + 5% นายจ้าง
ฐาน:      เงินเดือนประจำเท่านั้น
ฐานสูงสุด: 15,000
หักสูงสุด:  750/เดือน
```

| เงินเดือน | ฐาน | หัก |
|---------|-----|-----|
| ≤ 1,650 | 1,650 (floor) | 82.50 |
| 9,000 | 9,000 | 450 |
| 15,000 | 15,000 | 750 |
| 20,000+ | 15,000 | 750 (cap) |

**ยกเว้น SSO:** เฮีย + ไนซ์ (Director ม.33)

---

## 6.5 ภาษี ณ ที่จ่าย (WHT) — Pure Auto Mode

🔒 **LOCKED: Option C — Pure Auto** — คำนวณทุกคนทุกเดือน ไม่มี toggle ไม่มี opt-out

### สูตรคำนวณ

```
Step 1: Projected Annual = (Base + OT เฉลี่ย + คอม เฉลี่ย + เบี้ยขยัน) × 12
Step 2: หักค่าใช้จ่าย 50% (cap 100,000)
Step 3: หักลดหย่อน (ส่วนตัว 60,000 + SSO ทั้งปี + อื่นๆ)
Step 4: ขั้นบันได → ÷ 12 = WHT/เดือน
```

---

## 6.6 เบี้ยขยัน (Diligence Bonus)

```
Default: 600 บาท/เดือน
Type:    40(1) income (เข้า WHT, ไม่เข้า SSO)
จ่ายรอบ: Round 2 (วันที่ 16)
```

### 🔒 เงื่อนไขตัดเบี้ยขยัน (C-03 + C-04 Fixed — Locked 25 เม.ย. 2569)

ตัดเบี้ยขยันเต็มจำนวน ถ้าเข้าข้อใดข้อหนึ่ง:

**❌ C-03 (Option A):** ลาป่วย ≥ 1 ครั้ง/เดือน → ตัดเต็ม
> (ไม่ว่าจะกี่วัน ไม่ว่าจะมีใบรับรองแพทย์หรือไม่)

**❌ C-04:** สาย + ลืม check-in/out + correction request ≥ 3 ครั้ง/เดือน **รวมกัน** → ตัดเต็ม

**❌** ลากิจ/ลาพักร้อนไม่แจ้งล่วงหน้า → ตัดเต็ม

**ลาที่ไม่ตัดเบี้ยขยัน:**
✅ ลาพักร้อน, ลากิจ, ลาคลอด, ลาบวช, ลาสมรส, ลาฌาปนกิจ, ลาทหาร (ม.35), ลาฝึกอบรม (ม.34)

### Eligibility

```
✅ Regular salary ผ่าน Probation + ทำงานครบเดือน
❌ Directors, Executives, Probation, เข้า/ออกกลางเดือน, PC, สังวาลย์
```

---

## 6.7 ค่าปรับ — ไม่มีค่าปรับเป็นเงิน

```
❌ ไม่มีค่าปรับสายเป็นเงิน (ม.76)
❌ ไม่มีค่าปรับลืม check-in

ใช้ตัดเบี้ยขยันแทน
```

---

## 6.8 คอมมิชชัน

- Type: 40(1) — **ไม่ใช่ 50 ทวิ**
- Phase 1: Manual entry จาก Bluenote
- Payout: Round 2 เท่านั้น
- ✅ ได้ commission ระหว่าง Probation ปกติ

---

## 6.9 Payroll Schedule

```
เดือน N:
├── วันที่ 28-สิ้นเดือน: Finance คำนวณ Round 1 + ตั้งโอน
└── 31: ปิดรอบ attendance

เดือน N+1:
├── วันที่ 1:   Round 1 เงินเข้าบัญชี (auto)
├── วันที่ 1-7: Owner approve grace period
├── วันที่ 1-14: Prep Window (OT + commission + เบี้ยขยัน)
├── วันที่ 15:  ยื่น สปส.1-10 + ตั้งโอน Round 2
└── วันที่ 16:  Round 2 เงินเข้าบัญชี + payslips
```

---

## 6.10 สลิปเงินเดือน (Payslip)

```
✅ ออก 1 ใบ/เดือน (รวม Round 1 + Round 2)
✅ ออกวันที่ 16
✅ Delivery: ผ่าน LIFF (download PDF)
```

### Retention (🔒 C-10 Fixed)

| ช่วง | นโยบาย | เหตุผล |
|------|--------|--------|
| ระหว่างทำงาน | เก็บตลอด | สมัครสินเชื่อ |
| หลังออก | เก็บต่อ 2 ปี | สมัครสินเชื่อ |
| Legal minimum | **7 ปี** | กฎหมายภาษี |
| ตาม พ.ร.บ.แรงงาน ม.115 | **10 ปี** | บางประเภท payroll record |

> **กฎปฏิบัติ:** ระบบเก็บ payslip ตลอดอายุงาน + 2 ปีหลังออก เพื่อประโยชน์พนักงาน แต่ legal retention minimum = 7 ปี สำหรับ tax records และ 10 ปี สำหรับ payroll ตาม ม.115

---

## 6.11 Data Model (Core Tables)

```sql
payroll_runs: id, period_year, period_month, round (1|2),
              status (draft/approved/transferred/locked/closed),
              approved_by, total_gross, total_net

payroll_details: payroll_run_id, employee_id, base_salary,
                 prorated_salary, ot_amount_total, commission_amount,
                 diligence_bonus, diligence_forfeited, gross_income,
                 sso_deduction, wht_deduction_round_1/2, net_pay

wht_declarations: employee_id, year, personal_allowance,
                  spouse/child/parent_allowance, insurance, rmf_ssf
```

---

## 6.12 Edge Cases

| # | Scenario | การจัดการ |
|---|---------|---------|
| 1 | พนักงานใหม่กลางเดือน | Prorated ÷ 30 × วันทำงาน |
| 2 | ลาออกกลางเดือน | Prorated + settle outstanding |
| 3 | LWP | หัก Round 1 (Days Absent) |
| 4 | Round 1 error | ปรับใน Round 2 |
| 5 | ไม่มี bank account | Finance contact + pending |
| 6 | เภสัชกร OT | Fix 150 บาท/ชม. 🔒 D17 |
| 7 | ก.พ. (28 วัน) | ÷30 คงเดิม |
| 8 | Commission > salary | Normal — WHT recalc ปกติ |

---

*Last updated: 25 เม.ย. 2569 | C-03, C-04, C-08, C-10 resolved*
