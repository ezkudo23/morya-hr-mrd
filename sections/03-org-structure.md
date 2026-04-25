# Section 3: โครงสร้างองค์กร (Organization Structure)

*อัปเดต: 24 เม.ย. 2569*

---

## 3.1 แผนผังองค์กร (Org Chart)

```
                   👑 เฮีย (Owner)
                        │
       ┌────────────────┼────────────────┐
       ↓                ↓                ↓
  ไนซ์ (Delegate-HR)   จิว (Delegate-Strategic)
       │
       ↓
  การ์ตูน (HR Admin)
  นา (Finance Lead)
  บอส (IT Support)
       │
       ↓
5 Supervisors ─┬─ ติ๋ง (Warehouse, 6 คน)
               ├─ เมล์ + เดือน (Co-Sup HQ-WS, 8 คน)
               ├─ ค๊อป (สาขาปลีก HQ + PC, 6 คน)
               └─ จอย (สาขา 04, 3 คน)
       │
       ↓
 19 Staff (ปฏิบัติการ)
```

**รวม headcount: 33 คน** (30 คน run payroll + 3 PC reference)

> 📌 Single Source of Truth: Master Data section (employee headcount + roles)

---

## 3.2 Cost Center Structure (8 CC)

### Main Cost Centers (3 CC — สร้างรายได้)

#### CC-HQ-WS — ขายส่ง (Wholesale) HQ

| ข้อมูล | รายละเอียด |
|--------|-----------|
| สถานที่ | สำนักงานใหญ่ (Server 00) |
| พนักงาน | 8 คน |
| Supervisors | เมล์ (MY05) + เดือน (MY23) — Co-Supervisor Model |
| ลูกทีม | MY06, MY08, MY10, MY17, MY19, MY22 |
| GP target | 4–10% |
| ลูกค้า | B2B (ผ่าน morya.co.th — ต้อง approve user) |

#### CC-01 — ขายปลีก HQ

| ข้อมูล | รายละเอียด |
|--------|-----------|
| สถานที่ | สำนักงานใหญ่ (Server 01) |
| พนักงาน | 6 คน (3 Staff + 3 PC) |
| Supervisor | ค๊อป (MY14) — เภสัชกร + Supervisor |
| ลูกทีม | MY15, MY24 + PC01-03 |
| GP target | 30–40% |
| ลูกค้า | Walk-in retail |

#### CC-04 — ขายปลีก สาขา 04

| ข้อมูล | รายละเอียด |
|--------|-----------|
| สถานที่ | สาขา 3 (Server 04) |
| พนักงาน | 3 คน |
| Supervisor | จอย (MY11) — เภสัชกร + Supervisor |
| ลูกทีม | MY12, MY26 |
| GP target | 30–40% |
| ลูกค้า | Walk-in retail |

---

### Support Cost Centers (5 CC — ต้นทุนคงที่)

| CC | พนักงาน | รายละเอียด |
|----|---------|-----------|
| CC-SUPPORT-HR | 1 (การ์ตูน MY07) | การ์ตูนช่วยงาน FIN บางส่วน — คง primary CC ที่ HR |
| CC-SUPPORT-FIN | 3 | Finance Lead: นา (MY16); Assistants: ก้อย (MY02), แอ๊ด (MY21) |
| CC-SUPPORT-IT | 1 (บอส MY25) | — |
| CC-SUPPORT-WH | 6 | Supervisor: ติ๋ง (MY04); ลูกทีม: MY01, MY09, MY13, MY18, MY20 |
| CC-SUPPORT-FAC | 1 (จำเนียร) | แม่บ้าน / ดูแลสถานที่ |

---

## 3.3 การกระจายเภสัชกร (Pharmacist Coverage)

กฎหมาย: ต้องมีเภสัชกรประจำร้านขายยา

| ร้าน | เภสัชกร |
|------|---------|
| สำนักงานใหญ่ (Server 00 + 01) | ค๊อป (MY14) — ครอบทั้ง 2 server |
| สาขา 04 (Server 04) | จอย (MY11) |

⚠️ **Business Continuity Risk:** มีเภสัชกรแค่ 2 คน — ไม่มี backup — ถ้าลา/ป่วย/ลาออก ร้านต้องปิด — ต้องมี contingency plan (pending)

---

## 3.4 Product Consultants (PC) Structure

PC ไม่ใช่พนักงานของบริษัท — เป็น sponsored staff จาก vendor

| รหัส | ชื่อเล่น | Sponsor | ที่ประจำ |
|------|---------|---------|---------|
| PC01 | ชมพู่ | NBD | CC-01 |
| PC02 | ต่าย | Blackmores | CC-01 |
| PC03 | พลอย | Wellgate | CC-01 |

