# Section 4: กฎพื้นฐาน (Foundational Rules)

> **Notion ref**: https://www.notion.so/34c9e022ec8081b6a69ffefb3dceaf1d
> **Status**: ✅ Locked — 25 เม.ย. 2569
> **Note**: Foundation — workflow ทั้งหมดอ้างอิง rules ใน section นี้

---

## 4.1 Payroll Configuration

### Payroll Cycle
- **รอบจ่าย:** 2 รอบ/เดือน (Round 1 + Round 2) — D6
- **หลัก /30 fixed:** ค่าแรงต่อวัน = salary / 30 (ไม่ขึ้นกับเดือนมี 28/29/30/31 วัน)
  - ลา 1 วัน = หัก salary/30 ทุกเดือน ไม่ว่า ก.พ. (28 วัน) หรือ ม.ค. (31 วัน)
  - ทำงานครบเดือน = จ่าย salary เต็ม (ไม่ขึ้นกับจำนวนวันของเดือน)
- **การคำนวณรายชม.:** /8 ชม.
- **การปัดเศษ:** คณิตศาสตร์ (≥0.5 ปัดขึ้น, <0.5 ปัดลง) — ทศนิยม 2 ตำแหน่ง
- **Internal storage:** DECIMAL(10, 2)

### Hybrid Salary Logic — D9
```
พนักงานใหม่/ลาออก (เดือนแรก/สุดท้าย):
  salary = base × (worked_days / 30)
  (Days Worked method)

พนักงานเก่า (ทำงานครบเดือน หรือลา):
  deduction = base × (absent_days / 30)
  salary = base - deduction
  (Days Absent — ทำงานเต็มเดือน = จ่ายเต็ม)

SSO base = max(1650, min(salary_actual, 15000))
SSO = base × 5% (ปัดคณิต 2 ตำแหน่ง)
```

### Payroll Timeline — D7, D8
```
Round 1 (Salary Base):
├── วันที่ 28-สิ้นเดือน  — Finance คำนวณ + ตั้งโอนล่วงหน้า
├── วันที่ 1 (เดือนถัดไป) — เงิน Round 1 เข้าบัญชี (auto)
└── วันที่ 1-7           — Owner approve grace period
                          (error → adjust ใน Round 2)

Round 2 (Commission + Variable):
├── วันที่ 1-14  — Finance (นา) ดึง commission + OT + เบี้ยขยัน
├── วันที่ 15    — Deadline ตั้งโอน + ยื่น สปส.1-10
└── วันที่ 16    — เงิน Round 2 เข้าบัญชี + payslips
```

### Core Principle: ทำงานก่อน จ่ายทีหลัง
- วันที่ 1 ก.พ. = จ่ายเงินเดือนของ ม.ค. (ที่เพิ่งทำงานเสร็จ)
- ไม่จ่ายล่วงหน้า
- Round 1 = salary base (fixed, รู้ล่วงหน้าได้)
- Round 2 = variable (commission, OT, adjustments)

### Onboarding Cut-off
- **เริ่มงาน ≤ วันที่ 28**: เข้า Round 1 เดือนถัดไป (prorated)
- **เริ่มงาน > วันที่ 28**: รอ Round 1 อีกเดือน (skip 1 เดือน)

### Compensation Types

#### 1. Regular Salary (ม.40(1))
- เสีย ปกส.: 5% (พนักงาน) + 5% (นายจ้าง)
- Cap: 15,000 บาท (สูงสุด 750 บาท/เดือน)
- ยื่น ภ.ง.ด.1 รายเดือน
- รับสิทธิ์ประโยชน์ ปกส.

#### 2. Director Salary (Owner + Delegates: เฮีย + ไนซ์ + จิว)
- ม.40(1) — ไม่เข้า ปกส.
- ไม่ต้อง check-in/out (exempt)
- จิว (CEO02): รับเงินเดือน 30,000 ผ่านระบบ payroll ปกติ

