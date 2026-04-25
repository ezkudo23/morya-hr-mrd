# Section 12: Deployment & Go-Live 🚀

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 12*

> **Status:** ✅ Locked — 24 เม.ย. 2569  
> **Scope:** Deployment plan + Go-Live strategy + Post-launch support  
> **Dependencies:** All sections 1–11

---

## 12.1 ภาพรวม (Overview)

### วัตถุประสงค์

| Item | Detail |
|------|--------|
| **From** | Humansoft Advance (51,253 บาท/ปี) |
| **To** | MYHR Custom (29,705 บาท/ปี) |
| **Savings** | 21,548 บาท/ปี + ROI หลายเท่า |
| **D-Day** | 1 ม.ค. 2570 🔒 Locked |

**Success criteria:**
- ✅ ไม่มี payroll miss ระหว่าง transition
- ✅ พนักงาน 33 คน onboarded (30 payroll + 3 PC)
- ✅ Zero data loss
- ✅ Legal compliance ตั้งแต่ day 1

### Timeline รวม (Compressed — Go-Live 1 ม.ค. 2570)

```
พ.ค. 2569     Dev kickoff (M1)
   │
   ├── M1: พ.ค.–ก.ค. (Foundation)
   ├── M2: ส.ค.–ก.ย. (Core features)
   ├── M3: ต.ค. (Polish + QA) ⚠️ Compressed
   │
พ.ย. 2569     UAT (User Acceptance Testing)
   │             ⚠️ Moved up 1 month
   │
ธ.ค. 2569     🎯 Parallel Run (Humansoft + MYHR)
   │             ⚠️ ช่วงสิ้นปี + เทศกาล
   │
1 ม.ค. 2570   🚀 GO-LIVE (MYHR only)
   │             ⚠️ วันหยุดปีใหม่
   │
ม.ค.–มี.ค.   Hyper-care (90 days)
   │
เม.ย. 2570   Normal operation mode
```

---

## ⚠️ 12.1.1 Compressed Timeline — Risk Acknowledgment

### การเลือก Go-Live 1 ม.ค. 2570 แทน 1 ก.พ. 2570 = Timeline บีบอัด

```
Original plan (1 ก.พ. 2570):
├── Dev M3: ต.ค.–พ.ย. 2569
├── UAT:    ธ.ค. 2569
├── Parallel: ม.ค. 2570
└── Go-Live: 1 ก.พ. 2570

Adjusted plan (1 ม.ค. 2570 — LOCKED):
├── Dev M3: ต.ค. 2569 only (เฉือน 1 เดือน)
├── UAT:    พ.ย. 2569 (moved up)
├── Parallel: ธ.ค. 2569 (ช่วงเทศกาลปลายปี)
└── Go-Live: 1 ม.ค. 2570 ✅
```

### Mitigation สำหรับ Compressed Timeline

| Risk | Mitigation |
|------|------------|
| 🚨 Dev compressed 1 เดือน | Feature prioritization + MVP approach; defer non-critical ไป M4 |
| 🚨 UAT ช่วงปลายปี (พ.ย.) — staff ลาเยอะ | UAT เฉพาะ working days; compress 3 สัปดาห์; critical paths only |
| 🚨 Parallel run ทับกับ Humansoft final year | Humansoft: final payroll + ภ.ง.ด.1ก; MYHR: shadow run ธ.ค.; dedicate team |
| 🚨 Go-Live วันหยุด (1 ม.ค.) | ใช้ 1 ม.ค. เป็น technical cutover (quiet); real go-live = 2 ม.ค. |
| 🚨 Year-end complexity | 31 ธ.ค.: Humansoft final payroll → 1 ม.ค.: MYHR start (YTD = 0) |

### ✅ Benefits ของการเลือก 1 ม.ค. 2570

- ✅ YTD reset = เริ่มสดไม่ต้องโอน running totals
- ✅ Leave balance reset = clean cut-over
- ✅ ภ.ง.ด.1ก ปี 2569 = ยื่นจาก Humansoft ชัดเจน
- ✅ 50 ทวิ ปี 2569 = Humansoft ออกให้ (ครอบคลุมปีเก่า)
- ✅ Substitute tokens reset (เริ่มสดทุกคน)
- ✅ Holiday calendar 2570 = เริ่มใน MYHR เลย

---

## 12.2 Development Milestones (Adjusted)

### M1: Foundation (พ.ค.–ก.ค. 2569)

