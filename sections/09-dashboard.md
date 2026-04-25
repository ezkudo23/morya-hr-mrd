# Section 9: Dashboard & Reports 📊

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 9*

> **Status:** ✅ Locked — 24 เม.ย. 2569  
> **Scope:** Dashboard + Reports สำหรับทุก role  
> **Dependencies:** Section 6 (Payroll), Section 7 (Attendance), Section 10 (Audit Log)

---

## 9.1 ภาพรวม (Overview)

**Dashboard Philosophy:**
- แต่ละ role เห็นเฉพาะที่จำเป็น
- Owner เห็นทุกอย่าง — แต่ไม่ต้องเห็นทุกอย่างตลอด
- Critical metrics: Real-time
- Trend/Analytics: Daily refresh
- Historical reports: On-demand

### Dashboard Hierarchy

```
Owner Dashboard (เฮีย)
└── Company-wide KPIs + Alerts
    ↓
Delegate Dashboard (ไนซ์, จิว)
└── Same as Owner + specific functions
    ↓
HR Admin Dashboard (การ์ตูน)
└── Operational metrics + pending queue
    ↓
Finance Dashboard (นา, ก้อย, แอ๊ด)
└── Payroll, WHT, SSO, Budget (scope limited)
    ↓
Supervisor Dashboard (5 คน)
└── Team view + approval queue
    ↓
Staff Self-Service (20 คน)
└── Personal data + requests
```

---

## 9.2 Owner Dashboard (เฮีย / Delegate)

### หน้าแรก — Daily Pulse

**วันนี้ที่ต้องรู้:**
- พนักงานมาทำงาน: XX/XX (%)
- ลาป่วย + ชื่อ
- สาย + ชื่อ + นาที
- Pending approvals: N items

**เดือนนี้:**
- Payroll projected
- OT cost + % budget
- vs เดือนก่อน

**Alerts:** Critical (red) | Warning (yellow) | Info (green)

**ใกล้ครบกำหนด:** ยื่น สปส.1-10 | Holiday pivots | Forfeit review

**Quick Actions:** Approve Payroll | View OT | Holiday Cal | Reports

### Sub-views

**1. Financial View:** Payroll trend 12 เดือน | Cost by department | OT % by branch | YoY comparison

**2. Workforce View:** Headcount by CC | Turnover rate | Probation status | Average tenure

**3. Attendance View:** Late trends | Absence patterns | Leave utilization | Token usage

**4. Risk View:** Legal compliance indicators | OT cap violations | Correction abuse | Audit findings

### Alert Priorities

**🔴 Critical (ต้องดูทันที):**
- OT เกิน 36 ชม. (legal breach)
- Payroll ไม่ผ่าน approval ก่อน cut-off
- Data breach detected
- ปกส. ยื่นไม่ทัน (วันที่ 15)
- พนักงานลาออกพร้อมกัน ≥ 2 คน

**🟡 Warning (ควรรู้วันนี้):**
- OT ใกล้ cap (30+ ชม.)
- Correction 2/3 ครั้ง/เดือน
- Diligence bonus at risk
- ขาดงานไม่แจ้ง
- Probation ending ใน 14 วัน

**🟢 Info (FYI):**
- Daily digest stats
- Successful payroll run
- New hire onboarded
- Policy updates

---

## 9.3 HR Admin Dashboard (การ์ตูน)

### Primary View: Pending Queue

**📥 Pending Queue:** แสดงทุก item พร้อม SLA countdown
- 🔴 Corrections (SLA 4 ชม.)
- 🟡 Leave requests
- 🟢 DSR requests

**This Month Summary:** New hires | Resignations | Late count | Corrections processed | Leave days used

**Upcoming Tasks:** ยื่น สปส.1-10 | Collect Sale Admin schedule | Forfeit report

### Processing Center — Correction Detail View

แสดง: Employee info | Correction type | Date + claimed time | Reason | Evidence (photo link) | History + timestamps | Monthly counter | ⚠️ Warning ถ้า 3/3 → ตัดเบี้ยขยัน

Actions: [✅ Approve] [❌ Reject] [💬 Ask for details]

### Employee Directory View

Filter: Cost Center | Role | Status | Sort: Name/Hire date/Salary

แสดง: Code | Name | Role | CC | Salary | Alert count

Click row → Employee detail page

---

## 9.4 Finance Dashboard (นา, ก้อย, แอ๊ด)

