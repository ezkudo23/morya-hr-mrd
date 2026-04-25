# Section 1: บทสรุปผู้บริหาร (Executive Summary)

> **Notion ref**: https://www.notion.so/34c9e022ec8081669363ececbdb38222
> **Status**: ✅ Locked — 25 เม.ย. 2569

## 1.1 ภาพรวมโครงการ
- **ชื่อโครงการ:** Morya HR System (MYHR)
- **ประเภท:** Custom-built HRIS
- **กลุ่มเป้าหมาย:** พนักงาน บจก. หมอยาสุรินทร์ (33 คน รวม PC)

ระบบ HR สร้างเองครอบคลุม: เข้า-ออกงาน (Check-in/out), จัดกะ (Shift), ลา/OT, เงินเดือน (Payroll), ยื่นภาษี/ปกส. (Compliance), Dashboard — ใช้ LINE LIFF สำหรับพนักงาน + Admin Panel สำหรับหลังบ้าน ใช้แทน Humansoft Advance

## 1.2 บริบททางธุรกิจ

### ปัญหา (Pain Points)
1. **ข้อมูลไม่ sync** — 6 คน "Active" แต่ลาออกแล้ว
2. **ทำงานมือเยอะ** — Excel + LINE ส่วนตัว
3. **ขาด features** — commission, ใบอนุญาตเภสัชกร, ติดตาม PC
4. **ไม่เชื่อม LINE** — ไม่มี real-time dashboard
5. **เจ้าของข้อมูล** — อยู่บน vendor cloud

### Build Decision
- ✅ ปรับแต่งได้ 100%, ประหยัด 21,548/ปี, LINE-first, เป็นเจ้าของข้อมูล
- ⚠️ ต้นทุน: ~7 เดือน พัฒนา

## 1.3 ตัวชี้วัดความสำเร็จ

| Metric | ปัจจุบัน | เป้าหมาย (6 เดือน) |
|---|---|---|
| เวลาทำ Payroll | 16 ชม./เดือน | ≤ 4 ชม. |
| ความแม่นยำข้อมูล | 85% | 100% |
| เวลา Approval | 1-3 วัน | <24 ชม. |
| ข้อผิดพลาด Payroll | 1-2/ปี | 0 |
| ภาระงาน HR | Baseline | -30% |

## 1.4 ขอบเขต (Phase 1)

### In Scope
- Employee Management 33 คน (30 payroll + 3 PC)
- LIFF Check-in/out + GPS + Shifts
- การลา 9 ประเภท
- OT 1.5x, holiday variants, cap 36/สัปดาห์
- วันหยุดนักขัตฤกษ์ Model B1
- Payroll Two-stage (1, 15, 16)
- ภาษี/ปกส. (สปส.1-10, ภ.ง.ด.1, 50 ทวิ)
- Approval Workflow (3 ระดับ)
- LINE OA Notifications
- Dashboard (6 มุมมอง)
- Audit Log (Tier Model)
- PDPA, RBAC 6 roles

### Strictly Excluded
- ❌ The Pizza Company / Dairy Queen / Signature Clinic / Nap's Coffee

## 1.5 ความเสี่ยง 5 อันดับ

| # | ความเสี่ยง | ผลกระทบ | การจัดการ |
|---|---|---|---|
| 1 | Pharmacist OT 150 (D17) | สูง | ⚠️ Risk Accepted, Pending Legal |
| 2 | สังวาลย์ SSO fraud | สูง | ทนายแรงงาน |
| 3 | เฮียงานยุ่ง → delay | กลาง | Buffer + phased |
| 4 | ใบอนุญาตเภสัชกรหมดอายุ | สูง | Auto-alert 60 วัน |
| 5 | ข้อผิดพลาดการย้ายข้อมูล | กลาง | Parallel run + rollback |

## 1.6 Timeline

