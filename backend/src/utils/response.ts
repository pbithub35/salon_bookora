import { Response } from 'express';
export function success<T>(res: Response, data: T, status = 200, message = 'OK') {
  return res.status(status).json({ success: true, message, data });
}
