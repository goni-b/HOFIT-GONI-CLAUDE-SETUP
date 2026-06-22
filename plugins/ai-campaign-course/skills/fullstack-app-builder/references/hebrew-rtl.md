## Hebrew / RTL Patterns

Production-tested patterns for building Hebrew/RTL apps. These avoid common gotchas that break in RTL.

### Initial Setup

#### 1. HTML root element

```html
<!-- index.html (Vite) -->
<html lang="he" dir="rtl">
```

```tsx
// Next.js app/layout.tsx
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="he" dir="rtl">
      <body>{children}</body>
    </html>
  )
}
```

#### 2. Font setup

Use Heebo or Assistant from Google Fonts. Heebo is the modern default.

**Vite (index.html):**
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Heebo:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
```

**Next.js:**
```tsx
import { Heebo } from 'next/font/google'

const heebo = Heebo({ subsets: ['hebrew', 'latin'], variable: '--font-heebo' })

export default function RootLayout({ children }) {
  return (
    <html lang="he" dir="rtl" className={heebo.variable}>
      <body className="font-heebo">{children}</body>
    </html>
  )
}
```

**Tailwind config:**
```js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Heebo', 'sans-serif'],
        heebo: ['Heebo', 'sans-serif'],
      },
    },
  },
}
```

#### 3. Tailwind RTL plugin (recommended)

```bash
npm install tailwindcss-rtl
```

```js
module.exports = {
  plugins: [require('tailwindcss-rtl')],
}
```

This gives you `ps-4` (padding-inline-start) instead of `pl-4` (padding-left), which automatically flips in RTL contexts.

### Logical Properties (Critical!)

Use logical properties that respect text direction, NOT physical left/right.

| ❌ Physical (avoid) | ✅ Logical (use these) | What it means |
|---|---|---|
| `pl-4` | `ps-4` | padding-inline-start (right in RTL, left in LTR) |
| `pr-4` | `pe-4` | padding-inline-end |
| `ml-4` | `ms-4` | margin-inline-start |
| `mr-4` | `me-4` | margin-inline-end |
| `left-4` | `start-4` | inset-inline-start |
| `right-4` | `end-4` | inset-inline-end |
| `text-left` | `text-start` | text-align: start |
| `text-right` | `text-end` | text-align: end |
| `border-l` | `border-s` | border-inline-start |
| `border-r` | `border-e` | border-inline-end |
| `rounded-l-md` | `rounded-s-md` | border-radius-start |
| `rounded-r-md` | `rounded-e-md` | border-radius-end |

**Example:**
```tsx
// ❌ BAD — breaks in RTL
<div className="pl-4 mr-2 text-left">

// ✅ GOOD — works in both directions
<div className="ps-4 me-2 text-start">
```

**Exception:** When you specifically want something fixed regardless of direction (e.g., a logo always on the left), use physical properties intentionally.

### Component Gotchas

#### Native date input is BROKEN in RTL

`<input type="date">` doesn't render correctly in RTL on most browsers. Always use a custom calendar.

```tsx
// ❌ BAD
<input type="date" />

// ✅ GOOD — use shadcn/ui Calendar + Popover
import { Calendar } from "@/components/ui/calendar"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import { format } from "date-fns"
import { he } from "date-fns/locale"

function DatePicker({ value, onChange }) {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button variant="outline" className="w-full justify-start">
          <CalendarIcon className="me-2 h-4 w-4" />
          {value ? format(value, "dd/MM/yyyy", { locale: he }) : "בחר תאריך"}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto p-0">
        <Calendar mode="single" selected={value} onSelect={onChange} locale={he} />
      </PopoverContent>
    </Popover>
  )
}
```

#### DropdownMenu / Select — direction prop

shadcn/ui dropdowns need explicit direction:

```tsx
// ❌ BAD — won't position correctly
<DropdownMenuContent dir="rtl">

// ✅ GOOD — use style prop
<DropdownMenuContent style={{ direction: "rtl" }}>
```

#### Number and date formatting

```typescript
// Currency in Hebrew context
function formatCurrency(amount: number) {
  return new Intl.NumberFormat('he-IL', {
    style: 'currency',
    currency: 'ILS',
  }).format(amount)
}

