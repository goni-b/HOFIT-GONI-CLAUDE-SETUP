# CRO Frameworks — Full Reference

This document holds the in-depth explanations of every framework SKILL.md only summarized. Read it when an audit needs more depth than the main skill provides — for example, a B2B SaaS user asking specifically about which Cialdini principles to apply, or a copywriter asking which formula fits a long-form sales page.

## Table of contents
1. The LIFT Model (full)
2. The ResearchXL Framework (full)
3. Prioritization: PIE, ICE, RICE, PXL
4. Cialdini's 7 Principles of Persuasion
5. Fogg Behavior Model (B = MAT)
6. Nielsen's 10 Usability Heuristics
7. Copywriting frameworks: AIDA, PAS, BAB, FAB, 4Ps, AICPBSAWN, QUEST
8. Cognitive biases & UX laws
9. The MECLABS Conversion Sequence Heuristic

---

## 1. The LIFT Model (Chris Goward, WiderFunnel, 2009)

LIFT = **L**anding page **I**nfluence **F**unction for **T**ests. The most-used heuristic framework in modern CRO. It treats the page as an airplane: the Value Proposition is the wing generating lift, while the other five factors are either thrust (Relevance, Clarity, Urgency) or drag (Anxiety, Distraction).

### Value Proposition
The cost-vs-benefit equation in the visitor's mind. To strengthen it: clarify the unique outcome, quantify the benefit, reduce perceived cost (price, time, effort, risk).
Sub-questions:
- What does the visitor *gain*? (function, status, time, money, peace of mind)
- What's it *costing them*? (price, learning curve, switching cost, social risk)
- Why is *this* the best way to get the gain?

