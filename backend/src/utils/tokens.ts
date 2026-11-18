import crypto from 'node:crypto';
import jwt from 'jsonwebtoken';
import { UserRole, UserStatus } from '@prisma/client';
import { env } from '../config/env';

export type AuthClaims = { sub: string; role: UserRole; type?: string };

export function createAccessToken(user: { id: string; role: UserRole }) {
  return jwt.sign(
    { role: user.role, type: 'access' },
    env.JWT_ACCESS_SECRET,
    {
      subject: user.id,
      expiresIn: env.ACCESS_TOKEN_TTL as jwt.SignOptions['expiresIn'],
    },
  );
}

export function createRefreshToken(user: { id: string; role: UserRole }) {
  const token = jwt.sign(
    { role: user.role, type: 'refresh' },
    env.JWT_REFRESH_SECRET,
    { subject: user.id, expiresIn: `${env.REFRESH_TOKEN_TTL_DAYS}d` },
  );
  return {
    token,
    hash: hashToken(token),
    expiresAt: new Date(Date.now() + env.REFRESH_TOKEN_TTL_DAYS * 86400000),
  };
}

export function verifyAccessToken(token: string): AuthClaims {
  const claims = jwt.verify(token, env.JWT_ACCESS_SECRET) as AuthClaims;
  if (claims.type && claims.type !== 'access') {
    throw new Error('Invalid access token type');
  }
  return claims;
}

export function verifyRefreshToken(token: string): AuthClaims {
  const claims = jwt.verify(token, env.JWT_REFRESH_SECRET) as AuthClaims;
  if (claims.type !== 'refresh') {
    throw new Error('Invalid refresh token type');
  }
  return claims;
}

export function hashToken(token: string) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

/** Never spread Prisma user — omit secrets like passwordHash. */
export function serializeUser(user: {
  id: string;
  fullName: string;
  countryCode: string;
  mobileNumber: string;
  email: string | null;
  city: string | null;
  locale: string;
  role: UserRole;
  status: UserStatus;
  createdAt: Date;
}) {
  return {
    id: user.id,
    fullName: user.fullName,
    countryCode: user.countryCode,
    mobileNumber: user.mobileNumber,
    email: user.email,
    city: user.city,
    locale: user.locale,
    role: user.role === 'SALON_OWNER' ? 'salonOwner' : 'customer',
    status: user.status.toLowerCase(),
    createdAt: user.createdAt.toISOString(),
  };
}

export function serializeBusiness(business: {
  id: string;
  ownerId: string;
  brandName: string | null;
} | null) {
  if (!business) return undefined;
  return {
    id: business.id,
    ownerId: business.ownerId,
    brandName: business.brandName,
  };
}
