import bcrypt from 'bcrypt';
import { OtpPurpose, UserRole } from '@prisma/client';
import { prisma } from '../config/database';
import { deliverOtp, generateOtpCode } from '../providers/otp.provider';
import { AppError } from '../utils/errors';
import {
  createAccessToken,
  createRefreshToken,
  hashToken,
  serializeBusiness,
  serializeUser,
  verifyRefreshToken,
} from '../utils/tokens';

type Phone = { countryCode: string; mobileNumber: string };

const OTP_TTL_MS = 5 * 60_000;
const OTP_RESEND_COOLDOWN_MS = 60_000;
const OTP_MAX_ATTEMPTS = 5;

const purposeMap = (purpose: string) => purpose.toUpperCase() as OtpPurpose;

export class AuthService {
  async sendOtp(input: Phone & { purpose: string }) {
    const phone = {
      countryCode: input.countryCode,
      mobileNumber: input.mobileNumber,
    };
    const purpose = purposeMap(input.purpose);

    const exists = await prisma.user.findUnique({
      where: { countryCode_mobileNumber: phone },
    });

    if (input.purpose === 'login' && !exists) {
      throw new AppError(
        404,
        'No account found with this number. Please register first.',
        'ACCOUNT_NOT_FOUND',
      );
    }
    if (input.purpose === 'register' && exists) {
      throw new AppError(
        409,
        'An account already exists with this number. Please log in.',
        'ACCOUNT_EXISTS',
      );
    }

    const recent = await prisma.otp.findFirst({
      where: { ...phone, purpose, verifiedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    if (
      recent &&
      Date.now() - recent.createdAt.getTime() < OTP_RESEND_COOLDOWN_MS
    ) {
      const waitSec = Math.ceil(
        (OTP_RESEND_COOLDOWN_MS - (Date.now() - recent.createdAt.getTime())) /
          1000,
      );
      throw new AppError(
        429,
        `Please wait ${waitSec}s before requesting another OTP`,
        'OTP_RATE_LIMITED',
      );
    }

    // Invalidate previous unverified OTPs for this phone + purpose.
    await prisma.otp.deleteMany({
      where: { ...phone, purpose, verifiedAt: null },
    });

    const code = generateOtpCode();
    const codeHash = await bcrypt.hash(code, 10);
    await prisma.otp.create({
      data: {
        ...phone,
        purpose,
        codeHash,
        expiresAt: new Date(Date.now() + OTP_TTL_MS),
        userId: exists?.id,
      },
    });

    const delivery = await deliverOtp({ ...phone, code });
    return {
      expiresInSeconds: OTP_TTL_MS / 1000,
      ...(delivery.devOtp ? { devOtp: delivery.devOtp } : {}),
    };
  }

  async verifyOtp(input: Phone & { purpose: string; otp: string }) {
    const phone = {
      countryCode: input.countryCode,
      mobileNumber: input.mobileNumber,
    };
    const purpose = purposeMap(input.purpose);

    const record = await prisma.otp.findFirst({
      where: { ...phone, purpose, verifiedAt: null },
      orderBy: { createdAt: 'desc' },
    });

    if (!record || record.expiresAt < new Date()) {
      throw new AppError(
        400,
        'Please enter correct 4-digit OTP',
        'INVALID_OTP',
      );
    }

    if (record.attemptCount >= OTP_MAX_ATTEMPTS) {
      await prisma.otp.delete({ where: { id: record.id } });
      throw new AppError(
        429,
        'Too many invalid OTP attempts. Please request a new code.',
        'OTP_LOCKED',
      );
    }

    const ok = await bcrypt.compare(input.otp, record.codeHash);
    if (!ok) {
      await prisma.otp.update({
        where: { id: record.id },
        data: { attemptCount: { increment: 1 } },
      });
      throw new AppError(
        400,
        'Please enter correct 4-digit OTP',
        'INVALID_OTP',
      );
    }

    await prisma.otp.update({
      where: { id: record.id },
      data: { verifiedAt: new Date() },
    });
    return { verified: true };
  }

  private async requireVerifiedOtp(phone: Phone, purpose: string) {
    const record = await prisma.otp.findFirst({
      where: {
        ...phone,
        purpose: purposeMap(purpose),
        verifiedAt: { not: null },
        expiresAt: { gt: new Date() },
      },
      orderBy: { verifiedAt: 'desc' },
    });
    if (!record) {
      throw new AppError(
        400,
        'Verify your mobile number with OTP before continuing',
        'OTP_REQUIRED',
      );
    }
    await prisma.otp.deleteMany({
      where: { ...phone, purpose: purposeMap(purpose) },
    });
  }

  /**
   * Issues a session for ACTIVE and SUSPENDED users.
   * Suspended accounts still get tokens so the client can route to the
   * restricted screen (matches Flutter Phase 1 seed flow).
   */
  private async issueSession(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { business: true },
    });
    if (!user) {
      throw new AppError(404, 'Account not found', 'ACCOUNT_NOT_FOUND');
    }

    const refresh = createRefreshToken(user);
    await prisma.refreshToken.create({
      data: {
        userId,
        tokenHash: refresh.hash,
        expiresAt: refresh.expiresAt,
      },
    });

    return {
      token: createAccessToken(user),
      refreshToken: refresh.token,
      user: serializeUser(user),
      ...(user.business
        ? { business: serializeBusiness(user.business) }
        : {}),
    };
  }

  async login(phone: Phone) {
    await this.requireVerifiedOtp(phone, 'login');
    const user = await prisma.user.findUnique({
      where: { countryCode_mobileNumber: phone },
    });
    if (!user) {
      throw new AppError(
        404,
        'No account found with this number. Please register first.',
        'ACCOUNT_NOT_FOUND',
      );
    }
    return this.issueSession(user.id);
  }

  async registerCustomer(input: {
    fullName: string;
    countryCode: string;
    mobileNumber: string;
    email?: string;
    city?: string;
    password?: string;
  }) {
    await this.requireVerifiedOtp(input, 'register');
    const passwordHash = input.password
      ? await bcrypt.hash(input.password, 12)
      : null;
    try {
      const user = await prisma.user.create({
        data: {
          fullName: input.fullName,
          countryCode: input.countryCode,
          mobileNumber: input.mobileNumber,
          email: input.email || null,
          city: input.city || null,
          role: UserRole.CUSTOMER,
          passwordHash,
        },
      });
      return this.issueSession(user.id);
    } catch (error: unknown) {
      if (
        typeof error === 'object' &&
        error &&
        'code' in error &&
        (error as { code: string }).code === 'P2002'
      ) {
        throw new AppError(
          409,
          'An account already exists with this number or email',
          'ACCOUNT_EXISTS',
        );
      }
      throw error;
    }
  }

  /**
   * Owner registration creates a business account only — no salon/shop is
   * created here. The owner adds shops later from the dashboard.
   */
  async registerOwner(input: {
    ownerFullName: string;
    countryCode: string;
    mobileNumber: string;
    ownerEmail?: string;
    brandName?: string;
    password?: string;
  }) {
    await this.requireVerifiedOtp(
      {
        countryCode: input.countryCode,
        mobileNumber: input.mobileNumber,
      },
      'register',
    );
    const passwordHash = input.password
      ? await bcrypt.hash(input.password, 12)
      : null;
    const brandName = input.brandName?.trim();
    try {
      const user = await prisma.user.create({
        data: {
          fullName: input.ownerFullName,
          countryCode: input.countryCode,
          mobileNumber: input.mobileNumber,
          email: input.ownerEmail || null,
          role: UserRole.SALON_OWNER,
          passwordHash,
          business: {
            create: brandName ? { brandName } : {},
          },
        },
      });
      return this.issueSession(user.id);
    } catch (error: unknown) {
      if (
        typeof error === 'object' &&
        error &&
        'code' in error &&
        (error as { code: string }).code === 'P2002'
      ) {
        throw new AppError(
          409,
          'An account already exists with this number or email',
          'ACCOUNT_EXISTS',
        );
      }
      throw error;
    }
  }

  async refresh(token: string) {
    let claims;
    try {
      claims = verifyRefreshToken(token);
    } catch {
      throw new AppError(
        401,
        'Invalid or expired refresh token',
        'UNAUTHORIZED',
      );
    }
    const hashed = hashToken(token);
    const existing = await prisma.refreshToken.findUnique({
      where: { tokenHash: hashed },
    });
    if (
      !existing ||
      existing.revokedAt ||
      existing.expiresAt < new Date() ||
      claims.sub !== existing.userId
    ) {
      throw new AppError(
        401,
        'Invalid or expired refresh token',
        'UNAUTHORIZED',
      );
    }
    await prisma.refreshToken.update({
      where: { id: existing.id },
      data: { revokedAt: new Date() },
    });
    return this.issueSession(existing.userId);
  }

  async logout(userId: string, token?: string) {
    if (token) {
      await prisma.refreshToken.updateMany({
        where: {
          userId,
          tokenHash: hashToken(token),
          revokedAt: null,
        },
        data: { revokedAt: new Date() },
      });
    } else {
      await prisma.refreshToken.updateMany({
        where: { userId, revokedAt: null },
        data: { revokedAt: new Date() },
      });
    }
  }
}

export const authService = new AuthService();
