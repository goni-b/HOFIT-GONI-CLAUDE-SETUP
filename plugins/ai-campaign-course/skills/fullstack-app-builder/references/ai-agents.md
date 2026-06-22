## AI Agents Integration

Patterns for adding AI agents, chatbots, RAG, and LLM features to Full Stack apps.

### When to Add AI

Common requests:
- "Build a chatbot for our docs/website"
- "Create an AI assistant for X domain"
- "Add a feature where users can ask questions about their data"
- "Build an agent that does X automatically"
- "Generate summaries / titles / descriptions / suggestions"
- "Semantic search across our content"

### AI Framework Choice

#### Recommended: PydanticAI (Python backends)

```python
from pydantic_ai import Agent
from pydantic import BaseModel

class TaskSuggestion(BaseModel):
    title: str
    priority: str
    estimated_hours: int

agent = Agent(
    'openai:gpt-4o',
    result_type=TaskSuggestion,
    system_prompt="You are a productivity assistant. Suggest tasks based on user goals.",
)

result = await agent.run("I want to launch a podcast next month")
# result.data is a typed TaskSuggestion
```

**Why PydanticAI:**
- Type-safe with Pydantic models
- Supports all major LLM providers via env vars: `AI_MODEL=anthropic:claude-3-5-sonnet`
- Built-in tool calling, streaming, observability

#### Alternative: Vercel AI SDK (TypeScript/Next.js)

```bash
npm install ai @ai-sdk/openai @ai-sdk/anthropic
```

```typescript
import { streamText } from 'ai'
import { openai } from '@ai-sdk/openai'

const result = await streamText({
  model: openai('gpt-4o'),
  prompt: 'Hello, world!',
})

for await (const chunk of result.textStream) {
  console.log(chunk)
}
```

#### LLM Provider Choice

| Provider | Best for | Default model |
|---|---|---|
| Anthropic | Long context, careful reasoning, code | claude-3-5-sonnet-20241022 |
| OpenAI | Wide capability, mature tooling | gpt-4o or gpt-4o-mini (cheap) |
| Google Gemini | Multimodal, free tier | gemini-1.5-pro |
| OpenRouter | Try many models, fallback | various |

**Configure via env var:**
```
AI_PROVIDER=anthropic
AI_MODEL=claude-3-5-sonnet-20241022
ANTHROPIC_API_KEY=sk-ant-...
```

### Architecture: Chat with Streaming

#### Backend: FastAPI + WebSocket + PydanticAI

```python
# app/api/routes/agents.py
from fastapi import APIRouter, WebSocket
from app.agents.chat_agent import chat_agent

router = APIRouter()

@router.websocket("/ws/chat")
async def chat_ws(websocket: WebSocket):
    await websocket.accept()
    
    try:
        while True:
            data = await websocket.receive_json()
            user_message = data["message"]
            
            async with chat_agent.run_stream(user_message) as result:
                async for chunk in result.stream_text(delta=True):
                    await websocket.send_json({
                        "type": "text_delta",
                        "content": chunk
                    })
                
                await websocket.send_json({
                    "type": "complete",
                    "usage": result.usage().total_tokens
                })
    except Exception as e:
        await websocket.send_json({"type": "error", "message": str(e)})
        await websocket.close()
```

#### Frontend: React WebSocket Client Hook

```tsx
// hooks/useChatStream.ts
import { useState, useRef, useEffect } from 'react'

export function useChatStream(wsUrl: string) {
  const [messages, setMessages] = useState<Message[]>([])
  const [isStreaming, setIsStreaming] = useState(false)
  const wsRef = useRef<WebSocket | null>(null)
  
  useEffect(() => {
    const ws = new WebSocket(wsUrl)
    wsRef.current = ws
    
    ws.onmessage = (event) => {
      const data = JSON.parse(event.data)
      if (data.type === 'text_delta') {
        setMessages(prev => {
          const last = prev[prev.length - 1]
          if (last?.role === 'assistant' && last.streaming) {
            return [...prev.slice(0, -1), { ...last, content: last.content + data.content }]
          }
          return [...prev, { role: 'assistant', content: data.content, streaming: true }]
        })
      } else if (data.type === 'complete') {
        setMessages(prev => prev.map((m, i) =>
          i === prev.length - 1 ? { ...m, streaming: false } : m
        ))
        setIsStreaming(false)
      }
    }
    
    return () => ws.close()
  }, [wsUrl])
  
  const send = (message: string) => {
    setMessages(prev => [...prev, { role: 'user', content: message }])
    setIsStreaming(true)
    wsRef.current?.send(JSON.stringify({ message }))
  }
  
  return { messages, send, isStreaming }
}
```

#### Simplest Option: Vercel AI SDK with Next.js

