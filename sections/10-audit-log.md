# Section 10: บันทึกการใช้งาน (Audit Log)

*Immutable activity tracking | อัปเดต: 24 เม.ย. 2569*

> Audit log ให้ visibility + accountability + legal evidence  
> อ้างอิง: Section 4 (กฎพื้นฐาน) + Section 5 (Workflow)

---

## 10.1 ประเภทเหตุการณ์ (Event Taxonomy)

### Level 2 (สำคัญ) — เก็บ before/after, 2 ปี

**💰 Payroll**
- Round 1 cancel & re-run
- Payroll value edit (manual override)
- Force Proceed
- Emergency Unlock
- Commission entry/edit

**👥 ข้อมูลหลัก (Master Data)**
- แก้เงินเดือน
- แก้ WHT config
- เปลี่ยน status (probation → active → resigned)
- เปลี่ยน cost center
- เปลี่ยน supervisor

**📋 Approvals**
- อนุมัติ/ปฏิเสธ ลา
- อนุมัติ/ปฏิเสธ OT
- อนุมัติแก้ check-in
- อนุมัติใช้ token
- อนุมัติลาออก

**🔐 System**
- เปลี่ยน role
- สร้าง/ปิด user account
- Login failure (5+ ครั้ง)
- เปลี่ยน permission

**📜 Compliance**
- ยื่น ปกส.
- ยื่น ภ.ง.ด.1
- ออก 50 ทวิ
- อัปเดต PDPA consent

### Level 1 (ปกติ) — action + timestamp, 1 ปี

- Check-in / check-out
- ส่งคำขอลา
- ส่งคำขอ OT
- ดู/โหลด payslip
- ดู Dashboard
- Login / logout
- ส่งแจ้งเตือน

---

## 10.2 โครงสร้างข้อมูล

```typescript
type AuditLog = {
  id: string;
  level: 1 | 2;
  category: 'payroll' | 'master_data' | 'approval' | 'system' | 'compliance' | 'attendance';
  action: string;  // e.g., 'payroll.round1.cancel'

  actor: {
    user_id: string;
    role: UserRole;
    name: string;  // snapshot
  };

  target: {
    type: 'employee' | 'payroll' | 'leave_request' | ...;
    id: string;
    identifier: string;  // readable (e.g., "MY13 นัด")
  };

  changes?: {            // Level 2 เท่านั้น
    before: Record<string, any>;
    after: Record<string, any>;
  };

  context: {
    ip_address: string;
    user_agent: string;
    location?: { lat: number; lng: number };  // Level 2 เท่านั้น
    session_id: string;
  };

  reason?: string;       // บังคับสำหรับ Level 2
  timestamp: Date;
  retention_until: Date;
};
```

### Immutability Rule

- ❌ ห้าม UPDATE audit logs
- ❌ ห้าม DELETE โดย API (ยกเว้น automated retention)
- ✅ Append-only database
- ✅ DB trigger ป้องกัน UPDATE/DELETE

---

## 10.3 สิทธิ์การเข้าถึง

| Role | สิทธิ์ |
|------|--------|
| 👑 Owner (เฮีย) | ✅ ดูทุก level ทุก category |
| 👑 Delegates (ไนซ์, จิว) | ✅ ดูทุก level ทุก category |
| 💼 HR Admin (การ์ตูน) | ✅ Level 1 + 2 (ยกเว้น salary โดย Owner) |
| 💰 Finance (นา) | ✅ Payroll + Compliance (both levels) |
| 💻 IT Support (บอส) | ✅ System + login เท่านั้น |
| 👔 Supervisor | ✅ เฉพาะ team ตัวเอง |
| 👤 Staff | ❌ ไม่เห็น audit log ปกติ |
| 👤 Staff (ตัวเอง) | ✅ Activity log ตัวเอง 3 เดือน |

### HR Admin Exception
- HR ไม่เห็น salary changes โดย Owner (confidential)
- ถ้า HR ต้องการข้อมูล salary → ผ่าน Finance

### IT Support Exception
- IT ไม่เห็น payroll/salary/master data
- เฉพาะ technical events (login, errors, permissions)
- เหตุผล: separation of duties

---

## 10.4 Reason Requirement (Level 2)

ทุก Level 2 ต้องมี reason — min 20 chars — บังคับทั้ง client-side และ server-side

