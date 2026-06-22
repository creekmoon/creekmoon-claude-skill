# Anti-Patterns: AI UX Guardrails

Load this in Stage 3 to check every interaction decision against known
AI-generated UX failures. Flag violations and provide fixes.

## Visual Anti-Patterns

### The "AI Gradient" Problem
**Pattern**: Purple-to-blue gradients, excessive blur effects, floating orbs.
**Why bad**: Signals "AI made this instantly." No brand differentiation.
**Fix**: Use brand colors. If no brand exists, choose ONE distinctive accent
color. Restraint over decoration.

### Rounded Corner Overload
**Pattern**: `border-radius: 24px` on everything.
**Why bad**: Loses visual hierarchy. Everything feels the same weight.
**Fix**: Vary intentionally. Sharp corners = importance/action. Soft corners
= secondary/containers.

### Emoji Pollution
**Pattern**: Bullet points as emojis, decorative emojis in headers.
**Why bad**: Feels unserious, cluttered.
**Fix**: Emojis only for functional meaning (status indicators, reactions).
Never decorative. In UI, use SVG icons from a consistent library
(Heroicons/Lucide).

### Generic Hero Sections
**Pattern**: "Welcome to [Product]" + gradient + generic illustration.
**Why bad**: Zero differentiation. Users have seen this 10,000 times.
**Fix**: Lead with value proposition. Show the product. Be specific.

### Stock Illustration Syndrome
**Pattern**: Flat vector illustrations of "diverse people collaborating."
**Why bad**: Generic, forgettable, builds no brand.
**Fix**: Product screenshots, custom imagery, or no imagery at all.

---

## Copy Anti-Patterns

### Verbose Onboarding
**Pattern**: "Let's get you started! First, we'll need to collect some
information..."
**Why bad**: Users want to DO, not read. Every word is friction.
**Fix**: Reduce copy by 50%, then 50% again. Show, don't tell.

### Exclamation Point Abuse
**Pattern**: "Welcome! You're all set! Here's what's next!"
**Why bad**: Forced enthusiasm feels fake. Tiring to read.
**Fix**: Reserve exclamation points for genuine moments of delight.

### Corporate Jargon
**Pattern**: "Leverage our robust solution to optimize your workflow."
**Why bad**: Meaningless. Users tune it out.
**Fix**: Speak like a human. "Get more done" beats "optimize your workflow."

### Hedging Language
**Pattern**: "This might help you..." "You may want to consider..."
**Why bad**: Lacks confidence. Users want guidance.
**Fix**: Be direct. "Do this" not "You might want to do this."

### Feature Lists Over Benefits
**Pattern**: "Features: Real-time sync, Cloud storage, Collaboration."
**Why bad**: Features don't explain why users should care.
**Fix**: Lead with outcomes. "Never lose your work" beats "Cloud storage."

---

## Interaction Anti-Patterns

### Modal Hell
**Pattern**: Modals for everything — welcome, tooltips, confirmation, upsells.
**Why bad**: Interrupts flow. Users click through without reading.
**Fix**: Inline guidance. Modals ONLY for critical irreversible decisions
(delete account, confirm payment).

### Hover-Dependent UI
**Pattern**: Important actions only visible on hover.
**Why bad**: Invisible = nonexistent for most users. Fails on mobile.
**Fix**: Always-visible primary actions. Hover for secondary enhancements.

### Mystery Meat Navigation
**Pattern**: Icon-only navigation without labels.
**Why bad**: Users guess meanings. Increases cognitive load.
**Fix**: Labels on ALL navigation items. Icons supplement, never replace.

### Infinite Scroll Without Orientation
**Pattern**: Endless content with no sense of progress or location.
**Why bad**: Users feel lost. Can't return to specific items.
**Fix**: Pagination, section markers, or "jump to" controls.

### Form Field Bloat
**Pattern**: Asking for 15 fields when 3 would suffice.
**Why bad**: Each field = friction. Drop-off increases linearly.
**Fix**: Ask only what's immediately necessary. Progressive disclosure for
the rest.

---

## Architecture Anti-Patterns

### Everything-on-Dashboard
**Pattern**: Dashboard showing every possible metric and action.
**Why bad**: Overwhelming. Nothing stands out when everything does.
**Fix**: Curate ruthlessly. What does user need NOW? Hide the rest.

### Settings Sprawl
**Pattern**: Settings page with 50+ options in a flat list.
**Why bad**: Users can't find what they need.
**Fix**: Group logically. Progressive disclosure. Smart defaults.

### Feature Dumping
**Pattern**: Every feature accessible from every screen.
**Why bad**: Increases cognitive load. Dilutes focus.
**Fix**: Context-aware features. Show what's relevant to current task.

### Notification Overload
**Pattern**: Notifications for every possible event.
**Why bad**: Users disable all notifications. Signal becomes noise.
**Fix**: Default to minimal. Let users opt into more.

### Onboarding That Teaches Everything
**Pattern**: 10-step tour covering all features.
**Why bad**: Users retain nothing. Delays the "aha" moment.
**Fix**: Get users to value immediately. Teach features when relevant
(progressive onboarding).

---

## The Final Test

Before shipping any interaction, ask:

1. **Would a human designer at Apple/IDEO do this?**
2. **Does this serve the user or fill space?**
3. **If I removed this element, would anyone notice?**
4. **Does this look like every other AI-generated product?**

If any answer is "no" or "yes" (for #3 and #4), reconsider.