### Relevance
Match between the page and what the visitor was promised by the source.
- Does the page headline echo the ad/email/search keyword?
- Is the visual continuity strong (same hero image, same colors)?
- Does the offer match the segment? (B2B page shouldn't pitch like B2C)

### Clarity
Two layers: design clarity (visual hierarchy, eye flow) and content clarity (jargon-free copy, scannable structure).
- Can a 5-year-old explain what you do after looking for 5 seconds? (5-second test)
- Is the next action obvious without thinking?
- Are headlines self-contained? (Body copy should reinforce, not introduce.)

### Anxiety
Anything that triggers doubt at the moment of decision: privacy concerns, hidden costs, unclear cancellation, legitimacy worries, technical uncertainty.
Counters: explicit guarantees, "no credit card", visible privacy policy, customer service info, security badges, real photos of real people.

### Distraction
Anything that pulls the eye or thought away from the conversion path.
Common culprits: navigation menus on paid landing pages, sliders/carousels, autoplay video, multiple competing CTAs, social media icons that link out, popups, excessive options.

### Urgency
Why now? Implicit urgency = the pain is ongoing and getting worse. Explicit urgency = a real deadline, limited spots, time-sensitive bonus.
Honest urgency works; fake urgency (countdown timers that reset, "only 3 left" that's always true) burns trust the moment it's spotted.

The LIFT visualization stacks the factors around the value proposition wing. WiderFunnel claims average lifts of 10-277% across clients using this analysis.

---

## 2. ResearchXL Framework (Peep Laja, CXL)

Six diagnostic angles. The premise: heuristic analysis alone is biased; combine it with data to find what actually matters.

### Step 1 — Heuristic analysis
Use LIFT (above) or any expert-based framework. Catalog issues with a 1-5 severity rating. This is fastest but bias-prone — never your only step if data is available.

### Step 2 — Technical analysis
Bugs are the silent #1 conversion killer. Check:
- Site speed (PageSpeed Insights, GTmetrix, WebPageTest)
- Cross-browser (CrossBrowserTesting, BrowserStack)
- Mobile rendering on real devices
- Form submission across edge cases (slow connections, autofill, copy-paste from password managers)
- Console errors, broken images, 404 resources, mixed-content warnings
- Analytics setup health: are events firing correctly?

### Step 3 — Web analytics analysis
GA4 plus whatever revenue/CRM data exists. Look for:
- Funnel drop-offs by step
- Device segmentation (desktop vs mobile vs tablet)
- Traffic-source segmentation (paid vs organic vs email vs direct)
- Browser/OS conversion gaps (sometimes a single bad combo is killing 20% of revenue)
- Geographic patterns
- New vs returning behavior
- Time-on-page and scroll-depth correlations with conversion

### Step 4 — Mouse tracking & session recordings
Tools: Hotjar, Microsoft Clarity (free), Smartlook, FullStory.
Look for:
- Heatmaps — what's clicked, what's ignored, what's clicked thinking it's a link
- Scroll maps — where the page "ends" for most users
- Session recordings — where users hesitate, rage-click, or abandon
- Form analytics — which field is the abandonment field

### Step 5 — Qualitative research
Tools: Hotjar Polls, Qualaroo, Typeform, plain email surveys.
Best questions:
- "What almost stopped you from buying today?" (post-purchase)
- "What were you hoping to find on this page?" (on-page exit intent)
- "What other options did you consider?" (post-purchase)
- "In your own words, what does our product do?" (existing customers — reveals their language)
- Open-ended beats multiple choice — you want their words, not yours.

Interview 5-10 customers; you'll see patterns by interview 3.

### Step 6 — User testing
Tools: UserTesting, Maze, Lookback, in-person.
Have 5+ strangers (matching your target segment) attempt to convert while narrating aloud. Watch where they pause, what confuses them, what they ignore. Brutal but the highest-leverage qualitative method.

After all six, build a **master sheet** of every issue found, then bucket into:
- **Test** — big enough opportunity to A/B test
- **Just do it** — obvious fix, ship now
- **Hypothesize** — problem clear, solution unclear, brainstorm next
- **Investigate** — needs more digging
- **Instrument** — fix tracking before you can act

---

## 3. Prioritization frameworks

### PIE (Potential, Importance, Ease)
By Chris Goward at WiderFunnel. Best for **page-level** decisions ("which page should we focus on this quarter?").
- **Potential** — how much room for improvement on this page? (Currently performing badly = high potential.)
- **Importance** — how much traffic/revenue flows through it? (Homepage = high. Niche FAQ page = low.)
- **Ease** — design + dev + analytics effort.
- Score each 1-10, sum, sort.

### ICE (Impact, Confidence, Ease)
Popularized by Sean Ellis. Best for **hypothesis-level** decisions ("which test should we run next?").
- **Impact** — expected lift if it wins
- **Confidence** — how sure are we, based on evidence?
- **Ease** — implementation effort
- Score each 1-10, sum, sort.

ICE's flaw: with only three factors, the same idea can score very differently across team members. Always calibrate scales together first.

### RICE (Reach, Impact, Confidence, Effort)
Used at Intercom and many product teams. Adds Reach to ICE.
- **Reach** — how many users does this affect per quarter?
- **Impact** — per-user effect (massive, high, medium, low, minimal)
- **Confidence** — how sure are you? (high 100%, medium 80%, low 50%)
- **Effort** — person-months
- Score = (Reach × Impact × Confidence) / Effort

### PXL
By CXL. Most rigorous — uses 14 binary criteria (above-fold? high-traffic page? based on user research? above 5% conversion potential? etc.) plus an Effort column. Better for mature programs running 10+ tests/month.

**Hybrid recommendation**: ICE for quick triage of 30+ ideas, PXL or weighted scoring for the final ranking of the top 15-20.

---

## 4. Cialdini's 7 Principles of Persuasion

From *Influence: The Psychology of Persuasion* (1984) and *Pre-Suasion* (2016). These are not tricks — they're how human decision-making actually works.

1. **Reciprocity** — when someone gives, the recipient feels compelled to return. *Application:* free templates, audits, samples, content. The free thing has to be genuinely valuable, not a thinly veiled lead magnet.
2. **Commitment & consistency** — once people take a small action, they want to remain consistent with it. *Application:* multi-step forms (small ask first), quizzes, interactive tools, free trials before purchase.
3. **Social proof** — people look to others' behavior to inform their own. *Application:* testimonials, customer counts, recent activity ("32 signed up this hour"), reviews, logo bars, case studies.
4. **Authority** — people defer to credible experts. *Application:* credentials, press mentions ("As seen in..."), author expertise, certifications, awards, expert endorsements.
5. **Liking** — people are persuaded by people they like. *Application:* relatable founder story, human photos (not stock), conversational tone, shared values.
6. **Scarcity** — perceived rarity increases value. *Application:* genuine deadlines, limited cohorts, low-stock alerts. Must be real — manufactured scarcity destroys trust faster than almost anything.
7. **Unity** — shared identity bonds. *Application:* "for founders, by founders", local-community framing, niche-specific positioning ("the CRM built specifically for veterinary clinics").

Audit a page by literally asking: how many of these seven am I using? How honestly?

---

## 5. Fogg Behavior Model

BJ Fogg, Stanford. **Behavior = Motivation × Ability × Trigger** (B = MAT).

For a behavior (a conversion) to occur, all three must be present at the same moment:
- **Motivation** — does the user want this? (pleasure/pain, hope/fear, social acceptance/rejection)
- **Ability** — can they easily do it? (time, money, physical effort, brain cycles, social deviance, non-routine)
- **Trigger** — is there a prompt at the right moment? (CTA, notification, reminder)

Practical implication: **don't try to motivate when the bottleneck is ability**. If your form has 17 fields, no amount of urgent copy will fix it. Cut the fields. The cheapest conversion lifts almost always come from increasing ability (reducing friction), not from increasing motivation (more persuasion).

---

## 6. Nielsen's 10 Usability Heuristics

Created 1994, refined since. Severity scale: 0 (no problem) to 4 (catastrophe). Address 3s and 4s first.

1. **Visibility of system status** — show what's happening (loading states, progress bars, success messages)
2. **Match between system and real world** — speak the user's language, not yours
3. **User control & freedom** — easy undo, easy escape, no traps
4. **Consistency & standards** — same patterns, predictable behavior, follow conventions
5. **Error prevention** — design out errors before they happen
6. **Recognition rather than recall** — show options, don't make users remember
7. **Flexibility & efficiency of use** — shortcuts for experts, simplicity for novices
8. **Aesthetic & minimalist design** — every element earns its place
9. **Help users recognize, diagnose, recover from errors** — clear, jargon-free error messages
10. **Help & documentation** — searchable, contextual, focused on tasks

For landing pages, #2 and #10 are most often violated. Marketing-speak that doesn't match how customers describe their problem = a relevance problem in LIFT terms.

---

## 7. Copywriting frameworks

Pick the framework that matches the audience's awareness state, not your preference.

### AIDA (Attention, Interest, Desire, Action)
Best for: **solution-aware** audiences already evaluating options. Sales pages, ad copy, hero sections.
- **Attention** — strong hook, specific outcome
- **Interest** — relevant detail that earns the next 30 seconds
- **Desire** — emotional and rational benefits, vivid future
- **Action** — clear, low-friction CTA

### PAS (Problem, Agitate, Solution)
Best for: **problem-aware** audiences who feel the pain but haven't picked a fix. Email, blog intros, ads.
- **Problem** — name their specific pain
- **Agitate** — make it concrete, name the cost of inaction
- **Solution** — your offer as the resolution

PAS is overused; when your audience is already painfully aware, you can skip the agitation and go straight to BAB.

### BAB (Before, After, Bridge)
Best for: transformation-driven offers — courses, software, services, coaching. Case studies, social posts.
- **Before** — current painful state
- **After** — vivid better future
- **Bridge** — your offer as the connection

### FAB (Features, Advantages, Benefits)
Best for: technical or considered purchases (B2B SaaS, engineered products).
- **Feature** — what it is ("256-bit encryption")
- **Advantage** — what it does ("data is unreadable if intercepted")
- **Benefit** — what it means for the user ("you can sleep at night knowing client data is safe")

Most copy stops at Features. Always push to Benefit.

### 4Ps (Promise, Picture, Proof, Push)
Best for: long-form sales pages.
- **Promise** — bold outcome claim
- **Picture** — vivid description of the result
- **Proof** — evidence (case studies, data, testimonials)
- **Push** — the final CTA with urgency

### AICPBSAWN (Eugene Schwartz)
For long-form, cold-traffic sales pages. The full pre-internet direct-response stack.
**A**ttention → **I**nterest → **C**redibility → **P**roof → **B**enefits → **S**carcity → **A**ction → **W**arn → **N**ow.
Use when the offer is high-ticket, the audience is cold, and you need to overcome 12 objections in a single read.

### QUEST
- **Q**ualify — speak to the right reader
- **U**nderstand — show empathy with their situation
- **E**ducate — share insight that reframes the problem
- **S**timulate — make them want it
- **T**ransition — guide to the offer

### Awareness-state framework (Eugene Schwartz)
Match the framework to where the reader is:
- **Unaware** — they don't know they have a problem → tell a story, lead with curiosity
- **Problem-aware** — they feel the pain, don't know solutions exist → PAS
- **Solution-aware** — they know solutions exist, comparing → AIDA, BAB
- **Product-aware** — they know your product, weighing it → FAB, 4Ps, social proof
- **Most aware** — ready to buy → tight headline, clear offer, friction-free CTA

A landing page for cold traffic and one for retargeted visitors are entirely different beasts — never use the same copy.

---

## 8. UX laws & cognitive biases worth knowing

- **Hick's Law** — decision time grows with the number of options. Cut choices.
- **Fitts's Law** — time to acquire a target depends on size and distance. Big buttons, near where the eye is.
- **Miller's Law** — short-term memory holds ~7 items. Chunk in groups of 5-9.
- **Doherty Threshold** — productivity soars when system response is <400ms. Speed matters cognitively.
- **Jakob's Law** — users expect your site to work like other sites they know. Don't reinvent.
- **Loss aversion** — losses feel ~2x more powerful than gains. "Stop losing $X/month" beats "Save $X/month".
- **Anchoring** — first number seen biases everything after. Show the highest-tier price first.
- **Decoy effect** — adding a deliberately worse option makes the target option look better. Three-tier pricing leverages this.
- **Endowment effect** — people overvalue what they already have. Free trials work because users feel the product is "theirs" before paying.
- **IKEA effect** — we value things more when we've put effort into them. Onboarding flows that ask the user to build/customize increase retention.
- **Default bias** — most people pick the default. Pre-select the recommended plan.
- **Peak-end rule** — people remember the most intense moment and the ending. Make checkout/onboarding satisfying at the end.

---

## 9. MECLABS Conversion Sequence Heuristic

Flint McGlaughlin's formula:

**C = 4m + 3v + 2(i-f) - 2a**

Where:
- C = probability of conversion
- m = motivation of the user (0-10)
- v = clarity of the value proposition
- i = incentive to take action
- f = friction
- a = anxiety

The coefficients matter: motivation is weighted 4x, value prop 3x. *Friction and anxiety subtract.* This is a heuristic, not a real equation, but it's a useful mental model: doubling clarity does more than halving anxiety, and motivation eats everything else for breakfast.

In practice: **the user's pre-existing motivation (which you can't change) sets the ceiling. Your job is to get clarity and value-prop right, then minimize friction and anxiety.**