// Date in Hebrew: "12 בפברואר 2025"
function formatDateHe(date: Date) {
  return new Intl.DateTimeFormat('he-IL', { dateStyle: 'long' }).format(date)
}
```

#### Icons that should/shouldn't flip

| Icon type | Flip in RTL? |
|---|---|
| Arrows (`→ ←`) | YES — ChevronRight becomes ChevronLeft |
| Back/forward navigation | YES |
| Send (paper airplane) | Maybe — usually keep |
| Logos, brand icons | NO |
| Symmetric icons (search, settings) | NO (no flip needed) |
| Notification bell, user avatar | NO |

For directional icons:
```tsx
// Approach 1: Conditional component
function BackButton() {
  return <ChevronRight className="h-5 w-5" />  // In RTL, "back" points right
}

// Approach 2: CSS flip
<ArrowRight className="h-5 w-5 rtl:rotate-180" />
```

#### Sidebar position

In RTL, sidebars typically go on the right (visually = inline-start in RTL).

```tsx
<aside className="border-s border-sidebar-border h-screen w-64">
  {/* content */}
</aside>
```

#### Toast position

```tsx
// RTL: toasts appear top-left or bottom-left visually
<Toaster position="bottom-left" />
```

### Common Patterns

#### Hebrew form with mixed-direction inputs

```tsx
const schema = z.object({
  name: z.string().min(2, "שם חייב להכיל לפחות 2 תווים"),
  email: z.string().email("כתובת אימייל לא תקינה"),
  phone: z.string().regex(/^0\d{1,2}-?\d{7}$/, "מספר טלפון לא תקין"),
})

export function ContactForm() {
  const form = useForm({
    resolver: zodResolver(schema),
    defaultValues: { name: "", email: "", phone: "" },
  })

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField control={form.control} name="name" render={({ field }) => (
          <FormItem>
            <FormLabel>שם מלא</FormLabel>
            <FormControl>
              <Input placeholder="ישראל ישראלי" {...field} />
            </FormControl>
            <FormMessage />
          </FormItem>
        )} />
        
        <FormField control={form.control} name="email" render={({ field }) => (
          <FormItem>
            <FormLabel>אימייל</FormLabel>
            <FormControl>
              <Input type="email" dir="ltr" placeholder="name@example.com" {...field} />
            </FormControl>
            <FormMessage />
          </FormItem>
        )} />
        
        <FormField control={form.control} name="phone" render={({ field }) => (
          <FormItem>
            <FormLabel>טלפון</FormLabel>
            <FormControl>
              <Input type="tel" dir="ltr" placeholder="050-1234567" {...field} />
            </FormControl>
            <FormMessage />
          </FormItem>
        )} />
        
        <Button type="submit" className="w-full">שלח</Button>
      </form>
    </Form>
  )
}
```

**Important:** For email, phone, URLs, prices — set `dir="ltr"` on the input itself. These are inherently LTR content even in a Hebrew form.

#### Hebrew table

```tsx
<Table>
  <TableHeader>
    <TableRow>
      <TableHead>שם</TableHead>
      <TableHead>אימייל</TableHead>
      <TableHead>תפקיד</TableHead>
      <TableHead>סטטוס</TableHead>
      <TableHead className="text-end">פעולות</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    {users.map(user => (
      <TableRow key={user.id}>
        <TableCell className="font-medium">{user.name}</TableCell>
        <TableCell dir="ltr" className="text-start">{user.email}</TableCell>
        <TableCell><Badge>{user.role}</Badge></TableCell>
        <TableCell>
          <Badge variant={user.active ? "default" : "secondary"}>
            {user.active ? "פעיל" : "לא פעיל"}
          </Badge>
        </TableCell>
        <TableCell className="text-end">
          <Button variant="ghost" size="sm">ערוך</Button>
        </TableCell>
      </TableRow>
    ))}
  </TableBody>
</Table>
```

#### Mixed content (Hebrew with English/numbers)

```tsx
// Numbers and English embedded in Hebrew text — browsers handle automatically
<p>הלקוח {clientName} שילם ₪1,234.50 בתאריך 12/02/2026</p>

// For entire string of code/URL, use dir="ltr":
<code dir="ltr">npm install package-name</code>

// For mixed inline:
<p>אורך הקובץ: <span dir="ltr">2.5 MB</span></p>
```

### Common Israeli App Features

#### Israeli phone number validation

```typescript
const israeliPhoneRegex = /^0(5[0-9]|7[2-9])-?\d{7}$/  // Mobile
const israeliLandlineRegex = /^0([2-489])-?\d{7}$/    // Landline

