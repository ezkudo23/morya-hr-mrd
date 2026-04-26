# Section 7: บันทึกเวลา (Time & Attendance) ⏰

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 7*

> **Status:** ✅ Locked — 24 เม.ย. 2569 (อัปเดต 25 เม.ย. 2569)
> **Scope:** ระบบบันทึกเวลาทำงาน **28 คน** (ไม่รวม 3 Directors + สังวาลย์ + จำเนียร)
> **Dependencies:** Section 4 (Rules), Section 6 (Payroll)

---

## 7.1 ภาพรวม

### วัตถุประสงค์

ระบบบันทึกเวลาทำงานของพนักงาน **28 คน** ให้ถูกต้องตามกฎหมายแรงงาน ใช้งานง่ายผ่าน LIFF ป้องกันทุจริต และเชื่อมกับ Payroll

### Employee Groups

```
Group A: Full Attendance (25 คน)
└── Supervisor (5) + Staff (20)

Group B: Time Attendance Only (3 คน)
└── PC01-PC03
    ├── ✅ check-in/out (GPS tracking เพื่อยืนยัน sponsor)
    ├── ❌ ไม่มี leave/OT/correction
    └── LIFF access จำกัด (view self-attendance only)

Group C: Exempt (3 คน)
└── เฮีย, ไนซ์, จิว (Director/Executive)

Group D: ไม่อยู่ในระบบ
└── สังวาลย์ (active_no_payroll — ไม่มี attendance)
└── จำเนียร (จ้างนอกระบบ — ไม่มี employee record ใน MYHR)
```

> **Total Attendance tracking: 28 คน** (Group A 25 + Group B 3)

---

## 7.2 Check-in/out Flow (2 Taps)

### Core Business Rules

```yaml
grace_period: 0 minutes  # Strict
duplicate_window: 5 minutes
gps_radius: 100 meters
early_check_in:
  before_60min: warning
  before_120min: block + reason required
late_threshold: สาย+ลืม+correction รวม ≥ 3/เดือน → ตัดเบี้ยขยัน
```

### Cross-Location Logic

ทุกคน `can_multi_location = true` — เช็คจาก home CC ก่อน → fallback ทุกสาขา → แจ้ง Supervisor ถ้า cross-location

---

## 7.3 GPS Validation

```
Distance = Haversine(user_location, branch_location)
≤ 100m: PASS | > 100m: BLOCK (show distance)
```

### GPS Coordinates (Pending — เก็บที่ M1)

- HQ-00 (ขายส่ง) — 14.886239, 103.492307
- HQ-01 (ขายปลีก) — 14.8864189, 103.4919395
- CC-04 — 14.8732376, 103.5060382

---

## 7.4 Offline Check-in

Logic: Local Queue (IndexedDB) + Background sync via Service Worker

**Server verification:** ไม่เก่าเกิน 24 ชม., ไม่อยู่ในอนาคต, Device_id ตรง, GPS valid, ไม่ duplicate

---

## 7.5 โครงสร้างกะทำงาน

```
Standard: 9 ชม./วัน รวมพัก 1 ชม. (ทำงานจริง 8 ชม.)
Pattern:  หมุนเวียน (ไม่มี fixed weekly off)
OT cap:   36 ชม./สัปดาห์ (hard block)
```

### Shift Types

| CC | Shift | เวลา |
|----|-------|------|
| CC-HQ-WS | SHIFT_WS | 08:30–17:30 + OT_SA_EXT 17:30–18:30 (จ-ส) |
| CC-01 | Morning | 08:30–17:30 |
| CC-01 | Closing | 10:00–19:00 |
| CC-01 | Sunday | 08:30–17:30 |
| CC-04 | Morning | 09:00–18:00 |
| CC-04 | Closing | 12:00–21:00 |

---

## 7.6 Sale Admin Extended Shift

เวลา: 17:30–18:30 (จ-ส) | ผู้ทำ: เมล์, เยียร์, เดือน (สลับกัน)
Rate: OT Weekday 1.5x | Approval: Owner/ไนซ์ approve รายเดือน (วันที่ 28)

