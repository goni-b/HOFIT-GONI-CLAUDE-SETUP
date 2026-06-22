## Architecture Patterns

Production-grade architecture patterns from real codebases.

### Project Structure Pattern 1: React + Vite + Express (Separate client/server)

Best for: client portals, internal tools, B2B SaaS where you want clear separation.

```
project-name/
├── client/                              # Frontend (Vite + React + TS)
│   ├── src/
│   │   ├── components/
│   │   │   ├── ui/                      # shadcn/ui components + customs
│   │   │   ├── layout/
│   │   │   │   ├── AppLayout.tsx        # Sidebar + Header + <Outlet />
│   │   │   │   ├── Sidebar.tsx
│   │   │   │   ├── Header.tsx
│   │   │   │   └── PageHeader.tsx
│   │   │   └── shared/                  # Reusable feature components
│   │   ├── pages/
│   │   │   ├── auth/ (Login, Register, ForgotPassword)
│   │   │   ├── app/ (Dashboard, Tasks, Settings)
│   │   │   └── NotFound.tsx
│   │   ├── api/                         # API client modules (one per resource)
│   │   │   ├── client.ts                # Base axios/fetch config
│   │   │   ├── auth.ts                  # login(), register(), me()
│   │   │   └── tasks.ts
│   │   ├── contexts/
│   │   │   ├── AuthContext.tsx
│   │   │   └── NotificationsContext.tsx
│   │   ├── hooks/ (useAuth, useTasks via TanStack Query)
│   │   ├── types/
│   │   ├── lib/ (utils.ts with cn() helper, constants.ts)
│   │   ├── styles/globals.css           # Tailwind + CSS variables
│   │   ├── App.tsx                      # Routes + Providers
│   │   └── main.tsx
│   ├── .env.example                     # VITE_API_URL=...
│   ├── tailwind.config.js
│   ├── vite.config.ts                   # Path aliases (@/)
│   └── package.json
├── server/                              # Backend (Express + Prisma)
│   ├── src/
│   │   ├── routes/                      # One file per resource
│   │   ├── controllers/                 # Business logic
│   │   ├── services/                    # Reusable logic
│   │   ├── middleware/                  # auth, role, validate, error handler
│   │   ├── lib/                         # prisma client, jwt helpers
│   │   └── server.ts
│   ├── prisma/
│   │   ├── schema.prisma
│   │   ├── seed.ts
│   │   └── migrations/
│   ├── .env.example
│   └── package.json
├── shared/                              # Types/constants (optional)
├── docker-compose.yml                   # Postgres + Redis (if needed)
└── README.md
```

### Project Structure Pattern 2: Next.js Full Stack (Single codebase)

```
project-name/
├── src/
│   ├── app/                             # App Router
│   │   ├── (auth)/ (login, register)
│   │   ├── (app)/                       # Protected route group
│   │   │   ├── layout.tsx               # App shell with sidebar
│   │   │   ├── dashboard/
│   │   │   ├── tasks/
│   │   │   └── settings/
│   │   ├── (marketing)/                 # Public pages
│   │   ├── api/                         # API routes
│   │   ├── layout.tsx
│   │   └── globals.css
│   ├── components/ (ui/, layout/, shared/)
│   ├── lib/
│   │   ├── db.ts                        # Prisma client
│   │   ├── auth.ts                      # Auth config
│   │   └── validations/                 # Zod schemas
│   ├── server/
│   │   ├── actions/                     # Server actions
│   │   └── services/                    # Business logic
│   └── types/
├── prisma/
├── public/
└── package.json
```

### Project Structure Pattern 3: FastAPI + Next.js (AI/Agent Apps)

