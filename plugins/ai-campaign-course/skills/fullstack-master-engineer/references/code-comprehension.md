# Code Comprehension — Understand, Analyze & Document Existing Code

Use in COMPREHEND mode: inherited projects, legacy systems, undocumented code, or "explain how this works /
what does this do / map this codebase." The goal is an accurate mental model grounded in evidence, plus a
document the user can keep.

## Two hats
- **Architect hat** — structure, boundaries, data flow, dependencies, the "why."
- **QA hat** — observable behavior, inputs/outputs, edge cases, error handling.

## Workflow
1. **Scope** — full system or one feature/module? Confirm the boundary before exploring.
2. **Explore** — map the structure with Glob/Grep/Read. Don't write anything until coverage is real.
   _Checkpoint:_ have you read the entry points, config, and core modules? If not, keep exploring.
3. **Trace** — follow a real request/data path from entry to persistence and back.
4. **Document** — write observed behavior in EARS format with file:line evidence.
5. **Flag** — list uncertainties and questions in a dedicated section. Never invent.

## Iron rule
Ground every statement in actual code. Separate **observed fact** ("`auth.ts:42` returns 401 when no token")
from **inference** ("this probably means routes are protected globally"). Mark inferences as such.

## Exploration recipes
```bash
# Stack & entry points
cat package.json pyproject.toml go.mod 2>/dev/null      # deps + scripts reveal the stack
ls -la                                                   # top-level shape
# Entry points / routes
grep -rEn "@app\.route|@router\.|router\.(get|post)|app\.(get|post)|createServer|FastAPI\(" --include=*.{py,ts,js} .
# Config & env usage (config bugs masquerade as code bugs)
grep -rEn "process\.env|import\.meta\.env|os\.environ|settings\." --include=*.{py,ts,js} .
# Tech-debt markers (where the bodies are buried)
grep -rEn "TODO|FIXME|HACK|XXX|@deprecated" --include=*.{py,ts,js} .
# Data layer
grep -rEln "prisma|sqlalchemy|mongoose|knex|CREATE TABLE|schema" .
# Who calls a given module (blast radius)
grep -rn "from .*<module>|require(.*<module>" .
```

## EARS format (Easy Approach to Requirements Syntax)
Capture what the system *does* as testable statements:

| Type | Pattern | Example |
|---|---|---|
| Ubiquitous | The `<system>` shall `<action>`. | The API shall return JSON. |
| Event-driven | When `<trigger>`, the `<system>` shall `<action>`. | When a token is missing, the system shall return 401. |
| State-driven | While `<state>`, the `<system>` shall `<action>`. | While in maintenance mode, the system shall reject writes. |
| Optional | Where `<feature>` exists, the `<system>` shall `<action>`. | Where caching is on, the system shall store responses 60s. |

## Audience-tuned output
- **Onboarding doc** (new engineer): stack, setup commands (validated on a clean checkout), repo map, "how to
  run a common task," guardrails, troubleshooting.
- **Reverse spec** (planning a change): tech stack & architecture, module map, observed requirements (EARS),
  non-functional observations, inferred acceptance criteria, uncertainties, recommendations.
- **Tech-lead briefing**: architecture overview, key risks, hotspots (`git log --oneline -20 -- <path>` to
  find churn), operational concerns.

Save to `docs/<project>_overview.md` or `specs/<project>_reverse_spec.md`.

## Common pitfalls
- Writing docs before validating setup commands actually work.
- Describing intended behavior instead of observed behavior.
- Skipping error-handling and security paths.
- Letting the doc drift — update it in the same PR as behavior changes.
