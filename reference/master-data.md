# Master Data Reference (Source of Truth)

> **Notion ref**: https://www.notion.so/34c9e022ec808133ad97cf1b95bb780c
> **Status**: ✅ Updated — 1 พ.ค. 2569
> **Purpose**: Cross-section reference สำหรับ headcount, payroll logic, timeline

---

## 🏢 Company Information (🔴 อัปเดต 1 พ.ค. 2569)

| Field | Value |
|---|---|
| ชื่อบริษัท | บริษัท หมอยาสุรินทร์ จำกัด (สำนักงานใหญ่) |
| เลขประจำตัวผู้เสียภาษี | 0325557000531 |
| ที่อยู่ | 30,32 ถนนกรุงศรีใน ตำบลในเมือง อำเภอเมืองสุรินทร์ จังหวัดสุรินทร์ 32000 |
| เบอร์โทรศัพท์ | 0800891000 |
| ก่อตั้ง | 21 ตุลาคม 2557 |
| Domain | morya.co.th |
| MYHR Production | https://moryahr.com |

> ข้อมูลบริษัท seed ลง `system_config` category=`'company'` แล้ว — ดึงอัตโนมัติใน Payslip

---

## 👥 Official Headcount: 32 คน — D1

### Director / Delegate (3 คน)

| Code | Nickname | ชื่อ-นามสกุล | Salary | Hire Date | Notes |
|---|---|---|---|---|---|
| MR-001 | เฮีย | นายอมร เกียรติคุณรัตน์ | 20,000 | 21/10/2557 | Owner |
| MR-002 | ไนซ์ | ณภิญา — | 20,000 | 21/10/2557 | Delegate 1 |
| CEO02 | จิว | ศศิ — | 30,000 | — | Delegate 2 / Executive |

**Bank Account (อัปเดต 1 พ.ค. 2569):**
- เฮีย: ธนาคารกสิกรไทย เลขที่ 702-2-77877-8

### Supervisors (5 คน)

| Code | Nickname | Full Name | Salary | Department |
|---|---|---|---|---|
| MY04 | ติ๋ง | ศิริรัตน์ ผิวขาว | 12,444 | Supervisor CC-SUPPORT-WH |
| MY05 | เมล์ | ภัทราภรณ์ ปัสสาวะกัง | 10,820 | Co-Sup CC-HQ-WS + Sale Admin Ext |
| MY11 | จอย | ศิราพร สิทธิรัมย์ | 34,000 | Supervisor + เภสัชกร CC-04 |
| MY14 | ค๊อป | กษิดิศ สงึมรัมย์ | 31,000 | Supervisor + เภสัชกร CC-01 |
| MY23 | เดือน | ดวงหทัย ปวนใต้ | 16,200 | Co-Sup CC-HQ-WS + Sale Admin Ext |

### Counting Metrics (🔒 D1)

| Metric | Count | Excludes |
|---|---|---|
| **Total in system** | 32 | — |
| **Payroll run** | 29 | สังวาลย์ (SSO-only) + 3 PC |
| **Attendance tracking** | 28 | 3 Director (exempt) + สังวาลย์ |
| **LIFF Access** | 29 | สังวาลย์ + 3 PC (limited) |
| **SSO contribution** | 27 | เฮีย + ไนซ์ (Director exempt) |

> หมายเหตุ: จำเนียร (แม่บ้าน) = จ้างนอกระบบ ไม่มี employee record ใน MYHR

### Role Corrections (from Humansoft errors)

| Code | Old (Wrong) | New (Correct) |
|---|---|---|
| MY02 ก้อย | Warehouse Sup | Finance Assistant |
| MY07 การ์ตูน | Accounting | HR Admin (primary) |
| MY25 บอส | Warehouse | IT |
| MY04 ติ๋ง | Staff | Supervisor |
| MY16 นา | ~~Finance Lead~~ | **Finance** (only Finance person — D4) |

---

## 🏪 Cost Centers (Branches)

| Code | Name | Server | Type |
|---|---|---|---|
| CC-MGT | Management | — | Director/Delegate |
| HQ-00 | สำนักงานใหญ่ ขายส่ง (Wholesale) | 00 | B2B + B2C |
| HQ-01 | สำนักงานใหญ่ ขายปลีก (Retail) | 01 | Pharmacy |
| CC-04 | สาขา 4 | 04 | Pharmacy |
| CC-SUPPORT-* | Support teams | — | HR, Finance, IT, WH |

### GPS Coordinates (✅ Confirmed 26 เม.ย. 2569)

| Code | Location | Latitude | Longitude |
|---|---|---|---|
| HQ-00 | สำนักงานใหญ่ ขายส่ง | 14.886239 | 103.492307 |
| HQ-01 | สำนักงานใหญ่ ขายปลีก | 14.8864189 | 103.4919395 |
| CC-04 | สาขา 4 | 14.8732376 | 103.5060382 |