**Scope: Infrastructure + Core schema**
- Supabase setup + RLS policies
- LINE LIFF integration
- Employee master (33 คน migration — 30 payroll + 3 PC)
- Auth (LINE Login OAuth)
- Cost centers + shifts master
- Basic UI framework (shadcn/ui)
- CI/CD (GitHub + Cloudflare Pages)

**Deliverables:**
- Employees login via LIFF ได้
- View own profile
- No functional features yet

**Exit criteria:**
- [ ] 100% employees migrated
- [ ] LINE login working
- [ ] Security audit passed (RLS tested)

---

### M2: Core Features (ส.ค.–ก.ย. 2569)

**Scope: Payroll + Attendance**
- Attendance check-in/out (GPS)
- Leave requests + approval
- OT requests + approval
- Payroll engine (Round 1 + 2)
- WHT calculation (Pure Auto)
- SSO calculation
- Correction workflow
- Substitute tokens
- Audit log (Level 1 + 2)

**Deliverables:**
- พนักงาน check-in ได้
- Run payroll end-to-end (ทดสอบ)
- Export ภ.ง.ด.1, สปส.1-10

**Exit criteria:**
- [ ] Parallel payroll run = Humansoft (match 100%)
- [ ] Edge cases tested (30 test scenarios)
- [ ] Legal review passed

---

### M3: Polish + QA (ต.ค. 2569 — เฉือน 1 เดือน)

**Scope: Dashboard + Reports + Notifications**
- Owner/HR/Finance/Supervisor dashboards
- Real-time push (Supabase Realtime)
- Standard reports (7 categories)
- LINE Notify integration
- PDPA workflows (DSR, consent)
- Emergency Unlock + Override
- Holiday calendar 2570

**⚠️ Compressed strategy:**
- Priority 1 (must): Payroll + Attendance + Basic Dashboard
- Priority 2 (ship if time): Reports + Advanced Dashboard
- Priority 3 (defer to post-launch): Nice-to-have features

**Exit criteria:**
- [ ] Performance targets met (< 2s load)
- [ ] Mobile responsive tested
- [ ] PDPA training video ready
- [ ] Documentation complete

---

### พ.ย. 2569: UAT (Compressed 3 weeks)

**Duration:** 3 สัปดาห์ (เดิม 4 สัปดาห์)

**Participants: Core team (11 คน)**
- Owner + Delegates
- HR Admin (การ์ตูน)
- Finance (นา, ก้อย, แอ๊ด)
- Supervisors (ค๊อป, จอย, เมล์, เดือน, ติ๋ง)

**Test scenarios (prioritized):**
- 20 critical scenarios (attendance, payroll, approval)
- 10 edge cases (LWP, resignation, cross-location)
- 5 crisis scenarios (data breach, payroll error)

**Success gate:**
- [ ] ≥ 95% scenarios pass
- [ ] 0 critical bugs
- [ ] ≤ 5 minor bugs
- [ ] Legal signoff

---

## 12.3 Data Migration Plan

### Data Sources (Humansoft Advance → MYHR)

**1. Employee master**
- 33 คน พร้อม personal info (30 payroll + 3 PC)
- Salary + bank accounts
- Hire dates + probation status
- Cost center assignments
- ⚠️ Manual add: เฮีย + ไนซ์ + จำเนียร (ไม่อยู่ใน Humansoft)

**2. Historical payroll (2568–2569 archive)**
- Reference only (ไม่ migrate เข้า MYHR)
- Keep ใน Humansoft read-only 6 เดือน
- Export PDF archive

**3. Leave balances (รีเซ็ต 1 ม.ค. 2570)**
- ✅ YTD reset — เริ่ม fresh ปีใหม่
- Carry-over พักร้อน (ถ้ามีนโยบาย)
- Substitute tokens — reset ทั้งหมด (Model B1)

**4. Disciplinary records** (ถ้ามี)

**NOT migrating (fresh start):**
- Attendance logs (Humansoft เก็บไว้ reference)
- GPS data (ไม่มีใน Humansoft)
- Photos (privacy concern)

---

### Migration Phases