### WHT Configuration
```typescript
type EmployeeWHTConfig = {
  enable_wht: boolean;         // Default: true
  manual_override?: { amount: number };
};
```

---

## 4.2 OT Rules

### อัตราค่าแรง OT

| ประเภท | อัตรา | เงื่อนไข |
|---|---|---|
| Weekday OT | 1.5x | หลังเวลางานปกติ (ม.61) |
| Holiday Substitute (ร้านเปิดปกติ) | 1.0x + token | รวมอยู่ในแปดแล้ว เพิ่มสิทธิ์ลาชดเชย |
| Holiday Changed (work) | 2.0x | พลิก closed → open — ต้องมี consent |
| OT in Holiday Changed | 3.0x | พนักงานทำเกินกะ |

### OT Cap
- **สูงสุด 36 ชม./สัปดาห์** (hard cap, block)

### เภสัชกร (Pharmacist) Special Rate — D17 ⚠️
- **Fix 150 บาท/ชม.** ทั้ง 2 คน (ค๊อบ + จอย)
- ⚠️ **Owner Risk Acknowledgment:**
  - อัตรา fix นี้ต่ำกว่า 1.5x ของหนึ่งชม.เงินเดือน
  - จอย (34,000): hourly×1.5 = 212.50 vs fix 150 = ขาด 62.50/ชม.
  - ค๊อบ (31,000): hourly×1.5 = 193.75 vs fix 150 = ขาด 43.75/ชม.
  - **Owner ได้รับทราบ Legal risk ตามม.61 และยอมรับอย่างเป็นลายลักษณ์อักษร**
  - คง status quo — เปลี่ยนได้เมื่อ Owner สั่ง
- 🚩 **Pending Legal Review** — ทนายแรงงานตรวจสอบได้ (อาจต้องปรับปรุง)
- ระบุใน "ข้อบังคับการทำงาน" ชัดเจน + ลงลายมือชื่อ

### OT Request Model — D12
- **Flexible Timing:** "ทำได้ก่อน ขออนุมัติภายหลังภายใน 72 ชม."
- **Staff submit เอง** — ตามม.24 (consent)
- **Reject → ชั่วโมงไม่นับ** (ไม่ได้เงิน)
- **OT type:** Auto-detect จากวัน/เวลา (ไม่ต้อง user select)

#### ข้อยกเว้น (Pre-approved)
- **Sale Admin Extended (17:30-18:30):** Owner approve ตารางรายเดือน (วันที่ 28)
- **Holiday Pivot:** Owner init + ≥7 วันล่วงหน้า + consent พนักงาน

> 💡 OT Request workflow: ดู Section 7.8 (Flexible Timing Model)

---

## 4.3 Leave Rules

### Leave Types: 9 ประเภท — D11

| # | ประเภทลา | โควตา | จ่ายเงิน | กฎหมาย |
|---|---|---|---|---|
| 1 | ลาพักร้อน | 6 วัน/ปี | ✅ | ม.30 (หลัง 1 ปี) |
| 2 | ลาป่วย | 30 วัน/ปี | ✅ | ม.32 (3+ วันติด → ใบรับรองแพทย์) |
| 3 | ลากิจ | 3 วัน/ปี | ✅ | ม.57/1 |
| 4 | ลาคลอด | 45+45 | ✅ | ม.41 |
| 5 | ลาบวช | 15 วัน | ✅ | — |
| 6 | ลาสมรส | 3 วัน | ✅ | — |
| 7 | ลาฌาปนกิจ | 5 วัน | ✅ | — |
| 8 | ลาทหาร (รับราชการ) | ตามหมายเรียก | ✅ (ไม่เกิน 60 วัน) | ม.35 |
| 9 | ลาฝึกอบรม/อบรมวิชาชีพ | 30 วัน/ปี | ✅ | ม.34 |

> 💡 **ลาประเภทพิเศษอื่น** (ลาดูแลบิดา, ลาทำหมัน) → HR ใช้ ลากิจ/ลาฝึกอบรม + manual entry พร้อม note

