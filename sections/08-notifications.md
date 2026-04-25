# Section 8: ระบบแจ้งเตือน (Notification System) 8️⃣

*อัปเดต: 25 เม.ย. 2569*

> หลักการ: **ส่งเฉพาะข้อมูลที่มีคุณค่า ไม่สร้าง notification fatigue**

---

## 8.1 ช่องทาง (Notification Channels)

**ช่องทางหลัก: LINE OA "หมอยาสุรินทร์ HR"**
- Push Message (รายบุคคล)
- Broadcast (กลุ่ม/ทุกคน)
- Reply Message (ตอบคำสั่ง)
- LIFF Notification (in-app)

**Plan:** LINE OA Basic — 16,435 บาท/ปี | **Quota:** 15,000 ข้อความ/เดือน

**ช่องทางสำรอง:** In-app LIFF badge + Notification center | Email (Phase 2)

---

## 8.2 ประเภทการแจ้งเตือน

### 🔴 Critical — ส่งทันทีแม้ในช่วงเงียบ
- บังคับดำเนินการ Payroll (Force Proceed)
- Emergency Unlock
- ใบอนุญาตเภสัชกรจะหมดอายุ < 7 วัน
- Login ผิด 5+ ครั้ง

### 🟠 High — ส่งทันที (ยกเว้นช่วงเงียบ)
- ลา/OT ได้รับการอนุมัติ/ปฏิเสธ
- Auto-closed check-in
- Token จะหมดอายุ 3 วัน
- Payslip เดือนนี้ออกแล้ว

### 🟡 Medium — ส่งตามเวลาทำงาน
- **สรุปรายวันหัวหน้างาน (Daily Digest 09:00)** ← C-12 Fixed
- โควตาลาเหลือน้อย (< 20%)
- ได้รับ Token ชดเชยวันหยุด

### 🟢 Low — ส่งในเวลาทำงาน
- คำอวยพรวันเกิด
- ประกาศบริษัท
- ต้อนรับพนักงานใหม่

---

## 8.3 กรณีที่ **ไม่ส่ง** แจ้งเตือน

**ไม่ส่ง Shift Reminder ปกติ** — เหตุผล: การมาทำงานตรงเวลาเป็นหน้าที่พนักงาน, ป้องกันวัฒนธรรม "ระบบเตือนแล้วค่อยไป", ประหยัดโควตา

**ส่ง Shift Reminder เฉพาะกรณีพิเศษ:**

1. Rotation Change (กะเปลี่ยนสัปดาห์ใหม่)
2. Holiday Override (วันหยุดพลิกจากปิดเป็นเปิด) — ส่งล่วงหน้า 3 วัน

```typescript
function shouldSendShiftReminder(shift: Shift): boolean {
  if (shift.isFirstDayOfNewRotation) return true;
  if (shift.date.isHoliday && shift.date.normallyClosed && shift.date.isOpenException) {
    return true;
  }
  return false;
}
```

---

## 8.4 ช่วงเงียบ (Quiet Hours)

**เวลา: 22:00–08:00 (เวลาประเทศไทย)**

| ระดับ | นโยบาย |
|-------|--------|
| 🔴 Critical | ส่งทันที (override) |
| 🟠 High | รอ 08:00 วันถัดไป |
| 🟡 Medium | รอ 08:00 วันถัดไป |
| 🟢 Low | รอ 09:00 วันทำการ |

วันหยุด/นักขัตฤกษ์: ปฏิบัติเหมือนช่วงเงียบ ยกเว้น Critical

---

## 8.5 การจัดการโควตา

**Quota:** 15,000 ข้อความ/เดือน

| ประเภท | ประมาณ/เดือน |
|--------|------------|
| Approvals (ลา/OT) | ~300 |
| Payslip | 29 |
| Daily digest (5 Sup × 30 วัน) | ~150 |
| Token notifications | ~50 |
| Announcements + Critical | ~120 |
| **รวม** | **~650–800** ✅ |

**Buffer: ~94% เหลือ** | Rate limit: 50 msg/คน/วัน | Alert ที่ 70% และ 90%

---

## 8.6 เทมเพลตข้อความ

