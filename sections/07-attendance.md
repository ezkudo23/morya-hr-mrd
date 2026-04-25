# Section 7: บันทึกเวลา (Time & Attendance)

> **Notion ref**: https://www.notion.so/34c9e022ec80814bb206fbfa2d4a53e2
> **Status**: ✅ Locked — 25 เม.ย. 2569
> **Scope**: 29 คน (รวม PC 3 คน)
> **Dependencies**: Section 4 (Rules), Section 6 (Payroll)

---

## 7.1 ภาพรวม

### วัตถุประสงค์
ระบบบันทึกเวลาทำงาน 29 คน (20 Staff + 5 Supervisor + 1 Facility จำเนียร + 3 PC) ให้:
- ถูกต้องตามกฎหมาย (ม.23, 61, 28)
- ใช้ง่ายผ่าน LIFF (ไม่ต้องลงแอพ)
- ป้องกันทุจริต (GPS + Duplicate)
- เชื่อม Payroll อัตโนมัติ

### สถาปัตยกรรม
```
LINE LIFF → Check-in/out → GPS Validation (100m) + Duplicate (5min) + Shift Validation (Grace 0)
→ attendance_logs (Postgres + RLS)
→ Payroll Engine (OT, Late, Penalty)
```

### Employee Groups
```
Group A: Full Attendance (26 คน)
└── 5 Sup + 20 Staff + 1 Facility

Group B: Time Attendance Only (3 คน)
└── PC01 ชมพู่, PC02 ต่าย, PC03 พลอย
    ├── ✅ check-in/out (GPS)
    ├── ❌ ไม่มี leave/OT/correction
    └── LIFF จำกัด (view self only)

Group C: Exempt (3 คน) — เฮีย, ไนซ์, จิว
Group D: Not in System (1 คน) — สังวาลย์
```

> **Total tracking: 29 คน**

---

## 7.2 Check-in/out Flow (2 Taps)

```
LIFF → [Check-in] / [Check-out]
  → GPS check home_cost_center (100m)
  → ถ้าไม่ผ่าน: เช็คทุกสาขา (cross-location flag)
  → Duplicate check (5 min)
  → Shift validation (grace 0, early warning)
  → Confirmation Screen → Success Toast
```

### Cross-Location Logic
```
ทุกคน can_multi_location = true
1. GPS เช็ค home_cost_center ก่อน
2. ผ่าน → normal check-in
3. ไม่ผ่าน → เช็คทุกสาขา
   - ผ่าน → is_cross_location = true 🚩 + notify supervisors
   - ไม่ผ่าน → Block
```

### Business Rules — D13
```yaml
grace_period: 0 minutes
duplicate_window: 5 minutes
gps_radius: 100 meters

late_threshold: ≥3 ครั้ง/เดือน (สาย+ลืม+correction รวมกัน) → ตัดเบี้ยขยัน
pre_approved_late: ไม่นับในสาย

forgot_checkout:
  auto_close: shift_end + 2 hr
  self_correct_window: 24 hr
```

---

## 7.3 GPS Validation

```
Distance = Haversine(user, branch)
Distance ≤ 100m → PASS
else → BLOCK (show distance)
```

### GPS Coordinates (Pending M1)
- HQ-00 (ขายส่ง) — TBD
- HQ-01 (ขายปลีก) — TBD
- CC-04 — TBD

> ⚠️ HQ-00 และ HQ-01 อยู่ใกล้กัน — Default by home_cost_center

### Anti-Spoofing
- Mock Location Detection
- Accuracy Threshold (block >50m)
- Speed Anomaly (impossible travel)
- IP + GPS Correlation

---

## 7.4 Offline Check-in

```
Online → POST /api/check → DB verify
Offline → IndexedDB → Background sync (Service Worker)
```

### Server Verification
- ไม่เก่าเกิน 24 ชม.
- ไม่อยู่ในอนาคต (clock manipulation)
- Device_id ตรงกับ employee
- GPS valid ณ เวลานั้น
- ไม่มี duplicate ใน 5 นาที

---

## 7.5 โครงสร้างกะทำงาน