### รอบโควตาลา
- **รอบ:** ม.ค. - ธ.ค. (ปีปฏิทิน)
- **ไม่สะสมปีถัดไป** — use-or-lose (Model B1)
- **การคำนวณ:** 8 ชม./วัน

### Advance Notice
- ลาพักร้อน: 7 วัน
- ลาป่วย: ทันที (backdate ภายใน 3 วัน + ใบรับรองแพทย์)
- อื่นๆ: 3 วัน

### Probation
- **ระยะเวลา:** 119 วัน (เลี่ยง ม.118 severance)
- **สิทธิ์ระหว่าง probation:**
  - ✅ เงินเดือน + ปกส.
  - ✅ ลาป่วย
  - ❌ ลากิจ (ถือเป็น LWP)
  - ❌ ลาพักร้อน (ยังไม่ครบ 1 ปี)

### Resignation
- **แจ้งล่วงหน้า:** 30 วัน (ม.17)

---

## 4.4 Attendance Rules

### Grace Period
- **0 นาที** (strict)
- เวลา check-in ก่อน = early check-in (warning)
- เวลา check-in หลัง = สาย

### GPS Radius
- **100 เมตร** ทุก location (fixed)

### Duplicate Prevention
- **5 นาที** window

### Partial Shift (Hybrid B2+B3)
```
ชั่วโมงทำงานจริง:
   ├── ≥ 6 ชม.  → full day ✅
   ├── 3-6 ชม. → half day (ต้องมี leave request)
   └── < 3 ชม.  → full day (warning)
```

### เบี้ยขยัน (Diligence Bonus) — D16
- **600 บาท/เดือน** (configurable)
- **เงื่อนไขตัดสิทธิ์ (เข้า 1 ข้อ = ตัดทั้ง 600):**
  - ❌ ลาป่วย ≥1 ครั้ง/เดือน → ตัดเต็ม
    - ยกเว้น: ติดต่อ 3 วัน + ไม่มีใบรับรองแพทย์ → ตัด
  - ❌ สาย ≥3 ครั้ง/เดือน → ตัดเต็ม
  - ❌ ลืม check-in/out + correction ≥3 ครั้ง (รวมกัน) → ตัดเต็ม
  - ❌ ลากิจ/ลาพักร้อนไม่แจ้งล่วงหน้า → ตัดเต็ม
- **ระบุใน "ข้อบังคับการทำงาน" + พนักงานลงลายมือชื่อรับทราบ**
- **หมายเหตุ:** เบี้ยขยัน = สวัสดิการ (ไม่ใช่ค่าจ้าง) — นายจ้างมีสิทธิ์กำหนดเงื่อนไข (ม.76 ไม่ apply)

### สาย & ลืม Check-in — D13
- **สาย:** เกิน grace (0 นาที) → นับครั้ง, **ไม่หักเงิน**
- **ลืม check-in/out:** นับทุกครั้ง = correction request
- **≥3 ครั้ง/เดือน (สาย+ลืม+correction รวมกัน):** ตัดเบี้ยขยัน
- **ตัวอย่าง:** สาย 1 + ลืม checkout 2 = 3 ครั้ง → ตัด

---

## 4.5 Holiday Rules

### ปว 2570 (ต้องสร้าง — Q4 2569): 13 วัน
```
ร้านปิด (ส่วนหนึ่ง):
├── 1 ม.ค. — ปีใหม่ ✅ คงที่ทุกปี
├── 30 ธ.ค. — สิ้นปี ✅ คงที่ทุกปี
├── 31 ธ.ค. — สิ้นปี ✅ คงที่ทุกปี
└── อื่นๆ — เฮีย decide ตามบริบทปีนั้น

⏳ ร้านเปิด — ได้ substitute token 1.0x
```

### Holiday Rules
- ❌ ไม่รวมวันหยุดสัปดาห์
- ❌ ไม่สะสมปีถัดไป
- ❌ ห้ามหยุดติดกัน > 3 วัน

