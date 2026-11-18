import { Request, Response, NextFunction } from 'express';
import { authService } from '../services/auth.service';
import { success } from '../utils/response';
export const authController = {
  sendOtp: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await authService.sendOtp(req.body), 200, 'OTP sent'); } catch(e) { next(e); } },
  verifyOtp: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await authService.verifyOtp(req.body), 200, 'OTP verified'); } catch(e) { next(e); } },
  login: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await authService.login(req.body), 200, 'Login successful'); } catch(e) { next(e); } },
  registerCustomer: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await authService.registerCustomer(req.body), 201, 'Registration successful'); } catch(e) { next(e); } },
  registerOwner: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await authService.registerOwner(req.body), 201, 'Application submitted'); } catch(e) { next(e); } },
  refresh: async (req: Request, res: Response, next: NextFunction) => { try { return success(res, await authService.refresh(req.body.refreshToken)); } catch(e) { next(e); } },
  logout: async (req: Request, res: Response, next: NextFunction) => { try { await authService.logout(req.auth!.userId, req.body.refreshToken); return success(res, null, 200, 'Logged out'); } catch(e) { next(e); } },
};
