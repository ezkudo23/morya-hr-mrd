# Section 13: การจัดการกะทำงาน (Shift Management) 🔄

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 13*

> **Status:** 📝 Draft v2 — 2 พ.ค. 2569
> **Scope:** ระบบวางตารางกะ + สลับกะ + ขอเปลี่ยนกะ สำหรับ **28 คน** (ไม่รวม 3 Directors + สังวาลย์ + จำเนียร)
> **Dependencies:** Section 4 (Rules), Section 5 (Workflows), Section 7 (Attendance), Section 8 (Notifications)
> **Replaces:** Humansoft shift management feature

---

## 13.1 ภาพรวม

### วัตถุประสงค์

ระบบจัดการกะทำงานของพนักงาน **28 คน** ที่ครอบคลุม:
- การวางตารางกะรายเดือน (Sup ↔ Team)
- การสลับกะระหว่างพนักงาน (Staff ↔ Staff)
- การขอเปลี่ยนกะชั่วคราว (Staff → Sup)
- ป้องกันการละเมิดกฎหมายแรงงาน (D18 ม.28, ม.27 rest period)
- รักษา shift coverage ของทุก CC (alert-only — ไม่ block สิทธิ์ลา)

### Employee Groups

```
Full Shift Management (25 คน):
└── Supervisor (5) + Staff (20)
    ├── ✅ วางตาราง / ดูตาราง / สลับกะ / ขอเปลี่ยนกะ
    └── ✅ Validate D18 + OT cap + rest period

Limited (3 คน):
└── PC01-PC03
    ├── ✅ ดูตารางตัวเอง
    ├── ❌ ไม่สลับกะ
    └── ❌ ไม่ขอเปลี่ยนกะ

Exempt (3 คน):
└── เฮีย, ไนซ์, จิว — ไม่อยู่ในระบบกะ
```

---

## 13.2 4 Workflows หลัก

| # | Workflow | Actor | Approval |
|---|---|---|---|
| **13.4** | Schedule Publishing | Supervisor | Self |
| **13.5** | Shift Swap | Staff | B accept + Sup approve |
| **13.6** | Day-Off Swap | Staff | B accept + Sup approve |
| **13.7** | Shift Change Request | Staff | Sup approve |

> **ไม่รวม:** Coverage Substitution (ใช้ Leave + OT workflow เดิม) | Open Shift Pool / Broadcast (Phase 2 หลัง Go-Live)

---

## 13.3 Locked Decisions

🔒 **D19: Shift Management Scope** — ดู `DECISIONS.md` D19 สำหรับรายละเอียดทั้ง 28 sub-decisions

### Quick Reference

```yaml
schedule_period: monthly_with_weekly_adjust
schedule_publish_deadline: ไม่มี hard (warn ก่อนวันเริ่มเดือน)
schedule_edit_window: ตลอด (ก่อนวันที่ผ่าน)
schedule_visibility: เห็นแค่ทีม CC ตัวเอง
validation_timing: real-time warn + block publish

swap_approval: B accept + Sup approve (2-step)
swap_chain_limit: 1 swap/วัน/คน
swap_pharmacist_cross_cc: BLOCK
swap_cross_role: BLOCK
swap_cross_cc_staff: ALLOW (Sup ทั้ง 2 CC ต้อง approve)
swap_sup_to_staff: ALLOW (escalate HR Admin/Owner)
swap_probation: ALLOW (สิทธิ์เท่าพนักงานปกติ)
swap_after_checkin: BLOCK (แนะนำใช้ Correction)

change_request_lead_time:
  normal: 1 day
  urgent: same-day (require detailed reason)

cancel_swap:
  default: B agree + Sup approve
  b_reject: end (Swap คงเดิม)
  b_no_response_24h: escalate Sup

coverage_alert:
  recipient: Owner + Delegates (ไนซ์, จิว)
  behavior: alert (ไม่ block — สิทธิ์ลาตามกฎหมาย)
  trigger_timing: 2 รอบ (ตอน leave approve + ตอน schedule publish)
  cc01_cc04_sup_absent: Owner cover approval

sup_absent_handling:
  cc_hq_ws: Co-Sup cover (เมล์↔เดือน)
  cc01_cc04: Owner cover approval (default)
```

