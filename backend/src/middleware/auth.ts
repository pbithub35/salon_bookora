import { NextFunction, Request, Response } from 'express';
import { UserRole, UserStatus } from '@prisma/client';
import { prisma } from '../config/database';
import { AppError } from '../utils/errors';
import { verifyAccessToken } from '../utils/tokens';

declare global {
  namespace Express {
    interface Request {
      auth?: { userId: string; role: UserRole; status: UserStatus };
    }
  }
}

/** Allows ACTIVE and SUSPENDED (restricted screen / logout). */
export async function authenticate(
  req: Request,
  _res: Response,
  next: NextFunction,
) {
  try {
    const header = req.header('authorization');
    if (!header?.startsWith('Bearer ')) {
      throw new AppError(401, 'Authentication required', 'UNAUTHORIZED');
    }
    const claims = verifyAccessToken(header.slice(7));
    const user = await prisma.user.findUnique({
      where: { id: claims.sub },
      select: { id: true, role: true, status: true },
    });
    if (!user) {
      throw new AppError(401, 'Account is unavailable', 'UNAUTHORIZED');
    }
    if (
      user.status !== UserStatus.ACTIVE &&
      user.status !== UserStatus.SUSPENDED
    ) {
      throw new AppError(401, 'Account is unavailable', 'UNAUTHORIZED');
    }
    req.auth = { userId: user.id, role: user.role, status: user.status };
    next();
  } catch (error) {
    next(
      error instanceof AppError
        ? error
        : new AppError(401, 'Invalid or expired access token', 'UNAUTHORIZED'),
    );
  }
}

export const requireActive: (
  req: Request,
  _res: Response,
  next: NextFunction,
) => void = (req, _res, next) => {
  if (!req.auth || req.auth.status !== UserStatus.ACTIVE) {
    return next(
      new AppError(
        403,
        'This account is restricted. Please contact support.',
        'ACCOUNT_RESTRICTED',
      ),
    );
  }
  next();
};

export const allowRoles =
  (...roles: UserRole[]) =>
  (req: Request, _res: Response, next: NextFunction) => {
    if (!req.auth || !roles.includes(req.auth.role)) {
      return next(new AppError(403, 'Insufficient permissions', 'FORBIDDEN'));
    }
    next();
  };
