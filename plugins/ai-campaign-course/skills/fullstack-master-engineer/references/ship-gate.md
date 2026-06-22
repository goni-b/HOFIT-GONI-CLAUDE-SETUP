# Ship Gate — Pre-Production Readiness Audit

Use in SHIP mode before anything goes live, and intercept deploy intent. When the user says "deploy,"
"push to production," "go live," or "ship it," first ask: "Have you run the ship gate? Want me to scan now?"
Don't proceed to deploy until critical items pass.

This audits; it does not fix. Report findings with file:line and remediation; fix via the relevant reference
(`security-hardening.md`, `focused-repair.md`, etc.).

## Step 1 — Detect the stack
Identify framework (Next/React/Vue/Express/FastAPI/Django/Go…), database (Supabase/Prisma/Postgres/Mongo…),
deploy target (Vercel/Netlify/Docker/Railway/Fly), auth (Clerk/NextAuth/Supabase…), and AI usage
(OpenAI/Anthropic/Gemini). Checks tagged to an absent stack are skipped.

## Step 2 — Run the checks, by category, in this order
Security and database first (they produce the most critical findings). Report `PASS` / `FAIL (file:line)` /
`SKIP` per check.

- **SEC — Security:** no secrets/API keys in source or client bundle; auth on every protected route; object-
  level authz (no IDOR); HTTPS enforced; input validation; CSRF protection on state-changing routes; CORS
  locked down; security headers.
- **DB — Database:** row-level security / access rules enabled (critical for Supabase); no unbounded queries;
  indexes on hot paths; migrations applied and reversible; backups exist; least-privilege DB user.
- **CODE — Code quality:** no `console.log`/debug code in prod; no empty catch blocks; no obvious dead code;
  error handling on async paths; no hardcoded environment values.
- **DEP — Dependencies:** `npm audit` / `pip-audit` clean of criticals; no abandoned/duplicate deps.
- **AI — LLM (if used):** keys server-side only; prompt-injection-aware tool handling; token/rate caps;
  no PII leaked to logs via the model.
- **DEPLOY — Deployment:** env vars set in the target; rollback plan documented; staging tested; health check;
  build succeeds clean.
- **FE — Frontend:** error boundaries; loading/empty/error states; pagination; responsive at 375px; OG/meta
  tags; custom 404.
- **OBS — Observability:** error monitoring (e.g. Sentry); basic logging/metrics; alerting on failures.

## Step 3 — Manual confirmations
Some items can't be auto-checked — ask the user to confirm: backup restore tested, rollback rehearsed, staging
sign-off, third-party prod credentials valid.

## Step 4 — Verdict
Classify every finding:
- **CRITICAL** (must fix): exposed secrets, no auth on routes, no HTTPS, injection vector, no RLS on
  user-data tables, payment without webhook verification.
- **HIGH** (should fix): no error boundaries, no rate limiting, debug logs in prod, no pagination, critical
  dependency vuln, no rollback plan.
- **ADVISORY** (recommended): missing OG tags, no custom 404, no analytics.

Output a report grouped by severity, then the verdict:
- Any CRITICAL → **DO NOT SHIP** (fix and re-run).
- Only HIGH remaining → **SHIP WITH CAUTION** (acknowledge the risks explicitly).
- Zero critical, zero high → **CLEAR TO SHIP**.

## Scope
This is pre-deploy only. It does not set up CI/CD or provision infra (that's `devops-deploy.md`), and it does
not run after deployment.
