# Section 5: Workflow หลัก (Core Workflows)

*User journey + approval flows | อัปเดต: 1 พ.ค. 2569*

> Workflow ทั้งหมดสืบทอดจาก **Section 4 (กฎพื้นฐาน)**

---

## ภาพรวม Workflow (9 flows)

| # | Workflow | Primary Actor |
|---|----------|--------------|
| 5.1 | Check-in/Check-out | Staff |
| 5.2 | ขอลา | Staff → Supervisor → HR → Owner |
| 5.3 | ขอ OT | Staff → Supervisor |
| 5.4 | Substitute Token | Staff (auto-earn) → Supervisor (redeem) |
| 5.5 | Approval Flow & SLA | ทุกระดับ |
| 5.6 | แก้ check-in ที่ผิด | Staff → Supervisor → HR |
| 5.7 | Payroll Run | Finance → Owner |
| 5.8 | Onboarding / Offboarding | HR → Owner |
| 5.9 | Shift Swap (Pending) | Staff → Staff → Supervisor |

---

## 5.1 Check-in / Check-out

### Core Rules

| Rule | Value |
|------|-------|
| GPS radius | 100 เมตรทุก location |
| Grace period | 0 นาที (strict) |
| Duplicate prevention | 5 นาที |
| Early check-in | อนุญาต + warning |
| เวลาที่บันทึก | เวลาจริง (ไม่ปัด) |
| Work time นับ | ไม่นับก่อนเริ่มกะ |

### Check-in Flow

```
👤 Staff → LINE LIFF
   │
   ▼
📱 หน้าแสดงกะวันนี้ + สถานะ + ปุ่ม Check-in
   │
   ▼
📍 กด Check-in
   ├── ขอ GPS
   ├── Validate radius 100m
   │   ├── ✅ ในรัศมี → proceed
   │   └── ❌ นอกรัศมี → error (แสดงระยะจริง)
   ├── Check duplicate 5 นาที
   └── IF early → warning + record
   │
   ▼
✅ Check-in สำเร็จ
   ├── ถ้าสาย → "สาย X นาที" (red)
   └── ปุ่มเปลี่ยนเป็น Check-out
```

### Missing Check-out Handler

```
+1 ชม. หลังเลิกกะ: 📱 Reminder
23:59 — Auto-close:
├── มี approved OT → close ที่เวลา OT จบ
├── ELSE → close ที่เลิกกะปกติ + flag "auto_closed"
└── Notify supervisor → review
```

---

## 5.2 ขอลา

### Leave Types (9 ประเภท — 🔒 C-05 Fixed)

| # | ประเภท | โควตา | จ่าย | Half-day | Backdate |
|---|--------|-------|------|---------|---------|
| 1 | พักร้อน | 6 วัน/ปี | ✅ | ✅ | ❌ |
| 2 | ป่วย | 30 วัน/ปี | ✅ | ✅ | ✅ (3 วัน) |
| 3 | กิจ | 3 วัน/ปี | ✅ | ✅ | ❌ |
| 4 | คลอด | 45+45 วัน | ✅ | ❌ | ❌ |
| 5 | บวช | 15 วัน | ✅ | ❌ | ❌ |
| 6 | สมรส | 3 วัน | ✅ | ❌ | ❌ |
| 7 | ฌาปนกิจ | 5 วัน | ✅ | ❌ | ❌ |
| 8 | ทหาร (รับราชการ) | ตามหมายเรียก | ✅ (ไม่เกิน 60 วัน) | ❌ | ❌ |
| 9 | ฝึกอบรม/วิชาชีพ | 30 วัน/ปี | ✅ | ❌ | ❌ |

> **ลา 8 (ทหาร):** ตาม ม.35 — พนักงานมีสิทธิ์ลาโดยไม่ถูกเลิกจ้าง
> **ลา 9 (ฝึกอบรม):** ตาม ม.34 — เฉพาะที่นายจ้างส่ง หรือได้รับอนุมัติ

### Approval Routing (🔴 อัปเดต 1 พ.ค. 2569 — DB-Driven)

approval chain เก็บใน `leave_requests.approver_role_sequence TEXT[]` — คำนวณตอน submit และเก็บไว้ใน row

#### Approval Flow ตาม Leave Type + จำนวนวัน

