# Section 5: Workflow หลัก (Core Workflows)

*User journey + approval flows | อัปเดต: 25 เม.ย. 2569*

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
📋 เลือกประเภท (9 ประเภท) → เลือกวัน
   ├── Full day / Half day (ถ้าประเภทนั้น support)
   ├── แสดง quota เหลือ
   └── แนบใบรับรองแพทย์ (ลาป่วย 3+ วัน)
   │
   ▼
📝 เหตุผล → Submit → Approval routing
```

### Backdate Leave (ลาป่วยเท่านั้น)

- ต้องการใบรับรองแพทย์
- Window ≤ 3 วัน
- 2-step: Supervisor → HR Admin

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

### OT Rules (🔒 C-09 Fixed)

| Rule | Value |
|------|-------|
| Standard OT window | **72 ชม.** หลังทำงาน |
| Urgent (emergency) | Post-approve ภายใน 24 ชม. (subset ของ 72hr) |
| Request | Staff-only (ม.24 consent) |
| Cap | 36 ชม./สัปดาห์ (hard block) |
| เภสัชกร | Fix 150 บาท/ชม. 🔒 D17 |

> **"Urgent"** = กรณีฉุกเฉินที่ทำ OT ไปก่อนแล้วแต่ลืมขอ — ยังอยู่ภายใน 72hr window เสมอ

### OT Request Flow

```
👤 Staff → LIFF → "ขอ OT"
   │
   ▼
📅 เลือกวัน + เวลา
   │
   ▼
🤖 Auto-detect + preview (ประเภท, rate, ชม., ค่าแรง, OT สะสม/cap)
   │
   ▼
📝 เหตุผล → Submit → Supervisor approve
   └── ถ้าเกิน 72 ชม. → BLOCK (ไม่สามารถขอได้)
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

### State Machine

```
[pending_supervisor]
   ├── Approve (≤3 วัน) → [approved] ✅
   ├── Approve (4-7 วัน) → [pending_hr]
   └── Reject → [rejected_supervisor] ❌

[pending_hr]
   ├── Approve (≤7 วัน) → [approved] ✅
   ├── Approve (8+ วัน) → [pending_owner]
   └── Reject → [rejected_hr] ❌

[pending_owner]
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

## 5.9 Summary: Key Decisions

| Topic | Decision | Rationale |
|-------|----------|-----------|
| OT type | Auto-detect | UX simple |
| OT request | Staff-only | ม.24 consent |
| OT window | 72 ชม. standard | 🔒 C-09 |
| Approval | Sequential | Simple, bug-resistant |
| Correction window | 24hr/72hr/>72hr | 🔒 C-06 |
| Payroll cancel | Draft only | Safe |
| Emergency unlock | 2-person | Balance |
| Leave types | 9 ประเภท | 🔒 C-05 |
| Commission | Manual Phase 1 | No API yet |
| Token forfeit | Use-or-lose | Model B1 |

---

## 5.10 Open Items

- [ ] Phase 2: OT Opportunity Broadcast
- [ ] Phase 2: Bluenote API
- [ ] Define LINE OA critical templates

---

*Last updated: 25 เม.ย. 2569 | C-05, C-09 resolved*
