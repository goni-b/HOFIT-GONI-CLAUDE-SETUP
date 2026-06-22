# Security Hardening

Use in IMPROVE/SHIP mode, and keep it in mind during BUILD. Security is a property of every layer, not a
feature you add at the end.

## Non-negotiables
- **Validate on the server.** Client validation is UX; it is never the gate. Validate and sanitize every
  input server-side (Zod/Pydantic schemas).
- **Parameterize every query.** Never build SQL/NoSQL by string concatenation. Use parameters / the ORM's
  safe API.
- **Scope every query by the current user.** The default for any data fetch is `where user_id = current_user`.
  Returning another user's row is a critical bug.
- **Never hardcode or commit secrets.** Use env vars; provide `.env.example` with names only; ensure `.env`
  is gitignored. Rotate anything that leaked.

## OWASP-style checklist (baseline)
- **Injection** — SQL, NoSQL, command, LDAP. Parameterize; never pass user input to a shell.
- **Broken access control** — enforce authz on the server for every protected route and every object
  (IDOR: check the object belongs to the user, not just that the user is logged in).
- **Authentication** — hash passwords with bcrypt/argon2 (never plaintext/MD5/SHA1); rate-limit login;
  secure session/JWT handling (httpOnly cookies or short-lived tokens + refresh); invalidate on logout.
- **XSS** — escape/encode output; avoid `dangerouslySetInnerHTML`/`v-html` with user content; set a
  Content-Security-Policy.
- **CSRF** — for cookie-based auth, use CSRF tokens or SameSite cookies on state-changing requests.
- **Sensitive data exposure** — return explicit response schemas (never `SELECT *` to the client); don't leak
  password hashes, tokens, internal errors, or stack traces to users; HTTPS everywhere.
- **SSRF** — validate/allowlist any URL the server fetches on the user's behalf.
- **Security misconfiguration** — no debug mode in prod; least-privilege DB user; CORS locked to known
  origins; security headers (HSTS, X-Content-Type-Options).
- **Vulnerable dependencies** — run `npm audit` / `pip-audit`; patch criticals before shipping.
- **Insufficient logging** — log auth events and security-relevant actions (without logging secrets/PII).

## Secrets hygiene
- Secrets live in env/secret manager, not in code, not in the client bundle, not in git history.
- LLM and payment keys are server-side only — never expose `OPENAI_API_KEY`/`ANTHROPIC_API_KEY`/Stripe secret
  in client code.
- Use different secrets per environment; never reuse prod secrets in dev.

## AI/LLM-specific (when the app uses an LLM)
- **Prompt injection** — treat model output and tool results as untrusted; don't let them trigger privileged
  actions without checks; constrain tools and validate their arguments.
- Don't put secrets in prompts; don't echo user PII into logs via the model.
- Rate-limit and cap token usage to prevent cost-based abuse.

## Method
1. Identify the trust boundaries (where untrusted input enters).
2. Walk the checklist against the code at each boundary.
3. Report findings by severity (critical → advisory) with file:line and a concrete fix.
4. Re-verify after fixes. For a full pre-ship pass, run `ship-gate.md`.
