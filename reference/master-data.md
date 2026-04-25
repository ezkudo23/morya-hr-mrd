# Master Data Reference (Source of Truth)

> **Notion ref**: https://www.notion.so/34c9e022ec808133ad97cf1b95bb780c
> **Status**: ✅ Locked — 25 เม.ย. 2569
> **Purpose**: Cross-section reference สำหรับ headcount, payroll logic, timeline

---

## 🏢 Company Information

| Field | Value |
|---|---|
| ชื่อบริษัท | บริษัท หมอยาสุรินทร์ จำกัด |
| เลขประจำตัวผู้เสียภาษี | 0325557000531 |
| ก่อตั้ง | 2563 |
| Domain | morya.co.th |

---

## 👥 Official Headcount: 33 คน — D1

### Director / Delegate (3 คน)

| Code | Nickname | Full Name | Salary | Notes |
|---|---|---|---|---|
| — | เฮีย | อมร | 20,000 | Owner |
| — | ไนซ์ | (ภรรยาเฮีย) | 20,000 | Delegate 1 |
| CEO02 | จิว | (น้องชายเฮีย) | 30,000 | Delegate 2 / Executive |

### Supervisors (5 คน)

| Code | Nickname | Full Name | Salary | Department |
|---|---|---|---|---|
| MY04 | ติ๋ง | นภาทิพย์ พรหมสนิท | 12,444 | Supervisor (CC-HQ-WS) |
| MY05 | เมล์ | ภัทราภรณ์ ปัสสาวะกัง | 10,820 | Co-Sup CC-HQ-WS + Sale Admin Ext |
| MY11 | จอย | (แพทย์ฯ) | 34,000 | Supervisor + เภสัชกร CC-04 |
| MY14 | ค๊อบ | กษิดิศ สงึมรัมย์ | 31,000 | Supervisor + เภสัชกร CC-01 |
| MY23 | เดือน | ดวงหทัย ปวนใต้ | 16,200 | Co-Sup CC-HQ-WS + Sale Admin Ext |

### Staff (20 คน)

| Code | Nickname | Salary | Department |
|---|---|---|---|
| MY01 | นัด | 10,530 | Staff CC-04 |
| MY02 | ก้อย | 10,530 | Finance Assistant (HQ) |
| MY03 | (ปิง) | 10,530 | Staff CC-01 |
| MY06 | น็อต | 10,600 | Staff CC-04 |
| MY07 | การ์ตูน | 12,500 | HR Admin (primary) (HQ) |
| MY08 | อุ้ม | 10,530 | Staff CC-01 |
| MY09 | (พิ้ง) | 10,530 | Staff CC-01 |
| MY10 | เยียร์ | 10,530 | Staff (CC-HQ-WS) + Sale Admin Ext |
| MY12 | (ตอม) | 10,530 | Staff CC-04 |
| MY13 | (นัด) | 10,530 | Staff CC-04 |
| MY15 | ปิง | 10,530 | Staff CC-01 |
| MY16 | นา | 14,484 | **Finance** (only one — D4) |
| MY17 | (พลอย) | 10,530 | Staff CC-04 |
| MY18 | (ตอม) | 10,530 | Staff CC-04 |
| MY19-22 | ... | 10,530 | Staff |
| MY24 | แอ๊ด | 14,280 | Staff (CC-HQ-WS) |
| MY25 | บอส | 14,280 | **IT** (D1) |
| MY26 | หน่อย | 10,530 | Staff CC-04 |

### Other (5 คน)

| Code | Nickname | Salary | Type | Notes |
|---|---|---|---|---|
| — | จำเนียร | ~9,000 | Facility | ไม่อยู่ใน Humansoft, รวมใน MYHR M1 |
| — | สังวาลย์ | — | SSO-only | active_no_payroll, contribution 8,000/month |
| PC01 | ชมพู่ | คอม | PC (NBD) | คอมล้วน, no payroll, time attendance only |
| PC02 | ต่าย | คอม | PC (Blackmores) | Same |
| PC03 | พลอย | คอม | PC (Wellgate) | Same |

### Counting Metrics

| Metric | Count | Excludes |
|---|---|---|
| **Payroll run** | 30 | สังวาลย์ (SSO-only) + 3 PC (commission only) |
| **Attendance tracking** | 29 | 3 Director (exempt) + สังวาลย์ |
| **LIFF Access** | 30 | สังวาลย์ + 3 PC (limited) |
| **Total** | 33 | — |

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
| HQ-00 | สำนักงานใหญ่ ขายส่ง (Wholesale) | 00 | B2B + B2C |
| HQ-01 | สำนักงานใหญ่ ขายปลีก (Retail) | 01 | Pharmacy |
| CC-04 | สาขา 4 | 04 | Pharmacy |

### Branch Hours
- **HQ-00 (ขายส่ง):** จันทร์-อาทิตย์ 08:30-17:30 (ปิด 17:30)
- **HQ-01 (ขายปลีก):**
  - จันทร์-เสาร์: 2 กะ overlap (08:30-17:30 + 10:00-19:00)
  - อาทิตย์: 1 กะ (08:30-17:30)
