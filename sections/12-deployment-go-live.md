# Section 12: Deployment & Go-Live 🚀

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 12*

> **Status:** ✅ Locked — 24 เม.ย. 2569 (อัปเดต 25 เม.ย. 2569)
> **Scope:** Deployment plan + Go-Live strategy + Post-launch support
> **Dependencies:** All sections 1–11

---

## 12.1 ภาพรวม (Overview)

| Item | Detail |
|------|--------|
| **From** | Humansoft Advance (51,253 บาท/ปี) |
| **To** | MYHR Custom (29,705 บาท/ปี) |
| **Savings** | 21,548 บาท/ปี + ROI หลายเท่า |
| **D-Day** | 1 ม.ค. 2570 🔒 Locked |

**Success criteria:**
- ✅ ไม่มี payroll miss ระหว่าง transition
- ✅ พนักงาน **32 คน** onboarded: ← C-02 Fixed
  - 29 คน run payroll (LIFF + payroll)
  - 3 PC (LIFF limited — attendance only)
  - 1 สังวาลย์ (SSO-only — no LIFF)
  - ⚠️ จำเนียร = จ้างนอกระบบ **ไม่ migrate**
- ✅ Zero data loss
- ✅ Legal compliance ตั้งแต่ day 1

### Timeline รวม (Compressed)

```
พ.ค. 2569     Dev kickoff (M1)
   ├── M1: พ.ค.–ก.ค. (Foundation)
   ├── M2: ส.ค.–ก.ย. (Core features)
   ├── M3: ต.ค. (Polish + QA) ⚠️ Compressed
พ.ย. 2569     UAT (3 สัปดาห์)
ธ.ค. 2569     Parallel Run (Humansoft + MYHR)
1 ม.ค. 2570   🚀 GO-LIVE (Technical cutover)
2 ม.ค. 2570   Operational Go-Live (War Room)
ม.ค.–มี.ค.   Hyper-care (90 days)
```

---

## ⚠️ 12.1.1 Compressed Timeline — Risk Acknowledgment

```
Adjusted plan (1 ม.ค. 2570 — LOCKED):
├── Dev M3: ต.ค. 2569 only (เฉือน 1 เดือน)
├── UAT:    พ.ย. 2569 (moved up)
├── Parallel: ธ.ค. 2569
└── Go-Live: 1 ม.ค. 2570 ✅
```

| Risk | Mitigation |
|------|------------|
| Dev compressed 1 เดือน | MVP approach; defer non-critical ไป Phase 2 |
| UAT ปลายปี (พ.ย.) | Working days only; 3 สัปดาห์; critical paths |
| Parallel ทับ Humansoft final year | Dedicate team; MYHR shadow run |
| Go-Live วันหยุด | 1 ม.ค. = technical cutover; real go-live = 2 ม.ค. |

**Benefits ของ 1 ม.ค.:** YTD reset clean | Leave balance reset | ภ.ง.ด.1ก 2569 ออกจาก Humansoft | 50 ทวิ 2569 = Humansoft | Holiday calendar 2570 เริ่มใน MYHR

---

## 12.2 Development Milestones

### M1: Foundation (พ.ค.–ก.ค. 2569)

Supabase setup + RLS | LINE LIFF | Employee master | Auth | Cost centers + shifts | shadcn/ui | CI/CD

**Exit criteria:** 100% employees migrated | LINE login working | Security audit passed

### M2: Core Features (ส.ค.–ก.ย. 2569)

Attendance GPS | Leave + OT workflow | Payroll engine R1+2 | WHT | SSO | Correction | Substitute tokens | Audit log

**Exit criteria:** Parallel payroll = Humansoft (100%) | 30 test scenarios passed | Legal review passed

### M3: Polish + QA (ต.ค. 2569 — Compressed)

Dashboards | Reports | LINE Notify | PDPA | Emergency Unlock | Holiday calendar 2570

**Priority:** Must = Payroll+Attendance+Basic Dashboard | Should = Reports | Defer = Nice-to-have

### พ.ย. 2569: UAT (3 สัปดาห์)

**Participants:** เฮีย + ไนซ์ + จิว + การ์ตูน + นา + ก้อย + แอ๊ด + ค๊อป + จอย + เมล์ + เดือน (11 คน)

**Success gate:** ≥ 95% pass | 0 critical bugs | ≤ 5 minor | Legal signoff

---

## 12.3 Data Migration Plan

### Data Sources

**Employee master:** ← C-02 Fixed
- **29 คน payroll** + 3 PC (limited) = 32 คน in system
- ⚠️ Manual add: **เฮีย + ไนซ์** (ไม่อยู่ใน Humansoft)
- ❌ จำเนียร = **ไม่ migrate** (จ้างนอกระบบ)
- CEO02 จิว = ใน Humansoft แต่ salary = 0 → set 30,000 ใน MYHR

**Historical payroll:** Reference only — เก็บใน Humansoft read-only | Export PDF archive

**Leave balances:** Reset 1 ม.ค. 2570 (YTD fresh start)

