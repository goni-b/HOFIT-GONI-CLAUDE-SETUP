---
name: landing-page
description: |
  Master orchestrator for creating high-converting Hebrew landing pages.
  9-agent pipeline: Researcher → Avatar → Strategist → Angle → Authority → Copywriter → Visual Designer → Art Director → Builder.
  Triggers: "אני רוצה דף נחיתה", "create landing page", "build landing page", "בנה לי דף".
version: 3.0.0
---

# Landing Page Pipeline — 9 Agents, One Page

---

## 🚨 CRITICAL MISTAKES TO AVOID (FROM PAST FAILURES)

### Mistake 1: Reformatting Instead of Creating Copy
**WRONG:** Taking user's strategic document and just putting it in JSON format.
**RIGHT:** Use the document as INPUT, then GENERATE original copy with:
- Short sentences (3-4 words per line)
- "Slippery slope" style that forces reading
- Parenthetical whispers like (בדיוק כמו שקראת, שובב)
- Specific non-round numbers (₪238,250 not ₪240,000)
- The "cheeky best friend" tone

### Mistake 2: Using CSS Classes Without Verification
**WRONG:** Using `bg-bg-primary`, `text-gold` without checking if they exist.
**RIGHT:** ALWAYS read `globals.css` and `tailwind.config.ts` FIRST.

### Mistake 3: Skipping Skills
**WRONG:** Building without activating `brainstorming`, `framer-motion-best-practices`, etc.
**RIGHT:** Activate relevant skills BEFORE each phase.

### Mistake 4: Not Comparing to Reference Screenshots
**WRONG:** Building without looking at `/screenshots/` folder.
**RIGHT:** View ALL screenshots FIRST, compare output BEFORE declaring done.

### Mistake 5: Not Testing Animations
**WRONG:** Claiming animations work without browser testing.
**RIGHT:** Run dev server, scroll through page, verify animations trigger.

---

## 🛫 PRE-FLIGHT CHECKLIST (MANDATORY)

Before writing ANY code:

- [ ] Read `/copy.md` fully
- [ ] Read `/designer.md` fully
- [ ] View `/screenshots/` (12 desktop images)
- [ ] View `/screenshots/mobile/` (16 mobile images)
- [ ] Check `globals.css` for CSS variables
- [ ] Check `tailwind.config.ts` for custom colors
- [ ] Activate `/brainstorming` skill

---

## When to Use

- User says "אני רוצה דף נחיתה" or "create a landing page"
- User wants to build a new sales page or lead generation page
- User has a product/service and needs a complete funnel page

## ⚠️ IMPORTANT: How This Skill Works

This skill orchestrates the **9-agent workflow** for building a high-converting Hebrew landing page from scratch using Hofit & Goni's methodology.

You (Claude) play all 9 roles sequentially in the same conversation, getting user approval at the key checkpoints (steps 4, 6, 7, 8).

**The pipeline follows the structure below.** Read it carefully and execute each step in order.

---

## The Full Pipeline

```
┌─────────────────────────────────────────────────────┐
│  1. חוקר        — שאלות על המוצר                      │
│  2. אווטאר      — פחדים, חלומות, שפת לקוח              │
│  3. אסטרטג      — Big Idea, USP, מנגנון ייחודי         │
│  4. אנגל        — זווית התקפה, הוק, דחיפות      🔑 אישור │
│  5. חוקר סמכות  — מספרים, proof, Social Proof           │
│  6. קופירייטר   — כותב את הדף (9 סקשנים)        🔑 אישור │
│  7. מעצב ויזואלי — תמונות + פרומפטים לננו בננה  🔑 אישור │
│  8. דירקטור אמנותי — פלטה, סגנון, טיפוגרפיה    🔑 אישור │
│  9. בנאי        — מרכיב הכל לדף חי                     │
└─────────────────────────────────────────────────────┘
```

**4 נקודות אישור (🔑)** — לא ממשיכים בלי OK מהלקוח.

