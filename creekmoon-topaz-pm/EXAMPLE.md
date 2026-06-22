# Example: User Login Module — Complete Tactical PRD

> This is the quality anchor. Every PRD you generate should match or exceed
the depth, structure, and specificity of this example.

---

# 用户登录模块 — 战术PRD

> One-sentence: We're building a multi-method login system for both new and
> returning users to solve the problem of 40% drop-off at the login gate,
> which will increase activation rate from 60% to 80%.

---

## 1. Problem Statement

### Who has this problem?
- **Primary**: New users who abandon during account creation due to password fatigue and form complexity
- **Secondary**: Returning users who forget passwords and struggle with recovery flows

### What is the problem?
Current login module requires email + password only. Analytics show 40% of
users who land on the login page never complete the action. 25% of returning
users click "forgot password" monthly. The process is too high-friction for a
first interaction.

### Why is it painful?
- **User impact**: Users expect one-click login (Google/Apple SSO). Password
  creation during signup feels like homework. 3+ field forms on mobile have
  60% higher abandonment.
- **Business impact**: 40% login-page drop-off translates to ~2,000 lost
  activations/month at current traffic. Each activation worth $50 LTV =
  $100K/month in lost revenue.

### Evidence
- "I just wanted to try the product but it asked me to create a password with
  special characters. I left." — User interview, 3 users out of 5
- Login page → successful login funnel: 60% completion (Mixpanel, June 2026)
- "Forgot password" is #2 support ticket category (320 tickets/month)
- Competitor benchmark: Linear, Notion, Figma all offer SSO-first login

---

## 2. Goals & Success Metrics

### Primary Goal
Increase login-to-activation rate from 60% to 80% within 30 days of launch.

### Success Metrics
| Metric | Current | Target | Measurement Method |
|--------|---------|--------|-------------------|
| Login completion rate | 60% | 80% | Mixpanel funnel: Login page → Successful auth |
| "Forgot password" tickets | 320/mo | <150/mo | Zendesk ticket count |
| Time to login (returning) | 45s | <15s | Mixpanel event timing |
| SSO adoption (new users) | 0% | >60% | Backend auth method tracking |

### Guardrail Metrics
- Account security incidents: 0 increase (monitor for brute force, account takeovers)
- Page load time: <2s on 3G (Lighthouse performance audit)
- Mobile conversion: Must not decrease vs desktop

### Anti-Goals
- NOT building a full identity management system (keep it simple, no roles/permissions)
- NOT building social sharing or invite flows
- NOT supporting enterprise SSO (SAML/OAuth2) in this iteration

---

## 3. Target Users & Personas

### Primary Persona: "Curious First-Timer Carla"
- **Role**: New user discovering the product via referral or search
- **Tech level**: Medium (uses Google/Apple login everywhere)
- **Goals**: Try the product immediately with minimum friction
- **Pain points**: Password creation, email verification delays, form fatigue
- **Trigger**: Clicked a referral link or search result, wants to see the product NOW

### Secondary Persona: "Returning Regular Raj"
- **Role**: Weekly active user on multiple devices
- **Tech level**: High
- **Goals**: Get back into the product quickly
- **Pain points**: Forgot password, password manager doesn't work, 2FA friction
- **Trigger**: Clicked bookmark or typed URL directly

### Jobs-to-Be-Done
| Priority | Job Statement |
|----------|---------------|
| 1 | When I discover a new product, I want to access it instantly with one click, so I can evaluate it before committing. |
| 2 | When I return to a product, I want to resume where I left off without remembering passwords, so I can continue my work. |
| 3 | When I need to create an account, I want the fastest possible path, so I don't abandon during signup. |

---

## 4. Solution Overview

### High-Level Description
A dual-mode authentication system that presents SSO (Google, Apple) as the
primary path and email + password as the secondary option. New users land on
an SSO-first screen that enables account creation in 2 clicks. Returning
users are remembered and offered one-tap re-authentication. The password
flow is optimized for minimal friction with inline validation and a clear
"forgot password" recovery path.

### Key Features
1. **SSO-First Login**: Google and Apple sign-in buttons prominently placed
   above the fold as the primary path
