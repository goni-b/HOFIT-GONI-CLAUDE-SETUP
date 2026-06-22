# Data Flow Verification Playbook

Load when verifying any data feature, or when data "isn't flowing." This is what separates real full-stack
work from frontend theater: prove the whole chain works, don't assume it.

## The full chain (verify each link)
For a feature like "create a record and see it in the list":
1. **UI event** fires on the user action (button/submit handler runs).
2. **Client validation** passes (or shows correct errors).
3. **Request sent** — correct method, URL, headers (auth token attached!), and body (check the Network tab).
4. **Reaches the server** — the route handler is hit (server log).
5. **Server validation** passes (schema).
6. **Authz** — the action is allowed and scoped to the current user.
7. **DB write** happens (query log / the ORM returns the created row).
8. **Persists** — the row is actually in the DB (query it directly / Prisma Studio / Supabase table view).
9. **Response** is shaped correctly and returns the right status.
10. **UI updates** — TanStack Query invalidates/refetches and the new data appears.
11. **Survives refresh** — reload the page; the data is still there (the real persistence test).

## The decisive checks (do these, don't skip)
- **Create a real record, then refresh** — if it's gone, it never persisted (a classic mock-data illusion).
- **Log in as two different users** — confirm each sees only their own data (authz scoping).
- **Open the Network tab** — confirm the request is actually sent with the auth header and the right body, and
  inspect the real response.
- **Check the browser console** — zero errors. **Check the server logs** — zero 500s.

## Debug by layer when data doesn't flow
Walk the chain and find the first broken link, then go deep there:
- Nothing happens on click → the handler isn't wired / a JS error broke it (console).
- Request not sent → client validation failing silently, or the handler returns early.
- 401 → no token attached (API client interceptor) or it's expired.
- 403 → authz rejecting (check the scoping rule).
- 400/422 → server validation; compare the body to the schema.
- Request OK but DB unchanged → service/repository not actually writing, or a swallowed error.
- DB has the row but UI is stale → query not invalidated/refetched after the mutation.
- Works until refresh → you were rendering optimistic/local state that never hit the server.

## Common failure modes
- Login "succeeds" but no token is attached to subsequent requests.
- Frontend shows data from `useState` that never came from the server.
- Backend works in isolation but the UI shows stale data (no invalidation).
- One user sees another's data (missing `where user_id = current_user`).
- Empty/loading/error states missing, so failures look like "nothing happened."

## Pre-delivery final check
- [ ] All routes load; all endpoints respond correctly.
- [ ] Data persists after refresh.
- [ ] Auth scopes data (users see only their own).
- [ ] No console errors; no 500s in server logs.
- [ ] Mobile (375px) usable; empty/loading/error states show.
- [ ] No secrets committed; `.env.example` present.

Answer honestly: did I actually run it and click through every screen? Did I create a record and refresh? Did
I log in as different users? If any answer is "I assumed it works," go back and verify.