---

## Agent 1: חוקר (Product Researcher)

### מטרה
להבין את המוצר, השוק, והלקוח — כדי שכל מה שאחרי יהיה מבוסס על מציאות ולא על ניחושים.

### שאלות (שאל אחת-אחת, בשפה טבעית)

```markdown
1. "מה המוצר/שירות שאתה מוכר? תן לי שם + תיאור קצר."
2. "מי קהל היעד? (גיל, מגדר, מקצוע, מצב כלכלי)"
3. "מה הבעיה המרכזית שהמוצר פותר?"
4. "למה שיבחרו דווקא בך? מה הייחוד שלך?"
5. "מה ההצעה? (מחיר, פורמט — קורס/ליווי/שירות, בונוסים)"
6. "מי המתחרים? מה הם עושים שונה?"
7. "מה הפעולה שאתה רוצה שהקורא יעשה? (טופס/רכישה/שיחה)"
```

### פלט
Brief גולמי — סיכום של 5-8 שורות שתופס את התמונה המלאה.

### הערה
אם הלקוח סיפק כבר את רוב המידע (העתיק אתר, שלח מסמך) — **דלג על שאלות שכבר יש להן תשובה.** אל תשאל מה שאתה כבר יודע.

---

## Agent 2: אווטאר (Avatar Analyst)

### מטרה
לדעת מה הלקוח מרגיש, חולם, ופוחד — כדי שהקופי ידבר בשפה שלו ולא בשפה שלנו.

### עבודה פנימית (לא מראים ללקוח)

ענה על 6 שאלות:
1. **מה מעיר אותם ב-3 בלילה?** — הפחד הספציפי, לא הכללי
2. **מה הם חולמים בסתר ומתביישים להגיד?** — החלום האמיתי
3. **מה הם כבר ניסו ונכשלו?** — ה"דרך הלא נכונה"
4. **מה הם באמת רוצים מעבר למה שהם אומרים?** — הרצון העמוק
5. **באיזו שפה הם מדברים על הבעיה הזו?** — מילים מדויקות
6. **מה יגרום להם להרגיש "הוא מכיר אותי"?** — רגע ההזדהות

### פלט

```markdown
## פרופיל אווטאר

**הפחד המרכזי:** [משפט אחד]
**החלום הסודי:** [משפט אחד]
**מה כבר ניסו:** [2-3 דברים]
**השפה שלהם:** [5-8 ביטויים ספציפיים שהם משתמשים]
**רגע ההזדהות:** [תרחיש ספציפי שיגרום להם לחשוב "הוא מכיר אותי"]
```

הצג ללקוח לוולידציה מהירה (לא צריך אישור פורמלי, רק "נכון?").

---

## Agent 3: אסטרטג (Big Idea Strategist)

### מטרה
למצוא את ה-USP, הרעיון הגדול, והמנגנון הייחודי — הדבר שהופך את המוצר הזה ממשהו רגיל למשהו שאי אפשר לסרב לו.

### עבודה

על בסיס Agent 1-2, מצא:

1. **USP (Unique Selling Proposition)** — מה הדבר האחד שרק הלקוח הזה מציע?
   - לא "ניסיון רב" — זה כולם
   - כן: "שיטת 180 הימים — 10 ק"ג פחות בלי לוותר על אוכל שאוהבים"

2. **Big Idea** — הרעיון הגדול שמחבר הכל
   - לא "קורס טוב" — זה לא רעיון
   - כן: "הדירה שלך כבר עובדת בשבילך. מישהו פשוט צריך לנהל אותה."

3. **מנגנון ייחודי** — למה זה עובד (שם + הסבר פשוט)
   - לא "שיטה מוכחת"
   - כן: "שיטת ה-Vibe Coding — בונים פאנל שלם בשיחה עם AI"

### פלט

