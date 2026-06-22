#!/usr/bin/env bash
# ============================================================
#  HOFIT & GONI  -  התקנת סביבת העבודה עם Claude  (Mac / Linux)
#  מתקין: Homebrew, Git, Node.js, Claude Code + 17 הסקילים
#  הרצה (Terminal):
#  curl -fsSL https://hofit-goni.com/install-mac | bash
# ============================================================
set -e

MARKETPLACE_REPO="goni-b/HOFIT-GONI-CLAUDE-SETUP"
MARKETPLACE_NAME="hofit-goni-course"
PLUGIN_NAME="ai-campaign-course"

cyan()  { printf "\033[36m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }
gray()  { printf "\033[90m%s\033[0m\n" "$1"; }
step()  { printf "\n\033[36m[%s/5] %s\033[0m\n" "$1" "$2"; }

echo ""
cyan "========================================"
cyan "   HOFIT & GONI  -  התקנה עם Claude"
cyan "========================================"
gray "ההתקנה לוקחת 5-10 דקות. אם נכשלה - הריצו שוב, כלים מותקנים מדולגים."

# ---------- שלב 1: Homebrew ----------
step 1 "מתקין Homebrew (מנהל החבילות של Mac)..."
if command -v brew >/dev/null 2>&1; then
  green "   Homebrew כבר מותקן - מדלג."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# הוספת brew ל-PATH של החלון הנוכחי (Apple Silicon + Intel)
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [ -x /usr/local/bin/brew ];   then eval "$(/usr/local/bin/brew shellenv)";   fi

# ---------- שלב 2: Git ----------
step 2 "מתקין Git..."
if command -v git >/dev/null 2>&1; then green "   Git כבר מותקן - מדלג."; else brew install git; fi

# ---------- שלב 3: Node.js + Claude Code ----------
step 3 "מתקין Node.js ו-Claude Code CLI..."
if command -v node >/dev/null 2>&1; then green "   Node.js כבר מותקן ($(node --version)) - מדלג."; else brew install node; fi
npm install -g @anthropic-ai/claude-code

# ---------- שלב 4: הוספת ה-marketplace ----------
step 4 "מוסיף את חבילת הסקילים של חופית וגוני..."
claude plugin marketplace add "$MARKETPLACE_REPO"
claude plugin marketplace update "$MARKETPLACE_NAME"

# ---------- שלב 5: התקנת הסקילים ----------
step 5 "מתקין את 17 הסקילים..."
claude plugin install "$PLUGIN_NAME@$MARKETPLACE_NAME" --scope user

# ---------- סיום ----------
echo ""
green "========================================"
green "   ההתקנה הושלמה!  🎉"
green "========================================"
echo ""
echo "מה עכשיו? שני צעדים אחרונים:"
echo ""
cyan  "  1) הקלידו:  claude"
gray  "     (בפעם הראשונה ייפתח דפדפן - התחברו עם חשבון Claude שלכם)"
echo ""
cyan  "  2) בתוך Claude, נסו להקליד:  /copy"
gray  "     ותראו שהסקילים של חופית וגוני עובדים."
echo ""
echo "אין לכם עדיין חשבון Claude? פתחו מנוי Claude Pro בכתובת:"
echo "  https://claude.ai/upgrade"
echo ""
