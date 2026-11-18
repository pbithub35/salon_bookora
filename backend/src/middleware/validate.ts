import { RequestHandler } from 'express';
import { ZodType } from 'zod';
import { AppError } from '../utils/errors';
export const validate = (schema: ZodType): RequestHandler => (req, _res, next) => {
  const result = schema.safeParse(req.body);
  if (!result.success) return next(new AppError(400, 'Request validation failed', 'VALIDATION_ERROR', result.error.flatten()));
  req.body = result.data; next();
};
