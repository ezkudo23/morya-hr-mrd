# Section 1: บทสรุปผู้บริหาร (Executive Summary) 1️⃣

*อัปเดต: 25 เม.ย. 2569*

---

## 1.1 ภาพรวมโครงการ (Project Overview)

- **ชื่อโครงการ:** Morya HR System (MYHR)
- **ประเภท:** ระบบ HR แบบสร้างเอง (Custom-built HRIS)
- **กลุ่มเป้าหมาย:** พนักงาน บริษัท หมอยาสุรินทร์ จำกัด (**32 คน** รวม PC)

### คำอธิบายโครงการ

ระบบ HR สร้างเองสำหรับหมอยาสุรินทร์ ครอบคลุม: เข้า-ออกงาน (Check-in/out), จัดกะ (Shift), ลา/OT, เงินเดือน (Payroll), ยื่นภาษี/ปกส. (Compliance), Dashboard — ใช้ LINE LIFF สำหรับพนักงาน + Admin Panel สำหรับหลังบ้าน ใช้แทน Humansoft Advance

---

## 1.2 บริบททางธุรกิจ (Business Context)

### สถานการณ์ปัจจุบัน

- Humansoft Advance: 51,253 บาท/ปี ใช้งานจริง <30%
- คำนวณเงินเดือนด้วย Excel (~16 ชม./เดือน)
- ขอลา/OT ผ่าน LINE ส่วนตัว

### ปัญหาที่พบ (Pain Points)

1. ข้อมูลไม่ sync — 6 คน "Active" แต่ลาออกแล้ว, วันเริ่มงานผิด
2. ทำงานมือเยอะ — Excel, LINE ส่วนตัว
3. ขาด features — commission, ใบอนุญาตเภสัชกร, ติดตาม PC, cost center
4. ไม่เชื่อม LINE — ไม่มี real-time dashboard
5. เจ้าของข้อมูล — อยู่บน vendor cloud

### เหตุผลที่เลือกสร้างเอง

- ✅ ปรับแต่งได้ 100%, ประหยัด 21,548/ปี, LINE-first, เป็นเจ้าของข้อมูล
- ⚠️ ต้นทุน: ~7 เดือน พัฒนา

---

## 1.3 ตัวชี้วัดความสำเร็จ (Success Metrics)

### KPI หลัก

| Metric | ปัจจุบัน | เป้าหมาย (6 เดือน) |
|--------|---------|-----------------|
| เวลาทำ Payroll | 16 ชม./เดือน | ≤ 4 ชม. |
| ความแม่นยำข้อมูล | 85% | 100% |
| เวลา Approval | 1-3 วัน | <24 ชม. |
| ข้อผิดพลาด Payroll | 1-2/ปี | 0 |
| ภาระงาน HR | Baseline | -30% |

### KPI รอง

- การใช้งาน LIFF: >95%
- Supervisor response: <8 ชม.
- Uptime: >99%
- Audit coverage: 100% ของ sensitive actions
- Legal compliance: 100%

---

## 1.4 ขอบเขต (Scope)

### อยู่ในขอบเขต (In Scope - Phase 1)

- การจัดการพนักงาน 32 คน (29 payroll + 3 PC limited)
- Attendance ผ่าน LIFF, กะ, partial shift Hybrid B2+B3
- ลา **9 ประเภท** (ตาม Section 4.3)
- OT 1.5x, holiday variants, cap 36/สัปดาห์
- วันหยุดนักขัตฤกษ์ Model B1 (13 วัน, use-or-lose)
- Payroll Two-stage (วันที่ 1, 15, 16)
- ยื่นภาษี/ปกส. (ปกส., ภ.ง.ด.1, ภ.ง.ด.1ก, 50 ทวิ)
- Approval Workflow (3 ระดับ)
- แจ้งเตือน (LINE OA Basic, ช่วงเงียบ 22:00-08:00)
- Dashboard (6 มุมมอง)
- Audit Log (2 ปี)
- Document Management, PDPA, Prorated salary, Resignation checklist
- RBAC 6 roles

### นอกขอบเขต (Out of Scope - Future)

สรรหาบุคลากร, LMS, Performance review, Self-service portal, Native app, สวัสดิการนอกเหนือ SSO, AI analytics, Expense, Asset, Multi-company

### ยกเว้นเด็ดขาด

- ❌ The Pizza Company (Minor Food)
- ❌ Dairy Queen (Minor Food)
- ❌ Signature Clinic
- ❌ Nap's Coffee

---

## 1.5 สมมติฐานและความเสี่ยง

### สมมติฐาน

1. เฮียให้เวลา ~20 ชม./สัปดาห์ × 7 เดือน
2. นา + การ์ตูน + บอส เข้าร่วม Training
3. พนักงาน 29 คน (ไม่รวม PC + สังวาลย์) มี smartphone + LINE
4. Bluenote (POS) ยังใช้งานอยู่
5. ข้อบังคับการทำงาน update ก่อน launch
6. Legal consult สังวาลย์ ก่อน go-live

### 5 ความเสี่ยงสูงสุด

