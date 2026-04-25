# Section 8: ระบบแจ้งเตือน (Notification System)

*ออกแบบระบบแจ้งเตือนผ่าน LINE OA + LIFF | อัปเดตล่าสุด: 24 เม.ย. 2569*

> ระบบแจ้งเตือนช่วยให้พนักงานและผู้บริหารได้รับข้อมูลสำคัญในเวลาที่เหมาะสม  
> หลักการ: **ส่งเฉพาะข้อมูลที่มีคุณค่า ไม่สร้าง notification fatigue**

---

## 8.1 ช่องทางการแจ้งเตือน (Notification Channels)

### ช่องทางหลัก: LINE OA "หมอยาสุรินทร์ HR"

- Push Message (ส่งหาพนักงานทีละคน)
- Broadcast (ส่งหากลุ่ม/ทุกคน)
- Reply Message (ตอบกลับเมื่อพนักงานส่งคำสั่ง)
- LIFF Notification (แจ้งเตือนในแอป)

**Plan:** LINE OA Basic — 16,435 บาท/ปี | **Quota:** 15,000 ข้อความ/เดือน

### ช่องทางสำรอง

- In-app LIFF: Badge counter + Notification center (ดูประวัติได้)
- Email (Phase 2): ส่ง Payslip (ทางเลือก)

---

## 8.2 ประเภทการแจ้งเตือน (Notification Types)

### ระดับความสำคัญ: 4 ระดับ

**🔴 Critical — ส่งทันทีแม้ในช่วงเงียบ**
- บังคับดำเนินการ Payroll (Force Proceed)
- ปลดล็อกฉุกเฉิน (Emergency Unlock)
- ใบอนุญาตเภสัชกรจะหมดอายุ < 7 วัน
- ความปลอดภัย — login ผิด 5+ ครั้ง

**🟠 High — ส่งทันที (ยกเว้นช่วงเงียบ)**
- ลา/OT ได้รับการอนุมัติ/ปฏิเสธ
- ระบบปิดเวลาเข้างานอัตโนมัติ (auto-closed check-in)
- Token ชดเชยวันหยุดจะหมดอายุ 3 วัน
- Payslip เดือนนี้ออกแล้ว

**🟡 Medium — ส่งตามเวลาทำงาน**
- สรุปรายวันหัวหน้างาน (Daily Digest 09:30)
- โควตาลาเหลือน้อย (< 20%)
- ได้รับ Token ชดเชยวันหยุด

**🟢 Low — ส่งในเวลาทำงานปกติ**
- คำอวยพรวันเกิด
- ประกาศบริษัท
- ต้อนรับพนักงานใหม่

---

## 8.3 กรณีที่ **ไม่ส่ง** แจ้งเตือน

### หลักการ: ไม่ส่งข้อความที่ผลักภาระความรับผิดชอบของพนักงาน

**ไม่ส่ง Shift Reminder ปกติ** — เหตุผล:
- การมาทำงานตรงเวลาเป็นหน้าที่พนักงาน
- ป้องกันวัฒนธรรม "ระบบเตือนแล้วค่อยไป"
- ประหยัดโควตา LINE ~870 ข้อความ/เดือน (5.8%)
- Notification ที่ส่ง = มีคุณค่าจริง

ไม่ส่ง: "อย่าลืมทำหน้าที่ของคุณ" | "พรุ่งนี้มาทำงานนะ" | "วันนี้ร้านเปิดปกติ"

### ข้อยกเว้น: ส่ง Shift Reminder เฉพาะกรณีพิเศษ

**1) Rotation Change:** กะเปลี่ยน → แจ้งครั้งเดียว (วันแรกของกะใหม่)

**2) Holiday Override (วันหยุดพลิกจากปิดเป็นเปิด):**
- แจ้ง: "วันที่ 30 ธ.ค. ร้านเปิดพิเศษ — คุณมีกะ 09:00–18:00"
- ส่งล่วงหน้า 3 วัน

### Logic การตัดสินใจ

```typescript
function shouldSendShiftReminder(shift: Shift): boolean {
  // กรณี 1: Shift rotation change
  if (shift.isFirstDayOfNewRotation) return true;

  // กรณี 2: Holiday พลิกจาก closed → open
  if (shift.date.isHoliday &&
      shift.date.normallyClosed &&
      shift.date.isOpenException) {
    return true;
  }

  // Default: ไม่ส่ง
  return false;
}
```

---

## 8.4 ช่วงเงียบ (Quiet Hours)

**เวลา: 22:00 – 08:00 (เวลาประเทศไทย)**

