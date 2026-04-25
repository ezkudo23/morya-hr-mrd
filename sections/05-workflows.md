# Section 5: Workflow หลัก (Core Workflows)

*User journey + approval flows | อัปเดต: 24 เม.ย. 2569*

> Workflow ทั้งหมดสืบทอดจาก **Section 4 (กฎพื้นฐาน)**

---

## ภาพรวม Workflow (8 flows)

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
✅ Check-in สำเร็จ — แสดงเวลา
   ├── ถ้าสาย → แสดง "สาย X นาที" (red)
   └── ปุ่มเปลี่ยนเป็น Check-out
```

### Check-out Flow

```
🕐 กด Check-out
   ├── Validate GPS 100m
   ├── คำนวณชั่วโมงทำงาน:
   │   ├── ≥ 6 ชม. → full day ✅
   │   ├── 3–6 ชม. → half day
   │   └── < 3 ชม. → full day (warning)
   └── Push notification
```

### Missing Check-out Handler

```
+1 ชม. หลังเลิกกะ:
└── 📱 Reminder: "ยังไม่ได้ check-out — กดเลย!"

23:59 — Auto-close:
├── มี approved OT → close ที่เวลา OT จบ
├── ELSE → close ที่เลิกกะปกติ
├── Flag "auto_closed"
└── Notify supervisor → review
```

---

## 5.2 ขอลา

### Leave Types (7 ประเภท)

| ประเภท | โควตา | จ่าย | Half-day | Backdate |
|--------|-------|------|----------|----------|
| พักร้อน | 6 วัน/ปี | ✅ | ✅ | ❌ |
| ป่วย | 30 วัน/ปี | ✅ | ✅ | ✅ (ภายใน 3 วัน) |
| กิจ | 3 วัน/ปี | ✅ | ✅ | ❌ |
| คลอด | 98 วัน | 45+45 | ❌ | ❌ |
| บวช | 15 วัน | ✅ | ❌ | ❌ |
| สมรส | 3 วัน | ✅ | ❌ | ❌ |
| ฌาปนกิจ | 5 วัน | ✅ | ❌ | ❌ |

### Approval Routing

| วันลา | Chain |
|-------|-------|
| ≤ 3 วัน | Supervisor |
| 4–7 วัน | Supervisor → HR Admin |
| 8+ วัน | Supervisor → HR Admin → Owner |

### Leave Request Flow

```
👤 Staff → LIFF → "ขอลา"
   │
   ▼
📋 เลือกประเภท → เลือกวัน
   ├── Full day / Half day
   ├── แสดง quota เหลือ
   ├── Check consecutive ≤ 3 วัน
   └── แนบใบรับรองแพทย์ (ลาป่วย 3+)
   │
   ▼
📝 เหตุผล → Submit → Approval routing
```

### Backdate Leave (ป่วยเท่านั้น)

ต้องการใบรับรองแพทย์ | Window ≤ 3 วัน | 2-step: Supervisor → HR Admin

---

## 5.3 ขอ OT

### Auto-detect OT Type

```typescript
function detectOTType(date: Date, time: TimeRange): OTType {
  const dayConfig = getHolidayConfig(date);

  if (dayConfig.isHoliday && dayConfig.storeOpen && dayConfig.isChanged) {
    if (time.isDuringShift) return 'holiday_changed_work'; // 2.0x
    return 'holiday_changed_ot'; // 3.0x
  }

  if (dayConfig.isHoliday && dayConfig.storeOpen) {
    return 'holiday_substitute_work'; // 1.0x + token
  }

  return 'weekday_ot'; // 1.5x
}
```

### OT Rules

- **Approval:** Hybrid Pre/Post — ปกติ: pre-approve | Urgent: post-approve (ภายใน 24 ชม.)
- **Request:** Staff-only (ตาม ม.24 consent)
- **Cap:** 36 ชม./สัปดาห์ (OT cap หลัง D12 flexible)
- **เภสัชกร:** Fix 150 บาท/ชม. ⚠️ Risk Accepted (D17)

### OT Request Flow

```
👤 Staff → LIFF → "ขอ OT"
   │
   ▼
📅 เลือกวัน + เวลา
   │
   ▼
🤖 Auto-detect + preview:
   ┌─────────────────────────┐
   │ วัน: 15 ต.ค. 2569        │
   │ เวลา: 18:00–22:00        │
   │ ประเภท: Weekday OT       │
   │ Rate: 1.5x               │
   │ ชั่วโมง: 4 ชม.            │
   │ ค่าแรง: 375 บาท           │
   │ OT สะสม: 28/36 ชม.       │
   └─────────────────────────┘
   │
   ▼
