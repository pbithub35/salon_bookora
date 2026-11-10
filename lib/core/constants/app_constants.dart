/// Centralized Configuration and Seed Constants for SalonBookora
class AppConstants {
  AppConstants._();

  // Storage Keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserRole = 'user_role';
  static const String keyUserStatus = 'user_status';
  static const String keyUserData = 'user_data';
  static const String keySalonData = 'salon_data';
  static const String keySelectedLocale = 'selected_locale';

  // Seed / Test Mobile Numbers (for easy testing as per spec Section 12.1)
  static const String seedCustomerMobile = '9876543210';
  static const String seedOwnerPendingMobile = '9876543220';
  static const String seedOwnerApprovedMobile = '9876543230';
  static const String seedOwnerRejectedMobile = '9876543240';
  static const String seedSuspendedMobile = '9876543250';

  // Test OTP
  static const String devOtp = '0000';

  // Salon Types
  static const List<String> salonTypes = [
    'Unisex Salon',
    "Men's Salon",
    "Women's Salon",
    'Beauty Parlour',
    'Spa & Wellness',
    'Hair Studio',
    'Skin & Beauty Clinic',
    'Nail Studio',
    'Other',
  ];

  // Country Codes
  static const List<Map<String, String>> countryCodes = [
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
    {'code': '+971', 'name': 'UAE', 'flag': '🇦🇪'},
    {'code': '+61', 'name': 'Australia', 'flag': '🇦🇺'},
  ];
}