---

## 13.4 Workflow 1: Schedule Publishing

### Lifecycle

```
[Draft]
   │ Sup กรอกตาราง (real-time validation)
   │ ── Warn: D18 / OT cap / Rest period / Coverage gap
   ▼
[Validate]
   ├── ผ่าน → Publish ได้
   └── ไม่ผ่าน → Block publish + แสดง errors ทั้งหมด
   │
   ▼
[Published]
   │ Notify ทีม (Smart Targeted)
   │ ส่ง Coverage Alert ถ้ามี gap
   │
   ▼ (Sup แก้ภายหลัง)
[Re-published]
   │ Notify ทุกคนที่ทำงานในวันที่แก้
   │
   ▼ (วันผ่านไป)
[Locked] — ไม่สามารถแก้ได้แล้ว ใช้ Correction flow
```

### Schedule Period Logic

**Hybrid Monthly with Weekly Adjustment:**
- Sup publish ตารางรายเดือน (เช่น ก.ค. 2569 ทั้งเดือน)
- หลัง publish — แก้รายสัปดาห์ได้ (เช่น สัปดาห์ที่ 2 ของ ก.ค.)
- ทุกการแก้ → re-validate + notify

### Validation Rules (V1-V11)

| # | Rule | Trigger | Action | Recipient |
|---|---|---|---|---|
| **V1** | Pharmacist coverage per CC | ค๊อป (CC-01) / จอย (CC-04) ขาด | 🟡 **Alert (ไม่ block)** | Owner + Delegates |
| **V2** | Supervisor coverage | Sup ขาดวันใดวันหนึ่ง/CC | 🟡 **Alert (ไม่ block)** | Owner + Delegates |
| **V3** | D18 weekly off | ≥1 วันหยุด/สัปดาห์/คน | 🚫 Block (ม.28) | — |
| **V4** | Rest period | ≥12 ชม. ระหว่างกะติดกัน (ม.27) | 🚫 Block | — |
| **V5** | OT cap | ≤36 ชม./สัปดาห์/คน | 🚫 Block | — |
| **V6** | Approved leave conflict | ห้ามมีกะวันที่ approve leave แล้ว | 🚫 Block | — |
| **V7** | Approved OT conflict | ห้ามทับ approved OT | 🟡 Warn | — |
| **V8** | Sale Admin Ext | จัดการนอกระบบ swap (ดู MRD 7.6) | — | — |
| **V9** | Cross-month boundary | ห้ามข้าม payroll cutoff | 🚫 Block | — |
| **V10** | Resignation date | ห้ามเกินวันสุดท้ายทำงาน | 🚫 Block | — |
| **V11** | Skill/Role compatibility | สลับเฉพาะ role เดียวกัน | 🚫 Block (เฉพาะ swap) | — |

> **Important:** V1 และ V2 = **Alert only ไม่ block** เพราะการลาเป็นสิทธิ์ตามกฎหมาย (ม.30, 32) — ระบบไม่ควรห้ามคนใช้สิทธิ์ของตัวเอง

### UI Pattern

```
┌─────────────────────────────────────────────────┐
│ ตารางกะ ก.ค. 2569 — CC-HQ-WS                    │
├─────────────────────────────────────────────────┤
│         จ.   อ.   พ.   พฤ.  ศ.   ส.   อา.       │
│ ─────────────────────────────────────           │
│ น็อต    เปิด  เปิด  หยุด  เปิด  เปิด  เปิด  ⚠️  │
│         🔴 D18: ทำงาน 6 วันติด ไม่มีวันหยุด      │
│                                                  │
│ อุ้ม    หยุด  เปิด  เปิด  เปิด  เปิด  เปิด  หยุด │
│         ✅ ผ่าน                                  │
└─────────────────────────────────────────────────┘

Status bar: 🔴 1 errors | 🟡 0 warnings | ✅ 7 ผ่าน

Coverage warnings (ไม่ block publish):
- 🟡 15 ก.ค. — ไม่มี Pharmacist ที่ CC-01 (ค๊อปลาพักร้อน)

[ บันทึก draft ]  [ Publish — disabled (ยังมี V3-V11 error) ]
```

### Notification — Smart Targeted

