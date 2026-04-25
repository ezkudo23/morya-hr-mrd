# 📋 Pending Migration

> **Snapshot v1.0** — Critical Path migrated (Sections 1, 4, 6, 7 + Master Data)
> Created: 25 เม.ย. 2569

---

## ✅ Already Migrated (in this snapshot)

| File | Status | Lines |
|---|---|---|
| README.md | ✅ Final | 99 |
| DECISIONS.md (D1-D18) | ✅ Final | 211 |
| CONFLICTS.md (history) | ✅ Final | 98 |
| sections/01-exec-summary.md | ✅ Migrated | 146 |
| sections/04-foundational-rules.md | ✅ Migrated | 412 |
| sections/06-payroll.md | ✅ Migrated | 574 |
| sections/07-attendance.md | ✅ Migrated | 581 |
| reference/master-data.md | ✅ Migrated | 295 |
| scripts/check-consistency.sh | ✅ Working | 60 |
| .gitignore | ✅ | — |

---

## ⏳ Not Yet Migrated (still in Notion)

These sections are still in Notion and need to be migrated in a future session:

| Section | Notion URL | Priority |
|---|---|---|
| Section 2: Stakeholders | https://www.notion.so/34c9e022ec8081d883eac01049df4980 | Medium |
| Section 3: Cost Centers | https://www.notion.so/34c9e022ec8081b8bac6fbcf53168db0 | Medium |
| Section 5: Workflow | https://www.notion.so/34c9e022ec8081e39ff4d2e4da268b91 | Medium |
| Section 8: Notification | https://www.notion.so/34c9e022ec8081d6a076c18007337698 | Low |
| Section 9: Dashboard | https://www.notion.so/34c9e022ec808178ba55e778613dde71 | Low |
| Section 10: Audit Log | https://www.notion.so/34c9e022ec808152a678c038c7d6e07c | Medium |
| Section 11: PDPA | https://www.notion.so/34c9e022ec80819a90a9c4603581a1f4 | Medium |
| Section 12: Deployment | https://www.notion.so/34c9e022ec8081b0a4edd45aab2a8394 | High (M9 Go-Live) |

### Reference Files Pending
- reference/employee-master-v2.md (Notion: 34c9e022ec808143ada2c3d387a3f558)
- reference/holiday-calendar-2569.md (Notion: 34b9e022ec808111aa52d0c31d31e822)
- reference/holiday-calendar-2570.md (TBD — Q4 2569)
- CLAUDE.md (Coding agent guidance — Notion: 34b9e022ec8081c6839be2dd680ad697)

---

## 🎯 Why Critical Path First?

Critical Path = sections ที่ Dev ต้องอ่านก่อนเริ่มเขียน code:

1. **Section 1** = Project overview, scope, timeline
2. **Section 4** = ALL business rules (used by all other sections)
3. **Section 6** = Payroll engine logic + formulas (most complex)
4. **Section 7** = Attendance + shift system (used by payroll)
5. **Master Data** = Headcount, employees, branches (single source of truth)

ส่วนที่เหลือ (Sections 2, 3, 5, 8-12):
- Section 2-3: Org/branch info — เปลี่ยนน้อย
- Section 5: Workflow — referenced from 4, 6, 7 already
- Section 8-9: Notification + Dashboard — UI/UX (later phase)
- Section 10: Audit Log — infrastructure (later)
- Section 11: PDPA — compliance docs (review with lawyer)
- Section 12: Deployment — M9 specific (just before go-live)

---

## 🚀 Next Migration Session (Recommended Order)

1. **Section 12 (Deployment)** — M9 Go-Live checklist, parallel run procedure
2. **Section 10 (Audit Log)** — Infrastructure spec for Dev M1
3. **Section 11 (PDPA)** — Compliance review needed before go-live
4. **Section 5 (Workflow)** — Cross-section integration
5. **Section 2-3, 8, 9** — Lower priority

Estimated time: 1-2 sessions

---

## 📦 What to Do With This Snapshot

### Option A: Push to GitHub now
```bash
unzip morya-hr-mrd-v1.zip
cd morya-hr-mrd
git init
git add .
git commit -m "Initial MRD v1.0 — Critical Path (Sections 1, 4, 6, 7 + Master Data)"
git branch -M main
git remote add origin https://github.com/<your-username>/morya-hr-mrd.git
git push -u origin main
```

### Option B: Wait until full migration
- Keep this zip as backup
- Migrate remaining sections next session
- Push complete repo at once

### Option C (Recommended): Push now + iterate
- Push Critical Path now (start using GitHub workflow)
- Add remaining sections as commits in next sessions
- Each new section = 1 commit with clear message
