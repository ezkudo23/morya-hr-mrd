# Section 11: PDPA & Compliance 🔒

*บริษัท หมอยาสุรินทร์ จำกัด | MRD Section 11*

> **Status:** ✅ Locked — 24 เม.ย. 2569  
> **Scope:** การคุ้มครองข้อมูลส่วนบุคคลตาม PDPA พ.ศ. 2562  
> **Dependencies:** Section 10 (Audit Log), Section 2 (Stakeholders)

---

## 11.1 ภาพรวม (Overview)

### ฐานกฎหมาย

**พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 (PDPA)**

| บทบาท | รายละเอียด |
|-------|-----------|
| **Data Controller** | บริษัท หมอยาสุรินทร์ จำกัด (0325557000531) |
| **DPO** | เฮีย (อมร) — Owner + DPO ⚠️ Concentration of authority — รีวิวประจำปีโดยทนายภายนอก |
| **Data Processors** | Supabase (US/Singapore), LINE OA+LIFF (Japan), Cloudflare (Global), Anthropic Claude API (ไม่ส่ง PII) |

### Penalties (ทำไมต้อง compliant)

- ⚠️ Administrative fine: สูงสุด 5 ล้านบาท/ครั้ง
- ⚠️ Criminal: จำคุก 1 ปี + ปรับ 1 ล้าน (เจตนา)
- ⚠️ Civil: ลูกจ้าง sue + ค่าเสียหายเพิ่ม
- ⚠️ Reputational: อันตรายที่สุด

**Benefits:** Trust จากลูกจ้าง + Clear rules ลดข้อพิพาท + ป้องกันการใช้ข้อมูลเกินขอบเขต

---

## 11.2 Personal Data Inventory

### Category A: ข้อมูลส่วนบุคคลทั่วไป

**Identity:** ชื่อ-นามสกุล (ไทย/อังกฤษ), รหัสพนักงาน (MY01-26), เลข ปชช., วันเดือนปีเกิด/อายุ/เพศ, เบอร์โทร, LINE User ID, ที่อยู่, รูปถ่าย

**Employment:** ตำแหน่ง/Role/Cost Center, วันเริ่มงาน/Probation, เงินเดือน/OT/Commission/โบนัส, บัญชีธนาคาร, ข้อมูล SSO, เลขผู้เสียภาษี, ลดหย่อน (ลย.01)

**Attendance:** GPS coordinates (ทุก check-in/out), IP address + Device ID, เวลาเข้า-ออก, Pattern ทำงาน, Photos (correction evidence)

**Performance:** ยอดขาย (commission), Late counter, Leave records, Disciplinary records, Review notes

### Category B: ข้อมูลอ่อนไหว (Sensitive) — PDPA ม.26

ต้องการ explicit consent แยก:
- ข้อมูลสุขภาพ (ใบรับรองแพทย์เมื่อลาป่วย)
- ข้อมูลศาสนา (ลาบวช, ลาสมรส)
- ❌ ไม่เก็บ: ลายนิ้วมือ, พันธุกรรม, อาชญากรรม

### Category C: ข้อมูลครอบครัว (ลย.01)

สำหรับลดหย่อนภาษี: ข้อมูล spouse + บุตร + บิดามารดา → บุคคลเหล่านี้เป็น Data Subject ด้วย → ลูกจ้างต้องได้ consent จากครอบครัวก่อนแจ้ง

---

## 11.3 Legal Basis (ม.24)

| Data Category | Legal Basis | หมายเหตุ |
|---------------|-------------|---------|
| ชื่อ, เลข ปชช., ที่อยู่ | (5) Legal Obligation | สัญญาจ้าง + กม.แรงงาน ม.11 |
| เงินเดือน, ภาษี, ปกส. | (5) Legal Obligation | กม.แรงงาน + รัษฎากร + ปกส. |
| GPS, Attendance | (3) Contract Performance | จำเป็นต่อ payroll |
| Performance reviews | (4) Legitimate Interest | ประเมินผลงาน |
| ข้อมูลสุขภาพ | (26) Explicit Consent | แยก consent |
| Photos | (1) Consent | สมัครใจ |
| Family data | (5) + Consent | รัษฎากร + consent |

> **Key:** ไม่ base ทุกอย่างด้วย consent → ถ้าลูกจ้างเพิกถอน → ทำ payroll ไม่ได้ + ขัดกฎหมายแรงงาน

---

## 11.4 Data Subject Rights (8 สิทธิ์)

