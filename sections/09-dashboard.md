# Section 9: Dashboard & Reports 📊

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 9*

> **Status:** ✅ Locked — 24 เม.ย. 2569 (อัปเดต 25 เม.ย. 2569)
> **Scope:** Dashboard + Reports สำหรับทุก role
> **Dependencies:** Section 6 (Payroll), Section 7 (Attendance), Section 10 (Audit Log)

---

## 9.1 ภาพรวม

**Philosophy:** แต่ละ role เห็นเฉพาะที่จำเป็น | Critical metrics: Real-time | Trends: Daily refresh | Historical: On-demand

### Dashboard Hierarchy

```
Owner/Delegate → Company-wide KPIs + Alerts
HR Admin       → Operational metrics + pending queue
Finance        → Payroll + Tax + SSO (scope limited)
Supervisor     → Team view + approval queue
Staff          → Personal data + requests
```

---

## 9.2 Owner Dashboard

### Daily Pulse

**วันนี้ที่ต้องรู้:** พนักงานมาทำงาน X/Y (%) | ลาป่วย | สาย | Pending approvals

**เดือนนี้:** Payroll projected | OT cost + % budget | vs เดือนก่อน

**Alerts:**
- 🔴 Critical: OT เกิน 36 ชม. | Payroll ไม่ผ่าน approval | Data breach | ปกส. ไม่ทัน | ลาออกพร้อมกัน ≥ 2 คน
- 🟡 Warning: OT ≥ 30 ชม. | Correction 2/3 | Diligence at risk | Probation ending ใน 14 วัน
- 🟢 Info: Daily stats | Successful payroll | New hire

**Quick Actions:** [Approve Payroll] [View OT] [Holiday Cal] [Reports]

### Sub-views

- **Financial:** Payroll trend 12 เดือน | Cost by department | OT % by branch
- **Workforce:** Headcount by CC | Turnover | Probation status
- **Attendance:** Late trends | Absence | Leave utilization | Token usage
- **Risk:** Legal compliance | OT violations | Correction abuse | Audit findings

---

## 9.3 HR Admin Dashboard

### Primary View: Pending Queue

แสดง Corrections (SLA countdown) | Leave requests | DSR requests

**Correction Detail:** Employee info | Type | Claimed time | Reason | Evidence | Monthly counter (⚠️ ถ้า 3/3 → ตัดเบี้ยขยัน)

**Actions:** [✅ Approve] [❌ Reject] [💬 Ask details]

**This Month Summary:** New hires | Resignations | Late count | Corrections processed | Leave days used

### Employee Directory

Filter: Cost Center | Role | Status | Sort: Name/Hire/Salary | Click → Employee detail

---

## 9.4 Finance Dashboard

### 🔒 Access Scope (Locked: Payroll + Tax + SSO only)

✅ เห็น: Payroll Round 1+2 | WHT | SSO | Cash flow | Regulatory exports

❌ ไม่เห็น: Performance reviews | Disciplinary records | Strategic data

### Payroll Focus

- Current cycle status (Round 1/2 completed or pending)
- Cash flow forecast (Payroll total + SSO employer + WHT)
- Upcoming filings: สปส.1-10 (วันที่ 15) | ภ.ง.ด.1 (วันที่ 7) | ภ.ง.ด.1ก + 50 ทวิ (รายปี)

### Reports Available

**Standard:** Payroll Summary | WHT Detail | SSO Contribution | OT Cost | Commission | Leave Liability | Bonus Accrual

**Regulatory Exports:** ภ.ง.ด.1 .txt | ภ.ง.ด.1ก .txt | สปส.1-10 Excel/CSV | 50 ทวิ batch PDF | Bank transfer file (SCB BizFile)

---

## 9.5 Supervisor Dashboard

**Team Today:** Check-in status ทุกคน (✅/⚠️/❌)

**My Queue:** Pending approvals + SLA countdown

**Team Stats:** Attendance % | Late | OT total | Corrections

### Co-Sup Special View (เมล์/เดือน)

Sale Admin Management: Draft rotation schedule → Submit → Owner/ไนซ์ approve

---

## 9.6 Staff Self-Service

**วันนี้:** Shift + check-in status + Sale Admin Extension (ถ้ามี)

**My Payslip:** Round 1 + Round 2 + Download

**Leave Balance:** พักร้อน | ป่วย | กิจ | Substitute tokens (วันหมดอายุ)

**This Month:** Working days | Late | OT hours | Diligence status

**Available Actions:** Check-in/out | ขอลา | ขอ OT | Correction | Payslip | Token | Leave balance | Attendance history (3 months) | DSR (PDPA)

---

## 9.7 Standard Reports Library (7 Categories)

**Cat 1: Payroll** — Monthly Summary | Detail per employee | Bonus/Commission | YTD | Variance

**Cat 2: Tax** — WHT Summary | WHT Detail | 50 ทวิ | ภ.ง.ด.1 | ภ.ง.ด.1ก

**Cat 3: SSO** — Monthly Contribution | สปส.1-10 | Employee Statement | Employer Summary

