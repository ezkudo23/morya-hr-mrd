# 🚨 Conflicts & Issues Registry

> Resolution status of all critical conflicts and audit issues.
> ✅ All 15 critical conflicts resolved.
> ✅ D17 Legal Reviewed (26 เม.ย. 2569) — Risk Accepted confirmed.
> 📝 C16 (Shift Management) drafted v2 (2 พ.ค. 2569) — V2 fix + Coverage Alert unified.
> 📅 1 deferred (Holiday Calendar 2570 — Q4 2569).

**Last Updated**: 2 พ.ค. 2569
**Status**: ✅ All actionable conflicts resolved — Dev sprint Shift Management starting

---

## ✅ RESOLVED CONFLICTS (16/16)

### Batch 1-2 (Foundation)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C1 | Employee count | 32 in system, 29 payroll, 28 attendance | D1 |
| C2 | Go-Live date | 1 ม.ค. 2570 | D2 |
| C12 | Finance Lead → Finance | Single Finance person (นา) | D4 |
| C15 | Section 1 timeline | Aligned with Section 12 | D5 |

### Batch 3 (Payroll Core)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C3 | Payroll cycle | 2 รอบ/เดือน | D6 |
| C10 | Round 1 timing | ตั้งโอน 28-สิ้นเดือน, เงินเข้า 1 | D7 |
| C14 | Commission window | 1-14 (ขยายจาก 1-10) | D8 |

### Batch 4 (Legal)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C4 | Diligence forfeit | ลาป่วย ≥1 = ตัด (Strict) | D16 |
| C5 | Pharmacist OT | Fix 150 — ✅ Legal Reviewed 26 เม.ย. 2569 | D17 |
| C9 | CC-HQ-WS shift | Documented Rotation | D18 |

### Batch 5 (System Rules)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C6 | Leave types count | 9 ประเภท | D11 |
| C7 | OT Request Model | Flexible Timing | D12 |
| C8 | Correction threshold | ≥3 ครั้ง (รวมสาย+ลืม+correction) | D13 |
| C11 | Emergency Unlock | Allow before & after ปกส. filed | D14 |

### Batch 6 (Retention)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C13 | Data retention | Tier Model (L1=1ปี, L2=2ปี, Att=2ปี, Payroll=7ปี) | D15 |

### Batch 7 (Shift Management) ← NEW
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| **C16** | **MRD ขาด Shift Management ครอบคลุม** | **4 workflows + 28 sub-decisions + 38 edge cases** | **D19 (Draft v2)** |

---

## ✅ RESOLVED AUDIT ISSUES (8/8)

| # | Issue | Resolution Date | Sections |
|---|-------|-----------------|----------|
| #1 | Section 8 "Finance Lead" | 25 เม.ย. | 8 |
| #2 | Section 4.1 Payroll cycle ภาษา | 25 เม.ย. | 4.1 |
| #3 | Section 6.3 LWP case ไม่ชัด | 25 เม.ย. | 6.3 |
| #4 | Section 8 broadcast audience | 25 เม.ย. | 8 |
| #5 | Director Salary จิว | 25 เม.ย. | 4 |
| #6 | D17 Pharmacist OT Legal Review | 26 เม.ย. | 4, 6, 7 |
| #7 | Round 1 Block Logic | 25 เม.ย. | 6.9 |
| #8 | Payslip งวด clarification | 25 เม.ย. | 6.10 |

---

## 📅 DEFERRED ITEMS

### Holiday Calendar 2570
- **Status**: 📅 Deferred to Q4 2569
- **Reason**: ครม.ประกาศวันหยุดใหม่ปลายปี — ไม่สามารถ lock ตอนนี้
- **Action**: สร้าง `reference/holiday-calendar-2570.md`
- **Deadline**: 15 ธ.ค. 2569
- วันร้านปิดแน่นอน: 1 ม.ค., 30-31 ธ.ค.

---

## 🚩 RISK-ACCEPTED ITEMS

### D17: Pharmacist OT Fix 150
- **Legal Review**: ✅ 26 เม.ย. 2569
- **Owner Decision**: Accept risk — Fix 150 บาท/ชม. คงเดิม
- **Legal Risk**: ม.61 — จ่ายต่ำกว่า 1.5x hourly rate
- **Estimated Worst Case**: ~14,000+ ค่าฟ้องย้อน 2 ปี
- **Annual Saving vs. compliant**: ~6,375 บาท

### CC-01/CC-04 Single-Person Pharmacist+Sup (Section 13.10)
- **Status**: ⚠️ Structural Risk Acknowledged
- **Reason**: ค๊อป (CC-01) + จอย (CC-04) = Sup + Pharmacist เดียวกัน → no backup
- **Owner Decision**: Accept risk — ใช้ "ปิดม่านตู้ยาอันตราย" + Owner cover approval
- **Mitigation**:
  - Coverage Alert (D19.28) แจ้ง Owner+Delegates 2 รอบ
  - SOP: ปิดม่านตู้ยาอันตราย เปิดร้านได้ ไม่จ่ายยาที่ต้องใบสั่งแพทย์
  - Owner cover approval ของทีมเมื่อ Sup ขาด
- **Phase 2 Roadmap**: Pharmacist Backup Pool (post-Go-Live)

---

## 📝 PENDING REVIEW

### C16: Shift Management (D19 Draft v2)
- **Status**: 📝 Draft v2 — ปรับปรุง 2 พ.ค. 2569
- **Section**: 13 (ใหม่)
- **v1 → v2 Changes**:
  - ✅ V2 Supervisor coverage: เปลี่ยนจาก Block → Alert (ไม่ block สิทธิ์ลา)
  - ✅ Coverage Alert: รวม Pharmacist + Sup = unified alert
  - ✅ 4 scenarios (A-D) ตาม severity ของ gap
  - ✅ ม่านตู้ยาอันตราย procedure เพิ่มใน operational note
  - ✅ Owner cover approval สำหรับ CC-01/04
  - ✅ Trigger 2 รอบ (leave approve + schedule publish)
- **Reason**: MRD เดิมมีแค่ rule rotation (D18) + schema `employee_shifts` แต่ไม่ครอบคลุม:
  - UI วางตารางกะ
  - Workflow สลับกะ ระหว่างพนักงาน
  - Workflow ขอเปลี่ยนกะชั่วคราว
- **Resolution**:
  - 4 workflows (Schedule + Shift Swap + Day-Off Swap + Change Request)
  - 28 sub-decisions (D19.1-D19.28)
  - 38 edge cases analyzed
  - 11 validation rules (V1-V11)
  - 4 coverage alert scenarios
- **Reviewer Required**: เฮีย + ไนซ์ + การ์ตูน + Supervisors 5 คน + บอส
- **Next Step**: Team review → Lock D19 → Dev sprint 12 วัน

---

## 📊 Progress

```
Conflicts:       16/16 ✅ Resolved (100%)
Audit Issues:     8/8  ✅ Resolved (100%)
Deferred:         1     (Holiday 2570 — Q4 2569)
Pending Review:   1     (D19 Shift Management v2 — 2 พ.ค.)
Risk Accepted:    2     (D17 Pharmacist OT + CC-01/04 single-person)
```

---

*Last updated: 2 พ.ค. 2569 | C16 Shift Management drafted v2 — V2 fix (alert ไม่ block) + Coverage Alert unified*
