# SalonBookora Backend

Separate Node.js/Express TypeScript API for the existing Flutter client. API prefix: `/api/v1`; Swagger UI: `/docs`.

## Setup

1. Copy `.env.example` to `.env` and set a MySQL `DATABASE_URL` plus long random JWT secrets.
2. Install dependencies with `npm install`.
3. Run `npm run db:generate`, `npm run db:deploy` (or `npm run db:migrate` for development), and `npm run db:seed`.
4. Start with `npm run dev`.

The seed command creates the five mobile numbers listed in the Flutter Phase 1 spec (`9876543210` through `9876543250` as documented). In development, OTP is `0000`.

## Auth API

- `POST /api/v1/auth/otp/send` `{ countryCode, mobileNumber, purpose: "login" | "register" }`
- `POST /api/v1/auth/otp/verify` `{ countryCode, mobileNumber, purpose, otp }`
- `POST /api/v1/auth/login` `{ countryCode, mobileNumber }` (requires a verified login OTP)
- `POST /api/v1/auth/register/customer` `{ fullName, countryCode, mobileNumber, email?, city? }` (requires verified registration OTP)
- `POST /api/v1/auth/register/salon-owner` `{ ownerFullName, countryCode, mobileNumber, ownerEmail?, city, salonName, salonType, salonContact, address, state, pincode, salonEmail?, description? }`
- `POST /api/v1/auth/token/refresh` `{ refreshToken }` (rotates both tokens)
- `POST /api/v1/auth/logout` (Bearer token; optional `{ refreshToken }` revokes one or all sessions)
- `GET/PATCH/DELETE /api/v1/account/me` (profile, update, restrict own account)
- `GET /api/v1/account/salon/status` (salon owner only)

Successful responses use `{ success, message, data }`. Session data contains `token`, `refreshToken`, `user`, and optional `salon`; user and salon properties follow the Flutter model field names and lower camel-case enum values. Errors use `{ success: false, message, error: { code, details? } }`.

OTP delivery lives in `src/providers/otp.provider.ts`. Development mode returns the fixed dev code; production needs an SMS provider wired there. OTP send invalidates prior unverified codes, enforces a 60s resend cooldown, and locks after 5 failed verify attempts.

Suspended users still receive a session on login so the Flutter client can route to the restricted screen. Profile updates require an active account.

## Flutter client

Default app build still uses `MockAuthRepository`. To hit this API:

```bash
flutter run --dart-define=USE_REMOTE_AUTH=true --dart-define=API_BASE_URL=http://localhost:3000/api/v1
```

Android emulator host loopback: `http://10.0.2.2:3000/api/v1`.