| ระดับ | นโยบาย |
|-------|--------|
| 🔴 Critical | ส่งทันที (override ช่วงเงียบ) |
| 🟠 High | รอส่งเวลา 08:00 วันถัดไป |
| 🟡 Medium | รอส่งเวลา 08:00 วันถัดไป |
| 🟢 Low | รอส่งเวลา 09:00 วันทำการ |

**วันหยุด:** เสาร์–อาทิตย์และนักขัตฤกษ์ปฏิบัติเหมือนช่วงเงียบ — ยกเว้น Critical + ข้อยกเว้น shift reminder (ร้านยาเปิดเสาร์–อาทิตย์)

---

## 8.5 การจัดการโควตา (Quota Management)

### ประมาณการการใช้งาน

| ประเภท | จำนวน/เดือน |
|--------|------------|
| Approvals (ลา/OT) | ~300 ข้อความ |
| Payslip release | 30 ข้อความ |
| Daily digest supervisor | 5 × 30 = 150 ข้อความ |
| Token notifications | ~50 ข้อความ |
| Announcements | ~100 ข้อความ |
| Critical alerts | ~20 ข้อความ |
| **รวม** | **~650–800 ข้อความ/เดือน** ✅ |

**Quota เหลือ:** ~14,200 ข้อความ (94.7% buffer)

### ระบบเตือนโควตา

- แจ้ง Owner เมื่อใช้ 70% (10,500)
- แจ้ง Owner เมื่อใช้ 90% (13,500)
- Rate limit: สูงสุด 50 ข้อความ/คน/วัน (กัน spam)
- Batch digest (รวมเป็นข้อความเดียว)

---

## 8.6 เทมเพลตข้อความ (Content Templates)

### ลาได้รับอนุมัติ (Leave Approved)

```
✅ ลาได้รับอนุมัติ

ประเภท: ลาพักร้อน
วันที่: 25–27 ต.ค. 2569 (3 วัน)
อนุมัติโดย: พี่ค๊อป

[ดูรายละเอียด]
```

### Payslip ออก (Payslip Released)

```
💰 Payslip เดือน ต.ค. 2569 พร้อมแล้ว

เงินสุทธิ: 18,450 บาท
โอนเข้าบัญชีภายใน 1 วัน

[ดู Payslip] [ดาวน์โหลด]
```

### ใบอนุญาตเภสัชกรใกล้หมดอายุ

```
🚨 แจ้งเตือน: ใบประกอบวิชาชีพเภสัชกร

จะหมดอายุใน 60 วัน
วันหมดอายุ: 25 ธ.ค. 2569
สิ่งที่ต้องทำ: ต่ออายุใบอนุญาต

[ดูรายละเอียด]
```

### สรุปรายวันหัวหน้างาน (Daily Digest 09:30)

```
☀️ สรุปวันนี้ — 25 ต.ค. 2569

📋 งานค้างอนุมัติ (3):
├── ลาพักร้อน 2 วัน - MY13 นัด
├── OT 4 ชม. - MY18 ตอม
└── Correction - MY15 ปิง

📊 สรุปเมื่อวาน:
├── Check-in ครบ: 8/8 คน
├── OT ที่อนุมัติ: 6 ชม.
└── ลาที่อนุมัติ: 1 คน

[ไปอนุมัติ]
```

### Holiday Override Shift Reminder

```
📅 แจ้งเตือน: วันนี้ร้านเปิดพิเศษ

วันที่ 30 ธ.ค. 2569 (วันหยุดสิ้นปี)
ปกติร้านปิด → ตกลงเปิดพิเศษ

กะของคุณ: 09:00–18:00
อัตราค่าแรง: 2.0x (Holiday Changed)

[ดูตาราง]
```

---

## 8.7 การตั้งค่าผู้ใช้ (User Preferences)

เข้าผ่าน: LIFF → Settings → การแจ้งเตือน

**เปิด/ปิดได้:**
- อนุมัติลา/OT
- Payslip
- ประกาศบริษัท
- คำอวยพรวันเกิด
- Token notifications
- ช่วงเงียบส่วนบุคคล (กำหนดเวลาเองได้)

**ปิดไม่ได้:**
- 🔴 Critical alerts
- 💰 Payroll notifications
- 💊 License expiry (เฉพาะเภสัชกร)
- 📅 Shift reminder (ข้อยกเว้น)

---

## 8.8 การประกาศบริษัท (Announcement Broadcasting)

### สิทธิ์การส่งประกาศ

**ส่งได้:** Owner (เฮีย) | Owner Delegates (ไนซ์, จิว) | HR Admin (การ์ตูน)

