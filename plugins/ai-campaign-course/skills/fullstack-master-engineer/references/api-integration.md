# API Design & Third-Party Integration

Use in INTEGRATE mode to design your own APIs or connect to external services and other apps/sites.

## Designing an API (contract first)
Define the contract before writing handlers. For each endpoint: method + path, auth requirement, request
body/params, response shape, and error responses.
- **REST conventions** — nouns not verbs (`/orders`, not `/getOrders`); HTTP verbs carry intent (GET read,
  POST create, PATCH partial update, PUT replace, DELETE remove); plural collections; nest sparingly
  (`/users/:id/orders`).
- **Status codes** — 200/201 success, 400 validation, 401 unauthenticated, 403 unauthorized, 404 missing,
  409 conflict, 422 semantic validation, 429 rate-limited, 500 server. Be specific.
- **Consistent envelopes** — same shape for success and for errors (`{ error: { code, message, details } }`).
  Never return "Something went wrong" with a 200.
- **Validation** — validate every input with a schema (Zod/Pydantic); reuse the same schema on the client.
- **Versioning** — `/v1/...` or a header; never break an existing version's contract.
- **Pagination, filtering, sorting** — standardize them (`?page=&limit=&sort=&filter=`); always paginate
  collections.
- **CORS** — allow only known origins; don't `*` a credentialed API.
- **Docs** — generate OpenAPI; keep examples accurate.
- **GraphQL** — when clients need flexible shapes; design the schema and resolvers, guard against N+1 with
  dataloaders, and limit query depth/complexity.

## Integrating a third-party service
1. **Read their docs** — auth method, base URL, rate limits, pagination, webhook model, sandbox/test mode.
2. **Auth** — API key (server-side only) or OAuth 2.0 (authorization-code flow; store refresh tokens
   securely; refresh on expiry). Never put provider secrets in the client.
3. **A typed client module** — wrap the service in one module with a base client (auth header, base URL,
   timeout). Never scatter raw `fetch` calls across the app.
4. **Resilience** — timeouts on every call; retry transient failures (5xx/429) with **exponential backoff +
   jitter**; cap retries; circuit-break repeated failures. Make calls idempotent where the provider allows
   (idempotency keys for payments/orders).
5. **Rate limits** — respect documented limits; throttle to a human/allowed pace; queue if needed.
6. **Map errors** — translate provider errors into your own error envelope; don't leak their raw payloads to
   users.
7. **Test mode first** — build and verify against sandbox before touching live keys/data.

## Webhooks (receiving events)
- **Verify the signature** on every incoming webhook (HMAC with the shared secret) before trusting the body —
  unverified webhooks are an open door.
- **Respond fast (2xx) then process async** — acknowledge receipt immediately; do the work in a queue so a
  slow handler doesn't cause the provider to retry/duplicate.
- **Idempotency** — providers retry; dedupe by event ID so you don't process the same event twice.
- **Log** raw events (minus secrets) for debugging and replay.

## Connecting apps/sites together
- Prefer an official API/webhook over scraping.
- For app-to-app data sync, decide the source of truth, the sync direction, and conflict resolution
  (last-write-wins vs merge); use webhooks for push and a scheduled reconcile for safety.
- For embedding/cross-site, use documented embed APIs, postMessage with origin checks, or signed URLs — never
  trust cross-origin input without validation.

## Never
- Trust an unverified webhook payload.
- Put a provider secret or token in client code.
- Call an external API with no timeout, no retry, and no error mapping.
- Build a sync with no defined source of truth or conflict rule.