### หลักการ
```
Standard:  9 ชม./วัน รวมพัก 1 ชม. (ทำงานจริง 8 ชม.)
Break:     1 ชม. (สาขาจัดเอง)
Max OT cap: 36 ชม./สัปดาห์
```

### Shift Master — D18 (Documented Rotation)
```
CC-HQ-WS (ขายส่ง) — ร้านเปิด จ-อา (Rotation)
├── SHIFT_WS: 08:30-17:30
└── + OT_SA_EXT 17:30-18:30 (จ-ส only, 1 คน/วัน)
    ⚠️ พนักงานหยุด 1 วัน/สัปดาห์ (rotation - ม.28)

CC-01 (ขายปลีก HQ)
├── จ-ส (2 กะ overlap):
│   ├── SHIFT_01_MORNING: 08:30-17:30
│   └── SHIFT_01_CLOSING: 10:00-19:00
└── อาทิตย์ (1 กะ):
    └── SHIFT_01_SUNDAY: 08:30-17:30

CC-04 (สาขา 4) — ทุกวัน (2 กะ overlap):
├── SHIFT_04_MORNING: 09:00-18:00
└── SHIFT_04_CLOSING: 12:00-21:00
```

### CC-HQ-WS Documented Rotation — D18
```
ม.28: ลูกจ้างมีสิทธิ์วันหยุดประจำสัปดาห์ ≥1 วัน/สัปดาห์

CC-HQ-WS ร้านเปิด 7 วัน — Rotation Model:
├── พนักงานแต่ละคนหยุด 1 วัน/สัปดาห์ (ต่างวันกัน)
├── ระบบ track + validate:
│   ├── พนักงานแต่ละคนหยุด ≥1 วันหยุด/สัปดาห์
│   ├── Block schedule ที่ผิด ม.28
│   └── Alert HR ถ้า rotation pattern แปลก
├── Documentation:
│   ├── ระบุใน "ข้อบังคับการทำงาน"
│   ├── พนักงานลงลายมือชื่อ ยินยอม rotation
│   └── Schedule monthly แสดงชัดวันหยุดของแต่ละคน
└── Co-Sup (เมล์/เดือน) จัดตารางรายเดือน
```

### Schedule Assignment
```yaml
publish_frequency: รายเดือน (accident → ปรับกลางสัปดาห์ได้)
publish_via: LIFF + LINE
lead_time: ≥ 7 วันก่อนเดือนใหม่

who_assigns:
  cc_hq_ws: "Co-Sup (เมล์/เดือน)"
  cc_01: "Supervisor ค๊อบ"
  cc_04: "Supervisor จอย"
  sale_admin_ext: "Owner/ไนซ์ approve monthly"
```

---

## 7.6 Sale Admin Extended Shift

### Configuration
```
เวลา:        17:30-18:30 (1 ชม./วัน)
วัน:         จันทร์-เสาร์ (6 วัน/สัปดาห์)
สถานที่:     HQ-01 (ย้ายจาก HQ-00 ที่ปิด 17:30)

ผู้ทำ (สลับกัน):
├── MY05 เมล์   10,820
├── MY10 เยียร์ 10,530
└── MY23 เดือน  16,200

Rate:        OT Weekday 1.5x (ม.61)
Approval:    Owner/ไนซ์ approve ตารางรายเดือน (วันที่ 28)
```

### Workflow
```
วันที่ 25: Co-Sup draft ตาราง
├── ส่ง Owner/ไนซ์ → Review + approve ภายใน 3 วัน
└── วันที่ 28: Publish → ระบบสร้าง pre_approved OT

วันทำงาน:
├── 17:30: check-out กะหลัก → prompt "เริ่ม OT?"
├── กด "เริ่ม" → check-in OT session
├── 17:30-18:30: ทำงาน
├── 18:30: check-out → log 1 ชม. × 1.5x
└── เข้า payroll Round 2
```

### Cost: ~1,877-2,112 บาท/เดือน (~22,500-25,300/ปี)

---

## 7.7 Partial Shift Logic (Hybrid B2+B3)