| leave_type | เงื่อนไข | sequence |
|------------|----------|----------|
| sick | 1–2 วัน | `[supervisor]` |
| sick | 3+ วัน (บังคับใบรับรองแพทย์) | `[supervisor, hr_admin]` |
| annual | 1 วัน | `[supervisor]` |
| annual | 2+ วัน | `[supervisor, hr_admin, owner]` |
| personal | ทุกกรณี | `[supervisor, hr_admin, owner]` |
| maternity | ทุกกรณี | `[supervisor, hr_admin]` |
| ordination | ทุกกรณี | `[supervisor, hr_admin, owner]` |
| marriage | ทุกกรณี | `[supervisor, hr_admin, owner]` |
| funeral | ทุกกรณี | `[supervisor, hr_admin, owner]` |
| lwp | ทุกกรณี (HR Admin บันทึกเอง) | `[hr_admin, owner]` |
| military | HR Admin จัดการ | `[hr_admin, owner]` |
| training | HR Admin จัดการ | `[hr_admin, owner]` |

#### Edge Cases

| กรณี | การจัดการ |
|------|----------|
| **Supervisor ลาเอง** | ข้าม `supervisor` step → เริ่มที่ `hr_admin` |
| **HR Admin ลาเอง** | ข้าม `supervisor` + `hr_admin` → ส่งตรง `owner` |
| **ไม่มี supervisor** (CC-SUPPORT-*) | เปลี่ยน `supervisor` → `owner` ใน sequence |
| **Owner/Delegate ลาเอง** | exempt — ไม่มี use case |
| **Owner/Delegate approve** | ข้าม step ได้เสมอ (any step) |

#### Config ใน system_config (DB-driven)

```
category = 'leave'
sick_doc_required_days    = 3   ลาป่วยกี่วันขึ้นไปต้องมีใบรับรองแพทย์
sick_approval_short_days  = 2   ลาป่วยไม่เกินกี่วัน Supervisor อนุมัติคนเดียว
annual_approval_single_day = 1  ลาพักร้อนไม่เกินกี่วัน Supervisor อนุมัติคนเดียว
```

### Leave Request Flow

```
👤 Staff → LIFF → "ขอลา"
   │
   ▼
📋 เลือกประเภท (9 ประเภท) → เลือกวัน
   ├── Full day / Half day (ถ้าประเภทนั้น support)
   ├── แสดง quota เหลือ
   └── แนบใบรับรองแพทย์ (ลาป่วย 3+ วัน)
   │
   ▼
🤖 ระบบคำนวณ approver_role_sequence
   ├── ตาม leave_type + จำนวนวัน
   └── Handle edge cases (Sup ลาเอง, HR ลาเอง, ไม่มี Sup)
   │
   ▼
📝 เหตุผล → Submit → Approval routing ตาม sequence
```

### Backdate Leave (ลาป่วยเท่านั้น)

- ต้องการใบรับรองแพทย์ (3+ วัน)
- Window ≤ 3 วัน
- Approval ตาม sequence ปกติ

---

## 5.3 ขอ OT

### OT Type — Auto-detect (🔴 อัปเดต 1 พ.ค. 2569)

**เดิม:** พนักงานเลือก OT type เองจาก 5 ตัวเลือก
**ใหม่:** ระบบ auto-detect จาก `holiday_calendar` table ไม่ให้พนักงานเลือกเอง

```
ตรวจ holiday_calendar WHERE date = ot_date AND type = 'closed'
├── พบ → ot_type = 'holiday'  (3.0x)
└── ไม่พบ → ot_type = 'normal'  (1.5x)
```

> **NOTE (Pre-Go-Live):** ต้อง seed `holiday_calendar` 2569+2570 จริงก่อน Go-Live
> ปัจจุบัน seed dummy 1-2 พ.ค. 2569 ไว้เทส — ลบก่อน Go-Live

**DB accept ค่า:** `normal` | `holiday` (2 ค่าเท่านั้น)
**เภสัชกร:** Fix 150 บาท/ชม. ไม่ว่า type จะเป็นอะไร 🔒 D17

### OT Rules (🔒 C-09 Fixed)

| Rule | Value |
|------|-------|
| Standard OT window | **72 ชม.** หลังทำงาน |
| Request | Staff-only (ม.24 consent) |
| Cap | 36 ชม./เดือน (hard block) |
| เภสัชกร | Fix 150 บาท/ชม. 🔒 D17 |