---

## 7.7 Partial Shift Logic (Hybrid B2+B3)

| Actual | Day | Leave required | Salary impact |
|--------|-----|---------------|---------------|
| ≥ 6 ชม. | 1.0 | ❌ | 0 |
| 3–6 ชม. | 0.5 | ✅ | -0.5 LWP ถ้าไม่มี leave |
| < 3 ชม. | 1.0 | ❌ + warn | 0 |

---

## 7.8 OT Request + Approval

### OT Types

| Code | ชื่อ | Multiplier | Pre-approval |
|------|------|-----------|-------------|
| weekday_15 | OT วันทำงานปกติ | 1.5x | Optional (72hr window) |
| sale_admin_ext | Sale Admin | 1.5x | ✅ Required (monthly) |
| holiday_sub_10 | วันหยุด (sub) | 1.0x | Optional |
| holiday_changed_20 | วันหยุดที่เปลี่ยน | 2.0x | ✅ Owner init |
| ot_in_holiday_30 | OT ในวันเปลี่ยน | 3.0x | Optional |

**Pharmacist:** Fix 150 บาท/ชม. 🔒 D17

### Business Rules

```yaml
weekly_cap:
  hard: 36 hours  # block
  warning: 30 hours
submission_window: 72 hours  # 3 วัน หลังทำงาน
minimum_unit: 30 minutes
```

---

## 7.9 Holiday Management (Model B1)

**วันร้านปิด:** ไม่ต้อง check-in รับเงินปกติ
**วันร้านเปิด:** ทำงาน + ได้ substitute token (ทำงาน ≥ 8 ชม.)

### Substitute Token

```yaml
earn: ทำงาน ≥ 8 ชม. ในวัน holiday ร้านเปิด
expire: 30 วัน นับจากวันได้
year_end_reset: 31 ธ.ค. force expire
transferable: false
```

### Holiday Pivot (ปิด → เปิด)

Owner init → ≥ 7 วันล่วงหน้า → broadcast ขอ consent → Voluntary → OT 2.0x/3.0x

---

## 7.10 Substitute Token Lifecycle

```
EARN → ACTIVE → USED / EXPIRED / FORFEITED

Notifications:
├── 7 วันก่อนหมด: reminder
├── 3 วันก่อนหมด: urgent
└── 1 วันก่อนหมด: last chance

Forfeit: ลาออก / 31 ธ.ค. reset / contract termination
```

---

## 7.11 Correction Flow

### Correction Types

1. Forgot Check-in
2. Forgot Check-out
3. Time Adjustment

### 🔒 Correction Window (C-06 Fixed)

| Window | Action | Approver |
|--------|--------|---------|
| 0–24 ชม. | Self-correct via LIFF | Supervisor เท่านั้น |
| 25–72 ชม. | Correction request flow ปกติ | Supervisor → HR Admin |
| > 72 ชม. | HR manual entry | HR Admin + Owner approve |

### Business Rules (🔒 Locked 25 เม.ย. 2569)

```yaml
self_correct_window: 24 hours
correction_request_window: 72 hours
after_72hr: HR manual + Owner approve
quota:
  monthly: unlimited
  diligence_impact: สาย+ลืม+correction รวม ≥ 3/เดือน → ตัดเบี้ยขยัน
sla:
  supervisor: 4 hours
  hr: 4 hours
  quiet_hours: 22:00-08:00  # C-11 Fixed: เปลี่ยนจาก 20:00 เป็น 22:00
counter_reset: monthly — วันที่ 1 เวลา 00:00
```

> **C-11 Fixed:** Quiet hours = **22:00–08:00** (align กับทุก section) ไม่ใช่ 20:00

---

## 7.12 Forgot Check-in/out Policy

### Forgot Check-in

- **0–24 ชม.:** self-correct via LIFF (Supervisor approve เท่านั้น)
- **> 24 ชม.:** HR manual + Owner approve + evidence