**Good examples:**
- "HR ป่วยฉุกเฉิน + deadline ปกส. ใกล้"
- "Staff MY13 นัด ลาป่วยกลางเดือน ต้องแก้ attendance"
- "ปรับเงินเดือนตาม annual review 2569"

**Bad examples (ปฏิเสธ):**
- "test" / "แก้ไข" / "k"

---

## 10.5 Staff Activity Log (ของตัวเอง)

**ขอบเขต: 3 เดือนย้อนหลัง** — เข้าผ่าน LIFF → "My Activity"

**Summary (3 เดือน):** Check-ins, Check-outs, สาย, คำขอลา, OT hours

**Timeline:** แสดง event ย้อนหลังรายวัน

### PDPA Compliance
- Staff มี Right to Access (PDPA ม.30)
- Activity log = fulfill requirement
- Export ได้: Staff กด "Download my data" → PDF (3 เดือน)
- ขอข้อมูลเกิน 3 เดือน → DM HR Admin (manual)

---

## 10.6 Real-time Alerts (Level 2)

| Category | Recipients | Channel |
|----------|-----------|---------|
| Payroll | Owner + Delegates + Finance (นา) | LINE OA critical |
| Master Data | Owner + Delegates + HR Admin | LINE OA critical |
| Approvals | — (ไม่ alert — เกิดบ่อย = spam) | — |
| System | IT Support + Owner (critical only) | LINE OA |
| Compliance | Owner + Finance (นา) | LINE OA |

**Alert template:**
```
🚨 [CRITICAL] Audit Alert
Action: Payroll Round 1 Force Proceed
Actor: เฮีย (Owner)
Time: 2 พ.ย. 2569 14:30
Reason: "HR ป่วยฉุกเฉิน + deadline ปกส."
Affected: 2 items → [ดู Audit Log]
```

---

## 10.7 Context Capture (IP + GPS)

| ข้อมูล | Level 1 | Level 2 |
|--------|---------|---------|
| Timestamp | ✅ | ✅ |
| User agent | ✅ | ✅ |
| Session ID | ✅ | ✅ |
| IP address | Anonymized (192.168.1.xxx) | Full |
| GPS (lat/lng) | ❌ | ✅ |
| Device fingerprint | ❌ | Basic ✅ |

### PDPA Disclosure
Disclose ใน consent form ตอน onboarding: "ระบบเก็บ IP + GPS เมื่อทำ sensitive actions (เงินเดือน, payroll cancel) เพื่อ security + audit"

---

## 10.8 Retention & Deletion

### Retention Policy (🔒 Locked 25 เม.ย. 2569 — Tier Model)

| Data Type | Retention | Note |
|-----------|-----------|------|
| Level 1 (Notification, Login, Read) | 1 ปี → hard delete | Low risk |
| Level 2 (Override, Emergency, Payroll change) | 2 ปี → hard delete | Sensitive |
| Attendance Logs | 2 ปี | ตาม พ.ร.บ. ม.115 |
| Payroll Records | 7 ปี | ตามกฎหมายภาษี |
| Employee Records | ระยะเวลาทำงาน + 2 ปี | — |

**Exception: Legal Hold** — ถ้ามี labor lawsuit → freeze (ไม่ลบ) — Manual flag โดย Owner + reason

### Automated Deletion Flow

```
🤖 Cron: วันที่ 1 ของเดือน, 02:00
   │
   ▼
📊 Scan: retention_until < now()
   │
   ├── Skip: legal_hold = true
   │
   ▼
🔔 7-day pre-deletion notice → Owner
   │
   ▼ (after 7 days)
🗑️ Hard delete
   │
   ▼
📄 Post-deletion report → Owner
```

### Legal Hold Workflow

Owner → Admin Panel → Audit Log Management → "Legal Hold" → Filter employee/date range → Enter reason (min 50 chars) → Submit → Records flagged: `legal_hold = true`

---

## 10.9 Views & Search

### Dashboard (Owner/Delegate)

**Overview Tab:** Total actions 30/90 วัน | By category (pie) | By actor (top 10) | Sensitive actions trend (line)

**Search Tab:** Date range | Actor | Target | Category | Action type | Level | Full-text บน reason

**List View:** Columns: timestamp, actor, action, target, changes | Pagination 50/page | Sortable | Click → Detail

**Detail View:** Full JSON | Context (IP, GPS, device) | Related entries (same session) | Copy/export

### Saved Searches (Presets)
- "7 วันล่าสุด critical actions" (Level 2)
- "Payroll overrides เดือนนี้"
- "Master data changes ไตรมาสนี้"
- "Failed login attempts"
- "My actions"