**ความสัมพันธ์:** ทำงานในร้าน แต่เงินเดือนจาก sponsor | Commission จาก Bluenote → MYHR (reference only) | อยู่ภายใต้ค๊อป | ❌ ไม่มี LINE LIFF | ❌ ไม่ต้อง check-in/out

---

## 3.5 Rotation Shift Model

```
📅 Rotation: 9 ชม. × 6 วัน/สัปดาห์
   ├── ไม่มีวันหยุดประจำสัปดาห์คงที่
   ├── หมุนเวียนตาม schedule
   └── Supervisor กำหนดตาราง

ชั่วโมงทำงาน:
   ├── 9 ชม./วัน รวมพัก 1 ชม.
   ├── Effective work: 8 ชม./วัน
   └── 48 ชม./สัปดาห์ (ตามกฎหมาย)
```

### ข้อยกเว้น (Exempt from Time Attendance)

- 👑 Owner (เฮีย) — ระดับ Director
- 👑 Owner Delegates (ไนซ์, จิว) — ระดับ Director

---

## 3.6 Supervisor Hierarchy

### Approval Chain

| วันลา/OT | Chain |
|---------|-------|
| ≤ 3 วัน | Supervisor |
| 4–7 วัน | Supervisor → HR Admin |
| 8+ วัน | Supervisor → HR Admin → Owner/Delegate |

### Supervisor → Team Mapping

| Supervisor | Cost Center | ลูกทีม |
|-----------|------------|--------|
| ติ๋ง (MY04) | CC-SUPPORT-WH | MY01, MY09, MY13, MY18, MY20 |
| เมล์ (MY05) + เดือน (MY23) | CC-HQ-WS | MY06, MY08, MY10, MY17, MY19, MY22 |
| ค๊อป (MY14) | CC-01 | MY15, MY24, PC01-03 |
| จอย (MY11) | CC-04 | MY12, MY26 |

---

## 3.7 Special Roles

### เภสัชกร (Pharmacist) — Dual Role

จอย (MY11) + ค๊อป (MY14) ทำ 2 หน้าที่พร้อมกัน:
1. **Supervisor** — บริหารทีมในสาขา
2. **เภสัชกร** — ให้คำปรึกษา + ขาย + legal compliance

**OT Rate พิเศษ:** 150 บาท/ชม. (fix — ไม่ใช่ 1.5x)  
⚠️ **Flag D17:** อาจต่ำกว่า 1.5x legal minimum — รอทนายตรวจ | Risk Accepted โดย Owner

### Co-Supervisor Model (เมล์ + เดือน)

- CC-HQ-WS มีพนักงาน 8 คน → ใหญ่เกินกว่า Supervisor คนเดียว
- สิทธิ์เท่าเทียม (Equal authority)
- ใครว่างก่อน approve ก่อน (first come first served)
- Audit log ระบุชื่อคน approve

---

## 3.8 Special Status: สังวาลย์

| ข้อมูล | รายละเอียด |
|--------|-----------|
| สถานะ | active_no_payroll |
| เงินเดือน | ไม่มี |
| ปกส. | บริษัทจ่าย contribution 8,000 บาท/ปี |
| สิทธิ์เข้าถึง | ไม่มี |

⚠️ **สถานะทางกฎหมาย: รอปรึกษาทนาย**

---

## 3.9 Employee Master Summary

| Cost Center | จำนวน | หมายเหตุ |
|------------|-------|---------|
| CC-HQ-WS | 8 | Main — ขายส่ง (6 Staff + 2 Co-Sup) |
| CC-01 | 6 | Main — ขายปลีก HQ (1 Sup + 2 Staff + 3 PC) |
| CC-04 | 3 | Main — สาขา 04 (1 Sup + 2 Staff) |
| CC-SUPPORT-HR | 1 | Support (การ์ตูน) |
| CC-SUPPORT-FIN | 3 | Support (นา + ก้อย + แอ๊ด) |
| CC-SUPPORT-IT | 1 | Support (บอส) |
| CC-SUPPORT-WH | 6 | Support (ติ๋ง Sup + 5 Staff) |
| CC-SUPPORT-FAC | 1 | Support (จำเนียร) |
| Director (exempt) | 3 | Owner + 2 Delegates |
| Special status | 1 | สังวาลย์ |
| **รวม** | **33** | **(ไม่รวม PC 3 คน = 30 payroll)** |

---

## 3.10 Open Action Items

- [ ] Verify supervisor-team mapping ใน M1
- [ ] Business continuity plan สำหรับเภสัชกร (2 คน no backup)
- [ ] ขออีเมล/เบอร์เภสัชกร + license number + expiry
- [ ] Legal consult สถานะสังวาลย์ active_no_payroll
- [ ] Verify hire dates: MY23 เดือน, สังวาลย์, จำเนียร, เฮีย, ไนซ์

---

## 3.11 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | เฮีย | Pending |
| HR Admin | การ์ตูน | Pending |
| Legal | TBD | Pending |

---

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked*
