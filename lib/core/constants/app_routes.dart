/// Centralized route paths for SalonBookora (GoRouter).
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String roleSelect = '/role-select';
  static const String registerCustomer = '/register-customer';
  static const String registerOwner = '/register-owner';
  static const String otp = '/otp';
  static const String registrationSuccess = '/registration-success';
  static const String restrictedAccount = '/restricted';
  static const String customerShell = '/customer-shell';
  static const String ownerShell = '/owner-shell';
  static const String ownerShopCreate = '/owner-shell/shops/create';
  static const String ownerShopDetail = '/owner-shell/shops/:shopId';

  static String ownerShopDetailPath(String shopId) =>
      '/owner-shell/shops/$shopId';
}