**Cat 4: Attendance** — Daily | Monthly | Late | Absence | OT (by type/employee) | Cross-location

**Cat 5: Leave** — Balance (all) | Utilization | Liability (financial) | Upcoming Calendar

**Cat 6: Compliance** — PDPA consent status | DSR Log | Audit Export | Diligence Forfeit | Override Log

**Cat 7: Strategic** — Headcount Trend | Turnover | Cost per Employee | Department P&L | Workforce Planning

### Export Formats

| Format | Use case |
|--------|---------|
| PDF | Legal documents, payslips, 50 ทวิ |
| Excel | Data analysis, multi-sheet |
| CSV | Bulk transfer, integration |
| TXT | RD e-filing (ภ.ง.ด., สปส.) |
| JSON | API, DSR portability |

### Report Retention (🔒 C-14 Fixed)

| Report Type | Retention | เหตุผล |
|-------------|-----------|--------|
| General (attendance, leave, OT) | **2 ปี** | Align audit log |
| Payroll reports (payslip, summary) | **≥ 7 ปี** | กฎหมายภาษี |
| Payroll records ตาม พ.ร.บ.แรงงาน ม.115 | **≥ 10 ปี** | Legal minimum |
| Tax reports (ภ.ง.ด., สปส., 50 ทวิ) | **≥ 5–10 ปี** | ตาม Section 11 |

> **C-14 Fixed:** ไม่ใช่ "2 ปีทั้งหมด" — payroll/tax reports ยึดตาม Section 11 retention schedule

---

## 9.8 Real-time vs Batch (🔒 Locked: Hybrid)

### Data Freshness Policy

**Tier 1 — Real-time Push (Supabase Realtime):**
- check_in_count_today | pending_approval_count | critical_alerts | active_ot_hours | payroll_status
- Push เฉพาะ delta (ไม่ใช่ full refresh)

**Tier 2 — On-demand:** department_breakdown | individual_stats | leave_balance

**Tier 3 — Cached (pg_cron):**
- Daily 02:00: monthly_aggregates, yoy_trends, headcount_by_cc
- Hourly: today_late_count, today_attendance_rate
- Monthly Round 2: payroll_summary

### Resource Savings

| Approach | DB load |
|----------|---------|
| Naive polling (5s) | HIGH — 172,800 queries/day |
| Subscription Hybrid ✅ | LOW — ~500 events/day (96% ลดลง) |

### Daily Digest (🔒 Locked: **09:00 น.**) ← C-12 Confirmed

ส่งไป Owner + Delegates ทุกวัน 09:00 — check-in เมื่อวาน | OT สัปดาห์ | Alerts active | Payroll status (ถ้าอยู่ใน prep) | Dashboard link

---

## 9.9 Technical Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 15 App Router + shadcn/ui + IBM Plex Sans Thai |
| Charts | **Recharts** 🔒 — Line, Bar, Pie, Area, Heatmap, KPI cards |
| Data grid | TanStack Table |
| Backend | Supabase Postgres + Materialized views + pg_cron + Realtime |
| Security | RLS per role |

### Performance Targets

| Metric | Target |
|--------|--------|
| Dashboard load | < 2s (p95) |
| Chart render | < 500ms |
| Report export (< 50 rows) | < 10s |
| Bulk export (< 500 rows) | < 30s |
| Realtime latency | < 1s |

---

## 9.10 Access Control (RLS)

```sql
-- Owner/Delegate: ทุกอย่าง
-- Finance: Payroll + Tax + SSO เท่านั้น (🔒 Locked)
-- Supervisor: Team only
-- Staff: Own data only
```

---

## 9.11 Alert Triggers

```yaml
critical:
  ot_legal_breach: weekly_ot > 36hr → notify Owner + HR + Sup + Employee
  payroll_cutoff_missed: status != approved AND time > day_15_12pm
  sso_deadline: days_to_filing <= 3

warning:
  ot_approaching_cap: weekly_ot >= 30
  correction_high: monthly_corrections >= 2
  leave_balance_low: balance < 2 days

info:
  shift_published: schedule published → affected employees
  payslip_ready: round_2_completed → employee
```

---

## 9.12 Mobile-First

**~80% ใช้ผ่าน mobile** — Vertical cards, Large tap targets (44px+), Swipe gestures

**Desktop Only:** Payroll processing | Bulk operations | Export | Configuration | Advanced analytics

---

## 🔒 Locked Decisions Summary

| # | Decision |
|---|----------|
| Q1 | Daily Digest = **09:00 น.** (🔒 C-12) |
| Q2 | Dashboard refresh = Real-time Hybrid (Tier 1 Push delta, Tier 2 On-demand, Tier 3 Cached) |
| Q3 | Report retention = 2 ปี (general) | ≥7 ปี (payroll/tax) ตาม Section 11 (🔒 C-14) |
| Q4 | Finance access = Payroll + Tax + SSO only |
| Q5 | Chart library = Recharts |

---

*Last updated: 25 เม.ย. 2569 | C-12 (digest 09:00), C-14 (report retention tiered) resolved*
