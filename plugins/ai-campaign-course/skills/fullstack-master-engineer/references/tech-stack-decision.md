# Tech Stack Decision Guide

You own the stack decision; the user shouldn't have to specify one unless they have a preference. Default to
the owner's stack (`my-stack.md`) and deviate only with a reason.

## Decision tree — what is the app's primary nature?
- **Internal tool / B2B portal / CRM with roles** → React + Vite + Express (client-portal pattern).
- **Public SaaS with auth + payments + marketing site** → Next.js full-stack.
- **AI agent / chatbot / RAG** → FastAPI + Next.js.
- **Quick prototype / demo** → Vite single-page, or single-file HTML + CDN.
- **Real-time collaborative** → Next.js + Socket.io, or Supabase Realtime.
- **Heavy data viz / analytics** → React + Recharts + Express/Supabase.

## Quick reference
| Project type | Stack |
|---|---|
| Client portal / CRM / internal SaaS | React 18 + Vite + TS + Tailwind + shadcn/ui + React Router + TanStack Query |
| SaaS with auth + payments + dashboards | Next.js 15 (App Router) + Prisma/Supabase + NextAuth + Stripe + shadcn/ui |
| AI agent / RAG chatbot | FastAPI + Next.js + PydanticAI/LangChain + Postgres/pgvector or Qdrant + WS streaming |
| SEO-critical marketing + app | Next.js 15 + Prisma/Supabase |
| Real-time (chat, live boards) | Next.js + Socket.io OR Supabase Realtime |
| Simple CRUD / internal tool | React + Vite + Express + SQLite/Supabase (Prisma) |
| Quick prototype | Single-file HTML + CDN, or Vite |
| Heavy data viz dashboard | React + Recharts/Chart.js + Express/Supabase |

## Stack recipes
**Client portal (React + Vite + Express):** frontend react/react-dom/react-router-dom, @tanstack/react-query,
axios, typescript, vite, tailwindcss, lucide-react, sonner, react-hook-form, @hookform/resolvers, zod + shadcn/ui.
Backend express, @prisma/client/prisma, jsonwebtoken, bcrypt, cors, zod, tsx. SQLite dev / Postgres (or
Supabase) prod. Auth: JWT (httpOnly cookie preferred) + bcrypt.

**Next.js full-stack:** next, react, typescript, tailwindcss, prisma (or Supabase), next-auth, lucide-react,
sonner, react-hook-form, zod + shadcn/ui + Stripe. Prefer **server actions** for form submissions over API
routes; always check the session and validate with Zod inside the action.

**FastAPI + Next.js (AI):** fastapi, uvicorn, sqlalchemy, alembic, asyncpg, pydantic, pydantic-ai, openai or
the Anthropic SDK, qdrant-client/pgvector. Async-first; Repository+Service layering; WebSocket streaming for
AI responses; background tasks via a queue; observability from day one. Vector store: pgvector (<1M vectors,
already on Postgres), Qdrant (scale/filtering), Chroma (local dev).

## Component, state, forms
- **UI:** shadcn/ui by default (copy-paste, Radix-accessible, Tailwind-customizable, modern). No Bootstrap.
- **State:** local → useState/useReducer; light cross-component → Context; heavier → Zustand;
  **server state → TanStack Query** (never store server data in useState/Zustand).
- **Forms:** react-hook-form + Zod; reuse the schema on the backend.

## Common phrasing → stack
"CRM for my agency" / "internal admin dashboard" → React+Vite+Express. "SaaS like Notion" → Next.js + Prisma
+ NextAuth + Stripe. "AI chatbot for our docs" → FastAPI + Next.js + RAG. "Portal for clients in Hebrew" →
React+Vite+Express + RTL. "E-commerce store" → Next.js + Stripe/Payplus. "Quick demo for tomorrow" →
single-file HTML + CDN.
