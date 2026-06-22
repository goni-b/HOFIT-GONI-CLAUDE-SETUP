# Performance Optimization

Use in IMPROVE mode when something is slow, or proactively before scale. The cardinal sin is optimizing what
isn't the bottleneck.

## The rule
**Measure first, optimize the real bottleneck, measure the delta.** Profilers beat intuition. State the
metric you're improving (p95 latency, query time, bundle KB, LCP) and the before/after numbers.

## Backend & database (usually the biggest wins)
- **N+1 queries** — the #1 culprit. One query per row in a loop. Fix with eager loading / joins:
  `prefetch_related`/`select_related` (Django), `include`/`with` (Prisma), `JOIN`. Detect by logging SQL and
  counting queries per request.
- **Missing indexes** — add indexes on columns used in `WHERE`, `JOIN`, `ORDER BY`. Confirm with
  `EXPLAIN ANALYZE` (Postgres) that the planner uses the index and isn't doing a seq scan on a big table.
- **Unbounded queries** — always paginate lists; never `SELECT *` millions of rows to count or display.
- **Select only needed columns**; avoid loading large blobs you don't use.
- **Caching** — cache expensive, stable reads (Redis, HTTP cache headers, or in-memory for a single process).
  Set a TTL and an invalidation strategy; a wrong cache is worse than none.
- **Move work off the request path** — heavy jobs (emails, exports, AI calls) go to a background queue.
- **Connection pooling** — reuse DB connections; don't open one per request.

## Frontend & web vitals
- **Bundle size** — import only what you use (`import { x } from 'lib'`, not the whole lib); code-split routes
  (`React.lazy`/dynamic import); analyze with the bundler's analyzer. Drop heavy deps with light alternatives.
- **Images** — correct sizes, modern formats (WebP/AVIF), lazy-load below the fold, use `next/image` or
  equivalent. Images are the most common LCP killer.
- **Render cost** — memoize expensive computations (`useMemo`), stabilize callbacks (`useCallback`), avoid
  re-rendering large lists (virtualize), key lists correctly.
- **Server data** — let TanStack Query cache and dedupe; don't refetch on every render.
- **Core Web Vitals** — LCP (largest paint, target <2.5s), CLS (layout shift, <0.1), INP (interaction
  latency). Measure with Lighthouse / web-vitals.

## Method
1. Reproduce the slow path and measure it (timing, profiler, EXPLAIN, Lighthouse).
2. Find the dominant cost — don't guess. Often a single query or a single oversized asset.
3. Fix that one thing.
4. Re-measure. If the win is real, keep it; if not, revert and look again.
5. Stop when it's fast enough — don't micro-optimize past the point of user-perceptible difference.

## Never
- Optimize without a measurement showing it's the bottleneck.
- Add a cache without an invalidation plan.
- Ship a fix claiming it's faster without before/after numbers.
