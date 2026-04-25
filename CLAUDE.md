# CLAUDE.md

> Custom HRIS for บริษัท หมอยาสุรินทร์ จำกัด
> Built with Next.js + Supabase + LINE LIFF

**Last updated:** 25 เมษายน 2569

---

## Project Context

### Business

- **Company:** หมอยาสุรินทร์ (ID: 0325557000531)
- **Industry:** ร้านขายยา + ค้าส่งเวชภัณฑ์
- **Employees:** 32 total (29 payroll + 3 PC limited-access + 1 SSO-only สังวาลย์)
- **Owner:** อมร
- **Existing POS:** Bluenote (do NOT replace)

### Out of scope (NEVER)

- The Pizza Company, Dairy Queen (Minor Food)
- Signature Clinic
- Nap's Coffee Roaster

### Launch

- Go-Live: **1 ม.ค. 2570** (Technical cutover) / **2 ม.ค. 2570** (Operational)
- Dev start: May 2026 (M1)

---

## Tech Stack

- **Framework:** Next.js 15 (App Router only)
- **Language:** TypeScript 5.x strict (no `any`)
- **Runtime:** Node.js 20 LTS
- **Package manager:** pnpm
- **Styling:** Tailwind 4 + shadcn/ui
- **Forms:** React Hook Form + Zod
- **State:** React Query + Zustand
- **Database:** Supabase (Postgres 15 + RLS)
- **Auth:** Supabase Auth (LINE OAuth)
- **Edge Functions:** Supabase (Deno)
- **Font:** IBM Plex Sans Thai
- **Charts:** Recharts
- **Mobile:** LINE LIFF + LINE OA Basic
- **AI:** Claude API (Haiku)
- **Hosting:** Cloudflare Pages
- **Repo:** GitHub private — `morya-hr-mrd` (MRD) / `morya-hr` (code)
- **CI/CD:** GitHub Actions
- **Monitoring:** Sentry
- **Testing:** Vitest + Playwright (80% coverage)

---

## Coding Conventions

### TypeScript

- Strict mode ON, `noImplicitAny` ON
- NEVER use `any` — use `unknown` + type-guard
- Prefer `type` over `interface`
- Use Zod `z.infer<>` for form/API types

### React

- Functional components only
- Server Components by default
- `"use client"` only when needed
- Custom hooks: `use-*`

### File naming

- Files: `kebab-case.ts`
- Components: `PascalCase.tsx`
- Hooks: `use-kebab-case.ts`
- Tests: `*.test.ts` (co-located)

### Database (Supabase)

- **RLS on ALL tables — NO exceptions**
- Migrations: timestamped, never edit after commit
- Table names: snake_case plural
- Column names: snake_case
- Foreign keys: `{table}_id`
- Timestamps: `created_at`, `updated_at`
- Soft deletes: `deleted_at`

### Git

- Branch: `feat/` / `fix/` / `chore/`
- Commits: Conventional Commits
- PR: passing tests + typecheck + lint

---

## Domain Terminology

### People

- พนักงาน = employee
- หัวหน้างาน = supervisor
- เภสัชกร = pharmacist
- กรรมการ = director (NOT employee per SSO law)
- Product Consultant (PC) = attendance-tracked only (NOT in payroll)
- จำเนียร = แม่บ้านนอกระบบ (จ้างส่วนตัว — NO employee record in MYHR)

### Leave types (9 ประเภท — locked)

1. พักร้อน (6 วัน)
2. ป่วย (30 วัน)
3. กิจ (3 วัน)
4. คลอด (45+45 วัน)
5. บวช (15 วัน)
6. สมรส (3 วัน)
7. ฌาปนกิจ (5 วัน)
8. ทหาร/รับราชการ (ตามหมายเรียก, ม.35)
9. ฝึกอบรม/วิชาชีพ (30 วัน, ม.34)

### Payroll & Compliance

- ปกส. = SSO
- สปส.1-10 = SSO filing (due วันที่ 15)
- ภ.ง.ด.1 = monthly WHT (due วันที่ 7 เดือนถัดไป)
- ภ.ง.ด.1ก = annual WHT
- 50 ทวิ = tax withholding certificate
- ค่าคอมมิชชัน = commission (always 40(1), NEVER 50 ทวิ)

---

## Organization

### Headcount (Source of Truth)

```
Total in system:        32 คน
Payroll run:            29 คน (3 Directors + 5 Sup + 20 Staff)
Attendance tracking:    28 คน (5 Sup + 20 Staff + 3 PC)
LIFF access:            29 คน (ไม่รวม สังวาลย์ + PC limited)
SSO contribution:       27 คน (Payroll 29 - เฮีย - ไนซ์)
```

### Cost Centers (8 total)

**Main (3):** CC-HQ-WS, CC-01, CC-04
**Support (5):** CC-SUPPORT-HR, -FIN, -IT, -WH, -FAC

