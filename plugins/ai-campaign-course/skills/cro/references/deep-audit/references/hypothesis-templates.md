# Hypothesis Templates by Issue Type

Every recommendation should be a testable hypothesis, not an opinion. The structure below keeps the user (and you) honest about what's evidence and what's a guess.

## The base template

> **Because** [evidence — heatmap, drop-off data, user quote, heuristic finding, benchmark gap]
> **we believe that** [proposed change]
> **will result in** [primary metric] changing by [magnitude] over [time/sample]
> **We'll know we're right when** [stop condition / decision criterion]
> **We'll know we're wrong when** [counter-condition — be honest about what failure looks like]

---

## Templates by issue category

### Headline / value proposition

> Because the bounce rate above the fold is X% and the exit survey shows "couldn't tell what you do" as the top reason for leaving, we believe that replacing the current headline ([current]) with a specific outcome-focused headline ([proposed]) will increase scroll-past-fold rate from X% to Y% and form starts from A% to B% within 4 weeks.

### CTA copy

> Because the current CTA "[current copy]" is generic-action language and CTR on the primary button is X%, we believe that replacing it with verb-first outcome-framed copy ([proposed: "Get my free audit"]) will lift CTR from X% to Y%, based on prior research that outcome-framed CTAs outperform generic ones by 25-100% in similar contexts.

### Form length

> Because session recordings show 60%+ of mobile users abandon at field 4 of the form, and Imagescape research shows 11→4 fields produced a 120% lift, we believe that cutting the form from N fields to the qualifying minimum of 3 (name, email, [qualifier]) will lift form completion from X% to Y%, with quality maintained as measured by [downstream metric: SQL rate, customer LTV].

### Trust / social proof

> Because the page has no testimonials above the price point, and the exit survey shows "wasn't sure if it actually works" as the #2 objection, we believe that adding 3 outcome-quantified testimonials (with name, role, photo) directly above the pricing section will lift conversion from X% to Y%.

### Friction reduction

> Because PageSpeed Insights shows mobile LCP at 4.2s and bounce rate on mobile is 73% (vs 41% desktop), we believe that compressing the hero image from 2.4MB to <300KB and lazy-loading below-fold images will drop LCP below 2.5s and lift mobile conversion from X% to Y% — based on the well-established correlation of ~7% conversion loss per second of load time.

### Cognitive load / clarity

> Because the heatmap shows visitors spending 8+ seconds on the hero before any scroll or click — well above the 3-5 second engagement window — we believe that removing the [secondary CTA / sub-headline / decorative element] will reduce time-to-action and lift CTR on the primary CTA from X% to Y%.

### Mobile experience

> Because mobile drives 78% of traffic but converts at 1.4% vs desktop's 3.8% (a typical 40-50% mobile gap), and the form is currently below-fold on mobile with no sticky CTA, we believe that adding a sticky bottom CTA on mobile + raising the form above the fold on mobile viewports will lift mobile conversion from 1.4% toward the desktop benchmark of 3.8%.

### Pricing transparency

> Because the FAQ section shows "How much does it cost?" as a frequently-asked question and pricing is currently behind a "Contact sales" wall, we believe that displaying transparent starting pricing on the page will lift form-fill rate from X% to Y% by eliminating the largest friction (price uncertainty), while quality of leads is monitored via [SQL rate].

### Above-the-fold CTA

> Because the current page has no CTA visible until scroll-depth 65% and known industry data shows above-fold CTAs convert ~3x better, we believe that adding a primary CTA in the hero section will lift overall conversion from X% to Y%.

### Source-page message match

> Because the [paid ad / email / search ad] headline is "[exact source headline]" but the landing page headline is "[different page headline]", we believe that aligning the page headline to mirror the ad will reduce bounce rate from X% to Y% and lift conversion from A% to B% within 2 weeks of launching the test.

### Anxiety reduction

> Because no money-back guarantee, no privacy reassurance near the email field, and no contact information are visible on the page, we believe adding (a) "30-day no-questions-asked guarantee" near the CTA, (b) "We never share your email" near the email field, and (c) a real phone number in the footer will reduce form abandonment from X% to Y%.

### Scarcity / urgency

> Because the offer has a real, finite cohort start date but it's mentioned only in fine print, we believe that adding a clearly-visible cohort countdown ("Cohort starts March 15 — 8 spots left") will lift conversion from X% to Y% by adding honest explicit urgency to the existing implicit urgency.

---

## Anti-pattern hypotheses (don't write these)

❌ "Change the button color from blue to green" — no theory of why, no expected magnitude, no evidence.
❌ "Make the headline better" — undefined what "better" means.
❌ "Add more social proof" — vague; what kind, where, why?
❌ "Improve the page" — meaningless.
❌ "I think a video would convert better" — based on what?

If you can't write the hypothesis in the structured format, you don't yet have enough information to recommend the change. Either gather evidence or label it "investigate first."

---

## When the user has no traffic to A/B test

Below ~1,000 conversions/month per page, A/B tests rarely reach statistical significance. In this case:

1. **Ship the obvious fixes.** Anything that's clearly wrong (broken element, vague CTA, slow page, no trust signals) — just fix it. Don't test obvious things.
2. **Sequential testing instead of A/B.** Make a change, measure 2-4 weeks before/after, accept that confounding factors (seasonality, traffic sources) will muddy results.
3. **Lean harder on qualitative.** 5 user interviews + heatmap + session recordings will teach you more than a statistically-anemic A/B test.
4. **Use the change as a hypothesis investment.** Document what you changed and why; when traffic grows, you'll have a backlog of theory-driven tests ready.

Be transparent with the user: "Below this traffic threshold, we're using best-guess shipping with monitored before/after rather than rigorous A/B tests. We'll start true testing once we have ~10,000 sessions/month on this page."

---

## Test result interpretation cheatsheet

When the user comes back with test results, help them interpret honestly:

- **Statistical significance ≥95%, expected direction** — implement, monitor for 2-4 more weeks for novelty effects, document the learning.
- **Statistical significance ≥95%, opposite direction** — implement nothing. Investigate why your hypothesis was wrong. Often the most valuable result.
- **Inconclusive after planned sample size** — accept that the change probably has near-zero effect. Do *not* extend the test hoping for significance — that's p-hacking.
- **Big lift, small sample** — don't trust it. Run to your pre-planned sample size. Early lifts often regress to mean.
- **Win on overall metric, loss on segment** — investigate. May be safe to ship if the losing segment is small or low-value, dangerous if it's your highest-LTV segment.

Statistical rigor matters because false wins shipped feel like progress while quietly hurting revenue.