```
project-name/
├── backend/                             # FastAPI
│   ├── app/
│   │   ├── main.py                      # FastAPI app with lifespan
│   │   ├── api/
│   │   │   ├── deps.py                  # get_current_user, etc.
│   │   │   ├── routes/
│   │   │   └── exception_handlers.py
│   │   ├── core/ (config, security, middleware)
│   │   ├── db/ (base, session, models/)
│   │   ├── schemas/                     # Pydantic models
│   │   ├── repositories/                # Data access
│   │   ├── services/                    # Business logic
│   │   ├── agents/                      # AI agents
│   │   │   ├── base.py
│   │   │   ├── chat_agent.py            # PydanticAI agent
│   │   │   └── tools/
│   │   ├── rag/                         # RAG module
│   │   └── worker/                      # Background tasks
│   ├── alembic/                         # DB migrations
│   └── pyproject.toml
├── frontend/                            # Next.js 15
├── docker-compose.yml                   # postgres + redis + qdrant
└── README.md
```

### Core Architectural Patterns

#### 1. Repository + Service Pattern (Critical)

**Never put DB calls directly in route handlers.** Always go through a service layer.

```typescript
// ❌ BAD — route does everything
router.post('/tasks', async (req, res) => {
  const task = await prisma.task.create({ data: req.body })
  res.json(task)
})

// ✅ GOOD — separated layers
// routes/tasks.routes.ts
router.post('/tasks', authMiddleware, validateBody(createTaskSchema), tasksController.create)

// controllers/tasks.controller.ts
export const tasksController = {
  async create(req: Request, res: Response) {
    const task = await tasksService.createTask(req.user.id, req.body)
    res.status(201).json(task)
  }
}

// services/tasks.service.ts
export const tasksService = {
  async createTask(userId: string, data: CreateTaskDto) {
    const task = await tasksRepository.create({ ...data, userId })
    if (task.assigneeId) await notificationService.notifyAssignee(task)
    return task
  }
}
```

**Benefits:** Easy to test, easy to swap DB, easy to add cross-cutting concerns.

#### 2. API Client Module on Frontend

Never `fetch()` directly in components.

```typescript
// client/src/api/client.ts — base axios instance
import axios from 'axios'

export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
})

apiClient.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

apiClient.interceptors.response.use(
  res => res,
  err => {
    if (err.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(err)
  }
)

// client/src/api/tasks.ts — one file per resource
export const tasksApi = {
  list: () => apiClient.get<Task[]>('/api/tasks').then(r => r.data),
  get: (id: string) => apiClient.get<Task>(`/api/tasks/${id}`).then(r => r.data),
  create: (data: CreateTaskDto) => apiClient.post<Task>('/api/tasks', data).then(r => r.data),
  update: (id: string, data: Partial<Task>) => apiClient.patch<Task>(`/api/tasks/${id}`, data).then(r => r.data),
  delete: (id: string) => apiClient.delete(`/api/tasks/${id}`),
}
```

#### 3. TanStack Query for Server State

```typescript
// hooks/useTasks.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { tasksApi } from '@/api/tasks'

export function useTasks() {
  return useQuery({ queryKey: ['tasks'], queryFn: tasksApi.list })
}

export function useCreateTask() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: tasksApi.create,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['tasks'] }),
  })
}

// In component:
function TasksPage() {
  const { data: tasks, isLoading, error } = useTasks()
  const createTask = useCreateTask()

  if (isLoading) return <TasksSkeleton />
  if (error) return <ErrorState error={error} />
  if (!tasks?.length) return <EmptyState />
  
  return <TaskList tasks={tasks} />
}
```

#### 4. Auth Context Pattern

```tsx
// contexts/AuthContext.tsx
import { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { authApi } from '@/api/auth'

interface AuthContextType {
  user: User | null
  isAuthenticated: boolean
  login: (email: string, password: string) => Promise<boolean>
  logout: () => void
  loading: boolean
}

const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const token = localStorage.getItem('token')
    if (!token) { setLoading(false); return }
    authApi.me().then(setUser).catch(() => localStorage.removeItem('token')).finally(() => setLoading(false))
  }, [])

  const login = async (email: string, password: string) => {
    try {
      const { token, user } = await authApi.login(email, password)
      localStorage.setItem('token', token)
      setUser(user)
      return true
    } catch { return false }
  }

  const logout = () => {
    localStorage.removeItem('token')
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, isAuthenticated: !!user, login, logout, loading }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
```

