# ============================================================
#  HOFIT & GONI  -  התקנת סביבת העבודה עם Claude
#  מתקין: Git, Node.js, Claude Code + 17 הסקילים של חופית וגוני
#  הרצה (PowerShell כמנהל):
#  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force; irm https://hofit-goni.com/install | iex
# ============================================================

$ErrorActionPreference = "Stop"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

# --- הגדרות ה-marketplace שלנו (לא לשנות) ---
$MarketplaceRepo = "goni-b/HOFIT-GONI-CLAUDE-SETUP"
$MarketplaceName = "hofit-goni-course"
$PluginName      = "ai-campaign-course"

function Say($msg, $color = "White") { Write-Host $msg -ForegroundColor $color }
function Step($n, $msg) { Write-Host "`n[$n/5] $msg" -ForegroundColor Cyan }

# רענון משתני הסביבה (כדי שכלים שהותקנו ייקלטו מיד בלי לפתוח חלון חדש)
function Refresh-Path {
    $machine = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $user    = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $npm     = Join-Path $env:APPDATA "npm"
    $env:Path = "$machine;$user;$npm"
}

function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

Say ""
Say "========================================" Magenta
Say "   HOFIT & GONI  -  התקנה עם Claude" Magenta
Say "========================================" Magenta
Say "ההתקנה לוקחת 5-10 דקות. אם נכשלת - הריצו שוב, כלים מותקנים מדולגים." Gray

# בדיקה ש-winget קיים (מובנה ב-Windows 10/11 מעודכן)
if (-not (Have "winget")) {
    Say "`nשגיאה: לא נמצא winget (מנהל ההתקנות של Windows)." Red
    Say "עדכנו את Windows דרך Microsoft Store ('App Installer') ונסו שוב." Yellow
    return
}

# ---------- שלב 1: Git ----------
Step 1 "מתקין Git (שמירת גרסאות)..."
if (Have "git") {
    Say "   Git כבר מותקן - מדלג." Green
} else {
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
    Refresh-Path
}

# ---------- שלב 2: Node.js ----------
Step 2 "מתקין Node.js (סביבת הרצה)..."
if (Have "node") {
    Say "   Node.js כבר מותקן ($(node --version)) - מדלג." Green
} else {
    winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
    Refresh-Path
}

if (-not (Have "node")) {
    Say "`nNode.js הותקן אך לא נקלט בחלון הנוכחי." Yellow
    Say "סגרו את החלון, פתחו PowerShell חדש כמנהל, והריצו שוב את ההתקנה." Yellow
    return
}

# ---------- שלב 3: Claude Code ----------
Step 3 "מתקין Claude Code CLI (הכלי המרכזי)..."
if (Have "claude") {
    Say "   Claude Code כבר מותקן ($(claude --version)) - מעדכן..." Green
}
npm install -g @anthropic-ai/claude-code
Refresh-Path

if (-not (Have "claude")) {
    Say "`nClaude Code הותקן אך לא נקלט בחלון הנוכחי." Yellow
    Say "סגרו את החלון, פתחו PowerShell חדש, והריצו שוב את ההתקנה (היא תדלג על מה שכבר מותקן)." Yellow
    return
}

# ---------- שלב 4: הוספת ה-marketplace של חופית וגוני ----------
Step 4 "מוסיף את חבילת הסקילים של חופית וגוני..."
claude plugin marketplace add $MarketplaceRepo
claude plugin marketplace update $MarketplaceName

# ---------- שלב 5: התקנת הסקילים ----------
Step 5 "מתקין את 17 הסקילים..."
claude plugin install "$PluginName@$MarketplaceName" --scope user

# ---------- סיום ----------
Say "`n========================================" Green
Say "   ההתקנה הושלמה!  🎉" Green
Say "========================================" Green
Say ""
Say "מה עכשיו? שני צעדים אחרונים:" White
Say ""
Say "  1) הקלידו:  claude" Cyan
Say "     (בפעם הראשונה ייפתח דפדפן - התחברו עם חשבון Claude שלכם)" Gray
Say ""
Say "  2) בתוך Claude, נסו להקליד:  /copy" Cyan
Say "     ותראו שהסקילים של חופית וגוני עובדים." Gray
Say ""
Say "אין לכם עדיין חשבון Claude? פתחו מנוי Claude Pro בכתובת:" Yellow
Say "  https://claude.ai/upgrade" Yellow
Say ""