```markdown
## אסטרטגיה

**USP:** [משפט אחד חד]
**Big Idea:** [משפט אחד שמסכם את הכל]
**מנגנון ייחודי:** [שם] — [הסבר ב-2 שורות]
**ההיפוך מהמקובל:** "כולם אומרים [X], אנחנו אומרים [Y]"
```

---

## Agent 4: אנגל (Angle Master) — 🔑 נקודת אישור

### מטרה
לבחור את הזווית הכי מפתיעה ויעילה לדף. הזווית = האופן שבו נעטוף את כל ה-copy.

### עבודה

על בסיס Agents 1-3, הצע **3 זוויות**:

#### 11 זוויות אפשריות:

| # | אנגל | מתי מתאים | דוגמת פתיחה |
|---|-------|-----------|-------------|
| 1 | הודעת פטירה | מוצר שמחליף שיטה ישנה | "בצער רב אני מודיע על פטירת..." |
| 2 | וידוי / חשיפה | איש מקצוע חושף אמת | "אני הולך להגיד משהו שיזעזע..." |
| 3 | מכתב אישי | מותג אישי, קהל חם | "תקשיב, אני צריך לספר לך משהו..." |
| 4 | מודעת דרושים הפוכה | B2B או קהל עסקי | "דרוש: בעל עסק שעייף מ..." |
| 5 | כתב אישום | יש "אויב" ברור | "כתב אישום נגד: השיטה הישנה..." |
| 6 | דו"ח חקירה | מוצר מבוסס נתונים | "חקירה: מה באמת עולה לך..." |
| 7 | מכתב פרידה | עוזבים כלי/שירות ישן | "מכתב פרידה מהמעצבת שלי..." |
| 8 | שידור חדשות | שיבוש תעשייתי | "חדשות 2026: 73% מהפאנלים..." |
| 9 | "מה אם..." | נשמע טוב מכדי להיות אמיתי | "מה אם הייתי אומר לך ש..." |
| 10 | סיפור עם טוויסט | סיפור רקע חזק | "בשעה 2:17 בלילה שלחתי הודעה..." |
| 11 | "הייתי בדיוק כמוך" | קורס מיומנות, בעיה relatable | "כשהתחלתי, הייתי בדיוק כמוך..." |

### פלט (הצגה ללקוח)

```markdown
## 3 זוויות לדף:

### אופציה 1: [שם הזווית]
**פתיחה:** "[2-3 שורות ראשונות של הדף]"
**למה זה עובד:** [שורה אחת]

### אופציה 2: [שם הזווית]
**פתיחה:** "[2-3 שורות ראשונות של הדף]"
**למה זה עובד:** [שורה אחת]

### אופציה 3: [שם הזווית]
**פתיחה:** "[2-3 שורות ראשונות של הדף]"
**למה זה עובד:** [שורה אחת]
```

### 🔑 חכה לאישור לפני שממשיכים!

---

## Agent 5: חוקר סמכות (Authority Researcher)

### מטרה
לאסוף את כל ה-proof שיהפוך את הקופי ממשכנע לבלתי ניתן לסירוב.

### שאלות (שאל אחת-אחת)

```markdown
1. "כמה שנים אתה בתחום?"
2. "כמה לקוחות/תלמידים/תהליכים עשית?"
3. "מה התוצאה הכי מרשימה שלקוח שלך השיג?"
4. "יש לך מספרים ספציפיים? (הכנסות, אחוזי הצלחה, חיסכון)"
5. "יש לך עדויות? (שמות, ציטוטים, לפני/אחרי)"
6. "יש מותגים/אנשים מוכרים שעבדת איתם?"
7. "יש לך תעודות/הסמכות/הופעות בתקשורת?"
```

### פלט

```markdown
## בנק Social Proof

**מספרים קשיחים:**
- [מספר]: [הקשר]

**עדויות מפתח:**
- [שם]: "[ציטוט]" — [תוצאה]

**סמכות:**
- [שנים / מותגים / הסמכות]
```

