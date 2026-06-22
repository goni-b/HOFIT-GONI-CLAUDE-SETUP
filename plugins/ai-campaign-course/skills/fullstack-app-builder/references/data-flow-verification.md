## Data Flow Verification Playbook

This is the critical document for ensuring your app actually works end-to-end.
A pretty UI that doesn't persist data is a failure. A working API with no UI is a failure.

### The Full Verification Chain (11 Steps)

For every data-touching feature, walk through this chain explicitly:

```
1. User performs action in UI
   (clicks button, submits form, drags item)
        ↓
2. Frontend component fires HTTP request
   ✓ Correct method (GET/POST/PATCH/DELETE)
   ✓ Correct URL
   ✓ Auth token in Authorization header
   ✓ Body shape matches backend expectation
        ↓
3. Backend route receives request
   ✓ Route registered (no 404)
   ✓ CORS allows the request
   ✓ Middleware runs (auth, validation, logging)
        ↓
4. Backend validates input
   ✓ Required fields present
   ✓ Types match schema
   ✓ Returns 400 with clear error if invalid
        ↓
5. Backend authorizes the action
   ✓ User is authenticated (401 if not)
   ✓ User has permission (403 if not)
   ✓ Resource ownership verified
        ↓
6. Backend writes to / reads from database
   ✓ Query succeeds
   ✓ Returns expected shape
        ↓
7. Backend returns response
   ✓ Correct status code (201 for create, 200 for read)
   ✓ Response shape documented in API spec
   ✓ No sensitive data leaked (passwords, internal IDs)
        ↓
8. Frontend handles response
   ✓ Success path: state updated, UI reflects change
   ✓ Error path: clear message shown, retry available
   ✓ TanStack Query: invalidate relevant queries
        ↓
9. UI reflects the change
   ✓ User sees the new state immediately
   ✓ Optimistic updates don't roll back unexpectedly
   ✓ Loading states resolved
        ↓
10. Persistence check
    ✓ REFRESH THE PAGE — data still there?
    ✓ Open in another tab — data appears?
    ✓ Check DB directly (Prisma Studio) — record exists?
        ↓
11. Auth scoping check
    ✓ Logout, login as different user — they don't see it
    ✓ Different role — appropriate access enforced
```

### Common Failure Modes (Debug Checklist)

#### Network / CORS

**Symptom:** Console shows "CORS error" or "blocked by CORS policy"
**Cause:** Backend not allowing the frontend origin.
**Fix:**
```typescript
import cors from 'cors'
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
  credentials: true,
}))
```

**Symptom:** Request never reaches backend, console shows network error.
**Cause:** Wrong base URL. **Fix:** Check `import.meta.env.VITE_API_URL` matches running backend.

#### Auth

**Symptom:** Login succeeds, but subsequent requests return 401.
**Cause:** Token not being attached.
**Fix:** Check axios interceptor or fetch wrapper attaches `Authorization: Bearer <token>`.

**Symptom:** Token attached but still 401.
**Cause:** Token expired, JWT_SECRET mismatch, or wrong header format.
**Fix:** Decode token at jwt.io, verify JWT_SECRET in .env, check header format `Bearer <token>` with space.

**Symptom:** User sees other users' data.
**Cause:** Missing WHERE clause for ownership.
**Fix:**
```typescript
// ❌ BAD — returns all tasks regardless of user
router.get('/api/tasks', authMiddleware, async (req, res) => {
  const tasks = await prisma.task.findMany()
  res.json(tasks)
})

// ✅ GOOD — scoped to current user
router.get('/api/tasks', authMiddleware, async (req, res) => {
  const tasks = await prisma.task.findMany({
    where: { OR: [{ createdById: req.user.id }, { assigneeId: req.user.id }] }
  })
  res.json(tasks)
})
```

#### Database / Persistence

**Symptom:** UI shows new item after creation, but it's gone on refresh.
**Cause:** Item was only in local state, never sent to backend.
**Fix:** Verify mutation actually fires:
- Check browser DevTools Network tab for POST request
- Check backend logs for the request
- Open Prisma Studio (`npx prisma studio`) to see actual DB rows