---

## 📅 Payroll Timeline (Locked) — D7, D8

### Round 1 (Salary Base)
```
วันที่ 28-สิ้นเดือน:
├── Finance pre-check (corrections, OT pending, attendance)
├── Finance คำนวณ Round 1 ตาม salary base + SSO
├── ตั้งโอนล่วงหน้า (scheduled transfer)
└── Owner approve (ถ้าว่าง)
วันที่ 1 เดือนถัดไป:
└── เงิน Round 1 เข้าบัญชี auto
วันที่ 1-7 (grace period):
└── Owner approve ได้ภายหลัง
(ถ้ามี error → adjust ใน Round 2)
```

### Round 2 (Commission + Variable)
```
วันที่ 1-14 (เดือนถัดไป):
├── Finance (นา) ดึง commission จาก Bluenote
├── Verify + คำนวณ OT + เบี้ยขยัน
└── รวม adjustment จาก Round 1 (ถ้ามี)
วันที่ 15:
├── Deadline ตั้งโอน
└── ยื่น สปส.1-10 online
วันที่ 16:
└── เงิน Round 2 เข้าบัญชี auto + Payslips ออก
```

---

## 💰 Payroll Calculation Rules

### Hybrid Salary Logic (🔒 D9)

```
IF new hire (เดือนแรก) OR resign (เดือนสุดท้าย):
  salary = base × (worked_days / 30)
ELSE:
  deduction = base × (absent_days / 30)
  salary = base - deduction

หารด้วย 30 fixed เสมอ
```

### SSO Formula (🔒 D10)

```
base = max(1,650, min(salary_actual, 15,000))
sso  = round(base × 5%, 2)
floor = 82.50 | cap = 750.00
SSO exempt: เฮีย + ไนซ์
```

### Diligence Bonus

```
Amount: 600 บาท/เดือน (DB-driven: system_config.diligence_amount)
ตัดถ้า: ลาป่วย ≥1 ครั้ง | สาย+ลืม+correction รวม ≥3 | ลากิจ/พักร้อนไม่แจ้งล่วงหน้า
```

### OT Rates

```
normal  (วันทำงาน) → 1.5x
holiday (วันหยุด)  → 3.0x
เภสัชกร (ค๊อป, จอย) → Fix 150 บาท/ชม. ไม่ว่า type ใด (🔒 D17)
```

---

## 🔧 Tech Stack — D3

| Layer | Technology |
|---|---|
| Frontend | Next.js 15 + TypeScript strict + Tailwind 4 + shadcn/ui |
| Forms | React Hook Form + Zod |
| Database | Supabase Pro (Postgres + RLS + Auth) |
| Authentication | LINE Login (OAuth 2.0) |
| Mobile UI | LINE LIFF |
| Hosting | Cloudflare Pages |
| Repo | GitHub: `morya-hr` (code), `morya-hr-mrd` (this) |
| Error tracking | Sentry |
| PDF generation | Puppeteer |
| Excel export | exceljs |
| Font (Thai) | IBM Plex Sans Thai |
| Testing | Vitest (unit) + Playwright (e2e) |
| AI Assistant | Claude API Haiku |
| Charts | Recharts |
| Package manager | pnpm |

---

## 📊 Budget Summary

### Annual Operating Cost

| Item | Amount |
|---|---|
| Supabase Pro | 10,800 |
| LINE OA Basic | 16,435 |
| Domain | 70 |
| Claude API Haiku | 2,400 |
| Cloudflare/GitHub/Sentry | 0 |
| **Total** | **29,705 บาท/ปี** |

### One-time

- Legal consult: 5,000–10,000
- Security audit (optional): 5,000

### Comparison

- Humansoft: 51,253/ปี
- MYHR Year 1: ~40,000
- MYHR Year 2+: 29,705
- **Saving: ~21,548/ปี (~107,740 ใน 5 ปี)**

---

## 📞 Stakeholders Quick Reference

| Role | Name | Code |
|---|---|---|
| Owner / DPO | เฮีย (อมร เกียรติคุณรัตน์) | MR-001 |
| Delegate 1 | ไนซ์ | MR-002 |
| Delegate 2 / CEO | จิว | CEO02 |
| HR Sponsor | จอย (เภสัชกร CC-04) | MY11 |
| Finance | นา | MY16 |
| HR Admin (primary) | การ์ตูน | MY07 |
| IT | บอส | MY25 |
| Pharmacist 1 | ค๊อป (CC-01) | MY14 |
| Pharmacist 2 | จอย (CC-04) | MY11 |
| Legal (แรงงาน) | ทนายแรงงานสุรินทร์ | TBD |

---

## 🗃️ DB Schema Summary (อัปเดต 1 พ.ค. 2569)

### Tables

