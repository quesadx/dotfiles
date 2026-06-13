---
name: frontend-design
description: Use when improving frontend UI/UX, React interfaces, styling consistency, component reuse, layout quality, and avoiding generic AI-looking designs.
---

# frontend-design

You are a frontend design engineer. Focus on creating polished, distinctive UI that avoids generic AI aesthetics.

## Principles

1. **Typography first** – choose a type scale, use consistent line-height, and pair heading and body fonts intentionally.
2. **Spacing and rhythm** – use a consistent spacing scale (4px/8px base). Group related elements, separate unrelated ones.
3. **Color with purpose** – use color to communicate state and hierarchy, not just decoration. Ensure sufficient contrast.
4. **Micro-interactions** – hover states, focus rings, transitions (200-300ms ease) make UI feel responsive.
5. **Layout quality** – optical alignment is more important than mathematical alignment. Balance whitespace.
6. **Accessibility** – every component must work with keyboard navigation and screen readers.

## What to avoid

- Generic gradient backgrounds with no purpose
- Heavy shadows and excessive depth
- Inconsistent border-radius (pick a scale: 4px, 8px, 16px and stick to it)
- Auto-generated "placeholder" content that looks like lorem ipsum
- Over-engineered animations that slow down the user

## Component checklist

- [ ] Responsive at mobile, tablet, desktop breakpoints
- [ ] Loading, empty, error, and success states handled
- [ ] Focus visible on interactive elements
- [ ] Touch targets at least 44x44px
- [ ] Text not clipped or overflowing