### Forgot Check-out

```
auto_close: shift_end + 2 hours
├── timestamp = shift_end
└── flag: auto_closed_due_to_forgotten

self_correct_window: 24 hr
```

---

## 7.13 Emergency Unlock

### Access Control

```
Approver 1: Owner (เฮีย) [Required]
Approver 2: Owner Delegate (ไนซ์ หรือ จิว)
Timing:     Both approve within 1 hour (sequential)
Reason:     min 100 characters  ← C-07 Fixed (เพิ่ม min chars ให้ชัด)
```

> **C-07 Fixed:** Emergency Unlock ใน Attendance context ต้องการ reason **min 100 chars** เช่นเดียวกับ Section 4 และ Section 5

### Use Cases

```
✅ ปกส. ยื่นผิด (แก้ย้อน)
✅ WHT ยื่นผิด
✅ Attendance ผิด 10+ คน ก่อน payroll
✅ Ruling จาก สรรพากร/สปส.
❌ พนักงาน 1 คนลืม check-in (ใช้ correction)
```

---

## 7.14 Override / Force Proceed

```
Access: Owner + Delegate (all), HR Admin (attendance+correction)
Reason: min 50 characters
Confirm: 2-click (warning → type "OVERRIDE")
Audit:  Level 2, 2-year retention
```

---

## 7.15 Data Model

### Core Tables

```sql
-- Master (4): shifts, ot_types, holiday_calendar, cost_centers
-- Transactional (8): employee_shifts, attendance_logs,
--   attendance_summary_daily, attendance_queue,
--   ot_requests, substitute_tokens, correction_requests,
--   employee_diligence_counters
-- Audit (3): emergency_unlock_logs, override_audit_logs,
--   attendance_notifications

CREATE TABLE attendance_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES employees(id),
  event_type TEXT NOT NULL CHECK (event_type IN ('check_in', 'check_out')),
  event_date DATE NOT NULL,
  timestamp_reported TIMESTAMPTZ NOT NULL,
  timestamp_accepted TIMESTAMPTZ NOT NULL,
  gps_latitude DECIMAL(10, 7),
  gps_longitude DECIMAL(10, 7),
  home_cost_center_id UUID NOT NULL,
  actual_cost_center_id UUID NOT NULL,
  is_cross_location BOOLEAN GENERATED ALWAYS AS
    (home_cost_center_id != actual_cost_center_id) STORED,
  shift_id UUID,
  is_late BOOLEAN DEFAULT false,
  late_minutes INT DEFAULT 0,
  is_corrected BOOLEAN DEFAULT false,
  correction_request_id UUID,
  auto_closed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 7.16 Edge Cases Summary

| # | Case | การจัดการ |
|---|------|---------|
| 1 | พนักงานใหม่กลางเดือน | Prorated + probation |
| 2 | ลาออกกลางเดือน | Force expire tokens |
| 3 | ลาป่วย 1 ครั้ง | ตัดเบี้ยขยัน (C-03 Option A) |
| 4 | HQ-00 ใกล้ HQ-01 | auto-detect by home_cost_center |
| 5 | Device clock ผิด > 5 นาที | Block offline sync |
| 6 | Correction > 72 ชม. | HR manual + Owner |
| 7 | Emergency Unlock | 2-person + min 100 chars (C-07) |
| 8 | Sale Admin ป่วย 3 คน | Skip + LINE notify |
| 9 | Holiday Pivot < 7 วัน | Block |
| 10 | OT > 36 ชม./สัปดาห์ | Hard block |

---

## 🚨 Pending Action Items (Pre Go-Live)

- [ ] GPS coordinates 3 จุด (HQ-00, HQ-01, CC-04)
- [ ] Holiday Calendar 2570 (ก่อน 15 ธ.ค. 2569)
- [ ] ข้อบังคับการทำงาน — update ก่อน go-live

---

*Last updated: 25 เม.ย. 2569 | C-06, C-07, C-11 resolved*
