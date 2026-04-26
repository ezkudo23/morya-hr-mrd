# 🔒 Locked Decisions

> ทุก decision ที่ lock แล้วจะอยู่ที่นี่ — ห้าม revert โดยไม่มี approval จาก Owner

---

## 📋 Decision Index

| # | Date | Topic | Status | Sections |
|---|------|-------|--------|----------|
| D1 | 2026-04-21 | Headcount = 33 คน | 🔒 Locked | 1, 2, 3, 6, 7, 8, 12 |
| D2 | 2026-04-21 | Go-Live: 1 ม.ค. 2570 | 🔒 Locked | 1, 12 |
| D3 | 2026-04-21 | Tech Stack final | 🔒 Locked | 12 |
| D4 | 2026-04-23 | Finance Lead → Finance | 🔒 Locked | 2, 8, 10 |
| D5 | 2026-04-23 | Timeline milestones | 🔒 Locked | 1, 12 |
| D6 | 2026-04-24 | Payroll cycle = 2 รอบ | 🔒 Locked | 4, 5, 6 |
| D7 | 2026-04-24 | Round 1 timing (28-1) | 🔒 Locked | 4, 5, 6 |
| D8 | 2026-04-24 | Commission window 1-14 | 🔒 Locked | 4, 5, 6 |
| D9 | 2026-04-24 | Hybrid Salary Logic | 🔒 Locked | 4, 6 |
| D10 | 2026-04-24 | SSO formula (cap/floor) | 🔒 Locked | 4, 6 |
| D11 | 2026-04-25 | Leave Types: 9 ประเภท | 🔒 Locked | 1, 4 |
| D12 | 2026-04-25 | OT Flexible Timing | 🔒 Locked | 4, 7 |
| D13 | 2026-04-25 | Correction ≥3 = ตัด | 🔒 Locked | 4, 6, 7 |
| D14 | 2026-04-25 | Emergency Unlock: Both | 🔒 Locked | 4 |
| D15 | 2026-04-25 | Retention Tier Model | 🔒 Locked | 4, 10, 11 |
| D16 | 2026-04-25 | ลาป่วย ≥1 = ตัดเบี้ยขยัน | 🔒 Locked | 4, 6 |
| D17 | 2026-04-25 | Pharmacist OT Fix 150 | ⚠️ Risk Accepted | 4, 6, 7 |
| D18 | 2026-04-25 | CC-HQ-WS Rotation | 🔒 Locked | 7 |

---

## D1: Headcount = 33 คน

**Date**: 21 เม.ย. 2569
**Source**: Reconciled from Humansoft data

### Breakdown
- 3 Director/Delegate: เฮีย (20,000), ไนซ์ (20,000), จิว CEO02 (30,000)
- 5 Supervisors: MY04, MY05, MY11, MY14, MY23
- 20 Staff
- 1 Facility: จำเนียร (~9,000)
- 1 SSO-only: สังวาลย์ (8,000 SSO contribution)
- 3 PC: PC01 ชมพู่, PC02 ต่าย, PC03 พลอย

### Counting metrics
- **Payroll run**: 30 คน (exclude สังวาลย์ + 3 PC)
- **Attendance tracking**: 29 คน (20 Staff + 5 Sup + 1 Facility + 3 PC)
- **LIFF Access**: 30 คน

---

## D2: Go-Live = 1 ม.ค. 2570

- เดิมตั้ง 1 ก.พ. 2570 — compressed เพื่อ year-end Humansoft savings
- 1 ม.ค. 2570 = ตรงกับ tax year + payroll year ใหม่ → migration cleanest
- Humansoft freeze: 31 ธ.ค. 2569 23:59
- 1 ม.ค.: Technical cutover; 2 ม.ค.: Operational

---

## D6-D8: Payroll Timeline (Locked)

### Round 1: Salary Base
- ตั้งโอน: วันที่ 28 - สิ้นเดือน
- เงินเข้า: วันที่ 1 ของเดือนถัดไป (auto, scheduled transfer)
- Owner approve grace: วันที่ 1-7

### Round 2: Variable
- Commission + OT + เบี้ยขยัน + adjustments
- ทำ: วันที่ 1-14
- ยื่น สปส.1-10 + ตั้งโอน: 15
- เงินเข้า: 16

---

## D9: Hybrid Salary Logic

```
IF พนักงานใหม่ (เดือนแรก) OR ลาออก (เดือนสุดท้าย):
    USE Days Worked: salary = base × (worked_days / 30)

ELSE (พนักงานเก่า):
    USE Days Absent:
    deduction = base × (absent_days / 30)
    salary = base - deduction
```

### Always /30 Fixed
- ค่าแรงต่อวัน = salary / 30 (constant)
- ลา 1 วัน = หัก salary/30 ไม่ว่าเดือนไหน

---

## D10: SSO Formula

```
base = max(1,650, min(salary_actual, 15,000))
sso  = round(base × 5%, 2)

Cases:
├── salary_actual ≤ 1,650 → SSO = 82.50 (floor)
├── 1,650 < salary_actual < 15,000 → SSO = salary_actual × 5%
└── salary_actual ≥ 15,000 → SSO = 750.00 (cap)
```

