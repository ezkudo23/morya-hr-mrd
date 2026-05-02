# 🔒 Locked Decisions

> ทุก decision ที่ lock แล้วจะอยู่ที่นี่ — ห้าม revert โดยไม่มี approval จาก Owner

---

## 📋 Decision Index

| # | Date | Topic | Status | Sections |
|---|------|-------|--------|----------|
| D1 | 2026-04-21 | Headcount = 32 คน (in system) | 🔒 Locked | 1, 2, 3, 6, 7, 8, 12 |
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
| D17 | 2026-04-26 | Pharmacist OT Fix 150 | ✅ Legal Reviewed | 4, 6, 7 |
| D18 | 2026-04-25 | CC-HQ-WS Rotation | 🔒 Locked | 7 |
| **D19** | **2026-05-02** | **Shift Management Scope** | **📝 Draft v2** | **13** |

---

## D1: Headcount

**Date**: 21 เม.ย. 2569 | **Updated**: 26 เม.ย. 2569
**Source**: Reconciled from Humansoft data + จำเนียรออกจากระบบ 25 เม.ย. 2569

### Breakdown (32 คน in system)
- 3 Director/Delegate: เฮีย (20,000), ไนซ์ (20,000), จิว CEO02 (30,000)
- 5 Supervisors: MY04, MY05, MY11, MY14, MY23
- 20 Staff
- 1 SSO-only: สังวาลย์
- 3 PC: PC01 ชมพู่, PC02 ต่าย, PC03 พลอย
- ❌ จำเนียร = จ้างนอกระบบ ไม่มี employee record ใน MYHR

### Counting Metrics
- **Total in system**: 32 คน
- **Payroll run**: 29 คน (ไม่รวม สังวาลย์ + 3 PC)
- **Attendance tracking**: 28 คน (5 Sup + 20 Staff + 3 PC — ไม่รวม 3 Director + สังวาลย์)
- **LIFF Access**: 29 คน (ไม่รวม สังวาลย์ + PC limited)
- **SSO contribution**: 27 คน (Payroll 29 - เฮีย - ไนซ์)

---

## D2: Go-Live = 1 ม.ค. 2570

- เดิมตั้ง 1 ก.พ. 2570 — compressed เพื่อ year-end Humansoft savings
- 1 ม.ค. 2570 = ตรงกับ tax year + payroll year ใหม่ → migration cleanest
- Humansoft freeze: 31 ธ.ค. 2569 23:59
- 1 ม.ค.: Technical cutover; 2 ม.ค.: Operational

---

## D3: Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Next.js 15 + TypeScript strict + Tailwind 4 + shadcn/ui |
| Forms | React Hook Form + Zod |
| Database | Supabase Pro (Postgres + RLS + Auth) |
| Authentication | LINE Login (OAuth 2.0) |
| Mobile UI | LINE LIFF |
| Hosting | Cloudflare Pages |
| Error tracking | Sentry |
| PDF generation | Puppeteer |
| Excel export | exceljs |
| Font (Thai) | IBM Plex Sans Thai |
| Testing | Vitest (unit) + Playwright (e2e) |
| AI Assistant | Claude API Haiku |
| Charts | Recharts |
| Package manager | pnpm |

---

## D4: Finance (ไม่ใช่ Finance Lead)

- นา (MY16) = Finance — คนเดียวที่ run payroll ได้
- ไม่มีตำแหน่ง "Finance Lead" ในระบบ
- Finance Assistants (ก้อย, แอ๊ด) = support เท่านั้น ไม่ run payroll

---

## D5: Timeline Milestones

| Milestone | เป้าหมาย |
|-----------|---------|
| M0 MRD Approved | พ.ค. 2569 |
| M1 Foundation | พ.ค.–ก.ค. 2569 |
| M2 Core Features | ส.ค.–ก.ย. 2569 |
| M3 Polish + QA | ต.ค. 2569 ⚠️ Compressed |
| UAT | พ.ย. 2569 (3 สัปดาห์) |
| Parallel Run | ธ.ค. 2569 |
| Go/No-Go | 28 ธ.ค. 2569 |
| **Go-Live** | **1 ม.ค. 2570** |

---

## D6-D8: Payroll Timeline

### Round 1: Salary Base
- ตั้งโอน: วันที่ 28 - สิ้นเดือน
- เงินเข้า: วันที่ 1 ของเดือนถัดไป (auto)
- Owner approve grace: วันที่ 1-7