### OT Request Flow

```
👤 Staff → LIFF → "ขอ OT"
   │
   ▼
📅 เลือกวัน + เวลาเริ่ม/สิ้นสุด
   │
   ▼
🤖 Auto-detect ot_type จาก holiday_calendar
   ├── แสดง badge: "วันทำงาน (1.5x)" หรือ "วันหยุด (3.0x)"
   └── ไม่ให้พนักงานเลือก type เอง
   │
   ▼
✅ Validate client-side
   ├── OT ขั้นต่ำ 30 นาที
   ├── ไม่มีคำขอ OT วันนี้อยู่แล้ว (pending/approved)
   └── ไม่เกินโควต้า 36 ชม./เดือน
   │
   ▼
📝 เหตุผล (optional) → Submit → Supervisor approve
   └── ถ้าเกิน 72 ชม. → BLOCK
```

### Phase 2: OT Opportunity Broadcast (อนาคต)

Supervisor แจ้ง OT opportunity → Broadcast → Staff สนใจกดขอ → First come first served

---

## 5.4 Substitute Token

### Token Generation (Auto)

เงื่อนไข: วันหยุดนักขัตฤกษ์ + ร้านเปิด + Staff check-in ≥ 8 ชม. → Auto-generate

### Redemption Rules

| Rule | Detail |
|------|--------|
| Approval | Supervisor only |
| Rate | 1 token = 1 วัน |
| Expiry | 30 วัน strict |
| Forfeit | หมดอายุ = หาย |
| แลกเงิน | ❌ ไม่ได้ |

### Expiry Reminders

- 7 วันก่อนหมด: reminder
- 3 วันก่อนหมด: urgent reminder

---

## 5.5 Approval Flow & SLA

### SLA

| Item | Value |
|------|-------|
| Base SLA | 4 ชม./ระดับ |
| Quiet hours | 22:00–08:00 (pause SLA) |
| Auto-escalation | 4 ชม. overdue → HR |

### Sequential Model

เหตุผล: Dev cost ต่ำ, Testing ง่าย, Notification noise ต่ำ, Bug-resistant

### State Machine (Leave)

```
[pending] — step 1
   ├── Approve (ถ้า step < step_max) → advance to next approver
   ├── Approve (ถ้า step = step_max) → [approved] ✅
   └── Reject → [rejected] ❌

Approval sequence ดูจาก approver_role_sequence[current_step]
```

### Co-Supervisor (เมล์ + เดือน)

- Notify ทั้ง 2 คน
- ใคร approve ก่อน = final
- Audit log บันทึกชื่อคน approve

---

## 5.6 แก้ Check-in ที่ผิด

### Detection Cases

1. ลืม check-in ตอนเข้า
2. ลืม check-out (auto-close แล้ว)
3. GPS error

### Correction Window (🔒 C-06)

| Window | Action | Approver |
|--------|--------|---------|
| 0–24 ชม. | Self-correct via LIFF | Supervisor เท่านั้น |
| 25–72 ชม. | Correction request flow ปกติ | Supervisor → HR Admin |
| > 72 ชม. | HR manual entry | HR Admin + Owner approve |

### Flow (25–72 ชม.)

```
Staff → LIFF → My Attendance → Report Issue
   │
   ▼
กรอก: ประเภท + เวลาจริง + เหตุผล (min 50 chars) + รูป (optional)
   │
   ▼
Supervisor Review (SLA 4 ชม.)
   │
   ▼
HR Admin Review (SLA 4 ชม.)
   └── Approve → record updated + Audit Level 2
```

### Limit Policy

- ไม่จำกัดจำนวนครั้ง
- สาย + ลืม + correction รวม ≥ 3/เดือน → ตัดเบี้ยขยัน

---

## 5.7 Payroll Run

### Schedule (🔒 Locked)

**Round 1:** ตั้งโอน 28-สิ้นเดือน → เงินเข้า 1 → approve grace 1-7
**Round 2:** ทำ 1-14 → ตั้งโอน 15 + ยื่น สปส. → เงินเข้า 16
**Payslip:** ออกวันที่ 16 หลัง Round 2 เสร็จ (1 ใบ/เดือน รวม R1+R2)

### State Machine

