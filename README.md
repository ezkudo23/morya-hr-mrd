# Morya HR System (MYHR) — MRD

> **Single Source of Truth สำหรับการพัฒนา Custom HR System ของหมอยาสุรินทร์**
> Mirror ของ Notion workspace — แก้ที่ GitHub, sync ไป Notion ทีหลัง

---

## 📊 Status

| Item | Value |
|------|-------|
| Version | 1.0-final |
| Last Updated | 25 เม.ย. 2569 |
| Go-Live | 1 ม.ค. 2570 |
| Dev Kickoff | พ.ค. 2569 |
| Total Headcount | 33 คน |
| Critical Conflicts | ✅ 15/15 Resolved (100%) |
| Audit Issues | ✅ 7/8 Resolved (88%) |
| Risk Accepted | 1 (Pharmacist OT — Pending Legal Review) |

---

## 📁 Structure

```
morya-hr-mrd/
├── README.md                  ← You are here
├── DECISIONS.md               ← Locked decisions log (18 entries)
├── CONFLICTS.md               ← Issues registry (history)
├── sections/                  ← MRD content (12 sections)
├── reference/                 ← Master data + lookups
├── decisions/                 ← Decision logs by date
├── scripts/                   ← Validation scripts
└── archive/                   ← Old versions
```

---

## 🔄 Workflow

### การแก้ MRD

1. **Pull ล่าสุด** (ก่อนแก้): `git pull origin main`
2. **แก้ไฟล์** ใน `sections/` หรือ `reference/`
3. **Run consistency check**: `bash scripts/check-consistency.sh`
4. **Update DECISIONS.md** ถ้ามีการ lock decision ใหม่
5. **Commit + push**:
   ```bash
   git add .
   git commit -m "fix: <issue#> <description>"
   git push
   ```

### Sync to Notion

ปัจจุบัน manual sync — Corner update Notion หลังแก้ใน GitHub สำหรับ key decisions

---

## 🚦 Conflict Resolution Status

```
✅ Batch 1-2: C1, C2, C12, C15
✅ Batch 3:   C3, C10, C14
✅ Batch 4:   C4, C5*, C9   (*Risk accepted, Pending Legal)
✅ Batch 5:   C6, C7, C8, C11
✅ Batch 6:   C13

⚠️ Open Items:
└── Holiday Calendar 2570 (defer to Q4 2569)
```

---

## 🔗 Related Resources

- **Notion Mirror**: [Parent MRD](https://www.notion.so/34b9e022ec808162b0c7d1d6cea9363e)
- **GitHub Code Repo**: morya-hr (separate)
- **Payroll System**: Bluenote
- **Tech Stack**: Next.js 15 + TypeScript + Supabase + LIFF + Tailwind 4 + shadcn/ui

---

## 📞 Stakeholders

| Role | Name | Code |
|------|------|------|
| Owner | เฮีย (อมร) | — |
| Delegate 1 | ไนซ์ | — |
| CEO/Delegate 2 | จิว | CEO02 |
| HR Sponsor | จอย | MY11 |
| Finance | นา | MY16 |
| IT | บอส | MY25 |
| HR Admin | การ์ตูน | MY07 |

---

> ⚠️ **ห้าม commit ข้อมูลพนักงานจริง** (รหัสบัญชี, เลขบัตรประชาชน) ลง public repo
> ใช้ format anonymous ใน examples (เช่น "พนักงาน A", MY01, etc.)