📝 เหตุผล → Submit → Supervisor approve
```

### Phase 2: OT Opportunity Broadcast (อนาคต)

Supervisor แจ้ง OT opportunity → Broadcast ไป team → Staff สนใจกดขอ → Supervisor approve (first come)

**Phase 1:** ใช้ LINE manual

---

## 5.4 Substitute Token

### Token Generation (Auto)

เงื่อนไข: วันหยุดนักขัตฤกษ์ + ร้านเปิด + Staff check-in → Auto-generate token → Notify staff

**Token format:**
```
Token ID: TOK-2026-013
Earned: 13 ต.ค. 2569
From: วันสวรรคต ร.9
Expires: 12 พ.ย. 2569
Status: Active
```

### Redemption Rules

| Rule | Detail |
|------|--------|
| Approval | Supervisor only |
| Rate | 1 token = 1 วัน (pooling หลายวันได้) |
| Expiry | 30 วัน strict |
| Forfeit | หมดอายุ = หาย (ไม่ต่อ) |
| แลกเงิน | ❌ ไม่ได้ |

### Redemption Flow

```
📱 Staff → LIFF → "My Tokens"
   │
   ▼
📋 Active + expired tokens → กด Redeem
   │
   ▼
📅 เลือกวัน
   ├── Validate: ไม่ใช่วันหยุด, ไม่มี shift, ไม่ติด > 3 วัน
   └── Submit → Supervisor
   │
   ▼
✅ Approved → Token = Redeemed → วันนั้น = หยุด → Audit log
```

### Expiry Reminders
- 7 วันก่อนหมดอายุ: reminder
- 3 วันก่อนหมดอายุ: reminder (urgent)

---

## 5.5 Approval Flow & SLA

### SLA

| Item | Value |
|------|-------|
| Base SLA | 4 ชม. ต่อระดับ |
| Quiet hours (22:00–08:00) | Pause → restart 08:00 |
| Auto-escalation | 4 ชม. overdue → HR |

### Sequential Model

เหตุผลที่เลือก Sequential (ไม่ใช่ Parallel): Dev cost ต่ำ | Testing ง่าย | Sup reject = ไม่รบกวน HR/Owner | Notification noise ต่ำ | Bug-resistant

### State Machine

```
📝 Request Created
   │
   ▼
[pending_supervisor]
   │
   ├── Approve → days ≤ 3?
   │   ├── YES → [approved] ✅
   │   └── NO → [pending_hr]
   │
   └── Reject → [rejected_supervisor] ❌
   │
   ▼
[pending_hr]
   │
   ├── Approve → days ≤ 7?
   │   ├── YES → [approved] ✅
   │   └── NO → [pending_owner]
   │
   └── Reject → [rejected_hr] ❌
   │
   ▼
[pending_owner]
   │
   ├── Approve → [approved] ✅
   └── Reject → [rejected_owner] ❌
```

### Co-Supervisor (เมล์ + เดือน)

- Notify ทั้ง 2 คน
- ใคร approve ก่อน = final
- Audit log บันทึกชื่อคน approve

---

## 5.6 แก้ Check-in ที่ผิด

### Detection Cases

1. ลืม check-in ตอนเข้า (ผ่านเริ่มกะ + grace 30 นาที)
2. ลืม check-out (auto-close แล้ว)
3. GPS error

### Flow

```
👤 Staff → LIFF → My Attendance
   │
   ├── Record มีปัญหา (red) → Report Issue
   │
   ▼
📝 Fill form:
   ├── ประเภท: ลืม check-in/out / GPS
   ├── เวลาจริง
   ├── เหตุผล (min 50 chars)
   └── แนบรูป (optional)
   │
   ▼
📤 Submit → Supervisor Review
   │
   ▼
📤 HR Admin Review
   └── Approve → record updated
   └── Reject → แจ้งคืน
```

**Note:** HR ไม่ต้องแก้ manual — แค่ approve sup decision

### Limit Policy

| Rule | Detail |
|------|--------|
| จำนวนครั้ง | ไม่จำกัด |
| > 4 ครั้ง/เดือน | Penalty — ตัดเบี้ยขยัน |

---

## 5.7 Payroll Run

### Schedule (🔒 Locked 24 เม.ย. 2569)

**Round 1 (Salary Base):**
- วันที่ 28–สิ้นเดือน: Finance คำนวณ + ตั้งโอนล่วงหน้า
- วันที่ 1 เดือนถัดไป: เงินเข้าบัญชี (auto)
- วันที่ 1–7: Owner approve grace period

**Round 2 (Commission + Variable):**
- วันที่ 1–14: Finance ดึง + verify commission + OT
- วันที่ 15: Deadline + ยื่น สปส.1-10
- วันที่ 16: Round 2 เข้าบัญชี + payslips

### State Machine

```
[draft] ←── Cancel & Re-run
   │ Owner approve
   ▼
