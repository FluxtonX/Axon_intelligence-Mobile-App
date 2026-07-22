# Axon Intelligence — Product Development Plan

> AI-Powered Freelancing Marketplace | Flutter + BLoC + Clean Architecture

---

## Development Philosophy

- **One auth flow** for all users (buyer & seller)
- **One home screen** — marketplace-first
- **Seller unlocked later** — only when user opts in
- **Screen-by-screen** — no parallel development until each screen is complete

---

## Screen Development Order

| # | Screen | Status | Notes |
|---|--------|--------|-------|
| 1 | Splash Screen | ✅ Done | Gradient bg, logo animation |
| 2 | Onboarding (3 slides) | ✅ Done | AI match, expertise, trust |
| 3 | **Auth Screen** | 🔄 In Progress | Google + Email. No Apple. No role selection. |
| 4 | Buyer Home Screen | ✅ Done | Project stats, notifications, talent preview |
| 5 | Freelancer Profile | ✅ Done | Portfolio, ratings, hire button |
| 6 | Search & Filters | 🔄 In Progress | Category, budget, rating filters |
| 7 | Chat / Messages | ⏳ Pending | Conversation list + chat screen |
| 8 | Hire / Checkout | ⏳ Pending | Milestone-based payment flow |
| 9 | Seller Onboarding | ⏳ Pending | "Become a Freelancer" flow |
| 10 | Seller Dashboard | ⏳ Pending | Earnings, orders, gig management |
| 11 | Create Gig | ⏳ Pending | Multi-step gig creation |
| 12 | Order Management | ⏳ Pending | Buyer & seller order tracking |
| 13 | Reviews & Ratings | ⏳ Pending | Post-delivery review flow |
| 14 | Notifications | ⏳ Pending | In-app + push notifications |
| 15 | Settings & Profile | ⏳ Pending | Account, payments, preferences |

---

## Screen 3 — Auth Screen (Current Focus)

### What's on the screen
- Axon logo + app name
- Headline: "Welcome to Axon"
- Subtext: "Hire smarter. Earn faster."
- `Continue with Google` button
- `Continue with Email` button
- Guest browsing option (subtle)
- Terms & Privacy Policy link

### What's NOT here
- ❌ Apple Sign In (added later for iOS release)
- ❌ Role selection (Buyer / Freelancer)
- ❌ Separate login/register screens (one unified screen)

### After Auth → Default Landing
- User lands on **Marketplace Home** (buyer mode default)
- "Become a Freelancer" option available from profile settings

---

## Architecture Pattern (per feature)

```
features/
  <feature_name>/
    data/
      datasources/        ← API calls, Firebase, local storage
      repositories/       ← impl of domain repos
      models/             ← JSON serializable data models
    domain/
      entities/           ← pure Dart business objects
      repositories/       ← abstract interfaces
      usecases/           ← single-responsibility use cases
    presentation/
      bloc/               ← BLoC event / state / bloc
      pages/              ← full screen widgets
      widgets/            ← screen-specific reusable widgets
```

---

## Color System (current)

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#3B6EF5` | Buttons, links, active states |
| `background` | `#0F1117` | Dark screens |
| `backgroundLight` | `#FFFFFF` | Auth, onboarding |
| `textDark` | `#0F1117` | Headings on light screens |
| `textSecondary` | `#6B7280` | Subtitles, hints |
| `gradientStart` | `#284AA3` | Splash top |
| `gradientMid` | `#1D2C58` | Splash middle |
| `gradientEnd` | `#1A3681` | Splash bottom |

---

## Key Decisions

- **State Management**: BLoC (flutter_bloc ^9.1.1)
- **Navigation**: go_router ^15.1.3
- **Fonts**: Inter (Google Fonts)
- **Auth**: Google Sign-In + Email/Password (Firebase Auth)
- **Role logic**: Stored in user profile, NOT in auth flow
