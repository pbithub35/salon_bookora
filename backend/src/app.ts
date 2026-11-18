import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import swaggerUi from 'swagger-ui-express';
import { env } from './config/env';
import authRoutes from './routes/auth.routes';
import accountRoutes from './routes/account.routes';
import { errorHandler, notFound } from './middleware/errors';

const phoneProps = {
  countryCode: { type: 'string', example: '+91' },
  mobileNumber: { type: 'string', example: '9876543210' },
};

const openapi = {
  openapi: '3.0.3',
  info: { title: 'SalonBookora API', version: '1.0.0' },
  servers: [{ url: '/api/v1' }],
  components: {
    securitySchemes: {
      bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
    },
    schemas: {
      SuccessEnvelope: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: true },
          message: { type: 'string' },
          data: { type: 'object' },
        },
      },
      ErrorEnvelope: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: false },
          message: { type: 'string' },
          error: {
            type: 'object',
            properties: {
              code: { type: 'string' },
              details: { type: 'object' },
            },
          },
        },
      },
      OtpSendBody: {
        type: 'object',
        required: ['countryCode', 'mobileNumber', 'purpose'],
        properties: {
          ...phoneProps,
          purpose: { type: 'string', enum: ['login', 'register'] },
        },
      },
      OtpVerifyBody: {
        type: 'object',
        required: ['countryCode', 'mobileNumber', 'purpose', 'otp'],
        properties: {
          ...phoneProps,
          purpose: { type: 'string', enum: ['login', 'register'] },
          otp: { type: 'string', example: '0000' },
        },
      },
    },
  },
  paths: {
    '/auth/otp/send': {
      post: {
        summary: 'Send login or registration OTP',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/OtpSendBody' },
            },
          },
        },
        responses: {
          '200': { description: 'OTP sent' },
          '404': { description: 'ACCOUNT_NOT_FOUND' },
          '409': { description: 'ACCOUNT_EXISTS' },
          '429': { description: 'OTP_RATE_LIMITED' },
        },
      },
    },
    '/auth/otp/verify': {
      post: {
        summary: 'Verify OTP',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/OtpVerifyBody' },
            },
          },
        },
        responses: {
          '200': { description: 'OTP verified' },
          '400': { description: 'INVALID_OTP' },
          '429': { description: 'OTP_LOCKED' },
        },
      },
    },
    '/auth/login': {
      post: {
        summary: 'Create session after verified login OTP',
        responses: { '200': { description: 'Session issued' } },
      },
    },
    '/auth/register/customer': {
      post: {
        summary: 'Register customer after OTP verification',
        responses: { '201': { description: 'Customer registered' } },
      },
    },
    '/auth/register/salon-owner': {
      post: {
        summary: 'Register salon owner business account after OTP verification',
        description: 'Creates the owner account + optional brand. No shop is created; shops are added from the dashboard. Accepts mobileNumber or ownerMobile',
        responses: { '201': { description: 'Owner registered' } },
      },
    },
    '/auth/token/refresh': {
      post: {
        summary: 'Rotate refresh token',
        responses: { '200': { description: 'Session refreshed' } },
      },
    },
    '/auth/logout': {
      post: {
        summary: 'Revoke refresh token(s)',
        security: [{ bearerAuth: [] }],
        responses: { '200': { description: 'Logged out' } },
      },
    },
    '/account/me': {
      get: {
        summary: 'Get profile',
        security: [{ bearerAuth: [] }],
        responses: { '200': { description: 'Profile' } },
      },
      patch: {
        summary: 'Update profile (active accounts only)',
        security: [{ bearerAuth: [] }],
        responses: { '200': { description: 'Updated profile' } },
      },
      delete: {
        summary: 'Restrict own account',
        security: [{ bearerAuth: [] }],
        responses: { '200': { description: 'Account closed' } },
      },
    },
    '/account/business': {
      get: {
        summary: 'Get business profile (salon owner)',
        security: [{ bearerAuth: [] }],
        responses: { '200': { description: 'Business profile' } },
      },
    },
  },
};

const app = express();
app.use(helmet());
app.use(
  cors({
    origin:
      env.CORS_ORIGIN === '*'
        ? true
        : env.CORS_ORIGIN.split(',').map((x) => x.trim()),
    credentials: true,
  }),
);
app.use(express.json({ limit: '1mb' }));
app.get('/health', (_req, res) =>
  res.json({ success: true, data: { status: 'ok' } }),
);
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/account', accountRoutes);
app.use('/docs', swaggerUi.serve, swaggerUi.setup(openapi));
app.use(notFound);
app.use(errorHandler);
export default app;
