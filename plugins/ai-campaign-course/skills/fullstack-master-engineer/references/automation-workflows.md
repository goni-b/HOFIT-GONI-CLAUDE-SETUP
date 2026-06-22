# Automation Workflows — Simple and Complex

Use in INTEGRATE mode to automate a process: a one-off script, a scheduled job, a multi-app SaaS workflow,
browser automation, or scraping/ETL.

## Choose the right tool
| Need | Best tool |
|---|---|
| Deterministic data transform / file job / one-off | A script (Python/Node) run manually or on cron |
| Recurring job on a schedule | cron / a scheduler (GitHub Actions schedule, cloud scheduler, Supabase cron) |
| Connect SaaS apps with little/no code, fan-out, branching | Make (Integromat) / n8n / Zapier |
| Event-driven glue between your own services | A queue (Redis/BullMQ, SQS) + workers |
| No API available, must drive a UI | Browser automation (Playwright) |
| Pull structured data from web pages | Scraping (with an HTML parser); prefer an official API/feed if one exists |

For the owner's stack, Make.com is a common hub — design flows there and call out to scripts/APIs for the
parts that need real logic.

## Principles for any automation
- **Idempotent** — running it twice must not double-charge, double-send, or duplicate rows. Dedupe by a stable
  key; track what's already processed.
- **Resilient** — timeouts, retries with backoff, and a dead-letter path for items that keep failing. One bad
  record shouldn't halt the batch.
- **Observable** — log what ran, what succeeded, what failed, and why. Alert on failure (not on success).
- **Human-paced where it touches rate-limited or anti-bot systems** — throttle, randomize timing within
  reason, respect limits; don't hammer.
- **Secrets** — from env/secret manager, never inline. Least-privilege credentials.
- **Safe to re-run and easy to stop** — a kill switch / dry-run mode for anything that writes or sends.

## Script skeleton (robust batch job)
```python
def run(dry_run=False):
    items = fetch_pending()                 # source of truth for "what to do"
    for item in items:
        if already_done(item.id):           # idempotency
            continue
        try:
            with timeout(30):
                result = process(item)
            if not dry_run:
                mark_done(item.id, result)  # commit only after success
            log.info("ok", id=item.id)
        except Transient as e:
            retry_with_backoff(item, e)      # 5xx / 429 / network
        except Exception as e:
            dead_letter(item, e)             # don't crash the batch
            log.error("failed", id=item.id, err=str(e))
```

## Scheduling
- cron syntax `m h dom mon dow`; keep jobs short or make them resumable.
- In CI: a scheduled workflow; in cloud: a scheduler → function/queue; in Supabase: `pg_cron` / scheduled
  edge functions.
- Always make scheduled jobs idempotent — they will occasionally run twice or overlap.

## Browser automation & scraping (last resort, when no API)
- Use Playwright: explicit waits for elements (never blind `sleep`), handle navigation/timeouts, run headless.
- Respect the site: rate-limit, identify honestly where required, honor robots/ToS, cache results, don't
  scrape personal/protected data.
- Parse with a real HTML parser; make selectors resilient; expect the page to change and fail loudly.
- For data pipelines (ETL): extract → validate/clean → transform → load, with row-count checks and a sample
  audit before trusting a run.

## Never
- Build a writing/sending automation that isn't idempotent.
- Run unattended automation with no logging and no failure alert.
- Scrape when an official API exists, or ignore rate limits / ToS.
- Hardcode credentials into a workflow.