### 🔒 Access Scope (Locked: Payroll + Tax + SSO only)

**Finance เห็น:** Payroll Round 1+2 | WHT calculations + filings | SSO contributions | Cash flow forecasts | Regulatory exports

**Finance ไม่เห็น:** Performance reviews | Disciplinary records | Strategic workforce data | Sensitive personal data | Other roles' operational views

### Payroll Focus

**Current Cycle:**
- Round 1 Status (completed/pending) + amount transferred
- Round 2 Status (prep window) + OT pending + commission + diligence + WHT

**Next Actions:** Finalize Round 2 → ยื่น สปส.1-10 → Transfer Round 2 + Export payslips

**Cash Flow Forecast:** Payroll total | SSO contribution (employer) | WHT liable | Total outflow

**Upcoming Filings:** สปส.1-10 (วันที่ 15) | ภ.ง.ด.1 (วันที่ 7 เดือนถัดไป) | ภ.ง.ด.1ก + 50 ทวิ (รายปี)

### Reports Available

**Standard Reports:** Payroll Summary | WHT Detail | SSO Contribution | OT Cost Analysis | Commission Report | Leave Liability | Bonus Accrual

**Regulatory Exports:** ภ.ง.ด.1 .txt (RD e-filing) | ภ.ง.ด.1ก .txt | สปส.1-10 Excel/CSV | 50 ทวิ batch PDF | Bank transfer file (SCB BizFile)

**Management Reports:** Payroll vs Budget | Cost per headcount | Department comparison | Trend analysis

---

## 9.5 Supervisor Dashboard (5 คน)

### Team View

**Team Today:** Check-in status ทุกคน (✅/⚠️/❌) + PC status (ไม่ในระบบ)

**My Queue:** Pending approvals พร้อม SLA

**Team Stats (This Month):** Attendance % | Late count | OT total | Corrections

**Team Schedule:** View Week | View Month | Assign Shifts

### Co-Sup Special View (เมล์/เดือน)

Additional view: Sale Admin Management (Rotation schedule draft + submit for approval)

---

## 9.6 Staff Self-Service (20 คน)

### หน้าแรก — My Profile

**วันนี้:** Shift + status (Check-in time) + Sale Admin Extension (ถ้ามี)

**My Payslip:** Round 1 + Round 2 (pending/completed) + Download link

**Leave Balance:** พักร้อน | ป่วย | กิจ | Substitute tokens (พร้อมวันหมดอายุ)

**This Month Stats:** Working days | Late count | OT hours | Diligence status

### Available Self-Service Actions

- ✅ Check-in / Check-out
- 📝 Submit leave request
- ⏰ Submit OT request
- ✏️ Request correction
- 📄 View/Download payslip
- 🎫 Use substitute token
- 🏖️ Check leave balance
- 📊 View attendance history (3 months)
- 🔐 Update LINE Notify preferences
- 📋 Submit DSR request (PDPA)
- ⚙️ Update contact info (not PII)

---

## 9.7 Standard Reports Library

### 7 Categories

**Category 1: Payroll Reports**
Monthly Payroll Summary | Payroll Detail (per employee) | Bonus & Commission | YTD Earnings | Payroll Variance (MoM, YoY)

**Category 2: Tax Reports**
WHT Summary | WHT Detail (per employee) | 50 ทวิ (individual) | ภ.ง.ด.1 export | ภ.ง.ด.1ก export (annual)

**Category 3: SSO Reports**
Monthly SSO Contribution | สปส.1-10 export | Employee SSO Statement | Employer Contribution Summary

**Category 4: Attendance Reports**
Daily Attendance | Monthly Summary | Late Report | Absence Report | OT Report (by type/employee) | Cross-location Report

**Category 5: Leave Reports**
Leave Balance (all) | Leave Utilization | Leave Liability (financial) | Upcoming Leave Calendar

**Category 6: Compliance Reports**
PDPA Compliance (consent status) | DSR Requests Log | Audit Log Export | Diligence Forfeit Log | Override/Emergency Unlock Log

**Category 7: Strategic Reports**
Headcount Trend | Turnover Analysis | Cost per Employee | Department P&L contribution | Workforce Planning

### Export Formats

| Format | Use case |
|--------|---------|
| PDF | Formal documents, signatures, legal (50 ทวิ, payslips) |
| Excel | Detailed data for analysis (multi-sheet workbooks) |
| CSV | Bulk data transfer, integration |
| TXT | RD e-filing format (ภ.ง.ด., สปส.) |
| JSON | API integration, DSR portability |

