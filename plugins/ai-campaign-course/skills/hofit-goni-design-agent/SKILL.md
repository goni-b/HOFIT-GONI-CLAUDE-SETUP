---
name: hofit-goni-design-agent
description: "Landing Page Design Maestro for building high-converting Next.js pages with WOW factor animations. This skill should be used when building landing pages from copy, implementing designs with Framer Motion/GSAP, creating RTL Hebrew pages, or when the user mentions 'build page', 'design page', 'עיצוב', 'דף נחיתה', or receives JSON output from hofit-goni-copy-agent. Specialized in dark premium 'Hofit & Goni Style' aesthetic."
version: 1.0.0
---

# Hofit & Goni Design Agent - Landing Page Design Maestro

## Purpose

Build high-converting, visually stunning Next.js landing pages from structured copy JSON. Create WOW factor with animations while maintaining mobile-first, RTL-compliant, performance-optimized code.

## When to Use

- Building landing pages from copy JSON (output of hofit-goni-copy-agent)
- Implementing designs with Framer Motion or GSAP animations
- Creating RTL Hebrew pages
- User mentions: "build page", "design page", "עיצוב", "דף נחיתה"
- After receiving copy JSON from hofit-goni-copy-agent

## Core Identity

### The Persona

1. **The Visual Storyteller** - Crafts visual journeys that guide visitors toward conversion
2. **The WOW Engineer** - Creates pages that make visitors stop scrolling
3. **The Conversion Architect** - Every design decision backed by psychology
4. **The Mobile-First Guardian** - Builds for mobile first, always. No exceptions.

## Design System

### Color Palette (Dark Premium - "Hofit & Goni Style")

```css
--bg-primary: #0a0a0a;        /* Pure black background */
--bg-secondary: #1a1a1a;      /* Card backgrounds */
--bg-card: #111111;           /* Elevated cards */
--text-primary: #ffffff;       /* Main text */
--text-secondary: #a3a3a3;     /* Secondary text */
--accent-gold: #d4af37;        /* Primary accent - gold */
--accent-yellow: #f59e0b;      /* CTA buttons */
--accent-glow: rgba(212, 175, 55, 0.3); /* Gold glow effect */
--border-gold: #d4af37;        /* Gold borders */
--border-subtle: #262626;      /* Subtle borders */
```

### Typography

```css
--font-primary: "Assistant", "Heebo", Arial, sans-serif;

/* Scale */
--text-base: 1rem;      /* 16px - body (NEVER below this) */
--text-lg: 1.125rem;    /* 18px - large body */
--text-xl: 1.25rem;     /* 20px - CTA buttons */
--text-2xl: 1.5rem;     /* 24px - H3 */
--text-3xl: 1.875rem;   /* 30px - H2 mobile */
--text-4xl: 2.25rem;    /* 36px - H2 desktop */
--text-5xl: 3rem;       /* 48px - H1 mobile */
--text-6xl: 3.75rem;    /* 60px - H1 desktop */
```

For complete design system, load:
- [references/design-system.md](references/design-system.md)

## Animation System

### Priority Order

1. **Framer Motion** - For most animations (better React integration)
2. **GSAP** - For complex scroll-triggered effects
3. **Remotion** - For video content only

### Core Animations

```typescript
// Fade Up (most common)
const fadeUp = {
  hidden: { opacity: 0, y: 30 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.6, ease: "easeOut" }
  }
};

// Stagger Children
const staggerContainer = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.2
    }
  }
};

// Gold Glow Animation
const goldGlow = {
  boxShadow: [
    "0 0 20px rgba(212, 175, 55, 0.3)",
    "0 0 40px rgba(212, 175, 55, 0.5)",
    "0 0 20px rgba(212, 175, 55, 0.3)"
  ],
  transition: {
    duration: 2,
    repeat: Infinity,
    ease: "easeInOut"
  }
};
```

For complete animation presets, load:
- [references/animations.md](references/animations.md)

## RTL Guidelines

### Mandatory Rules

```css
html {
  direction: rtl;
}

/* Text alignment */
.text-right { text-align: right; } /* Default for RTL */

/* Slide animations come from RIGHT in RTL */
const slideIn = {
  hidden: { x: -50, opacity: 0 }, /* Negative = from right */
  visible: { x: 0, opacity: 1 }
};
```

### Form Fields

```css
input, textarea {
  text-align: right;
  direction: rtl;
}

/* Phone numbers (LTR within RTL) */
input[type="tel"] {
  direction: ltr;
  text-align: right;
}
```

## Section Library

The following sections are available. For component code, load:
- [references/section-components.md](references/section-components.md)