**כלל:** אם אין מספיק proof — אמור ללקוח. אל תמציא. "אני צריך ממך עוד 2 עדויות ספציפיות עם מספרים."

---

## Agent 6: קופירייטר (Copywriter) — 🔑 נקודת אישור

### מטרה
לכתוב את הקופי השלם של הדף — כל מילה, כל כותרת, כל CTA.

### מתודולוגיה
עובד לפי שיטת "Hofit & Goni" 24 הצעדים (ראה `hofit-goni-copy-agent` skill).

### מבנה 9 הסקשנים:

| # | סקשן | מה כולל |
|---|-------|---------|
| 1 | Hook + Headline | הוק (מהאנגל שנבחר) + כותרת ראשית |
| 2 | Bridge | סמכות + open loop + טיזר להצעה |
| 3 | Lead / Pain | תיאור הבעיה בשפת האווטאר → תקווה → שבירת התנגדויות |
| 4 | Solution Reveal | הצהרה מפתיעה → הרג שיטה ישנה → שם הפתרון → הסבר פשוט → proof |
| 5 | Offer | שם המוצר (גדול) → פורמט → פירוט ימים/מודולים → אלמנט מיוחד |
| 6 | Who It's For | דיסקוואליפיקציה → רשימת אווטארים → חלום → סגירה |
| 7 | Pricing | עיגון (עלות הדרך הישנה) → מה כלול → מחיר → הרגעה |
| 8 | CTA + Urgency | דחיפות אמיתית → כפתור → מחסור + ביטחון |
| 9 | FAQ | 4-6 שאלות = טיפול בהתנגדויות |

### כללים קריטיים:
- **בהירות > יצירתיות** — הקורא חייב להבין תוך 3 שניות מה המוצר
- **USP ב-Hero** — לא בסקשן 5
- **משפטים קצרים** — 3-4 מילים בשורה
- **מספרים ספציפיים** — ₪19,928 לא "כ-20 אלף"
- **Proof ליד הטענה** — לא בסקשן נפרד בתחתית

### פלט

הקופי המלא — סקשן אחרי סקשן — עם סימונים ברורים:

```markdown
## [שם הסקשן]

[הקופי]

---
💡 רעיון ויזואלי: [מה התמונה/אנימציה שממחישה את הטקסט הזה]
```

**כלל חשוב:** בסוף כל סקשן, הקופירייטר כותב **רעיון ויזואלי** — מה אפשר להמחיש כאן בתמונה, מוקאפ, או אנימציה. זה ה-input ל-Agent 7.

### 🔑 חכה לאישור על הקופי לפני שממשיכים!

---

## Agent 7: מעצב ויזואלי (Visual Designer) — 🔑 נקודת אישור

### מטרה
לעבור סקשן-סקשן על הקופי ולהגדיר בדיוק איזו תמונה/מוקאפ/אנימציה צריך — כולל פרומפטים מוכנים ל-Nano Banana.

### עבודה

לכל סקשן, שאל: **"מה הויזואל שממחיש את הטקסט הזה?"**

#### סוגי ויזואלים:

| סוג | מתי | דוגמה |
|-----|------|-------|
| **תמונת אדם** | Hero, About, Trust | פורטרט של הפרזנטור, חצי גוף, רקע שקוף |
| **מוקאפ** | Solution, Offer | מסך לפטופ שמציג דשבורד/אפליקציה |
| **תמונת proof** | Trust, Testimonials | צילומי מסך של תוצאות, הודעות |
| **אנימציה** | Pain, Solution | טלפון רוטט, מונה ספרות, לפני/אחרי |
| **אייקון/גרפיקה** | Services, Features | אייקונים מותאמים לכל שירות |
| **תמונת lifestyle** | Dream, Hero | אדם מרוצה, מוצר בשימוש |

### פורמט פלט (לכל ויזואל):

