/// Centralized Configuration and Seed Constants for SalonBookora
class AppConstants {
  AppConstants._();

  // Storage Keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserRole = 'user_role';
  static const String keyUserStatus = 'user_status';
  static const String keyUserData = 'user_data';
  static const String keyBusinessData = 'business_data';
  // Legacy key — cleared on logout for sessions stored before the
  // salon-application model was replaced by business accounts.
  static const String keySalonData = 'salon_data';
  static const String keySelectedLocale = 'selected_locale';

  /// Remote API. Override with:
  /// `--dart-define=USE_REMOTE_AUTH=true`
  /// `--dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1`
  static const bool useRemoteAuth = bool.fromEnvironment(
    'USE_REMOTE_AUTH',
    defaultValue: false,
  );
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  // Seed / Test Mobile Numbers (for easy testing as per spec Section 12.1)
  static const String seedCustomerMobile = '9876543210';
  static const String seedOwnerPendingMobile = '9876543220';
  static const String seedOwnerApprovedMobile = '9876543230';
  static const String seedOwnerRejectedMobile = '9876543240';
  static const String seedSuspendedMobile = '9876543250';

  // Test OTP
  static const String devOtp = '0000';

  // Salon Types (registration / legacy)
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

  /// Shop types for owner "Add shop" flow.
  static const List<String> shopTypes = [
    'Salon',
    'Barber',
    'Spa',
    'Nail studio',
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
