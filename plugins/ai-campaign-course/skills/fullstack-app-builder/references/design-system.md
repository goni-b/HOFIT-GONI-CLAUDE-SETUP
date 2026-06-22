## Design System (UI/UX Standards)

Beautiful UI is one of the three pillars. These rules produce interfaces that feel intentional and professional.

### Visual Direction by Project Type

Choose the right direction at project start. Don't apply the same look to everything.

| Project Type | Direction | Reference Apps |
|---|---|---|
| Data-dense business (CRM, dashboards, admin) | Dark theme default, dense layouts, monospace numbers, subtle borders | Linear, Stripe Dashboard, Vercel |
| Client portals / B2B SaaS | Light theme often preferred, generous whitespace, soft shadows, accent sparingly | Notion, Asana, ClickUp |
| Consumer web apps | Light theme, large imagery, bold typography, generous whitespace | Airbnb, Stripe homepage |
| Internal tools | Clean and functional, either theme acceptable | Retool, internal admin panels |
| AI / chat apps | Either theme, focus on conversation UI, generous reading width | ChatGPT, Claude.ai, Perplexity |
| Marketing / landing | Bold typography, distinctive colors, hero sections, large CTAs | Linear's homepage, Vercel's homepage |

### Typography Standards

**Never use system fonts as the default.** Pick a distinctive font.

**Hebrew/RTL apps:** Heebo (default) or Assistant from Google Fonts.
```html
<link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700;800&display=swap" rel="stylesheet">
```

