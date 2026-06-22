# My Stack & Conventions (Goni Bahat)

Consult early in BUILD / INTEGRATE / COMMERCE so choices match how the owner actually works. These are
defaults, not handcuffs — deviate when a project genuinely argues for it, and say why.

## Default tech stack
- **Frontend:** React + TypeScript, Vite (or Next.js when SSR/SEO or a marketing+app combo is needed).
  React 19 / TanStack Start is in active use.
- **UI:** TailwindCSS + **shadcn/ui** (Radix under the hood). Lucide for icons. This is the default look —
  clean, modern, accessible. No Bootstrap.
- **Backend:** Node/Express or Next.js route handlers/server actions for TS projects; FastAPI (Python) for
  AI-heavy or async-heavy services.
- **Database & platform:** **Supabase** (Postgres + auth + storage + edge functions + cron) is the default
  data platform. Enable RLS before launch. Prisma when using a separate Node backend.
- **State/data:** TanStack Query for server state; Context/Zustand for light client state.
- **Forms:** react-hook-form + Zod (reuse the Zod schema on the server).
- **AI:** Anthropic API is the default LLM provider (Claude). See `ai-agents-rag.md`.
- **Hosting:** **Vercel** for frontends/Next.js; Railway/Fly for separate backends; Supabase for data.
- **Version control:** GitHub under `goni-b` (e.g. `github.com/goni-b/...`).

## Integration targets the owner actually builds against
- **Meta Graph API** (Marketing/Ads) — campaign tooling (e.g. Campaigner AI). Pin the API version explicitly;
  handle OAuth, rate limits, and Ads-specific objects. (Use `api-integration.md` patterns.)
- **Payplus** — default payment processor for Israeli commerce; account for the owner's clearing/split
  structures and VAT. (See `ecommerce.md`.)
- **GoHighLevel (JONSON CRM)**, **monday.com**, **Make.com**, **VoiceCenter** — common business-systems the
  owner integrates with via API/webhooks and automations. When connecting these, prefer official APIs and
  verified webhooks, and design idempotent flows (`automation-workflows.md`).

## Market & language defaults
- **Israeli market, Hebrew-first, RTL by default** for any user-facing UI. Apply `hebrew-rtl.md` (RTL layout,
  Heebo/Assistant fonts, logical Tailwind spacing, `dir="ltr"` on phone/email/URL inputs, custom Calendar
  instead of native date input). Bilingual (HE/EN) when the audience needs it.
- VAT (מע"מ) handled correctly anywhere money or invoices appear.

## Working style
- **Direct and results-oriented.** Concise, actionable output. Propose before executing — especially for any
  write to a CRM, database, or external platform (preview the change, get the go-ahead).
- **Iterative.** Build in tasks, show progress, verify, then move on.
- Respond in **Hebrew** when the owner writes Hebrew; keep technical terms in English.