1. **สิทธิ์เข้าถึง (ม.30)** — ขอดูข้อมูลทั้งหมด
2. **สิทธิ์ถ่ายโอน (ม.31)** — ขอ machine-readable format
3. **สิทธิ์คัดค้าน (ม.32)** — หยุดประมวลผลใน purpose X
4. **สิทธิ์ลบข้อมูล (ม.33)** — ⚠️ legal retention 5-10 ปี
5. **สิทธิ์ระงับการใช้ (ม.34)** — freeze ชั่วคราว
6. **สิทธิ์แก้ไข (ม.35)** — แก้ข้อมูลผิด
7. **สิทธิ์ถอน consent (ม.19)** — effect ทันที
8. **สิทธิ์ร้องเรียน (ม.73)** — internal หรือ สคส.

### DSR SLA (Tiered — 🔒 Locked)

| Request Type | SLA |
|-------------|-----|
| Simple (แก้ที่อยู่, ดู payslip) | 7 วัน |
| Medium (export data) | 14 วัน |
| Complex (delete, restrict, portability) | 30 วัน |

**Workflow:** LIFF Submit → DPO classify → Approve (SLA) → Execute → Audit Log L2

---

## 11.5 Consent Management

### รูปแบบ: Umbrella Consent (🔒 Locked)

1 ใบ consent ครอบคลุมทั้งหมด แต่ granular checkbox:

- ☐ Basic data (required — legal obligation)
- ☐ Cross-border transfer (Supabase, LINE, Cloudflare)
- ☐ Sensitive data (medical certificates)
- ☐ Photos in HR records
- ☐ Marketing/Internal communication (LINE OA)
- ☐ Event photos (company events)

เซ็นครั้งเดียว — granular แต่ละ checkbox | Withdraw ได้เฉพาะ checkbox ที่ไม่ required

### Data Model

```sql
consent_records
├── id (UUID)
├── employee_id (FK)
├── consent_type (enum)
├── purpose (text)
├── scope (JSON)
├── granted_at (timestamp)
├── granted_ip (inet)
├── granted_device (text)
├── version (consent form version)
├── withdrawn_at (nullable)
├── withdrawal_reason (nullable)
├── status ('active', 'withdrawn', 'expired')
└── audit_trail (JSONB)
```

### Withdrawal Policy (🔒 Locked: Immediate)

Immediate effect ตาม PDPA ม.19

- Data base = Legal Obligation → ไม่กระทบ (เงินเดือน, ภาษี, ปกส. ยังเก็บได้)
- Data base = Consent → หยุดใช้ทันที (photos, medical certs, marketing)

---

## 11.6 Data Retention Policy

| Data Type | Retention | Legal Basis |
|-----------|-----------|-------------|
| Payroll records | 10 ปี | พ.ร.บ.แรงงาน ม.115 |
| 50 ทวิ, ภ.ง.ด. | 5 ปี | รัษฎากร ม.83/12 |
| สปส.1-10 | 10 ปี | ประกันสังคม |
| Attendance logs | 2 ปี | แรงงาน + dispute |
| GPS coordinates | 2 ปี | Same |
| Leave records | 5 ปี | แรงงาน |
| Disciplinary records | 5 ปี หรือจบคดี | แรงงาน |
| Medical certificates | 1 ปี | PDPA min necessary |
| Contract documents | 10 ปี | สัญญา + แรงงาน |
| Emergency contact | ทำงาน + 1 ปี | Ongoing need |
| Photos (HR) | ทำงาน + 6 เดือน | Employment |
| Audit logs | 2–5 ปี | Internal |

### Auto-deletion Schedule

**Monthly cron (วันที่ 1):** Check retention_until < CURRENT_DATE → Anonymize/Delete → Audit Level 2 → Report DPO

**Post-resignation timeline:**
- T+0: Lock LIFF access
- T+immediate: Delete GPS
- T+6 เดือน: Delete photos
- T+1 ปี: Delete medical certs
- T+2 ปี: Delete attendance
- T+5 ปี: Delete 50 ทวิ
- T+10 ปี: Delete payroll records

---

## 11.7 Data Security & Access Control

### Technical Safeguards

**1. Encryption**
- At rest: Supabase AES-256
- In transit: TLS 1.3
- Backups: encrypted

**2. Access Control**
- Row-Level Security (RLS) ทุก table
- Role-based: Staff/Sup/HR/Owner
- JWT tokens (1 ชม. expiry)
- LINE LIFF verified identity