### Migration Phases

| Phase | เวลา | รายละเอียด |
|-------|------|-----------|
| Phase 1 Reference data | ก.ย. (M2) | Cost centers, shifts, holiday 2569, employee master, roles |
| Phase 2 Historical snapshot | ต.ค. (M3) | Humansoft PDF archive → Google Drive |
| Phase 3 Opening balances | 31 ธ.ค. 23:59 | Leave carry-over, bank verified, counters = 0 |
| Phase 4 Go-live data | 1 ม.ค. 2570 | Holiday 2570, shift schedules ม.ค. |

### Data Validation Checklist

**Pre-migration:**
- [ ] Employee count match (29 payroll + 3 PC = 32 in system)
- [ ] Salary sum match
- [ ] Bank account verified ทุกคน
- [ ] Role assignments correct

**Post-migration:**
- [ ] Spot check 10 random employees
- [ ] Test payroll simulation (ม.ค.)
- [ ] Login test ทุกคน
- [ ] Sign-off จาก Finance

---

## 12.4 Parallel Run (ธ.ค. 2569) 🔒 1 เดือน

| ระบบ | Mode | หน้าที่ |
|------|------|---------|
| Humansoft | Primary (ใช้จริง) | Payroll + ยื่นแบบ + โอนเงิน + legal |
| MYHR | Shadow (ทดสอบ) | Check-in คู่ขนาน + payroll shadow + compare |

### Parallel Run Checklist

**Week 1 (1–7 ธ.ค.):** พนักงาน check-in ทั้ง 2 ระบบ | Compare EOD | Fix discrepancies

**Week 2 (8–14 ธ.ค.):** Test leave + OT | Run payroll simulation (พ.ย. data) | Compare WHT

**Week 3 (15–21 ธ.ค.):** Parallel payroll ธ.ค. — Humansoft real, MYHR shadow | Compare ทุกคน | Investigate variance > 1 บาท

**Week 4 (22–31 ธ.ค.):** Training refresher | Final data sync | Go/No-Go (28 ธ.ค.) | Freeze Humansoft (31 ธ.ค. 23:59)

### Go/No-Go Decision (28 ธ.ค. 2569)

**Participants:** เฮีย + ไนซ์ + จิว + การ์ตูน + นา

**Go criteria:**
- [ ] Parallel payroll variance < 100 บาท/คน
- [ ] Zero critical bugs
- [ ] Core team trained (≥ 95% quiz pass)
- [ ] Legal documents updated
- [ ] Data migration verified
- [ ] Rollback plan tested
- [ ] PDPA compliance ready

**No-Go:** Critical bug → delay 15 ม.ค. | Variance > 500 บาท → investigate

---

## 12.5 Go-Live Day (1 ม.ค. 2570) 🔒

**1 ม.ค. = วันหยุดปีใหม่ → Technical Cutover (Quiet)**

| เวลา | Action |
|------|--------|
| 00:00 | Humansoft → read-only; final state exported |
| 00:30 | MYHR final sync; all counters = 0 |
| 05:00 | Health check (Supabase ✓, LIFF ✓, Cloudflare ✓) |
| 09:00 | LINE announcement ทุกคน |
| ตลอดวัน | Tech team on-call (standby) |

**2 ม.ค. = Operational Go-Live (War Room)**

| เวลา | Action |
|------|--------|
| 07:00 | War Room active — การ์ตูน + ไนซ์ + เฮีย |
| 08:00 | First check-in window |
| 12:00 | Midday review |
| 22:00 | Day 1 retrospective |

### War Room 🔒 1 สัปดาห์ (1–7 ม.ค.)

Team: เฮีย + ไนซ์ + การ์ตูน + Dev rep + นา

**Escalation:** L1 = การ์ตูน | L2 = ไนซ์ | L3 = เฮีย | L4 = Rollback

---

## 12.6 Rollback Plan

**Auto triggers:** Data corruption | Payroll error > 5% | Downtime > 2 ชม. | Security breach

| Scenario | Impact | Recovery |
|----------|--------|---------|
| < T+24hr | น้อย | Reactivate Humansoft — 2–4 ชม. |
| T+7 days | ปานกลาง | Export + reactivate — 1–2 days |
| T+30 days | สูง | Fix-forward > Rollback |

**Backup:** Pre go-live snapshot (3 locations) | Post go-live daily automated | Retention 2 ปี

---

## 12.7 Humansoft Post Go-Live 🔒 Read-only 6 เดือน

**1 ม.ค. 2570 → 30 มิ.ย. 2570**

✅ เข้าดูได้ (Owner + Finance + HR) | ✅ ยื่น ภ.ง.ด.1ก ปี 2569 | ✅ ออก 50 ทวิ ปี 2569 | ❌ Edit

**Decommission:** พ.ค. 2570 review → มิ.ย. final export → ก.ค. contract ends → archive 2 ปี

---

## 12.8 Training Plan