**ตอน publish ครั้งแรก:** notify ทุกคนใน CC

**ตอน re-publish (แก้ภายหลัง):** notify เฉพาะคนที่ทำงานใน "วันที่ถูกแก้" (เดิม + ใหม่)

```
ตัวอย่าง:
แก้ตาราง 15 ก.ค.:
- เดิม: น็อต(หยุด), อุ้ม(เปิด), ต้อม(ปิด)
- ใหม่: น็อต(ปิด), อุ้ม(เปิด), ต้อม(หยุด)
- Notify: น็อต + อุ้ม + ต้อม (ทั้ง 3 คนเกี่ยวข้อง)
```

---

## 13.5 Workflow 2: Shift Swap

### Use Case
สลับกะ (เปิด ↔ ปิด) "ในวันเดียวกัน" หรือ "คนละวันที่ทั้งคู่ทำงาน"

### State Machine

```
[Draft] — A กรอก
   │ A เลือก B + วัน + กะ + reason
   │
   ▼
[Pending B] — รอ B accept (SLA: 24 ชม.)
   ├── B accept → [Pending Sup]
   ├── B reject → [Rejected by B]
   └── Timeout 24h → [Rejected — B no response]
   │
   ▼
[Pending Sup] — Sup approve (SLA: 4 ชม. ตาม Section 5.5)
   ├── Validate V1-V11 → ผ่าน
   ├── Approve → [Approved]
   └── Reject → [Rejected by Sup]
   │
   ▼
[Approved]
   │ ระบบ swap shift ใน employee_shifts
   │ Notify A + B + ทีม (Smart Targeted)
   │
   ▼ (วัน swap ผ่านไป)
[Completed]
```

### Validation Rules (Pre-approval)

ทุก swap request ต้องผ่าน V1-V11 ตามตาราง 13.4

**เพิ่มเติมเฉพาะ Swap:**

| Rule | Detail |
|---|---|
| **A และ B ทั้งคู่ active** | ไม่ใช่ resigned |
| **ไม่มี swap pending วันเดียวกัน** | จำกัด 1 swap/วัน/คน |
| **ไม่ check-in แล้ว** | ถ้า check-in → block (ใช้ Correction) |
| **ไม่ backdate** | ห้ามขอย้อนหลัง |
| **Schedule published แล้ว** | ตารางที่จะ swap ต้อง published |

### Cross-CC Swap (Staff ปกติ — ไม่ใช่ Pharmacist)

```yaml
allowed: true
approval_chain:
  - B accept
  - Sup ของ A's CC approve
  - Sup ของ B's CC approve

example:
  A: CC-01 (Sup ค๊อป)
  B: CC-04 (Sup จอย)
  → ค๊อป + จอย ต้อง approve ทั้งคู่
```

### Pharmacist Cross-CC — BLOCK

ค๊อป (CC-01) ↔ จอย (CC-04) → ระบบ block — ไม่อนุญาต
> เหตุผล: ใบอนุญาตเภสัชกรผูกกับ CC เฉพาะ

### Sup ↔ Staff Swap

ถ้า Supervisor ขอ swap กับ Staff ในทีมตัวเอง:
- ❌ Sup self-approve ไม่ได้
- ✅ Escalate ไป **HR Admin** หรือ **Owner** เป็นคน approve

---

## 13.6 Workflow 3: Day-Off Swap

### Use Case
สลับ "วันหยุด" กันระหว่าง 2 คน — เช่น A หยุด จ. / B หยุด อ. → สลับ

### Critical Logic — สลับ "ทั้งวันหยุดและกะ"

**กะเดียวกัน:**
```
Before:
  A: หยุด จ. / ทำงาน อ. (กะเปิด)
  B: หยุด อ. / ทำงาน จ. (กะเปิด)

After:
  A: ทำงาน จ. (กะเปิด) / หยุด อ.
  B: หยุด จ. / ทำงาน อ. (กะเปิด)
```

**คนละกะ — ระบบต้อง swap "ทั้งวันหยุด + กะ":**
```
Before:
  A: หยุด จ. / ทำงาน อ. = กะเปิด
  B: หยุด อ. / ทำงาน จ. = กะปิด

After:
  A: ทำงาน จ. = กะปิด / หยุด อ.    ← รับกะปิดจาก B
  B: หยุด จ. / ทำงาน อ. = กะเปิด    ← รับกะเปิดจาก A

→ จ.ยังมีกะปิด, อ.ยังมีกะเปิด ✅ guarantee coverage
```

