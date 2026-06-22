# DevOps & Deployment

Use in SHIP mode to deploy and to set up the pipeline. Goal: a repeatable, reversible path from commit to
production.

## Environment configuration
- All config via env vars; provide `.env.example` (names only) for every service; `.env` gitignored.
- Separate environments (dev/staging/prod) with separate secrets and databases. Never point dev at prod data.
- Validate required env vars at startup and fail fast with a clear message if one is missing.

## Deploy targets (match the owner's stack)
- **Vercel** — frontend / Next.js full-stack: connect the repo, set env vars in the dashboard, preview
  deploys per PR, promote to prod. Default for the owner's React/Next projects.
- **Railway / Fly.io / Render** — Node/Express/FastAPI backends and workers; managed Postgres/Redis.
- **Supabase** — managed Postgres + auth + storage + edge functions + cron; apply migrations via the CLI;
  enable RLS before going live.
- **Docker / VPS** — when you need full control: a clean multi-stage Dockerfile, `docker-compose` for
  app + db + redis, a reverse proxy (Caddy/Nginx) with TLS.

## Database in production
- Apply migrations as a deploy step (not by hand); migrations must be reversible and tested.
- Take a backup before a risky migration; know the restore procedure.
- Enable RLS / access rules; use a least-privilege app DB user.

## CI/CD (GitHub Actions baseline)
A typical pipeline on push/PR:
1. Install deps (cached).
2. Lint + type-check.
3. Run unit + integration tests (against a test DB service).
4. Build.
5. On main: deploy (or let Vercel/Railway auto-deploy on merge).
Block merge on a red pipeline. Keep secrets in the CI secret store, never in the workflow file.

## Rollback & safety
- Every deploy needs a one-step rollback (redeploy the previous build / revert the release).
- Use preview/staging to validate before promoting to prod.
- Health check endpoint + uptime monitor; error monitoring (Sentry) wired before launch.
- For risky changes, ship behind a feature flag and enable gradually.

## Containerization tips
- Multi-stage build (build stage → slim runtime); don't ship dev deps or secrets in the image.
- Pin base image versions; run as non-root; `.dockerignore` node_modules and `.env`.

## Never
- Hardcode secrets in the image, the workflow file, or the repo.
- Run un-reviewed, irreversible migrations directly on prod.
- Deploy without a rollback path and a health check.
- Share one database/secret set across environments.