```
[draft] ←── Cancel & Re-run (draft only)
   │ Owner approve
[locked] ←── Emergency unlock (2-person)
   │ วันที่ 15
[filed]
   │ วันที่ 16
[round2]
   │ Owner approve + pay
[closed]
```

### Emergency Unlock

- Authorized: Owner + 1 Delegate (2-person)
- Required: reason min 100 chars + 2-click confirm
- ใช้ได้ทั้งก่อนและหลัง ปกส. filed

### Commission

- Phase 1: Manual (Finance นา)
- Payout: Round 2 เท่านั้น

### Holiday Guard (Pre-Go-Live Requirement)

ก่อน run payroll รอบแรกของปีใหม่ — ระบบตรวจสอบว่ามีวันหยุด `holiday_calendar` ของปีนั้นครบหรือไม่
ถ้าน้อยกว่า threshold → แสดง warning บน Payroll page และ block การ run

---

## 5.8 Onboarding / Offboarding

### Onboarding

HR → Admin Panel → New Employee (4 steps) → Owner approve → Status: active

### Offboarding

```
Resignation received → HR Start Offboarding
   │
Checklist auto:
   ├── [ ] ส่งคืน key/อุปกรณ์
   ├── [ ] ปิด system access
   ├── [ ] Final payroll (prorated + severance)
   ├── [ ] ใบ certificate
   ├── [ ] ยื่น ปกส.6
   └── [ ] ออก 50 ทวิ
```

### Severance (ม.118)

| อายุงาน | Severance |
|---------|-----------|
| < 120 วัน | 0 |
| 120 วัน–1 ปี | 30 วัน |
| 1–3 ปี | 90 วัน |
| 3–6 ปี | 180 วัน |
| 6–10 ปี | 240 วัน |
| > 10 ปี | 300 วัน |

---

## 5.9 Shift Swap ⏳ Pending

> **Status:** Decision locked, ยังไม่มี schema หรือ UI — implement ก่อน Go-Live

### Rules

| Rule | Value |
|------|-------|
| สลับกับใคร | เฉพาะพนักงานที่อยู่ cost_center เดียวกัน |
| ผู้อนุมัติ | Supervisor ของสาขา |

### Flow

```
พนักงาน A ขอสลับกะ
   │
   ▼
พนักงาน B ยืนยัน (ต้องอยู่ cost_center เดียวกัน)
   │
   ▼
Supervisor อนุมัติ
   │
   ▼
ระบบสลับ employee_shifts ทั้ง 2 คน
```

---

## 5.10 Summary: Key Decisions

| Topic | Decision | Rationale |
|-------|----------|-----------|
| OT type | Auto-detect จาก holiday_calendar | ป้องกันพนักงานเลือก 3.0x ตลอด |
| OT request | Staff-only | ม.24 consent |
| OT window | 72 ชม. standard | 🔒 C-09 |
| Leave approval | DB-driven approver_role_sequence | DB-driven, flexible |
| Leave by type | แยก flow ตาม leave_type + วัน | Business logic ชัดเจน |
| Approval | Sequential | Simple, bug-resistant |
| Correction window | 24hr/72hr/>72hr | 🔒 C-06 |
| Payroll cancel | Draft only | Safe |
| Emergency unlock | 2-person | Balance |
| Leave types | 9 ประเภท | 🔒 C-05 |
| Commission | Manual Phase 1 | No API yet |
| Token forfeit | Use-or-lose | Model B1 |
| Shift Swap | Same cost_center only, Sup approve | ⏳ Pending |

---

## 5.11 Open Items

- [ ] Phase 2: OT Opportunity Broadcast
- [ ] Phase 2: Bluenote API
- [ ] Define LINE OA critical templates
- [ ] Shift Swap — schema + UI (ก่อน Go-Live)
- [ ] Holiday Calendar 2569+2570 seed จริง (ก่อน Go-Live)
- [ ] Holiday Guard บน Payroll Run page (ก่อน Go-Live)
- [ ] OT auto-detect upgrade: ถ้ามี holiday_calendar ครบ จะ detect แม่นยำขึ้น

---

*Last updated: 1 พ.ค. 2569 | Leave approval flow redesign (DB-driven approver_role_sequence) | OT type auto-detect จาก holiday_calendar | เพิ่ม 5.9 Shift Swap*