| ช่วง | กลุ่ม | รูปแบบ |
|------|-------|--------|
| พ.ย. (UAT) | Core team 11 คน | Deep training 3 sessions × 2 hr |
| 1–15 ธ.ค. | All-staff 20 คน | Onboarding 3 batches × 1 hr |
| 16–31 ธ.ค. | ทุกคน | Hands-on + PDPA video + quiz (mandatory) |
| 1 ม.ค. | Support team | On-call standby |

| Role | Duration | Topics |
|------|----------|--------|
| Staff (20) | 1 hr | Check-in, leave/OT, payslip, correction, PDPA |
| Supervisor (5) | 2 hr | + Approve, team dashboard, shifts |
| HR Admin (การ์ตูน) | 4 hr | Full system, correction workflow, PDPA DSR |
| Finance (3) | 3 hr | Payroll R1+2, WHT, SSO, exports |
| Owner/Delegate (3) | 2 hr | Dashboard, approvals, Emergency Unlock |

---

## 12.9 Support Model

| Tier | ช่องทาง | Response |
|------|---------|---------|
| 1 Self-help | FAQ LIFF + Video | ทันที |
| 2 Peer/Supervisor | LINE "MYHR Help" + การ์ตูน | < 2 hr |
| 3 Owner/Dev | ไนซ์ + Dev + เฮีย (emergency) | < 24 hr |

**Hyper-care (90 days):** Daily standup 2 สัปดาห์แรก → Weekly retro → Monthly review

**Exit criteria:** Tickets < 5/week | All edge cases documented | Team independent | 3 months stable

---

## 12.10 Success Metrics

**Financial:** ≤ 29,705 บาท/ปี | ≥ 21,548 ประหยัด | ROI < 1 ปี

**Operational:** Uptime ≥ 99.5% | Payroll on-time 100% | SSO on-time 100% | Zero errors

**User Adoption:** Active ≥ 95% | Mobile ≥ 80% | Feature adoption ≥ 70% (6 เดือน) | Satisfaction ≥ 4/5

**Compliance:** PDPA incidents = 0 | Legal breaches = 0 | Audit critical = 0

---

## 12.11 Post-Launch Roadmap

| Phase | ช่วง | Focus |
|-------|------|-------|
| Stabilization | ม.ค.–มี.ค. 2570 | Fix bugs, high support |
| Optimization | เม.ย.–ก.ค. 2570 | Speed, UX refinement |
| Expansion | ส.ค.–ธ.ค. 2570 | Pizza/DQ staff, performance reviews |
| Scale | ปี 2571 | Clinic/Coffee, Bluenote sync, AI insights |

---

## 12.12 Risk Register

| # | Risk | Impact | Likelihood | Mitigation |
|---|------|--------|------------|------------|
| 🔴 1 | Compressed timeline | High | High | MVP; defer non-critical |
| 🔴 2 | Payroll miscalculation | High | Medium | Parallel run; spot check |
| 🔴 3 | System downtime | High | Low | Offline queue; 99.9% SLA |
| 🟡 4 | Staff resistance | Medium | High | Training; peer support |
| 🟡 5 | Data migration errors | High | Low | 4-phase; Humansoft 6 เดือน |
| 🟡 6 | Year-end distractions | Medium | High | Technical cutover 1 ม.ค. |
| 🟢 7 | Legal/regulatory change | Medium | Medium | Lawyer; quarterly review |

---

## 🔒 Locked Decisions

| # | Decision |
|---|----------|
| Q1 | Parallel Run = 1 เดือน (ธ.ค. 2569) |
| Q2 | Go-Live = 1 ม.ค. 2570 (technical) + 2 ม.ค. (operational) |
| Q3 | Humansoft = Read-only 6 เดือน → decommission ก.ค. 2570 |
| Q4 | War Room = 1 สัปดาห์ (1–7 ม.ค.) |

---

## 📅 Critical Dates

| วันที่ | Milestone |
|--------|-----------|
| พ.ค. 2569 | Dev kickoff (M1) |
| ต.ค. | M3 Polish (compressed) |
| พ.ย. | UAT (3 สัปดาห์) |
| **15 ธ.ค.** | Holiday Calendar 2570 ready ⚠️ Deadline |
| ธ.ค. | Parallel Run + All-staff training |
| 28 ธ.ค. | Go/No-Go meeting |
| 31 ธ.ค. 23:59 | Humansoft freeze |
| **1 ม.ค. 2570** | 🚀 GO-LIVE (Technical) |
| **2 ม.ค. 2570** | Operational + War Room |
| 15 ม.ค. | First SSO filing |
| 15 ก.พ. | 50 ทวิ ปี 2569 (Humansoft) |
| 28 ก.พ. | ภ.ง.ด.1ก ปี 2569 (Humansoft) |
| มี.ค. | Hyper-care ends |
| 30 มิ.ย. | Humansoft decommissioned |

---

*Last updated: 25 เม.ย. 2569 | C-02 resolved (headcount wording 32 คน, จำเนียรไม่ migrate)*