**English business apps:** Inter (most common), Geist (Vercel's), IBM Plex Sans (technical).
**English consumer apps:** Inter, Manrope, DM Sans.
**Display headings (optional):** Fraunces (elegant serif), Space Grotesk (geometric tech), Instrument Serif.

**Type scale:**

| Use | Tailwind | Pixels |
|---|---|---|
| Page hero | text-5xl/6xl | 48-60px |
| Page title (h1) | text-3xl/4xl | 30-36px |
| Section heading (h2) | text-2xl | 24px |
| Sub-heading (h3) | text-xl | 20px |
| Card title | text-lg | 18px |
| Body | text-base | 16px |
| Secondary text | text-sm | 14px |
| Metadata | text-xs | 12px |

Font weights: font-normal (400) body, font-medium (500) emphasized body, font-semibold (600) headings, font-bold (700) hero.

### Color System

Define these tokens upfront in CSS variables or `tailwind.config.js`.

**Dark theme example (Linear / Vercel style):**

```css
--background: #0A0A0B;        /* main page background */
--surface: #18181B;           /* cards, modals */
--surface-hover: #27272A;     /* card hover state */
--border: #27272A;            /* subtle dividers */
--border-strong: #3F3F46;     /* prominent dividers */

--foreground: #FAFAFA;        /* primary text */
--foreground-muted: #A1A1AA;  /* secondary text */
--foreground-subtle: #71717A; /* tertiary / metadata */

--primary: #8B5CF6;           /* primary actions, links */
--primary-foreground: #FFFFFF;
--accent: #06B6D4;            /* secondary accent, used rarely */

--success: #10B981;
--warning: #F59E0B;
--danger: #EF4444;
--info: #3B82F6;
```

**Light theme example:**

```css
--background: #FAFAFA;
--surface: #FFFFFF;
--surface-hover: #F4F4F5;
--border: #E4E4E7;
--border-strong: #D4D4D8;

--foreground: #0F172A;        /* slate-900 — high contrast */
--foreground-muted: #475569;  /* slate-600 — accessible body */
--foreground-subtle: #64748B; /* slate-500 — metadata */

--primary: #6366F1;
--primary-foreground: #FFFFFF;
--success: #059669;
--warning: #D97706;
--danger: #DC2626;
--info: #2563EB;
```

**Color usage rules:**
1. One primary color used sparingly — only for primary CTAs, active states, focus rings.
2. Semantic colors are fixed — green=success, red=danger, amber=warning, blue=info.
3. Light mode contrast — body text must be ≥ 4.5:1 (slate-700/900, not slate-400).
4. Dark mode contrast — body text should be `foreground-muted` (zinc-400), NOT subtle (zinc-500).
5. Borders are essential in light mode — never use `border-white/10` (invisible). Use `border-gray-200`+.
6. Glass effects in light mode — use `bg-white/80` minimum opacity.
7. Subtle elevation on dark — cards slightly lighter than background, not pure black on black.

**With shadcn/ui:** Use the built-in CSS variable system. It auto-handles dark mode:
```tsx
<div className="bg-background text-foreground">
  <Card className="bg-card text-card-foreground border-border">
    <Button variant="default">Primary</Button>
    <Button variant="secondary">Secondary</Button>
    <Button variant="outline">Outline</Button>
    <Button variant="ghost">Ghost</Button>
    <Button variant="destructive">Delete</Button>
  </Card>
</div>
```

### Layout Principles

**Whitespace:** Cramped layouts feel cheap. Use larger gaps than feel necessary.

| Context | Suggested padding/gap |
|---|---|
| Page top/bottom | py-8 to py-16 |
| Section gap | gap-8 to gap-12 |
| Card padding | p-6 |
| Card grid gap | gap-4 to gap-6 |
| Form field gap | space-y-4 to space-y-6 |
| Button padding | px-4 py-2 (default), px-6 py-3 (large) |

**Spacing scale:** Pick one (Tailwind default: 4/8/16/24/32/48/64) and stick to it. Never random pixel values.

**Max content width:**
- Marketing / landing: max-w-7xl (1280px) or max-w-6xl (1152px)
- Reading / docs: max-w-3xl (768px) or max-w-4xl (896px)
- Dashboard data: max-w-7xl or full width for tables
- Auth forms: max-w-md (448px)

**Grid patterns:**

```tsx
// Dashboard KPI grid
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

// Two-column dashboard
<div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
  <div className="lg:col-span-2">{main}</div>
  <div>{sidebar}</div>
</div>

// Card grid
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
```

### Component Standards

#### Buttons (shadcn/ui)
```tsx
<Button>Primary action</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="destructive">Delete</Button>
<Button variant="link">Link style</Button>

// Loading state
<Button disabled={isLoading} type="submit">
  {isLoading && <Loader2 className="me-2 h-4 w-4 animate-spin" />}
  {isLoading ? "שומר..." : "שמור"}
</Button>
```

#### Forms (react-hook-form + Zod + shadcn/ui)
```tsx
const schema = z.object({
  email: z.string().email("אימייל לא תקין"),
  password: z.string().min(8, "סיסמה חייבת להכיל לפחות 8 תווים"),
})

export function LoginForm() {
  const form = useForm({
    resolver: zodResolver(schema),
    defaultValues: { email: "", password: "" }
  })

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField control={form.control} name="email" render={({ field }) => (
          <FormItem>
            <FormLabel>אימייל</FormLabel>
            <FormControl><Input type="email" {...field} /></FormControl>
            <FormMessage />
          </FormItem>
        )} />
        <Button type="submit" className="w-full">התחבר</Button>
      </form>
    </Form>
  )
}
```

#### Cards, Tables, Modals
```tsx
// Card
<Card>
  <CardHeader>
    <CardTitle>כותרת</CardTitle>
    <CardDescription>תיאור משני</CardDescription>
  </CardHeader>
  <CardContent>{content}</CardContent>
  <CardFooter><Button>פעולה</Button></CardFooter>
</Card>

// Modal
<Dialog open={open} onOpenChange={setOpen}>
  <DialogTrigger asChild><Button>פתח</Button></DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>כותרת</DialogTitle>
      <DialogDescription>הסבר</DialogDescription>
    </DialogHeader>
    {content}
    <DialogFooter>
      <Button variant="outline" onClick={() => setOpen(false)}>ביטול</Button>
      <Button onClick={handleSave}>שמור</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

**Modal required behaviors:** Backdrop click closes, Escape key closes, Focus trap, Smooth animation.

#### Toasts (Sonner)
```tsx
import { toast } from "sonner"
toast.success("נשמר בהצלחה")
toast.error("שגיאה בשמירה")
toast.loading("שומר...")
```
**Position:** bottom-right (LTR) or bottom-left (RTL). Auto-dismiss 4s for success, manual for errors.

#### Loading States by Duration

| Wait time | Pattern |
|---|---|
| < 200ms | No indicator |
| 200ms - 1s | Spinner |
| 1s - 5s | Skeleton screen |
| > 5s | Progress bar with text |

#### Empty States — Never show a blank screen

```tsx
<div className="flex flex-col items-center justify-center py-16 text-center">
  <FolderOpen className="h-12 w-12 text-muted-foreground mb-4" />
  <h3 className="text-lg font-semibold mb-2">אין משימות עדיין</h3>
  <p className="text-sm text-muted-foreground mb-6">צור את המשימה הראשונה שלך</p>
  <Button onClick={() => setOpen(true)}>+ משימה חדשה</Button>
</div>
```

#### Error States — Specific message + retry

```tsx
<div className="flex flex-col items-center justify-center py-16 text-center">
  <AlertCircle className="h-12 w-12 text-destructive mb-4" />
  <h3 className="text-lg font-semibold mb-2">משהו השתבש</h3>
  <p className="text-sm text-muted-foreground mb-6">{error.message}</p>
  <Button variant="outline" onClick={retry}>נסה שוב</Button>
</div>
```

### Icons

**ALWAYS use SVG icons. NEVER use emojis as UI icons.**

**Recommended:** Lucide React (default, used in shadcn/ui), Heroicons (Tailwind's), Simple Icons (brand logos).

```tsx
import { Plus, Trash, Edit, LogOut, ChevronRight } from "lucide-react"
<Plus className="h-5 w-5" />
```

**Icon sizing:** Tiny (h-3/h-4), Default (h-5), Prominent (h-6), Hero (h-12+).

### Interaction Standards

**Hover states** — every clickable element MUST have hover feedback:
- Buttons: shadcn handles
- Cards: `hover:bg-muted/50` or `hover:border-foreground/20`
- Nav items: `hover:bg-sidebar-accent`
- **DON'T use `scale-105` on cards — causes layout shift**

**Cursor:** Add `cursor-pointer` to all clickable elements that aren't buttons/links.

**Transitions:**
- Color changes: `transition-colors duration-200`
- Multiple properties: `transition-all duration-200`
- Avoid > 300ms unless intentional

### Mobile Responsiveness (Non-Negotiable)

Test at 375px (iPhone SE), 768px (iPad), 1280px+ (desktop).

**Tailwind breakpoints:** sm:640+, md:768+, lg:1024+, xl:1280+, 2xl:1536+

**Common patterns:**

```tsx
// Sidebar → mobile drawer
<div className="hidden md:flex">{/* Desktop sidebar */}</div>
<Sheet>
  <SheetTrigger className="md:hidden"><Menu /></SheetTrigger>
  <SheetContent>{/* Mobile drawer */}</SheetContent>
</Sheet>

// Multi-column → stacked
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">

// Table → cards on mobile
<div className="hidden md:block">{/* Table */}</div>
<div className="md:hidden space-y-3">{/* Card list */}</div>
```

### Dark Mode Implementation

```bash
npm install next-themes
```

```tsx
// providers.tsx
import { ThemeProvider } from "next-themes"
export function Providers({ children }) {
  return (
    <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
      {children}
    </ThemeProvider>
  )
}

// Toggle
export function ThemeToggle() {
  const { theme, setTheme } = useTheme()
  return (
    <Button variant="ghost" size="icon" onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
      <Sun className="h-5 w-5 dark:hidden" />
      <Moon className="hidden h-5 w-5 dark:block" />
    </Button>
  )
}
```

### Accessibility (a11y) Requirements

Every project must:
- All images have `alt` text (decorative: `alt=""`)
- All form inputs have associated labels
- Color is not the only indicator (icons + text for status)
- Keyboard navigation works (Tab, Enter, Esc)
- Focus visible on all interactive elements
- `prefers-reduced-motion` respected

For icon-only buttons:
```tsx
<Button variant="ghost" size="icon">
  <Trash className="h-4 w-4" />
  <span className="sr-only">מחק</span>
</Button>
```

---