### State Machine

เหมือน Shift Swap (13.5) — ผ่าน B accept → Sup approve → V1-V11

---

## 13.7 Workflow 4: Shift Change Request

### Use Case
1 คน ขอเปลี่ยนเวลา/กะของวันใดวันหนึ่ง (ไม่มี partner) — เช่น มีหมอนัด ขอเลื่อนกะปิดเป็นกะเปิด

### State Machine

```
[Draft]
   │ Staff: เลือกวัน + กะใหม่ + reason
   │
   ▼ Lead Time Check
[Pending Sup]
   │ Validate V1-V11
   │
   ▼
   ├── Sup approve → [Approved]
   └── Sup reject → [Rejected]
```

### Lead Time Rules

| Type | Lead Time | Required |
|---|---|---|
| Normal | ≥1 วัน ก่อนวันเป้าหมาย | reason |
| **Urgent** | Same-day | ✅ Checkbox "ฉุกเฉิน" + reason ≥50 chars |

### Different from Swap
- ❌ ไม่มี partner — เปลี่ยนกะคนเดียว
- ✅ Sup approve คนเดียว
- ⚠️ ระบบไม่ช่วยหาคน cover shift เดิม — Sup ตัดสินใจ

---

## 13.8 Edge Cases & Cascading Failures

### Critical Edge Cases (38 ข้อ — High Severity)

#### **E20: B ลาป่วยหลัง swap approved**

```yaml
trigger: B ยื่นลาที่กระทบ approved swap
detection: ระบบเช็ค swap วันที่ B ลา
action: alert Sup ทันที + show 3 options

decision_options:
  auto_revert:    # cancel swap → A กลับมาทำ
  reassign:       # หาคนใหม่จากทีม
  skip:           # B ใช้ leave + Sup รับมือ

escalation:
  1hr no response: → HR Admin
  2hr no response: → Owner

audit: Level 2 (2 ปี)
```

#### **E21: A resign หลัง swap approved**

```yaml
trigger: Employee resigns + has future swaps

step_1_acknowledgment:
  show_warning: รายการ swap ที่จะถูก cancel
  require_confirmation: 2-click

step_2_auto_cancel:
  - cancel_all_future_swaps
  - notify_partners
  - notify_supervisor

step_3_open_shifts:
  status: open_shift
  sup_action_required: true
  sla:
    48hr_before_shift: notify Sup
    24hr_before_shift: escalate HR
    12hr_before_shift: escalate Owner

audit: Level 2
```

#### **E22: Sup แก้ schedule ทับ approved swap**

```yaml
detection: schedule edit เจอ approved swap วันนั้น
action: confirm dialog — "คุณกำลังแก้ schedule วันที่มีการขอสลับ
        กับ {partner} ไว้แล้ว โปรดคุยกับพนักงานก่อน
        [ยกเลิกการแก้] [คอนเฟิร์มแก้ + cancel swap]"

if_confirm: cancel swap + notify A + B + revert ทั้งคู่กลับเดิม
audit: Level 2
```

#### **E38: ทั้งคู่มา check-in (ลืม swap)**

```
A ↔ B swap วันที่ 15 (approved) — A รับกะ B
วันที่ 15:
  - B มา check-in (ลืมว่า swap)
  - A มา check-in (ตามที่รับมาจาก B)

ระบบ:
1. คนที่ check-in แรก = ถูก (ตามแผน หลัง swap)
2. คนที่ check-in ทีหลังหรือผิด = block + แสดง:
   "วันนี้คุณ swap กับ {partner} แล้ว — ไม่ต้องเข้างาน
    หากต้องการแก้ไข ติดต่อ Supervisor"
3. Alert Sup ทันที
```

### Edge Cases Summary Table (20 จุดสำคัญ)

