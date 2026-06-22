# Landing Pages & Conversion Rate Optimization (CRO)

Use in COMMERCE mode to build or improve a landing/sales page. A landing page has exactly one job: convert a
specific visitor to a specific action. Optimize for that, not for decoration.

## The one-job principle
One page, one audience, one goal, one primary CTA. Every element either moves the visitor toward that action
or it's noise. Remove navigation and competing links that leak attention away from the conversion.

## Anatomy of a high-converting page (top to bottom)
1. **Hero** — a headline that states the specific outcome/benefit (not a clever slogan), a one-line subhead
   that clarifies, and the primary CTA above the fold. The visitor should know within 5 seconds: what is this,
   who is it for, what do I do next.
2. **Message-match** — the headline must match the ad/email that sent them here. Mismatch = bounce. Mirror the
   promise and the wording.
3. **Problem → solution** — name the pain in the visitor's own words, then position the offer as the path out.
4. **Proof** — testimonials, logos, numbers, before/after, ratings. Specific beats generic
   (real names/results > "great product"). Place proof near each CTA.
5. **How it works** — 3 simple steps; reduce perceived effort and risk.
6. **Objection handling / FAQ** — answer the top reasons people won't buy (price, time, trust, "will it work
   for me").
7. **Offer & risk reversal** — make the offer concrete; add a guarantee where appropriate to lower risk.
8. **Repeated CTA** — the same single action, restated at natural decision points. One offer, not five.

## Conversion mechanics that matter most
- **Speed** — a slow page kills conversion before the copy is read. Optimize LCP (<2.5s), compress images,
  defer non-critical JS. (See `performance.md`.)
- **Mobile-first** — most traffic is mobile; design for 375px first, tap targets large, forms short.
- **Form friction** — ask for the minimum fields. Every extra field drops conversion. Inline validation,
  clear errors, a submit button that shows progress and can't double-submit.
- **CTA clarity** — action + value ("Start free trial," "Get the course"), high contrast, unmissable.
- **Trust signals** — security/payment badges near the form, privacy reassurance, real contact info.
- **Visual hierarchy** — the eye should land on headline → benefit → CTA. Whitespace and contrast guide it.

## CRO method (improving an existing page)
1. **Define the conversion** and measure the current rate; identify where visitors drop (analytics, heatmaps,
   session recordings, form-field analytics).
2. **Diagnose** against the anatomy and mechanics above — what's missing, unclear, slow, or high-friction.
3. **Prioritize** fixes by expected impact × ease (clarity of the offer and CTA, page speed, form friction,
   and proof usually move the needle most).
4. **Form testable hypotheses** — "Changing the headline to state the outcome will raise sign-ups, because
   visitors currently can't tell what they get." One change per test where traffic allows A/B testing.
5. **Measure the delta**; keep wins, revert losses.

## For Israeli-market pages
Default to Hebrew + RTL (`hebrew-rtl.md`): RTL layout, Heebo/Assistant fonts, phone/email inputs forced
`dir="ltr"`, and copy in direct, plain Hebrew that matches the ad. Trust and risk reversal are especially
persuasive locally — make the guarantee and contact details prominent.

## Never
- Add navigation and competing links that leak attention from the single CTA.
- Mismatch the headline and the ad that drove the click.
- Ship a slow or form-heavy page and blame the copy.
- Claim a change "improved conversion" without before/after numbers.
