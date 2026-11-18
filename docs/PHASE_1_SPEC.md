# SalonBookora — Phase 1 Spec

Flutter Web + Android salon booking foundation. Stack: MVVM, Riverpod, GoRouter, Dio, Secure Storage, ARB l10n (en/hi/pa), ScreenUtil 390×844.

## Owner model (revised)

Owner registration creates a **business account** — it does NOT create a salon/shop.

```text
Business (optional brandName, e.g. "Looks Salon")
└─ Shop: Looks Salon, Mohali
└─ Shop: Looks Salon, Delhi
```

- Brand is optional; single-shop owners skip it.
- First-time owner lands on dashboard → "Create your first shop" → configure → add staff/services → booking rules → publish → add more shops later.
- Each shop is independent: own name, address/map, contact, hours, photos, staff, service menu/pricing, offers/packages, booking policies, home-service coverage. Mohali and Delhi can differ under one brand.

### Data hierarchy (Prisma)

```text
User (SALON_OWNER)
→ Business (optional brandName)
→ Shop (status: DRAFT | LIVE | PAUSED)
→ Category → Subcategory → Service
   ├─ duration, price, mode (SALON|HOME|BOTH), onlineBookingEnabled, addons
   └─ ServiceHomeConfig (fee, radius/PINs, buffers, min order, advance hours)
→ StaffMember (business-level person)
→ ShopStaffAssignment (per-shop role, hours, permissions, bookable)
→ ServiceStaffAssignment (staff who can perform a service)
→ Offer (flat/%/combo price, dates, eligible services)
→ Package (multi-visit) / Combo (single booking) / ServiceAddon
→ ShopBookingSettings + ShopHomeService (per-shop policies)
```

### Shop detail sections

Overview (setup progress, today's bookings, revenue, staff, status, quick actions) · Services (catalogue) · Team · Offers · Booking settings · Shop settings.

### Bottom nav (owner)

`Dashboard | Shops | Calendar | Team | More` — More holds brand settings, profile, payments, notifications, subscription, help, logout.

## Screens
| ID | Screen | Notes |
|----|--------|-------|
| S01 | Splash | Session + onboarding routing |
| S02 | Onboarding | 3 slides |
| S03 | Welcome | Login / Create Account + LanguageSelector |
| S04 | Login | Mobile + seed accounts |
| S05 | Role Selection | Customer / Salon Owner |
| S06 | Customer Registration | Profile → OTP |
| S07 | Owner Registration | Business account (name, mobile, email, optional brand) → OTP |
| S08 | OTP | 4-digit, 60s resend, dev `0000` |
| S09 | Registration Success | Route by role |
| S10 | Restricted | Suspended account |
| Shell | Customer / Owner portals | Bottom nav shells |

## Dev seeds (OTP `0000`)
| Mobile | Destination |
|--------|-------------|
| 9876543210 | Customer shell |
| 9876543220 | Owner shell — Glow Unisex Studio (draft shop) |
| 9876543230 | Owner shell — The Royal Spa (Ludhiana live + Delhi draft) |
| 9876543240 | Owner shell — new business account, no shops |
| 9876543250 | Restricted |

## Design
Aurora header (navy + cyan/magenta glows) via reusable `AuroraBackground` on auth screens.
Central tokens: colors, spacing, radius, typography, theme.
Every API call: connectivity check + shared Dio/error handling.
