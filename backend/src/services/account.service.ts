import { prisma } from '../config/database';
import { AppError } from '../utils/errors';
import { serializeBusiness, serializeUser } from '../utils/tokens';
export class AccountService {
  async profile(id: string) {
    const user = await prisma.user.findUnique({ where: { id }, include: { business: true } });
    if (!user) throw new AppError(404, 'Account not found', 'ACCOUNT_NOT_FOUND');
    return { user: serializeUser(user), ...(user.business ? { business: serializeBusiness(user.business) } : {}) };
  }
  async update(id: string, input: any) {
    try {
      const user = await prisma.user.update({ where: { id }, data: { fullName: input.fullName, email: input.email === '' ? null : input.email, city: input.city, locale: input.locale }, include: { business: true } });
      return { user: serializeUser(user), ...(user.business ? { business: serializeBusiness(user.business) } : {}) };
    } catch (error: any) { if (error.code === 'P2002') throw new AppError(409, 'Email is already in use', 'ACCOUNT_EXISTS'); throw error; }
  }
  async close(id: string) { await prisma.user.update({ where: { id }, data: { status: 'SUSPENDED' } }); await prisma.refreshToken.updateMany({ where: { userId: id, revokedAt: null }, data: { revokedAt: new Date() } }); }
}
export const accountService = new AccountService();
