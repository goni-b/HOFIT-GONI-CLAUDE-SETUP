## Tech Stack Decision Guide

The agent owns the tech stack decision. The user should not have to specify a stack unless they have a strong preference.

### Decision Tree

#### Step 1: What is the primary nature of the app?

**A) Internal tool / B2B portal / CRM with user roles**
→ Use **Stack: React + Vite + Express (Client Portal Pattern)**. Example: client portal, internal admin app, agency portal.

**B) Public SaaS with auth + payments + marketing site**
→ Use **Stack: Next.js 15 Full Stack**. Example: Notion-like, modern SaaS startups.

**C) AI agent app, chatbot, RAG system**
→ Use **Stack: FastAPI + Next.js (AI Pattern)**. Example: ChatGPT-like apps, document Q&A, AI customer support.

**D) Quick prototype / demo / MVP**
→ Use **Stack: Vite + Single-file or HTML + CDN**.

**E) Real-time collaborative app**
→ Use **Stack: Next.js + Socket.io OR Supabase**. Example: chat, kanban with live updates.

**F) Heavy data viz / analytics dashboard**
→ Use **Stack: React + Recharts + Express**.

### Quick Reference Table

| Project Type | Recommended Stack | Why |
|---|---|---|
| Client portal / CRM / internal SaaS | React 18 + Vite + TS + TailwindCSS + shadcn/ui + React Router + TanStack Query | Battle-tested for B2B portals. Fast dev. |
| SaaS with auth + payments + dashboards | Next.js 15 (App Router) + Prisma + PostgreSQL + NextAuth + Stripe + shadcn/ui | Production-ready full-stack, single codebase. |
| AI agent app / RAG chatbot | FastAPI + Next.js 15 + PydanticAI/LangChain + PostgreSQL + WebSocket streaming + Qdrant/pgvector | Async Python for AI work. |
| SEO-critical marketing + app | Next.js 15 + Prisma + PostgreSQL | SSR/SSG built-in. |
| Real-time (chat, live boards) | Next.js + Socket.io OR Supabase Realtime | Built-in websocket support. |
| Simple CRUD / internal tool | React + Vite + Express + SQLite (Prisma) | Minimal overhead. |
| Quick prototype | Single-file HTML + CDN OR Vite + lowdb | Zero setup. |
| Mobile-first PWA | Next.js + Tailwind + service worker + IndexedDB | Responsive by design. |
| Heavy data viz dashboard | React + Recharts/Chart.js + Express + PostgreSQL | Strong viz ecosystem. |

### Stack 1: React + Vite + Express (Client Portal Pattern)

**Use when:** Internal tools, B2B portals, CRMs, multi-role apps, internal SaaS.

**Frontend dependencies:**
```json
{
  "react": "^18.x", "react-dom": "^18.x", "react-router-dom": "^6.x",
  "@tanstack/react-query": "^5.x", "axios": "^1.x",
  "typescript": "^5.x", "vite": "^5.x", "tailwindcss": "^3.x",
  "lucide-react": "latest", "sonner": "^1.x",
  "react-hook-form": "^7.x", "@hookform/resolvers": "^3.x", "zod": "^3.x"
}
```
Plus shadcn/ui (copy-paste, no npm package).

**Backend dependencies:**
```json
{
  "express": "^4.x", "@prisma/client": "^5.x", "prisma": "^5.x",
  "jsonwebtoken": "^9.x", "bcrypt": "^5.x", "cors": "^2.x",
  "zod": "^3.x", "tsx": "^4.x", "typescript": "^5.x"
}
```

**Database:** SQLite for dev, PostgreSQL for prod (both via Prisma).
**Auth:** JWT in localStorage (simpler) or httpOnly cookie (more secure), bcrypt for passwords.
**Hosting:** Frontend on Vercel/Netlify, Backend on Railway/Fly.io, DB on Neon/Supabase/Railway.

### Stack 2: Next.js 15 Full Stack

**Use when:** Public SaaS, marketing + app combined, SEO-critical apps.