> CC-SUPPORT-FAC: 0 คน ปัจจุบัน (จำเนียรออก) — CC ยังคงอยู่เผื่ออนาคต

### User Roles (6)

```typescript
type UserRole =
  | 'owner'           // อมร
  | 'owner_delegate'  // ไนซ์ + จิว
  | 'hr_admin'        // การ์ตูน
  | 'finance'         // นา + Finance Assistants
  | 'it_support'      // บอส
  | 'supervisor'      // 5 คน
  | 'staff'           // 20 คน
```

> PC01-03: role `pc_staff` (limited — attendance only, no payroll/leave/OT)

### Current Supervisors (5)

- **MY04 ติ๋ง** — Supervisor WH (5 staff)
- **MY05 เมล์** — Co-Supervisor CC-HQ-WS (with เดือน)
- **MY11 จอย** — Supervisor + เภสัชกร CC-04
- **MY14 ค๊อป** — Supervisor + เภสัชกร CC-01 (คุม PC01-03)
- **MY23 เดือน** — Co-Supervisor CC-HQ-WS (with เมล์)

### Pharmacist Licenses

- **HQ (Server 00 + 01):** MY14 ค๊อป — 1 ใบ
- **สาขา 04:** MY11 จอย — 1 ใบ
- ⚠️ 2 คน ไม่มี backup → ต้อง contingency plan

---

## Business Rules (Critical)

### Employment Status

```typescript
type EmploymentStatus =
  | 'active'
  | 'active_no_payroll'   // สังวาลย์ — SSO only
  | 'probation'           // 119 วัน
  | 'on_leave'
  | 'resigned'
  | 'terminated';
```

### Compensation Type

```typescript
type CompensationType =
  | 'regular_salary'      // 40(1), มี SSO
  | 'director_salary';    // 40(1), ไม่มี SSO
```

### Directors (Attendance + SSO Exempt)

- อมร (Owner) — 20,000/เดือน — ไม่อยู่ใน Humansoft → manual add ตอน M1
- ไนซ์ (Owner Delegate) — 20,000/เดือน — ไม่อยู่ใน Humansoft → manual add ตอน M1
- จิว (CEO02, Owner Delegate) — 30,000/เดือน, SSO 750 — มีใน Humansoft (salary=0 → set 30,000)

### WHT Rules (🔒 Pure Auto — Section 6.5)

- คำนวณอัตโนมัติทุกคนทุกเดือน — NO toggle, NO opt-out
- ตาม ม.50(1), ม.52, ม.54 — เป็น Duty ไม่ใช่ Right

### Shift Rules

- 9 hr/วัน × 6 วัน/สัปดาห์ (rotation)
- GPS: **100m fixed** ทุก location
- Grace period: **0 นาที** (strict)
- Partial shift (Hybrid B2+B3): ≥6hr = full | 3-6hr = half | <3hr = full

### OT Rules

- Weekday: 1.5x
- Holiday substitute: 1.0x + token
- Holiday changed: 2.0x + consent
- OT in holiday changed: 3.0x
- **Hard cap: 36 hr/สัปดาห์**
- **Pharmacist OT: 150 บาท/ชม. (fix) — 🔒 D17 Owner accepts legal risk**
- Request window: **72 ชม.** หลังทำงาน

### Diligence Bonus (เบี้ยขยัน 600 บาท/เดือน)

ตัดเต็มถ้าเข้าข้อใดข้อหนึ่ง:
- ❌ ลาป่วย ≥ 1 ครั้ง/เดือน (ไม่ว่ากี่วัน ไม่ว่ามีใบหรือไม่) — 🔒 C-03 Option A
- ❌ สาย + ลืม check-in/out + correction **รวมกัน** ≥ 3 ครั้ง/เดือน — 🔒 C-04
- ❌ ลากิจ/ลาพักร้อนไม่แจ้งล่วงหน้า

### Correction Window (🔒 C-06)

- 0–24 ชม.: self-correct (Supervisor approve)
- 25–72 ชม.: correction request flow (Sup → HR)
- > 72 ชม.: HR manual + Owner approve

### Holiday (Model B1)

- 13 วัน/ปี, use-or-lose 31 ธ.ค.
- Legal risk ม.29 accepted
- ข้อบังคับต้อง update ก่อน go-live

### Leave Approval Workflow

| Days | Approvers |
|------|-----------|
| ≤3 | Supervisor only |
| 4–7 | Supervisor + HR |
| 8+ | Supervisor + HR + Owner |
| OT | Supervisor only |

- Auto-escalation 4 ชม. → HR Admin
- Quiet hours SLA pause: **22:00–08:00**

### Co-Supervisor Model

- เมล์ + เดือน ใน CC-HQ-WS (equal authority)
- ใคร approve ก่อน = final
- Audit log บันทึกชื่อคน approve

