# UX Pattern Library

Proven patterns with success data. Reference these in Stage 3 when making
interaction decisions. Don't blindly copy — understand WHY each pattern works.

## Onboarding Patterns

### Progressive Onboarding
**What**: Teach features in context, when user needs them.
**Success**: 75% higher feature adoption vs front-loaded tours (Appcues).
**When**: Complex products, power-user features.
**Example**: Figma shows shortcuts when you perform actions manually.

### Single-Action Signup
**What**: One field (email) to start, collect details later.
**Success**: Up to 60% conversion improvement (Sumo).
**When**: Low-commitment products, free tiers.
**Example**: Superhuman email-only waitlist.

### Value-First Demo
**What**: Let users experience core value before account creation.
**Success**: 30% higher conversion (ProductLed).
**When**: Products where value is immediately demonstrable.
**Example**: Canva lets you design before signup.

### Checklist Progress
**What**: Visible checklist of setup tasks.
**Success**: 90% completion when under 5 items (Twilio).
**When**: Required setup steps.
**Example**: Notion new workspace setup.

### Empty State Guidance
**What**: First screen shows exactly what to do, not empty dashboard.
**Success**: 50% faster time-to-value.
**When**: All products.
**Example**: Linear shows "Create your first issue" prominently.

---

## Form Design

### Inline Validation
**Pattern**: Validate as user completes each field, not on submit.
**Success**: 22% error reduction.
**Implementation**: Green checkmark for valid. Red + specific message for invalid.

### Smart Defaults
**Pattern**: Pre-fill likely values.
**Examples**: Country from IP, date defaults to today, toggle defaults to
most common choice.

### Input Masking
**Pattern**: Format inputs as user types (phone, card, dates).
**Implementation**: Use libraries like Cleave.js.

### Error Messages
**Pattern**: Specific, actionable, positioned near field.
**Good**: "Password needs at least 8 characters (you have 6)."
**Bad**: "Password invalid."

### Single Column
**Pattern**: One field per row, top to bottom.
**Success**: 15% faster completion vs multi-column (CXL).
**Exception**: Short related fields (City/State/Zip).

### Optional Field Marking
**Pattern**: Mark optional fields, not required ones.
**Why**: Most fields are required. Reduces visual noise.
**Implementation**: Gray "(optional)" text after label.

---

## Navigation

### Persistent Primary Nav
**Pattern**: Main navigation always visible.
**Why**: Orientation, quick access.
**Implementation**: Top bar or left sidebar. Never auto-hide primary nav.

### Breadcrumbs
**Pattern**: Show path from home to current page.
**Why**: Orientation, backtracking, SEO.
**When**: Hierarchical content, e-commerce, docs.
**Format**: Home > Category > Subcategory > Current.

### Tab Navigation
**Pattern**: Tabs for switching views of same content.
**Rules**: Max 5-7 tabs. NEVER nest tabs.

### Hamburger Menu
**Pattern**: Hidden navigation behind icon.
**Caveat**: Reduces discoverability 50%. Primary actions must be visible.

### Search-First
**Pattern**: Prominent search for content-heavy products.
**Data**: 30% of users try search first.
**Implementation**: Cmd+K shortcut, recent searches, suggestions.

---

## Empty States

### First-Run Empty State
**Elements**: Clear headline, single primary CTA.
**Example**: "Create your first project" with button.

### No Results Empty State
**Elements**: Explain why, suggest alternatives, clear filters option.
**Example**: "No results for 'xyz'. Try different keywords."

### User-Cleared Empty State
**Elements**: Confirm action, suggest next steps.
**Example**: "All done! Your inbox is empty."

### Error Empty State
**Elements**: What went wrong, how to fix, retry action.
**Example**: "Couldn't load projects. Check connection and try again."

---

## Loading States

### Skeleton Screens
**Pattern**: Show page structure with gray placeholders.
**Success**: Perceived 30% faster than spinners.
**When**: Known content structure.

### Progressive Loading
**Pattern**: Load critical content first, defer rest.
**Why**: Users start engaging immediately.

### Optimistic UI
**Pattern**: Show expected result immediately, sync in background.
**When**: High-confidence actions (like, save, simple edit).
**Caveat**: Must handle failures gracefully.

---

## Error Handling

### Prevention Over Correction
**Examples**: Disable submit until valid, confirm destructive actions, autosave.

### Graceful Degradation
**Principle**: Partial functionality beats complete failure.
**Example**: Image upload fails? Let user continue and retry later.

### Specific Error Messages
**Bad**: "An error occurred."
**Good**: "Your session expired. Please log in again."

### Non-Blocking Errors
**Pattern**: Errors shouldn't stop all activity.
**Implementation**: Toast for minor errors. Inline for form errors. Full-page
only for truly blocking issues (no auth, no network).

### Error Recovery Paths
**Elements**: What happened, why, what to do now.
**Example**: "Payment failed. Try a different card or contact your bank."

---

## Mobile Patterns

### Thumb Zone Design
**Pattern**: Primary actions in easy thumb reach (bottom of screen).
**Data**: 75% of users use phone one-handed.
**Implementation**: Bottom navigation, FABs, bottom sheets.

### Touch Target Size
**Minimum**: 44x44 points.
**Note**: Padding counts toward touch target, not just visible element.

### Swipe Actions
**When**: Common actions on lists (delete, archive).
**Caveat**: Needs discoverability hint. Not all users know to swipe.

### Bottom Sheets
**When**: Secondary actions, filters, options.
**Why**: Easier to reach than top modals. Can be partially dismissed.

---

## Checkout & Conversion (Baymard Institute Data)

### Guest Checkout
**Impact**: 35% abandon if forced to create account.
**Fix**: Always offer guest checkout. Offer account creation AFTER purchase.

### Progress Indicator
**Impact**: Reduces anxiety.
**Format**: 3-5 steps max. Cart → Shipping → Payment → Review.

### Form Field Reduction
**Impact**: Each field removed = ~3% conversion increase.

### Trust Signals
**Impact**: 17% abandon due to payment security concerns.
**Fix**: Security badges near payment. Display accepted cards.

### Cart Persistence
**Data**: 35% of abandoned carts are recovered within 24 hours.
**Fix**: Save to localStorage minimum.

### Shipping Transparency
**Impact**: 48% abandon due to unexpected shipping costs.
**Fix**: Show shipping estimate early.
