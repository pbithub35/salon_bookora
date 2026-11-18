import { env } from '../config/env';

/**
 * OTP delivery integration point.
 * Dev mode returns the fixed code; production should call an SMS provider.
 */
export interface OtpDeliveryResult {
  delivered: boolean;
  /** Returned only when OTP_DEV_MODE=true for local testing. */
  devOtp?: string;
}

export async function deliverOtp(input: {
  countryCode: string;
  mobileNumber: string;
  code: string;
}): Promise<OtpDeliveryResult> {
  if (env.OTP_DEV_MODE) {
    return { delivered: true, devOtp: input.code };
  }

  // TODO: wire SMS/WhatsApp provider (Twilio, MSG91, etc.)
  // await smsClient.send(`${input.countryCode}${input.mobileNumber}`, `Your SalonBookora OTP is ${input.code}`);
  return { delivered: true };
}

export function generateOtpCode(): string {
  return env.OTP_DEV_MODE
    ? env.OTP_DEV_CODE
    : String(Math.floor(1000 + Math.random() * 9000));
}
