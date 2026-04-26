# 🚨 Conflicts & Issues Registry

> Resolution status of all critical conflicts and audit issues.
> ✅ All 15 critical conflicts resolved.
> ⚠️ 1 risk accepted (D17 - Pending Legal Review).
> 📅 1 deferred (Holiday Calendar 2570 — Q4 2569).

**Last Updated**: 25 เม.ย. 2569
**Status**: ✅ All actionable conflicts resolved — Ready for Dev Kickoff

---

## ✅ RESOLVED CONFLICTS (15/15)

### Batch 1-2 (Foundation)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C1 | Employee count | 33 total, 30 payroll, 29 attendance | D1 |
| C2 | Go-Live date | 1 ม.ค. 2570 | D2 |
| C12 | Finance Lead → Finance | Single Finance person (นา) | D4 |
| C15 | Section 1 timeline | Aligned with Section 12 | D5 |

### Batch 3 (Payroll Core)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C3 | Payroll cycle | 2 รอบ/เดือน | D6 |
| C10 | Round 1 timing | ตั้งโอน 28-สิ้นเดือน, เงินเข้า 1 | D7 |
| C14 | Commission window | 1-14 (ขยายจาก 1-10) | D8 |

### Batch 4 (Legal — Pending Lawyer Review)
| # | Topic | Resolution | Decision |
|---|-------|------------|----------|
| C4 | Diligence forfeit | ลาป่วย ≥1 = ตัด (Strict) | D16 |
| C5 | Pharmacist OT | Fix 150 (⚠️ Risk Accepted) | D17 |
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

---

## ✅ RESOLVED AUDIT ISSUES (7/8)

| # | Issue | Resolution Date | Sections |
|---|-------|-----------------|----------|
| #1 | Section 8 "Finance Lead" | 25 เม.ย. | 8 |
| #2 | Section 4.1 Payroll cycle ภาษา | 25 เม.ย. | 4.1 |
| #3 | Section 6.3 LWP case ไม่ชัด | 25 เม.ย. | 6.3 |
| #4 | Section 8 broadcast audience | 25 เม.ย. | 8 |
| #5 | Director Salary จิว | 25 เม.ย. | 4 |
| #7 | Round 1 Block Logic | 25 เม.ย. | 6.9 |
| #8 | Payslip งวด clarification | 25 เม.ย. | 6.10 |

---

## 📅 DEFERRED ITEMS

### Issue #6: Holiday Calendar 2570
- **Status**: 📅 Deferred to Q4 2569
- **Reason**: ครม.ประกาศวันหยุดใหม่ปลายปี — ไม่สามารถ lock ตอนนี้
- **Action**:
  - สร้าง Notion page + Markdown file ใน `reference/holiday-calendar-2570.md`
  - Deadline: 15 ธ.ค. 2569 (per Section 12)
  - วันร้านปิดแน่นอน: 1 ม.ค., 30-31 ธ.ค.

---

## 🚩 RISK-ACCEPTED ITEMS

### D17: Pharmacist OT Fix 150
- **Owner Decision**: Accept risk, maintain status quo (Humansoft 5+ years)
- **Legal Risk**: ม.61 violation (จ่ายต่ำกว่า 1.5x ของหนึ่งชม.เงินเดือน)
- **Estimated Worst Case**: ~14,000+ ค่าฟ้องย้อน 2 ปี
- **Annual Saving vs. compliant**: ~6,375 บาท
- **✅ Legal Reviewed 26 เม.ย. 2569**: Owner ยืนยัน risk accepted — Fix 150 บาท/ชม. คงเดิม
---

## 📊 Progress

```
Critical Conflicts:  ████████████████████  15/15 (100%)
Audit Issues:        █████████████████░░░   7/8  (88%)
Risk-Accepted:        1 (Pharmacist OT)
Deferred:             1 (Holiday Calendar 2570)

Overall: 22/24 = 92% — Ready for Dev Kickoff (พ.ค. 2569)
```
