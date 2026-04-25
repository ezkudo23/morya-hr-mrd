# Section 3: โครงสร้างองค์กร (Organization Structure)

*อัปเดต: 25 เม.ย. 2569*

---

## 3.1 แผนผังองค์กร (Org Chart)

```
                   👑 เฮีย (Owner)
                        │
       ┌────────────────┼────────────────┐
       ↓                ↓
  ไนซ์ (Delegate-HR)   จิว (Delegate-Strategic)
       │
       ↓
  การ์ตูน (HR Admin)
  นา (Finance)
  บอส (IT Support)
       │
       ↓
5 Supervisors ─┬─ ติ๋ง (Warehouse, 5 คน)
               ├─ เมล์ + เดือน (Co-Sup HQ-WS, 6 คน)
               ├─ ค๊อป (ขายปลีก HQ + PC, 5 คน)
               └─ จอย (สาขา 04, 2 คน)
       │
       ↓
 20 Staff (ปฏิบัติการ)
```

**รวม headcount: 32 คน** (29 คน run payroll + 3 PC reference)

> 📌 Single Source of Truth: Master Data (Official Headcount & Roles)

---

## 3.2 Cost Center Structure (8 CC)

### Main Cost Centers (3 CC — สร้างรายได้)

#### CC-HQ-WS — ขายส่ง (Wholesale) HQ

| ข้อมูล | รายละเอียด |
|--------|-----------|
| สถานที่ | สำนักงานใหญ่ (Server 00) |
| พนักงาน | 8 คน |
| Supervisors | เมล์ (MY05) + เดือน (MY23) — Co-Supervisor |
| ลูกทีม | MY06, MY08, MY10, MY17, MY19, MY22 |
| GP target | 4–10% |
| ลูกค้า | B2B (morya.co.th — ต้อง approve user) |

#### CC-01 — ขายปลีก HQ

| ข้อมูล | รายละเอียด |
|--------|-----------|
| สถานที่ | สำนักงานใหญ่ (Server 01) |
| พนักงาน | 5 คน (2 Staff + 3 PC) |
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

---

### Support Cost Centers (5 CC — ต้นทุนคงที่)

| CC | พนักงาน | รายละเอียด |
|----|---------|-----------|
| CC-SUPPORT-HR | 1 (การ์ตูน MY07) | HR Admin primary |
| CC-SUPPORT-FIN | 3 | นา (MY16), ก้อย (MY02), แอ๊ด (MY21) |
| CC-SUPPORT-IT | 1 (บอส MY25) | IT Support |
| CC-SUPPORT-WH | 5 | ติ๋ง (MY04) Sup + MY01, MY09, MY13, MY18, MY20 |
| CC-SUPPORT-FAC | **0 คน** (CC ยังคงอยู่) | ⚠️ จำเนียรออกแล้ว (จ้างนอกระบบ) — CC เผื่ออนาคต |

---

## 3.3 การกระจายเภสัชกร

| ร้าน | เภสัชกร |
|------|---------|
| HQ (Server 00 + 01) | ค๊อป (MY14) |
| สาขา 04 | จอย (MY11) |

⚠️ **Risk:** มีเภสัชกรแค่ 2 คน ไม่มี backup — ถ้าลา/ป่วย/ลาออก ร้านต้องปิด — ต้องมี contingency plan (pending)

---

## 3.4 Product Consultants (PC) Structure

PC ไม่ใช่พนักงานของบริษัท — เป็น sponsored staff จาก vendor

| รหัส | ชื่อเล่น | Sponsor | ที่ประจำ |
|------|---------|---------|---------|
| PC01 | ชมพู่ | NBD | CC-01 |
| PC02 | ต่าย | Blackmores | CC-01 |
| PC03 | พลอย | Wellgate | CC-01 |

- ทำงานในร้าน เงินเดือนจาก sponsor
- ✅ มี check-in/out (ติดตาม sponsor)
- ⚡ LIFF access จำกัด (self-attendance only)
- อยู่ใต้ค๊อป (Supervisor)

---