| Phase | เวลา | รายละเอียด |
|-------|------|------------|
| **Phase 1** Reference data | ก.ย. 2569 (M2) | Cost centers, shifts, holiday calendar 2569 (ref), employee master, role assignments |
| **Phase 2** Historical snapshot | ต.ค. 2569 (M3) | Humansoft payroll history export (PDF), archive → Google Drive, 50 ทวิ ปี 2568 (ref) |
| **Phase 3** Opening balances | 31 ธ.ค. 2569 23:59 | Leave carry-over, bank accounts verified, verify match 100% |
| **Phase 4** Go-live data | 1 ม.ค. 2570 | Holiday calendar 2570, shift schedules ม.ค., new employee data (if any), all counters = 0 |

### Data Validation Checklist

**Pre-migration:**
- [ ] Employee count match (33 = 30 payroll + 3 PC)
- [ ] Salary sum match
- [ ] Leave balance match (carry-over)
- [ ] Bank account verified ทุกคน
- [ ] Role assignments correct

**Post-migration:**
- [ ] Spot check 10 random employees
- [ ] Test payroll simulation (เดือน ม.ค.)
- [ ] Login test ทุกคน
- [ ] Sign-off จาก Finance

---

## 12.4 Parallel Run (ธ.ค. 2569) 🔒 Locked: 1 เดือน

**เจตนา:** รันระบบทั้ง 2 พร้อมกัน 1 เดือน เพื่อ verify MYHR + train ทีม + หา bugs + confidence check

| ระบบ | Mode | หน้าที่ |
|------|------|---------|
| **Humansoft** | Primary (ใช้จริง) | Payroll + ยื่นแบบ + โอนเงิน + legal records |
| **MYHR** | Shadow (ทดสอบ) | Check-in คู่ขนาน + payroll shadow + compare |

### Parallel Run Checklist

**Week 1 (1–7 ธ.ค.):**
- [ ] Daily: พนักงาน check-in ทั้ง 2 ระบบ
- [ ] Compare attendance logs EOD
- [ ] Fix discrepancies
- [ ] Verify GPS + correction working

**Week 2 (8–14 ธ.ค.):**
- [ ] Test leave requests ใน MYHR
- [ ] Test OT workflow
- [ ] Run payroll simulation (พ.ย. data)
- [ ] Compare WHT calculations

**Week 3 (15–21 ธ.ค.):**
- [ ] Run parallel payroll (ธ.ค.)
  - Humansoft: Real payroll
  - MYHR: Shadow calculation
- [ ] Compare: employee by employee
- [ ] Investigate variances > 1 บาท
- [ ] Sign-off before Round 2

**Week 4 (22–31 ธ.ค.):**
- [ ] Training refresher ทีม
- [ ] Final data sync
- [ ] Go/No-Go decision meeting (28 ธ.ค.)
- [ ] Backup Humansoft data
- [ ] Freeze Humansoft (31 ธ.ค. 23:59)

### Go/No-Go Decision (28 ธ.ค. 2569)

**Participants:** เฮีย + ไนซ์ + จิว + การ์ตูน + นา

**Go criteria (ต้องผ่านทุกข้อ):**
- [ ] Parallel payroll variance < 100 บาท/คน
- [ ] Zero critical bugs
- [ ] Core team trained (≥ 95% quiz pass)
- [ ] Legal documents updated
- [ ] Data migration verified
- [ ] Backup + rollback plan tested
- [ ] PDPA compliance ready

**No-Go scenarios:**
- Critical bug found → Delay 2 weeks (Go-Live 15 ม.ค.)
- Payroll variance > 500 บาท → Investigate
- Training incomplete → Extend parallel run
- Legal issue → Consult + delay

---

## 12.5 Go-Live Day (1 ม.ค. 2570) 🔒 Locked

### ⚠️ Special Consideration: วันหยุดปีใหม่

1 ม.ค. 2570 = วันขึ้นปีใหม่ (วันหยุด — ร้านปิด)

**Strategy:**
- ใช้ 1 ม.ค. เป็น technical cutover (ระบบเปลี่ยน)
- ไม่มีพนักงาน check-in (วันหยุด)
- Staff กลับมาทำงานวันที่ 2 ม.ค. → เจอระบบใหม่
- Real operational go-live = 2 ม.ค. 2570

### 1 ม.ค. 2570 — Technical Cutover (Quiet Day)

| เวลา | Action |
|------|--------|
| 00:00 | Humansoft set to read-only; export final state; archive access เปิด 6 เดือน |
| 00:30 | MYHR final data sync; verify employee master + leave balances; all counters = 0 |
| 05:00 | System health check (Supabase uptime ✓, LINE LIFF ✓, Cloudflare ✓, Alerts ✓) |
| 09:00 | Send LINE announcement to ทุกคน via LINE OA; link tutorial + support contact |
| ตลอดวัน | Tech team on-call (standby อยู่บ้าน) |