| # | Case | Default Handle |
|---|---|---|
| E19 | A ลาป่วยหลัง swap | A ใช้ leave quota, B มาทำงาน |
| E20 | B ลาป่วยหลัง swap | Sup decide 3 options + escalation |
| E21 | A resign หลัง swap | Require ack + auto-cancel + Sup หาคนแทน |
| E22 | Schedule edit ทับ swap | Sup confirm dialog ก่อน cancel swap |
| E23 | Backdated swap | Block — ใช้ Correction |
| E24 | Far-future swap | Block — schedule ต้อง publish ก่อน |
| E25 | Last-minute swap | Allow + urgent SLA |
| E26 | Partial day swap | Block — ใช้ Leave + OT |
| E27 | Multi-day swap | Allow — 1 request หลายวัน |
| E28 | Mismatched expectations | Validate ตอน B accept |
| E29 | Privacy of swap | Visible แค่ A, B, Sup |
| E30 | Open swap broadcast | Phase 2 |
| E31 | Cross-role swap | Block — role mismatch |
| E32 | Sup ↔ Staff swap | Escalate HR Admin/Owner |
| E33 | Cross-week D18 | Validate ทั้ง 2 สัปดาห์ |
| E34 | Payroll calc | Salary ตามคน, OT ตาม hourly |
| E35 | Diligence calc | Swap-aware — ตามคนที่รับผิดชอบหลัง swap |
| E36 | History tracking | Audit log |
| E37 | System down | Offline queue (Section 7.4) |
| E38 | Both check-in | First-come + Block ที่สอง + alert Sup |

---

## 13.9 Cancel Swap Workflow

### Setup
หลัง swap approved แล้ว A เปลี่ยนใจอยาก cancel

### State Machine

```
[Approved Swap]
   │ A กดขอ cancel
   │
   ▼
[Pending B Response] — SLA 24 ชม.
   ├── B agree → [Pending Sup]
   ├── B reject → [Rejected — Swap คงเดิม] ✅ จบ ไม่ไป Sup
   └── B no response 24h → [Pending Sup — Auto-escalate]
   │
   ▼
[Pending Sup]
   ├── Sup approve cancel → [Cancelled — Revert]
   └── Sup reject cancel → [Swap คงเดิม]
```

### Constraints

| Condition | Action |
|---|---|
| Cancel ก่อนวัน swap < 24 ชม. | 🚫 Block — ใช้ leave/correction |
| Cancel หลัง check-in | 🚫 Block (ตาม E38) |
| A พยายาม cancel หลังถูก reject แล้ว | 🚫 Limit 1 cancel/swap |

---

## 13.10 Coverage Alert (Unified — Pharmacist + Supervisor)

🔒 **Special Alert** — รวม Pharmacist coverage + Supervisor coverage ไว้ที่เดียว

### Core Behavior

```yaml
recipient: Owner + Delegates (ไนซ์, จิว) เท่านั้น
behavior: Alert (ไม่ block — สิทธิ์ลาตามกฎหมาย)
trigger_timing:
  - timing_1: ตอน leave approve (early warning)
  - timing_2: ตอน schedule publish (final reminder)
audit: Level 2 (2 ปี)
```

### Sources of "Coverage Gap"

- ลา (leave approved)
- หยุดประจำสัปดาห์
- Swap approved (สลับวันหยุด → coverage เปลี่ยน)
- Resignation
- Sup absence (sick / personal)

### 4 Notification Scenarios

#### **🟡 Scenario A: Pharmacist ขาด (Sup ยังอยู่)**

> เกิดที่ CC-HQ-WS เท่านั้น — เพราะ CC-01/04 Sup = Pharmacist เดียวกัน

```
🟡 Pharmacist Coverage Alert
วันที่: 15 ก.ค. 2569
{CC} ไม่มีเภสัชกรประจำ
สาเหตุ: {ชื่อ} ลา{ประเภท} (approved)

⚠️ ผลกระทบ:
- ✅ ร้านเปิดได้ตามปกติ
- ⚠️ ต้อง "ปิดม่านตู้ยาอันตราย"
- ❌ ไม่จ่ายยาที่ต้องใบสั่งแพทย์

✅ Sup ในวันนั้น: {ชื่อ} cover ได้

Action:
[ ] รับทราบ — เปิดร้านพร้อมปิดม่าน
[ ] ขอเลื่อนลา (คุยกับพนักงาน)
[ ] หา pharmacist part-time
```

