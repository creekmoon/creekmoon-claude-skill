# Anti-Patterns: AI UX Guardrails

Load this in Stage 3 to check every interaction requirement against known
AI-generated UX failures. Flag violations and provide fixes.

Scope note: this checklist covers flow, information architecture, and content
strategy — the levels this skill owns. Visual anti-patterns (gradients, radii,
shadows, typography, decorative styling) are design-execution concerns and are
deliberately NOT covered here; don't expand into them.

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

## Content Strategy Anti-Patterns

### Verbose Onboarding
**Pattern**: "Let's get you started! First, we'll need to collect some
information..."
**Why bad**: Users want to DO, not read. Every word is friction.
**Fix**: Reduce copy by 50%, then 50% again. Show, don't tell.

### Feature Lists Over Benefits
**Pattern**: "Features: Real-time sync, Cloud storage, Collaboration."
**Why bad**: Features don't explain why users should care.
**Fix**: Lead with outcomes. "Never lose your work" beats "Cloud storage."

---

## The Final Test

Before finalizing any interaction requirement, ask:

1. **Does this flow serve the user's job-to-be-done, or fill space?**
2. **If I removed this step/field/screen, would anyone notice?**
3. **Does this flow work the way every lazy default product works, or the way
   this user actually needs?**

If the answers point to "filler" or "default", reconsider.