**3. Authentication**
- Primary: LINE Login (OAuth 2.0)
- MFA: HR Admin + Owner
- Auto-logout 30 นาที

**4. Audit Logging**
- Level 1: 1 ปี retention
- Level 2: 2 ปี retention
- SHA256 hash chain (immutable)
- DB triggers (cannot disable)

**5. Network Security**
- Cloudflare WAF
- Rate limiting per user
- Geo-blocking (TH-only HR admin)

**6. Monitoring**
- Sentry: error + security alerts
- Anomaly detection
- DPO dashboard

### Access Matrix

| Role | Own | Team | Branch | All | Export | Delete |
|------|-----|------|--------|-----|--------|--------|
| Staff | ✅ | ❌ | ❌ | ❌ | Own | ❌ |
| Supervisor | ✅ | ✅ | ❌ | ❌ | Team | ❌ |
| HR Admin | ✅ | ✅ | ✅ | ✅ | All | Soft |
| Finance | ✅ | ❌ | ❌ | Read | All | ❌ |
| Owner/DPO | ✅ | ✅ | ✅ | ✅ | All | ✅ |

---

## 11.8 Data Breach Response Plan

### Incident Response Timeline

| เวลา | Action |
|------|--------|
| T+0 | Detection (Sentry / DPO / Employee complaint) |
| T+2 hr | Initial Assessment: DPO ประชุม, Scope + Severity, Containment action |
| T+24 hr | Containment Complete: Block attacker, Revoke compromised creds, Preserve evidence |
| T+72 hr | Regulatory Notification (PDPA ม.37): แจ้ง สคส. ที่ pdpc.or.th ⚠️ High-risk → แจ้งลูกจ้างด้วย |
| T+7 วัน | Post-Incident Report |
| T+30 วัน | Follow-up |

### Severity Levels

| Level | Scope | Action |
|-------|-------|--------|
| 🟢 Low | 1–5 คน, non-sensitive | Internal only |
| 🟡 Medium | 5–20 คน, financial data | Internal + document |
| 🟠 High | 20+ คน หรือ sensitive | ⚠️ แจ้ง สคส. |
| 🔴 Critical | All employees, active exploit | ⚠️ แจ้ง สคส. ทันที + ลูกจ้าง + อาจแถลง |

---

## 11.9 Privacy Notice

**เผยแพร่ที่:** ตอนสมัครงาน | LIFF "Privacy Center" | www.morya.co.th/privacy | ติด notice ที่ร้าน 3 สาขา

**เนื้อหาที่ต้องมี (PDPA ม.23):**
1. ผู้ควบคุมข้อมูล + ข้อมูลติดต่อ DPO
2. วัตถุประสงค์ + legal basis
3. ข้อมูลที่เก็บ + sources
4. การเปิดเผย/ถ่ายโอน
5. Retention period
6. สิทธิ์ Data Subject (8 ข้อ)
7. วิธีการใช้สิทธิ์ + SLA
8. ผลของการไม่ให้ข้อมูล
9. การถ่ายโอนต่างประเทศ
10. วิธีร้องเรียน (สคส.)

**ภาษา:** ไทย (main) + อังกฤษ (optional) — ใช้ plain language

---

## 11.10 Cross-Border Data Transfer

| Provider | Location | Data | Legal Basis |
|----------|----------|------|-------------|
| Supabase | US/Singapore | Production data | SCC + consent |
| LINE OA | Japan | User IDs, messages | Contract |
| Cloudflare | Global | Access logs, static | SCC |
| Anthropic | Global | ❌ ไม่ส่ง PII | N/A (anonymized only) |

### ⚠️ Anthropic Claude API Rule

**ห้าม send:** ชื่อ-นามสกุล, เลข ปชช., เงินเดือน, ข้อมูลลูกจ้างระบุตัวตนได้

**ส่งได้:** Language summarization (anonymized), Content generation (templates), ข้อมูล anonymized เท่านั้น

---

## 11.11 DPO Responsibilities (🔒 Locked: เฮีย)

**Duties:**
1. Monitor PDPA compliance
2. ให้คำปรึกษา staff + management
3. ประสาน สคส. เมื่อมี breach/complaint
4. ทบทวน Privacy Notice + Policies ทุกปี
5. จัด training ให้ทีม (annual)
6. ทำ Data Protection Impact Assessment (DPIA)
7. Process Data Subject Requests
8. รายงาน (self) รายไตรมาส

