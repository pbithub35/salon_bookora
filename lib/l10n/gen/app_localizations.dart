import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('pa'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SalonBookora'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Salon Booking & Management'**
  String get appTagline;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0 Phase 1'**
  String get appVersion;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing your beauty experience...'**
  String get splashLoading;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover Top Salons'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Explore premium hair studios, luxury spas, and wellness centers near you with genuine customer ratings.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Instant Easy Booking'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Book appointments in seconds with your favorite stylists without waiting in long salon queues.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Your Beauty, Your Way'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Personalized grooming services, transparent pricing, hassle-free scheduling, and instant confirmations.'**
  String get onboardingDesc3;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SalonBookora'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book top-rated salons or grow your salon business with India’s leading salon platform.'**
  String get welcomeSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @termsNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get termsNotice;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to access your account.'**
  String get loginSubtitle;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit mobile number'**
  String get enterMobileNumber;

  /// No description provided for @requestOtp.
  ///
  /// In en, this message translates to:
  /// **'Request OTP'**
  String get requestOtp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @selectAccountType.
  ///
  /// In en, this message translates to:
  /// **'Choose Account Type'**
  String get selectAccountType;

  /// No description provided for @selectRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select how you would like to use SalonBookora'**
  String get selectRoleSubtitle;

  /// No description provided for @customerTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer / Client'**
  String get customerTitle;

  /// No description provided for @customerDesc.
  ///
  /// In en, this message translates to:
  /// **'Book salon appointments, discover stylists, and explore beauty treatments near you.'**
  String get customerDesc;

  /// No description provided for @salonOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Salon Owner / Partner'**
  String get salonOwnerTitle;

  /// No description provided for @salonOwnerDesc.
  ///
  /// In en, this message translates to:
  /// **'List your salon, manage staff & appointments, and expand your business. Get 3 Months Free Trial!'**
  String get salonOwnerDesc;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @customerRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Registration'**
  String get customerRegisterTitle;

  /// No description provided for @customerRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to start booking services.'**
  String get customerRegisterSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmail;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enterCity;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy'**
  String get agreeToTerms;

  /// No description provided for @ownerRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Salon Owner Registration'**
  String get ownerRegisterTitle;

  /// No description provided for @ownerRegisterFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Business Account'**
  String get ownerRegisterFormTitle;

  /// No description provided for @ownerRegisterFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to create your owner account. You can add shops, services and staff later from the dashboard.'**
  String get ownerRegisterFormSubtitle;

  /// No description provided for @brandNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Brand Name (Optional)'**
  String get brandNameLabel;

  /// No description provided for @hintBrandName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Looks Salon'**
  String get hintBrandName;

  /// No description provided for @businessAccount.
  ///
  /// In en, this message translates to:
  /// **'Business Account'**
  String get businessAccount;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Owner Details'**
  String get step1Title;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Salon Profile'**
  String get step2Title;

  /// No description provided for @salonName.
  ///
  /// In en, this message translates to:
  /// **'Salon Name'**
  String get salonName;

  /// No description provided for @enterSalonName.
  ///
  /// In en, this message translates to:
  /// **'Enter registered salon name'**
  String get enterSalonName;

  /// No description provided for @salonType.
  ///
  /// In en, this message translates to:
  /// **'Salon Type'**
  String get salonType;

  /// No description provided for @selectSalonType.
  ///
  /// In en, this message translates to:
  /// **'Select salon category'**
  String get selectSalonType;

  /// No description provided for @salonContact.
  ///
  /// In en, this message translates to:
  /// **'Salon Contact Number'**
  String get salonContact;

  /// No description provided for @salonAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get salonAddress;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'PIN Code'**
  String get pincode;

  /// No description provided for @salonEmail.
  ///
  /// In en, this message translates to:
  /// **'Salon Email (Optional)'**
  String get salonEmail;

  /// No description provided for @salonDescription.
  ///
  /// In en, this message translates to:
  /// **'Salon Description (Optional)'**
  String get salonDescription;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplication;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Mobile Number'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We have sent a 4-digit verification code to'**
  String get otpSubtitle;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-Digit OTP'**
  String get enterCode;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify & Proceed'**
  String get verifyOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendOtp;

  /// No description provided for @editNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Number'**
  String get editNumber;

  /// No description provided for @devOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Dev Mode: Default test OTP is 0000'**
  String get devOtpHint;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registrationSuccess;

  /// No description provided for @customerSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Your customer account is active. Welcome to SalonBookora!'**
  String get customerSuccessDesc;

  /// No description provided for @ownerSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Your business account is ready. Add your first shop to start taking bookings.'**
  String get ownerSuccessDesc;

  /// No description provided for @continueToPortal.
  ///
  /// In en, this message translates to:
  /// **'Go to Portal'**
  String get continueToPortal;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Under Review'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalDesc.
  ///
  /// In en, this message translates to:
  /// **'Thank you for registering your salon with SalonBookora! Our verification team is reviewing your documents and profile details. Applications are typically approved within 24-48 business hours.'**
  String get pendingApprovalDesc;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Approval Status'**
  String get checkStatus;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @rejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Not Approved'**
  String get rejectedTitle;

  /// No description provided for @rejectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, your salon application could not be approved at this time.'**
  String get rejectedDesc;

  /// No description provided for @rejectionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason provided by review team:'**
  String get rejectionReasonLabel;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @restrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Suspended'**
  String get restrictedTitle;

  /// No description provided for @restrictedDesc.
  ///
  /// In en, this message translates to:
  /// **'Access to this account has been temporarily restricted due to policy guidelines.'**
  String get restrictedDesc;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languagePunjabi.
  ///
  /// In en, this message translates to:
  /// **'ਪੰਜਾਬੀ'**
  String get languagePunjabi;

  /// No description provided for @onboardingBadge1.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM SALONS'**
  String get onboardingBadge1;

  /// No description provided for @onboardingBadge2.
  ///
  /// In en, this message translates to:
  /// **'INSTANT BOOKING'**
  String get onboardingBadge2;

  /// No description provided for @onboardingBadge3.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED STYLISTS'**
  String get onboardingBadge3;

  /// No description provided for @termsDialogBody.
  ///
  /// In en, this message translates to:
  /// **'SalonBookora Phase 1 Terms and Conditions.\n\n1. Acceptance of Terms: By accessing SalonBookora, you agree to these binding rules.\n2. Service Booking: Customers can book salon appointments subject to availability.\n3. Salon Partner Eligibility: Salon owners must provide accurate business info and undergo verification.\n4. Trial Period: Approved salon owners receive 3 months complimentary access.'**
  String get termsDialogBody;

  /// No description provided for @privacyDialogBody.
  ///
  /// In en, this message translates to:
  /// **'SalonBookora Privacy Policy.\n\nWe prioritize customer and salon partner data privacy. Mobile numbers are used solely for authentication and appointment confirmations. We never sell your personal information to third parties.'**
  String get privacyDialogBody;

  /// No description provided for @seedAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Dev Test Accounts (1-Tap Fill):'**
  String get seedAccountsTitle;

  /// No description provided for @seedCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get seedCustomer;

  /// No description provided for @seedOwnerPending.
  ///
  /// In en, this message translates to:
  /// **'Owner • Draft Shop'**
  String get seedOwnerPending;

  /// No description provided for @seedOwnerApproved.
  ///
  /// In en, this message translates to:
  /// **'Owner • Live Shops'**
  String get seedOwnerApproved;

  /// No description provided for @seedOwnerRejected.
  ///
  /// In en, this message translates to:
  /// **'Owner • New Account'**
  String get seedOwnerRejected;

  /// No description provided for @seedSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get seedSuspended;

  /// No description provided for @loginEnterPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get loginEnterPhoneTitle;

  /// No description provided for @loginEnterPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will send a 4-digit verification code to log you in.'**
  String get loginEnterPhoneSubtitle;

  /// No description provided for @roleHowToUseTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use SalonBookora?'**
  String get roleHowToUseTitle;

  /// No description provided for @roleHowToUseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your account type. You can easily manage bookings or grow your business.'**
  String get roleHowToUseSubtitle;

  /// No description provided for @freeTrialBadge.
  ///
  /// In en, this message translates to:
  /// **'3 MONTHS FREE TRIAL'**
  String get freeTrialBadge;

  /// No description provided for @hintFullName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Aarav Sharma'**
  String get hintFullName;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'e.g. aarav@example.com'**
  String get hintEmail;

  /// No description provided for @hintCity.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mohali, Chandigarh'**
  String get hintCity;

  /// No description provided for @continueToOtp.
  ///
  /// In en, this message translates to:
  /// **'Continue to OTP Verification'**
  String get continueToOtp;

  /// No description provided for @stepOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get stepOwner;

  /// No description provided for @stepSalon.
  ///
  /// In en, this message translates to:
  /// **'Salon'**
  String get stepSalon;

  /// No description provided for @step1OwnerProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Owner Profile'**
  String get step1OwnerProfileTitle;

  /// No description provided for @step1OwnerProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the salon owner or business manager details.'**
  String get step1OwnerProfileSubtitle;

  /// No description provided for @ownerFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Full Name *'**
  String get ownerFullNameLabel;

  /// No description provided for @hintOwnerName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Simran Kaur'**
  String get hintOwnerName;

  /// No description provided for @ownerMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Mobile Number *'**
  String get ownerMobileLabel;

  /// No description provided for @ownerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Email Address *'**
  String get ownerEmailLabel;

  /// No description provided for @hintOwnerEmail.
  ///
  /// In en, this message translates to:
  /// **'e.g. simran@gmail.com'**
  String get hintOwnerEmail;

  /// No description provided for @validationOwnerEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner email is required'**
  String get validationOwnerEmailRequired;

  /// No description provided for @nextSalonDetails.
  ///
  /// In en, this message translates to:
  /// **'Next: Salon Business Details'**
  String get nextSalonDetails;

  /// No description provided for @step2SalonDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Salon Details'**
  String get step2SalonDetailsTitle;

  /// No description provided for @step2SalonDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide salon brand & location information.'**
  String get step2SalonDetailsSubtitle;

  /// No description provided for @editStep1.
  ///
  /// In en, this message translates to:
  /// **'Edit Step 1'**
  String get editStep1;

  /// No description provided for @hintSalonName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Glow Unisex Studio'**
  String get hintSalonName;

  /// No description provided for @hintSalonContact.
  ///
  /// In en, this message translates to:
  /// **'e.g. 98765 43211'**
  String get hintSalonContact;

  /// No description provided for @hintAddress.
  ///
  /// In en, this message translates to:
  /// **'SCO / Plot No., Sector, Street'**
  String get hintAddress;

  /// No description provided for @hintSalonCity.
  ///
  /// In en, this message translates to:
  /// **'Mohali'**
  String get hintSalonCity;

  /// No description provided for @hintSalonState.
  ///
  /// In en, this message translates to:
  /// **'Punjab'**
  String get hintSalonState;

  /// No description provided for @hintSalonEmail.
  ///
  /// In en, this message translates to:
  /// **'contact@glowsalon.com'**
  String get hintSalonEmail;

  /// No description provided for @hintSalonDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of services, hygiene standards & features...'**
  String get hintSalonDescription;

  /// No description provided for @accountActivated.
  ///
  /// In en, this message translates to:
  /// **'Account Activated'**
  String get accountActivated;

  /// No description provided for @applicationReceived.
  ///
  /// In en, this message translates to:
  /// **'Business Account Created'**
  String get applicationReceived;

  /// No description provided for @customerSuccessNote.
  ///
  /// In en, this message translates to:
  /// **'You can now explore top rated salons, book haircuts, spa treatments, and manage appointments.'**
  String get customerSuccessNote;

  /// No description provided for @ownerSuccessNote.
  ///
  /// In en, this message translates to:
  /// **'From your dashboard you can create shops, add services and staff, set offers, and configure booking rules.'**
  String get ownerSuccessNote;

  /// No description provided for @badgeApplicationUnderReview.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION UNDER REVIEW'**
  String get badgeApplicationUnderReview;

  /// No description provided for @badgeApplicationNotApproved.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION NOT APPROVED'**
  String get badgeApplicationNotApproved;

  /// No description provided for @badgeAccountRestricted.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT ACCESS RESTRICTED'**
  String get badgeAccountRestricted;

  /// No description provided for @badgePendingReview.
  ///
  /// In en, this message translates to:
  /// **'PENDING REVIEW'**
  String get badgePendingReview;

  /// No description provided for @badgeApproved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get badgeApproved;

  /// No description provided for @badgeApplicationRejected.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION REJECTED'**
  String get badgeApplicationRejected;

  /// No description provided for @badgeRestricted.
  ///
  /// In en, this message translates to:
  /// **'RESTRICTED'**
  String get badgeRestricted;

  /// No description provided for @badgeActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get badgeActive;

  /// No description provided for @badgeVerifiedPartner.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED PARTNER'**
  String get badgeVerifiedPartner;

  /// No description provided for @partnerSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Salon Partner Support'**
  String get partnerSupportTitle;

  /// No description provided for @supportResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Response within 24 business hours'**
  String get supportResponseTime;

  /// No description provided for @supportHours.
  ///
  /// In en, this message translates to:
  /// **'Mon - Sat: 9:00 AM - 7:00 PM'**
  String get supportHours;

  /// No description provided for @supportTollFree.
  ///
  /// In en, this message translates to:
  /// **'+91 1800 200 4000 (Toll Free)'**
  String get supportTollFree;

  /// No description provided for @rejectionFallbackReason.
  ///
  /// In en, this message translates to:
  /// **'Uploaded business documents or address details could not be validated. Please reach out to our partner support team for clarification.'**
  String get rejectionFallbackReason;

  /// No description provided for @rejectedHelpText.
  ///
  /// In en, this message translates to:
  /// **'If you believe this decision was made in error or have updated documents, please contact our partner operations desk.'**
  String get rejectedHelpText;

  /// No description provided for @accessSuspended.
  ///
  /// In en, this message translates to:
  /// **'Access Suspended'**
  String get accessSuspended;

  /// No description provided for @restrictedHelpText.
  ///
  /// In en, this message translates to:
  /// **'If you believe this restriction was placed mistakenly, please get in touch with our security and operations compliance team.'**
  String get restrictedHelpText;

  /// No description provided for @contactSecurityTeam.
  ///
  /// In en, this message translates to:
  /// **'Contact Security Team'**
  String get contactSecurityTeam;

  /// No description provided for @supportRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Request'**
  String get supportRequestTitle;

  /// No description provided for @supportRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'A security appeal has been submitted to support@salonbookora.com.'**
  String get supportRequestMessage;

  /// No description provided for @infoOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get infoOwnerName;

  /// No description provided for @infoContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get infoContactNumber;

  /// No description provided for @infoLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get infoLocation;

  /// No description provided for @infoEstimatedReview.
  ///
  /// In en, this message translates to:
  /// **'Estimated Review'**
  String get infoEstimatedReview;

  /// No description provided for @infoReviewDuration.
  ///
  /// In en, this message translates to:
  /// **'24 - 48 Hours'**
  String get infoReviewDuration;

  /// No description provided for @roleCustomerShort.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomerShort;

  /// No description provided for @roleOwnerShort.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwnerShort;

  /// No description provided for @logoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTooltip;

  /// No description provided for @tabMyAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get tabMyAppointments;

  /// No description provided for @tabSavedSalons.
  ///
  /// In en, this message translates to:
  /// **'Saved Salons'**
  String get tabSavedSalons;

  /// No description provided for @tabAppointmentsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Appointments Calendar'**
  String get tabAppointmentsCalendar;

  /// No description provided for @tabServicesPricing.
  ///
  /// In en, this message translates to:
  /// **'Services & Pricing'**
  String get tabServicesPricing;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search salon, haircuts, spas or stylists...'**
  String get searchHint;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @catHaircut.
  ///
  /// In en, this message translates to:
  /// **'Haircut'**
  String get catHaircut;

  /// No description provided for @catSpaMassage.
  ///
  /// In en, this message translates to:
  /// **'Spa & Massage'**
  String get catSpaMassage;

  /// No description provided for @catFacialGlow.
  ///
  /// In en, this message translates to:
  /// **'Facial & Glow'**
  String get catFacialGlow;

  /// No description provided for @catBeardGrooming.
  ///
  /// In en, this message translates to:
  /// **'Beard Grooming'**
  String get catBeardGrooming;

  /// No description provided for @catNails.
  ///
  /// In en, this message translates to:
  /// **'Nails & Manicure'**
  String get catNails;

  /// No description provided for @featuredSalonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured Salons Near You'**
  String get featuredSalonsTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @promoFirstVisit.
  ///
  /// In en, this message translates to:
  /// **'20% OFF FIRST VISIT'**
  String get promoFirstVisit;

  /// No description provided for @promoTrending.
  ///
  /// In en, this message translates to:
  /// **'TRENDING SALON'**
  String get promoTrending;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @phase1ShellCustomerNote.
  ///
  /// In en, this message translates to:
  /// **'Phase 1 Shell: Booking & Catalog workflows will be activated in Phase 2.'**
  String get phase1ShellCustomerNote;

  /// No description provided for @phase1ShellOwnerNote.
  ///
  /// In en, this message translates to:
  /// **'Phase 1 Shell: Comprehensive calendar, booking management and invoicing features will arrive in Phase 2.'**
  String get phase1ShellOwnerNote;

  /// No description provided for @profileMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get profileMobile;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @freeTrialLabel.
  ///
  /// In en, this message translates to:
  /// **'3 Months Free Trial'**
  String get freeTrialLabel;

  /// No description provided for @trialNote.
  ///
  /// In en, this message translates to:
  /// **'Complimentary partner access active until 90 days from approval.'**
  String get trialNote;

  /// No description provided for @businessOverview.
  ///
  /// In en, this message translates to:
  /// **'Business Overview'**
  String get businessOverview;

  /// No description provided for @metricTodaysBookings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Bookings'**
  String get metricTodaysBookings;

  /// No description provided for @metricRevenueToday.
  ///
  /// In en, this message translates to:
  /// **'Revenue Today'**
  String get metricRevenueToday;

  /// No description provided for @metricActiveStylists.
  ///
  /// In en, this message translates to:
  /// **'Active Stylists'**
  String get metricActiveStylists;

  /// No description provided for @metricSalonRating.
  ///
  /// In en, this message translates to:
  /// **'Salon Rating'**
  String get metricSalonRating;

  /// No description provided for @quickManagement.
  ///
  /// In en, this message translates to:
  /// **'Quick Management'**
  String get quickManagement;

  /// No description provided for @actionManageServices.
  ///
  /// In en, this message translates to:
  /// **'Manage Services & Pricing'**
  String get actionManageServices;

  /// No description provided for @actionManageServicesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add haircut, spa packages and treatment prices'**
  String get actionManageServicesDesc;

  /// No description provided for @actionStaffScheduling.
  ///
  /// In en, this message translates to:
  /// **'Staff Scheduling'**
  String get actionStaffScheduling;

  /// No description provided for @actionStaffSchedulingDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure working hours and barber shifts'**
  String get actionStaffSchedulingDesc;

  /// No description provided for @actionSalonProfile.
  ///
  /// In en, this message translates to:
  /// **'Salon Business Profile'**
  String get actionSalonProfile;

  /// No description provided for @profileOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get profileOwnerName;

  /// No description provided for @profileOwnerPhone.
  ///
  /// In en, this message translates to:
  /// **'Owner Phone'**
  String get profileOwnerPhone;

  /// No description provided for @profileCityState.
  ///
  /// In en, this message translates to:
  /// **'City & State'**
  String get profileCityState;

  /// No description provided for @selectCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Select Country Code'**
  String get selectCountryCode;

  /// No description provided for @validationMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get validationMobileRequired;

  /// No description provided for @validationMobileInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get validationMobileInvalid;

  /// No description provided for @validationFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get validationFullNameRequired;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get validationNameTooShort;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationPincodeRequired.
  ///
  /// In en, this message translates to:
  /// **'PIN code is required'**
  String get validationPincodeRequired;

  /// No description provided for @validationPincodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'PIN code must be 6 digits'**
  String get validationPincodeInvalid;

  /// No description provided for @termsRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms Required'**
  String get termsRequiredTitle;

  /// No description provided for @termsRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms of Service and Privacy Policy to proceed.'**
  String get termsRequiredMessage;

  /// No description provided for @unableToSendOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to Send OTP'**
  String get unableToSendOtpTitle;

  /// No description provided for @unableToResendOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to Resend OTP'**
  String get unableToResendOtpTitle;

  /// No description provided for @otpSentTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent'**
  String get otpSentTitle;

  /// No description provided for @otpResentMessage.
  ///
  /// In en, this message translates to:
  /// **'A new 4-digit verification code has been sent.'**
  String get otpResentMessage;

  /// No description provided for @incompleteCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Incomplete Code'**
  String get incompleteCodeTitle;

  /// No description provided for @incompleteCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 4 digits of the verification code.'**
  String get incompleteCodeMessage;

  /// No description provided for @loginFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailedTitle;

  /// No description provided for @registrationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registrationFailedTitle;

  /// No description provided for @defaultCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get defaultCustomerName;

  /// No description provided for @defaultOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Salon Owner'**
  String get defaultOwnerName;

  /// No description provided for @defaultSalonName.
  ///
  /// In en, this message translates to:
  /// **'Salon'**
  String get defaultSalonName;

  /// No description provided for @statusCheckedTitle.
  ///
  /// In en, this message translates to:
  /// **'Status Checked'**
  String get statusCheckedTitle;

  /// No description provided for @statusStillUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your application is still under review by our verification team.'**
  String get statusStillUnderReview;

  /// No description provided for @errNoInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet'**
  String get errNoInternetTitle;

  /// No description provided for @errTimeoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Timeout'**
  String get errTimeoutTitle;

  /// No description provided for @errNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get errNetworkTitle;

  /// No description provided for @errServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get errServerTitle;

  /// No description provided for @errSessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get errSessionExpiredTitle;

  /// No description provided for @errAccountNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Not Found'**
  String get errAccountNotFoundTitle;

  /// No description provided for @errInvalidOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get errInvalidOtpTitle;

  /// No description provided for @errNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get errNotFoundTitle;

  /// No description provided for @errGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errGenericTitle;

  /// No description provided for @errNoInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errNoInternetMessage;

  /// No description provided for @errTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errTimeoutMessage;

  /// No description provided for @errNetworkMessage.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get errNetworkMessage;

  /// No description provided for @errServerMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again.'**
  String get errServerMessage;

  /// No description provided for @errSessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get errSessionExpiredMessage;

  /// No description provided for @errAccountNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No account found with this number. Please register first.'**
  String get errAccountNotFoundMessage;

  /// No description provided for @errNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Requested resource was not found.'**
  String get errNotFoundMessage;

  /// No description provided for @greetingHello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String greetingHello(String name);

  /// No description provided for @partnerPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner Portal • {name}'**
  String partnerPortalTitle(String name);

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(int seconds);

  /// No description provided for @validationFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationFieldRequired(String field);

  /// No description provided for @navShops.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get navShops;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get navTeam;

  /// No description provided for @shopsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Shops'**
  String get shopsTitle;

  /// No description provided for @shopsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No shops yet'**
  String get shopsEmptyTitle;

  /// No description provided for @shopsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first shop to manage services, team, and bookings.'**
  String get shopsEmptySubtitle;

  /// No description provided for @addShop.
  ///
  /// In en, this message translates to:
  /// **'Add shop'**
  String get addShop;

  /// No description provided for @createShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Create shop'**
  String get createShopTitle;

  /// No description provided for @saveShop.
  ///
  /// In en, this message translates to:
  /// **'Save shop'**
  String get saveShop;

  /// No description provided for @shopSaved.
  ///
  /// In en, this message translates to:
  /// **'Shop created successfully'**
  String get shopSaved;

  /// No description provided for @shopDetails.
  ///
  /// In en, this message translates to:
  /// **'Shop details'**
  String get shopDetails;

  /// No description provided for @shopServicesPrices.
  ///
  /// In en, this message translates to:
  /// **'Services & prices'**
  String get shopServicesPrices;

  /// No description provided for @shopMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get shopMembers;

  /// No description provided for @shopHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get shopHours;

  /// No description provided for @shopBookingPage.
  ///
  /// In en, this message translates to:
  /// **'Booking page'**
  String get shopBookingPage;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeMember;

  /// No description provided for @memberName.
  ///
  /// In en, this message translates to:
  /// **'Member name'**
  String get memberName;

  /// No description provided for @memberRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get memberRole;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleSubAdmin.
  ///
  /// In en, this message translates to:
  /// **'Sub-admin'**
  String get roleSubAdmin;

  /// No description provided for @roleStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get roleStaff;

  /// No description provided for @permManageBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage bookings'**
  String get permManageBookings;

  /// No description provided for @permManageServices.
  ///
  /// In en, this message translates to:
  /// **'Manage services'**
  String get permManageServices;

  /// No description provided for @permManageStaff.
  ///
  /// In en, this message translates to:
  /// **'Manage staff'**
  String get permManageStaff;

  /// No description provided for @permManageShopSettings.
  ///
  /// In en, this message translates to:
  /// **'Manage shop settings'**
  String get permManageShopSettings;

  /// No description provided for @memberAdded.
  ///
  /// In en, this message translates to:
  /// **'Member added'**
  String get memberAdded;

  /// No description provided for @memberRemoved.
  ///
  /// In en, this message translates to:
  /// **'Member removed'**
  String get memberRemoved;

  /// No description provided for @cannotRemoveOwner.
  ///
  /// In en, this message translates to:
  /// **'The owner cannot be removed'**
  String get cannotRemoveOwner;

  /// No description provided for @comingSoonCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar management is coming soon.'**
  String get comingSoonCalendar;

  /// No description provided for @comingSoonTeam.
  ///
  /// In en, this message translates to:
  /// **'Cross-shop team overview is coming soon. Manage members inside each shop.'**
  String get comingSoonTeam;

  /// No description provided for @bookingPageLink.
  ///
  /// In en, this message translates to:
  /// **'Public booking link'**
  String get bookingPageLink;

  /// No description provided for @bookingPagePreviewOnly.
  ///
  /// In en, this message translates to:
  /// **'Preview only. A public booking link will be available when publishing is connected.'**
  String get bookingPagePreviewOnly;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Booking link copied'**
  String get linkCopied;

  /// No description provided for @noServicesYet.
  ///
  /// In en, this message translates to:
  /// **'No services added yet'**
  String get noServicesYet;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get addService;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceName;

  /// No description provided for @serviceCategory.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get serviceCategory;

  /// No description provided for @serviceDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get serviceDuration;

  /// No description provided for @servicePrice.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get servicePrice;

  /// No description provided for @validationPositiveDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter a duration greater than zero'**
  String get validationPositiveDuration;

  /// No description provided for @validationPositivePrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a price greater than zero'**
  String get validationPositivePrice;

  /// No description provided for @invalidOpeningHours.
  ///
  /// In en, this message translates to:
  /// **'Closing time must be later than opening time'**
  String get invalidOpeningHours;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editMember.
  ///
  /// In en, this message translates to:
  /// **'Edit member'**
  String get editMember;

  /// No description provided for @saveMember.
  ///
  /// In en, this message translates to:
  /// **'Save member'**
  String get saveMember;

  /// No description provided for @memberPhoneAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'A member with this phone number already exists in this shop'**
  String get memberPhoneAlreadyUsed;

  /// No description provided for @staffServices.
  ///
  /// In en, this message translates to:
  /// **'Services this staff member can perform'**
  String get staffServices;

  /// No description provided for @staffServicesHint.
  ///
  /// In en, this message translates to:
  /// **'Select every service they can be booked for.'**
  String get staffServicesHint;

  /// No description provided for @noServicesToAssign.
  ///
  /// In en, this message translates to:
  /// **'Add services to this shop before assigning them to staff.'**
  String get noServicesToAssign;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @openHours.
  ///
  /// In en, this message translates to:
  /// **'{open} – {close}'**
  String openHours(String open, String close);

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get shopName;

  /// No description provided for @shopType.
  ///
  /// In en, this message translates to:
  /// **'Shop type'**
  String get shopType;

  /// No description provided for @shopPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get shopPhone;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address line 1'**
  String get addressLine1;

  /// No description provided for @addressLine2.
  ///
  /// In en, this message translates to:
  /// **'Address line 2 / landmark'**
  String get addressLine2;

  /// No description provided for @shopEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Shop email (optional)'**
  String get shopEmailOptional;

  /// No description provided for @shopDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Shop description (optional)'**
  String get shopDescriptionOptional;

  /// No description provided for @websiteOptional.
  ///
  /// In en, this message translates to:
  /// **'Website (optional)'**
  String get websiteOptional;

  /// No description provided for @socialLinksOptional.
  ///
  /// In en, this message translates to:
  /// **'Social links (optional)'**
  String get socialLinksOptional;

  /// No description provided for @gstinOptional.
  ///
  /// In en, this message translates to:
  /// **'GSTIN (optional)'**
  String get gstinOptional;

  /// No description provided for @gstinHint.
  ///
  /// In en, this message translates to:
  /// **'You can add GSTIN later in business settings'**
  String get gstinHint;

  /// No description provided for @stepShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Shop details'**
  String get stepShopDetails;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;

  /// No description provided for @stepHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get stepHours;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get nextStep;

  /// No description provided for @backStep.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backStep;

  /// No description provided for @copyHoursToAll.
  ///
  /// In en, this message translates to:
  /// **'Copy Mon hours to all open days'**
  String get copyHoursToAll;

  /// No description provided for @hoursCopied.
  ///
  /// In en, this message translates to:
  /// **'Hours copied to open days'**
  String get hoursCopied;

  /// No description provided for @mapPinOptional.
  ///
  /// In en, this message translates to:
  /// **'Map location (optional)'**
  String get mapPinOptional;

  /// No description provided for @setMapPin.
  ///
  /// In en, this message translates to:
  /// **'Drop a pin'**
  String get setMapPin;

  /// No description provided for @clearMapPin.
  ///
  /// In en, this message translates to:
  /// **'Remove pin'**
  String get clearMapPin;

  /// No description provided for @mapPinSet.
  ///
  /// In en, this message translates to:
  /// **'Pin saved — you can change it later'**
  String get mapPinSet;

  /// No description provided for @mapPinSkipped.
  ///
  /// In en, this message translates to:
  /// **'No map pin — you can continue without it'**
  String get mapPinSkipped;

  /// No description provided for @addLogo.
  ///
  /// In en, this message translates to:
  /// **'Add logo'**
  String get addLogo;

  /// No description provided for @addCoverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add cover photo'**
  String get addCoverPhoto;

  /// No description provided for @mediaSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get mediaSelected;

  /// No description provided for @mediaLater.
  ///
  /// In en, this message translates to:
  /// **'Upload later'**
  String get mediaLater;

  /// No description provided for @setupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Setup in progress'**
  String get setupInProgress;

  /// No description provided for @shopReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get shopReady;

  /// No description provided for @setupProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop setup progress'**
  String get setupProgressTitle;

  /// No description provided for @setupProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} steps complete'**
  String setupProgressSubtitle(int done, int total);

  /// No description provided for @actionAddServices.
  ///
  /// In en, this message translates to:
  /// **'Add services'**
  String get actionAddServices;

  /// No description provided for @actionAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get actionAddMembers;

  /// No description provided for @actionReviewBookingPage.
  ///
  /// In en, this message translates to:
  /// **'Review booking page'**
  String get actionReviewBookingPage;

  /// No description provided for @openTime.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get openTime;

  /// No description provided for @closeTime.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get closeTime;

  /// No description provided for @atLeastOneOpenDay.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one day open'**
  String get atLeastOneOpenDay;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'pa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'pa':
      return AppLocalizationsPa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
