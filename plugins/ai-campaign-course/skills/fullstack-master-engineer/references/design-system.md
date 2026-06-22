# Design System — UI/UX Standards

Load for any UI work. A generic AI-looking interface is a failure state; every screen should look intentional,
polished, and modern (think Linear/Vercel/Stripe). Default component library: shadcn/ui.

## Visual direction by project type
- **B2B / internal / SaaS** → clean, dense, functional (Linear-like): neutral palette, one accent, strong
  typography hierarchy.
- **Marketing / landing** → bold, spacious, high-contrast hero, generous whitespace.
- **Finance / data** → restrained, trustworthy, dark-friendly, precise alignment, numbers tabular-aligned.
- **Consumer / coaching / education** → warmer palette, rounded, approachable, imagery-forward.

## Typography
- One display/heading font + one body font max. For Hebrew: **Heebo** or **Assistant**. For English: Inter.
- A clear scale (e.g. 12/14/16/20/24/32/40); don't use random sizes. Body ≥16px. Generous line-height (~1.5)
  for body, tighter for headings.
- Limit weights (e.g. 400/500/600/700). Establish hierarchy with size+weight, not color alone.

## Color
- A small palette: neutral scale (background/surface/border/text) + one primary accent + semantic colors
  (success/warning/destructive). Define them as theme tokens and use them directly (`bg-primary`,
  `text-muted-foreground`) — don't wrap in ad-hoc `var()`.
- Ensure contrast ≥4.5:1 for body text in both themes. Avoid low-contrast gray-on-white body copy.

## Layout
- Use a consistent spacing scale (4/8/12/16/24/32…), not random pixel values.
- Generous whitespace; don't cram. Max content widths for readability (~65–75ch for text).
- Floating/fixed navbars need breathing room (`top-4 left-4 right-4`, not stuck to `top-0`); never hide
  content behind a fixed bar.

## Components
- shadcn/ui for buttons, inputs, dialogs, forms, tables, toasts, dropdowns, etc. — accessible by default,
  fully restyleable. Install only what you use.
- Consistent component states: default, hover, focus, active, disabled, loading.
- Tables: sticky headers, zebra or clear row separation, right-aligned numbers, empty state.
- Forms: labels on every input, inline validation, clear error text, a submit button that disables + shows
  progress during async.

## Icons
- Use an SVG icon set (Lucide React / Heroicons) consistently — never emojis as UI icons.
- Brand/logo marks from Simple Icons; verify they exist before using.

## Interaction
- Every clickable element: `cursor-pointer` + a clear hover state.
- Transitions 150–300ms; visible focus rings for keyboard nav; submit buttons disabled while loading.
- Avoid `scale-105` on cards (causes layout shift) — use shadow/border/background change instead.

## Dark mode (if supported)
- Test both themes before delivery. Borders visible in both; glass/transparent elements visible in light mode
  (`bg-white/80`+, not `bg-white/10`). No light-mode text below 4.5:1.

## Mobile responsiveness (non-negotiable)
- Design mobile-first; test at 375px, 768px, 1024px, 1440px. No horizontal scroll on mobile.
- Tap targets ≥44px; stacked layouts on small screens; readable without zoom.

## Accessibility
- Images have alt text; inputs have labels; color is never the only signal; respect `prefers-reduced-motion`;
  semantic HTML and ARIA where needed; keyboard-navigable.

## Design anti-patterns
Default browser styles (Times New Roman, blue underlined links); emojis as icons; cramped layouts; invisible
glass cards in light mode; no hover states; inconsistent spacing; navbars glued to the edge; `scale-105` on
hover; low-contrast body text.
