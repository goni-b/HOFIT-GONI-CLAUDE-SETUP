# Code Review — Structured, Prioritized, Constructive

Use in IMPROVE mode to review a PR, diff, or file. Output a categorized report that improves quality and
teaches, without being a style nitpick machine.

## Workflow
1. **Context** — read the PR description; understand the problem being solved.
   _Checkpoint:_ summarize the intent in one sentence. If you can't, ask the author.
2. **Structure** — does it follow existing patterns? Are new abstractions justified, or is it over-engineered?
3. **Details** — correctness, security, performance (apply the checklist below). Flag critical issues
   immediately, don't wait for the end.
4. **Tests** — are edge cases covered? Do tests assert behavior, not implementation?
5. **Report** — categorized, prioritized, with code examples and praise for what's done well.

## What to look for
**Correctness:** off-by-one, null/undefined handling, race conditions, un-awaited promises, wrong arg order,
swallowed errors (empty catch), incorrect edge-case handling.
**Security (OWASP baseline):** SQL/NoSQL injection (string-built queries), XSS (unescaped output), missing
authz (returns other users' data), hardcoded secrets, missing input validation, insecure deserialization,
SSRF, mass assignment. (Deep dive: `security-hardening.md`.)
**Performance:** N+1 queries, missing indexes, unbounded queries (no pagination), work inside loops that
belongs outside, missing caching, large bundle imports. (Deep dive: `performance.md`.)
**Maintainability:** magic numbers, dead code, copy-paste instead of extraction, files >500 lines, unclear
names, missing error handling on the unhappy path, leaked abstractions.

## Quick patterns — bad vs good
```python
# N+1 query
for u in users: Order.objects.filter(user=u)          # BAD
users = User.objects.prefetch_related('orders').all() # GOOD

# Magic number
if status == 3: ...                                    # BAD
ORDER_SHIPPED = 3
if status == ORDER_SHIPPED: ...                        # GOOD

# SQL injection
cursor.execute(f"SELECT * FROM users WHERE id = {uid}")        # BAD
cursor.execute("SELECT * FROM users WHERE id = %s", [uid])     # GOOD

# Authz gap
return db.orders.all()                                 # BAD — every user's data
return db.orders.where(user_id=current_user.id)        # GOOD — scoped
```

## Output template
1. **Summary** — one-sentence intent recap + overall assessment.
2. **Critical** — must fix before merge (bugs, security, data loss).
3. **Major** — should fix (performance, design, maintainability).
4. **Minor** — nice to have (naming, readability).
5. **Positive** — specific patterns done well (always include this).
6. **Questions** — clarifications needed.
7. **Verdict** — Approve / Request Changes / Comment.

## Tone
Be specific and actionable; include a code suggestion, not just a complaint. Praise good work. Don't be
condescending. Don't nitpick style when a linter/formatter is configured. Don't block on personal preference.
If the author explained a non-obvious choice, acknowledge their reasoning before proposing an alternative.
Reference SOLID, DRY, KISS, YAGNI where useful — but never demand perfection.