### Payroll Schedule (Two-stage)

```
วันที่ 28-สิ้นเดือน: Finance คำนวณ + ตั้งโอน Round 1
วันที่ 1:            Round 1 เข้าบัญชี (auto)
วันที่ 1-7:          Owner approve grace period
วันที่ 1-14:         Prep Round 2 (OT + commission + เบี้ยขยัน)
วันที่ 15:           ยื่น สปส.1-10 + ตั้งโอน Round 2
วันที่ 16:           Round 2 เข้าบัญชี + payslips
```

### Commission

- ALWAYS 40(1)
- **NEVER 50 ทวิ** (illegal)
- คำนวณรายเดือน จ่ายกับ Round 2 เท่านั้น
- ✅ ได้ commission ระหว่าง probation

---

## Notification System

- **Channel:** LINE OA "หมอยาสุรินทร์ HR"
- **Plan:** Basic (16,435 THB/ปี)
- **Quota:** 15,000 msg/เดือน

### Quiet Hours

- **22:00–08:00** (Thailand)
- Critical events override

### Delivery

- Instant push: critical events
- **Daily digest 09:00:** supervisors — 🔒 C-12
- Reply API: commands (/leave, /payslip, /ot, /quota, /help)
- LIFF center: reference data

---

## Report Retention (🔒 C-14)

| Report Type | Retention |
|-------------|-----------|
| General (attendance, leave, OT) | 2 ปี |
| Payroll reports | ≥ 7 ปี (กฎหมายภาษี) |
| Payroll records (ม.115) | ≥ 10 ปี |
| Tax reports (ภ.ง.ด., สปส., 50 ทวิ) | ≥ 5–10 ปี |

---

## Security & Privacy

### Auth

- Supabase Auth (LINE OAuth)
- Session: 12 hr
- LIFF: LINE login auto

### RBAC

- 6 roles + 1 limited (pc_staff) via `profiles.role`
- Enforce via Supabase RLS

### PDPA

- Consent tracking (Umbrella form — granular checkboxes)
- Privacy policy versioned
- DSR workflow in LIFF
- Disclose: Supabase US/EU, LINE Japan, Cloudflare Global
- **ห้าม send PII ไปยัง Anthropic Claude API**

### Audit Log

- Level 1: all actions (1 ปี retention)
- Level 2: sensitive before/after (2 ปี retention)
- Quiet hours SLA: 22:00–08:00
- Emergency Unlock reason: min 100 chars
- Owner Delegate logged separately

### NEVER expose

- service_role key
- plaintext passwords
- .env files
- PII ใน Claude API calls

---

## What NOT to Do

### Code

- ❌ `any` type
- ❌ Skip RLS
- ❌ Commit secrets
- ❌ Client-side storage for sensitive data
- ❌ Push without tests
- ❌ Modify existing migrations
- ❌ Inline styles
- ❌ `window`/`document` in Server Components

### Business

- ❌ 50 ทวิ for commission
- ❌ OT > 36 hr/สัปดาห์
- ❌ Grace period check-in
- ❌ Auto-approve leave/OT
- ❌ Bypass quiet hours (non-critical)
- ❌ Delete employee records (soft only)
- ❌ SSO for director_salary
- ❌ Check-in for director/delegate
- ❌ Create employee record สำหรับจำเนียร (จ้างนอกระบบ)
- ❌ Toggle WHT off (Pure Auto mode)

### Process

- ❌ Architectural decisions โดยไม่ถาม
- ❌ เปลี่ยน business rules ไม่ update MRD
- ❌ Add dependencies ไม่มีเหตุผล
- ❌ Create DB tables ไม่ review schema

---

## When in Doubt — ASK

**ASK before:**

- Architectural decisions
- Business rules changes
- New npm dependencies
- New DB tables / schema changes
- RLS policies
- Notification triggers
- New user roles
- Headcount changes

**Proceed without asking:**

- Bug fixes (reported)
- Typo corrections
- Adding tests
- Styling improvements
- Documentation
- Refactoring (no behavior change)

---

## Commands

```bash
pnpm dev                  # dev server
pnpm build                # production
pnpm typecheck            # TS check
pnpm lint                 # ESLint + Prettier
pnpm test                 # Vitest
pnpm test:e2e             # Playwright
pnpm db:migrate           # apply migrations
pnpm db:types             # generate types
```

---

## Resources

- Notion MRD: https://www.notion.so/34b9e022ec808162b0c7d1d6cea9363e
- Employee Master (Source of Truth): https://www.notion.so/34c9e022ec808133ad97cf1b95bb780c
- GitHub MRD: `ezkudo23/morya-hr-mrd` (private)
- GitHub Code: `morya-hr` (private — TBD M1)
- Supabase: TBD (M1)
- Cloudflare: TBD (M1)

---

**Maintained by:** อมร + Claude (pair programming)
