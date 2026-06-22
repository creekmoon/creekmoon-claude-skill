---
name: creekmoon-topaz-pm
version: 1.0.0
description: 产品经理战术 PRD 与交互方案技能。基于 JTBD、Persona、场景补全、交互模式和原型指导，把一句话需求展开为可落地的功能 PRD。适用于用户提出写 PRD、设计功能、规划登录/看板/引导等产品模块、补充用户故事、原型或交互方案的场景；不用于纯代码实现、项目排期或营销文案。
---

# Product Manager — Integrated Tactical PRD Skill

**Philosophy:** We don't invent from scratch. We stand on giants — 7
battle-tested open-source PM/UX skills compressed into one pipeline that
outputs a complete, developer-ready tactical PRD from a one-line requirement.

**Sources integrated:** FinStep PRD Writer, product-on-purpose deliver-prd,
Dean Peters PRD Development + Feature Investment Advisor, neo-user-journey UX
patterns, design-ref-skill real-world references, johnnychauvet JTBD PRD,
Digidai pushback review.

---

## 4-Stage Pipeline

Every request flows through these 4 stages automatically. No questions asked,
no user interaction needed until the final strategic review.

```
Input: One-line requirement (e.g., "做一个用户登录模块")
                │
                ▼
┌──────────────────────────────────────────────────────────────┐
│ Stage 1: Requirement Structuring (auto)                       │
│   → JTBD extraction → Persona definition → Goals              │
│   References: FinStep req extraction + Dean Peters persona     │
└──────────────────────────────────────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────────────────────┐
│ Stage 2: Boundary & Scenario Completion (auto-infer)          │
│   → Main flow → Branches → Error states → Empty states        │
│   → Edge cases → Permission boundaries                        │
│   → Pushback check: solution smuggling? coverage gaps?        │
│   References: Dean Peters edge cases + Digidai pushback       │
└──────────────────────────────────────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────────────────────┐
│ Stage 3: Interaction Decision (auto-match)                    │
│   → Page structure → Info hierarchy → Button placement        │
│   → Operation paths → State transitions                       │
│   → Anti-Pattern guardrail check                              │
│   → Nielsen heuristic score (0-40)                            │
│   → Reference 1-2 real products as design rationale           │
│   References: neo-user-journey + design-ref-skill             │
└──────────────────────────────────────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────────────────────┐
│ Stage 4: PRD + Prototype Output (enforced template)           │
│   → Full PRD per TEMPLATE.md                                  │
│   → Page flow description OR single-file HTML prototype spec  │
│   → Quality check: 4-role review                              │
│   References: product-on-purpose 3-file + FinStep prototype   │
└──────────────────────────────────────────────────────────────┘
                │
                ▼
Output: Complete tactical PRD + UX decisions + prototype guide

You (strategic layer): Review Rationale + Open Questions, approve or adjust.
```

---

## Stage 1: Requirement Structuring

Extract from the user's one-line input:

### 1.1 JTBD Extraction

Frame each job as:
> "When [situation], I want to [motivation], so I can [expected outcome]."

Identify 2-5 core jobs. Prioritize by frequency and importance.

### 1.2 Persona Definition

Define 2-3 personas minimum:

| Field | Description |
|-------|-------------|
| Name | Archetype name (e.g., "Hurried Return User") |
| Role | Who they are |
| Tech level | Low / Medium / High |
| Goals | What they want to achieve |
| Pain points | Current frustrations |
| Trigger | What brings them to this feature |

### 1.3 Goals & Constraints

- **Primary goal**: The one metric this feature must move
- **Success metrics**: 1-3 measurable signals (with baseline → target if known)
- **Guardrail metrics**: What must NOT get worse
- **Anti-goals**: What this feature explicitly does NOT include
- **Technical constraints**: Platform, auth, offline, accessibility, performance

---

## Stage 2: Boundary & Scenario Completion

### 2.1 Flow Decomposition

Map ALL paths systematically:

**Main flow (happy path)**
- Numbered steps from entry to success

**Alternative flows**
- Different entry points, different choices, different user types

**Error states** (MUST have — developers need these)
- Network failure, validation failure, permission denied, timeout
- Each error: what the user sees, what they can do next

**Empty states** (MUST have — first-run experience)
- No data yet, no permissions, no results

**Loading states**
- Skeleton, spinner, or progressive reveal

**Edge cases**
- Extreme inputs (very long name, special characters, emoji)
- Concurrent operations (double-click, multi-tab)
- Race conditions
- Accessibility scenarios (screen reader, keyboard-only, high contrast)

### 2.2 Pushback Self-Check

Before proceeding to Stage 3, challenge the requirement:

```
PUSHBACK CHECKLIST:
□ Solution smuggling: Is the user describing a solution instead of a problem?
  → If yes, reframe to JTBD and discard the prescriptive solution.
□ Role coverage: Have we considered ALL personas, not just the primary?
□ Metric missing: Is there a measurable success criterion?
□ Scope creep: Is there anything implied but not explicitly stated?
□ Assumption risk: What must be true for this feature to succeed?
□ Rollback: What happens if this feature fails after launch?
```

If any check fails, document as **Open Question** in the final PRD.

---

## Stage 3: Interaction Decision

### 3.1 Core Decision Rules

Apply these in order:

**Step 1: Match to Pattern Library**
- Search `references/pattern-library.md` for relevant UX patterns
- Choose the pattern with the best success data for this scenario
- Document the choice rationale

**Step 2: Anti-Pattern Guardrail Check**
- Run `references/anti-patterns.md` checklist
- Flag any violations found
- Provide specific fix for each violation

