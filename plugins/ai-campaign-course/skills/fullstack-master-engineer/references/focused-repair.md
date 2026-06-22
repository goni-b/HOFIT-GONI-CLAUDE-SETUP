# Focused Repair — Deep-Dive Feature/Module Repair Protocol

Use in REPAIR mode when an entire feature or module needs to work end-to-end: "make the X feature work,"
"the Y module is broken," "focus on Z and fix it properly." This is NOT for a single isolated bug — use
`debugging-methodology.md` for that.

## The Iron Law
```
NO FIXES WITHOUT COMPLETING SCOPE → TRACE → DIAGNOSE FIRST.
```
If you haven't finished Phase 3, you may not propose fixes. Skipping the early phases is how you get
whack-a-mole fixes that each break something new.

## The 5 phases — strictly in order

### Phase 1 — SCOPE: map the feature boundary
Before touching code: identify the primary folder/files, read every one, and produce a manifest.
```
FEATURE SCOPE
  Primary path:  src/features/<feature>/
  Entry points:  <files imported by the rest of the app>
  Internal files: <files used only within this feature>
  Files: N   Lines: N
```

### Phase 2 — TRACE: map every dependency, both directions
**Inbound** (what this feature imports): for each import, confirm the source exists, the entity is exported,
and signatures match. Also capture env vars, config files, DB models, API calls, third-party packages.
**Outbound** (what imports this feature): grep the whole codebase for imports from this folder; verify each
consumer uses entities that exist and the correct interface.
```
DEPENDENCY MAP
  Inbound:  src/lib/db.ts → repository.ts (getUser, createUser)
            process.env.JWT_SECRET → service.ts
  Outbound: api/login/route.ts → imports { login } from service
  Env required: JWT_SECRET, DATABASE_URL    Config: prisma/schema.prisma (User)
```

### Phase 3 — DIAGNOSE: find every issue, confirm every root cause
Run all checks; don't stop at the first finding.
- **Code:** every import resolves; no circular deps; types consistent at boundaries (no `any`); async errors
  handled; no TODO/FIXME hiding a known break.
- **Runtime:** required env vars set (check `.env`); migrations current; endpoints return expected shapes; no
  hardcoded values that should be config.
- **Tests:** find and run every test that imports from this feature; record each failure verbatim; note
  untested paths.
- **Logs & history:** check error logs; `git log --oneline -20 -- <feature>` and recent commits to its
  dependencies — a recent change may be the cause.
- **Root-cause confirmation:** for each critical issue, state "X is the root cause because Y" and trace the
  flow backward to verify. Don't trust surface symptoms.

Label each issue's risk and report:
| Risk | Criteria |
|---|---|
| HIGH | Public API / breaking contract / DB schema / auth/security / widely imported (>3 callers) / git hotspot |
| MED | Internal module with tests / shared utility / config with runtime impact |
| LOW | Leaf module / isolated file / test-only change |
```
DIAGNOSIS REPORT
  CRITICAL: 1. [HIGH] service.ts:45 — token signed with wrong arg order. Root cause: confirmed by test X.
  WARNINGS: 1. [MED] repository.ts:12 — missing null check.
  TESTS: ran 23, passed 16, failed 7 [list each failure].
```

### Phase 4 — FIX: repair in dependency order
Fix in this exact order: **deps → types → logic → tests → integration.** Fix HIGH before MED before LOW. One
issue at a time; run the related test after each fix. If a fix breaks something else, STOP and return to
DIAGNOSE. Never change code outside the feature folder without stating why.
```
FIX #1  service.ts:45 — swapped (expiresIn, payload)→(payload, expiresIn). Test auth.test.ts → PASS
```
**3-strike escalation:** if 3+ fixes create NEW issues (not pre-existing), STOP. That pattern means an
architectural problem, not a bug collection. Tell the user: "3+ fixes have cascaded into new issues — this
suggests the feature's architecture needs rethinking, not patching. Here's what I found: […]. Continue
patching, or discuss restructuring?" Do not attempt fix #4 without that conversation.

### Phase 5 — VERIFY: prove it works
Run every test in the feature folder, then every test in files that import from it, then the full suite
(check for regressions). For UI, describe manual verification. Summarize all changes.
```
FOCUSED FIX COMPLETE
  Feature: auth   Files changed: 4   Fixes: 7   Tests: 23/23   Regressions: 0
  Consumers verified: api/login ✓  api/register ✓  middleware ✓
```

## Red flags — if you think any of these, return to the phase you're in
- "I can see the bug, let me just fix it" → you haven't traced dependencies.
- "Scoping is overkill, it's obviously one file" → it never is, for feature-level work.
- "Tests pass so I'm done" → did you run the consumers' tests too?
- "I don't need to check env vars" → config issues masquerade as code bugs.
- "One more fix should do it" (after 2+ cascades) → escalate instead.

## Common rationalizations (all false)
| Excuse | Reality |
|---|---|
| "Small feature, skip the phases" | Phases 1–2 take minutes for small features. Do them. |
| "I already know this codebase" | Knowledge decays. Trace the actual imports. |
| "User wants speed, not process" | Skipping phases causes rework. Systematic is faster than thrashing. |
| "Root cause is obvious" | "Obvious" root causes are frequently wrong. Confirm with evidence. |

## Quick reference
| Phase | Action | Output |
|---|---|---|
| SCOPE | Read every file, map entry points | Feature manifest |
| TRACE | Map inbound + outbound deps | Dependency map |
| DIAGNOSE | Check code, runtime, tests, logs; confirm root causes | Diagnosis report |
| FIX | deps → types → logic → tests → integration | Fix log per issue |
| VERIFY | Run all tests + consumers; summarize | Completion report |
