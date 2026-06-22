# HOFIT & GONI — סביבת העבודה עם Claude

חבילת התקנה בפקודה אחת: מתקינה את כל הכלים הדרושים לעבודה עם **Claude Code**, ומוסיפה את **17 הסקילים של חופית וגוני** לבניית קמפיינים, קופי, דפי נחיתה ועוד.

---

## התקנה בפקודה אחת (Windows)

פותחים **PowerShell כמנהל** (קליק ימני על תפריט התחל ← *Terminal (Admin)* / *PowerShell (Administrator)*), מדביקים ולוחצים Enter:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force; irm https://hofit-goni.com/install | iex
```

> הלינק הממותג `hofit-goni.com/install` מפנה (301) אל `install.ps1` שב-repo הזה.
> אם ההפניה עדיין לא הוגדרה, אפשר להשתמש בלינק הישיר:
> `irm https://raw.githubusercontent.com/goni-b/HOFIT-GONI-CLAUDE-SETUP/main/install.ps1 | iex`

ההתקנה לוקחת 5–10 דקות. אם נכשלה — מריצים שוב; כלים שכבר מותקנים מדולגים.

לאחר ההתקנה: מקלידים `claude`, מתחברים עם חשבון Claude, ומתחילים לעבוד.

**מדריך מעוצב ללקוח (Windows + Mac, עם איורי מסך):** [guide.pdf](guide.pdf)

### Mac / Linux
```bash
curl -fsSL https://hofit-goni.com/install-mac | bash
```

> צריך חשבון **Claude Pro** או מעלה: https://claude.ai/upgrade

---

## מה מותקן

| כלי | למה |
|------|------|
| Git | שמירת גרסאות של הקוד |
| Node.js LTS | סביבת הרצה |
| Claude Code CLI | הכלי המרכזי |
| חבילת `ai-campaign-course` | 17 הסקילים של חופית וגוני |

## הסקילים בחבילה

**שיווק:** meta-campaigner-ai · copywriting · marketing-psychology · meta-report
**תפעול:** email-agent
**כלים:** skill-creator · canvas-design · pdf · schedule · xlsx
**אתרים ודפי נחיתה:** design-strategist · fullstack-app-builder · fullstack-master-engineer · hofit-goni-design-agent · landing-page · landing-page-design · cro

---

## מבנה ה-repo

```
.claude-plugin/marketplace.json     ← מגדיר את ה-marketplace
install.ps1                         ← המתקין ל-Windows
plugins/ai-campaign-course/         ← הפלאגין + 17 הסקילים
```

## עדכון הסקילים (לצוות חופית וגוני)

כל שינוי בסקילים — דוחפים ל-GitHub (`git add . && git commit -m "..." && git push`).
הלקוחות מקבלים את העדכון אוטומטית בפעם הבאה שהם מריצים בתוך Claude:

```
/plugin marketplace update hofit-goni-course
/plugin update ai-campaign-course@hofit-goni-course
```

© HOFIT & GONI