### Decision Tree
```
actual_hours:
├── ≥ 6 ชม. → Full Day (1.0)
├── 3-6 ชม. → Half Day (0.5) — ต้องมี leave request
└── < 3 ชม. → Full Day + Warning
```

### Decision Matrix

| Actual | Day | Leave | Salary | เบี้ยขยัน |
|---|---|---|---|---|
| 9 ชม. | 1.0 | ❌ | 0 | ✅ |
| 6 ชม. | 1.0 | ❌ | 0 | ✅ |
| 5.9 | 0.5 | ✅ | -0.5 (LWP) | ⚠️ ลาป่วย → ตัด |
| 4 | 0.5 | ✅ | -0.5 (LWP) | ⚠️ ลาป่วย → ตัด |
| 2.9 | 1.0 | ❌ + warn | 0 | ⚠️ review |

### Applied Only To
```
✅ ลาพักร้อน, ลาป่วย, ลากิจ
❌ ลาคลอด, ลาบวช, ลาสมรส, ลาฌาปนกิจ, ลาทหาร
   (เต็มวันล้วน — ไม่มี concept ครึ่งวัน)
```

---

## 7.8 OT Request + Approval — D12

### หลักการ: Flexible Timing
```
"ทำได้ก่อน ขออนุมัติภายหลัง"
├── ทำโดยพลการ → supervisor reject → ชั่วโมงไม่นับ
└── Submission window: 72 hours
```

### OT Types (5 ประเภท)

| Code | ชื่อ | Multiplier | Pre-approval |
|---|---|---|---|
| `weekday_15` | OT วันทำงานปกติ | 1.5x | Optional |
| `sale_admin_ext` | Sale Admin | 1.5x | ✅ Required |
| `holiday_sub_10` | วันหยุด (sub) | 1.0x | Optional |
| `holiday_changed_20` | วันหยุดที่เปลี่ยน | 2.0x | ✅ Owner init |
| `ot_in_holiday_30` | OT ในวันเปลี่ยน | 3.0x | Optional |

**Pharmacist:** Fix 150 บาท/ชม. (Locked — Owner accepts legal risk, D17, 🚩 Pending Legal)

### Business Rules
```yaml
weekly_cap:
  hard: 36 hours  # block
  warning: 30 hours

submission_window: 72 hours
minimum_unit: 30 minutes  # half-up
cross_day_ot: "นับเป็น OT ของวันที่เริ่ม"
consecutive_days_max: 6
```

### Auto-Check Logic
```
1. Weekly cap > 36 → BLOCKED
2. Weekly cap > 30 → WARNING
3. Attendance log mismatch → WARNING
4. Consecutive OT 6 วัน → WARNING
5. Sale Admin ไม่มี pre-approved → BLOCKED
```

---

## 7.9 Holiday Management (Model B1)

### Config
```
Model: B1 (Use-it-or-lose-it)
Annual holidays: 13 วัน
Closed days: 4-5 วัน (paid)
Open days: 8-9 วัน (substitute token)
```

### Holiday Calendar (รายปี — ต้อง Q4 2569)
```
✅ คงที่ทุกปี:
├── 1 ม.ค. (ปีใหม่)
├── 30 ธ.ค. (สิ้นปี)
└── 31 ธ.ค. (สิ้นปี)

⚠️ วันร้านปิดอื่นๆ → เฮีย decide ปีนั้นๆ
```

### Holiday Pivot (ปิด → เปิด)
```
Workflow:
├── Owner/Delegate initiate (Audit Level 2)
├── System check: ≥ 7 วันล่วงหน้า
├── Broadcast LINE + LIFF ขอ consent
├── Voluntary consent:
│   ├── Accept → ทำ + OT 2.0x
│   └── Decline → ยังได้ holiday pay
└── OT rates: 2.0x กะปกติ, 3.0x ส่วนเกิน
```

---

## 7.10 Substitute Token

### Lifecycle
```
EARN → ACTIVE → USED / EXPIRED / FORFEITED

Earn: holiday ร้านเปิด + ทำงาน ≥ 8 ชม.
Use: LIFF request → Supervisor approve
Expire: 30 วัน หรือ 31 ธ.ค. force expire
```