**Mitigation สำหรับ DPO = Owner:**
- ⚠️ Concentration of authority
- ✅ รีวิวประจำปีโดยทนายภายนอก
- ✅ External audit (optional) Q1 ปี 2570
- ✅ Quarterly self-report documented

---

## 11.12 Training (🔒 Locked: Online Video + Quiz)

**Format:** Online Video + Quiz (5–10 นาที) ใน LIFF | Track completion | Quiz pass 80% | Refresher annually

**Content:**
1. PDPA คืออะไร (2 นาที)
2. สิทธิ์ 8 ข้อของลูกจ้าง (3 นาที)
3. วิธีใช้สิทธิ์ใน LIFF (2 นาที)
4. Data breach — ทำยังไงถ้าสงสัย (2 นาที)
5. Contact DPO (1 นาที)

Quiz: 5–10 คำถาม | Retake: unlimited

**Schedule:** New hire = ส่วนหนึ่งของ onboarding (mandatory) | Existing = Annual refresher | Post-breach = Retrain affected team

---

## 11.13 Implementation Checklist

### Pre Go-Live (1 ม.ค. 2570)

**🔴 Must Have:**
- [x] แต่งตั้ง DPO — เฮีย (Owner)
- [ ] เขียน Privacy Notice ภาษาไทย (10 ข้อ)
- [ ] ออกแบบ Umbrella Consent form
- [ ] Legal review โดยทนาย (4–8 hr)
- [ ] ติด Privacy Notice ที่ร้าน 3 สาขา
- [ ] Update สัญญาจ้างงาน — PDPA clauses
- [ ] สร้าง Training Video + Quiz in LIFF
- [ ] Training พนักงานทุกคน (mandatory)
- [ ] DSR workflow in LIFF

**🟡 Should Have:**
- [ ] Data Protection Impact Assessment (DPIA)
- [ ] Breach response playbook (document)
- [ ] Annual audit plan
- [ ] Third-party DPA — Supabase, LINE
- [ ] สคส. registration (voluntary)

**🟢 Nice to Have:**
- [ ] External audit (Q1 2570)
- [ ] Privacy by Design review
- [ ] ISO 27001 cert roadmap

### Post Go-Live (ongoing)

**Monthly:** DPO review access logs | Monitor DSRs | Self-report summary

**Quarterly:** Policy review | Training refresher | Risk assessment

**Annually:** Full Privacy Notice review | External lawyer review | Update consent forms | Annual compliance report

---

## 11.14 Cost Estimate

| รายการ | ค่าใช้จ่าย |
|--------|-----------|
| Lawyer consult one-time (4–8 hr) | 15,000–30,000 บาท |
| Privacy Notice design | 0 (in-house) |
| Training video production | ~3,000 บาท |
| Physical notices (print) | ~500/สาขา × 3 = 1,500 บาท |
| **รวม one-time** | **~20,000–35,000 บาท** |
| Policy review (lawyer) ต่อปี | ~10,000 บาท |
| External audit (optional) ต่อปี | ~30,000 บาท |
| **รวม Year 1** | **20,000–65,000 บาท** |
| **รวม Year 2+** | **10,000–40,000 บาท/ปี** |

vs Non-compliance risk: สูงสุด 5,000,000 บาท/ครั้ง → ROI: Insurance policy มูลค่าสูง

---

## 🔒 Locked Decisions Summary

| # | Decision |
|---|----------|
| Q1 | DPO = เฮีย (Owner) + External lawyer annual review mitigation |
| Q2 | Consent form = Umbrella (1 ใบ granular checkboxes) |
| Q3 | DSR SLA = Tiered: Simple 7d / Medium 14d / Complex 30d |
| Q4 | Consent withdrawal = Immediate effect |
| Q5 | Training = Online Video + Quiz (5–10 นาที) + Annual refresher |

---

## 🔗 Related Sections

- Section 2: Stakeholders (DPO role)
- Section 10: Audit Log (tracking)
- Section 12: Deployment (go-live checklist)

## 🔗 Legal References

- **PDPA พ.ศ. 2562** เต็มฉบับ: pdpc.or.th
- ม.19 — การเพิกถอน consent
- ม.23 — Privacy Notice requirements
- ม.24 — Legal bases
- ม.26 — Sensitive data
- ม.28-29 — Cross-border transfer
- ม.30-35 — Data Subject Rights
- ม.37 — Breach notification (72 ชม.)
- ม.73 — Right to complain

---

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked & Ready for Dev M1*
