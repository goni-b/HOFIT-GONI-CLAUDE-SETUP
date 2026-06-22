# AI Agents & RAG Integration

Load when the app uses an LLM: chat, streaming, retrieval (RAG), or tool-calling agents. Default provider for
the owner is the **Anthropic API (Claude)**.

## When to add AI (and when not)
Add AI for: natural-language Q&A over content, summarization/extraction, classification, drafting, or an
assistant that takes actions via tools. Don't add it where a deterministic rule or a simple search is cheaper,
faster, and more reliable. Be explicit about which kind of AI: chatbot vs RAG vs tool-agent vs content-gen.

## Framework choice
- **Direct SDK** (Anthropic/OpenAI) — simplest; full control; good default for chat and single-step tasks.
- **PydanticAI** — type-safe agents in Python (FastAPI stacks).
- **LangChain/LlamaIndex** — when you want batteries-included RAG/agent tooling; more abstraction.
Keep all LLM keys **server-side only** — never in the client bundle.

## Streaming chat architecture
- Stream tokens to the UI (SSE or WebSocket) so responses feel instant; render incrementally.
- Keep the conversation state on the server; send the needed history with each request.
- Handle cancellation (user stops generation) and errors (provider timeout/rate limit) gracefully.

## RAG (retrieval-augmented generation)
Pipeline: **ingest** (load docs) → **chunk** (sensible sizes with overlap) → **embed** → **store** (vector DB)
→ at query time **retrieve** top-k relevant chunks → **augment** the prompt with them → **generate** →
optionally **cite** sources.
- **Vector store:** pgvector (already on Postgres/Supabase, <~1M vectors), Qdrant (scale/filtering),
  Chroma (local dev).
- Chunk by structure where possible; store metadata for filtering and citations.
- Quality levers: better chunking, hybrid (keyword + vector) search, re-ranking, and grounding the model to
  answer only from retrieved context (reduce hallucination).

## Tool-calling agents
- Define tools with strict schemas; validate the model's tool arguments before executing.
- **Treat tool results and model output as untrusted** — don't let them trigger privileged actions without
  checks (prompt-injection defense; see `security-hardening.md`).
- Bound the loop (max steps) and handle tool failures; log each tool call.

## Conversation persistence
- Persist messages (and tool calls) per conversation/user; scope by user.
- Trim/summarize long histories to control context size and cost.

## Cost & observability
- Cap tokens per request and per user; rate-limit to prevent cost abuse.
- Cache where inputs repeat; pick the right model size for the task (don't use the biggest model for trivial
  calls).
- Log latency, tokens, and errors; monitor spend.

## Common pitfalls
- Putting the LLM key in client code.
- No grounding → confident hallucinations in RAG.
- Unbounded agent loops or unvalidated tool execution.
- No token caps → runaway cost.
- Blocking the request thread on a long generation instead of streaming/queuing.