### 2 ม.ค. 2570 — Operational Go-Live (War Room Active)

| เวลา | Action |
|------|--------|
| 07:00 | War Room activated (HQ); Team standby: การ์ตูน + ไนซ์ + เฮีย; monitor dashboard |
| 08:00 | First check-in window opens; broadcast video tutorial reminder |
| 08:30 | First shift starts (HQ-WS: 10 คน; CC-01: 3 คน) |
| 09:00 | CC-04 opens |
| 12:00 | Midday review (issues logged? support tickets? adjustments?) |
| 17:30 | End-of-day checkpoint; Sale Admin Ext starts; first check-out |
| 21:00 | All check-outs done |
| 22:00 | Day 1 retrospective (success metrics, issues list, action plan day 2) |

### War Room Protocol 🔒 Locked: 1 สัปดาห์ (1–7 ม.ค. 2570)

**Location:** HQ สำนักงานใหญ่  
**Team on-site:** เฮีย + ไนซ์ + การ์ตูน + Dev representative + นา

**Daily schedule:** 07:00 Standup | 12:00 Review | 17:30 EOD | 22:00 Retro

**Escalation:**
- Level 1: HR solve (การ์ตูน)
- Level 2: Ops issue → ไนซ์
- Level 3: Critical → เฮีย decide
- Level 4: Rollback trigger

**Communication:** LINE group "MYHR War Room" + Real-time dashboard + Emergency hotline

---

## 12.6 Rollback Plan

### Trigger Conditions

**🚨 Automatic rollback:**
- Data corruption detected
- Payroll miscalculation > 5% affected
- System unavailable > 2 hours
- Security breach confirmed
- Critical bug affecting all users

**⚠️ Discretionary rollback (Owner decide):**
- Multiple workflow failures
- User revolt (> 50% complaints)
- Regulatory issue
- Business continuity threat

### Rollback Procedures

| Scenario | เวลา | Impact | Action | Recovery |
|----------|------|--------|--------|----------|
| **A** | < T+24hr | น้อย | Reactivate Humansoft; re-enable LINE OA flows; announce to staff | 2–4 hr |
| **B** | T+7 days | ปานกลาง | Export MYHR data → Humansoft format; reactivate; re-input attendance manually | 1–2 days |
| **C** | T+30 days | สูง | Fix-forward > Rollback; patch critical bugs urgent; manual workarounds ชั่วคราว | — |

> **Note Scenario C:** ถ้าผ่าน payroll run แรกไปแล้ว cost of rollback > cost of fix → fix-forward ดีกว่า

### Backup Strategy

**Pre go-live (31 ธ.ค. 23:59):**
- Humansoft full export: Database dump + Reports PDF (YTD 2569)
- Stored 3 locations: Google Drive | External HDD | Offsite copy
- MYHR initial state: Supabase snapshot
- Retention: 2 ปี minimum

**Post go-live:**
- Daily: Supabase automated
- Weekly: Manual verification
- Monthly: Export to long-term storage
- Retention: Per PDPA retention policy (D15)

---

## 12.7 Humansoft Post Go-Live 🔒 Locked: Read-only 6 เดือน

**Period:** 1 ม.ค. 2570 → 30 มิ.ย. 2570

| Access | Permission |
|--------|------------|
| เข้าไปดูข้อมูล | ✅ Owner + Finance + HR |
| ยื่น ภ.ง.ด.1ก ปี 2569 (28 ก.พ.) | ✅ |
| ออก 50 ทวิ ปี 2569 (15 ก.พ.) | ✅ |
| Reference หาก dispute | ✅ |
| Rollback safety net | ✅ |
| Edit / modify data | ❌ Read-only เท่านั้น |

**ต้นทุน:** ~25,000 บาท (half year fee)  
**ROI justification:** Insurance policy — ไม่แพงเทียบกับ risk

### Decommission Timeline

| เวลา | Action |
|------|--------|
| ม.ค.–มี.ค. 2570 | Hyper-care + Humansoft read-only |
| พ.ค. 2570 | Review ว่าต้องใช้ Humansoft อีกไหม |
| มิ.ย. 2570 | Final export + archive offline |
| ก.ค. 2570 | Humansoft contract ends |
| หลังจากนั้น | เก็บ archive 2 ปี (ตาม PDPA) |

---

