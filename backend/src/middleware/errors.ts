import { ErrorRequestHandler, RequestHandler } from 'express';
import { ZodError } from 'zod';
import { AppError } from '../utils/errors';
export const notFound: RequestHandler = (req, _res, next) => next(new AppError(404, `Route ${req.method} ${req.path} not found`, 'NOT_FOUND'));
export const errorHandler: ErrorRequestHandler = (error, _req, res, _next) => {
  if (error instanceof AppError) return res.status(error.status).json({ success: false, message: error.message, error: { code: error.code, ...(error.details ? { details: error.details } : {}) } });
  if (error instanceof ZodError) return res.status(400).json({ success: false, message: 'Request validation failed', error: { code: 'VALIDATION_ERROR', details: error.flatten() } });
  console.error(error);
  return res.status(500).json({ success: false, message: 'Internal server error', error: { code: 'INTERNAL_ERROR' } });
};