**Dependencies:**
```json
{
  "next": "^15.x", "react": "^18.x", "typescript": "^5.x",
  "tailwindcss": "^3.x", "@prisma/client": "^5.x",
  "next-auth": "^5.x (beta)", "lucide-react": "latest", "sonner": "^1.x",
  "react-hook-form": "^7.x", "zod": "^3.x"
}
```
Plus shadcn/ui. Add Stripe for payments.

**Server Actions Pattern** (preferred over API routes for form submissions):
```tsx
// app/(app)/tasks/actions.ts
'use server'
import { db } from '@/lib/db'
import { z } from 'zod'
import { revalidatePath } from 'next/cache'

const schema = z.object({ title: z.string().min(1) })

export async function createTask(formData: FormData) {
  const session = await auth()
  if (!session) throw new Error('Unauthorized')
  const parsed = schema.parse(Object.fromEntries(formData))
  await db.task.create({ data: { ...parsed, userId: session.user.id } })
  revalidatePath('/app/tasks')
}
```

### Stack 3: FastAPI + Next.js (AI Pattern)

**Use when:** AI agent apps, RAG chatbots, heavy async Python work.

**Backend dependencies (pyproject.toml):**
```toml
fastapi = "^0.110"
uvicorn = "^0.27"
sqlalchemy = "^2.0"
alembic = "^1.13"
asyncpg = "^0.29"
pydantic = "^2.0"
pydantic-ai = "^0.0.x"      # Recommended AI framework
qdrant-client = "^1.x"      # For RAG
openai = "^1.x"
```

**Key Architectural Decisions:**
1. Async-first — `async def` everywhere, `asyncpg`, `httpx`
2. Repository + Service pattern — Routes never call DB directly
3. WebSocket streaming for AI responses
4. PydanticAI for type-safe agents
5. Background tasks via Celery/Taskiq
6. Observability via Logfire (free tier)

**Vector Store Choice:**
| Store | When to use |
|---|---|
| pgvector | Already using Postgres, < 1M vectors |
| Qdrant | Higher scale, advanced filtering |
| Chroma | Local dev, simple use cases |
| Milvus | Massive scale (10M+ vectors) |

### Component Library: Always Default to shadcn/ui

**Use shadcn/ui for almost every React/Next.js project.**

Why: Copy-paste (no npm dependency), built on Radix UI (accessible), Tailwind-based (customizable),
modern aesthetic (looks like Linear/Vercel/Stripe), excellent dark mode, industry standard.

Install:
```bash
npx shadcn@latest init
npx shadcn@latest add button card dialog form input toast table
```

**Don't use Bootstrap.** Outdated for modern React apps.

### State Management Choice

- **Local component state:** `useState` / `useReducer`
- **Cross-component (light):** Context API — auth, theme, current user
- **Cross-component (heavy):** Zustand — lightweight, no boilerplate
- **Server state:** TanStack Query — caching, refetching, optimistic updates

**Never store server data in useState/Zustand** — let TanStack Query own it.

### Form Library: react-hook-form + Zod

```bash
npm install react-hook-form @hookform/resolvers zod
```

Why: Best performance, Zod schemas reused on backend, excellent shadcn/ui integration, TypeScript inference.

### Common Project → Stack Mapping

| User says... | Stack |
|---|---|
| "Build a CRM for my agency" | React + Vite + Express |
| "I need an internal admin dashboard" | React + Vite + Express |
| "Create a SaaS like Notion for X" | Next.js + Prisma + NextAuth + Stripe |
| "Build an AI chatbot for our docs" | FastAPI + Next.js + PydanticAI + Qdrant |
| "Build a portal for my clients in Hebrew" | React + Vite + Express + RTL config |
| "Analytics dashboard with charts" | React + Vite + Express + Recharts |
| "E-commerce store" | Next.js + Stripe |
| "Booking system" | Next.js + Prisma + NextAuth + Stripe |
| "RAG over PDFs" | FastAPI + Next.js + LlamaParse + pgvector |
| "I need a quick demo for tomorrow" | Single HTML + CDN, or Vite + lowdb |

### When the User Has a Stack Preference

**Always honor it.** Even if you'd choose differently. Confirm understanding, mention concerns once if any, then proceed without complaint. Never silently swap their stack.

---

