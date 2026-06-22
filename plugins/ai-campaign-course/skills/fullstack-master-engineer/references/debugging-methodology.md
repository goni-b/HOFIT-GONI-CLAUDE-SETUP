# Debugging Methodology — Systematic, Hypothesis-Driven

Use in REPAIR mode for a single bug, error, crash, or unexpected behavior. For a whole broken feature, use
`focused-repair.md` instead.

## The one rule that matters
**Form one hypothesis, test it, then move on.** Guessing and changing many things at once hides which change
mattered and creates new bugs. "Obvious" root causes are wrong a large fraction of the time — confirm with
evidence before fixing.

## Workflow
1. **Reproduce** — get consistent, minimal reproduction steps. If you can't reproduce it, you can't fix it.
2. **Isolate** — shrink to the smallest failing case. Remove variables until only the bug remains.
3. **Hypothesize & test** — state "I think X because Y," then prove or disprove it with a log, a breakpoint,
   or a test. One at a time.
4. **Fix** — make the smallest change that addresses the confirmed root cause.
5. **Prevent** — add a regression test that fails before the fix and passes after. Remove all debug code.

## Gather complete evidence first
- The full error message **and** stack trace (not a paraphrase).
- The exact input that triggers it.
- Relevant log lines around the failure.
- Recent changes: `git log --oneline -10 -- <file>` and `git diff` — many "sudden" bugs are a recent commit.

## Hunt a regression with git bisect
```bash
git bisect start
git bisect bad                 # current commit is broken
git bisect good v1.2.0         # last known-good tag/commit
# git checks out the midpoint — test it, then:
git bisect good                # or: git bisect bad
# repeat until git names the first bad commit, then:
git bisect reset
```

## Language debuggers (prefer a debugger over scattered prints)
```bash
# Python
python -m pdb script.py        # b 42 | n | s | p var | bt | c
# Node.js
node --inspect-brk script.js   # open chrome://inspect → Sources → breakpoints/watch/step
# Go
dlv debug ./cmd/server         # (dlv) break main.go:55 | continue | print myVar
```
For web UIs: browser DevTools — Network tab (is the request sent? right URL/headers/body? what's the
response/status?), Console (errors), and breakpoints in Sources.

## Debug-by-layer when data "doesn't flow"
Walk the chain and find the first broken link: UI event fired? → request sent (Network)? → reached the server
(server log)? → passed validation? → hit the DB (query log)? → DB returned rows? → response shaped right? →
UI updated/cached correctly? Add one log at each boundary, identify the failing layer, then go deep there.
(Full chain in `data-flow-verification.md`.)

## Common patterns to check fast
- `undefined`/`null` where an object was expected (optional chaining, missing await, race).
- Off-by-one, wrong argument order, wrong comparison (`==` vs `===`, truthiness).
- Missing/`await`ed async — promise not awaited, error swallowed in an empty catch.
- Env var unset or different between dev and prod.
- Stale cache / stale state (TanStack Query not invalidated, memoized value not recomputed).
- Timezone/encoding/locale issues (especially Hebrew/RTL and dates).

## Output template
1. **Root cause** — what specifically caused it.
2. **Evidence** — the stack trace, log, or failing test that proves it.
3. **Fix** — the change that resolves it.
4. **Prevention** — the regression test or safeguard added.

## Never
- Guess without testing, or change multiple things at once.
- Skip reproduction, or assume you know the cause.
- Debug in production without safeguards.
- Leave `console.log`/`debugger`/`print` statements behind.
