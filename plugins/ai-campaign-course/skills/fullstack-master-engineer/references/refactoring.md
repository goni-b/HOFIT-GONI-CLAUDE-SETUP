# Refactoring, Modernization & Migration

Use in IMPROVE mode to restructure code, modernize legacy, pay down tech debt, or run a large migration.

## The prime directive
**Refactoring preserves behavior.** If behavior changes, it's a feature change, not a refactor — do them
separately, in separate commits. Never mix "make it cleaner" with "make it do something new" in one change.

## Safe refactoring loop
1. **Characterize** — before changing untested code, write tests that capture current behavior (golden /
   characterization tests). These are your safety net; they should pass before and after.
2. **Small steps** — one transformation at a time (extract function, rename, inline, move). Run tests after
   each. A green-to-green sequence of tiny steps beats one big rewrite.
3. **Commit often** — each green step is a commit you can roll back to.
4. **Verify** — full test suite green; behavior identical; no new warnings.

## High-value refactors (in rough priority)
- **Extract** a long function/component into named pieces; extract duplicated logic into a shared helper.
- **Name** magic numbers/strings as constants; rename unclear identifiers.
- **Separate concerns** — pull DB calls out of route handlers into a service/repository layer
  (see `architecture-patterns.md`).
- **Reduce nesting** — early returns / guard clauses instead of deep `if` pyramids.
- **Type the boundaries** — replace `any` at module edges with real types/schemas (Zod).
- **Delete** dead code and unused deps — the safest performance and clarity win there is.

## Legacy modernization strategy
1. **Understand first** — run COMPREHEND (`code-comprehension.md`) to map the system before touching it.
2. **Add a safety net** — characterization tests around the area you'll change.
3. **Strangler-fig pattern** — wrap the old system, route new functionality through the new path, migrate
   slices incrementally. Avoid big-bang rewrites; they tend to fail.
4. **Anti-corruption layer** — adapt the old data/contracts at the boundary so new code stays clean.
5. **Upgrade deps deliberately** — one major dependency at a time, tests green between each.

## Large migrations (framework / DB / API version)
- Write the migration plan first: phases, rollback per phase, data-backfill steps, dual-write/dual-read
  window if zero-downtime is required.
- Make schema migrations reversible; test the down-migration.
- For data migrations, run on a copy first, verify counts and spot-check rows, then run for real with a
  backup and a documented rollback.
- Keep the old and new paths coexisting until the new one is proven, then remove the old.

## Tech-debt tracking
Keep a lightweight register: location, what's wrong, risk (HIGH/MED/LOW), estimated effort, and the trigger
that makes it urgent (e.g. "blocks the payments feature"). Pay down debt that sits on the critical path first;
leave isolated low-risk debt documented but untouched.

## Never
- Change behavior and structure in the same commit.
- Refactor code with no tests without first adding characterization tests.
- Do a big-bang rewrite when an incremental path exists.
- Leave the migration half-done with both paths permanently live.