## 12.8 Training Plan (Adjusted Timeline)

### Training Schedule

| ช่วงเวลา | กลุ่ม | รูปแบบ |
|----------|-------|--------|
| พ.ย. 2569 (UAT) | Core team 11 คน | Deep training 3 sessions × 2 hr |
| 1–15 ธ.ค. | All-staff 21 คน | Onboarding 3 batches × 1 hr; Mobile LIFF demo |
| 16–31 ธ.ค. (Parallel) | ทุกคน | Hands-on practice; Q&A weekly; PDPA video + quiz (mandatory) |
| 1 ม.ค. 2570 | Support team | Standby on-call |
| ม.ค.–มี.ค. (Hyper-care) | ทุกคน | Daily tips LINE; weekly Q&A; monthly review |

### Training Content per Role

| Role | Duration | Topics |
|------|----------|--------|
| **Staff (20 คน)** | 1 hr | LINE login, check-in/out (GPS), leave/OT request, payslip view, correction, PDPA basics |
| **Supervisor (5 คน)** | 2 hr | All staff content + approve/reject, team dashboard, shift assignment, handle exceptions |
| **Co-Sup (เมล์, เดือน)** | +30 min | Sale Admin schedule management |
| **HR Admin (การ์ตูน)** | 4 hr | Full system tour, pending queue, correction workflow, PDPA DSR, employee directory, reports |
| **Finance (3 คน)** | 3 hr | Payroll Round 1+2, WHT, SSO filing, regulatory exports, error handling |
| **Owner/Delegate (3 คน)** | 2 hr | Dashboard, approvals, Emergency Unlock, override protocol, analytics |

### Training Materials

**Digital:**
- Video tutorials per role (uploaded ใน LIFF)
- Quick reference cards (PDF)
- FAQ page
- Search knowledge base

**Physical:**
- Printed quick-start guide (30 คน)
- Poster ที่ร้าน (QR code → tutorial)
- Laminated cheat sheet

---

## 12.9 Support Model (Post Go-Live)

### 3-Tier Support Structure

| Tier | ช่องทาง | Response time |
|------|---------|---------------|
| **Tier 1 Self-help** | FAQ ใน LIFF, video tutorials, quick reference cards | ทันที |
| **Tier 2 Peer/Supervisor** | Supervisor ช่วยทีม; HR Admin (การ์ตูน); LINE group "MYHR Help" | < 2 hr |
| **Tier 3 Owner/Dev** | Critical → ไนซ์; System bugs → Dev team; Emergency → เฮีย | < 24 hr |

### Hyper-care Period (ม.ค.–มี.ค. 2570)

**Intensive support 90 days:**
- Daily standup (2 สัปดาห์แรก)
- Weekly retrospective (เดือน 1–3)
- Monthly owner review
- Quick-response mode

**Metrics tracked:** Support ticket count | Resolution time | User satisfaction | System uptime | Payroll accuracy

**Exit criteria → Normal operation:**
- [ ] Tickets < 5/week
- [ ] All edge cases documented
- [ ] Team independent
- [ ] 3 months stable

---

## 12.10 Success Metrics

### KPIs (วัดที่ 30, 60, 90 วัน)

**Financial:**
- Budget adherence: ≤ 29,705 บาท/ปี
- Cost savings realized: ≥ 21,548 บาท/ปี
- ROI positive: < 1 ปี

**Operational:**
- System uptime: ≥ 99.5%
- Payroll on-time: 100% (Round 1 + 2)
- SSO filing: 100% on time (วันที่ 15)
- ภ.ง.ด.1 filing: 100% on time (วันที่ 7)
- Zero payroll errors

**User Adoption:**
- Active users: ≥ 95% (monthly)
- Mobile usage: ≥ 80%
- Feature adoption: ≥ 70% (6 months)
- User satisfaction: ≥ 4/5

**Process:**
- Avg approval time: < 4 hr
- Correction resolution: < 8 hr
- Support tickets: < 10/month (steady state)
- Training completion: 100%

**Compliance:**
- PDPA incidents: 0
- Legal breaches: 0
- Audit findings: 0 critical
- Data retention adherence: 100%

### Reporting Cadence

| Frequency | Content |
|-----------|---------|
| **Daily** (30 วันแรก) | Check-in success rate, error count, support tickets |
| **Weekly** | KPI dashboard, issues list, action items |
| **Monthly** | Full metrics report → Owner; user feedback; roadmap adjustments; compliance check |
| **Quarterly** | ROI analysis, user satisfaction survey, system review, future enhancements |

