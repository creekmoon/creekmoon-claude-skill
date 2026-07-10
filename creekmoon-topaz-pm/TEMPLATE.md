# Tactical PRD Template

Use this template for EVERY PRD output. Every section must be filled.
If a section truly doesn't apply, write "N/A — [reason]" rather than omitting.

```markdown
# [Feature Name] — 战术PRD

> One-sentence: We're building [solution] for [persona] to solve [problem],
> which will [impact].

---

## 1. Problem Statement

### Who has this problem?
[Target persona(s) — 1-2 sentences each]

### What is the problem?
[Clear description of the pain point — 2-4 sentences]

### Why is it painful?
- **User impact**: [Time lost, frustration, blocked goal]
- **Business impact**: [Metric affected, $ cost if quantifiable]

### Evidence
- [Customer quote, analytics data, support ticket count, research finding]
- [At least one piece of evidence — never assume the problem is obvious]

---

## 2. Goals & Success Metrics

### Primary Goal
[The ONE metric this feature must move]

### Success Metrics
| Metric | Current | Target | Measurement Method |
|--------|---------|--------|-------------------|
| [Primary] | [X] | [Y] | [How measured] |
| [Secondary] | [X] | [Y] | [How measured] |
| [Secondary] | [X] | [Y] | [How measured] |

### Guardrail Metrics
[What must NOT get worse — e.g., "page load time < 2s", "conversion rate >= current"]

### Anti-Goals
[What this feature explicitly does NOT try to achieve]

---

## 3. Target Users & Personas

### Primary Persona: [Name]
- **Role**: [Who they are]
- **Tech level**: [Low / Medium / High]
- **Goals**: [What they want]
- **Pain points**: [Current frustrations]
- **Trigger**: [What brings them here]

### Secondary Persona: [Name]
[Same structure]

### Jobs-to-Be-Done
| Priority | Job Statement |
|----------|---------------|
| 1 | When [situation], I want to [motivation], so I can [outcome]. |
| 2 | When [situation], I want to [motivation], so I can [outcome]. |
| 3 | When [situation], I want to [motivation], so I can [outcome]. |

---

## 4. Solution Overview

### High-Level Description
[2-3 paragraphs describing the solution — user-facing, not technical]

### Key Features
- [Feature 1: 1-sentence description]
- [Feature 2: 1-sentence description]
- [Feature 3: 1-sentence description]

### User Flow (Happy Path)
1. [User action]
2. [System response]
3. [User action]
4. [System response]
5. [Success state]

### Alternative Flows
- **Flow A**: [Different path — e.g., returning user]
- **Flow B**: [Different path — e.g., mobile vs desktop]

---

## 5. Interaction Requirements

> Requirements and constraints for whoever designs and builds the UI.
> Describe what the interaction must accomplish — never page layout,
> component placement, or visual styling. Those are design decisions
> made downstream.

### Screen Inventory
[Which screens/views must exist and what job each one does — no layout]

### Information Priorities
[Which information the user needs most, in order of importance. State the
priority, not the position: "sync status must be discoverable at a glance",
not "put the status badge top-right".]

### Interaction Model
- Primary flow: [numbered steps with interaction details]
- Gestures/shortcuts: [if applicable]
- Undo/redo behavior: [if applicable]

### Interaction Constraints
| Constraint | Rationale |
|-----------|-----------|
| [e.g., "Primary task completable in ≤2 clicks"] | [Why this matters] |
| [e.g., "Destructive actions need confirmation or undo"] | [Why] |

### Real Product References
| Decision | Reference Product | What We Learned |
|----------|------------------|-----------------|
| [e.g., "Recovery flow"] | [Product X] | [Why their flow works] |
| [e.g., "Error state behavior"] | [Product Y] | [Why this pattern works] |

### Anti-Pattern Check Results
| Check | Status | Fix Applied |
|-------|--------|-------------|
| No modal hell | ✅/❌ | [If ❌, what was changed] |
| No hover-dependent primary actions | ✅/❌ | |
| No form field bloat | ✅/❌ | |
| No verbose onboarding | ✅/❌ | |
| Loading states defined | ✅/❌ | |
| Error recovery paths exist | ✅/❌ | |

### Nielsen Heuristic Score: __/40
[Score table with each of 10 heuristics rated 0-4]
Overall: [Excellent/Good/Acceptable/Needs Overhaul]
Weak areas: [Which heuristics scored low and why]

---

## 6. State Definitions

### States Overview
| State | Trigger | Visual | User Can |
|-------|---------|--------|----------|
| **Default** | [What triggers this state] | [What user sees] | [Available actions] |
| **Loading** | [Trigger] | [Skeleton/spinner/progressive] | [Can/cannot interact] |
| **Empty** | [Trigger — first run, no data] | [What user sees + CTA] | [Available actions] |
| **Success** | [Trigger] | [Confirmation visual] | [Next steps] |
| **Error** | [Trigger — network, validation, permission] | [Error message + recovery CTA] | [Recovery actions] |
| **Partial Error** | [Trigger — some data loaded, some failed] | [What loaded + error indicator] | [Retry, continue, or report] |

### State Transition Diagram
```
[Default] --(trigger)--> [Loading] --(success)--> [Success] --(auto)--> [Default]
                                     |
                                     --(error)--> [Error] --(retry)--> [Loading]
                                     |
                                     --(empty)--> [Empty] --(CTA action)--> [Loading]