### Report Retention (🔒 Locked: 2 ปี)

Generated reports เก็บ 2 ปี — align กับ audit log retention — Raw data sources เก็บตาม data type retention (Section 11 PDPA)

---

## 9.8 Real-time vs Batch Updates (🔒 Locked: Hybrid)

### Data Freshness Policy

**Tier 1 — Real-time Push (Supabase Realtime WebSocket):**
- Push เฉพาะ delta (ไม่ใช่ full refresh)
- Data: check-in count, alerts, pending queue, OT cap, payroll status
- Cost: included in Supabase Pro
- ~5–10 critical metrics

**Tier 2 — On-demand (Lazy load):**
- User click → fetch latest
- Data: department breakdown, individual stats, leave balance

**Tier 3 — Cached (Materialized views via pg_cron):**
- Scheduled refresh
- Data: trends, aggregates, monthly totals

### Real-time Metrics

**Push (real-time):** check_in_count_today | pending_approval_count | critical_alerts | active_ot_hours | payroll_status

**On-demand:** department_breakdown | individual_stats | leave_balance | historical_trends

**Materialized refresh:**
- Daily 02:00: monthly_aggregates, yoy_trends, headcount_by_cc
- Hourly: today_late_count, today_attendance_rate
- Monthly Round 2: payroll_summary, budget_utilization

### Resource Cost Analysis

| Approach | Queries/day | Data/day | DB load |
|----------|------------|---------|---------|
| Naive polling (5s) | 172,800 | ~1 GB | HIGH |
| Subscription-based Hybrid ✅ | ~500 events | ~40 MB | LOW |
| Savings | — | ~96% reduction | — |

### UI Feedback

```
🟢 Live (connected)          3s ago
├── 👥 พนักงาน: 24/26
│       ↑ +1 (เมล์ just checked in)
└── ⚠️ Alerts: 2
        🆕 NEW: เดือน OT 30hr

Indicators:
├── 🟢 Live (connected + subscribed)
├── 🟡 Reconnecting (network blip)
├── 🔴 Offline (need refresh)
└── ⚡ Animation เมื่อมี update ใหม่
```

### Safeguards

- Rate limiting: max 10 events/sec, debounce 500ms
- Auto-reconnect: true, max retry 5, exponential backoff
- Fallback: ถ้า WebSocket fail → banner + poll every 30s + cache last state
- Battery optimization mobile: background = pause, focus lost = poll 60s

### Daily Digest (🔒 Locked: 09:00 น.)

ส่งไป Owner + Delegates via LINE ทุกวัน 09:00 — จำนวน check-in เมื่อวาน | OT ยอดสัปดาห์ | Alerts active | Payroll status (ถ้าอยู่ใน prep window) | Dashboard link

---

## 9.9 Technical Implementation

### Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 15 App Router + shadcn/ui + IBM Plex Sans Thai |
| Charts | **Recharts** (🔒 Locked) — Line, Bar, Pie/Donut, Area, Heatmap, KPI cards |
| Data grid | TanStack Table |
| Date | date-fns |
| Backend | Supabase Postgres + Materialized views + pg_cron + Supabase Realtime |
| Security | RLS per role |

### Performance Targets

| Metric | Target |
|--------|--------|
| Dashboard load | < 2 seconds (p95) |
| Chart render | < 500ms |
| Report export | < 10 seconds (PDF, < 50 rows) |
| Bulk export | < 30 seconds (Excel, < 500 rows) |
| Realtime latency | < 1 second (event to UI) |

### Supabase Realtime Example

```javascript
useEffect(() => {
  const subscription = supabase
    .channel('owner-dashboard')
    .on('postgres_changes', {
      event: 'INSERT',
      schema: 'public',
      table: 'attendance_logs',
      filter: `event_date=eq.${today}`
    }, (payload) => {
      updateCheckInCount(payload.new);
    })
    .on('postgres_changes', {
      event: 'UPDATE',
      schema: 'public',
      table: 'alerts',
      filter: 'severity=in.(critical,warning)'
    }, (payload) => {
      updateAlerts(payload.new);
    })
    .subscribe();

  return () => subscription.unsubscribe();
}, []);
```

### Materialized Views

