# PRD Quality Checklist

Run this checklist automatically after generating every PRD. Append results
to the Quality Review section.

---

## 1. Tech Lead Lens 🔧

Evaluate from implementation difficulty, system performance, security:

- [ ] **Concurrency**: Are race conditions addressed? (double-submit,
  simultaneous edit, multi-tab)
- [ ] **Idempotency**: Are destructive actions safe to retry?
  (payment, delete, create)
- [ ] **Error recovery**: What happens after network disconnect, payment
  interrupt, timeout?
- [ ] **Data consistency**: Distributed state — how is consistency maintained?
- [ ] **Security**: Auth, injection (SQL/XSS), CSRF, rate limiting
- [ ] **Performance**: Large data handling, query optimization, caching
- [ ] **Scalability**: Will this work at 10x user volume?

### Common Tech Red Flags
| Red Flag | What to Check |
|----------|--------------|
| "Just add a field" | Migration plan? Backfill? Rollback? |
| "Real-time sync" | Conflict resolution? Offline handling? |
| "Upload any file" | File type validation? Size limit? Virus scan? |
| "Delete permanently" | Soft delete? Audit log? Undo window? |
| "Search everything" | Index strategy? Pagination? Performance at scale? |

---

## 2. Picky User Lens 👤

Evaluate from operation convenience, flow rationality:

- [ ] **Click count**: Can the primary task be completed in minimum steps?
- [ ] **Form fields**: Is every field justified? Can any be removed or
  auto-filled?
- [ ] **Error messages**: Are they specific, actionable, in human language?
- [ ] **Loading states**: Does user know the system is working? Is progress
  visible?
- [ ] **Undo/redo**: Can users recover from mistakes? (especially destructive)
- [ ] **Empty states**: First-run experience — is it guided or abandoned?
- [ ] **Mobile**: Does the flow work on a small screen with one thumb?

### Common UX Red Flags
| Red Flag | What to Check |
|----------|--------------|
| "Click here to..." | Is the action self-evident without reading? |
| "Please enter..." | Can any field be pre-filled or inferred? |
| Multiple modals stacked | Can this be inline or a single flow? |
| "Are you sure?" confirmation | Is the action truly destructive? Can it be undone instead? |
| Hidden navigation | Is discoverability acceptable for the target user? |

---

## 3. Ops Lead Lens 📊

Evaluate from data analytics, marketing promotion:

- [ ] **Event tracking**: Are key behaviors instrumented with analytics events?
- [ ] **Conversion funnel**: Are funnel entry/exit points defined and trackable?
- [ ] **User segmentation**: Can users be segmented by feature usage?
- [ ] **Admin tools**: Does ops have config/control without engineering?
- [ ] **Data export**: Can reports be generated for business review?

### Analytics Event Checklist
Ensure these standard events are defined:

| Event | When to Fire | Properties |
|-------|-------------|------------|
| `[feature]_viewed` | User sees the feature/page | source, context |
| `[feature]_started` | User begins interaction | entry_point |
| `[feature]_completed` | Primary action succeeds | duration, method |
| `[feature]_failed` | Primary action fails | error_type, error_message |
| `[feature]_dismissed` | User exits without completing | reason (if known) |

---

## 4. QA Engineer Lens 🧪

Evaluate from exception scenarios, boundary coverage:

- [ ] **Boundary values**: Max/min/empty/null/special characters/emoji/very long
- [ ] **Concurrent operations**: Double-click, multi-tab, multi-device
- [ ] **Network failure**: Offline, slow 3G, timeout, intermittent
- [ ] **Device compatibility**: Different screens, browsers, OS versions
- [ ] **Permission boundaries**: Unauthenticated, partial auth, role-based access
- [ ] **Data volume**: Empty list, 1 item, 1000 items, 1M items
- [ ] **Session expiry**: What happens mid-action when session dies?

### Test Scenario Matrix

| Scenario | Expected Behavior |
|----------|-------------------|
| User performs primary action successfully | [Expected success state] |
| User performs action with invalid input | [Validation error, inline] |
| User performs action while offline | [Graceful degradation] |
| User double-clicks primary action | [Idempotent — only one execution] |
| User navigates away mid-action | [State saved? Or discarded?] |
| User returns after session expiry | [Redirect to login, return after] |
| User accesses from mobile browser | [Responsive, touch-friendly] |
| User uses keyboard only (no mouse) | [Full keyboard navigation] |
| Screen reader user accesses feature | [ARIA labels, semantic HTML] |
| Data returns empty | [Empty state with CTA] |
| Data returns 10,000 items | [Pagination/virtual scroll] |
| API returns 500 error | [User-friendly error + retry] |
| API returns malformed data | [Graceful handling, no crash] |

---

## Output Format

Append this section to every PRD:

```markdown
## Quality Review

### Tech Lead 🔧
- [ ] Concurrency/race conditions: [PASS / FLAG — details]
- [ ] Idempotency: [PASS / FLAG]
- [ ] Error recovery: [PASS / FLAG]
- [ ] Performance: [PASS / FLAG]
- [ ] Security: [PASS / FLAG]

### Picky User 👤
- [ ] Click efficiency: [PASS / FLAG]
- [ ] Form justification: [PASS / FLAG]
- [ ] Error message quality: [PASS / FLAG]
- [ ] Undo/redo: [PASS / FLAG]
- [ ] Loading clarity: [PASS / FLAG]

### Ops Lead 📊
- [ ] Tracking events: [PASS / FLAG]
- [ ] Conversion points: [PASS / FLAG]
- [ ] Admin tools: [PASS / FLAG]

### QA Engineer 🧪
- [ ] Boundary values: [PASS / FLAG]
- [ ] Concurrent ops: [PASS / FLAG]
- [ ] Network failures: [PASS / FLAG]
- [ ] Cross-device: [PASS / FLAG]
- [ ] Permission boundaries: [PASS / FLAG]

### UX Heuristic 🎨
- Nielsen score: __/40 — [Rating]
- Anti-Pattern violations: [None / N — list]
- Accessibility: [WCAG AA / Needs work]
```