```

---

## 7. Detailed Scenarios

### Scenario 1: [Happy Path Name]
**Given** [precondition]
**When** [user action]
**Then** [expected outcome]
**And** [additional outcomes]

### Scenario 2: [Alternative Path Name]
[Given-When-Then format]

### Scenario 3: [Error Recovery Name]
[Given-When-Then format]

### Scenario 4: [Edge Case Name]
[Given-When-Then format]

---

## 8. Functional Requirements

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-1 | [Specific, testable requirement] | P0/P1/P2 | [Edge cases, constraints] |
| FR-2 | ... | ... | ... |

### Non-Functional Requirements
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-1 | [Performance, security, accessibility] | [Measurable target] |

---

## 9. Component Spec

| Component | Type | Description | Linked Scenarios |
|-----------|------|-------------|-----------------|
| [Name] | [Form/Layout/Action/Display/Nav/Modal] | What it does | S1, S2 |
| ... | ... | ... | ... |

### Data Model (TypeScript)
```typescript
interface [ModelName] {
  id: string;
  // ... fields with comments
}
```

### API Surface
| Method | Path | Description | Auth | Response |
|--------|------|-------------|------|----------|
| GET | /api/... | ... | Yes | {...} |

---

## 10. Scope

### In Scope
- [Specific deliverable 1]
- [Specific deliverable 2]

### Out of Scope
| Item | Reason |
|------|--------|
| [Not building X] | [Why — complexity, validate simpler version first, etc.] |
| [Not building Y] | [Why] |

### Future Considerations
- [Idea for v2, with conditions for building]

---

## 11. Dependencies & Risks

### Dependencies
| Dependency | Owner | Status | Impact if Delayed |
|------------|-------|--------|-------------------|
| [What we need] | [Who] | [Status] | [Consequence] |

### Risks & Mitigations
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| [What could go wrong] | High/Med/Low | High/Med/Low | [What we'll do] |

---

## 12. Open Questions

| Question | Impact if Unresolved | Suggested Resolution |
|----------|---------------------|---------------------|
| [Strategic or technical unknown] | [What happens if we guess wrong] | [How to resolve] |

---

## 13. Rollout Plan

### Milestones
- [ ] [Phase — e.g., Design complete]
- [ ] [Phase — e.g., MVP implementation]
- [ ] [Phase — e.g., QA & launch]

### Rollback Plan
[How to revert if metrics don't meet expectations — feature flag, gradual rollout, etc.]

---

## 14. Quality Review

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

---

## 15. Rationale

### Why These Decisions Were Made
[For each major UX decision, explain the reasoning. This section is critical —
it shows product thinking, not just feature listing. Reference real products,
data, or principles.]

### Key Tradeoffs
| Decision | Option A | Option B | Chose | Why |
|----------|----------|----------|-------|-----|
| [e.g., Modal vs inline] | [A] | [B] | [A/B] | [Reasoning] |

---

*PRD generated by product-manager skill. Review Rationale and Open Questions
before approving. All decisions should be grounded in user impact.*
```