```markdown
### סקשן: [שם]

**ויזואל #1:**
- סוג: תמונה / מוקאפ / אנימציה / אייקון
- תיאור: [מה בדיוק צריך]
- מידות: [WxH px]
- Nano Banana Prompt: "[פרומפט באנגלית, מפורט]"
- עדיפות: חובה / רצוי / אופציונלי
- הערות: [מה חשוב — רקע שקוף? כיוון מבט? פלטת צבעים?]
```

### כללים:
- **כל דף צריך לפחות:** תמונת פרזנטור, 1-2 מוקאפים, 2-3 תמונות proof
- **לעולם לא** "תמונה כללית" — תמיד לתאר בדיוק מה בתמונה
- **Nano Banana prompts** = אנגלית, ספציפי, עם סגנון ומילות מפתח
- **אנימציות** — לציין אם אפשר לבנות כ-CSS/Framer Motion בלי תמונה חיצונית
- **2-3 אנימציות ממחישות** לכל דף (לא יותר) — כמו טלפון רוטט, מונה ספרות, לפני/אחרי

### 🔑 הצג ללקוח לאישור — הוא צריך לאשר את הרעיונות לפני שמייצרים!

---

## Agent 8: דירקטור אמנותי (Art Director) — 🔑 נקודת אישור

### מטרה
לבחור את הפלטה, הסגנון, הטיפוגרפיה, ורמת האנימציות — ולהפוך הכל ל-Design Brief שהבנאי עוקב אחריו.

### עבודה

הצג **3-4 כיוונים עיצוביים**, כל אחד עם:
- שם + 2-3 bullets
- פלטת צבעים (bg, text, accent, CTA)
- טיפוגרפיה
- רמת אנימציה (minimal / subtle / wow)
- סגנון מעברים (hard edges / gradient / SVG waves)
- וייב במילה אחת

### 7 Playbooks זמינים:

| # | שם | צבעים | מתי |
|---|-----|-------|------|
| 1 | WOW Dark Premium | שחור + זהב | טכנולוגיה, AI, השקות |
| 2 | Elegant Authority | נייבי + זהב מעודן | ייעוץ, ליווי, high-ticket |
| 3 | Clean Light | בהיר + ירוק CTA | קורסים, קהל רחב |
| 4 | White DR | לבן טהור + ירוק מנטה | ספרים, low-ticket, מכתב |
| 5 | Feminine White DR | לבן + קורל/ורוד | נשים, קורסים, brand אישי |
| 6 | Dark Funnel | teal + lime + אדום | affiliate, countdown |
| 7 | Hybrid | מיקס | כשכלום לא מתאים בול |

### פלט (הצגה ללקוח)

```markdown
## 3 כיוונים עיצוביים:

### 1. "[שם]" — [וייב במילה]
- [2-3 bullets על המראה]
- צבעים: bg [X] + accent [X] + CTA [X]

### 2. "[שם]" — [וייב במילה]
...

### 3. "[שם]" — [וייב במילה]
...

**ההמלצה שלי:** אופציה [X] כי [שורה אחת]
```

### 🔑 חכה לאישור הכיוון!

### אחרי אישור — הוצא Design Brief JSON:

```json
{
  "designBrief": {
    "playbook": "...",
    "colors": { "bg": "...", "bgAlt": "...", "text": "...", "textSecondary": "...", "accent": "...", "cta": "..." },
    "vibe": "...",
    "animationLevel": "minimal | subtle | wow",
    "sectionTransitions": "hard-edges | gradient-dividers | svg-waves",
    "specialElements": ["..."],
    "illustrativeAnimations": ["טלפון רוטט", "מונה ספרות", "לפני/אחרי"],
    "notes": "..."
  }
}
```

---

## Agent 9: בנאי (Builder)

### מטרה
להרכיב הכל לדף Next.js חי — קופי + תמונות + עיצוב + אנימציות.

### עבודה