### Constraints
```yaml
swap_ratio: 1 token = 1 วันหยุด (ไม่แลกเงิน)
max_per_day: 1 token/วัน
lead_time: ≥ 2 วัน
consecutive: < 3 วันติดกัน
```

### Forfeit Cases
```
├── Resignation: คงเหลือหาย (ไม่จ่ายเงิน)
├── 31 ธ.ค.: force expire ทุก token
└── Contract termination: forfeit
```

---

## 7.11 Correction Flow — D13

### Correction Types
```
1. Forgot Check-in
2. Forgot Check-out
3. Time Adjustment (GPS ช้า, sync lag)

❌ NOT Location Fix — auto-detect ไม่ให้พลาด
```

### Workflow (2-Step)
```
Step 1: Employee Submit (LIFF)
├── เลือก type + วันที่ + claim value
├── Reason (min 20 chars)
└── Evidence (optional)
        ↓
Step 2a: Supervisor Review (SLA 4 ชม.)
        ↓
Step 2b: HR Admin Review (SLA 4 ชม.)
        ↓
✅ Applied + Audit Level 2 + Counter +1
```

### Business Rules — Locked 25 เม.ย. 2569
```yaml
submission_window: 72 hours
diligence_impact: ≥3 ครั้ง/เดือน (ลืม+สาย+correction รวมกัน) → ตัดเบี้ยขยัน
sla:
  supervisor: 4 hours
  hr: 4 hours
  quiet_hours: 20:00-08:00 (pause SLA)
counter_reset: monthly — วันที่ 1 เวลา 00:00
```

---

## 7.12 Forgot Check-in/out Policy

### Forgot Check-in
```
self_correct_window: 24 hours
├── User submit + Supervisor approve
└── > 24hr: HR manual + Owner approve + evidence
```

### Forgot Check-out
```
auto_close: shift_end + 2 hours
├── ตัวอย่าง: 17:30 → 19:30 auto-close
├── ระบบสร้าง check_out record (auto_closed flag)
└── Notify employee + supervisor

OT implication:
└── ถ้า actual > shift_end + 2hr → ต้อง submit OT request แยก
```

---

## 7.13 Emergency Unlock — D14

### Use Case
ยื่น ปกส./WHT ผิด ต้องแก้ย้อน → unlock payroll ที่ locked

### Access Control
```
Approver 1: Owner (เฮีย) [Required]
Approver 2: Owner Delegate (ไนซ์ OR จิว)

⚠️ Both approve within 1 hour, sequential
Reason: min 100 characters
```

### When to Use
```
✅ Use Cases:
├── ปกส. ยื่นผิด (Allow before/after, D14)
├── WHT ยื่นผิด
├── Attendance ผิด 10+ คน
├── Ruling จากสรรพากร/สปส.
└── Audit finding

❌ Not for:
├── พนักงาน 1 คนลืม check-in (ใช้ correction)
└── Attendance ทั่วไป
```

### Workflow
```
Step 1: Owner initiate → specify period + reason + changes
Step 2: Delegate review 1 hour → approve/reject
Step 3: Apply changes 2-hour window → ระบบ auto re-lock
Step 4: Post-unlock → report + notify + re-generate files
```

---

## 7.14 Override / Force Proceed

### Access Control
```
Owner + Delegate: all overrides
HR Admin: attendance + correction
Supervisors: non-critical (grace period)

Reason: min 50 characters
Confirmation: 2-click (warning → type "OVERRIDE")
Audit: Level 2, 2-year retention
```

### Example Cases
```
1. OT > 36 hr/week → Owner/Delegate only
2. Correction > 72 hr → HR or Owner
3. Leave นอกเวลาแจ้งล่วงหน้า → Supervisor
4. Cross-location ≥ 200m → Supervisor
```

---

## 7.15 Data Model

### Tables (15)
```
Master Data (4):
├── shifts, ot_types, holiday_calendar, cost_centers

Transactional (8):
├── employee_shifts, attendance_logs, attendance_summary_daily,
│   attendance_queue (local), ot_requests, substitute_tokens,
│   correction_requests, employee_diligence_counters

Audit & Admin (3):
├── emergency_unlock_logs, override_audit_logs, attendance_notifications
```