### Substitute Token Rules
- **Expire:** 30 วัน strict
- **แลกวันหยุด:** 1:1 only (ไม่แลกเงิน)
- **Approval:** Supervisor only
- **Forfeit:** หมดอายุ → หายเลย, ลาออก → forfeit

> 📌 **Holiday Calendar 2570 ต้องสร้าง Q4 2569** (deadline 15 ธ.ค. 2569)

---

## 4.6 Approval Flow

### Sequential Model
```
ระดับ 1: Supervisor
ระดับ 2: HR Admin
ระดับ 3: Owner/Delegate

Routing ตามจำนวนวัน:
├── ≤ 3 วัน  → Supervisor
├── 4-7 วัน → Supervisor → HR Admin
└── 8+ วัน  → Supervisor → HR Admin → Owner
```

### SLA
- **4 ชม./ระดับ**
- **Quiet hours (22:00-08:00):** SLA pause
- **Auto-escalation:** 4 ชม. overdue → HR Admin

---

## 4.7 Owner/Delegate Override

### Force Proceed / Emergency Unlock
```yaml
authorized_actors:
  - Owner (เฮีย)
  - Owner Delegates (ไนซ์, จิว)

required_conditions:
  - reason_note: min 50 chars
  - affected_items: listed
  - confirmation: 2-click

mandatory_notifications:
  sent_to: [Owner, Delegates, HR Admin, Finance]
  channel: LINE OA critical (override quiet hours)

audit_log:
  level: 2 (sensitive)
  retention: 2 years
```

### Emergency Unlock (Payroll Locked → Draft) — D14
- **2-person approval:** Owner + 1 Delegate (sequential within 1 hr)
- **Allow before & after ปกส. filed**
  - Before: Unlock + Re-calc ปกติ
  - After: Unlock + Re-calc + ยื่น สปส.6-09 (แก้ย้อน) + Owner รับผิดชอบ
- **Required reason:** min 100 chars

---

## 4.8 Exception Handling

### Payroll Pre-Check (วันที่ 28)
- Pending corrections เดือนก่อนหน้า
- Pending OT approvals เกิน 72 ชม.
- Incomplete attendance logs
- Bank account พนักงานใหม่ยังไม่มี

→ ถ้ามีปัญหา: HR/Finance เคลียร์ก่อน 28
→ ถ้าตั้งโอนแล้วพบ error → adjust Round 2
→ ถ้า issue ใหญ่ → Emergency Unlock

### Correction (แก้ check-in)
- **2-step approve:** Supervisor → HR Admin
- **ไม่จำกัดจำนวน**
- **≥3/เดือน → ตัดเบี้ยขยัน** (D13)

### Commission
- **Phase 1:** Manual (Finance นา)
- **Phase 2:** Bluenote API (pending vendor)
- **Timeline:** ดึง report + verify + คำนวณ วันที่ 1-14
- **Payout:** Round 2 (วันที่ 16) เท่านั้น
- **Commission ทำไว้แต่ลาออก:** จ่าย Round 2 ปกติ (HR รู้ล่วงหน้า 30 วัน)

---

## 4.9 PDPA Compliance

### Retention Tier Model — D15

```
Tier 1 - Audit Level 1 (Low Risk):  1 ปี
├── Notification logs, Login attempts, Read queries
└── หลังครบ: hard delete อัตโนมัติ

Tier 2 - Audit Level 2 (Sensitive):  2 ปี
├── Override / Force Proceed, Emergency Unlock
├── Payroll changes (post-lock), Permission changes
└── หลังครบ: archive 1 ปี → hard delete

Tier 3 - Attendance Logs:           2 ปี
└── ขั้นต่ำตาม พ.ร.บ. คุ้มครองแรงงาน ม.115

Tier 4 - Payroll Records:             7 ปี ⭐
└── ขั้นต่ำตาม กฎหมายภาษี ม.ประมวลรัษฎากร

Tier 5 - Employee Records:            ระยะเวลาทำงาน + 2 ปี
└── หลังลาออก: เก็บต่ออีก 2 ปี → hard delete
```

