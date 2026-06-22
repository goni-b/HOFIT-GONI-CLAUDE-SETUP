# Testing Strategy

Use in SHIP mode (and during BUILD/REPAIR). Tests exist to let you change code with confidence and to prove
behavior — not to chase a coverage number.

## The pyramid
- **Unit** (most) — pure logic, fast, no I/O. Test functions, reducers, validators, business rules.
- **Integration** (some) — API endpoints against a real/test DB; service + repository together; auth scoping.
- **E2E** (few, high-value) — real user journeys through the UI with Playwright (login → do the thing →
  see the result persisted).

## What a good test does
- Asserts **behavior**, not implementation. Renaming an internal helper shouldn't break tests.
- Covers the unhappy path: invalid input, unauthorized access, empty/edge cases, failure of a dependency.
- Is deterministic — no reliance on real time, network, or order. Mock external services; freeze time;
  isolate state between tests.
- Has a descriptive name that reads as a spec: `returns 401 when token is missing`.

## TDD (when behavior is well-specified)
Red → Green → Refactor: write a failing test that states the desired behavior, write the minimum code to pass
it, then refactor with the test as a safety net. Especially valuable for bug fixes — the regression test
should fail before your fix and pass after.

## Tooling by stack
- **JS/TS** — Vitest/Jest for unit+integration; Playwright for E2E; Testing Library for components
  (test what the user sees, not internals).
- **Python** — pytest; httpx/TestClient for FastAPI; factory fixtures for data.
- Run a test DB (SQLite or a disposable Postgres) and reset state per test/suite.

## Playwright E2E essentials
- Use role/text locators (`getByRole`, `getByText`) over brittle CSS selectors.
- Auto-waiting: assert on elements/state, avoid fixed `sleep`.
- Cover the critical journeys only — login, the core action, payment if any — not every screen.
- Run headless in CI; capture trace/video on failure for debugging.

## Coverage, honestly
Aim for meaningful coverage of logic and critical paths, not 100%. A well-tested checkout flow beats 100%
coverage of getters. Track that the paths that would lose data or money are tested.

## In BUILD and REPAIR
- BUILD: add tests as you build each feature, not all at the end.
- REPAIR: every fix ships with a regression test (`debugging-methodology.md` / `focused-repair.md` require it).

## Never
- Assert implementation details that make refactoring painful.
- Write tests that depend on real network/time/order.
- Claim something is tested without running the test and seeing it pass.
