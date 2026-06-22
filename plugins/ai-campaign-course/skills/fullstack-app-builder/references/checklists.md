## Anti-Patterns to Avoid

These distinguish amateur work from professional. Watch yourself for these:

### Process anti-patterns
- ❌ Starting to code before the plan is approved
- ❌ Asking the user 10 clarifying questions when 2-3 would do
- ❌ Plowing ahead with assumptions when 1 clarifying question would have saved an hour
- ❌ Skipping tasks or jumping ahead in the task list
- ❌ Saying "it works" without actually testing the full user flow

### Technical anti-patterns
- ❌ Building a beautiful frontend that hits no real backend ("mock data app")
- ❌ Building a backend with no UI to actually use it
- ❌ Skipping validation because "the frontend already validates"
- ❌ Hardcoding URLs, API keys, or environment-specific values
- ❌ Returning vague errors like "Something went wrong" — be specific with codes
- ❌ Putting everything in one giant file (>500 lines)
- ❌ Copy-pasting the same logic across files instead of extracting a helper
- ❌ Delivering a multi-page app where half the navigation links are broken
- ❌ Forgetting mobile responsiveness until the end
- ❌ Putting hooks AFTER early returns (Rules of Hooks violation)
- ❌ Using `fetch()` directly in components instead of an API client module
- ❌ Storing server data in useState instead of TanStack Query
- ❌ Putting `OPENAI_API_KEY` (or any LLM key) in client code
- ❌ Returning all records to all users instead of scoping by user.id

### Design anti-patterns
- ❌ Using default browser styles (Times New Roman, blue underlined links)
- ❌ Using emojis as UI icons (use Lucide React or Heroicons SVGs)
- ❌ Cramped layouts with insufficient whitespace
- ❌ Glass/transparent cards that are invisible in light mode (`bg-white/10`)
- ❌ No hover states on clickable elements
- ❌ Inconsistent spacing (random pixel values instead of a scale)
- ❌ Floating navbars stuck to `top-0` without breathing room
- ❌ Light-mode text that's too low-contrast (e.g., gray-400 body text)
- ❌ Using `scale-105` on hover for cards (causes layout shift)
- ❌ Using physical Tailwind properties (`pl-`, `pr-`, `ml-`, `mr-`) in RTL projects
- ❌ Native `<input type="date">` in RTL projects (broken)

---

## Output and Delivery

When a project (or meaningful milestone) is complete:

1. Place all project files in the user's chosen project directory (ask if not given; default to a new folder in the current working directory)
2. Include a **README.md** with:
   - What the app does (one paragraph)
   - Tech stack summary (with versions)
   - Setup instructions (install, env vars, run dev server, run migrations, seed data)
   - API endpoint documentation
   - Project structure overview
   - Deployment notes (Vercel/Railway/Docker)
3. Include `.env.example` files (both client and server) showing required environment variables
4. Save the README first, then the key files, into the project directory
5. Summarize for the user:
   - What was built (feature checklist)
   - How to run it locally (commands to copy-paste)
   - What's tested and verified end-to-end
   - What's left or could be improved next
   - Any credentials/setup the user must do themselves (API keys, OAuth apps, etc.)

### Communication Style

- **Be concise but complete** — don't pad explanations, but don't skip steps.
- **Bilingual support** — if the user writes in Hebrew, respond in Hebrew. Always offer Hebrew UI + RTL for Israeli users.
- **Explain decisions briefly** — when you choose a stack or pattern, give a one-sentence reason.
- **Confirm at decision points** — "I'm using Prisma + SQLite for dev, easy to swap to PostgreSQL later. Sound good?"
- **Honest about trade-offs** — if something is prototype-grade vs production-ready, say so.
- **Show progress, not silence** — during long task execution, periodically summarize what's done.

### Quick Reference: When to Stop and Ask

Pause and ask the user (don't charge ahead) when:

- The data model is ambiguous (e.g., "should an order have multiple products or just one?")
- A feature could be built simply or with full production rigor (auth, payments, file upload, notifications)
- The plan you're about to write would be very large (>20 tasks) — confirm scope first
- You hit a fork in execution where two reasonable paths exist
- The user mentions an external service without specifying which one (e.g., "send emails" — Resend? SendGrid? SMTP?)
- Hebrew vs English UI hasn't been specified for an Israeli user
- The user mentions "AI" without specifying what kind (chatbot? RAG? agent with tools? content generation?)

Don't ask about trivia. Don't ask about color choices unless they significantly affect direction.
Don't ask about variable names or file names. Ask about architecture and product decisions only.

---

## Pre-Delivery Checklists

### Self-Check Before Declaring Done

Before saying a milestone is done, verify:

- [ ] All planned routes exist and load
- [ ] All planned API endpoints exist and respond correctly
- [ ] Data persists after page refresh
- [ ] Auth properly scopes data (users see only their own data)
- [ ] No console errors in browser
- [ ] No 500 errors in server logs
- [ ] Mobile layout at 375px width is usable
- [ ] Empty states show friendly messages
- [ ] Error states show specific messages with retry
- [ ] Loading states show during async operations
- [ ] All clickable elements have `cursor-pointer` and hover feedback
- [ ] No emojis used as UI icons (Lucide React used instead)
- [ ] If Hebrew: RTL works correctly, fonts are Heebo/Assistant, dates display correctly
- [ ] README.md explains how to run the project
- [ ] .env.example exists with all required variables (no actual secrets committed)

### Pre-Delivery UI Checklist

#### Visual quality
- [ ] No emojis used as icons (Lucide React/Heroicons SVGs instead)
- [ ] All icons from a single consistent set
- [ ] Brand logos verified from Simple Icons
- [ ] Theme colors used directly (`bg-primary`) not as `var()` wrappers
- [ ] Hover states don't cause layout shift (no `scale-105` on cards)

#### Interaction
- [ ] All clickable elements have `cursor-pointer`
- [ ] Hover states provide clear visual feedback
- [ ] Transitions smooth (150-300ms)
- [ ] Focus states visible for keyboard navigation
- [ ] Submit buttons disabled during loading

#### Light/dark mode (if both supported)
- [ ] Light mode text contrast ≥ 4.5:1
- [ ] Glass/transparent elements visible in light mode (`bg-white/80`+)
- [ ] Borders visible in both modes
- [ ] Both modes tested before delivery

#### Layout
- [ ] Floating navbars have spacing from edges (`top-4 left-4 right-4`, not `top-0`)
- [ ] No content hidden behind fixed navbars
- [ ] Responsive at 375px, 768px, 1024px, 1440px
- [ ] No horizontal scroll on mobile

#### Accessibility
- [ ] Images have alt text
- [ ] Form inputs have labels
- [ ] Color is not the only indicator
- [ ] `prefers-reduced-motion` respected

#### Hebrew/RTL (if applicable)
- [ ] `dir="rtl"` on html element
- [ ] Font is Heebo or Assistant
- [ ] Icons mirror correctly (or stay neutral)
- [ ] Date inputs use custom Calendar component (not native `<input type="date">`)
- [ ] DropdownMenuContent uses `style={{ direction: "rtl" }}` (not `dir` prop)
- [ ] Email/phone/URL inputs have `dir="ltr"`
- [ ] No physical Tailwind properties in layout-critical places

### Final Verification Questions

Answer these honestly before declaring complete:

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

**End of Skill Definition**

This skill enforces a senior Full Stack workflow with three equal pillars: structured planning, beautiful UI/UX, and end-to-end data integrity. Always plan before coding. Always verify before declaring done.
