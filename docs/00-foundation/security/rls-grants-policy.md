# RLS & Grants Policy Reference

> **Single source of truth** สำหรับ database access control ของ MYHR

**Last Updated:** 2 พ.ค. 2569  
**Status:** ✅ Active (Comprehensive Audit Migration applied + profiles recursion fix)  
**Owner:** Conner (Claude) + อมร

---

## 📋 Table of Contents

1. [Purpose](#purpose)
2. [Architecture](#architecture)
3. [5 Buckets Overview](#5-buckets-overview)
4. [Table Assignments](#table-assignments)
5. [Helper Functions](#helper-functions)
6. [Standard Patterns](#standard-patterns)
7. [⚠️ Critical: Profiles Recursion](#critical-profiles-recursion)
8. [Decision Log](#decision-log)
9. [Maintenance Rules](#maintenance-rules)

---

## Purpose

PostgreSQL/Supabase ใช้ 2 layers เพื่อควบคุม database access:

```
┌─────────────────────────────────────┐
│ Layer 1: Table Grants               │
│ ─────────────────────                │
│ "ใครเปิดประตูได้บ้าง"                  │
│ • GRANT SELECT/INSERT/UPDATE/DELETE  │
│ • Per role (anon, authenticated, ...)│
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│ Layer 2: RLS Policies               │
│ ─────────────────                    │
│ "เปิดประตูแล้วเห็น/ทำอะไรได้"          │
│ • Row-level filter                   │
│ • USING (read) / WITH CHECK (write)  │
└─────────────────────────────────────┘
```

**Both must allow** = user can access the data.  
ทั้งสองชั้นต้อง pass พร้อมกัน — ไม่ใช่ OR

ปัญหาที่เจอใน production (ก่อน audit นี้):
- มี RLS policies ครบ (ดี) แต่ table grants ไม่เปิด → user query ไม่ได้
- ใช้ `auth.uid()` ที่จุดต่าง ๆ — บางจุดถูก บางจุดผิด
- Pattern ในแต่ละ table ไม่ consistent → maintenance ยาก
- **profiles policies ใช้ inline subquery → infinite recursion** (เจอตอน apply migration)

→ Migration นี้แก้ปัญหาทั้งหมด — standardize ให้เหมือนกันทุก table

---

## Architecture

### Single Helper Function Layer

ทุก policy ใช้ helper functions ใน `public` schema:

| Function | Returns | Purpose |
|---|---|---|
| `current_employee_id()` | UUID | employee_id ของ user ที่ login (ผ่าน profiles) |
| `current_user_role()` | TEXT | role ของ user (จาก profiles, ไม่ใช่ JWT) |
| `is_admin()` | BOOLEAN | role ∈ owner/owner_delegate/hr_admin |
| `is_supervisor()` | BOOLEAN | role = supervisor |
| `is_finance_or_admin()` | BOOLEAN | role ∈ owner/delegate/hr_admin/finance |
| `supervises_employee(uuid)` | BOOLEAN | logged-in user เป็น supervisor ของ target ไหม |
| `is_admin_or_it()` | BOOLEAN | สำหรับ profiles read — owner/delegate/hr_admin/it_support |
| `can_write_profile()` | BOOLEAN | สำหรับ profiles write — owner/delegate/it_support |

**Why functions?**
1. **Consistency** — เปลี่ยน 1 ที่ มีผลทุก policy
2. **Performance** — `STABLE` + cached per-query
3. **Readability** — `is_admin()` ดีกว่า `(auth.jwt() ->> 'role')::text IN ('owner','owner_delegate','hr_admin')`
4. **Source of truth** — `profiles.role` แทน JWT (JWT อาจ stale)
5. **No recursion** — `SECURITY DEFINER` bypass RLS เมื่อ query profiles

### auth.uid() vs current_employee_id()

ปัญหาที่เคยเจอใน hardening แรก: ใช้ `auth.uid()` ที่ผิดที่

```
auth.uid()              = profiles.id (UUID ของ login session)
current_employee_id()   = profiles.employee_id (UUID ของ employees table)

Tables มี employee_id column → ต้อง compare กับ current_employee_id()
Tables มี user_id หรือ id (สำหรับ profiles) → ต้อง compare กับ auth.uid()
```

**Rule:** ถ้าเห็น `employee_id = auth.uid()` ใน policy = bug แน่นอน

---

## 5 Buckets Overview

แบ่งทุก table เป็น 5 buckets ตาม sensitivity และ access pattern:

```
┌────────────────────────────────────────────────────────┐
│ Bucket A: PUBLIC REFERENCE                              │
│ ────────────────────────                                 │
│ Master data ที่ไม่ใช่ personal — ทุกคนอ่านได้           │
│                                                         │
│ Read:    anon + authenticated → always                  │
│ Write:   authenticated → admin only                     │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ Bucket B: PERSONAL DATA                                 │
│ ─────────────────                                        │
│ ข้อมูลส่วนบุคคล — เห็นเฉพาะตัวเอง + supervisor + admin    │
│                                                         │
│ Read:    self / supervisor (team) / admin               │
│ Write:   admin (mostly) — บาง table ผู้ใช้ insert ตัวเอง  │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ Bucket C: WORKFLOW / TRANSACTIONS                       │
│ ────────────────────────────                             │
│ User submit + approver flow                             │
│                                                         │
│ Read:    self / supervisor (team) / admin               │
│ Insert:  self only                                      │
│ Update:  approvers (supervisor / admin)                 │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ Bucket D: PAYROLL                                       │
│ ───────────                                              │
│ ข้อมูลเงินเดือน — sensitive มาก                          │
│                                                         │
│ Read:    self (sealed runs only) / finance / admin      │
│ Write:   finance / admin only                           │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ Bucket E: ADMIN / COMPLIANCE                            │
│ ─────────────────────                                    │
│ Audit + PDPA + system tokens                            │
│                                                         │
│ Read:    admin (or self where applicable)               │
│ Write:   admin / system                                 │
└────────────────────────────────────────────────────────┘
```

---

## Table Assignments

### Bucket A: Public Reference (4 tables)

| Table | Description |
|---|---|
| `cost_centers` | Branch/department info (HQ-00, HQ-01, CC-04, ...) |
| `shifts` | Shift definitions (start/end time) |
| `holiday_calendar` | วันหยุดบริษัท |
| `system_config` | DB-driven config values |

### Bucket B: Personal Data (5 tables)

| Table | Description |
|---|---|
| `employees` | Core employee master (name, salary, etc.) |
| `profiles` | Auth profile (linked to auth.users) |
| `attendance_logs` | Check-in/check-out records |
| `employee_shifts` | Shift assignments per day |
| `employee_diligence_counters` | เบี้ยขยัน counter (late/absent counts) |

### Bucket C: Workflow (4 tables)

| Table | Description |
|---|---|
| `leave_balances` | Annual leave balance per type |
| `leave_requests` | Leave applications |
| `ot_requests` | OT applications |
| `correction_requests` | Time correction requests |

### Bucket D: Payroll (5 tables)

| Table | Description |
|---|---|
| `payroll_runs` | Payroll batch runs (monthly) |
| `payroll_details` | Per-employee payroll details |
| `payroll_deductions` | Deduction breakdowns |
| `wht_declarations` | ภ.ง.ด. 1 declarations |
| `notifications_log` | Notification history (LINE, etc.) |

### Bucket E: Admin/Compliance (4 tables)

| Table | Description |
|---|---|
| `audit_logs` | System audit trail |
| `consent_records` | PDPA consent tracking |
| `dsr_requests` | Data Subject Rights requests |
| `substitute_tokens` | Substitute auth tokens |

**Total: 22 tables**

---

## Helper Functions

### `public.current_employee_id() → UUID`

Returns employee_id ของ user ที่ login (lookup จาก profiles)

```sql
CREATE OR REPLACE FUNCTION public.current_employee_id()
RETURNS UUID
LANGUAGE SQL STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT employee_id FROM profiles WHERE id = auth.uid()
$$;
```

**Usage in policies:**
```sql
USING (employee_id = public.current_employee_id())
```

### `public.current_user_role() → TEXT`

Returns role จาก profiles (ไม่ใช่ JWT — เพื่อ avoid stale data)

```sql
CREATE OR REPLACE FUNCTION public.current_user_role()
RETURNS TEXT
LANGUAGE SQL STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role FROM profiles WHERE id = auth.uid()
$$;
```

### `public.is_admin() → BOOLEAN`

```sql
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE SQL STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT public.current_user_role() IN ('owner','owner_delegate','hr_admin')
$$;
```

### `public.supervises_employee(target UUID) → BOOLEAN`

```sql
CREATE OR REPLACE FUNCTION public.supervises_employee(target_employee_id UUID)
RETURNS BOOLEAN
LANGUAGE SQL STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM employees
    WHERE id = target_employee_id
      AND supervisor_id = public.current_employee_id()
  )
$$;
```

### `public.is_admin_or_it() → BOOLEAN` (profiles-specific)

```sql
CREATE OR REPLACE FUNCTION public.is_admin_or_it()
RETURNS BOOLEAN
LANGUAGE SQL STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role IN ('owner','owner_delegate','hr_admin','it_support')
  FROM profiles WHERE id = auth.uid()
$$;
```

### `public.can_write_profile() → BOOLEAN` (profiles-specific)

```sql
CREATE OR REPLACE FUNCTION public.can_write_profile()
RETURNS BOOLEAN
LANGUAGE SQL STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role IN ('owner','owner_delegate','it_support')
  FROM profiles WHERE id = auth.uid()
$$;
```

---

## Standard Patterns

### Pattern A: Public Reference

```sql
-- Grants
GRANT SELECT ON {table} TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON {table} TO authenticated;

-- Policies
CREATE POLICY "{table}_read_all"
ON {table} FOR SELECT
TO anon, authenticated
USING (true);

CREATE POLICY "{table}_write_admin"
ON {table} FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());
```

### Pattern B: Personal Data

```sql
-- Grants
GRANT SELECT ON {table} TO authenticated;
GRANT INSERT, UPDATE, DELETE ON {table} TO authenticated;

-- Read: self
CREATE POLICY "{table}_read_self"
ON {table} FOR SELECT
TO authenticated
USING (employee_id = public.current_employee_id());

-- Read: supervisor sees team
CREATE POLICY "{table}_read_supervisor"
ON {table} FOR SELECT
TO authenticated
USING (
  public.is_supervisor()
  AND public.supervises_employee(employee_id)
);

-- Read: admin sees all
CREATE POLICY "{table}_read_admin"
ON {table} FOR SELECT
TO authenticated
USING (public.is_admin());

-- Write: admin only (or specific to table)
CREATE POLICY "{table}_write_admin"
ON {table} FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());
```

### Pattern C: Workflow

```sql
-- Grants
GRANT SELECT, INSERT, UPDATE, DELETE ON {table} TO authenticated;

-- Read: self / supervisor / admin (3 policies — same as Pattern B)
[... same SELECT policies as Pattern B ...]

-- Insert: self only
CREATE POLICY "{table}_insert_self"
ON {table} FOR INSERT
TO authenticated
WITH CHECK (employee_id = public.current_employee_id());

-- Update: approvers (supervisor or admin)
CREATE POLICY "{table}_update_approver"
ON {table} FOR UPDATE
TO authenticated
USING (public.is_supervisor() OR public.is_admin())
WITH CHECK (public.is_supervisor() OR public.is_admin());
```

### Pattern D: Payroll

```sql
-- Grants
GRANT SELECT, INSERT, UPDATE, DELETE ON {table} TO authenticated;

-- Read self (sealed runs only — for payroll_details)
CREATE POLICY "{table}_read_self_sealed"
ON {table} FOR SELECT
TO authenticated
USING (
  employee_id = public.current_employee_id()
  AND EXISTS (
    SELECT 1 FROM payroll_runs
    WHERE id = {table}.payroll_run_id
      AND status IN ('transferred','locked','closed')
  )
);

-- Read finance/admin
CREATE POLICY "{table}_read_finance_admin"
ON {table} FOR SELECT
TO authenticated
USING (public.is_finance_or_admin());

-- Write: finance/owner only
CREATE POLICY "{table}_write_finance"
ON {table} FOR ALL
TO authenticated
USING (public.current_user_role() IN ('owner','owner_delegate','finance'))
WITH CHECK (public.current_user_role() IN ('owner','owner_delegate','finance'));
```

### Pattern E: Admin/Compliance

```sql
-- Grants
GRANT SELECT, INSERT, UPDATE ON {table} TO authenticated;

-- Read self (for tables with employee_id)
CREATE POLICY "{table}_read_self"
ON {table} FOR SELECT
TO authenticated
USING (employee_id = public.current_employee_id());

-- Read admin
CREATE POLICY "{table}_read_admin"
ON {table} FOR SELECT
TO authenticated
USING (public.is_admin());

-- Write admin
CREATE POLICY "{table}_write_admin"
ON {table} FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());
```

---

## ⚠️ Critical: Profiles Recursion

**The Problem:**

ในการ apply migration ครั้งแรก เกิด **infinite recursion** เพราะ profiles policy ใช้ inline subquery:

```sql
-- ❌ WRONG (caused recursion)
CREATE POLICY "profiles_read_admin"
ON profiles FOR SELECT
USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) IN ('owner', ...)
);

-- เกิดอะไร:
-- 1. User query profiles
-- 2. RLS check policy "profiles_read_admin"
-- 3. Subquery (SELECT role FROM profiles ...) 
-- 4. ← Subquery นี้โดน RLS ของ profiles ตรวจอีกครั้ง
-- 5. → Trigger policy "profiles_read_admin" อีก
-- 6. → Subquery อีก → loop ไม่จบ
-- 7. ❌ ERROR 42P17: infinite recursion detected
```

**The Fix:**

ใช้ `SECURITY DEFINER` functions ที่ bypass RLS:

```sql
-- ✅ CORRECT (no recursion)
CREATE FUNCTION public.is_admin_or_it()
RETURNS BOOLEAN
LANGUAGE SQL STABLE SECURITY DEFINER  -- ← KEY: bypass RLS
SET search_path = public
AS $$
  SELECT role IN ('owner','owner_delegate','hr_admin','it_support')
  FROM profiles WHERE id = auth.uid()
$$;

CREATE POLICY "profiles_read_admin"
ON profiles FOR SELECT
USING (public.is_admin_or_it());

-- เกิดอะไร:
-- 1. User query profiles
-- 2. RLS check policy "profiles_read_admin"
-- 3. Function call public.is_admin_or_it()
-- 4. ← SECURITY DEFINER → run as table owner → bypass RLS
-- 5. Function returns BOOLEAN
-- 6. ✅ No recursion
```

**Rules for profiles policies:**

1. ❌ **NEVER** use inline subquery on `profiles` within profiles policies
2. ✅ **ALWAYS** use `SECURITY DEFINER` functions
3. ✅ Two profile-specific helpers exist: `is_admin_or_it()`, `can_write_profile()`
4. ✅ Self-read can use `id = auth.uid()` directly (no subquery)

---

## Decision Log

### Decision 1: Helper functions in `public` schema (not `auth`)

**Considered:**
- A) Functions in `auth` schema (idiomatic Supabase)
- B) Functions in `public` schema

**Chosen:** B

**Rationale:** `auth` schema is owned by Supabase — modifying it could conflict with future Supabase updates. `public` schema is project-owned, safe to modify.

### Decision 2: Use `profiles.role` instead of JWT for role check

**Considered:**
- A) `auth.jwt() ->> 'role'` (faster, no DB lookup)
- B) `profiles.role` (slower, but always fresh)

**Chosen:** B

**Rationale:**
- JWT can become stale if user's role changes during active session
- Critical operations (payroll, admin) must use up-to-date role
- Performance impact minimal — function is `STABLE`, cached per-query

### Decision 3: `profiles` table needs SECURITY DEFINER functions

**Problem:** RLS policies that call helper functions on `profiles` cause recursion (helper itself queries profiles)

**First attempt (failed):** Inline subquery
```sql
USING ((SELECT role FROM profiles WHERE id = auth.uid()) IN (...))
-- ❌ ERROR 42P17: infinite recursion
```

**Final solution:** Two profile-specific helpers using SECURITY DEFINER
```sql
USING (public.is_admin_or_it())  -- ✅ bypasses RLS
```

**Trade-off:** SECURITY DEFINER functions run with elevated privileges. We accept this because:
- Functions are `STABLE` and read-only
- Functions only check `auth.uid()` and return BOOLEAN
- No data leak possible (no row data returned to caller)

### Decision 4: `payroll_details` self-read requires sealed run status

**Rationale:** Employees should not see draft/preview payrolls (could cause confusion or premature concerns). Only show payroll details when run is `transferred`, `locked`, or `closed`.

```sql
USING (
  employee_id = public.current_employee_id()
  AND EXISTS (
    SELECT 1 FROM payroll_runs
    WHERE id = payroll_details.payroll_run_id
      AND status IN ('transferred','locked','closed')
  )
)
```

### Decision 5: anon role gets SELECT on Bucket A only

**Rationale:**
- Bucket A = public reference data (no PII)
- Allows pre-login UI elements (e.g., branch list during onboarding)
- Other buckets contain personal/sensitive data → require auth

### Decision 6: Service role unrestricted access on critical tables

**Rationale:** Edge Functions use service_role to bypass RLS for system operations (insert audit logs, system notifications, etc.). Without this, system operations would fail.

```sql
CREATE POLICY "employees_service_role_all"
ON employees FOR ALL
TO service_role
USING (true)
WITH CHECK (true);
```

Applied selectively to tables where Edge Functions need direct write access.

### Decision 7: Drop ALL policies before recreating (clean slate)

**Considered:**
- A) ALTER existing policies (preserve names)
- B) DROP all + CREATE fresh

**Chosen:** B

**Rationale:**
- Migration must be idempotent and predictable
- Existing policies had inconsistent names + bugs
- DROP-then-CREATE in single transaction is atomic (BEGIN/COMMIT)
- Clear audit trail: before-after is easy to compare

---

## Maintenance Rules

### When adding a new table

1. **Pick a bucket** — match data sensitivity to A/B/C/D/E
2. **Apply pattern** — copy template SQL from this doc
3. **Replace `{table}`** with actual table name
4. **Test with 4 roles** — staff, supervisor, hr_admin, owner
5. **Update this doc** — add to "Table Assignments"
6. **Commit migration + doc together** — single PR

### When changing a policy

1. **Document why** in commit message
2. **Add to Decision Log** if architectural change
3. **Run verification queries** post-deploy
4. **Test with all roles** before merge

### Anti-patterns (never do these)

❌ `employee_id = auth.uid()` — auth.uid() is profile.id, not employee.id  
❌ `(SELECT ... FROM profiles WHERE id = auth.uid())` ใน profiles policies — recursion  
❌ Using `auth.jwt() ->> 'role'` for critical operations — can be stale  
❌ Bypassing RLS via SECURITY DEFINER unless absolutely necessary  
❌ Mixing `roles: public` and `roles: authenticated` randomly  
❌ Creating policy without GRANT — RLS without grant = blocked  

### Verification Queries

```sql
-- 1. All tables have authenticated SELECT grant
SELECT t.table_name,
       BOOL_OR(p.privilege_type = 'SELECT' AND p.grantee = 'authenticated') AS has_grant
FROM information_schema.tables t
LEFT JOIN information_schema.table_privileges p
  ON p.table_name = t.table_name AND p.table_schema = t.table_schema
WHERE t.table_schema = 'public' AND t.table_type = 'BASE TABLE'
GROUP BY t.table_name
HAVING NOT BOOL_OR(p.privilege_type = 'SELECT' AND p.grantee = 'authenticated');
-- Expected: 0 rows (all tables have grant)

-- 2. All RLS-enabled tables have at least 1 policy
SELECT c.relname
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relkind = 'r'
  AND c.relrowsecurity = true
  AND NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = c.relname AND schemaname = 'public'
  );
-- Expected: 0 rows

-- 3. No policy uses raw auth.uid() for employee_id
SELECT tablename, policyname, qual
FROM pg_policies
WHERE schemaname = 'public'
  AND qual LIKE '%employee_id = auth.uid()%';
-- Expected: 0 rows (all should use current_employee_id())

-- 4. All 8 helper functions exist
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name IN (
    'current_employee_id', 'current_user_role',
    'is_admin', 'is_supervisor', 'is_finance_or_admin',
    'supervises_employee', 'is_admin_or_it', 'can_write_profile'
  );
-- Expected: 8 rows
```

---

## Migration History

| Date | Migration | Status |
|---|---|---|
| 2569-04-25 | Initial RLS hardening (Sprint kickoff) | ⚠️ Incomplete (some tables missing grants) |
| 2569-05-02 | **Comprehensive RLS & Grants Audit** (this doc) | ✅ Active |
| 2569-05-02 | Hotfix: profiles recursion (added `is_admin_or_it`, `can_write_profile`) | ✅ Active |

---

## Related Documentation

- [DECISIONS.md](../DECISIONS.md) — Locked architectural decisions
- [Section 1: Identity & Roles](../01-identity-and-roles.md)
- [Section 4: Authentication Flow](../04-authentication-flow.md)
- [Schema Reference](../master-data.md)