**ส่งไม่ได้:** Finance | IT Support | Supervisors | Staff

### ประเภทการประกาศ

| ประเภท | สิทธิ์ | ผู้รับ | โควตา | ข้อจำกัด |
|--------|-------|--------|-------|---------|
| ทั่วบริษัท | Owner + Delegates | ทุกคน 33 คน | 33 ข้อความ | สูงสุด 10 ครั้ง/เดือน |
| Payroll | Owner + Delegates + Finance + HR | 30 คน (payroll) | 30 ข้อความ | — |
| แผนก/สาขา | Owner + Delegates + HR | สมาชิกแผนก | — | สูงสุด 20 ครั้ง/เดือน |

### Flow การส่งประกาศ

```
Owner/Delegate/HR → Admin Panel → "ส่งประกาศ"
   │
   ▼
กรอกฟอร์ม:
├── ประเภท
├── หัวข้อ + เนื้อหา
├── เวลาส่ง: ทันที / กำหนดเวลา
└── Priority
   │
   ▼
Preview → Confirm → ส่งออก + Audit log
```

---

## 8.9 Webhook & Reply API

### LINE Webhook Events

| Event | Action |
|-------|--------|
| follow | ส่งต้อนรับ + LIFF link |
| unfollow | Flag "line_disconnected" |
| message | Reply API ตอบคำสั่ง |
| postback | Handle quick actions |

### Reply Commands

| Command | Response |
|---------|---------|
| `/payslip` | Payslip ล่าสุด + เงินสุทธิ + link |
| `/leave` | ปุ่มเปิด LIFF ขอลา |
| `/ot` | ปุ่มเปิด LIFF ขอ OT |
| `/quota` | โควตาลาคงเหลือ |
| `/help` | รายการคำสั่งทั้งหมด |

---

## 8.10 Notification Log & Retention

### Retention Policy
- เก็บ: 1 ปี (สอดคล้อง Audit Level 1)
- หลังครบกำหนด: hard delete อัตโนมัติ
- Legal hold: freeze ได้ถ้าจำเป็น

### Data Schema

```typescript
type NotificationLog = {
  id: string;
  type: 'critical' | 'high' | 'medium' | 'low';
  category: string;

  recipient: {
    user_id: string;
    line_user_id: string;
  };

  content: {
    template_id: string;
    variables: Record<string, any>;
    rendered_text: string;
  };

  delivery: {
    status: 'queued' | 'sent' | 'failed' | 'read';
    queued_at: Date;
    sent_at?: Date;
    read_at?: Date;
    failure_reason?: string;
  };

  retention_until: Date;
  created_at: Date;
};
```

### สถิติ (Dashboard สำหรับ Owner/HR)

- จำนวนข้อความส่ง/เดือน
- อัตราการอ่าน (read rate)
- อัตราการตอบสนอง (response rate)
- ข้อความที่ส่งไม่สำเร็จ (failed delivery)
- การใช้โควตา LINE OA (% ของ 15,000)

---

## 8.11 สรุปการตัดสินใจสำคัญ

| หัวข้อ | การตัดสินใจ |
|--------|-----------|
| ช่องทางหลัก | LINE OA Basic (15,000 msg/เดือน) |
| Shift reminder ปกติ | ❌ ไม่ส่ง |
| Shift reminder ยกเว้น | Rotation change + Holiday พลิกเปิด |
| Daily digest supervisor | 09:30 — Pending + สรุปเมื่อวาน |
| Payslip timing | วันที่ 16 เที่ยง (หลัง Owner อนุมัติ) |
| Quiet hours | 22:00–08:00 (Critical override ได้) |
| ประกาศทั่วบริษัท | Owner + Delegates + HR Admin |
| Rate limit | 50 msg/คน/วัน |
| Log retention | 1 ปี (ตาม Audit Level 1) |

---

## 8.12 Open Items

- [ ] Design LINE OA Rich Menu (4–6 quick actions)
- [ ] Create welcome message template (first-time users)
- [ ] Define announcement moderation process
- [ ] Test LINE webhook reliability (M2)
- [ ] Implement notification preferences UI (M3)
- [ ] Setup quota monitoring dashboard (M4)

---

## 8.13 Sign-off

| Role | Name | Date |
|------|------|------|
| Owner | อมร | Pending |
| Owner Delegate | ไนซ์ | Pending |
| HR Admin | การ์ตูน | Pending |
| IT Support | บอส | Pending |

---

*Last updated: 24 เม.ย. 2569 | Status: ✅ Locked*