---

## 10.10 Export & Legal Evidence

### Export Permissions

| ประเภท | Authorized | Format |
|--------|-----------|--------|
| Full export | Owner, Delegates | PDF, CSV, JSON |
| HR export | HR Admin | PDF (approvals + corrections) |
| Finance export | Finance Lead | PDF, CSV (payroll + compliance) |

### PDF Export (Legal Evidence)

ประกอบด้วย: Header (บริษัท + export date + authorized by) | Cover (query params + digital signature) | Body (tabular entries) | Appendix (JSON dump) | Footer (page numbers + hash) | Digital signature

### Tamper Evidence
- แต่ละ record มี `hash` field = SHA256(prev_hash + record_data)
- Chain of hashes → detect tampering
- Export includes hash chain → legal-grade

---

## 10.11 Database Schema (Supabase)

```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  level INTEGER NOT NULL CHECK (level IN (1, 2)),
  category TEXT NOT NULL,
  action TEXT NOT NULL,

  actor_user_id UUID NOT NULL REFERENCES auth.users(id),
  actor_role TEXT NOT NULL,
  actor_name TEXT NOT NULL,

  target_type TEXT NOT NULL,
  target_id TEXT,
  target_identifier TEXT,

  changes JSONB,
  context JSONB NOT NULL,
  reason TEXT,

  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  retention_until TIMESTAMPTZ NOT NULL,
  legal_hold BOOLEAN DEFAULT FALSE,
  legal_hold_reason TEXT,

  hash TEXT NOT NULL,
  prev_hash TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_audit_actor ON audit_logs(actor_user_id, timestamp DESC);
CREATE INDEX idx_audit_target ON audit_logs(target_type, target_id);
CREATE INDEX idx_audit_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX idx_audit_level ON audit_logs(level, timestamp DESC);
CREATE INDEX idx_audit_retention ON audit_logs(retention_until) WHERE legal_hold = FALSE;

-- Immutability triggers
CREATE OR REPLACE FUNCTION prevent_audit_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'Audit logs are immutable';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_logs_no_update
BEFORE UPDATE ON audit_logs
FOR EACH ROW EXECUTE FUNCTION prevent_audit_modification();

CREATE TRIGGER audit_logs_no_delete
BEFORE DELETE ON audit_logs
FOR EACH ROW EXECUTE FUNCTION prevent_audit_modification();

-- RLS
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owner/Delegate sees all" ON audit_logs
  FOR SELECT USING (
    auth.jwt() ->> 'role' IN ('owner', 'owner_delegate')
  );
```

---

## 10.12 Security

| Threat | Mitigation |
|--------|------------|
| SQL injection | Parameterized queries + validation |
| Tamper audit | DB triggers + hash chain |
| Unauthorized access | RLS policies per role |
| Mass export abuse | Rate limiting (1 export/hour/user) |
| Snapshot staleness | Snapshot name/role at write time |
| Time manipulation | Server-side timestamp only |
| Session hijacking | IP + user_agent fingerprint |

**Backup:** Daily encrypted S3 | 7-year retention (legal) | Test restoration ทุก 6 เดือน | Off-site separate region

---

## 10.13 Summary

| Topic | Decision |
|-------|----------|
| Levels | 2 tiers (1yr + 2yr) |
| Reason | Required all Level 2 (min 20 chars) |
| Access | Role-based (6 roles) |
| Staff self-view | 3 months via LIFF |
| Alerts | Level 2 → relevant Delegates only |
| Context | IP + GPS for Level 2 only |
| Retention | L1=1ปี, L2=2ปี, Att=2ปี, Payroll=7ปี, Employee=ระยะ+2ปี |
| Legal hold | Owner can flag |
| Export | Owner/Delegate all, role-scoped others |
| Tamper-evidence | Hash chain (SHA256) |
| Immutability | DB triggers |

---

## 10.14 Open Items

- [ ] Hash algorithm final (SHA256 confirmed)
- [ ] PDPA consent text (IP + GPS disclosure)
- [ ] Legal review — audit log admissibility
- [ ] Backup strategy (M6)
- [ ] Retention cron schedule

---

## 10.15 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | เฮีย | Pending |
| Delegate | ไนซ์ | Pending |
| HR Admin | การ์ตูน | Pending |
| Finance | นา | Pending |
| IT Support | บอส | Pending |
| Legal | TBD | Pending |

---

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked*
