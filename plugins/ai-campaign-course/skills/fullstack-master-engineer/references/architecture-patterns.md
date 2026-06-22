# Architecture Patterns

Production patterns from real codebases. Load when writing code in any mode.

## Project structures
**React + Vite + Express (separate client/server):** `client/src/{components/{ui,layout,shared},pages/{auth,
app},api (one module per resource + client.ts),contexts,hooks,types,lib,styles}` and `server/src/{routes,
controllers,services,middleware,lib}` + `prisma/{schema,seed,migrations}`. Best for portals/internal tools
with clear separation.

**Next.js full-stack (single codebase):** `src/app/{(auth),(app)/{layout,dashboard,...},(marketing),api}`,
`src/{components/{ui,layout,shared},lib/{db,auth,validations},server/{actions,services},types}` + `prisma/`.

**FastAPI + Next.js (AI):** `backend/app/{main,api/{deps,routes},core,db/{models},schemas,repositories,
services,agents/{base,chat_agent,tools},rag,worker}` + `alembic/`, and a Next.js `frontend/`, with
`docker-compose.yml` (postgres + redis + qdrant).

## Core patterns

### Repository + Service (critical)
Never put DB calls in route handlers. Route → controller → service → repository.
```
router.post('/tasks', authMiddleware, validateBody(schema), tasksController.create)
// controller: calls tasksService.createTask(req.user.id, req.body) → 201 json
// service: business logic, calls repository, triggers side effects (notifications)
// repository: the only place that touches the DB
```
Benefits: testable, swappable DB, one place for cross-cutting concerns.

### API client module on the frontend (never raw fetch in components)
A base axios/fetch instance with an interceptor that attaches the auth token and redirects on 401, plus one
module per resource (`tasksApi.list/get/create/update/delete`). Components call the module, not `fetch`.

### TanStack Query owns server state
`useQuery({ queryKey, queryFn })` for reads; `useMutation` with `onSuccess: invalidateQueries` for writes.
Don't mirror server data into useState. Use it for caching, refetching, and optimistic updates.

## React best practices
- Hooks at the top, before any early return (Rules of Hooks).
- Components small and focused; extract shared UI; co-locate a component with its hook/types.
- Derive state instead of duplicating it; avoid redundant effects (compute during render where possible).
- Stable keys for lists; memoize only proven-expensive work.
- Loading / empty / error states for every async view.

## Backend best practices
- Validate every input with a schema at the edge; return a consistent error envelope with specific codes.
- Centralized error handler; never leak stack traces to clients.
- Scope every query by the current user; parameterize all queries.
- Keep handlers thin; logic in services; side effects explicit.
- Log security-relevant events (no secrets/PII).

## Database patterns (Prisma / Supabase)
- Model relationships explicitly; add indexes on FK/`WHERE`/`ORDER BY` columns.
- Use migrations (never edit the DB by hand); make them reversible; seed sample data for dev.
- Use transactions for multi-step writes that must be atomic (orders, inventory).
- On Supabase, enable Row-Level Security and write access policies before launch; use a least-privilege role.
- Don't `SELECT *` to the client; select explicit columns; paginate lists.