### ลาได้รับอนุมัติ
```
✅ ลาได้รับอนุมัติ
ประเภท: ลาพักร้อน
วันที่: 25-27 ต.ค. 2569 (3 วัน)
อนุมัติโดย: พี่ค๊อป
[ดูรายละเอียด]
```

### Payslip ออก
```
💰 Payslip เดือน ต.ค. 2569 พร้อมแล้ว
เงินสุทธิ: 18,450 บาท
[ดู Payslip] [ดาวน์โหลด]
```

### ใบอนุญาตเภสัชกรใกล้หมดอายุ
```
🚨 ใบประกอบวิชาชีพเภสัชกรจะหมดอายุใน 60 วัน
วันหมดอายุ: 25 ธ.ค. 2569
[ดูรายละเอียด]
```

### Daily Digest Supervisor (09:00) ← C-12 Fixed
```
☀️ สรุปวันนี้ — 25 ต.ค. 2569 (ส่งเวลา 09:00)

📋 งานค้างอนุมัติ (3):
├── ลาพักร้อน 2 วัน — MY13 นัด
├── OT 4 ชม. — MY18 ต้อม
└── Correction — MY15 ปิง

📊 สรุปเมื่อวาน:
├── Check-in ครบ: 8/8 คน
└── OT อนุมัติ: 6 ชม.

[ไปอนุมัติ]
```

---

## 8.7 User Preferences

**เปิด/ปิดได้:** อนุมัติลา/OT | Payslip | ประกาศ | วันเกิด | Token | Quiet hours ส่วนตัว

**ปิดไม่ได้:** 🔴 Critical | 💰 Payroll | 💊 License expiry | 📅 Shift reminder (ข้อยกเว้น)

---

## 8.8 Announcement Broadcasting

**ส่งได้:** Owner | Delegates | HR Admin

| ประเภท | Authorized | ผู้รับ | จำกัด |
|--------|-----------|--------|-------|
| ทั่วบริษัท | Owner + Delegates | ทุกคน 32 คน | 10 ครั้ง/เดือน |
| Payroll | Owner + Delegates + Finance + HR | 29 คน | — |
| แผนก/สาขา | Owner + Delegates + HR | สมาชิกแผนก | 20 ครั้ง/เดือน |

---

## 8.9 Webhook & Reply Commands

| Command | Response |
|---------|---------|
| `/payslip` | Payslip ล่าสุด + เงินสุทธิ |
| `/leave` | ปุ่มเปิด LIFF ขอลา |
| `/ot` | ปุ่มเปิด LIFF ขอ OT |
| `/quota` | โควตาลาคงเหลือ |
| `/help` | รายการคำสั่งทั้งหมด |

**Webhook Events:** follow → ต้อนรับ + LIFF link | unfollow → flag | message → Reply | postback → Quick actions

---

## 8.10 Log & Retention

- เก็บ 1 ปี (ตาม Audit Level 1) → hard delete อัตโนมัติ
- Legal hold: freeze ได้ถ้าจำเป็น

---

## 8.11 สรุปการตัดสินใจสำคัญ

| หัวข้อ | การตัดสินใจ |
|--------|-----------|
| ช่องทางหลัก | LINE OA Basic (15,000 msg/เดือน) |
| Shift reminder ปกติ | ❌ ไม่ส่ง |
| Shift reminder ยกเว้น | Rotation change + Holiday พลิกเปิด |
| **Daily digest supervisor** | **09:00** ← C-12 Fixed |
| Payslip timing | วันที่ 16 หลัง Owner อนุมัติ |
| Quiet hours | 22:00–08:00 (Critical override) |
| ประกาศทั่วบริษัท | Owner + Delegates + HR Admin |
| Rate limit | 50 msg/คน/วัน |
| Log retention | 1 ปี |

---

## 8.12 Open Items

- [ ] Design LINE OA Rich Menu (4–6 quick actions)
- [ ] Create welcome message template
- [ ] Test LINE webhook reliability (M2)
- [ ] Implement notification preferences UI (M3)
- [ ] Setup quota monitoring dashboard (M4)

---

## 8.13 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | อมร | Pending |
| Delegate | ไนซ์ | Pending |
| HR Admin | การ์ตูน | Pending |
| IT | บอส | Pending |

---

*Last updated: 25 เม.ย. 2569 | C-12 resolved (Daily Digest = 09:00)*