**Symptom:** Item is in DB but doesn't show in UI.
**Cause:** TanStack Query cache not invalidated after mutation.
**Fix:**
```typescript
const createTask = useMutation({
  mutationFn: tasksApi.create,
  onSuccess: () => queryClient.invalidateQueries({ queryKey: ['tasks'] }),
})
```

#### Validation

**Symptom:** Backend accepts garbage data (empty strings, malformed dates).
**Cause:** Missing or weak validation.
**Fix:** Add Zod schema and middleware (see Backend Best Practices above).

#### State / UI

**Symptom:** Optimistic update gets "stuck" if request fails.
**Cause:** Missing `onError` rollback.
**Fix:**
```typescript
const updateTask = useMutation({
  mutationFn: tasksApi.update,
  onMutate: async (newTask) => {
    await queryClient.cancelQueries({ queryKey: ['tasks'] })
    const previous = queryClient.getQueryData(['tasks'])
    queryClient.setQueryData(['tasks'], old => /* optimistic update */)
    return { previous }
  },
  onError: (err, _, context) => {
    queryClient.setQueryData(['tasks'], context.previous)  // ← Rollback
    toast.error('Failed to update')
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: ['tasks'] })
  }
})
```

### Testing Each Layer

#### Backend: Test with curl/Postman/Bruno

Before connecting frontend, verify backend works:

```bash
# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin123"}'
# → {"token":"eyJ..."}

# List tasks
curl http://localhost:3000/api/tasks \
  -H "Authorization: Bearer eyJ..."

# Create task
curl -X POST http://localhost:3000/api/tasks \
  -H "Authorization: Bearer eyJ..." \
  -H "Content-Type: application/json" \
  -d '{"title":"Test task","priority":"high"}'
# → 201 {"id":"...","title":"Test task",...}

# Verify in DB
npx prisma studio
```

#### Frontend: Test with browser DevTools
- **Network tab** — verify request method, URL, headers, body, response status
- **Console** — errors and warnings
- **Application → Storage** — verify token saved in localStorage
- **React DevTools** — inspect component state

#### End-to-End: Manual smoke test

For every feature, run this sequence:

1. **Cold start** — Login fresh, navigate to feature
2. **Empty state** — If applicable, see the friendly empty message
3. **Create** — Add a new item. See it appear. Refresh page. Still there.
4. **Read** — Navigate away and back. Item still there.
5. **Update** — Edit the item. Save. See updated. Refresh. Still updated.
6. **Delete** — Remove item. Gone from UI. Refresh. Still gone.
7. **Cross-user isolation** — Logout, login as different user. Item is NOT visible.
8. **Mobile check** — Resize browser to 375px. Layout still usable.

### Anti-Pattern: "It Looks Like It Works"

```typescript
// ❌ TERRIBLE — feels like it works but data only exists in local state
function TasksPage() {
  const [tasks, setTasks] = useState<Task[]>([])
  
  const handleCreate = (data: CreateTaskDto) => {
    const newTask = { id: Math.random().toString(), ...data, createdAt: new Date() }
    setTasks([...tasks, newTask])  // ← Only local state! Gone on refresh!
    toast.success('Created')
  }
  
  return <TaskList tasks={tasks} onCreate={handleCreate} />
}
```

This is one of the most common bugs — UI updates, user sees success, but data never persists.
**Always go through the API.**

### Anti-Pattern: Frontend Validation Only

```typescript
// ❌ BAD — only checks on frontend
const onSubmit = (data) => {
  if (!data.email.includes('@')) {
    toast.error('Invalid email')
    return
  }
  apiClient.post('/api/users', data)  // backend accepts anything
}
```

Always validate on backend too — frontend validation is for UX, backend validation is for security.

### Pre-Delivery Final Check

Before saying "the app is ready," answer these honestly:

1. Did I actually run the app and click through every screen?
2. Did I create a real record in the DB and refresh to verify persistence?
3. Did I log in as different users and verify data scoping?
4. Did I check mobile (375px) — does it work?
5. Did I check that empty states, loading states, and error states all show correctly?
6. Did I check the browser console for errors?
7. Did I check the server logs for 500 errors?
8. Did I make sure no API keys or secrets are committed to git?

If any answer is "no" or "I assumed it works" — go back and verify.

---