| # | Milestone | เป้าหมาย | Deliverable |
|---|---|---|---|
| M0 | MRD Approved | พ.ค. 2569 | Full sign-off |
| M1 | Foundation | มิ.ย. 2569 | Auth, employees, CC |
| M2 | Attendance + Shifts | ก.ค. 2569 | LIFF check-in/out |
| M3 | Leave + OT | ส.ค. 2569 | Approval workflow |
| M4 | Payroll Engine | ส.ค.-ก.ย. 2569 | Two-stage payroll |
| M5 | Compliance + Dashboard | ต.ค. 2569 | ยื่น ปกส./ภาษี + 6 dashboards |
| M6 | UAT | พ.ย. 2569 (3 สัปดาห์) | Core team 11 คน |
| M7 | Parallel Run + Training | ธ.ค. 2569 | รัน Humansoft + MYHR |
| M8 | Go/No-Go + Freeze | 28-31 ธ.ค. 2569 | Final + Humansoft freeze |
| M9 | **Go-Live** | **1 ม.ค. 2570** | แทน Humansoft |

### Launch Strategy
- **Technical cutover (1 ม.ค. 2570)**: วันหยุด — สลับระบบ background
- **Operational go-live (2 ม.ค. 2570)**: พนักงานเริ่มใช้ + War Room 1-7 ม.ค.
- **Humansoft read-only**: 6 เดือน (ม.ค.-มิ.ย. 2570) สำหรับยื่น ภ.ง.ด.1ก + 50 ทวิ ปี 2569

## 1.7 เกณฑ์ Go/No-Go (1 ม.ค. 2570)

- [ ] 33 พนักงาน migrate ครบ
- [ ] Payroll parallel run สำเร็จ
- [ ] LINE notifications > 95% delivery
- [ ] Check-in/out ทุกสาขา
- [ ] นา + การ์ตูน + บอส ได้รับการอบรม
- [ ] Rollback plan จัดทำแล้ว
- [ ] Legal consult สังวาลย์ + Pharmacist OT เสร็จ
- [ ] ข้อบังคับ update โดย lawyer
- [ ] PDPA verified

## 1.8 งบประมาณ

### รายจ่ายประจำปี
| รายการ | บาท/ปี |
|---|---|
| Supabase Pro | 10,800 |
| LINE OA Basic | 16,435 |
| Domain | 70 |
| Claude API Haiku | 2,400 |
| Cloudflare/GitHub/Sentry | 0 |
| **รวม** | **29,705** |

### ค่าใช้จ่ายครั้งเดียว
- Legal consult: 5,000-10,000
- Security audit (optional): 5,000

### เปรียบเทียบ
- Humansoft: 51,253/ปี
- MYHR ปีที่ 1: ~40,000
- MYHR ปีที่ 2+: 29,705
- **ประหยัด/ปี: ~21,548 (~107,740 ใน 5 ปี)**

## 1.9 Stakeholders

| Role | Name |
|---|---|
| Owner | เฮีย (อมร) |
| Owner Delegate 1 | ไนซ์ |
| Owner Delegate 2 / CEO | จิว (CEO02) |
| HR Admin | การ์ตูน (MY07) |
| Finance | นา (MY16) |
| IT | บอส (MY25) |
| External | ทนายแรงงาน (TBD) |

## 1.10 Open Items
- [ ] หาทนายแรงงาน — Critical
  - Pharmacist OT review (D17)
  - สังวาลย์ status review
  - ข้อบังคับการทำงาน update
- [ ] Holiday Calendar 2570 (Q4 2569)
- [ ] Verify hire dates: MY23, สังวาลย์, จำเนียร, เฮีย, ไนซ์

## 1.11 Sign-off

| Role | Name | Date |
|---|---|---|
| Owner | เฮีย (อมร) | ✅ 23 เม.ย. 2569 |
| Finance | นา | Pending |
| HR | การ์ตูน | Pending |
| Legal | TBD | Pending |
