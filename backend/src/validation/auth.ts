import { z } from 'zod';

const phone = z.object({
  countryCode: z.string().regex(/^\+\d{1,4}$/),
  mobileNumber: z.string().regex(/^\d{6,15}$/),
});

export const otpRequestSchema = phone.extend({
  purpose: z.enum(['login', 'register']),
});

export const otpVerifySchema = phone.extend({
  purpose: z.enum(['login', 'register']),
  otp: z.string().length(4),
});

export const customerRegisterSchema = phone.extend({
  fullName: z.string().trim().min(2).max(120),
  email: z.email().optional().or(z.literal('')),
  city: z.string().trim().max(120).optional(),
  password: z.string().min(8).optional(),
});

/**
 * Owner registration creates a business account only — no shop is created.
 * `brandName` is optional (multi-location owners); shops are added later from
 * the owner dashboard. Accepts Flutter `ownerMobile` or API `mobileNumber`.
 */
export const ownerRegisterSchema = z
  .object({
    countryCode: z.string().regex(/^\+\d{1,4}$/),
    mobileNumber: z.string().regex(/^\d{6,15}$/).optional(),
    ownerMobile: z.string().regex(/^\d{6,15}$/).optional(),
    ownerFullName: z.string().trim().min(2).max(120),
    ownerEmail: z.email().optional().or(z.literal('')),
    brandName: z.string().trim().max(160).optional().or(z.literal('')),
    password: z.string().min(8).optional(),
  })
  .superRefine((value, ctx) => {
    if (!value.mobileNumber && !value.ownerMobile) {
      ctx.addIssue({
        code: 'custom',
        path: ['mobileNumber'],
        message: 'mobileNumber or ownerMobile is required',
      });
    }
  })
  .transform((value) => {
    const { ownerMobile, mobileNumber, ...rest } = value;
    return {
      ...rest,
      mobileNumber: (mobileNumber ?? ownerMobile) as string,
    };
  });

export const refreshSchema = z.object({
  refreshToken: z.string().min(20),
});

export const profileUpdateSchema = z
  .object({
    fullName: z.string().trim().min(2).max(120).optional(),
    email: z.email().optional().or(z.literal('')),
    city: z.string().trim().max(120).optional(),
    locale: z.enum(['en', 'hi', 'pa']).optional(),
  })
  .refine((v) => Object.keys(v).length > 0);