```sql
-- Monthly payroll aggregates
CREATE MATERIALIZED VIEW mv_payroll_monthly AS
SELECT
  period_year,
  period_month,
  cost_center_id,
  COUNT(DISTINCT employee_id) as headcount,
  SUM(gross_income) as total_gross,
  SUM(sso_deduction) as total_sso,
  SUM(wht_deduction_round_1 + wht_deduction_round_2) as total_wht,
  SUM(net_pay) as total_net,
  AVG(ot_amount_total) as avg_ot
FROM payroll_details
JOIN employees USING(employee_id)
GROUP BY period_year, period_month, cost_center_id;

CREATE UNIQUE INDEX ON mv_payroll_monthly
  (period_year, period_month, cost_center_id);

-- Daily attendance summary
CREATE MATERIALIZED VIEW mv_attendance_daily AS
SELECT
  work_date,
  cost_center_id,
  COUNT(DISTINCT employee_id) FILTER(WHERE present) as present_count,
  COUNT(DISTINCT employee_id) FILTER(WHERE is_late) as late_count,
  AVG(actual_hours) as avg_hours,
  SUM(ot_hours) as total_ot
FROM attendance_summary_daily
GROUP BY work_date, cost_center_id;
```

---

## 9.10 Access Control (RLS)

```sql
-- Owner/Delegate — เห็นทุกอย่าง
CREATE POLICY dashboard_owner_all
ON ALL dashboard tables FOR SELECT
USING (current_user_role() IN ('owner', 'owner_delegate'));

-- Finance — Payroll + Tax + SSO only (🔒 Locked)
CREATE POLICY dashboard_finance
ON payroll_details, sso_records, wht_records FOR SELECT
USING (current_user_role() = 'finance');

-- Supervisor — Team only
CREATE POLICY dashboard_supervisor
ON attendance_logs, ot_requests, leave_requests FOR SELECT
USING (
  employee_id IN (
    SELECT id FROM employees
    WHERE cost_center_id IN (
      SELECT cost_center_id FROM supervisor_assignments
      WHERE supervisor_id = current_user_employee_id()
    )
  )
);

-- Staff — Own data only
CREATE POLICY dashboard_staff
ON * FOR SELECT
USING (employee_id = current_user_employee_id());
```

---

## 9.11 Alert System

### Trigger Conditions

**Critical:**
- `weekly_ot > 36` → notify Owner + HR + Supervisor + Employee (LINE urgent)
- `round_status != 'approved' AND time > day_15_12pm` → notify Owner + Finance
- `days_to_sso_filing <= 3` → notify Finance + HR

**Warning:**
- `weekly_ot >= 30` → notify Supervisor + Employee
- `monthly_corrections >= 2` → notify HR + Supervisor
- `leave_balance < 2 days` → notify Employee

**Info:**
- `schedule_published` → notify all affected employees
- `round_2_completed` → notify Employee (payslip ready)

### Delivery Channels

| Channel | Use |
|---------|-----|
| LINE Notify | Primary — all immediate |
| Dashboard | Always visible when logged in |
| Email | Critical + monthly digest only |
| LIFF Badge | Queue count indicator |

---

## 9.12 Mobile-First Considerations

**~80% ใช้ผ่าน mobile** — all views designed mobile-first

**Staff View:** Vertical cards | Large tap targets (44px+) | Action buttons bottom (thumb zone) | Swipe gestures

**Supervisor View:** Quick approval cards | Swipe to approve/reject | Critical info up top

**Owner View:** KPI tiles at-a-glance | Drill-down on tap | Monthly summaries prioritized

**Desktop Only:** Payroll processing | Bulk operations | Export/import | Detailed reports | Configuration | Advanced analytics

---

## 🔒 Locked Decisions Summary

| # | Decision |
|---|----------|
| Q1 | Daily Digest = 09:00 น. |
| Q2 | Dashboard refresh = Real-time Hybrid (Tier 1 Push delta, Tier 2 On-demand, Tier 3 Cached) — Supabase Realtime WebSocket |
| Q3 | Report retention = 2 ปี (align audit log) |
| Q4 | Finance access = Payroll + Tax + SSO only (principle of least privilege) |
| Q5 | Chart library = Recharts (align tech stack) |

---

## 🔗 Related Sections

- Section 6: Payroll (data source)
- Section 7: Attendance (data source)
- Section 8: Notification (alert delivery)
- Section 10: Audit Log (retention alignment)
- Section 11: PDPA (access control + RLS)

---

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked & Ready for Dev M1*