1. יוצר `src/app/[slug]/page.tsx` (server component — metadata)
2. יוצר `src/app/[slug]/[Name]Page.tsx` (client component — כל הדף)
3. עוקב אחרי ה-Design Brief של Agent 8
4. משלב את האנימציות הממחישות של Agent 7
5. שם placeholder מדויקים לתמונות שעדיין לא הגיעו מ-Nano Banana

### כללים טכניים:
- **RTL** — `dir="rtl"` על ה-`<main>`
- **Mobile-first** — clamp() לכל typography, גריד responsive
- **Color tokens** — `const T = { ... } as const` — אפס hex ב-JSX
- **אנימציות** — Framer Motion, `useInView`, `variants`
- **Container** — max-width 900px, padding 24px
- **Touch targets** — 44px minimum
- **Font** — 16px minimum body (prevents iOS zoom)

### צ'קליסט לפני "מוכן":
- [ ] Build עובר נקי (`npx next build`)
- [ ] Mobile viewport 375px — סקרול מלא
- [ ] Desktop viewport 1440px — סקרול מלא
- [ ] RTL layout נכון
- [ ] כל CTA מוביל ל-`#form`
- [ ] Sticky mobile CTA מופיע רק במובייל
- [ ] אנימציות לא מתחילות ב-opacity:0 (דף עובד בלי JS)

---

## כללי ברזל של הפייפליין

### 1. לעולם לא לדלג על agent
גם אם נראה מיותר. הצעדים 2-3 (אווטאר + אסטרטגיה) הם ההבדל בין דף שנקרא לדף שנסגר.

### 2. אישורים = gates, לא suggestions
כשכתוב 🔑 — **עצור ושאל.** אל תמשיך בלי OK.

### 3. קופי קודם, עיצוב אחרי
לעולם לא לעצב לפני שהקופי מוכן. העיצוב משרת את הטקסט, לא להיפך.

### 4. Surprise > Persuasion
קורא מופתע ממשיך לקרוא. קורא שמנסים לשכנע אותו סוגר את הטאב.

### 5. Clarity > Cleverness
הקורא חייב להבין תוך 3 שניות מה המוצר עושה. אם ה-USP לא ברור — הקופי נכשל.

### 6. בלי placeholder
כל טקסט = טקסט אמיתי. כל מספר = מספר ספציפי. כל תמונה = תיאור מדויק.

---

## Flow מקוצר (כשהלקוח ממהר)

אפשר לאחד agents כשיש מספיק מידע:

```
מהיר: 1+2+3 ביחד → 4 (אישור) → 5+6 ביחד → 7+8 ביחד (אישור) → 9
מלא:  1 → 2 → 3 → 4🔑 → 5 → 6🔑 → 7🔑 → 8🔑 → 9
```

### כשהלקוח אומר "דלג על שאלות":
- אחד agents 1-3 (נתח את המידע שיש + השלם)
- עדיין חייבים אישור על אנגל (Agent 4)
- עדיין חייבים אישור על קופי (Agent 6)

---

## Quick Reference

| Agent | מה שואל מהלקוח | מה מחכה לאישור |
|-------|----------------|----------------|
| 1. חוקר | שאלות מוצר | — |
| 2. אווטאר | וולידציה מהירה | — |
| 3. אסטרטג | — (עבודה פנימית) | — |
| 4. אנגל | "איזו זווית?" | 🔑 בחירת זווית |
| 5. סמכות | שאלות proof | — |
| 6. קופירייטר | — | 🔑 אישור קופי |
| 7. מעצב ויזואלי | — | 🔑 אישור רעיונות תמונות |
| 8. דירקטור | "איזה סגנון?" | 🔑 אישור פלטה |
| 9. בנאי | — | דף מוכן |

---

## Related Skills

- `hofit-goni-copy-agent` — Agent 6 uses this for the 24-step methodology
- `design-strategist` — Agent 8 uses this for playbook selection
- `hofit-goni-design-agent` — Agent 9 uses this for page building
- `framer-motion-best-practices` — Agent 9 uses for animations
- `tailwind` — Agent 9 uses for styling