| # | ความเสี่ยง | ผลกระทบ | ความน่าจะเป็น | การจัดการ |
|---|-----------|---------|------------|---------|
| 1 | Legal ม.29 holiday forfeit | สูง (60-80K/ปี) | กลาง | ทนาย + update ข้อบังคับ |
| 2 | สังวาลย์ SSO fraud risk | สูง | กลาง | ทนายแรงงาน |
| 3 | เฮียงานยุ่ง → delay | กลาง | สูง | Buffer + phased |
| 4 | ใบอนุญาตเภสัชกรหมดอายุ | สูง | ต่ำ | Auto-alert 60 วัน |
| 5 | ข้อผิดพลาดการย้ายข้อมูล | กลาง | กลาง | Parallel run + rollback |

### ความเสี่ยงทางกฎหมายที่ยอมรับ

- Model B1 forfeit (ม.29) — 60-80K/ปี exposure
- Rotation shift (no fixed weekly off)
- สังวาลย์ active_no_payroll
- Pharmacist OT 150 บาท/ชม. (🔒 D17 — ปรึกษาทนายแล้ว ยืนยันตามสัญญาจ้าง)
- Supabase data residency US/EU — disclose ใน PDPA

---

## 1.6 Timeline (🔒 C-01 Fixed — align กับ Section 12)

### Milestones

| # | Milestone | เป้าหมาย | Deliverable |
|---|-----------|---------|------------|
| M0 | MRD Approved | พ.ค. 2569 | Full MRD sign-off |
| M1 | Foundation | พ.ค.–ก.ค. 2569 | Auth, employees, CC, LIFF login |
| M2 | Core Features | ส.ค.–ก.ย. 2569 | Attendance, Leave, OT, Payroll engine |
| M3 | Polish + QA | ต.ค. 2569 ⚠️ Compressed | Dashboard, Reports, Notifications, PDPA |
| M4 | UAT | พ.ย. 2569 (3 สัปดาห์) | Core team 11 คน |
| M5 | Parallel Run + Training | ธ.ค. 2569 | Humansoft + MYHR พร้อมกัน |
| M6 | Go/No-Go + Freeze | 28–31 ธ.ค. 2569 | Final decision + Humansoft freeze |
| M7 | **Go-Live** | **1 ม.ค. 2570** | แทน Humansoft |

> ⚠️ **Compressed Timeline:** M3 เหลือ 1 เดือน (ต.ค.) เพราะเลือก Go-Live 1 ม.ค. 2570 — ดู Risk Mitigation ใน Section 12.1.1

### Launch Strategy

- **Technical cutover (1 ม.ค. 2570):** วันหยุด — สลับระบบใน background
- **Operational go-live (2 ม.ค. 2570):** พนักงานเริ่มใช้ MYHR + War Room 1-7 ม.ค.
- **Humansoft read-only:** 6 เดือน (ม.ค.–มิ.ย. 2570)

---

## 1.7 เกณฑ์ Go/No-Go

**Launch: 1 ม.ค. 2570 — ต้องผ่านทั้งหมด**

- [ ] 29 คน payroll + 3 PC migrate ครบ (รวมเฮีย + ไนซ์ ที่ไม่อยู่ใน Humansoft)
- [ ] Payroll parallel run สำเร็จ
- [ ] LINE notifications >95% delivery
- [ ] Check-in/out ทุกสาขา
- [ ] นา + การ์ตูน + บอส ได้รับการอบรม
- [ ] Rollback plan จัดทำแล้ว
- [ ] ทุก feature ใน Phase 1 ทดสอบแล้ว
- [ ] Legal consult สังวาลย์ เสร็จ
- [ ] ข้อบังคับ update โดย lawyer
- [ ] PDPA verified

---

## 1.8 งบประมาณ (Budget)

### รายจ่ายประจำปี

| รายการ | บาท/ปี |
|--------|--------|
| Supabase Pro | 10,800 |
| LINE OA Basic | 16,435 |
| Domain (2 USD) | 70 |
| Claude API Haiku | 2,400 |
| Cloudflare/GitHub/Sentry | 0 |
| **รวม** | **29,705** |

### ค่าใช้จ่ายครั้งเดียว

| รายการ | บาท |
|--------|-----|
| Legal consult | 5,000–10,000 |
| Security audit (optional) | 5,000 |

### เปรียบเทียบต้นทุน

| Scenario | บาท/ปี |
|---------|--------|
| Humansoft | 51,253 |
| MYHR ปีที่ 1 | ~40,000 |
| MYHR ปีที่ 2+ | 29,705 |
| **ประหยัด/ปี** | **~21,548** |
| **5 ปี** | **~107,740** |

---

## 1.9 ผู้มีส่วนเกี่ยวข้อง

| Role | คน |
|------|-----|
| Owner | เฮีย (อมร) |
| Owner Delegate | ไนซ์ (ภรรยา) |
| Owner Delegate | จิว (น้องชาย) |
| HR Admin | การ์ตูน (MY07) |
| Finance | นา (MY16) |
| IT | บอส (MY25) |
| External | ทนายแรงงาน (TBD) |

---

## 1.10 Open Action Items

- [ ] หาทนายแรงงาน ก่อน go-live (critical)
- [ ] Verify hire dates: MY23 เดือน, สังวาลย์, เฮีย, ไนซ์
- [ ] Holiday Calendar 2570 (ก่อน 15 ธ.ค. 2569)

---

## 1.11 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | เฮีย (อมร) | ✅ 23 เม.ย. 2569 |
| Finance | นา | Pending |
| HR | การ์ตูน | Pending |
| Legal | TBD | Pending |

---

*Last updated: 25 เม.ย. 2569 | C-01 resolved (Timeline align กับ Section 12)*
