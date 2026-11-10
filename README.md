# SalonBookora - Salon Booking & Management Application
## Phase 1 Frontend Foundation • Clean GetX Architecture

SalonBookora is a modern salon booking and management cross-platform Flutter application (Android & Web) built with **GetX Clean Architecture**, **flutter_screenutil** responsiveness, and centralized design tokens.

---

## 🌟 Key Architecture & Highlights

1. **State Management**: **GetX** (`GetxController`, `Rx`, `Obx`, `Bindings`, `GetMaterialApp`).
2. **Responsive Layouts**: **flutter_screenutil** using the official 390 × 844 logical px reference canvas:
   - Widths: `.w`
   - Heights: `.h`
   - Font sizes: `.sp`
   - Radii: `.r`
   - Web/Desktop: Automatic `ResponsiveWrapper` preventing form stretching on wide displays.
3. **Dedicated Typography & Color Classes**:
   - `AppColors`: All hex color tokens (navy, primaryPurple, cyan, neonPink, pageBackground, surface, status colors, gradients).
   - `AppTextSizes`: Dedicated centralized class with `.sp` getters (`tiny`, `caption`, `bodySmall`, `body`, `titleSmall`, `title`, `headingSmall`, `headingMedium`, `headingLarge`, `display`). Modifying font sizes across the entire application in the future is as simple as updating this one file!
   - `AppTextStyles`: Typography combining `AppTextSizes` and `AppColors` with `GoogleFonts.inter`.
   - `AppSpacing`: Centralized 8px grid spacing tokens with 2–4px micro-adjustments (`.w`, `.h`).
   - `AppRadius`: Rounded corner tokens (`.r`).
   - `AppStrings`: Centralized user-facing strings ready for multi-language localization.
4. **Common Reusable Widgets**:
   - `AuroraBackground`: Custom-painted locked Aurora glow (deep midnight navy base `#080B45`, cyan top-right glow `#00E5E5`, magenta/purple left glow `#EC4DFF`/`#8B19E8`, flowing neon wave curves).
   - `AppText`: Standardized common text with factory constructors (`AppText.heading`, `AppText.title`, `AppText.body`, `AppText.caption`, `AppText.auroraHeader`).
   - `AppTextField`: Text input with rounded borders, focus glow, icons, and error states.
   - `PhoneNumberField`: Phone input with country code dropdown selector (+91 default).
   - `AppButton`: `AppButton.primary` (gradient), `AppButton.secondary` (outlined), `AppButton.text` with loading indicator.
   - `GlassCard`: Frosted glassmorphism card.
   - `RoleSelectionCard`: Interactive Customer vs. Salon Owner selection cards.
   - `OtpInputField`: 4-digit responsive pin boxes with auto-focus and paste.
   - `StatusBadge`: Badges for PENDING, APPROVED, REJECTED, RESTRICTED, ACTIVE.
   - `CustomAppBar`: Standard navigation bar.

---

## 📱 Complete Phase 1 Screen Coverage

| Screen ID | Screen Name | Description |
|-----------|-------------|-------------|
| **S01** | **Splash Screen** | Glowing animated logo, tagline, session and onboarding check. |
| **S02** | **Onboarding** | 3 swipeable slides (Discover Salons, Easy Booking, Your Beauty) with page indicators, Skip & Next/Get Started. |
| **S03** | **Auth Welcome** | Locked Aurora header, Login & Create Account actions, Terms & Privacy modals. |
| **S04** | **Login** | Mobile number + country code, validation, and 1-tap dev seed account selectors. |
| **S05** | **Role Selection** | Customer vs Salon Owner (with 3-Month Free Trial badge). |
| **S06** | **Customer Registration** | Full name, phone, optional email, city, terms acceptance, OTP routing. |
| **S07** | **Salon Owner Registration** | 2-step stepper form (Step 1: Owner Profile; Step 2: Salon Details) with backwards data preservation. |
| **S08** | **OTP Verification** | 4-digit responsive inputs, 60-second cooldown timer, change number, test OTP 0000 dev mode hint. |
| **S09** | **Registration Success** | Confirmation feedback with redirect to portal or review screen. |
| **S10** | **Pending Approval** | Salon application status, submission summary, check status & logout. |
| **S11** | **Rejected Application** | Rejection notice, review team reason, contact support dialog, logout. |
| **S12** | **Restricted Account** | Suspended account notice, contact security team, logout. |
| **Shell** | **Customer Portal Shell** | Explore categories, search bar, featured salons, bottom navigation (Explore, Bookings, Favorites, Profile). |
| **Shell** | **Salon Owner Portal Shell**| Verified partner header, 3-Month Free Trial Active banner, daily metrics, management shortcuts, bottom navigation. |

---

## 🧪 Test / Dev Seed Accounts (Section 12.1)

In Development Mode, the test OTP is **`0000`**. On the Login screen, you can also 1-tap fill any of these numbers:

| Test Mobile Number | Account Role & Status | Expected Destination |
|--------------------|-----------------------|----------------------|
| `9876543210` | CUSTOMER / ACTIVE | Customer Portal Shell |
| `9876543220` | SALON_OWNER / PENDING | Pending Approval Screen |
| `9876543230` | SALON_OWNER / APPROVED | Salon Owner Portal Shell (3 Months Free Trial Active) |
| `9876543240` | SALON_OWNER / REJECTED | Rejection Notice with Reason |
| `9876543250` | User / SUSPENDED | Account Restricted Screen |

---

## 🚀 How to Run

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run analysis
flutter analyze

# 3. Run automated tests
flutter test

# 4. Run application (Android or Chrome Web)
flutter run -d chrome
# or
flutter run
```