### Auto-deletion Process
```
Daily cron (02:00):
├── Scan records past retention period
├── Soft delete → archive 30 วัน
└── Hard delete หลัง 30 วัน (PDPA right to erasure)

Exception: Legal Hold
└── Owner/HR สามารถ freeze record ได้
```

### Rights (PDPA)
- Right to Access (ม.30) — LIFF self-view 3 เดือน
- Right to Rectification (ม.32)
- Right to Erasure (ม.33) — หลังครบ retention
- Right to Data Portability (ม.31)

### Consent Form
- เซ็นตอนเข้างาน
- Disclose: IP + GPS logging, Supabase US/EU residency, retention tiers

---

## 4.10 Legal Compliance

### กฎหมายคุ้มครอง
- พ.ร.บ. คุ้มครองแรงงาน 2541
- PDPA 2562
- กฎหมายประกันสังคม

### Risks Flagged (รอ legal review)
1. **Pharmacist OT 150 (D17)** — Owner accepted, pending lawyer
2. **สังวาลย์ active_no_payroll** — สถานะทางกฎหมาย
3. **Rotation shift no fixed weekly off** — ✅ Documented (D18)
4. **Holiday forfeit (ม.29)** — Model B1 use-or-lose

### Filings ที่ต้องทำ

| Filing | ความถี่ | Due Date |
|---|---|---|
| สปส.1-10 (ปกส.) | รายเดือน | วันที่ 15 |
| ภ.ง.ด.1 | รายเดือน | วันที่ 7 เดือนถัดไป |
| ภ.ง.ด.1ก | รายปี | ก.พ. (ปีถัดไป) |
| 50 ทวิ | รายปี | ก.พ. (ปีถัดไป) |

---

## 4.11 สรุปการตัดสินใจสำคัญ

| หัวข้อ | ค่า | อ้างอิง |
|---|---|---|
| Payroll cycle | 2 รอบ/เดือน | 🔒 D6 |
| Round 1 timing | ตั้งโอน 28-สิ้นเดือน, เงินเข้า 1, approve ถึง 7 | 🔒 D7 |
| Round 2 timing | ทำ 1-14, ตั้งโอน 15, เงินเข้า 16 | 🔒 D7, D8 |
| Salary logic | Hybrid (Days Worked / Days Absent) | 🔒 D9 |
| SSO formula | base × 5%, floor 82.50, cap 750 | 🔒 D10 |
| Onboarding cut-off | วันที่ 28 ของเดือน | 🔒 D7 |
| ปกส. | 5% + 5%, cap 750, floor 1,650 | SSO Act |
| OT weekday | 1.5x | ม.61 |
| OT cap | 36 ชม./สัปดาห์ | Hard |
| เภสัชกร OT | 150 บาท/ชม. fix | ⚠️ D17 |
| ลาพักร้อน | 6 วัน/ปี | ม.30 |
| ลาป่วย | 30 วัน/ปี | ม.32 |
| Leave types | 9 ประเภท | 🔒 D11 |
| OT Request | Flexible Timing 72 ชม. | 🔒 D12 |
| Correction threshold | ≥3 ครั้ง/เดือน | 🔒 D13 |
| Emergency Unlock | Allow before & after ปกส. | 🔒 D14 |
| Retention | Tier Model | 🔒 D15 |
| Diligence ลาป่วย | ≥1 = ตัด | 🔒 D16 |
| Probation | 119 วัน | เลี่ยง ม.118 |
| Resignation notice | 30 วัน | ม.17 |
| Grace check-in | 0 นาที | Strict |
| GPS radius | 100 เมตร | Fixed |
| Token expire | 30 วัน | Use-or-lose |

---

## 4.12 Open Items
- [ ] Legal consult สำหรับ Pharmacist OT (D17) — Critical before go-live
- [ ] Holiday Calendar 2570 (Q4 2569)
- [ ] PDPA consent form — draft + legal review