#### **🟡 Scenario B: Sup ขาด (Pharmacist ยังอยู่)**

> เกิดที่ CC-HQ-WS เท่านั้น — เพราะ CC-01/04 Sup = Pharmacist เดียวกัน

```
🟡 Supervisor Coverage Alert
วันที่: 15 ก.ค. 2569
{CC} ไม่มีหัวหน้างานประจำ
สาเหตุ: {ชื่อ} ลา{ประเภท} (approved)

⚠️ ผลกระทบ:
- ✅ เภสัชกรอยู่ — ร้านเปิดปกติ จ่ายยาได้
- ⚠️ Approval ลา/OT/correction ของทีม → ต้องมี cover

✅ Cover Approval Plan:
- CC-HQ-WS: Co-Sup เดือน/เมล์ cover ได้
- CC-01/CC-04: Owner cover (default)

Action:
[ ] รับทราบ — Owner cover approval
```

#### **🔴 Scenario C: ขาดทั้ง Sup + Pharmacist (CC-01/CC-04 critical)**

> เกิดที่ CC-01 (ค๊อปขาด) หรือ CC-04 (จอยขาด)

```
🔴 CRITICAL — Dual Coverage Gap
วันที่: 15 ก.ค. 2569
{CC} ไม่มีทั้ง Supervisor และ Pharmacist
สาเหตุ: {ชื่อ} ลา{ประเภท} (approved)

🚨 ผลกระทบรุนแรง:
- ❌ ไม่มีเภสัชกร — ต้อง "ปิดม่านตู้ยาอันตราย"
- ❌ ไม่มีหัวหน้า — Approval ขาดคน → Owner cover
- ⚠️ ทีม {CC} ขาดผู้นำในวันนั้น

🎯 ทางเลือก:
[ ] ขอเลื่อนการลา (คุยกับพนักงาน)
[ ] หา pharmacist part-time + Owner cover Sup
[ ] ปิดร้าน {CC} วันนั้น
[ ] ดึง Sup จาก CC อื่นมา cover (เมล์/เดือน/ติ๋ง)

⚠️ Owner ต้องตัดสินใจก่อนวันที่ 15
```

#### **🟢 Scenario D: CC-HQ-WS Co-Sup (resilient)**

```
🟢 Info — Co-Supervisor Coverage
วันที่: 15 ก.ค. 2569
CC-HQ-WS ขาด Sup 1 ใน 2
สาเหตุ: เมล์ ลาพักร้อน (approved)

✅ เดือน cover ได้ — ทีมยังมีหัวหน้า
ไม่ต้องดำเนินการเพิ่ม
```

### Coverage Gap Resolution — Approval Cover Logic

| CC | Sup Absent → Cover Approval |
|---|---|
| CC-HQ-WS | Co-Sup (เมล์ ↔ เดือน) — automatic |
| CC-01 | Owner cover (default) |
| CC-04 | Owner cover (default) |
| CC-SUPPORT-WH | Owner cover |

### Operational Note: ตู้ยาอันตราย

เมื่อ pharmacist ไม่อยู่:
- ✅ ร้านเปิดขายยาทั่วไปได้
- ⚠️ ต้องปิดม่านตู้ยาอันตราย (ป้องกันการขายผิดกฎหมาย)
- ❌ ไม่จ่ายยาที่ต้องใบสั่งแพทย์
- ❌ ไม่ขายยาที่ต้องเภสัชกรควบคุม

> นี่เป็น procedure ที่ Owner รับทราบและ Operate Humansoft แบบเดียวกัน

---

## 13.11 Notification Strategy

### ปริมาณคาด

```
1 swap = ~10-18 noti
5-10 swap/เดือน × 15 = 75-150 noti/เดือน
+ Coverage Alerts: ~10-20/เดือน
+ Schedule Re-publish: ~5-10/เดือน
─────────────
total Section 13: ~90-180 noti/เดือน

total noti (Section 8 + 13): ~740-980/เดือน
buffer remaining: ~93% ✅ ปลอดภัย
```

### Notification Triggers

