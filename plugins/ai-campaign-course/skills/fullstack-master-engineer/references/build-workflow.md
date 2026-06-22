# Build Workflow — The 5 Phases for Greenfield Apps & Large Features

Use in BUILD mode. No code is written before an approved plan exists. Planning is the difference between a
project that ships and one that drowns in rework.

## Three pillars (equal weight)
1. **Structured planning before code** — an approved plan first, always.
2. **Beautiful, professional UI/UX** — generic AI-looking interfaces are a failure state (`design-system.md`).
3. **End-to-end data integrity** — every feature works through the whole stack (`data-flow-verification.md`).

## Phase 1 — Discovery & scoping
Understand before designing:
1. What does the app DO? (one-sentence core value)
2. Who uses it? (roles: admin, user, guest, client… and what each can do)
3. What data lives in it? (entities + relationships)
4. What actions can users take? (CRUD + business logic + integrations)
5. External systems? (third-party APIs, AI, auth, payments, email, storage)
6. Language & direction? (Hebrew/RTL / English / bilingual — affects fonts & layout)
7. Constraints? (hosting, mobile/desktop, scale, deadline)

Ask only architecture/product questions, and only when truly unclear — use `ask_user_input_v0` for clean
multi-choice. Do NOT ask about the tech stack unless the user has a preference (choosing it is your job).

## Phase 2 — Tech stack selection
Your decision, with reasoning. Default to the owner's stack (`my-stack.md`); see `tech-stack-decision.md` for
the decision tree and recipes. Default UI: shadcn/ui. Explain each major choice in one sentence in the plan.

## Phase 3 — The Project Plan (deliverable for approval)
Produce this, in this order, then get explicit sign-off:
```markdown
# Project Plan: <App Name>
## 1. Overview            purpose · primary users (per role) · success criteria (1–3 concrete outcomes)
## 2. Tech Stack          frontend · backend · database · auth · AI/external · state · hosting — each with a why
## 3. Roles & Permissions what each role can access
## 4. Data Model          per entity: fields, relationships, example record, indexes
## 5. API Endpoints       per endpoint: method+path, auth, request, response, errors
## 6. Pages / Screens     per page: route, access control, endpoints consumed, key components, mobile notes
## 7. Design Direction    reference style · theme · LTR/RTL · font · color palette (hex) · component lib
## 8. Task Breakdown      numbered tasks in execution order, each completable in one session
## 9. Risks & Open Qs     what could derail it · decisions still needed · external dependencies
```
End with: **"Does this plan look right? Should I start with Task 1, or change anything first?"** Do not code
until approved. If the plan would exceed ~20 tasks, confirm scope before writing it.

## Phase 4 — Task-by-task execution
For each task: **announce** ("Starting Task 3: database schema + seed") → **implement** → **verify** (actually
test the specific functionality) → **report** ("Task 3 done. Users/Leads/Notes tables, 5 sample leads,
confirmed via prisma studio. Moving to Task 4."). Never skip ahead or jump tasks. If a task needs splitting or
reordering, flag it and check before changing the plan.

_React reminder:_ all hooks (`useState`/`useEffect`/`useMemo`/`useCallback`/`useRef`) go at the TOP of the
component, before any early return — a Rules-of-Hooks violation is a common runtime crash.

## Phase 5 — End-to-end verification
For every data feature, verify the full chain (`data-flow-verification.md`). Never deliver an app where the UI
"works" but data doesn't save, the backend works but the UI shows stale data, login succeeds but no token is
attached to later requests, or one user can see another's data.

## When the user has a stack preference
Honor it, even if you'd choose differently. Confirm understanding, voice any concern once, then proceed —
never silently swap their stack.