- **CC-04:** ทุกวัน, 2 กะ overlap (09:00-18:00 + 12:00-21:00)

---

## 💰 Payroll Calculation Logic — D9, D10

### Core Principles
```
1. ทำงานก่อน จ่ายทีหลัง
   วันที่ 1 เดือนไหน = จ่ายเงินของเดือนที่ผ่านมา

2. ทศนิยม 2 ตำแหน่ง
   Internal: DECIMAL(10, 2)
   Payslip: 2 ตำแหน่ง

3. ปัดคณิตศาสตร์
   ≥0.5 ปัดขึ้น
   <0.5 ปัดลง
```

### Hybrid Salary Logic
```
สถานการณ์                         วิธีคำนวณ
─────────────────────────────  ─────────────────────────
พนักงานใหม่ (เดือนแรก)          Days Worked:
ลาออก (เดือนสุดท้าย)               salary = base × (worked_days / 30)
พนักงานเก่า (ทำงานครบเดือน)     salary เต็ม = base
พนักงานเก่า (LWP/ขาดงาน)        Days Absent:
                                  deduction = base × (absent_days / 30)
                                  salary = base - deduction
```

### SSO Formula
```
base = max(1,650, min(salary_actual, 15,000))
sso  = round(base × 5%, 2)

Cases:
├── salary_actual ≤ 1,650  → SSO = 82.50
├── 1,650 < salary < 15,000  → SSO = salary × 5%
└── salary_actual ≥ 15,000  → SSO = 750.00 (cap)
```

### Net Pay Formula
```
Net Round 1 = salary_actual - sso - wht_round_1

Net Round 2 = commission + ot + diligence_bonus
            + other_income
            + adjustments (± จาก Round 1 error)
            - lwp_late_discovered
            - wht_round_2 (ถ้าเปลี่ยน bracket)
```

### Onboarding / Offboarding Cut-off
```
Cut-off: วันที่ 28 ของเดือน (Finance ตั้งโอนล่วงหน้า)

พนักงานใหม่:
├── เริ่ม ≤ วันที่ 28 → เข้า Round 1 เดือนถัดไป (prorated)
└── เริ่ม > วันที่ 28 → รอ Round 1 อีกเดือน (skip 1 เดือน)

พนักงานลาออก:
├── แจ้งล่วงหน้า 30 วัน → HR รู้แน่นอน
└── Round 2 เดือนสุดท้าย = จ่าย commission ที่ค้าง
```

### LWP Handling
```
LWP รู้ก่อน cut-off 28:
→ หัก Round 1 เลย (Days Absent formula)

LWP รู้หลัง cut-off 28:
→ Round 1 จ่ายเต็ม
→ Round 2 adjustment: -(base × days/30)
```

### Test Cases Validated

| # | Scenario | Base | Days | Result |
|---|---|---|---|---|
| 1 | ปกติเต็มเดือน | 10,530 | 30/30 | 10,003.50 |
| 2 | เริ่ม 3 มี.ค. | 15,000 | 29/30 | 13,775.00 |
| 3 | เริ่ม 28 มี.ค. (SSO ฐานต่ำสุด) | 10,530 | 4/30 | 1,321.50 |
| 4 | เริ่ม 15 ก.พ. | 10,530 | 14/30 | 4,668.30 |
| 5 | SSO cap | 34,000 | 30/30 | 33,250.00 |
| 6 | ลาออก 15 เม.ย. | 10,600 | 15/30 | 5,035.00 |
| 7 | LWP 3 วัน | 10,530 | -3 | 9,003.15 |
| 11 | LWP 1 วัน ก.พ. (Days Absent) | 10,530 | -1 | 9,670.05 |

⚠️ **เคส 3 — ถ้าเงินเดือน prorated < 1,650 → SSO ใช้ฐาน 1,650 ตาม ปกส. ม.47**

---

## 📅 Payroll Timeline (Locked) — D7, D8

### Round 1 (Salary Base)
```
วันที่ 28-สิ้นเดือน (2-3 วันก่อนสิ้นเดือน):
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
└── เงิน Round 2 เข้าบัญชี auto + payslips
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

## 📞 Stakeholders Quick Reference

| Role | Name | Code | Contact |
|---|---|---|---|
| Owner / DPO | เฮีย (อมร) | — | — |
| Owner Delegate 1 | ไนซ์ | — | — |
| Owner Delegate 2 / CEO | จิว | CEO02 | — |
| HR Sponsor | จอย (เภสัชกร CC-04) | MY11 | — |
| Finance | นา | MY16 | — |
| HR Admin (primary) | การ์ตูน | MY07 | — |
| IT | บอส | MY25 | — |
| Pharmacist 1 | ค๊อบ (CC-01) | MY14 | — |
| Pharmacist 2 | จอย (CC-04) | MY11 | — |
| External | ทนายแรงงาน | TBD | — |

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
- Legal consult: 5,000-10,000
- Security audit (optional): 5,000

### Comparison
- Humansoft: 51,253/ปี
- MYHR Year 1: ~40,000
- MYHR Year 2+: 29,705
- **Saving: ~21,548/ปี (~107,740 ใน 5 ปี)**