#### 5. Protected Routes + Role Guards

```tsx
function ProtectedRoute({ children }: { children: ReactNode }) {
  const { isAuthenticated, loading } = useAuth()
  if (loading) return <FullPageSpinner />
  if (!isAuthenticated) return <Navigate to="/login" replace />
  return <>{children}</>
}

function RoleGuard({ allowed, children }: { allowed: UserRole[], children: ReactNode }) {
  const { user } = useAuth()
  if (!user || !allowed.includes(user.role)) return <Navigate to="/app/dashboard" replace />
  return <>{children}</>
}

// Usage
<Route path="/app" element={<ProtectedRoute><AppLayout /></ProtectedRoute>}>
  <Route path="dashboard" element={<Dashboard />} />
  <Route path="admin" element={<RoleGuard allowed={['admin']}><AdminPage /></RoleGuard>} />
</Route>
```

#### 6. Role-Based Navigation

```typescript
// data/navigation.ts
import { Home, Users, BarChart, ListTodo, type LucideIcon } from 'lucide-react'

export type RoleCategory = 'admin' | 'team' | 'client'

interface NavItem {
  title: string
  url: string
  icon: LucideIcon
  roles: RoleCategory[]
}

const NAV_ITEMS: NavItem[] = [
  { title: 'דשבורד', url: '/app/dashboard', icon: Home, roles: ['admin', 'team', 'client'] },
  { title: 'משימות', url: '/app/tasks', icon: ListTodo, roles: ['admin', 'team', 'client'] },
  { title: 'לקוחות', url: '/app/clients', icon: Users, roles: ['admin', 'team'] },
  { title: 'מדדים', url: '/app/metrics', icon: BarChart, roles: ['admin'] },
]

export function getNavigation(category: RoleCategory) {
  return NAV_ITEMS.filter(item => item.roles.includes(category))
}
```

### React Best Practices

#### Rules of Hooks (Critical!)

**ALL hooks must be at the TOP of the component, BEFORE any early returns.**

```tsx
// ❌ BAD — useEffect after early return
function MyComponent() {
  const { user } = useAuth()
  if (!user) return null  // ❌ early return before hooks
  
  const [count, setCount] = useState(0)  // ❌ hook after a return
  useEffect(() => { /* ... */ }, [])
  return <div>...</div>
}

// ✅ GOOD — all hooks first, then returns
function MyComponent() {
  const { user } = useAuth()
  const [count, setCount] = useState(0)
  
  useEffect(() => {
    if (!user) return  // fine inside useEffect
  }, [user])
  
  if (!user) return null  // early return AFTER all hooks
  return <div>...</div>
}
```

Error message when violated: "Rendered fewer hooks than expected".

#### File Length Rules
- Components: < 300 lines (split if larger)
- Routes/pages: < 200 lines (extract sections)
- Utility files: < 200 lines

### Backend Best Practices

#### REST Conventions

| Method | Path | Action |
|---|---|---|
| GET | `/api/tasks` | List all |
| GET | `/api/tasks/:id` | Get one |
| POST | `/api/tasks` | Create |
| PATCH | `/api/tasks/:id` | Partial update |
| DELETE | `/api/tasks/:id` | Delete |

#### Status Codes

| Code | When |
|---|---|
| 200 | OK — success on GET, PATCH |
| 201 | Created — success on POST |
| 204 | No Content — success on DELETE |
| 400 | Bad Request — validation failed |
| 401 | Unauthorized — no/invalid auth |
| 403 | Forbidden — auth ok but no permission |
| 404 | Not Found |
| 409 | Conflict — e.g., email already exists |
| 429 | Too Many Requests — rate limit |
| 500 | Server Error |

#### Input Validation with Zod