```typescript
// app/api/chat/route.ts
import { streamText } from 'ai'
import { anthropic } from '@ai-sdk/anthropic'

export async function POST(req: Request) {
  const { messages } = await req.json()
  const result = await streamText({
    model: anthropic('claude-3-5-sonnet-20241022'),
    messages,
  })
  return result.toDataStreamResponse()
}
```

```tsx
// app/chat/page.tsx
'use client'
import { useChat } from 'ai/react'

export default function ChatPage() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat()
  
  return (
    <div className="flex flex-col h-screen">
      <div className="flex-1 overflow-y-auto p-4">
        {messages.map(m => (
          <div key={m.id}>{m.role}: {m.content}</div>
        ))}
      </div>
      <form onSubmit={handleSubmit} className="p-4">
        <Input value={input} onChange={handleInputChange} disabled={isLoading} />
      </form>
    </div>
  )
}
```

The Vercel AI SDK is the easiest path if you're already in Next.js.

### RAG (Retrieval-Augmented Generation)

When the AI needs to answer questions based on YOUR documents/data.

**Components:**
1. **Ingestion** — Parse documents, split into chunks, generate embeddings, store in vector DB
2. **Retrieval** — On user question, find relevant chunks via vector similarity
3. **Generation** — Pass retrieved context to LLM with the question

#### pgvector Setup with Prisma

```prisma
generator client {
  provider        = "prisma-client-js"
  previewFeatures = ["postgresqlExtensions"]
}

datasource db {
  provider   = "postgresql"
  url        = env("DATABASE_URL")
  extensions = [vector]
}

model Document {
  id        String   @id @default(cuid())
  content   String   @db.Text
  embedding Unsupported("vector(1536)")?  // OpenAI text-embedding-3-small = 1536
  metadata  Json?
  createdAt DateTime @default(now())
  
  @@index([embedding], type: Brin)
}
```

#### Ingestion + Retrieval Pipeline

```typescript
// services/rag.service.ts
import OpenAI from 'openai'
import { db } from '@/lib/db'

const openai = new OpenAI()

export async function ingestDocument(text: string, metadata: any) {
  const chunks = splitIntoChunks(text, 500, 50)  // 500 tokens, 50 overlap
  
  for (const chunk of chunks) {
    const { data } = await openai.embeddings.create({
      model: 'text-embedding-3-small',
      input: chunk,
    })
    const embedding = data[0].embedding
    
    await db.$executeRaw`
      INSERT INTO "Document" (id, content, embedding, metadata)
      VALUES (
        ${crypto.randomUUID()},
        ${chunk},
        ${`[${embedding.join(',')}]`}::vector,
        ${JSON.stringify(metadata)}::jsonb
      )
    `
  }
}

export async function answerQuestion(question: string) {
  // 1. Embed the question
  const { data } = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: question,
  })
  const queryEmbedding = data[0].embedding
  
  // 2. Find top-k relevant chunks
  const chunks = await db.$queryRaw<Document[]>`
    SELECT id, content, metadata,
           1 - (embedding <=> ${`[${queryEmbedding.join(',')}]`}::vector) AS similarity
    FROM "Document"
    ORDER BY embedding <=> ${`[${queryEmbedding.join(',')}]`}::vector
    LIMIT 5
  `
  
  // 3. Build context-augmented prompt
  const context = chunks.map((c, i) => `[${i + 1}] ${c.content}`).join('\n\n')
  
  const completion = await openai.chat.completions.create({
    model: 'gpt-4o',
    messages: [
      { role: 'system', content: 'Answer based on the provided context. Cite sources by [number].' },
      { role: 'user', content: `Context:\n${context}\n\nQuestion: ${question}` }
    ],
  })
  
  return {
    answer: completion.choices[0].message.content,
    sources: chunks.map(c => c.metadata),
  }
}
```

#### Document Parsing

| Tool | Best for |
|---|---|
| PyMuPDF | Fast, simple PDFs |
| LlamaParse | Complex layouts (tables, multi-column) — managed API, paid |
| Unstructured.io | Broad format support |
| pdf-parse (Node) | Node.js PDF text extraction |
| mammoth (Node) | .docx files |

### Tool-Calling Agents

For agents that need to take actions (query DB, call APIs, etc.):

#### PydanticAI Tool Example

```python
from pydantic_ai import Agent, RunContext

@dataclass
class Deps:
    user_id: str
    db: Database

agent = Agent[Deps]('openai:gpt-4o', deps_type=Deps, result_type=str)

@agent.tool
async def get_user_tasks(ctx: RunContext[Deps]) -> list[dict]:
    """Get tasks for the current user."""
    tasks = await ctx.deps.db.task.find_many(where={"userId": ctx.deps.user_id})
    return [{"title": t.title, "status": t.status, "due": t.dueDate} for t in tasks]

@agent.tool
async def create_task(ctx: RunContext[Deps], title: str, priority: str = "medium") -> str:
    """Create a new task for the user."""
    task = await ctx.deps.db.task.create({
        "title": title, "priority": priority, "userId": ctx.deps.user_id,
    })
    return f"Created task {task.id}"

# Usage
result = await agent.run(
    "What tasks do I have? Create a new high-priority one called 'Review designs'",
    deps=Deps(user_id="user123", db=db)
)
```