**Step 3: Nielsen Heuristic Scoring**

Score the proposed interaction against 10 heuristics (0-4 each):

| # | Heuristic | Score |
|---|-----------|-------|
| 1 | Visibility of system status | _/4 |
| 2 | Match between system and real world | _/4 |
| 3 | User control and freedom | _/4 |
| 4 | Consistency and standards | _/4 |
| 5 | Error prevention | _/4 |
| 6 | Recognition rather than recall | _/4 |
| 7 | Flexibility and efficiency of use | _/4 |
| 8 | Aesthetic and minimalist design | _/4 |
| 9 | Help users recognize, diagnose, recover from errors | _/4 |
| 10 | Help and documentation | _/4 |
| **Total** | | **_/40** |

Rating: 36-40=Excellent, 28-35=Good, 20-27=Acceptable, <20=Needs overhaul

**Step 4: Real-World Reference Matching**

Automatically match 1-2 real products as design rationale:
- Search for products with similar features/patterns
- Reference specific decisions: "Why does [Product X] put the button here?"
- Document in PRD's **Rationale** section

### 3.2 Output of Stage 3

- Page structure and information hierarchy
- Component placement and rationale
- Primary interaction flows (numbered)
- State transition descriptions
- Anti-Pattern violations found and fixes applied
- Nielsen score and weak areas
- Real product references used

---

## Stage 4: PRD Output

Use `references/TEMPLATE.md` as the enforced output structure. Every section
must be filled. If a section truly doesn't apply, write "N/A — [reason]" rather
than omitting it.

### Output Files

| File | Content |
|------|---------|
| `PRD.md` | Complete tactical PRD (per TEMPLATE.md) |
| `prototype.html` | Single-file HTML prototype spec (optional, per user request) |

### Quality Checklist (4-Role Review)

After generating the PRD, run this self-check automatically and append a
**Quality Review** section:

**Tech Lead Lens** 🔧
- [ ] Concurrency and race conditions addressed?
- [ ] Idempotency for destructive actions?
- [ ] Error recovery paths defined?
- [ ] Performance targets stated?
- [ ] Security considerations (auth, injection, XSS)?

**Picky User Lens** 👤
- [ ] Minimum clicks to complete primary task?
- [ ] Form fields justified (no unnecessary fields)?
- [ ] Error messages specific and actionable?
- [ ] Undo/redo available where expected?
- [ ] Loading states give clear feedback?

**Ops Lead Lens** 📊
- [ ] Key behaviors have tracking events defined?
- [ ] Conversion funnel points identified?
- [ ] User segmentation criteria documented?
- [ ] Admin/ops tools sufficient?

**QA Engineer Lens** 🧪
- [ ] Boundary values specified (min/max/empty)?
- [ ] Concurrent operation scenarios covered?
- [ ] Network failure modes handled?
- [ ] Cross-browser/device compatibility stated?
- [ ] Permission boundary cases tested?

**UX Heuristic Lens** 🎨
- [ ] Nielsen score ≥ 28 (Good or better)?
- [ ] No Anti-Pattern violations remaining?
- [ ] Accessibility (WCAG AA minimum) considered?
- [ ] Real product references cited?

---

## Quick Reference: Decision Frameworks

### Build / Don't Build (from Feature Investment Advisor)

When user asks "should we build X?", evaluate:

1. **Revenue connection**: Direct monetization / retention / conversion / expansion / none
2. **Cost structure**: Dev cost (one-time) + COGS (ongoing) + OpEx (support)
3. **ROI**: (Revenue impact × Gross margin) / Dev cost. Need >3:1 for direct, >10:1 LTV for retention
4. **Strategic value**: Competitive moat / platform enabler / market requirement / risk reduction
5. **Payback period**: Must be shorter than average customer lifetime

### RICE Scoring (for prioritization)

```
RICE = (Reach × Impact × Confidence) / Effort
```

- **Reach**: Users affected per period (1=niche, 10=all users)
- **Impact**: Per user (0.25=minimal, 0.5=low, 1=medium, 2=high, 3=massive)
- **Confidence**: % (100%=high, 80%=medium, 50%=low)
- **Effort**: Person-months

---

## Reference Documents

Load these during the pipeline:

| Pipeline Stage | Reference File | Purpose |
|---------------|----------------|---------|
| Stage 1 | SKILL.md (this file) | JTBD + Persona extraction rules |
| Stage 2 | SKILL.md (this file) | Pushback checklist + edge case rules |
| Stage 3 | `references/anti-patterns.md` | AI UX anti-patterns guardrail |
| Stage 3 | `references/pattern-library.md` | Proven UX patterns with success data |
| Stage 4 | `references/TEMPLATE.md` | Enforced PRD output structure |
| Stage 4 | `references/quality-checklist.md` | 4-role quality review checklist |
| Stage 4 | `references/prototype-guide.md` | HTML prototype generation spec |
| Stage 4 | `references/EXAMPLE.md` | Quality anchor example (login module PRD) |

---

## Mini-Patterns: Common Decisions

### When user says "做一个XX模块"
→ Run full 4-stage pipeline → Output PRD.md

### When user says "这个需求怎么设计交互"
→ Stages 1-3 only → Output interaction decision brief (no full PRD)

### When user says "评估一下做不做这个功能"
→ Build/Don't Build framework → Output investment recommendation

### When user says "给这个PRD提意见"
→ Pushback checklist + heuristic audit → Output review with scored feedback

### When user says "生成原型"
→ Stage 4 prototype mode → Output HTML spec per prototype-guide.md
