# Hebrew / RTL Patterns

Load for any Hebrew or RTL interface (the default for Israeli-facing UI). RTL done wrong is instantly obvious
to native users; these rules get it right.

## Initial setup
- `dir="rtl"` and `lang="he"` on `<html>`.
- Font: **Heebo** or **Assistant** (load the Hebrew weights you use).
- Tailwind: rely on **logical properties** so layout flips automatically with `dir`.

## Logical properties (critical)
Never use physical direction utilities in RTL layouts — use logical ones so they mirror correctly:
| Use (logical) | Not (physical) |
|---|---|
| `ps-*` / `pe-*` (padding-inline-start/end) | `pl-*` / `pr-*` |
| `ms-*` / `me-*` (margin-inline-start/end) | `ml-*` / `mr-*` |
| `start-*` / `end-*` | `left-*` / `right-*` |
| `text-start` / `text-end` | `text-left` / `text-right` |
| `border-s` / `border-e` | `border-l` / `border-r` |
Flexbox/grid order also flips under `dir="rtl"` — verify visually.

## Inputs that must stay LTR even in RTL
Force `dir="ltr"` (and usually `text-align` accordingly) on fields whose content is inherently LTR:
- Phone numbers, email addresses, URLs, and often numeric/currency fields.
Otherwise digits and `@`/`.`/`+` render in a confusing order.

## Component gotchas
- **Native date input** `<input type="date">` is broken/awkward in RTL — use a custom Calendar component
  (e.g. shadcn/ui Calendar + Popover) instead.
- **Dropdown/Menu content:** set direction via `style={{ direction: "rtl" }}` on the content (the `dir` prop
  alone can misbehave in some libs).
- **Icons:** directional icons (arrows, chevrons, back/forward) should mirror; neutral icons stay as-is.
  A "back" arrow points right in RTL.
- **Numbers & dates:** display Hebrew/Israeli formats; numbers themselves stay LTR within RTL text.
- **Mixed content:** Hebrew text with embedded English/numbers needs correct bidi handling; wrap inherently-LTR
  spans with `dir="ltr"`.

## Common Israeli app features
- Israeli phone formatting/validation; Israeli ID (ת.ז.) validation where relevant; ILS currency and
  **VAT (מע"מ)** handling on prices/invoices; Hebrew date display; right-aligned forms and tables.

## Layout mental model
In RTL, "start" = right and "end" = left. Reading flows right-to-left; the primary nav/sidebar typically sits
on the right; primary actions go on the start (right) side. Think in start/end, not left/right.

## Bilingual (Hebrew + English)
- Switch `dir` and `lang` with the active locale; keep all spacing logical so one set of classes works for
  both directions.
- Keep copy in a translation layer; don't hardcode strings; mirror layout, not content meaning.

## RTL final checklist
- `dir="rtl"` + `lang="he"` on html; font is Heebo/Assistant.
- No physical spacing utilities in layout-critical places (logical only).
- Phone/email/URL inputs `dir="ltr"`; custom Calendar instead of native date input.
- Dropdown content uses `style={{ direction: "rtl" }}`.
- Directional icons mirror; numbers/dates display correctly; no broken bidi in mixed strings.