```typescript
// validations/tasks.ts
import { z } from 'zod'

export const createTaskSchema = z.object({
  title: z.string().min(1).max(200),
  description: z.string().max(2000).optional(),
  priority: z.enum(['low', 'medium', 'high', 'urgent']).default('medium'),
  dueDate: z.string().datetime().optional(),
  assigneeId: z.string().uuid().optional(),
})

export type CreateTaskDto = z.infer<typeof createTaskSchema>

// middleware/validate.middleware.ts
export const validateBody = (schema: z.ZodSchema) => (req, res, next) => {
  const result = schema.safeParse(req.body)
  if (!result.success) {
    return res.status(400).json({
      error: 'Validation failed',
      details: result.error.flatten(),
    })
  }
  req.body = result.data
  next()
}
```

#### Centralized Error Handler

```typescript
// middleware/error.middleware.ts
export function errorHandler(err: any, req: Request, res: Response, next: NextFunction) {
  console.error(`[${new Date().toISOString()}] ${req.method} ${req.path}:`, err)
  
  if (err instanceof ZodError) {
    return res.status(400).json({ error: 'Validation failed', details: err.flatten() })
  }
  if (err.code === 'P2002') return res.status(409).json({ error: 'Resource already exists' })
  if (err.code === 'P2025') return res.status(404).json({ error: 'Resource not found' })
  if (err.status) return res.status(err.status).json({ error: err.message })
  return res.status(500).json({ error: 'Internal server error' })
}

// Mount LAST in server.ts
app.use(errorHandler)
```

#### Authentication Middleware

```typescript
// middleware/auth.middleware.ts
import jwt from 'jsonwebtoken'

export const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '')
  if (!token) return res.status(401).json({ error: 'No token provided' })
  
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as { userId: string, role: string }
    req.user = payload
    next()
  } catch {
    return res.status(401).json({ error: 'Invalid token' })
  }
}

export const requireRole = (...roles: string[]) => (req, res, next) => {
  if (!roles.includes(req.user?.role)) {
    return res.status(403).json({ error: 'Insufficient permissions' })
  }
  next()
}
```

#### Environment Variables (Validated)

```typescript
// config/env.ts — validate at startup
import { z } from 'zod'

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
  CORS_ORIGIN: z.string().url(),
  OPENAI_API_KEY: z.string().optional(),
})

export const env = envSchema.parse(process.env)
```

Provide `.env.example`:
```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
JWT_SECRET=change-me-to-a-long-random-string-of-at-least-32-chars
CORS_ORIGIN=http://localhost:5173
```

### Database Patterns (Prisma)

```prisma
// prisma/schema.prisma
enum UserRole {
  ADMIN
  TEAM_MEMBER
  CLIENT
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  password  String              // hashed with bcrypt
  name      String
  role      UserRole @default(CLIENT)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  tasks     Task[]   @relation("AssignedTasks")
  createdTasks Task[] @relation("CreatedTasks")
  
  @@index([email])
  @@index([role])
}

model Task {
  id          String   @id @default(cuid())
  title       String
  description String?  @db.Text
  status      String   @default("open")
  priority    String   @default("medium")
  dueDate     DateTime?
  
  createdById String
  createdBy   User     @relation("CreatedTasks", fields: [createdById], references: [id])
  assigneeId  String?
  assignee    User?    @relation("AssignedTasks", fields: [assigneeId], references: [id])
  
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  @@index([createdById])
  @@index([assigneeId])
  @@index([status])
}
```

**Seed Data:**
```typescript
// prisma/seed.ts
import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcrypt'

const prisma = new PrismaClient()

async function main() {
  const admin = await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      email: 'admin@example.com',
      password: await bcrypt.hash('admin123', 10),
      name: 'Admin User',
      role: 'ADMIN',
    },
  })
  
  await prisma.task.createMany({
    data: [
      { title: 'משימה ראשונה', createdById: admin.id, status: 'open', priority: 'high' },
      { title: 'משימה שנייה', createdById: admin.id, status: 'in_progress' },
    ],
  })
}

main().catch(console.error).finally(() => prisma.$disconnect())
```

Add to `package.json`: `"prisma": { "seed": "tsx prisma/seed.ts" }`. Run: `npx prisma db seed`.

---