[locked] ←── Emergency unlock
   │ วันที่ 15
   ▼
[filed]
   │ วันที่ 16
   ▼
[round2]
   │ Owner approve + pay
   ▼
[closed]
```

### Round 1 Flow

```
🌅 วันที่ 28 (ก่อนสิ้นเดือน):
   │
   ▼
Finance คำนวณ:
   ├── Base salary ตาม Hybrid Logic:
   │   ├── ทำงานครบเดือน → เต็ม
   │   ├── ใหม่/ลาออก → Days Worked (worked × base/30)
   │   └── ลากลางเดือน → Days Absent (base − absent × base/30)
   ├── หัก SSO: base × 5% (cap 750, floor 82.50)
   ├── หัก WHT (ถ้า enabled)
   └── ตั้งโอนล่วงหน้า (มีผล 1 ก.พ.)
   │
   ▼
Owner approve (grace period ถึง 7 ก.พ.)
   │
   ▼
วันที่ 1 ก.พ.: เงินเข้าบัญชีพนักงาน (auto)
```

### Cancel & Re-run

ทำได้เฉพาะ Draft state — ปุ่ม: Recalculate | Edit | Cancel | Submit

### Emergency Unlock

- Authorized: Owner + 1 Delegate (2-person)
- Required: reason (min 100 chars) + 2-click confirmation
- เฉพาะก่อน ปกส. filed

### Round 2 Flow

```
วันที่ 1–14:
   ├── Finance (นา) ดึง commission จาก Bluenote
   ├── Verify + คำนวณ OT
   ├── คำนวณเบี้ยขยัน (ตาม attendance 1–สิ้นเดือน)
   └── Adjustment จาก Round 1 (ถ้า error — ± ได้)
   │
วันที่ 15:
   ├── ตั้งโอน Round 2 (deadline)
   └── ยื่น สปส.1-10 online
   │
วันที่ 16:
   ├── เงิน Round 2 เข้าบัญชี (auto)
   ├── Release payslips (LIFF)
   └── Status: closed
```

### Commission Entry

- Phase 1: Manual (Finance นา entry)
- Phase 2: Bluenote API (อนาคต)
- Payout: เข้า Round 2 เท่านั้น
- Commission หลังลาออก: จ่าย Round 2 ปกติ

---

## 5.8 Onboarding / Offboarding

### Onboarding

```
HR → Admin Panel → New Employee
   ├── Step 1: ข้อมูลพื้นฐาน
   ├── Step 2: Employment (position, CC, salary)
   ├── Step 3: อัปโหลดเอกสาร
   └── Step 4: System access (Supabase + LINE)
   │
   ▼
Submit → Owner approve → Status: active
```

### Offboarding

```
Resignation received
   │
   ▼
HR → Start Offboarding
   ├── Last working day (+30 วัน)
   ├── Reason
   └── Exit interview schedule
   │
   ▼
Checklist (auto):
   ├── [ ] ส่งคืน key/อุปกรณ์
   ├── [ ] ปิด system access
   ├── [ ] Transfer tasks
   ├── [ ] Final payroll (prorated + severance)
   ├── [ ] ใบ certificate
   ├── [ ] ยื่น ปกส.6
   └── [ ] ออก 50 ทวิ
```

### Severance (ม.118)

| อายุงาน | Severance |
|---------|-----------|
| < 120 วัน | 0 |
| 120 วัน – 1 ปี | 30 วัน |
| 1–3 ปี | 90 วัน |
| 3–6 ปี | 180 วัน |
| 6–10 ปี | 240 วัน |
| > 10 ปี | 300 วัน |

### Exit Interview
- LIFF form + Face-to-face (HR meeting)
- Retention: 2 ปี

---

## 5.9 Summary: Key Decisions

| Topic | Decision | Rationale |
|-------|----------|-----------|
| OT type | Auto-detect | UX simple |
| OT request | Staff-only | ม.24 consent |
| Approval | Sequential | Simple, bug-resistant |
| Correction | 2-step (Sup → HR) | Transparency |
| Payroll cancel | Draft only | Safe |
| Emergency unlock | 2-person | Balance |
| Payroll exception | BLOCK Round 1 | Integrity |
| Commission | Manual Phase 1 | No API yet |
| Token forfeit | Use-or-lose | Model B1 |

---

## 5.10 Open Items

- [ ] Phase 2: OT Opportunity Broadcast
- [ ] Phase 2: Bluenote API integration
- [ ] Phase 2: Exit interview analytics
- [ ] Legal review: Emergency Unlock procedure
- [ ] Define LINE OA critical templates

---

## 5.11 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | เฮีย | Pending |
| Delegate | ไนซ์ | Pending |
| HR Admin | การ์ตูน | Pending |
| Finance | นา | Pending |
| Legal | TBD | Pending |

---

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked*