| Event | Recipient | Priority |
|---|---|---|
| Schedule published | ทีม CC ทั้งหมด | Medium |
| Schedule re-published | คนที่ทำงานในวันที่แก้ | Medium |
| Swap requested | Partner B | Normal |
| Swap accepted by B | A + Sup | Normal |
| Swap approved | A + B + ทีม (summary) | Normal |
| Swap rejected | A | High |
| Cancel requested | B + Sup | Normal |
| **Coverage Alert** (Pharmacist/Sup gap) | **Owner + Delegates** | 🟡 Warning |
| **Coverage Alert — Critical (CC-01/04 dual gap)** | **Owner + Delegates** | 🔴 Critical |
| B sick after swap (E20) | Sup → HR → Owner (escalate) | 🔴 Critical |

---

## 13.12 Database Schema

### Tables ใหม่ (3 tables)

```sql
-- 1. Schedule period tracking
CREATE TABLE shift_schedule_periods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cost_center_id UUID NOT NULL REFERENCES cost_centers(id),
  year INTEGER NOT NULL,
  month INTEGER NOT NULL CHECK (month BETWEEN 1 AND 12),
  status TEXT NOT NULL CHECK (status IN ('draft', 'published')),
  published_at TIMESTAMPTZ,
  published_by UUID REFERENCES auth.users(id),
  week_overrides_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (cost_center_id, year, month)
);

-- 2. Shift swap requests (ใช้สำหรับ Shift Swap + Day-Off Swap)
CREATE TABLE shift_swap_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  swap_type TEXT NOT NULL CHECK (swap_type IN ('shift_swap', 'day_off_swap')),

  requester_id UUID NOT NULL REFERENCES employees(id),
  partner_id UUID NOT NULL REFERENCES employees(id),

  requester_date DATE NOT NULL,
  partner_date DATE NOT NULL,
  requester_shift_id UUID REFERENCES shifts(id),  -- NULL ถ้าหยุด
  partner_shift_id UUID REFERENCES shifts(id),    -- NULL ถ้าหยุด

  reason TEXT,

  -- 2-step approval
  partner_response TEXT NOT NULL DEFAULT 'pending'
    CHECK (partner_response IN ('pending', 'accepted', 'rejected', 'timeout')),
  partner_responded_at TIMESTAMPTZ,

  -- Cross-CC: ต้องมี Sup ทั้ง 2
  supervisor_a_id UUID REFERENCES auth.users(id),
  supervisor_b_id UUID REFERENCES auth.users(id),
  supervisor_a_status TEXT DEFAULT 'pending'
    CHECK (supervisor_a_status IN ('pending', 'approved', 'rejected')),
  supervisor_b_status TEXT DEFAULT 'pending'
    CHECK (supervisor_b_status IN ('pending', 'approved', 'rejected', 'not_required')),

  final_status TEXT NOT NULL DEFAULT 'pending'
    CHECK (final_status IN ('pending', 'approved', 'rejected', 'cancelled', 'timeout')),

  cancelled_at TIMESTAMPTZ,
  cancelled_by UUID REFERENCES auth.users(id),
  cancel_reason TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Shift change requests
CREATE TABLE shift_change_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES employees(id),

  target_date DATE NOT NULL,
  original_shift_id UUID REFERENCES shifts(id),
  requested_shift_id UUID REFERENCES shifts(id),

  is_urgent BOOLEAN DEFAULT FALSE,
  reason TEXT NOT NULL,

  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
  approver_id UUID REFERENCES auth.users(id),
  approved_at TIMESTAMPTZ,
  rejected_reason TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_swap_requester ON shift_swap_requests(requester_id, final_status);
CREATE INDEX idx_swap_partner ON shift_swap_requests(partner_id, partner_response);
CREATE INDEX idx_swap_dates ON shift_swap_requests(requester_date, partner_date);
CREATE INDEX idx_change_employee ON shift_change_requests(employee_id, status);
CREATE INDEX idx_change_target ON shift_change_requests(target_date);

-- RLS Policies (ตัวอย่าง)
ALTER TABLE shift_swap_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own swaps + Sup sees team swaps"
  ON shift_swap_requests FOR SELECT
  USING (
    requester_id = (SELECT employee_id FROM profiles WHERE user_id = auth.uid())
    OR partner_id = (SELECT employee_id FROM profiles WHERE user_id = auth.uid())
    OR (auth.jwt() ->> 'role') IN ('owner', 'owner_delegate', 'hr_admin', 'supervisor')
  );
```