---

## 12.11 Post-Launch Roadmap

| Phase | ช่วงเวลา | Focus |
|-------|----------|-------|
| **Phase 1** Stabilization | ม.ค.–มี.ค. 2570 | Fix critical bugs; high user support; monitor edge cases; documentation update |
| **Phase 2** Optimization | เม.ย.–ก.ค. 2570 | Speed improvements; UI refinement (user feedback); report customization; dashboard widgets |
| **Phase 3** Expansion | ส.ค.–ธ.ค. 2570 | Expand to Pizza/DQ staff; performance reviews; recruitment workflow; training management |
| **Phase 4** Scale | ปี 2571 | Clinic + Coffee integration; Bluenote full sync; mobile native app; AI insights (Claude API) |

---

## 12.12 Risk Register

| # | Risk | Impact | Likelihood | Mitigation |
|---|------|--------|------------|------------|
| 🔴 1 | Compressed timeline | High | High | Feature prioritization (MVP); defer non-critical ไป Phase 2; buffer 2 สัปดาห์ใน ธ.ค. |
| 🔴 2 | Payroll miscalculation | High | Medium | Parallel run 1 เดือน; spot check ทุกคน; manual override capability |
| 🔴 3 | System downtime (Supabase) | High | Low | Offline check-in queue; 99.9% SLA; manual attendance form backup |
| 🟡 4 | Staff resistance/confusion | Medium | High | Intensive training; peer support (supervisor); owner communication |
| 🟡 5 | Data migration errors | High | Low | 4-phase migration; validation checkpoints; Humansoft read-only 6 เดือน |
| 🟡 6 | Year-end/new year distractions | Medium | High | 1 ม.ค. = technical cutover only; real go-live 2 ม.ค.; pre-announce + training done ก่อนสิ้นปี |
| 🟢 7 | Legal/regulatory change | Medium | Medium | Lawyer on retainer; quarterly policy review; flexible config system |

---

## 🔒 Locked Decisions Summary

| # | Decision | Detail |
|---|----------|--------|
| Q1 | Parallel Run | 1 เดือน (ธ.ค. 2569) |
| Q2 | Go-Live Date | 1 ม.ค. 2570 — YTD clean reset; ⚠️ compressed timeline (เฉือน 1 เดือน); 1 ม.ค. = technical cutover; 2 ม.ค. = real operational go-live |
| Q3 | Humansoft Post Go-Live | Read-only 6 เดือน; support ยื่น ภ.ง.ด.1ก + 50 ทวิ ปี 2569; decommission ก.ค. 2570 |
| Q4 | War Room | 1 สัปดาห์ (1–7 ม.ค. 2570) |

---

## 🔗 Related Sections

- Section 1: บทสรุปผู้บริหาร (budget + goals)
- Section 6: Payroll (migration target)
- Section 7: Attendance (migration target)
- Section 9: Dashboard (monitoring go-live)
- Section 11: PDPA (compliance ready)

---

## 📅 Critical Dates Summary

| วันที่ | Milestone |
|--------|-----------|
| พ.ค. 2569 | Dev kickoff (M1) |
| พ.ค.–ก.ค. | M1 Foundation |
| ส.ค.–ก.ย. | M2 Core features |
| ต.ค. | M3 Polish (compressed) |
| พ.ย. | UAT (3 weeks) |
| 15 ธ.ค. | Holiday Calendar 2570 ready ⚠️ Deadline |
| ธ.ค. | Parallel Run + All-staff training |
| 28 ธ.ค. | Go/No-Go decision meeting |
| 31 ธ.ค. 23:59 | Humansoft freeze |
| **1 ม.ค. 2570** | 🚀 GO-LIVE (Technical cutover) |
| **2 ม.ค. 2570** | Operational Go-Live (War Room) |
| 1–7 ม.ค. | War Room active |
| 15 ม.ค. | First SSO filing (Round 1) |
| 15 ก.พ. | 50 ทวิ ปี 2569 (from Humansoft) |
| 28 ก.พ. | ภ.ง.ด.1ก ปี 2569 (from Humansoft) |
| มี.ค. | Hyper-care ends |
| พ.ค. | Humansoft decommission review |
| 30 มิ.ย. | Humansoft fully decommissioned |

---

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked & Ready for Dev Kickoff*  
*⚠️ Timeline compressed — commitment to aggressive delivery*
