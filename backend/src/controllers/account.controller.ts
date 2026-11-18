import { Request, Response, NextFunction } from 'express';
import { accountService } from '../services/account.service';
import { success } from '../utils/response';
export const accountController = {
  profile: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await accountService.profile(req.auth!.userId)); } catch(e) { next(e); } },
  update: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await accountService.update(req.auth!.userId, req.body)); } catch(e) { next(e); } },
  close: async (req: Request, res: Response, next: NextFunction) => { try { await accountService.close(req.auth!.userId); return success(res, null, 200, 'Account restricted'); } catch(e) { next(e); } },
};