### Existing Tables — ใช้ต่อ

```sql
-- employee_shifts (มีแล้ว) — ใช้เป็น final shift assignment
-- shifts (มีแล้ว) — ใช้ define shift types
-- public_holidays (มีแล้ว) — ใช้ validate holiday rules
```

---

## 13.13 Sprint Plan (12 วัน)

| Day | งาน | Deliverable |
|---|---|---|
| **Day 1** | MRD writing (Section 13 + DECISIONS D19 + CONFLICTS) | ✅ Section 13 finalized |
| **Day 2** | Schema migration + RLS + seed | DB ready |
| **Day 3-4** | RPC: schedule create/publish/edit + V1-V11 validation | RPC ready |
| **Day 5** | RPC: swap workflow (3 functions) | Swap RPC |
| **Day 6** | RPC: change request workflow (2 functions) | Change RPC |
| **Day 7-9** | UI: Supervisor schedule view + edit (calendar) | Sup UI |
| **Day 10-11** | UI: Staff view + swap form + change form | Staff UI |
| **Day 12** | Notification integration + Coverage Alert + integration testing | Production-ready |

---

## 13.14 Migration Strategy

### Phase: Parallel Run (ธ.ค. 2569)

```
1 ธ.ค. — Sup เริ่มสร้างตาราง ม.ค. 2570 ใน MYHR
       ↓
ทดสอบเปรียบเทียบกับ Humansoft (ทำงานคู่)
       ↓
15 ธ.ค. — ตาราง ม.ค. 2570 ครบทุก CC
       ↓
31 ธ.ค. — Humansoft freeze
       ↓
1 ม.ค. 2570 — Go-Live ใช้ MYHR เต็มรูปแบบ
```

### Training (พ.ย. 2569)

- Supervisor 5 คน → Schedule create + edit + validate
- Staff 20 คน → ดูตาราง + swap + change request
- HR Admin (การ์ตูน) → Sup-Staff swap escalation
- Owner + Delegates → Coverage Alert response procedure

---

## 13.15 Phase 2 Roadmap (หลัง Go-Live)

> ไม่อยู่ใน scope ของ Section 13 — ทำเฉพาะ post-Go-Live หากจำเป็น

- **Open Shift Pool** — A broadcast หาคนรับ shift, first-come-first-served
- **Auto-rotation Generator** — ระบบช่วย Sup สร้าง rotation pattern อัตโนมัติ
- **Shift Bidding** — Staff bid เข้ากะที่ต้องการ
- **Multi-week scheduling** — ตารางหลายเดือนพร้อมกัน
- **Mobile schedule preview** — ดู 4 สัปดาห์ล่วงหน้า
- **Pharmacist Backup Pool** — สร้าง part-time pharmacist registry

---

## 13.16 Open Items

- [ ] Schema migration script — เขียนตอน M2
- [ ] V1-V11 validation function library — ใช้ร่วม Schedule + Swap
- [ ] Notification templates 12 ตัว (publish, swap, cancel, 4 coverage scenarios, alerts)
- [ ] LIFF UI design — Supervisor calendar mode
- [ ] LIFF UI design — Staff swap modal
- [ ] Cron job — Auto-timeout B response 24h
- [ ] Cron job — Auto-escalate Sup decision (E20)
- [ ] Audit log integration — Level 2 events
- [ ] Coverage Alert templates (4 scenarios) — Real-time trigger logic
- [ ] Owner approval cover SOP — สำหรับ CC-01/CC-04 Sup absence

---

## 13.17 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | อมร | Pending |
| Delegate | ไนซ์ | Pending |
| HR Admin | การ์ตูน | Pending |
| Supervisor (HQ-WS) | เมล์ + เดือน | Pending |
| Supervisor (CC-01) | ค๊อป | Pending |
| Supervisor (CC-04) | จอย | Pending |
| Supervisor (WH) | ติ๋ง | Pending |
| IT | บอส | Pending |

---

*Last updated: 2 พ.ค. 2569 | Status: 📝 Draft v2 — V2 fix (alert ไม่ block) + Coverage Alert unified (4 scenarios) + ม่านตู้ยาอันตราย procedure*