function formatPhone(phone: string): string {
  const digits = phone.replace(/\D/g, '')
  if (digits.length === 10 && digits.startsWith('05')) {
    return `${digits.slice(0, 3)}-${digits.slice(3)}`
  }
  return phone
}
```

#### Israeli ID (Teudat Zehut) validation

```typescript
function isValidIsraeliId(id: string): boolean {
  const digits = id.replace(/\D/g, '').padStart(9, '0')
  if (digits.length !== 9) return false
  
  let sum = 0
  for (let i = 0; i < 9; i++) {
    let num = parseInt(digits[i]) * ((i % 2) + 1)
    if (num > 9) num -= 9
    sum += num
  }
  return sum % 10 === 0
}
```

#### Hebrew date formatting with date-fns

```typescript
import { format, formatDistanceToNow } from "date-fns"
import { he } from "date-fns/locale"

format(new Date(), "PPP", { locale: he })          // "11 בפברואר 2026"
format(new Date(), "PPPp", { locale: he })         // "11 בפברואר 2026 בשעה 14:30"
formatDistanceToNow(new Date(), { locale: he, addSuffix: true })  // "לפני 5 דקות"
```

#### Google Calendar / Maps deep links (Israeli context)

```typescript
// Google Calendar deep link (no OAuth needed)
function googleCalendarLink(event: { title: string, start: Date, end: Date, location?: string }) {
  const params = new URLSearchParams({
    action: 'TEMPLATE',
    text: event.title,
    dates: `${format(event.start, "yyyyMMdd'T'HHmmss")}/${format(event.end, "yyyyMMdd'T'HHmmss")}`,
    location: event.location || '',
    ctz: 'Asia/Jerusalem',
  })
  return `https://calendar.google.com/calendar/r/eventedit?${params}`
}

// Google Maps link
function googleMapsLink(address: string) {
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`
}
```

#### RTL-friendly Kanban board

```tsx
// In RTL, columns flow right-to-left. New tasks on the right, done on the left.
<div className="flex gap-4 overflow-x-auto">
  {["חדש", "בטיפול", "תקוע", "הושלם"].map(status => (
    <KanbanColumn key={status} status={status} className="w-72 flex-shrink-0">
      {/* tasks */}
    </KanbanColumn>
  ))}
</div>
```

### Layout Direction Mental Model

When designing in RTL, mentally flip your natural reading direction:

| LTR thinking | RTL thinking |
|---|---|
| Logo top-left, user menu top-right | Logo top-right, user menu top-left |
| Sidebar on the left | Sidebar on the right (visually) |
| Pagination: ← Prev / Next → | Next → / Prev ← (arrows flip direction) |
| Form: label left, field right | Label right, field follows in flow |
| Toast: bottom-right | Bottom-left |
| List item: avatar left, text after | Avatar right, text after (in flow) |

### Testing RTL — Final Checklist

Before delivery, verify in browser:
- [ ] Text reads naturally from right to left
- [ ] Numbers/English mixed text doesn't break (e.g., phone, email displays correctly)
- [ ] Date picker is custom (not native `<input type="date">`)
- [ ] Dropdown menus open in correct direction
- [ ] Icons that have direction (arrows) point the correct way
- [ ] Sidebar appears on visual right
- [ ] Toast notifications appear on visual left
- [ ] Tooltips open without going off-screen
- [ ] Modals/dialogs have proper text alignment
- [ ] Forms align labels and inputs correctly
- [ ] Tables have right-aligned headers for text, end-aligned for actions
- [ ] No physical `pl-` / `pr-` / `ml-` / `mr-` / `left-` / `right-` in layout-critical places — use logical `ps-` / `pe-` / `ms-` / `me-` / `start-` / `end-`

### Bilingual App Support (Hebrew + English)

For apps with a language switcher:

1. Store language preference in user profile or localStorage
2. Set `dir` dynamically on the html element based on language
3. Use logical properties EVERYWHERE
4. Test both directions before delivery

```tsx
// LanguageContext.tsx
const [lang, setLang] = useState<'he' | 'en'>('he')

useEffect(() => {
  document.documentElement.lang = lang
  document.documentElement.dir = lang === 'he' ? 'rtl' : 'ltr'
}, [lang])
```

For full i18n: use `react-i18next` or `next-intl`.

---