#### Vercel AI SDK Tools

```typescript
import { streamText, tool } from 'ai'
import { z } from 'zod'

const result = await streamText({
  model: anthropic('claude-3-5-sonnet-20241022'),
  prompt,
  tools: {
    getTasks: tool({
      description: 'Get tasks for the current user',
      parameters: z.object({}),
      execute: async () => {
        return await db.task.findMany({ where: { userId } })
      }
    }),
    createTask: tool({
      description: 'Create a new task',
      parameters: z.object({
        title: z.string(),
        priority: z.enum(['low', 'medium', 'high']),
      }),
      execute: async ({ title, priority }) => {
        return await db.task.create({ data: { title, priority, userId } })
      }
    }),
  },
  maxSteps: 5,  // allow multi-step tool use
})
```

### Conversation Persistence

```prisma
model Conversation {
  id        String    @id @default(cuid())
  userId    String
  user      User      @relation(fields: [userId], references: [id])
  title     String?
  messages  Message[]
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt
}

model Message {
  id             String       @id @default(cuid())
  conversationId String
  conversation   Conversation @relation(fields: [conversationId], references: [id], onDelete: Cascade)
  role           String       // 'user' | 'assistant' | 'system' | 'tool'
  content        String       @db.Text
  toolCalls      Json?
  createdAt      DateTime     @default(now())
  
  @@index([conversationId, createdAt])
}
```

### Cost Management & Observability

**Track every LLM call:**
```python
await db.usage.create({
    "userId": user_id,
    "model": "gpt-4o",
    "promptTokens": result.usage().request_tokens,
    "completionTokens": result.usage().response_tokens,
    "cost": calculate_cost(model, tokens),
})
```

**Rate limit per user:**
```python
allowed = await check_rate_limit(user_id, "ai_calls", max=100, window_hours=24)
if not allowed:
    raise HTTPException(429, "Rate limit exceeded")
```

**Model fallback by user tier:**
```typescript
const model = isPaidUser ? 'gpt-4o' : 'gpt-4o-mini'
```

**Observability:** Use Logfire (free, native for PydanticAI), LangSmith (for LangChain), or roll your own logging to `llm_logs` table.

### Common Pitfalls

1. **API key leaks** — ALWAYS route through backend. NEVER put `OPENAI_API_KEY` in client code.
2. **Slow first token** — Show "thinking..." indicator immediately. Use faster models for less critical tasks.
3. **Hallucinated tool calls** — Be explicit in system prompts. Validate tool args with Zod/Pydantic.
4. **Context window overflow** — Truncate old messages, summarize history, limit retrieved chunks.
5. **RAG returns irrelevant chunks** — Tune chunk size (300-500 tokens), use hybrid search (vector + keyword).
6. **Streaming UI flickers** — Use stable keys, virtualize long chats, batch state updates.

### Quick Start: Add AI to an Existing Next.js App (15 minutes)

```bash
npm install ai @ai-sdk/anthropic
```

```typescript
// app/api/chat/route.ts
import { streamText } from 'ai'
import { anthropic } from '@ai-sdk/anthropic'

export async function POST(req: Request) {
  const { messages } = await req.json()
  const result = await streamText({
    model: anthropic('claude-3-5-sonnet-20241022'),
    system: "You are a helpful assistant for [app name]. Be concise.",
    messages,
  })
  return result.toDataStreamResponse()
}
```

```tsx
// app/chat/page.tsx
'use client'
import { useChat } from 'ai/react'
import { Card } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'

export default function ChatPage() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat()
  
  return (
    <Card className="max-w-2xl mx-auto h-[80vh] flex flex-col">
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map(m => (
          <div key={m.id} className={m.role === 'user' ? 'text-end' : ''}>
            <div className={`inline-block px-4 py-2 rounded-lg ${m.role === 'user' ? 'bg-primary text-primary-foreground' : 'bg-muted'}`}>
              {m.content}
            </div>
          </div>
        ))}
      </div>
      <form onSubmit={handleSubmit} className="p-4 border-t flex gap-2">
        <Input value={input} onChange={handleInputChange} placeholder="Type a message..." />
        <Button type="submit" disabled={isLoading}>Send</Button>
      </form>
    </Card>
  )
}
```

Add `ANTHROPIC_API_KEY=...` to `.env.local`. Done.

---