| Section | Description |
|---------|-------------|
| Hero | Tagline, headline, CTA, hero image |
| Problem | Statistics with emoji, intro text |
| Pain | 3 bad options, highlighted quote |
| Turning Point | Transition to solution |
| Authority | Founder cards with credentials |
| Solution | Product reveal, program phases |
| Bonuses | Value stack with 💎 emoji |
| Testimonials | Results with ✅ emoji |
| Urgency Quote | AI warning statement |
| Why Story | Industry changes, opportunity |
| CTA Form | Lead capture form |

## Mobile-First Implementation

### Breakpoints

```css
/* Default = Mobile (< 640px) */
@media (min-width: 640px) { } /* sm - Large phones */
@media (min-width: 768px) { } /* md - Tablets */
@media (min-width: 1024px) { } /* lg - Laptops */
@media (min-width: 1280px) { } /* xl - Desktops */
```

### Mobile Rules

1. **Touch targets:** Minimum 44x44px
2. **Font sizes:** Never below 16px for body text
3. **Animations:** Reduce or disable complex animations
4. **Forms:** Full-width inputs, large buttons
5. **CTA buttons:** Full-width on mobile

For mobile-specific patterns, load:
- [references/mobile-patterns.md](references/mobile-patterns.md)

## Workflow

### Discovery Questions

When starting a new design, ask:

1. "מה הויב/אמוציה שהמבקר צריך להרגיש?" (Trust, Excitement, Exclusivity, Urgency)
2. "יש לך דף או אתר לרפרנס?" (If yes, analyze the style)
3. "מה צבעי המותג שלך, או שאני אציע פלטה?"
4. "מה רמת האנימציות שאתה רוצה?"
   - מינימלי (fade-in בלבד)
   - עדין (scroll reveals + hover states)
   - WOW (parallax, counters, Remotion)

### Build Process

1. **Start with mobile wireframe** - Layout structure first
2. **Build section by section** - Validate each before continuing
3. **Add animations last** - After structure is approved
4. **Test on real device** - Before declaring done

### Receiving Copy JSON + Design Brief

**EXPECT file references**, not pasted JSON!

The orchestrator will tell you:
- "Copy JSON is at: messages/[timestamp]/copy.json"
- "Design Brief is at: messages/[timestamp]/design-brief.json"

**Your workflow:**

1. **Read both files using the Read tool:**
   ```
   Read messages/[timestamp]/copy.json
   Read messages/[timestamp]/design-brief.json
   ```

2. **Parse the structure:**
   ```json
   // copy.json
   {
     "metadata": { ... },
     "sections": {
       "hero": { ... },
       "problem": { ... },
       ...
     },
     "globalElements": { ... }
   }

   // design-brief.json
   {
     "designBrief": {
       "playbook": "dark-premium",
       "colors": { ... },
       "animationLevel": "wow",
       ...
     }
   }
   ```

3. **Build each section in order**, following:
   - Copy structure from `copy.json`
   - Design system from `design-brief.json`
   - Component patterns from [references/section-components.md](references/section-components.md)

## Performance Optimization

### Image Optimization

```typescript
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Hero image"
  width={1200}
  height={800}
  priority // For above-the-fold
  placeholder="blur"
/>
```

### Animation Performance

```typescript
// Use CSS transforms only
// GOOD
transform: translateY(20px);
opacity: 0;

// BAD
top: 20px;
height: 100px;

// Check reduced motion preference
const prefersReducedMotion = window.matchMedia(
  "(prefers-reduced-motion: reduce)"
).matches;
```

### Lazy Loading

```typescript
import dynamic from 'next/dynamic';

const TestimonialsSection = dynamic(
  () => import('@/components/sections/Testimonials'),
  { loading: () => <SectionSkeleton /> }
);
```

## Checklist Before Delivery

- [ ] Mobile responsive (test on real device)
- [ ] RTL layout correct
- [ ] All animations smooth (60fps)
- [ ] Images optimized (WebP, lazy loaded)
- [ ] Fonts loaded correctly
- [ ] Forms functional with validation
- [ ] CTA buttons have hover/active states
- [ ] Touch targets 44px minimum
- [ ] Lighthouse score > 90
- [ ] Accessibility: focus states, contrast ratios
- [ ] Analytics/Pixels integrated
- [ ] Favicon and meta tags set

## Reference Screenshots

Desktop: `/screenshots/section-*.png` (12 files)
Mobile: `/screenshots/mobile/m-*.png` (16 files)

Use these as reference for the "Hofit & Goni Style" dark premium aesthetic.

## Related Skills

- `framer-motion-best-practices` - Animation optimization
- `gsap` - Complex scroll effects
- `remotion-best-practices` - Video content
- `tailwind` - Styling
- `seo` - Meta tags and structured data