### Core Schema — attendance_logs
```sql
CREATE TABLE attendance_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES employees(id),

  event_type TEXT NOT NULL CHECK (event_type IN ('check_in', 'check_out')),
  event_date DATE NOT NULL,

  timestamp_reported TIMESTAMPTZ NOT NULL,
  timestamp_accepted TIMESTAMPTZ NOT NULL,
  offline_delay_seconds INT DEFAULT 0,

  gps_latitude DECIMAL(10, 7),
  gps_longitude DECIMAL(10, 7),
  gps_accuracy_meters DECIMAL(6, 2),

  home_cost_center_id UUID NOT NULL REFERENCES cost_centers(id),
  actual_cost_center_id UUID NOT NULL REFERENCES cost_centers(id),
  is_cross_location BOOLEAN GENERATED ALWAYS AS
    (home_cost_center_id != actual_cost_center_id) STORED,

  shift_id UUID REFERENCES shifts(id),
  is_late BOOLEAN DEFAULT false,
  late_minutes INT DEFAULT 0,
  is_pre_approved_late BOOLEAN DEFAULT false,

  device_id TEXT,
  device_info JSONB,
  ip_address INET,
  is_mock_location_detected BOOLEAN DEFAULT false,

  is_corrected BOOLEAN DEFAULT false,
  correction_request_id UUID REFERENCES correction_requests(id),
  original_log_id UUID REFERENCES attendance_logs(id),
  auto_closed BOOLEAN DEFAULT false,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 7.16 Edge Cases (15)

```
1. ✅ พนักงานใหม่กลางเดือน → Prorated + probation
2. ✅ ลาออกกลางเดือน → Prorated + force expire tokens
3. ✅ ลาป่วย ≥1 ครั้ง = ตัดเบี้ยขยัน (D16)
4. ✅ HQ-00 ใกล้ HQ-01 → auto-detect by home
5. ✅ Device clock ผิด > 5 นาที → Block offline
6. ✅ เปลี่ยนเครื่อง → Warning + check-in ใหม่
7. ✅ Sale Admin ป่วย 3 คน → Skip + LINE notify
8. ✅ Holiday Pivot < 7 วัน → Block
9. ✅ OT > 36 hr/week → Hard block
10. ✅ Correction ≥3 ครั้ง → ตัดเบี้ยขยัน (D13)
11. ✅ Forgot check-out auto close shift_end + 2hr
12. ✅ Emergency Unlock → 2-person Owner + Delegate
13. ✅ ก.พ. (28 วัน) → ÷30 + ทำงานครบเดือน = จ่ายเต็ม
14. ✅ Cross-location → flag + notify
15. ✅ Holiday 2570 → ต้องกำหนด Q4 2569
```

---

## 🚨 Pending Action Items (Pre Go-Live)

### Must Have
- [ ] GPS coordinates 3 จุด (HQ-00, HQ-01, CC-04) — M1
- [ ] Holiday Calendar 2570 (13 วัน, 1 ม.ค. + 30-31 ธ.ค. คงที่) — Q4 2569
- [ ] Pharmacist OT 150 — Owner accepted, 🚩 Pending Legal Review
- [ ] ข้อบังคับการทำงาน — update ก่อน go-live
- [ ] Labor lawyer consultation

### Nice to Have
- [ ] Integration test กับ Bluenote (commission)
- [ ] Training Core Team (11 คน)
- [ ] Parallel run ม.ค. 2570

---

## 🔗 Related
- Section 4: กฎพื้นฐาน (rates, formulas)
- Section 6: Payroll (OT → compensation)
- Section 8: Notification (LINE alerts)
- Section 10: Audit Log (Level 2)

## 🔗 Legal
- ม.23 — ชั่วโมงทำงาน (9 ชม. รวมพัก)
- ม.28 — วันหยุดประจำสัปดาห์ (Documented Rotation, D18)
- ม.29 — สิทธิหยุดตามประเพณี
- ม.61 — OT rates
- ม.62 — OT วันหยุด