2. **Smart Remember Me**: 30-day persistent session with visual indication of
   remembered account
3. **Inline Password Recovery**: Password reset flow embedded in the same
   page without navigation (reduces drop-off by keeping context)
4. **Passwordless Option**: Magic link sent via email for users who prefer
   not to create or remember passwords

### User Flow (Happy Path — New User via SSO)
1. User lands on `/login` page
2. Page shows SSO buttons (Google, Apple) prominently at top
3. User clicks "Continue with Google"
4. OAuth popup → user selects account → popup closes
5. Backend creates account or links existing account
6. Redirect to `/onboarding` (first visit) or `/dashboard` (returning)
7. Success toast: "Welcome aboard!"

### User Flow (Happy Path — Returning User)
1. User lands on `/login`
2. Page shows remembered account card: "Welcome back, [Name]" with avatar
3. Single "Continue as [Name]" button
4. If session still valid: direct redirect to `/dashboard`
5. If re-auth needed: quick Google/Apple confirmation

### Alternative Flows
- **Flow A**: Email + password login (user prefers or SSO unavailable)
  → Click "Use email instead" → show email/password form
- **Flow B**: Magic link login (user forgets password, doesn't want SSO)
  → Click "Send me a magic link" → enter email → click link in inbox
- **Flow C**: Multiple Google accounts (user has work + personal)
  → Show account picker every time (don't auto-select)
- **Flow D**: Mobile browser with SSO blocked (popup blockers, incognito)
  → Fallback to magic link automatically suggested

---

## 5. UX Decisions

### Page Structure
Single centered card layout on a clean, distraction-free background:
```
┌──────────────────────────────────────┐
│  Logo (small, top center)            │
│                                      │
│  "Welcome to [Product]"              │
│  "Sign in to continue"               │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  Continue with Google          │  │  ← Primary
│  └────────────────────────────────┘  │
│  ┌────────────────────────────────┐  │
│  │  Continue with Apple           │  │  ← Primary
│  └────────────────────────────────┘  │
│                                      │
│  ─────────── or ───────────          │  ← Divider
│                                      │
│  ┌────────────────────────────────┐  │
│  │  Enter your email              │  │  ← Email input
│  └────────────────────────────────┘  │
│  ┌────────────────────────────────┐  │
│  │  Continue →                    │  │  ← CTA (adaptive)
│  └────────────────────────────────┘  │
│                                      │
│  Don't have an account? Sign up →    │
└──────────────────────────────────────┘
```

### Information Hierarchy
1. **Brand recognition**: Small logo (users need to know they're in the right place)
2. **Social proof heading**: "Welcome" (friendly, not "LOGIN REQUIRED")
3. **Primary action**: SSO buttons (largest visual weight)
4. **Secondary path**: Email input (accessible but visually subordinate)
5. **Tertiary**: Sign up link (for new users who landed on wrong page)

### Component Placement
| Element | Position | Rationale |
|---------|----------|-----------|
| Google/Apple buttons | Top of card, full width | Primary path per F-Pattern reading. Users scan top first. |
| Email input | Below divider | Secondary path — accessible but subordinate |
| "Forgot password" | Below password field, right-aligned | Close to the field it relates to. Right align = secondary action convention. |
| "Sign up" link | Bottom center | Users who landed wrong need this, but it shouldn't compete with login |
| "Remember me" | Below password, left-aligned | Near auth action, unchecked by default (privacy) |

### Interaction Model
- **Primary flow**: Click SSO button → OAuth → redirect (3 steps, 5-10 seconds)
- **Adaptive CTA**: Email field only shows "Continue". If email exists in DB,
  CTA changes to "Sign in" and password field appears. If new email, CTA
  shows "Create account" and prompts for password creation.
- **Magic link**: Below password field, text link "Or send me a magic link"
- **Keyboard**: Tab order follows visual order. Enter submits current form.
- **Auto-focus**: Email input auto-focused on page load (desktop only — avoid
  mobile keyboard popup)

### Real Product References
| Decision | Reference Product | What We Learned |
|----------|------------------|-----------------|
| SSO buttons above fold | Notion, Linear, Figma | All leading SaaS products lead with SSO. Users expect it. Reduces signup friction by 40-60%. |
| Adaptive CTA (sign in vs create) | Stripe dashboard | Single email field that adapts eliminates the "Sign in vs Sign up" confusion. Reduces cognitive load. |
| Centered card on empty background | Linear, Vercel | Distraction-free auth pages increase completion. No navigation, no upsells, no feature lists. |
| Magic link as password alternative | Slack, Medium | Magic links reduce "forgot password" tickets to near zero. Users prefer them on mobile. |

### Anti-Pattern Check Results
| Check | Status | Fix Applied |
|-------|--------|-------------|
| No modal hell | ✅ | All auth actions are inline or redirect, no modals |
| No hover-dependent primary actions | ✅ | All actions always visible, touch-friendly |
| No form field bloat | ✅ | SSO path = 1 click. Email path = max 3 fields (email, password, remember) |
| No verbose onboarding | ✅ | Login page has 0 instructional text. Actions are self-evident. |
| Loading states defined | ✅ | SSO button shows spinner during OAuth. Page shows skeleton during redirect. |
| Error recovery paths exist | ✅ | See State Definitions section below |
| No "AI gradient" design | ✅ | Clean white card on subtle gray background. No decorative effects. |
| No emoji pollution | ✅ | No emojis in UI. Professional tone. |

### Nielsen Heuristic Score: 36/40

| # | Heuristic | Score | Notes |
|---|-----------|-------|-------|
| 1 | Visibility of system status | 4 | Loading spinner on SSO button, progress during redirect |
| 2 | Match between system and real world | 4 | "Continue with Google" matches user mental model from other products |
| 3 | User control and freedom | 4 | Back button works, cancel OAuth anytime, "Use email instead" alternative |
| 4 | Consistency and standards | 4 | Standard OAuth buttons, standard form patterns, standard link colors |
| 5 | Error prevention | 3 | Email validation inline, magic link offered if password forgotten (-1 for no password strength indicator) |
| 6 | Recognition rather than recall | 4 | Remembered account shown with avatar — user recognizes, doesn't need to recall |
| 7 | Flexibility and efficiency of use | 3 | Keyboard shortcuts work, SSO is fast. (-1 for no "sign in with QR code" for power users) |
| 8 | Aesthetic and minimalist design | 4 | Single card, no sidebar, no navigation, no upsells. Only what's needed. |
| 9 | Error recovery | 4 | Inline error messages with specific fixes. Magic link as recovery. |
| 10 | Help and documentation | 2 | No help text on page. (-2: could use a "Need help?" link for edge cases) |
| **Total** | | **36** | **Good** |

Weak areas: Help text (#10) and password strength feedback (#5). Acceptable
tradeoffs for a minimal login page — help link added in v1.1 if support
tickets indicate need.

---

## 6. State Definitions

### States Overview
| State | Trigger | Visual | User Can |
|-------|---------|--------|----------|
| **Default** | Page load, no remembered account | SSO buttons + email input visible | Click SSO, enter email, switch to signup |
| **Loading (SSO)** | User clicked SSO button | SSO button shows spinner, disabled | Wait, cancel by closing popup |
| **Loading (Redirect)** | OAuth success, processing | Full-page skeleton with product logo | Wait (typically 1-3 seconds) |
| **Remembered User** | Returning user with valid session | Welcome back card with avatar + "Continue as [Name]" | Click continue, switch account, use different method |
| **Email Exists** | Typed email recognized by backend | Password field appears, CTA changes to "Sign in" | Enter password, click sign in, request magic link |
| **Email New** | Typed email not in DB | Password creation field appears, CTA shows "Create account" | Enter new password, terms checkbox appears |
| **Empty (First Visit)** | N/A for login | N/A | N/A |
| **Success** | Auth completed | Redirect to destination, brief "Welcome" toast | Begin using product |
| **Error (Network)** | API timeout/offline | Inline error: "Can't connect. Check your internet." with retry | Retry, check connection |
| **Error (Invalid Credentials)** | Wrong password | Field-level error: "Incorrect password. Try again or use magic link." | Re-enter, click magic link, reset password |
| **Error (OAuth Cancel)** | User closed popup | Return to default state, no error shown (intentional — not an error) | Try again |
| **Error (Account Locked)** | Too many failed attempts | Inline message: "Account temporarily locked. Check your email." | Wait 15 min, check email for unlock link |

### State Transition Diagram
```
[Default]
  ├── SSO click → [Loading SSO] → OAuth success → [Loading Redirect] → [Success]
  │                              → OAuth cancel → [Default] (no error)
  │
  ├── Type email → [Email Exists] → Enter password → Submit → [Loading] → [Success]
  │                               │                → Wrong → [Error Invalid Creds]
  │                               → Magic link → [Loading] → Check email
  │
  ├── Type email → [Email New] → Create password → Submit → [Loading] → [Success]
  │
  └── Remembered cookie → [Remembered User] → Continue → [Loading Redirect] → [Success]
                                              → Switch → [Default]
```

---

## 7. Detailed Scenarios

### Scenario 1: New User — Google Signup (Happy Path)
**Given** A new user has clicked a referral link to the product
**And** They have an active Google session in their browser
**When** They click "Continue with Google"
**And** Select their Google account in the popup
**Then** An account is automatically created with their Google profile data
**And** They are redirected to the onboarding flow
**And** A "Welcome to [Product]" toast appears
**And** The event `signup_completed` fires with method=google

### Scenario 2: Returning User — Quick Resume (Happy Path)
**Given** A user logged in 3 days ago and has a valid session cookie
**When** They navigate to `/login`
**Then** The page shows their avatar and name: "Welcome back, Carla"
**And** A single "Continue as Carla" button is displayed
**When** They click "Continue as Carla"
**Then** They are redirected to `/dashboard` within 2 seconds
**And** Their previous workspace state is restored

### Scenario 3: Wrong Password with Recovery Path (Error Recovery)
**Given** A returning user types their correct email
**And** Enters an incorrect password
**When** They click "Sign in"
**Then** The password field shows: "Incorrect password"
**And** A "Send me a magic link" option appears below the error
**When** They click "Send me a magic link"
**Then** A "Check your email" message appears
**And** An email with a 15-minute magic link is sent
**When** They click the link in their email
**Then** They are logged in and redirected to `/dashboard`
**And** The event `login_completed` fires with method=magic_link

### Scenario 4: Mobile Popup Blocker (Edge Case)
**Given** A user on iOS Safari (private mode) clicks "Continue with Google"
**When** The OAuth popup is blocked by the browser
**Then** After 3 seconds of no response, the page detects the block
**And** Shows: "Popups are blocked. Try a magic link instead."
**And** Auto-focuses the email input with "Send me a magic link" CTA

### Scenario 5: Concurrent Login Attempts (Edge Case)
**Given** A user clicks "Continue with Google" twice rapidly (double-click)
**When** The first OAuth flow starts
**Then** The second click is ignored (button disabled during loading)
**And** Only one auth callback is processed (idempotency key on request)
**And** No duplicate account is created

### Scenario 6: Brute Force Protection (Security Edge Case)
**Given** A user enters wrong passwords 5 times in 10 minutes
**When** They attempt the 6th login
**Then** The account is temporarily locked for 15 minutes
**And** The error message shows: "Too many attempts. Try again in 15 minutes or use a magic link."
**And** An email notification is sent to the account owner about the suspicious activity

---

## 8. Functional Requirements

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-1 | Users can sign up and log in via Google OAuth 2.0 | P0 | PKCE flow, popup-based |
| FR-2 | Users can sign up and log in via Sign in with Apple | P0 | Same UX pattern as Google |
| FR-3 | Users can log in with email + password | P0 | Adaptive CTA (sign in vs create) |
| FR-4 | Users can request a magic link via email | P0 | 15-min expiry, single-use |
| FR-5 | Returning users see remembered account card | P1 | 30-day cookie, avatar + name |
| FR-6 | Password reset flow via email | P1 | 1-hour expiry token |
| FR-7 | Account lockout after 5 failed attempts in 10 min | P1 | 15-min lock, email notification |
| FR-8 | Session management: 30-day remember me | P2 | Refresh token rotation |

### Non-Functional Requirements
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-1 | Page load time | <1.5s on 4G, <2s on 3G (Lighthouse) |
| NFR-2 | Auth redirect time | <3s end-to-end (click → dashboard visible) |
| NFR-3 | WCAG compliance | AA minimum |
| NFR-4 | Mobile viewport | iPhone SE (375px) to desktop |
| NFR-5 | Security | HTTPS only, httpOnly cookies, CSP headers, rate limiting |
| NFR-6 | Cookie consent | No third-party cookies until consent given |

---

## 9. Component Spec

| Component | Type | Description | Linked Scenarios |
|-----------|------|-------------|-----------------|
| SSOButton | Action | Google/Apple branded sign-in buttons | S1, S4 |
| AuthCard | Layout | Centered card with all auth options | All |
| EmailInput | Form | Email field with adaptive validation | S3, S4 |
| PasswordInput | Form | Password field with show/hide toggle | S3 |
| RememberedUserCard | Display | Avatar + name + continue button | S2 |
| MagicLinkSender | Action | Email input + send button for magic link | S3 |
| LoadingSpinner | Display | Inline spinner for loading states | All |
| ErrorMessage | Display | Contextual error with recovery action | S3, S6 |
| ToastNotification | Display | Success confirmation toast | S1 |

### Data Model
```typescript
interface User {
  id: string;                    // UUID v4
  email: string;                 // Unique, indexed
  emailVerified: boolean;        // True after first successful auth
  name: string;                  // From OAuth profile or user input
  avatar: string | null;         // URL to avatar image
  authMethod: 'google' | 'apple' | 'email' | 'magic_link';
  googleId?: string;             // OAuth sub claim
  appleId?: string;              // Apple user identifier
  passwordHash?: string;         // bcrypt, only for email auth
  failedLoginAttempts: number;   // Counter for lockout
  lockedUntil: Date | null;      // Timestamp or null
  createdAt: string;             // ISO8601
  updatedAt: string;             // ISO8601
}

interface Session {
  id: string;                    // UUID
  userId: string;                // FK → User.id
  token: string;                 // JWT access token
  refreshToken: string;          // Hashed refresh token
  expiresAt: Date;               // Access token expiry (15 min)
  refreshExpiresAt: Date;        // Refresh token expiry (30 days)
  userAgent: string;             // For session listing
  ipAddress: string;             // For security audit
  createdAt: string;             // ISO8601
}

interface MagicLink {
  id: string;                    // UUID
  userId: string;                // FK → User.id
  token: string;                 // Hashed, 32-byte random
  expiresAt: Date;               // 15 minutes from creation
  usedAt: Date | null;           // Null until consumed
  createdAt: string;             // ISO8601
}
```

### API Surface
| Method | Path | Description | Auth | Response |
|--------|------|-------------|------|----------|
| POST | /api/auth/google | Initiate Google OAuth | No | `{ authUrl: string }` |
| POST | /api/auth/google/callback | Handle OAuth callback | No | `{ token: JWT, user: User }` |
| POST | /api/auth/apple | Initiate Apple Sign In | No | `{ authUrl: string }` |
| POST | /api/auth/apple/callback | Handle Apple callback | No | `{ token: JWT, user: User }` |
| POST | /api/auth/email/check | Check if email exists | No | `{ exists: boolean }` |
| POST | /api/auth/email/login | Email + password login | No | `{ token: JWT, user: User }` |
| POST | /api/auth/email/register | Create account with email | No | `{ token: JWT, user: User }` |
| POST | /api/auth/magic-link/send | Request magic link | No | `{ sent: boolean }` |
| POST | /api/auth/magic-link/verify | Consume magic link | No | `{ token: JWT, user: User }` |
| POST | /api/auth/password/reset | Request password reset | No | `{ sent: boolean }` |
| POST | /api/auth/session/refresh | Refresh access token | Refresh cookie | `{ token: JWT }` |
| DELETE | /api/auth/session | Logout (revoke session) | Bearer | `{ success: boolean }` |

---

## 10. Scope

### In Scope
- Google OAuth 2.0 signup and login
- Sign in with Apple
- Email + password authentication (login + registration)
- Magic link authentication
- Remembered user / quick resume
- Password reset via email
- Account lockout protection
- Session management (JWT + refresh tokens)

### Out of Scope
| Item | Reason |
|------|--------|
| Enterprise SSO (SAML, OIDC) | B2B sales-led deals only, <5% of user base. Build when first enterprise contract requires it. |
| Multi-factor authentication (MFA) | Security team request but no user demand. Monitor account takeover rate; add if >0.1%. |
| Username/password (without email) | Email is required for magic link recovery. Username adds complexity without clear benefit. |
| Social logins beyond Google/Apple | No user requests for Facebook/GitHub login. Add if analytics show demand >10%. |
| Account deletion flow | Legal requirement but separate feature. Track in GDPR compliance epic. |

### Future Considerations
- **v1.1**: "Need help?" link on login page (heuristic #10 improvement)
- **v1.1**: Password strength indicator during creation (heuristic #5 improvement)
- **v2.0**: MFA via TOTP/SMS if security audit requires
- **v2.0**: Enterprise SAML/OIDC when B2B segment grows

---

## 11. Dependencies & Risks

### Dependencies
| Dependency | Owner | Status | Impact if Delayed |
|------------|-------|--------|-------------------|
| Google OAuth app registration | Engineering | Required | Blocks SSO — fallback to email-only MVP |
| Apple Developer account | Engineering | Required | Blocks Apple SSO — ship Google + email first |
| Email service (SendGrid/Postmark) | Engineering | Required | Blocks magic links and password reset |
| Domain verification for OAuth | DevOps | Required | Can't test OAuth in production without this |

### Risks & Mitigations
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| OAuth popup blockers on mobile | High | Medium | Auto-detect after 3s, fallback to magic link |
| Google/Apple API changes | Low | Medium | Abstract OAuth layer, monitor changelogs |
| Email deliverability (magic links in spam) | Medium | Medium | Use established email service with good reputation; include "check spam" message |
| Session hijacking via XSS | Low | High | httpOnly cookies, CSP headers, short-lived access tokens |
| Duplicate accounts (same email via different methods) | Medium | Medium | Email normalization + account linking on first OAuth login |

---

## 12. Open Questions

| Question | Impact if Unresolved | Suggested Resolution |
|----------|---------------------|---------------------|
| Should we support passwordless (WebAuthn/Passkeys) in v1? | Medium — could leapfrog competitors but adds 2+ weeks dev time | Ship email + magic link first. Passkeys in v2 if user research confirms demand. |
| Do we need GDPR-specific consent flows for EU users? | High — legal risk if non-compliant | Consult legal team before launch. Cookie consent banner may be needed. |
| Should remembered users skip the login page entirely? | Medium — reduces one click but may confuse shared-device users | A/B test: auto-redirect vs show "Welcome back" card. Default to card (safer). |

---

## 13. Rollout Plan

### Milestones
- [ ] Design review of login page mockup
- [ ] Google OAuth integration complete (MVP — email + Google only)
- [ ] Apple Sign In added
- [ ] Magic link flow complete
- [ ] QA: all scenarios from Section 7 pass
- [ ] Security review complete
- [ ] Launch to 10% of new users (feature flag)
- [ ] Monitor metrics for 1 week
- [ ] 100% rollout

### Rollback Plan
- Feature flag `new_login_v2` controls the new login page
- If login completion rate drops below 55% (current = 60%), instant rollback to old login
- Old login page remains deployed but inactive behind the flag

---

## 14. Quality Review

### Tech Lead 🔧
- [x] Concurrency/race conditions: PASS — OAuth button disabled during load, idempotency keys on registration
- [x] Idempotency: PASS — Duplicate OAuth callbacks de-duped by state param + nonce
- [x] Error recovery: PASS — Network timeout → retry button. Magic link as password recovery.
- [x] Performance: PASS — Login page is static HTML, <50KB. CDN cached.
- [x] Security: PASS — Rate limiting (5 req/min per IP), bcrypt passwords, httpOnly cookies, CSP

### Picky User 👤
- [x] Click efficiency: PASS — SSO = 2 clicks to logged in. Remembered user = 1 click.
- [x] Form justification: PASS — Email path: email + password only (2 fields). No unnecessary fields.
- [x] Error message quality: PASS — "Incorrect password. Try again or use magic link." (specific + recovery)
- [x] Undo/redo: N/A — Login is not an undo-requiring action. Logout available in settings.
- [x] Loading clarity: PASS — SSO button spinner, skeleton during redirect, progress is visible

### Ops Lead 📊
- [x] Tracking events: PASS — `login_started`, `login_completed` (with method), `login_failed` (with reason), `magic_link_sent`, `magic_link_used`
- [x] Conversion points: PASS — Funnel: login_page → method_selected → auth_started → auth_completed → dashboard_loaded
- [x] Admin tools: PASS — Admin panel shows login method distribution, failed login attempts, locked accounts

### QA Engineer 🧪
- [x] Boundary values: PASS — Email validation (format, length 254 char max), password (min 8, max 128)
- [x] Concurrent ops: PASS — Double-click SSO handled (button disabled). Simultaneous login from 2 devices allowed (separate sessions).
- [x] Network failures: PASS — Timeout after 10s with "Check connection" message. Magic link works offline (link in email).
- [x] Cross-device: PASS — Desktop (Chrome, Safari, Firefox, Edge), Mobile (iOS Safari, Android Chrome)
- [x] Permission boundaries: PASS — No authenticated actions on login page. All endpoints are public.

### UX Heuristic 🎨
- Nielsen score: 36/40 — Good
- Anti-Pattern violations: None
- Accessibility: WCAG AA (color contrast 7:1, keyboard navigable, aria-labels on SSO buttons)

---

## 15. Rationale

### Why These Decisions Were Made

1. **SSO-first, not email-first**: Data from Mixpanel shows 40% of users
   abandon at login. Competitor analysis (Notion, Linear, Figma) confirms
   SSO-first reduces signup friction by 40-60%. This is the highest-impact
   change we can make.

2. **Single adaptive form instead of Sign In / Sign Up tabs**: Tabs create
   confusion — users often click the wrong one. Stripe's adaptive CTA
   pattern eliminates this entirely. One less decision = less friction.

3. **Magic links instead of "forgot password" flow as primary recovery**:
   Magic links reduce support tickets to near zero (Slack's experience).
   They're also faster than reset-password-email → click link → create new
   password → log in again (4 steps → 2 steps).

4. **Remembered user card**: Recognition > recall (Nielsen heuristic #6).
   Seeing your own avatar and name triggers instant recognition. This is why
   every modern SaaS (Figma, Vercel, Notion) uses this pattern.

5. **No navigation, no sidebar, no upsells on login page**: Every
   distraction increases abandonment. F-Pattern research shows users scan
   top-left to right, then down. The auth card is the ONLY thing in the
   visual field. This follows Linear's and Vercel's minimalist auth pages.

### Key Tradeoffs
| Decision | Option A | Option B | Chose | Why |
|----------|----------|----------|-------|-----|
| Modal vs redirect for OAuth | Inline modal | Full redirect | Modal | Modal keeps user context. Full redirect loses state on mobile browsers. |
| Show password by default | Show | Hide | Hide | Security > convenience. Show/hide toggle available. |
| Remember me default | Checked | Unchecked | Unchecked | Privacy default. User opts in. |
| Auto-redirect remembered users | Yes | No | No | Shared device risk. Card is 1 click — acceptable tradeoff for safety. |
| Social logins count | 2 (Google, Apple) | 4+ (add GitHub, etc.) | 2 | 90%+ of SSO users use Google or Apple. Diminishing returns beyond 2. |

---

*PRD generated by product-manager skill. Review Rationale and Open Questions
before approving. All decisions grounded in user impact.*
