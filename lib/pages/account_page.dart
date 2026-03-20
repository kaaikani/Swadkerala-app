import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/referral/referral_controller.dart';
import '../services/graphql_client.dart';
import '../services/channel_service.dart';
import '../controllers/theme_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../services/in_app_update_service.dart';
import '../widgets/snackbar.dart';
import '../theme/theme.dart';
import '../utils/responsive.dart';
import '../utils/google_auth_env.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../graphql/Customer.graphql.dart';
import '../theme/colors.dart';
import 'orders_page.dart';
import '../utils/analytics_helper.dart';
import '../services/analytics_service.dart';
import '../routes.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final CustomerController customerController = Get.put(CustomerController());
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.put(ThemeController());
  final UtilityController utilityController = Get.find();
  final InAppUpdateService _updateService = InAppUpdateService();
  final ReferralController referralController = Get.put(ReferralController());
  final GlobalKey _shareReferralKey = GlobalKey();
  final GlobalKey _shareAppKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'Account');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Only fetch customer data if user is authenticated
      if (_isUserAuthenticated()) {
        await customerController.getActiveCustomer();
        // Load referral redeemed status for this customer
        final cid = customerController.activeCustomer.value?.id;
        if (cid != null) referralController.loadRedeemedStatus(cid);
        // Fetch referral data
        referralController.fetchMyReferrals();
        referralController.fetchEarnedScratchCards();
        referralController.fetchChannelPoints();
        // Check for invalid email or missing phone number after customer data loads
     _checkAndShowUpdateDialogs();
      }
      _updateService.checkAndShowFlexibleUpdateInAccount(context);
    });
  }

  /// Check if email is a valid Gmail address
  bool _isValidGmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email.toLowerCase());
  }

  /// Check and show dialogs for invalid email or missing phone number
  /// For CITY (and other) channels only; BRAND channels show these dialogs on the home page.
  void _checkAndShowUpdateDialogs() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    // Only show update email/phone dialogs on account page for non-BRAND (CITY and other) channels
    final channelType = ChannelService.getChannelType()?.toUpperCase() ?? '';
    if (channelType.contains('BRAND')) return;

    // Check if email is not a valid Gmail
    final isValidEmail = _isValidGmail(customer.emailAddress);
    
    if (!isValidEmail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showUpdateEmailDialog();
        }
      });
      return; // Don't check phone if email dialog is shown
    }

    // Check if phone number is null
    final hasPhone = customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty;
    
    if (!hasPhone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showUpdatePhoneDialog();
        }
      });
    } else {
    }
  }

  /// Show dialog to update email address
  void _showUpdateEmailDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    // Clear any previous error
    customerController.emailUpdateError.value = '';

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent closing by back button
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isLoading = false;
              final emailController = TextEditingController();

              return Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: ResponsiveUtils.rp(28),
                          color: AppColors.button,
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          child: Text(
                            'Update Email Address',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(20),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Close button (X mark)
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            size: ResponsiveUtils.rp(24),
                            color: AppColors.textSecondary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(20)),
                    Text(
                      'Sign in with Google to set your email address',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    // Show error message if available
                    Obx(() {
                      final errorMsg = customerController.emailUpdateError.value;
                      if (errorMsg.isNotEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                          padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.error,
                                size: ResponsiveUtils.rp(20),
                              ),
                              SizedBox(width: ResponsiveUtils.rp(8)),
                              Expanded(
                                child: Text(
                                  errorMsg,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(13),
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    // Google Sign-In Button (only option)
                    SizedBox(
                      width: double.infinity,
                      child: AbsorbPointer(
                        absorbing: isLoading,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await _handleGoogleSignInForEmail(context, setState, emailController, () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          icon: isLoading
                            ? SizedBox(
                                width: ResponsiveUtils.rp(20),
                                height: ResponsiveUtils.rp(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                                ),
                              )
                            : Image.asset(
                                'assets/images/google_logo.png',
                                width: ResponsiveUtils.rp(24),
                                height: ResponsiveUtils.rp(24),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.login,
                                    size: ResponsiveUtils.rp(20),
                                    color: AppColors.button,
                                  );
                                },
                              ),
                        label: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(16),
                            fontWeight: FontWeight.w600,
                            color: AppColors.button,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.button,
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(16),
                            vertical: ResponsiveUtils.rp(14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                          ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }

  /// Handle Google Sign-In specifically for email retrieval
  /// This only requests email scope, not full authentication
  Future<void> _handleGoogleSignInForEmail(
    BuildContext context,
    StateSetter setState,
    TextEditingController emailController,
    VoidCallback onComplete,
  ) async {
    setState(() {
      customerController.emailUpdateError.value = '';
    });

    try {
      // Google Auth: from .env via GoogleAuthEnv
      final googleClientId = GoogleAuthEnv.googleClientId;
      if (googleClientId == null || googleClientId.isEmpty) {
        setState(() {
          customerController.emailUpdateError.value = 'Google Client ID not configured';
        });
        onComplete();
        return;
      }
      if (!GoogleAuthEnv.isIosConfigValid) {
        setState(() {
          customerController.emailUpdateError.value =
              'Set GOOGLE_CLIENT_ID_IOS in .env for iOS (iOS OAuth client). See docs/GOOGLE_AUTH_SETUP.md.';
        });
        onComplete();
        return;
      }
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: googleClientId,
        clientId: GoogleAuthEnv.clientIdForPlatform,
        scopes: ['email'],
      );

      // Sign out any existing Google account to force account selection
      try {
        final currentUser = await googleSignIn.signInSilently();
        if (currentUser != null) {
          await googleSignIn.signOut();
        }
      } catch (e) {
        // Try to sign out anyway
        try {
          await googleSignIn.signOut();
        } catch (signOutError) {
          // Ignore sign out errors
        }
      }

      // Sign in with Google - this will show account picker
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        // Handle cancellation or other sign-in errors
        final errorStr = e.toString().toLowerCase();

        // Check for cancellation
        if (errorStr.contains('canceled') ||
            errorStr.contains('cancelled') ||
            errorStr.contains('sign_in_canceled') ||
            errorStr.contains('sign_in_cancelled') ||
            errorStr.contains('12501')) {
          // User cancelled, just return without error
          onComplete();
          return;
        }

        // Check for developer error (error code 10)
        final hasError10 = errorStr.contains('apiexception: 10') ||
            errorStr.contains('apiException: 10') ||
            errorStr.contains('apiexception:10') ||
            errorStr.contains('error 10') ||
            errorStr.contains('developer_error') ||
            errorStr.contains(': 10:') ||
            errorStr.contains(': 10 ') ||
            RegExp(r'apiexception.*10|error.*10').hasMatch(errorStr);

        if (hasError10) {
          setState(() {
            customerController.emailUpdateError.value =
                'Google Sign-In Configuration Error. Please contact support.';
          });
          onComplete();
          return;
        }

        // For other errors
        setState(() {
          customerController.emailUpdateError.value = 'Failed to sign in with Google. Please try again.';
        });
        onComplete();
        return;
      }

      if (googleUser == null) {
        // User cancelled the sign in
        onComplete();
        return;
      }

      // Extract email from Google account
      final email = googleUser.email;
      if (email.isEmpty) {
        setState(() {
          customerController.emailUpdateError.value = 'Failed to get email address from Google account';
        });
        onComplete();
        return;
      }

      // Validate that it's a Gmail address
      if (!_isValidGmail(email)) {
        setState(() {
          customerController.emailUpdateError.value = 'Please use a Gmail address (@gmail.com)';
        });
        onComplete();
        return;
      }

      // Populate the text field with the email from Google
      setState(() {
        emailController.text = email;
        customerController.emailUpdateError.value = '';
      });

      // Automatically update the email
      final success = await customerController.updateCustomerEmail(email);

      onComplete();

      if (success) {
        // Close dialog and show success message
        Get.back();
        showSuccessSnackbar('Email updated successfully');
        // Check for phone number after email is updated
        _checkAndShowUpdateDialogs();
      } else {
        // Error message is already set in controller and will be shown in UI
        // Don't show snackbar as error is displayed in dialog
      }
    } catch (e) {
      // Check if it's a cancellation
      final errorStr = e.toString().toLowerCase();
      final isCancellation = errorStr.contains('canceled') ||
          errorStr.contains('cancelled') ||
          errorStr.contains('sign_in_canceled') ||
          errorStr.contains('sign_in_cancelled') ||
          errorStr.contains('12501');

      if (isCancellation) {
        onComplete();
        return;
      }

      // Check for developer error
      final isDeveloperError = errorStr.contains('apiexception: 10') ||
          errorStr.contains('apiException: 10') ||
          errorStr.contains('apiexception:10') ||
          errorStr.contains('error 10') ||
          errorStr.contains('developer_error') ||
          errorStr.contains(': 10:') ||
          errorStr.contains(': 10 ') ||
          RegExp(r'apiexception.*10|error.*10').hasMatch(errorStr);

      if (isDeveloperError) {
        setState(() {
          customerController.emailUpdateError.value =
              'Google Sign-In Configuration Error. Please contact support.';
        });
        onComplete();
        return;
      }

      // For other errors
      setState(() {
        customerController.emailUpdateError.value = 'Failed to sign in with Google. Please try again.';
      });
      onComplete();
    }
  }

  /// Show dialog to update phone number
  void _showUpdatePhoneDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final phoneController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent closing by back button
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: ResponsiveUtils.rp(28),
                        color: AppColors.button,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: Text(
                          'Update Phone Number',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Text(
                    'Please enter your phone number',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  // Error message display
                  if (errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(12),
                        vertical: ResponsiveUtils.rp(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: ResponsiveUtils.rp(18),
                            color: AppColors.error,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(13),
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                  ],
                  TextField(
                    controller: phoneController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter 10 digit phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(
                          color: errorMessage != null 
                              ? AppColors.error 
                              : AppColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(
                          color: errorMessage != null 
                              ? AppColors.error 
                              : AppColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        borderSide: BorderSide(
                          color: errorMessage != null 
                              ? AppColors.error 
                              : AppColors.button, 
                          width: 2,
                        ),
                      ),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      // Clear error when user starts typing
                      if (errorMessage != null) {
                        setState(() {
                          errorMessage = null;
                        });
                      }
                      // Validate on change - show error if non-digit characters are entered
                      if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        setState(() {
                          errorMessage = 'Only numbers are allowed';
                        });
                      }
                    },
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          
                          final phone = phoneController.text.trim();
                          
                          if (phone.isEmpty) {
                            setState(() {
                              errorMessage = 'Please enter a phone number';
                            });
                            return;
                          }
                          
                          // Validate: Only digits allowed
                          if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                            setState(() {
                              errorMessage = 'Only numbers are allowed. No special characters.';
                            });
                            return;
                          }
                          
                          // Validate: Must be exactly 10 digits
                          if (phone.length != 10) {
                            setState(() {
                              errorMessage = 'Phone number must be exactly 10 digits';
                            });
                            return;
                          }


                          setState(() {
                            isLoading = true;
                          });

                          // Update phone number using customer controller
                          try {
                          final success = await customerController.updateCustomerPhoneNumber(phone);

                          if (success) {
                              // Close dialog first
                              Navigator.of(context).pop();
                            showSuccessSnackbar('Phone number updated successfully');
                          } else {
                              setState(() {
                                isLoading = false;
                                errorMessage = 'Failed to update phone number. Please try again.';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              // Check if error message contains "already registered"
                              final errorStr = e.toString();
                              if (errorStr.toLowerCase().contains('already registered') ||
                                  errorStr.toLowerCase().contains('already exists')) {
                                errorMessage = 'This phone number is already registered with another account.';
                              } else {
                                errorMessage = 'Failed to update phone number. Please try again.';
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.button,
                          foregroundColor: Colors.white,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: ResponsiveUtils.rp(20),
                                height: ResponsiveUtils.rp(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text('Update Phone'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }

  /// Check if user is authenticated
  bool _isUserAuthenticated() {
    final authController = Get.find<AuthController>();
    final authToken = GraphqlService.authToken;
    final channelToken = GraphqlService.channelToken;
    
    return authController.isLoggedIn && 
           authToken.isNotEmpty && 
           channelToken.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // Observe theme changes to rebuild the entire page
    return Obx(() {
      // Force rebuild when theme changes
      final _ = themeController.isDarkMode;
      
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          'My Account',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerAccount();
        }

        final customer = customerController.activeCustomer.value;

        return RefreshIndicator(
          onRefresh: () async {
            // Only fetch customer data if user is authenticated
            if (_isUserAuthenticated()) {
              await customerController.getActiveCustomer();
            }
          },
          color: AppColors.refreshIndicator,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Card, guest card, or error/retry card
                customer != null
                    ? _buildProfileCard(customer)
                    : _isUserAuthenticated()
                        ? _buildProfileErrorCard()
                        : _buildGuestProfileCard(),

                // Orders Section (hide for guest)
               

                // Referral Section (hide for guest)
                if (_isUserAuthenticated()) ...[
                  _buildReferralSection(),
                  SizedBox(height: ResponsiveUtils.rp(8)),
                ],
 if (_isUserAuthenticated()) ...[
                  _buildOrdersSection(),
                  SizedBox(height: ResponsiveUtils.rp(8)),
                ],
                // Account Options
                _buildAccountOptions(isGuest: !_isUserAuthenticated()),

                SizedBox(height: ResponsiveUtils.rp(8)),

                // Support Section
                _buildSupportSection(isGuest: !_isUserAuthenticated()),

                SizedBox(height: ResponsiveUtils.rp(16)),

                // App Version & Logout/Login
                _buildFooter(isGuest: !_isUserAuthenticated()),
              ],
            ),
          ),
        );
      }),
    );
    });
  }

  /// Guest profile card — Your Account centered at top, Sign Up and Login buttons
  Widget _buildGuestProfileCard() {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              'Your Account',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(24),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(20)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.signup),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.button,
                    side: BorderSide(color: AppColors.button),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(12)),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  icon: Icon(Icons.login, size: ResponsiveUtils.rp(18)),
                  label: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Compact error card when customer data fails to load — keeps rest of page visible
  Widget _buildProfileErrorCard() {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline,
            size: ResponsiveUtils.rp(40),
            color: AppColors.textSecondary,
          ),
          SizedBox(width: ResponsiveUtils.rp(16)),
          Expanded(
            child: Text(
              'Unable to load profile',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              if (_isUserAuthenticated()) {
                await customerController.getActiveCustomer();
              }
            },
            icon: Icon(Icons.refresh, size: ResponsiveUtils.rp(18), color: AppColors.button),
            label: Text('Retry', style: TextStyle(color: AppColors.button, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Query$GetActiveCustomer$activeCustomer customer) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: ResponsiveUtils.rp(70),
                height: ResponsiveUtils.rp(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.button,
                      AppColors.button.withValues(alpha: 0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getInitials(customer.firstName, customer.lastName),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.sp(24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(16)),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${customer.firstName} ${customer.lastName}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ResponsiveUtils.rp(6)),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: ResponsiveUtils.rp(16),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: ResponsiveUtils.rp(6)),
                        Expanded(
                          child: Text(
                            customer.phoneNumber ?? 'No phone number',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: ResponsiveUtils.sp(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (customer.groups.isNotEmpty) ...[
                      SizedBox(height: ResponsiveUtils.rp(6)),
                      Wrap(
                        spacing: ResponsiveUtils.rp(6),
                        runSpacing: ResponsiveUtils.rp(4),
                        children: customer.groups.map((g) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(8),
                            vertical: ResponsiveUtils.rp(3),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.button.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                          ),
                          child: Text(
                            g.name,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(11),
                              fontWeight: FontWeight.w600,
                              color: AppColors.button,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              // Edit Button with red dot when any profile field is empty
              Obx(() {
                final c = customerController.activeCustomer.value;
                final hasIncomplete = c != null && CustomerController.isProfileIncomplete(c);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: _showEditProfileDialog,
                      icon: Icon(Icons.edit_outlined),
                      color: AppColors.button,
                      iconSize: ResponsiveUtils.rp(24),
                      tooltip: 'Edit Profile',
                    ),
                    if (hasIncomplete)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: ResponsiveUtils.rp(10),
                          height: ResponsiveUtils.rp(10),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          // Loyalty Points
          InkWell(
            onTap: () {
              Get.toNamed('/loyalty-points-transactions');
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(16),
                vertical: ResponsiveUtils.rp(12),
              ),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.stars_outlined,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(20),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(10)),
                  Text(
                    'Loyalty Points',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.sp(14),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${customer.customFields?.loyaltyPointsAvailable ?? 0}',
                    style: TextStyle(
                      color: AppColors.button,
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.rp(20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection() {
    final ordersCount = customerController.orders.length;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: AppColors.iconLight, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'My Orders',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => Get.toNamed('/orders', arguments: OrderFilter.all),
                child: Text(
                  'View All ($ordersCount)',
                  style: TextStyle(
                    color: AppColors.button,
                    fontSize: ResponsiveUtils.sp(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStatusItem(
                  Icons.payment_outlined, 
                  'Order Confirmed', 
                  Colors.green, 
                  () => Get.toNamed('/orders', arguments: OrderFilter.paymentAuthorized)),
              _buildOrderStatusItem(
                  Icons.check_circle_outlined, 
                  'Delivered', 
                  Colors.blue, 
                  () => Get.toNamed('/orders', arguments: OrderFilter.delivered)),
              _buildOrderStatusItem(
                  Icons.pending_actions_outlined, 
                  'Cancellation Request', 
                  Colors.orange, 
                  () => Get.toNamed('/orders', arguments: OrderFilter.cancellationRequest)),
              _buildOrderStatusItem(
                  Icons.cancel_outlined, 
                  'Cancelled', 
                  Colors.red, 
                  () => Get.toNamed('/orders', arguments: OrderFilter.cancelled)),
    
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusItem(
      IconData icon, String status, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: ResponsiveUtils.rp(54),
            height: ResponsiveUtils.rp(54),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(27)),
            ),
            child: Icon(icon, color: color, size: ResponsiveUtils.rp(26)),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            status,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralSection() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_giftcard_outlined,
                  color: AppColors.iconLight, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'Refer & Earn',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Obx(() {
                final earned = referralController.totalEarnedCards.value;
                if (earned > 0) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(2),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                    ),
                    child: Text(
                      '$earned cards to scratch!',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(11),
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          // Share referral link
          InkWell(
            key: _shareReferralKey,
            onTap: () => _shareReferralLink(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(16),
                vertical: ResponsiveUtils.rp(14),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.button.withValues(alpha: 0.1), AppColors.button.withValues(alpha: 0.05)],
                ),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(color: AppColors.button.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.share_outlined, color: AppColors.button, size: ResponsiveUtils.rp(22)),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Share your referral link',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(14),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: ResponsiveUtils.rp(8)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(8),
                                vertical: ResponsiveUtils.rp(2),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.button.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                              ),
                              child: Text(
                                'ID: ${customerController.activeCustomer.value?.id ?? ''}',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(11),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.button,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.rp(2)),
                        Obx(() => Text(
                          'Earn ${referralController.channelPoints.value} points per referral',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        )),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppColors.button, size: ResponsiveUtils.rp(16)),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          // Scratch Cards, My Referrals, Saved Addresses, Wishlist, Preferred Items as icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStatusItem(
                Icons.style_outlined,
                'Scratch Cards',
                Colors.amber.shade700,
                () => Get.toNamed(AppRoutes.scratchCards),
              ),
              _buildOrderStatusItem(
                Icons.people_outline,
                'Referrals',
                Colors.blue.shade700,
                () => Get.toNamed(AppRoutes.myReferrals),
              ),
              _buildOrderStatusItem(
                Icons.location_on_outlined,
                'Addresses',
                Colors.green.shade700,
                () => Get.toNamed('/addresses'),
              ),
              _buildOrderStatusItem(
                Icons.favorite_outline,
                'Wishlist',
                Colors.red.shade700,
                () => Get.toNamed('/favourite'),
              ),
              _buildOrderStatusItem(
                Icons.shopping_bag_outlined,
                'Preferred',
                Colors.purple.shade700,
                () => Get.toNamed('/frequently-ordered'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Rect? _shareOrigin(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> _shareReferralLink() async {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;
    final customerId = customer.id;
    final link = 'https://www.avsecomhub.com/products/kaaikani/refer?referrerId=$customerId';
    try {
      await Share.share(
        'Hey! Use my referral link to sign up on Kaaikani and we both earn rewards!\n\n$link',
        sharePositionOrigin: _shareOrigin(_shareReferralKey),
      );
    } catch (e) {
      debugPrint('Error sharing referral: $e');
    }
  }

  /// Returns true if the customer account was created within the last 24 hours.
  bool _isAccountCreatedWithin24Hours() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return false;
    final createdAt = customer.createdAt;
    return DateTime.now().difference(createdAt).inHours < 24;
  }

  /// Shows "Redeem Referral" tile only if account is < 24 hours old and not already referred.
  Widget _buildRedeemReferralTile() {
    if (!_isAccountCreatedWithin24Hours()) return const SizedBox.shrink();
    final customer = customerController.activeCustomer.value;
    if (customer?.referredBy != null) return const SizedBox.shrink();
    return Obx(() {
      if (referralController.hasRedeemed.value) return const SizedBox.shrink();
      return Column(
        children: [
          _buildListTile(
            Icons.card_giftcard_outlined,
            'Redeem Referral',
            Icons.arrow_forward_ios,
            subtitle: 'Enter referrer ID to earn rewards',
            onTap: _showRedeemReferralDialog,
          ),
          _buildDivider(),
        ],
      );
    });
  }

  /// Shows dialog to enter referrer ID (numbers only) and calls registerReferral mutation.
  void _showRedeemReferralDialog() {
    final textController = TextEditingController();
    final isSubmitting = false.obs;
    Get.dialog(
      AlertDialog(
        title: const Text('Redeem Referral'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the referrer ID to redeem your referral reward.'),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Enter referrer ID',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: isSubmitting.value
                ? null
                : () async {
                    final referrerId = textController.text.trim();
                    if (referrerId.isEmpty) {
                      SnackBarWidget.showError('Please enter a referrer ID');
                      return;
                    }
                    isSubmitting.value = true;
                    final customerId = customerController.activeCustomer.value?.id;
                    final success = await referralController.registerReferral(referrerId, customerId: customerId);
                    isSubmitting.value = false;
                    if (success) {
                      Get.back();
                      SnackBarWidget.showSuccess('Referral redeemed successfully!');
                      referralController.fetchMyReferrals();
                      referralController.fetchEarnedScratchCards();
                    } else {
                      SnackBarWidget.showError('Failed to redeem referral. Please check the ID and try again.');
                    }
                  },
            child: isSubmitting.value
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Redeem'),
          )),
        ],
      ),
    );
  }

  Widget _buildAccountOptions({bool isGuest = false}) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          if (!isGuest) ...[
            _buildRedeemReferralTile(),
          ],
          _buildDarkModeTile(),
        ],
      ),
    );
  }

  Widget _buildSupportSection({bool isGuest = false}) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          _buildListTile(
            Icons.link_outlined,
            'Connect with Us',
            Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/connect-with-us'),
          ),
          _buildDivider(),
          _buildListTile(
            Icons.help_outline,
            'Help & Support',
            Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/help-support'),
          ),
          _buildDivider(),
          _buildListTile(
            Icons.star_outline,
            'Rate Our App',
            Icons.arrow_forward_ios,
            onTap: _openStoreForRating,
          ),
          _buildDivider(),
          KeyedSubtree(
            key: _shareAppKey,
            child: _buildListTile(
              Icons.share_outlined,
              'Share App',
              Icons.arrow_forward_ios,
              onTap: _shareApp,
            ),
          ),
          _buildDivider(),
          _buildListTile(
            Icons.privacy_tip_outlined,
            'Privacy & Policy',
            Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/privacy-policy'),
          ),
          _buildDivider(),
          _buildListTile(
            Icons.description_outlined,
            'Terms & Conditions',
            Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/terms-conditions'),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      IconData leadingIcon, String title, IconData trailingIcon,
      {String? subtitle, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: ResponsiveUtils.rp(36),
        height: ResponsiveUtils.rp(36),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
        ),
        child: Icon(leadingIcon,
            color: AppColors.button, size: ResponsiveUtils.rp(20)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveUtils.sp(14),
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: Icon(trailingIcon,
          size: ResponsiveUtils.rp(16), color: AppColors.textTertiary),
      contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
      minLeadingWidth: 0,
    );
  }

  // Dark Mode Toggle Tile
  Widget _buildDarkModeTile() {
    return Obx(() => ListTile(
          leading: Container(
            width: ResponsiveUtils.rp(36),
            height: ResponsiveUtils.rp(36),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
            ),
            child: Icon(
              themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.button,
              size: ResponsiveUtils.rp(20),
            ),
          ),
          title: Text(
            'Dark Mode',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            themeController.isDarkMode ? 'Enabled' : 'Disabled',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Switch(
            value: themeController.isDarkMode,
            onChanged: (value) {
              themeController.setDarkMode(value);
            },
            activeColor: AppColors.button,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          minLeadingWidth: 0,
        ));
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 60, endIndent: 16);
  }

  Widget _buildFooter({bool isGuest = false}) {
    return Column(
      children: [
        // Company Information
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Information',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: ResponsiveUtils.rp(16),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FSSAI License Number',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        Text(
                          '12422012001406',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: ResponsiveUtils.rp(16),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GST No',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        Text(
                          '33BFHPS5919D2ZD',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: isGuest
              ? ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  icon: Icon(Icons.login, size: ResponsiveUtils.rp(20)),
                  label: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                )
              : OutlinedButton(
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
        ),
        SizedBox(height: ResponsiveUtils.rp(16)),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            return Center(
              child: Text(
                'App Version ${snapshot.data?.version ?? "1.0.0"}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: ResponsiveUtils.sp(12),
                ),
              ),
            );
          },
        ),
        SizedBox(height: ResponsiveUtils.rp(20)),
      ],
    );
  }

  String _getInitials(String firstName, String lastName) {
    String firstInitial =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    if (firstInitial.isEmpty && lastInitial.isEmpty) return 'U';
    return '$firstInitial$lastInitial';
  }

  /// Label with optional small red dot when field is unfilled
  Widget _buildFieldLabel(String label, bool isEmpty) {
    return Row(
      children: [
        if (isEmpty) ...[
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(right: ResponsiveUtils.rp(6)),
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    // Check if phone number is not null OR email is not null/valid
    final hasValidPhone = customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty;
    final hasValidEmail = _isValidGmail(customer.emailAddress);
    final canEditOnlyName = hasValidPhone || hasValidEmail;

    final firstNameController = TextEditingController(text: customer.firstName);
    final lastNameController = TextEditingController(text: customer.lastName);
    final emailController = TextEditingController(
      text: customer.emailAddress.isNotEmpty ? customer.emailAddress : '',
    );
    final phoneController = TextEditingController(
      text: customer.phoneNumber ?? '',
    );
    // Title (Mr. / Ms. / Miss) in update customer
    const List<String> titleOptions = ['Mr.', 'Ms.', 'Miss'];
    String? selectedTitle;
    if (customer.title != null && customer.title!.isNotEmpty) {
      final t = customer.title!.trim();
      final lower = t.toLowerCase();
      if (lower == 'male' || lower == 'mr' || lower == 'mr.') {
        selectedTitle = 'Mr.';
      } else if (lower == 'female' || lower == 'ms' || lower == 'ms.') {
        selectedTitle = 'Ms.';
      } else if (lower == 'miss' || lower == 'others') {
        selectedTitle = 'Miss';
      } else if (titleOptions.contains(t)) {
        selectedTitle = t;
      } else {
        selectedTitle = t;
      }
    }
    bool isLoading = false;
    String? titleError;
    String? firstNameError;
    String? lastNameError;
    String? emailError;
    String? phoneError;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(20),
          vertical: ResponsiveUtils.rp(40),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: ResponsiveUtils.rp(20),
                    offset: Offset(0, ResponsiveUtils.rp(10)),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                    decoration: BoxDecoration(
                      color: AppColors.button.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(ResponsiveUtils.rp(20)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                          decoration: BoxDecoration(
                            color: AppColors.button,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: ResponsiveUtils.rp(24),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(20),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close_rounded),
                          color: AppColors.textSecondary,
                          iconSize: ResponsiveUtils.rp(24),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title dropdown (Mr. / Ms. / Miss) - stored as title in GraphQL
                          _buildFieldLabel('Title', selectedTitle?.isEmpty ?? true),
                          SizedBox(height: ResponsiveUtils.rp(8)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(12)),
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                              border: Border.all(color: AppColors.border, width: 1),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedTitle != null && titleOptions.contains(selectedTitle)
                                    ? selectedTitle
                                    : null,
                                isExpanded: true,
                                hint: Text(
                                  'Select',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(16),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
                                items: titleOptions
                                    .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        selectedTitle = value;
                                        titleError = null;
                                        setState(() {});
                                      },
                              ),
                            ),
                          ),
                          if (titleError != null) ...[
                            SizedBox(height: ResponsiveUtils.rp(4)),
                            Text(
                              titleError!,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(12),
                                color: AppColors.error,
                              ),
                            ),
                          ],
                          SizedBox(height: ResponsiveUtils.rp(20)),
                          // First Name Field
                          _buildFieldLabel('First Name', firstNameController.text.trim().isEmpty),
                          SizedBox(height: ResponsiveUtils.rp(8)),
              TextField(
                controller: firstNameController,
                            enabled: !isLoading,
                            onChanged: (_) {
                              if (firstNameError != null) {
                                firstNameError = null;
                                setState(() {});
                              }
                            },
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              color: AppColors.textPrimary,
                            ),
                decoration: InputDecoration(
                              hintText: 'Enter first name',
                              errorText: firstNameError,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppColors.button,
                              ),
                              filled: true,
                              fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                borderSide: BorderSide(
                                  color: AppColors.button,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(16),
                                vertical: ResponsiveUtils.rp(16),
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.rp(20)),
                          // Last Name Field
                          _buildFieldLabel('Last Name', lastNameController.text.trim().isEmpty),
                          SizedBox(height: ResponsiveUtils.rp(8)),
              TextField(
                controller: lastNameController,
                            enabled: !isLoading,
                            onChanged: (_) {
                              if (lastNameError != null) {
                                lastNameError = null;
                                setState(() {});
                              }
                            },
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              color: AppColors.textPrimary,
                            ),
                decoration: InputDecoration(
                              hintText: 'Enter last name',
                              errorText: lastNameError,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppColors.button,
                              ),
                              filled: true,
                              fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                borderSide: BorderSide(
                                  color: AppColors.button,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(16),
                                vertical: ResponsiveUtils.rp(16),
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.rp(20)),
                          // Only show email and phone fields if they are NOT valid (can edit them)
                          if (!canEditOnlyName) ...[
                            SizedBox(height: ResponsiveUtils.rp(20)),
                            // Email Field
                            _buildFieldLabel('Email', emailController.text.trim().isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            TextField(
                              controller: emailController,
                              enabled: !isLoading && !canEditOnlyName,
                              readOnly: canEditOnlyName,
                              onChanged: (_) {
                                if (emailError != null) {
                                  emailError = null;
                                  setState(() {});
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter email address',
                                errorText: emailError,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: canEditOnlyName ? AppColors.textSecondary : AppColors.button,
                                ),
                                filled: true,
                                fillColor: canEditOnlyName ? AppColors.background : AppColors.inputFill,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.button,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.rp(16),
                                  vertical: ResponsiveUtils.rp(16),
                                ),
                              ),
                            ),
                            // Show "Connect with Google" button if email is not Gmail or empty
                            if (customer.emailAddress.isEmpty || 
                                !customer.emailAddress.toLowerCase().endsWith('@gmail.com')) ...[
                              SizedBox(height: ResponsiveUtils.rp(12)),
                              OutlinedButton.icon(
                                onPressed: isLoading ? null : () {
                                  AnalyticsHelper.trackButton(
                                    'Connect with Google - Profile',
                                    screenName: 'Account',
                                    callback: () {
                                      _showGoogleAccountSelectionDialog(context, setState, emailController);
                                    },
                                  )?.call();
                                },
                                icon: Image.asset(
                                  'assets/images/google_logo.png',
                                  width: ResponsiveUtils.rp(20),
                                  height: ResponsiveUtils.rp(20),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.login,
                                      size: ResponsiveUtils.rp(20),
                                      color: AppColors.button,
                                    );
                                  },
                                ),
                                label: Text(
                                  'Connect with Google',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(14),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.button,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: AppColors.button,
                                    width: 1.5,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUtils.rp(16),
                                    vertical: ResponsiveUtils.rp(12),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: ResponsiveUtils.rp(20)),
                            // Phone Number Field (always editable)
                            _buildFieldLabel('Phone Number', phoneController.text.trim().isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            TextField(
                              controller: phoneController,
                              enabled: !isLoading,
                              onChanged: (_) {
                                if (phoneError != null) {
                                  phoneError = null;
                                  setState(() {});
                                }
                              },
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                errorText: phoneError,
                                prefixIcon: Icon(
                                  Icons.phone_outlined,
                                  color: AppColors.button,
                                ),
                                filled: true,
                                fillColor: AppColors.inputFill,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.button,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.rp(16),
                                  vertical: ResponsiveUtils.rp(16),
                                ),
                                counterText: '',
                              ),
                            ),
                          ] else ...[
                            // Email: show email with Edit button (opens email dialog)
                            SizedBox(height: ResponsiveUtils.rp(20)),
                            _buildFieldLabel('Email', customer.emailAddress.isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(16),
                                vertical: ResponsiveUtils.rp(14),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: AppColors.textSecondary,
                                    size: ResponsiveUtils.rp(22),
                                  ),
                                  SizedBox(width: ResponsiveUtils.rp(12)),
                                  Expanded(
                                    child: Text(
                                      customer.emailAddress.isNotEmpty
                                          ? customer.emailAddress
                                          : 'No email address',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(16),
                                        color: customer.emailAddress.isNotEmpty
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Get.back();
                                      _showUpdateEmailDialog();
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: ResponsiveUtils.rp(18),
                                      color: AppColors.button,
                                    ),
                                    label: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(14),
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.button,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.rp(20)),
                            // Phone Number Field (always editable)
                            _buildFieldLabel('Phone Number', phoneController.text.trim().isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            TextField(
                              controller: phoneController,
                              enabled: !isLoading,
                              onChanged: (_) {
                                if (phoneError != null) {
                                  phoneError = null;
                                  setState(() {});
                                }
                              },
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                errorText: phoneError,
                                prefixIcon: Icon(
                                  Icons.phone_outlined,
                                  color: AppColors.button,
                                ),
                                filled: true,
                                fillColor: AppColors.inputFill,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                  borderSide: BorderSide(
                                    color: AppColors.button,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.rp(16),
                                  vertical: ResponsiveUtils.rp(16),
                                ),
                                counterText: '',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Actions
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.border,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading ? null : () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.border),
                              foregroundColor: AppColors.textPrimary,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.rp(14),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () async {
                              final firstName = firstNameController.text.trim();
                              final lastName = lastNameController.text.trim();
                              final phone = phoneController.text.trim();
                              final email = emailController.text.trim();

                              // Clear previous errors and validate required fields
                              titleError = null;
                              firstNameError = null;
                              lastNameError = null;
                              emailError = null;
                              phoneError = null;

                              bool hasError = false;
                              if (selectedTitle == null || selectedTitle!.trim().isEmpty) {
                                titleError = 'Required';
                                hasError = true;
                              }
                              if (firstName.isEmpty) {
                                firstNameError = 'Required';
                                hasError = true;
                              }
                              if (lastName.isEmpty) {
                                lastNameError = 'Required';
                                hasError = true;
                              }
                              if (!canEditOnlyName) {
                                if (email.isEmpty) {
                                  emailError = 'Required';
                                  hasError = true;
                                }
                                if (phone.isEmpty) {
                                  phoneError = 'Required';
                                  hasError = true;
                                }
                              }
                              if (phone.isNotEmpty) {
                                if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                                  phoneError = 'Phone must be digits only';
                                  hasError = true;
                                } else if (phone.length != 10) {
                                  phoneError = 'Must be exactly 10 digits';
                                  hasError = true;
                                }
                              }

                              if (hasError) {
                                setState(() {});
                                showErrorSnackbar('Please fill all required fields');
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              customerController.firstNameController.text = firstName;
                              customerController.lastNameController.text = lastName;

                              bool success = await customerController.updateCustomer(title: selectedTitle);
                              if (success && phone.isNotEmpty && phone != (customer.phoneNumber ?? '')) {
                                try {
                                  final phoneSuccess = await customerController.updateCustomerPhoneNumber(phone);
                                  if (!phoneSuccess) {
                                    showErrorSnackbar('Profile saved but phone update failed. Try updating phone separately.');
                                  }
                                } catch (e) {
                                  final msg = e.toString().replaceFirst('Exception: ', '');
                                  showErrorSnackbar(msg.isNotEmpty ? msg : 'Failed to update phone number');
                                }
                              }

                              setState(() {
                                isLoading = false;
                              });

                              if (success) {
                                Get.back();
                                showSuccessSnackbar('Profile updated successfully');
                              } else {
                                showErrorSnackbar('Failed to update profile');
                              }
                            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.rp(14),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: ResponsiveUtils.rp(20),
                                    height: ResponsiveUtils.rp(20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(16),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show Google account selection dialog
  /// On Android 8.0+, AccountManager can't access Google accounts due to privacy restrictions
  /// So we show a manual email input dialog where user can enter their email
  Future<void> _showGoogleAccountSelectionDialog(
    BuildContext context,
    StateSetter setState,
    TextEditingController emailController,
  ) async {
    // Try to get accounts from AccountManager first
    try {
      const platform = MethodChannel('com.kaaikani.kaaikani/account_manager');
      final List<dynamic> accounts = await platform.invokeMethod('getGoogleAccounts') as List<dynamic>;
      
      if (accounts.isNotEmpty) {
        // Convert to list of maps with email
        final List<Map<String, String>> accountList = accounts.map((account) {
          return {
            'email': account['email'] as String,
            'type': account['type'] as String? ?? 'com.google',
          };
        }).toList();
        
        
        // Show dialog with all Google accounts
        final selectedAccount = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: ResponsiveUtils.rp(28),
                        color: AppColors.button,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: Text(
                          'Select Google Account',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close),
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: accountList.length,
                      itemBuilder: (context, index) {
                        final account = accountList[index];
                        final email = account['email'] ?? '';
                        
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            email,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: ResponsiveUtils.rp(16),
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            Navigator.of(context).pop(account);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(16),
                            vertical: ResponsiveUtils.rp(8),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        
        // If user selected an account, pass email to text box
        if (selectedAccount != null) {
          final selectedEmail = selectedAccount['email'] ?? '';
          if (selectedEmail.isNotEmpty) {
            
            emailController.text = selectedEmail;
            setState(() {});
            
            return;
          }
        }
      }
    } catch (e) {
    }
    
    // If no accounts found or error occurred, show manual email input dialog
    _showManualEmailInputDialog(context, setState, emailController);
  }

  /// Show manual email input dialog when no accounts found
  void _showManualEmailInputDialog(
    BuildContext context,
    StateSetter setState,
    TextEditingController emailController,
  ) {
    final manualEmailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        ),
        child: Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.email,
                    size: ResponsiveUtils.rp(28),
                    color: AppColors.button,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(
                    child: Text(
                      'Enter Email Address',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
              TextField(
                controller: manualEmailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    borderSide: BorderSide(color: AppColors.button, width: 2),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  ElevatedButton(
                    onPressed: () {
                      final email = manualEmailController.text.trim();
                      if (email.isNotEmpty) {
                        
                        emailController.text = email;
                        setState(() {});
                        Navigator.of(context).pop();
                        
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Use Email'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Logout',
          style: TextStyle(fontSize: ResponsiveUtils.sp(18), fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: ResponsiveUtils.sp(14)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// App Store ID for iOS (from App Store Connect).
  static const String _appStoreId = '6759081528';

  bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> _shareApp() async {
    try {
      String appLink;
      if (_isIOS) {
        appLink = 'https://apps.apple.com/app/id$_appStoreId';
      } else if (_isAndroid) {
        final packageInfo = await PackageInfo.fromPlatform();
        appLink =
            'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
      } else {
        // Web/desktop: use Play Store link as fallback or a generic message
        final packageInfo = await PackageInfo.fromPlatform();
        appLink =
            'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
      }
      await Share.share(appLink, sharePositionOrigin: _shareOrigin(_shareAppKey));
    } catch (e) {
      showErrorSnackbar('Could not share app');
    }
  }

  /// Opens App Store on iOS or Play Store on Android for rating the app.
  Future<void> _openStoreForRating() async {
    try {
      if (_isIOS) {
        final appStoreUrl =
            Uri.parse('https://apps.apple.com/app/id$_appStoreId');
        final itmsUrl =
            Uri.parse('itms-apps://apps.apple.com/app/id$_appStoreId');
        if (await canLaunchUrl(itmsUrl)) {
          await launchUrl(itmsUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
        }
      } else if (_isAndroid) {
        final packageInfo = await PackageInfo.fromPlatform();
        final packageName = packageInfo.packageName;
        final playStoreUrl = Uri.parse('market://details?id=$packageName');
        final webStoreUrl = Uri.parse(
            'https://play.google.com/store/apps/details?id=$packageName');
        if (await canLaunchUrl(playStoreUrl)) {
          await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
        }
      } else {
        showErrorSnackbar('Please open the app on a phone to rate us.');
      }
    } catch (e) {
      showErrorSnackbar(
        _isIOS
            ? 'Could not open App Store: $e'
            : 'Could not open Play Store: $e',
      );
    }
  }




  Widget _buildShimmerAccount() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile card shimmer
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              child: Row(
                children: [
                  Container(
                    width: ResponsiveUtils.rp(80),
                    height: ResponsiveUtils.rp(80),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: ResponsiveUtils.rp(20),
                          width: ResponsiveUtils.rp(150),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(8)),
                        Container(
                          height: ResponsiveUtils.rp(16),
                          width: ResponsiveUtils.rp(200),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            // Quick actions shimmer
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                children: List.generate(
                    3,
                    (index) => Container(
                          height: ResponsiveUtils.rp(56),
                          margin:
                              EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            // Orders section shimmer
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                children: [
                  Container(
                    height: ResponsiveUtils.rp(20),
                    width: ResponsiveUtils.rp(100),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  ...List.generate(
                      2,
                      (index) => Container(
                            height: ResponsiveUtils.rp(80),
                            margin:
                                EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
