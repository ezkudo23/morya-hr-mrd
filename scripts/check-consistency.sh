#!/usr/bin/env bash
# MYHR MRD Consistency Check
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

ISSUES=0

echo "🔍 MYHR MRD Consistency Check"
echo "═══════════════════════════════════════════════"
echo ""

check() {
    local name="$1"
    local pattern="$2"
    local should_match="$3"

    # Exclude lines marked with ~~strikethrough~~ (intentional old refs)
    local matches
    matches=$(grep -rn --include='*.md' "$pattern" sections/ reference/ 2>/dev/null | grep -v '~~' || true)

    if [[ "$should_match" == "no" && -n "$matches" ]]; then
        echo "❌ FOUND (should NOT exist): $name"
        echo "$matches" | head -5 | sed 's/^/   /'
        ISSUES=$((ISSUES + 1))
        echo ""
    elif [[ "$should_match" == "yes" && -z "$matches" ]]; then
        echo "❌ MISSING (should exist): $name"
        ISSUES=$((ISSUES + 1))
        echo ""
    else
        echo "✅ $name"
    fi
}

echo "─── Stale Terms (should NOT exist) ───"
echo "Note: Lines with ~~strikethrough~~ are excluded (intentional old refs)"
echo ""
check "Old: 'Finance Lead' (use 'Finance')" "Finance Lead" "no"
check "Old: '1 รอบ/เดือน' (use '2 รอบ')" "1 รอบ/เดือน" "no"
check "Old: '34 คน' headcount (use '33')" "34 คน" "no"
check "Old: '1 ก.พ. 2570' Go-Live (use '1 ม.ค.')" "1 ก.พ. 2570" "no"
check "Old: '13 ประเภท' (use '9 ประเภท')" "13 ประเภท" "no"
check "Old: '> 4 ครั้ง/เดือน' (use '≥3')" "> 4 ครั้ง/เดือน" "no"
check "Old: 'max(150, hourly × 1.5)' (use Fix 150)" "max(150, hourly" "no"

echo ""
echo "─── Required Terms (should EXIST) ───"
check "33 คน headcount" "33 คน" "yes"
check "1 ม.ค. 2570 Go-Live" "1 ม.ค. 2570" "yes"
check "Hybrid Salary Logic" "Hybrid" "yes"
check "Documented Rotation (CC-HQ-WS)" "Documented Rotation\|Rotation" "yes"
check "Tier Model (Retention)" "Tier Model\|tier" "yes"
check "Risk Accepted (D17)" "Risk Accepted\|Pending Legal" "yes"

echo ""
echo "═══════════════════════════════════════════════"
if [[ $ISSUES -eq 0 ]]; then
    echo "✅ All checks passed — MRD is consistent"
    exit 0
else
    echo "❌ Found $ISSUES issue(s) — review and fix"
    exit 1
fi