| Table | หน้าที่ |
|---|---|
| employees | 32 คน (รวม PC + สังวาลย์) |
| cost_centers | สาขา + support teams |
| profiles | LINE auth + role |
| shifts / employee_shifts | กะทำงาน |
| attendance_logs | GPS check-in/out |
| leave_requests | คำขอลา + `approver_role_sequence` |
| leave_balances | โควต้าลาปีนั้น |
| ot_requests | คำขอ OT |
| substitute_tokens | Token วันหยุด |
| correction_requests | แก้เวลาทำงาน |
| holiday_calendar | วันหยุดนักขัตฤกษ์ + วันหยุดร้าน |
| payroll_runs | Round 1/2 per month |
| payroll_details | คำนวณรายบุคคล + `payslip_note` |
| **payroll_deductions** | **รายการหักพิเศษ (ใหม่ 1 พ.ค. 2569)** |
| wht_declarations | ลดหย่อนภาษีรายปี |
| system_config | ทุก config DB-driven |
| audit_logs | Immutable audit trail |
| notifications_log | ประวัติการแจ้งเตือน |
| consent_records | PDPA consent |
| dsr_requests | PDPA data subject request |
| employee_diligence_counters | นับ สาย/ลืม/correction |

### RPC Functions

| Function | หน้าที่ |
|---|---|
| `get_employee_by_line_id` | AUTH: หา employee จาก LINE ID |
| `get_profile_by_employee_id` | หา profile |
| `get_employee_by_id` | หา employee |
| `increment_diligence_counter` | นับ counter เบี้ยขยัน |
| `submit_leave_request` v2 | ยื่นลา + คำนวณ approver_role_sequence |
| `approve_leave_request` v2 | อนุมัติ/ปฏิเสธลา (อ่านจาก sequence) |
| `get_leave_balance` | โควต้าลาคงเหลือ |
| `get_pending_leaves` | รายการรออนุมัติ |
| `submit_ot_request` | ยื่น OT |
| `approve_ot_request` | อนุมัติ/ปฏิเสธ OT |
| `get_ot_requests` | ประวัติ OT |
| `calculate_payroll` | คำนวณ payroll |
| `run_payroll` | run payroll จริง |
| `get_payroll_summary` | สรุป payroll (Finance/Owner) |
| `get_payslip` | ดู payslip รายบุคคล (ใหม่ 1 พ.ค. 2569) |

### system_config Categories

| Category | Keys |
|---|---|
| `company` | name, address, tax_id, tel |
| `payslip` | authorized_signer_name, authorized_signer_position |
| `payroll` | round1_cutoff_day, round1_grace_end_day, round2_commission_end_day, salary_divisor, sso_rate_percent, sso_min_base, sso_max_base |
| `leave` | annual_entitled_days, sick_entitled_days, personal_entitled_days, sick_doc_required_days, sick_approval_short_days, annual_approval_single_day, ... |
| `attendance` | gps_radius_meters, ... |
| `ot` | max_monthly_hours, min_ot_minutes, window_hours |
| `deduction` | student_loan, court_order, union_fee, advance, other |
| `notification` | daily_digest_time, quiet_hours_start/end, approval_sla_hours |

---

## Change Log

### 1 พ.ค. 2569
- ✅ เพิ่มข้อมูลบริษัท: ที่อยู่, TAX ID, เบอร์โทร, MYHR URL
- ✅ เพิ่ม bank account เฮีย: ธ.กสิกรไทย 702-2-77877-8
- ✅ เพิ่ม `payroll_deductions` table ใน DB Schema Summary
- ✅ เพิ่ม `get_payslip` RPC ใน RPC list
- ✅ เพิ่ม `payslip_note` column ใน `payroll_details`
- ✅ เพิ่ม system_config categories: `company`, `payslip`, `deduction`
- ✅ เพิ่ม `leave_requests.approver_role_sequence` ใน table list

### 26 เม.ย. 2569
- ✅ Hire dates confirmed: เฮีย + ไนซ์ + เดือน = 21/10/2557 (วันก่อตั้งบริษัท)
- ✅ Hire date สังวาลย์ = 01/01/2562
- ✅ GPS coordinates confirmed (HQ-00, HQ-01, CC-04)
- ✅ D17 Legal Reviewed — Owner confirms risk accepted

### 25 เม.ย. 2569
- ❌ จำเนียร เชิดกลิ่น ออกจากระบบ (จ้างนอกระบบ)
- ✅ Total: 33 → 32 | Payroll: 30 → 29 | Attendance: 29 → 28
- ✅ C-03 Locked: ลาป่วย ≥1 ครั้ง = ตัดเบี้ยขยัน (Option A)

---

*Last updated: 1 พ.ค. 2569 | เพิ่มข้อมูลบริษัท, bank account เฮีย, payroll_deductions, get_payslip, system_config categories ใหม่*