### Round 2: Variable
- Commission + OT + เบี้ยขยัน + adjustments
- ทำ: วันที่ 1-14
- ยื่น สปส.1-10 + ตั้งโอน: วันที่ 15
- เงินเข้า: วันที่ 16

---

## D9: Hybrid Salary LogicIF พนักงานใหม่ (เดือนแรก) OR ลาออก (เดือนสุดท้าย):
USE Days Worked: salary = base × (worked_days / 30)ELSE (พนักงานเก่า):
USE Days Absent:
deduction = base × (absent_days / 30)
salary = base - deduction

### Always /30 Fixed
- ค่าแรงต่อวัน = salary / 30 (constant)
- ลา 1 วัน = หัก salary/30 ไม่ว่าเดือนไหน

---

## D10: SSO Formulabase = max(1,650, min(salary_actual, 15,000))
sso  = round(base × 5%, 2)Cases:
├── salary_actual ≤ 1,650 → SSO = 82.50 (floor)
├── 1,650 < salary_actual < 15,000 → SSO = salary_actual × 5%
└── salary_actual ≥ 15,000 → SSO = 750.00 (cap)

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

## D17: Pharmacist OT Fix 150 (✅ Legal Reviewed)

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

## D19: Shift Management Scope (📝 Draft v2 — Pending Team Review)

**Date**: 2 พ.ค. 2569
**Status**: 📝 Draft v2 — รอ review จากทีมก่อน lock
**Source**: Pair-programming session กับ Owner (อมร) — 2 พ.ค. 2569
**Replaces**: Humansoft shift management feature
**Revisions**: v2 — V2 fix (alert ไม่ block) + Coverage Alert unified

### Scope: 4 Workflows

```
1. Schedule Publishing       — Sup วางตารางทีม
2. Shift Swap                — Staff สลับกะกัน
3. Day-Off Swap              — Staff สลับวันหยุดกัน
4. Shift Change Request      — Staff ขอเปลี่ยนกะคนเดียว

❌ Coverage Substitution     — ใช้ Leave + OT workflow เดิม
❌ Open Shift Pool           — Phase 2 หลัง Go-Live
```

### 28 Sub-Decisions

#### A. Strategy & Architecture

| # | Decision | Choice |
|---|---|---|
| D19.1 | Phase Strategy | ทำทั้งก้อนรอบเดียว ไม่แบ่ง phase |
| D19.2 | Workflow Count | 4 workflow |
| D19.3 | SA Ext Layer | ไม่เพิ่ม Layer — SA Ext จัดการนอกระบบ swap |

#### B. Schedule Management

| # | Decision | Choice |
|---|---|---|
| D19.4 | Schedule Period | Hybrid — รายเดือน publish + ปรับสัปดาห์ |
| D19.5 | Schedule Source ม.ค. 2570 | Sup สร้างใน MYHR (parallel run ธ.ค. 2569) |
| D19.6 | Publish Lead Time | ไม่มี hard — Soft warn ก่อนวันเริ่มเดือน |
| D19.7 | Edit Window | แก้ได้ตลอด (ก่อนวันที่ผ่าน) — Re-publish + notify |
| D19.8 | Visibility (Staff) | เห็นแค่ทีม CC ตัวเอง |
| D19.9 | Validation Timing | Real-time warn + Block publish |

#### C. Shift Swap Rules

| # | Decision | Choice |
|---|---|---|
| D19.10 | Swap Approval | B accept + Sup approve (2-step) |
| D19.11 | Pharmacist Cross-CC Swap | Block |
| D19.12 | Probation Swap | Allow — สิทธิ์เท่าพนักงานปกติ |
| D19.13 | Cross-CC Swap (Staff ปกติ) | Allow — Sup ทั้ง 2 CC ต้อง approve |
| D19.14 | Cross-Role Swap | Block — สลับเฉพาะ role เดียวกัน |
| D19.15 | Sup ↔ Staff Swap | Escalate HR Admin / Owner |

#### D. Change Request Rules

| # | Decision | Choice |
|---|---|---|
| D19.16 | Change Request Lead Time | Normal 1 วัน + Urgent same-day |

#### E. Cancel & Rollback

| # | Decision | Choice |
|---|---|---|
| D19.17 | Cancel Swap (B agree path) | B agree → Sup approve → cancel |
| D19.18 | Cancel Swap (B reject) | จบ — Swap คงเดิม (ไม่ไป Sup) |
| D19.19 | Cancel Swap (B no response) | 24hr timeout → Sup decide |
| D19.20 | Cancel Swap < 24hr ก่อนวัน | Block — ใช้ leave/correction |
| D19.21 | After Check-in | Block — แนะนำใช้ Correction/Change Request |
| D19.22 | Chain Swap (multiple swaps/วัน) | Limit 1 swap/วัน/คน |