### Rounding
- คณิตศาสตร์ (≥0.5 ขึ้น, <0.5 ลง)
- เก็บใน DB: DECIMAL(10, 2)
- Payslip: 2 ทศนิยม

---

## D11: Leave Types = 9 ประเภท

1. ลาพักร้อน (6 วัน/ปี)
2. ลาป่วย (30 วัน/ปี)
3. ลากิจ (3 วัน/ปี)
4. ลาคลอด (45+45)
5. ลาบวช (15 วัน)
6. ลาสมรส (3 วัน)
7. ลาฌาปนกิจ (5 วัน)
8. ลาทหาร (รับราชการ — ม.35, จ่ายไม่เกิน 60 วัน)
9. ลาฝึกอบรม/อบรมวิชาชีพ (30 วัน/ปี — ม.34)

> ลาประเภทพิเศษอื่น (ลาดูแลบิดา, ลาทำหมัน) → HR ใช้ ลากิจ/ลาฝึกอบรม + manual entry

---

## D12: OT Flexible Timing

- "ทำได้ก่อน ขออนุมัติภายหลังภายใน 72 ชม."
- Staff submit เอง — ตามม.24 (consent)
- Reject → ชั่วโมงไม่นับ (ไม่ได้เงิน)
- Sale Admin Extended: pre-approved monthly
- Holiday Pivot: pre-approved + ≥7 วันล่วงหน้า + consent

---

## D13: Correction Threshold = ≥3

- สาย + ลืม check-in/out + correction request **รวมกัน** ≥3 ครั้ง/เดือน → ตัดเบี้ยขยัน
- ตัวอย่าง: สาย 1 + ลืม checkout 2 = 3 → ตัด

---

## D14: Emergency Unlock — Allow Both

- 2-person approval: Owner + 1 Delegate (sequential within 1 hr)
- **Before ปกส. filed**: Unlock + Re-calc ปกติ
- **After ปกส. filed**: Unlock + Re-calc + ยื่น สปส.6-09 (แก้ย้อน) + Owner รับผิดชอบ
- Required reason: min 100 chars
- Audit Level 2 + retention 2 ปี

---

## D15: Retention Tier Model

| Tier | Type | Period | Source |
|------|------|--------|--------|
| L1 | Audit Level 1 (notification, query) | 1 ปี | Internal |
| L2 | Audit Level 2 (override, sensitive) | 2 ปี | Internal |
| 3 | Attendance logs | 2 ปี | พ.ร.บ. ม.115 |
| 4 | Payroll records | 7 ปี | กม.ภาษี |
| 5 | Employee records | ระยะทำงาน + 2 ปี | PDPA |

Auto-deletion: Daily cron 02:00, soft delete + 30 วัน archive → hard delete

---

## D16: Diligence — ลาป่วย ≥1 = ตัด

- ลาป่วย ≥1 ครั้ง/เดือน → ตัดเบี้ยขยัน 600
- ติดต่อ 3 วันไม่มีใบรับรอง → ตัด
- สาย ≥3 → ตัด
- ลืม + correction ≥3 (รวมกัน) → ตัด
- ลากิจ/พักร้อนไม่แจ้งล่วงหน้า → ตัด

> เบี้ยขยัน = สวัสดิการ (ไม่ใช่ค่าจ้าง) — ม.76 ไม่ apply
> ระบุใน "ข้อบังคับการทำงาน" + พนักงานลงลายมือชื่อรับทราบ

---

## D17: Pharmacist OT Fix 150 (⚠️ Risk Accepted)

**Decision**: Fix 150 บาท/ชม. ทั้ง 2 คน (ค๊อป + จอย)

### Legal Risk Acknowledged
- ม.61: OT ≥ 1.5x ของหนึ่งชม.เงินเดือน
- จอย (34,000): hourly×1.5 = 212.50 vs fix 150 = ขาด 62.50/ชม.
- ค๊อป (31,000): hourly×1.5 = 193.75 vs fix 150 = ขาด 43.75/ชม.
- ม.4: ตกลงต่ำกว่ากฎหมายไม่ได้ (โมฆะ)

### Owner Decision
- ยอมรับ risk ตามสถานะเดิม (Humansoft ใช้มา 5+ ปี)
- ประหยัด ~6,375 บาท/ปี
- Worst case (ลูกจ้างฟ้องย้อนหลัง 2 ปี): ~14,000+ ค่าฟ้อง

✅ **Legal Reviewed 26 เม.ย. 2569** — Owner ยืนยัน risk accepted, Fix 150 บาท/ชม. คงเดิม

---

## D18: CC-HQ-WS Documented Rotation

- Model: Rotation — พนักงานแต่ละคนหยุด ≥1 วัน/สัปดาห์ (ต่างวันกัน)
- Legal: ✅ ม.28 compliant เมื่อมี documentation
- System: validate ≥1 วันหยุด/สัปดาห์ — block schedule ที่ผิด
- Docs: ระบุในข้อบังคับ + พนักงานลงชื่อยินยอม rotation

---

> 📌 **เพิ่ม decision ใหม่**: ใส่บนสุด, อัปเดต Index, ใส่ section reference
