# SalonBookora — Phase 1 Spec

Flutter Web + Android salon booking foundation. Stack: MVVM, Riverpod, GoRouter, Dio, Secure Storage, ARB l10n (en/hi/pa), ScreenUtil 390×844.

## Screens
| ID | Screen | Notes |
|----|--------|-------|
| S01 | Splash | Session + onboarding routing |
| S02 | Onboarding | 3 slides |
| S03 | Welcome | Login / Create Account + LanguageSelector |
| S04 | Login | Mobile + seed accounts |
| S05 | Role Selection | Customer / Salon Owner |
| S06 | Customer Registration | Profile → OTP |
| S07 | Owner Registration | 2-step → OTP |
| S08 | OTP | 4-digit, 60s resend, dev `0000` |
| S09 | Registration Success | Route by role |
| S10–S12 | Pending / Rejected / Restricted | Owner/user status |
| Shell | Customer / Owner portals | Bottom nav shells |

## Dev seeds (OTP `0000`)
| Mobile | Destination |
|--------|-------------|
| 9876543210 | Customer shell |
| 9876543220 | Pending approval |
| 9876543230 | Owner shell (trial) |
| 9876543240 | Rejected |
| 9876543250 | Restricted |

## Design
Aurora header (navy + cyan/magenta glows) via reusable `AuroraBackground` on auth screens.
Central tokens: colors, spacing, radius, typography, theme.
Every API call: connectivity check + shared Dio/error handling.