#### F. Edge Cases & Cascades

| # | Decision | Choice |
|---|---|---|
| D19.23 | E20 — B sick after swap | Sup decide 3 options + escalation 1hr/2hr |
| D19.24 | E21 — A resign after swap | Require ack + auto-cancel + Sup หาคนแทน |
| D19.25 | E22 — Schedule edit overlap swap | Sup confirm dialog ก่อน cancel swap |
| D19.26 | E38 — Both check-in (forgot swap) | Block 2nd check-in + alert Sup |

#### G. Coverage & Validation (NEW in v2)

| # | Decision | Choice |
|---|---|---|
| **D19.27** | **V1+V2 — Pharmacist/Sup Coverage** | **Alert (ไม่ block) — สิทธิ์ลาตามกฎหมาย** |
| **D19.28** | **Coverage Alert** | **Unified (4 scenarios) — Owner+Delegates, ม่านตู้ยา procedure, Owner cover CC-01/04** |

### Coverage Alert Rules (D19.28)

```yaml
recipient: Owner + Delegates (ไนซ์, จิว) เท่านั้น
trigger_timing:
  - timing_1: ตอน leave approve (early warning)
  - timing_2: ตอน schedule publish (final reminder)

scenarios:
  A_pharmacist_only_absent:
    severity: 🟡 Warning
    cc_affected: CC-HQ-WS เท่านั้น (เพราะ CC-01/04 Sup=Pharmacist เดียวกัน)
    operational_impact:
      - ร้านเปิดได้ตามปกติ
      - ปิดม่านตู้ยาอันตราย
      - ไม่จ่ายยาที่ต้องใบสั่งแพทย์

  B_sup_only_absent:
    severity: 🟡 Warning
    cc_affected: CC-HQ-WS เท่านั้น
    cover_approval:
      cc_hq_ws: Co-Sup (เมล์↔เดือน) automatic
      cc_01: Owner cover (default)
      cc_04: Owner cover (default)

  C_dual_gap_critical:
    severity: 🔴 Critical
    cc_affected: CC-01 หรือ CC-04 (เมื่อ ค๊อป/จอย ลา)
    options:
      - ขอเลื่อนการลา
      - หา pharmacist part-time + Owner cover Sup
      - ปิดร้านวันนั้น
      - ดึง Sup จาก CC อื่นมา cover

  D_cohqws_co_sup:
    severity: 🟢 Info
    cc_affected: CC-HQ-WS
    auto_resolved: Co-Sup คนอื่น cover ได้
```

### Special Rules

#### Pharmacist Coverage Alert (V1)
- Alert พิเศษเมื่อ ค๊อป (CC-01) หรือ จอย (CC-04) ขาด
- แจ้ง Owner + Delegates เท่านั้น
- ไม่ block — เพราะการลาเป็นสิทธิ์ตามกฎหมาย
- Operational: ปิดม่านตู้ยาอันตราย, ไม่จ่ายยาที่ต้องใบสั่งแพทย์

#### Validation Rules (V1-V11)
- V1: Pharmacist coverage per CC → 🟡 Alert (ไม่ block)
- V2: Supervisor coverage → 🟡 Alert (ไม่ block)
- V3: D18 weekly off (≥1 วันหยุด/สัปดาห์) → 🚫 Block (ม.28)
- V4: Rest period (≥12 ชม. ม.27) → 🚫 Block
- V5: OT cap (≤36 ชม./สัปดาห์) → 🚫 Block
- V6: Approved leave conflict → 🚫 Block
- V7: Approved OT conflict → 🟡 Warn
- V8: Sale Admin Ext (separate) → —
- V9: Cross-month boundary → 🚫 Block
- V10: Resignation date → 🚫 Block
- V11: Skill/Role compatibility → 🚫 Block (เฉพาะ swap)

### Notification Strategy

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

### Sprint Plan: 12 วัน

ดู Section 13.13 สำหรับ breakdown รายวัน

---

> 📌 **เพิ่ม decision ใหม่**: ใส่ต่อท้าย, อัปเดต Index, ใส่ section reference

*Last updated: 2 พ.ค. 2569 | D1 headcount corrected (32 in system / 29 payroll) | D17 Legal Reviewed | D19 Shift Management v2 — pending team review*