## 3.5 Rotation Shift Model

```
9 ชม./วัน รวมพัก 1 ชม. (ทำงานจริง 8 ชม.)
หมุนเวียน — ไม่มีวันหยุดประจำสัปดาห์คงที่
48 ชม./สัปดาห์ (ตามกฎหมาย)
```

**Exempt:** เฮีย, ไนซ์, จิว (Director/Executive — ไม่ต้อง check-in)

---

## 3.6 Supervisor Hierarchy

### Approval Chain

| วันลา/OT | Chain |
|---------|-------|
| ≤ 3 วัน | Supervisor |
| 4–7 วัน | Supervisor → HR Admin |
| 8+ วัน | Supervisor → HR Admin → Owner |

### Supervisor → Team Mapping

| Supervisor | Cost Center | ลูกทีม |
|-----------|------------|--------|
| ติ๋ง (MY04) | CC-SUPPORT-WH | MY01, MY09, MY13, MY18, MY20 |
| เมล์ (MY05) + เดือน (MY23) | CC-HQ-WS | MY06, MY08, MY10, MY17, MY19, MY22 |
| ค๊อป (MY14) | CC-01 | MY15, MY24, PC01-03 |
| จอย (MY11) | CC-04 | MY12, MY26 |

---

## 3.7 Special Roles

### เภสัชกร — Dual Role

จอย + ค๊อป ทำ 2 หน้าที่: Supervisor + เภสัชกร

**OT Rate:** 150 บาท/ชม. (fix) — 🔒 D17 Owner accepts legal risk (ปรึกษาทนายแล้ว)

### Co-Supervisor (เมล์ + เดือน)

8 คนใน CC-HQ-WS ใหญ่เกินกว่า Supervisor คนเดียว → สิทธิ์เท่าเทียม, ใครว่างก่อน approve ก่อน

---

## 3.8 Special Status: สังวาลย์

| สถานะ | active_no_payroll |
|-------|-----------------|
| เงินเดือน | ไม่มี |
| ปกส. | บริษัทจ่าย contribution 8,000 บาท/ปี |
| สิทธิ์เข้าถึง | ไม่มี |

⚠️ **สถานะทางกฎหมาย: รอปรึกษาทนาย**

---

## 3.9 Employee Master Summary

| Cost Center | จำนวน | หมายเหตุ |
|------------|-------|---------|
| CC-HQ-WS | 8 | 2 Co-Sup + 6 Staff |
| CC-01 | 5 | 1 Sup + 2 Staff + 3 PC |
| CC-04 | 3 | 1 Sup + 2 Staff |
| CC-SUPPORT-HR | 1 | การ์ตูน |
| CC-SUPPORT-FIN | 3 | นา + ก้อย + แอ๊ด |
| CC-SUPPORT-IT | 1 | บอส |
| CC-SUPPORT-WH | 5 | ติ๋ง Sup + 5 Staff → รวม 6 แต่ 1 = ติ๋ง Sup |
| CC-SUPPORT-FAC | 0 | จำเนียรออกแล้ว (จ้างนอกระบบ) — CC ยังคงอยู่ |
| Director (exempt) | 3 | เฮีย + ไนซ์ + จิว |
| Special status | 1 | สังวาลย์ |
| **รวม** | **29** | **(ไม่รวม PC 3 คน = 29 payroll, 32 total in system)** |

---

## 3.10 Open Action Items

- [ ] Verify supervisor-team mapping ใน M1
- [ ] Business continuity plan เภสัชกร (2 คน no backup)
- [ ] License number + expiry ของเภสัชกรทั้ง 2 คน
- [ ] Legal consult สังวาลย์ active_no_payroll
- [ ] Verify hire dates: MY23, สังวาลย์, เฮีย, ไนซ์

---

## 3.11 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | เฮีย | Pending |
| HR Admin | การ์ตูน | Pending |
| Legal | TBD | Pending |

---

*Last updated: 25 เม.ย. 2569 | จำเนียรออก (จ้างนอกระบบ), headcount 32 total / 29 payroll*
