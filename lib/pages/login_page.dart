import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../services/sim_detection_service.dart';
import '../services/sms_autofill_service.dart';
import 'package:mobile_number/mobile_number.dart';
import '../theme/theme.dart';
import '../controllers/theme_controller.dart';
import '../utils/navigation_helper.dart';
import '../utils/responsive.dart';
import '../services/analytics_service.dart';
import '../widgets/snackbar.dart';
import '../routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _authController = Get.find<AuthController>();
  final _smsAutofillService = SmsAutofillService();
  bool _isDetectingSim = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Timer for auto-fill phone number
  Timer? _autoFillTimer;

  // Focus node for phone field
  final FocusNode _phoneFocusNode = FocusNode();

  // Validation states
  String? _phoneError;
  String? _otpError;
  bool _phoneFieldTouched = false;
  bool _otpFieldTouched = false;

  @override
  void initState() {
    super.initState();
    
    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService().logScreenView(screenName: 'Login');
    });
    _initializeAnimations();
    _initializeSmsAutofill();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllCache();
      _authController.resetFormField();
      _autoFillTimer = Timer(const Duration(milliseconds: 300), () {
        _autoFillPhoneNumber();
      });
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _initializeSmsAutofill() async {
    try {
      await _smsAutofillService.initialize();
    } catch (e) {
    }
  }

  Future<void> _clearAllCache() async {
    try {
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      final storage = GetStorage();
      
      // Preserve onboarding flags - user should not see onboarding again after first install
      final preservedOnboardingComplete = storage.read('onboarding_complete');
      final preservedIntroShown = storage.read('intro_shown');
      
      // Preserve landing page cache keys for better user experience
      final preservedPostalCode = storage.read('postal_code');
      final preservedChannelCode = storage.read('channel_code');
      final preservedChannelName = storage.read('channel_name');
      final preservedChannelType = storage.read('channel_type');
      
      await storage.erase();
      
      // Restore onboarding flags if they existed
      if (preservedOnboardingComplete != null) {
        await storage.write('onboarding_complete', preservedOnboardingComplete);
      }
      if (preservedIntroShown != null) {
        await storage.write('intro_shown', preservedIntroShown);
      }
      
      // Restore landing page cache if they existed
      if (preservedPostalCode != null) {
        await storage.write('postal_code', preservedPostalCode);
      }
      if (preservedChannelCode != null) {
        await storage.write('channel_code', preservedChannelCode);
      }
      if (preservedChannelName != null) {
        await storage.write('channel_name', preservedChannelName);
      }
      if (preservedChannelType != null) {
        await storage.write('channel_type', preservedChannelType);
      }
      
      _authController.setLoggedIn(false);
      _authController.setOtpSent(false);
    } catch (e) {
    }
  }

  Future<void> _autoFillPhoneNumber() async {
    if (!mounted) return;
    setState(() => _isDetectingSim = true);
    try {
      final simService = SimDetectionService();
      bool hasPermission = await simService.hasPhonePermission();

      if (!hasPermission) {
        bool granted = await simService.requestPhonePermission();
        if (!granted) {
          await _tryGetPhoneFromGoogle();
          if (mounted) setState(() => _isDetectingSim = false);
          return;
        }
      }

      List<SimInfo> simInfoList =
          await simService.getAllSimInfoWithRetry().timeout(
                const Duration(seconds: 3),
                onTimeout: () => <SimInfo>[],
              );

      if (simInfoList.isNotEmpty) {
        if (simInfoList.length == 1) {
          _authController.phoneNumber.text = simInfoList.first.last10Digits;
          _validatePhone(_authController.phoneNumber.text);
        } else {
          final selectedSim =
              await simService.showSimSelectionDialog(context, simInfoList);
          if (selectedSim != null) {
            _authController.phoneNumber.text = selectedSim.last10Digits;
            _validatePhone(_authController.phoneNumber.text);
          } else {
            await _tryGetPhoneFromGoogle();
          }
        }
      } else {
        await _tryGetPhoneFromGoogle();
      }
    } catch (e) {
      await _tryGetPhoneFromGoogle();
    } finally {
      if (mounted) setState(() => _isDetectingSim = false);
    }
  }

  Future<void> _tryGetPhoneFromGoogle() async {
    if (!mounted) return;
    try {
      
      final mobileNumber = await MobileNumber.mobileNumber;
      
      if (mobileNumber != null && mobileNumber.isNotEmpty) {
        String phoneNumber = mobileNumber.replaceAll(RegExp(r'[^0-9]'), '');
        
        if (phoneNumber.length >= 10) {
          phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
          _authController.phoneNumber.text = phoneNumber;
          _validatePhone(phoneNumber);
        }
      }
    } catch (e) {
    }
  }

  void _validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (value.length < 10) {
        _phoneError = 'Phone number must be 10 digits';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _phoneError = 'Only numbers are allowed';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validateOtp(String value) {
    setState(() {
      if (value.isEmpty) {
        _otpError = 'OTP is required';
      } else if (value.length < 4) {
        _otpError = 'OTP must be 4 digits';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _otpError = 'Only numbers are allowed';
      } else {
        _otpError = null;
      }
    });
  }

  Future<void> _startSmsAutofill() async {
    try {
      await _smsAutofillService.startListening((otp) {
        _authController.otpController.text = otp;
        _validateOtp(otp);
        if (otp.length == 4 && _otpError == null) _verifyOtp();
      });
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: Obx(() => !_authController.isOtpSent
          ? _buildFloatingConnectButton()
          : const SizedBox.shrink()),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.button.withValues(alpha: 0.08),
              AppColors.background,
              AppColors.button.withValues(alpha: 0.03),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  ResponsiveUtils.rp(24),
                  ResponsiveUtils.rp(32),
                  ResponsiveUtils.rp(24),
                  ResponsiveUtils.rp(4),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 420,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header without logo
                      _buildSimpleHeader(),
                      
                      SizedBox(height: ResponsiveUtils.rp(48)),
                      
                      // Progress Indicator
                      _buildProgressIndicator(),
                      
                      SizedBox(height: ResponsiveUtils.rp(40)),
                      
                      // Form Content (no card)
                      Obx(() {
                        final isOtpSent = _authController.isOtpSent;
                        final isLoading = _authController.isLoading;
                        debugPrint('[LoginPage] Obx(form) rebuild | isOtpSent=$isOtpSent, isLoading=$isLoading');
                        return isOtpSent
                            ? _buildOtpSection()
                            : _buildPhoneSection();
                      }),
                      
                      SizedBox(height: ResponsiveUtils.rp(32)),
                      
                      // Action Button
                      _buildActionButton(),
                      
                      SizedBox(height: ResponsiveUtils.rp(24)),
                      
                      // Divider
                      Obx(() => !_authController.isOtpSent
                          ? _buildDivider()
                          : const SizedBox.shrink()),
                      
                      SizedBox(height: ResponsiveUtils.rp(24)),
                      
                      // Google Sign In
                      Obx(() => !_authController.isOtpSent
                          ? _buildGoogleSignInButton()
                          : const SizedBox.shrink()),
                      
                      SizedBox(height: ResponsiveUtils.rp(16)),
                      
                      // Resend OTP
                      Obx(() => _authController.isOtpSent
                          ? _buildResendSection()
                          : const SizedBox.shrink()),
                      
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      
                      // Sign Up Link
                      _buildSignUpLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSimpleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(32),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -1.0,
          ),
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        
        // Subtitle
        Text(
          'Sign in to continue',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(16),
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(() {
      final currentStep = _authController.isOtpSent ? 1 : 0;
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressStep(
            step: 1,
            label: 'Phone',
            isActive: currentStep == 0,
            isCompleted: currentStep > 0,
          ),
          Container(
            width: ResponsiveUtils.rp(40),
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(4)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: currentStep > 0
                  ? AppColors.button
                  : AppColors.border.withValues(alpha: 0.3),
            ),
          ),
          _buildProgressStep(
            step: 2,
            label: 'Verify',
            isActive: currentStep == 1,
            isCompleted: false,
          ),
        ],
      );
    });
  }

  Widget _buildProgressStep({
    required int step,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveUtils.rp(32),
          height: ResponsiveUtils.rp(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.button
                : isActive
                    ? AppColors.button
                    : AppColors.border.withValues(alpha: 0.3),
            boxShadow: isActive || isCompleted
                ? [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.3),
                      blurRadius: ResponsiveUtils.rp(8),
                      offset: Offset(0, ResponsiveUtils.rp(2)),
                    ),
                  ]
                : null,
          ),
          child: isCompleted
              ? Icon(
                  Icons.check,
                  size: ResponsiveUtils.rp(18),
                  color: Colors.white,
                )
              : Center(
                  child: Text(
                    '$step',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontSize: ResponsiveUtils.sp(14),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
        ),
        SizedBox(height: ResponsiveUtils.rp(6)),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(11),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive || isCompleted
                ? AppColors.button
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }



  Widget _buildPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Text(
          'We\'ll send you a verification code',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textSecondary,
          ),
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
        SizedBox(height: ResponsiveUtils.rp(24)),
        _buildPhoneField(),
        if (_phoneFieldTouched && _phoneError != null)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
            child: _buildErrorMessage(_phoneError!),
          ),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Code',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  Text(
                    '+91 ${_authController.phoneNumber.text}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _authController.setOtpSent(false);
                  _authController.otpController.clear();
                  _otpFieldTouched = false;
                  _otpError = null;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(12),
                  vertical: ResponsiveUtils.rp(8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                ),
              ),
              child: Text(
                'Change',
                style: TextStyle(
                  color: AppColors.button,
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.rp(28)),
        _buildOtpField(),
        if (_otpFieldTouched && _otpError != null)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
            child: _buildErrorMessage(_otpError!),
          ),
      ],
    );
  }

  Widget _buildPhoneField() {
    bool hasError = _phoneFieldTouched && _phoneError != null;
    bool isValid = _phoneFieldTouched &&
        _phoneError == null &&
        _authController.phoneNumber.text.length == 10;
    
    // Get theme controller to check dark mode
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : isValid
                  ? AppColors.success
                  : isDarkMode
                      ? AppColors.border.withValues(alpha: 0.5)
                      : AppColors.border.withValues(alpha: 0.3),
          width: hasError || isValid ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.rp(12),
            offset: Offset(0, ResponsiveUtils.rp(4)),
          ),
          if (hasError || isValid)
            BoxShadow(
              color: (hasError ? AppColors.error : AppColors.success)
                  .withValues(alpha: 0.15),
              blurRadius: ResponsiveUtils.rp(12),
              offset: Offset(0, ResponsiveUtils.rp(4)),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(18),
              vertical: ResponsiveUtils.rp(18),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [
                        AppColors.button.withValues(alpha: 0.2),
                        AppColors.button.withValues(alpha: 0.12),
                      ]
                    : [
                        AppColors.button.withValues(alpha: 0.15),
                        AppColors.button.withValues(alpha: 0.08),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveUtils.rp(18)),
                bottomLeft: Radius.circular(ResponsiveUtils.rp(18)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flag_rounded,
                  size: ResponsiveUtils.rp(18),
                  color: AppColors.button,
                ),
                SizedBox(width: ResponsiveUtils.rp(6)),
                Text(
                  '+91',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.button,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: ResponsiveUtils.rp(28),
            margin: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(10)),
            color: isDarkMode
                ? AppColors.border.withValues(alpha: 0.5)
                : AppColors.border.withValues(alpha: 0.3),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Handle tap even when field is disabled
                if (!_authController.isOtpSent) {
                  if (_isDetectingSim) {
                    // If still detecting, stop detection and enable field
                    setState(() {
                      _isDetectingSim = false;
                    });
                    // Request focus after a brief delay
                    Future.delayed(Duration(milliseconds: 50), () {
                      if (mounted) {
                        _phoneFocusNode.requestFocus();
                      }
                    });
                  } else {
                    // Request focus immediately if not detecting
                    _phoneFocusNode.requestFocus();
                  }
                }
              },
            child: TextField(
              controller: _authController.phoneNumber,
                focusNode: _phoneFocusNode,
              keyboardType: TextInputType.phone,
              enabled: !_authController.isOtpSent && !_isDetectingSim,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(17),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 1.0,
              ),
              cursorColor: AppColors.textPrimary,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (value) {
                if (!_phoneFieldTouched) {
                  setState(() => _phoneFieldTouched = true);
                }
                _validatePhone(value);
              },
              decoration: InputDecoration(
                hintText: '10 Digit number only',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: ResponsiveUtils.sp(17),
                  letterSpacing: 1.0,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(18),
                  vertical: ResponsiveUtils.rp(18),
                ),
                suffixIcon: _buildPhoneSuffixIcon(hasError, isValid),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildPhoneSuffixIcon(bool hasError, bool isValid) {
    if (_isDetectingSim) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Skeletons.smallBox(size: ResponsiveUtils.rp(20)),
      );
    }
    if (isValid) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: ResponsiveUtils.rp(20),
        ),
      );
    }
    if (hasError) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.sim_card_rounded,
              color: AppColors.button,
              size: ResponsiveUtils.rp(22),
            ),
            onPressed: _isDetectingSim || _authController.isOtpSent ? null : _showSimSelectionDialog,
            tooltip: 'Select from SIM',
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: ResponsiveUtils.rp(20),
            ),
          ),
        ],
      );
    }
    // Show SIM button when field is empty or no error
    if (!_authController.isOtpSent) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
        child: IconButton(
          icon: Icon(
            Icons.sim_card_rounded,
            color: AppColors.button,
            size: ResponsiveUtils.rp(22),
          ),
          onPressed: _showSimSelectionDialog,
          tooltip: 'Select from SIM',
        ),
      );
    }
    return null;
  }

  Future<void> _showSimSelectionDialog() async {
    if (!mounted || _authController.isOtpSent) return;
    
    setState(() => _isDetectingSim = true);
    try {
      final simService = SimDetectionService();
      bool hasPermission = await simService.hasPhonePermission();

      if (!hasPermission) {
        bool granted = await simService.requestPhonePermission();
        if (!granted) {
          if (mounted) {
            showErrorSnackbar('Phone permission is required to access SIM numbers');
          }
          return;
        }
      }

      List<SimInfo> simInfoList =
          await simService.getAllSimInfoWithRetry().timeout(
                const Duration(seconds: 3),
                onTimeout: () => <SimInfo>[],
              );

      if (simInfoList.isEmpty) {
        if (mounted) {
          showErrorSnackbar('No SIM numbers found');
        }
        return;
      }

      final selectedSim = await simService.showSimSelectionDialog(context, simInfoList);
      if (selectedSim != null && selectedSim.phoneNumber.isNotEmpty && mounted) {
        _authController.phoneNumber.text = selectedSim.last10Digits;
        _validatePhone(_authController.phoneNumber.text);
        setState(() => _phoneFieldTouched = true);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar('Error loading SIM numbers: $e');
      }
    } finally {
      if (mounted) setState(() => _isDetectingSim = false);
    }
  }

  Widget _buildOtpField() {
    bool hasError = _otpFieldTouched && _otpError != null;
    bool isValid = _otpFieldTouched &&
        _otpError == null &&
        _authController.otpController.text.length == 4;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : isValid
                  ? AppColors.success
                  : AppColors.border.withValues(alpha: 0.3),
          width: hasError || isValid ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: ResponsiveUtils.rp(12),
            offset: Offset(0, ResponsiveUtils.rp(4)),
          ),
          if (hasError || isValid)
            BoxShadow(
              color: (hasError ? AppColors.error : AppColors.success)
                  .withValues(alpha: 0.15),
              blurRadius: ResponsiveUtils.rp(12),
              offset: Offset(0, ResponsiveUtils.rp(4)),
            ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(24),
        vertical: ResponsiveUtils.rp(24),
      ),
      child: TextField(
        controller: _authController.otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ResponsiveUtils.sp(32),
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: ResponsiveUtils.rp(16),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        onChanged: (value) {
          if (!_otpFieldTouched) {
            setState(() => _otpFieldTouched = true);
          }
          _validateOtp(value);
          if (value.length == 4 && _otpError == null) {
            _verifyOtp();
          }
        },
        decoration: InputDecoration(
          hintText: '○ ○ ○ ○',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.sp(32),
            letterSpacing: ResponsiveUtils.rp(16),
            fontWeight: FontWeight.w300,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Obx(() {
      final isLoading = _authController.isLoading;
      final isOtpSent = _authController.isOtpSent;
      final bool isEnabled = isOtpSent
          ? (_otpError == null &&
              _authController.otpController.text.length == 4)
          : (_phoneError == null &&
              _authController.phoneNumber.text.length == 10);
      debugPrint('[LoginPage] Obx(actionButton) | isOtpSent=$isOtpSent, isLoading=$isLoading, isEnabled=$isEnabled');

      return Container(
        height: ResponsiveUtils.rp(58),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
          gradient: isEnabled
              ? LinearGradient(
                  colors: [AppColors.button, AppColors.buttonLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : AppColors.border.withValues(alpha: 0.3),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.button.withValues(alpha: 0.35),
                    blurRadius: ResponsiveUtils.rp(24),
                    offset: Offset(0, ResponsiveUtils.rp(8)),
                    spreadRadius: ResponsiveUtils.rp(2),
                  ),
                  BoxShadow(
                    color: AppColors.button.withValues(alpha: 0.15),
                    blurRadius: ResponsiveUtils.rp(12),
                    offset: Offset(0, ResponsiveUtils.rp(4)),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isLoading || !isEnabled) ? null : _handleButtonPress,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: ResponsiveUtils.rp(26),
                      height: ResponsiveUtils.rp(26),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isOtpSent ? 'Verify & Login' : 'Continue',
                          style: TextStyle(
                            color: isEnabled ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveUtils.sp(17),
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
                          decoration: BoxDecoration(
                            color: isEnabled 
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppColors.border.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                          ),
                          child: Icon(
                            isOtpSent ? Icons.verified_rounded : Icons.arrow_forward_rounded,
                            color: isEnabled ? Colors.white : AppColors.textPrimary,
                            size: ResponsiveUtils.rp(18),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          "Didn't receive the code?",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.sp(14),
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        TextButton(
          onPressed: _authController.isLoading ? null : _handleResendOtp,
          child: Text(
            'Resend OTP',
            style: TextStyle(
              color: AppColors.button,
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.border.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: Text(
            'OR',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.sp(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.border.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return Obx(() {
      final isLoading = _authController.isLoading;
      
      return Container(
        height: ResponsiveUtils.rp(58),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: ResponsiveUtils.rp(20),
              offset: Offset(0, ResponsiveUtils.rp(4)),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : _handleGoogleSignIn,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: ResponsiveUtils.rp(24),
                      height: ResponsiveUtils.rp(24),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png',
                          width: ResponsiveUtils.rp(24),
                          height: ResponsiveUtils.rp(24),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return FaIcon(
                              FontAwesomeIcons.google,
                              size: ResponsiveUtils.rp(24),
                              color: Colors.blue.shade700,
                            );
                          },
                        ),
                        SizedBox(width: ResponsiveUtils.rp(14)),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveUtils.sp(16),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFloatingConnectButton() {
    return FloatingActionButton(
      onPressed: () => _showConnectOptionsDialog(),
      backgroundColor: AppColors.button,
      elevation: 4,
      child: FaIcon(
        FontAwesomeIcons.circleQuestion,
        color: Colors.white,
        size: ResponsiveUtils.rp(24),
      ),
    );
  }

  void _showConnectOptionsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveUtils.rp(20)),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.rp(20),
            vertical: ResponsiveUtils.rp(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: ResponsiveUtils.rp(40),
                height: ResponsiveUtils.rp(4),
                decoration: BoxDecoration(
                  color: AppColors.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
              // Title
              Text(
                'Connect with us',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(24)),
              // Options list
              _buildConnectOption(
                icon: FontAwesomeIcons.circleQuestion,
                title: 'Help Center',
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.helpSupport);
                },
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              _buildConnectOption(
                icon: FontAwesomeIcons.shield,
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.privacyPolicy);
                },
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              _buildConnectOption(
                icon: FontAwesomeIcons.fileContract,
                title: 'Terms and Condition',
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.termsConditions);
                },
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(16),
          vertical: ResponsiveUtils.rp(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.rp(40),
              height: ResponsiveUtils.rp(40),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(20),
                ),
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(16)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveUtils.sp(15),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: ResponsiveUtils.rp(24),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed('/signup'),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.button,
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: ResponsiveUtils.rp(16),
          ),
          SizedBox(width: ResponsiveUtils.rp(8)),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.error,
                fontSize: ResponsiveUtils.sp(12),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleButtonPress() async {
    final isOtpSent = _authController.isOtpSent;
    final isLoading = _authController.isLoading;
    debugPrint('[LoginPage] _handleButtonPress | isOtpSent=$isOtpSent, isLoading=$isLoading, mounted=$mounted');
    if (isOtpSent) {
      debugPrint('[LoginPage] _handleButtonPress -> _verifyOtp()');
      await _verifyOtp();
    } else {
      debugPrint('[LoginPage] _handleButtonPress -> _sendOtp()');
      await _sendOtp();
    }
    debugPrint('[LoginPage] _handleButtonPress done | isOtpSent=${_authController.isOtpSent}');
  }

  Future<void> _sendOtp() async {
    debugPrint('[LoginPage] _sendOtp ENTRY | isOtpSent=${_authController.isOtpSent}, isLoading=${_authController.isLoading}');
    setState(() => _phoneFieldTouched = true);
    _validatePhone(_authController.phoneNumber.text);

    if (_phoneError != null) {
      debugPrint('[LoginPage] _sendOtp EXIT phoneError=$_phoneError');
      SnackBarWidget.showError(_phoneError!);
      return;
    }

    await _startSmsAutofill();
    debugPrint('[LoginPage] _sendOtp calling startLoginFlow(context)');
    final success = await _authController.startLoginFlow(context);
    debugPrint('[LoginPage] _sendOtp startLoginFlow returned success=$success, isOtpSent=${_authController.isOtpSent}');

    if (success && _authController.isOtpSent) {
      debugPrint('[LoginPage] _sendOtp OTP sent successfully, forcing UI rebuild | mounted=$mounted');
      if (mounted) {
        setState(() {});
      }
      _authController.isOtpSent; // Access to trigger Obx
    }
    debugPrint('[LoginPage] _sendOtp EXIT');
  }

  Future<void> _verifyOtp() async {
    setState(() => _otpFieldTouched = true);
    _validateOtp(_authController.otpController.text);

    if (_otpError != null) {
      SnackBarWidget.showError(_otpError!);
      return;
    }

    final success = await _authController.verifyOtpForLogin(context);
    if (success) {
      await AnalyticsService().logLogin(loginMethod: 'OTP');
      await NavigationHelper.redirectToIntendedRoute();
    }
  }

  Future<void> _handleResendOtp() async {
    await _authController.resendOtp(context);
  }

  Future<void> _handleGoogleSignIn() async {
    final success = await _authController.signInWithGoogle(context);
    if (success) {
      await AnalyticsService().logLogin(loginMethod: 'Google');
      await NavigationHelper.redirectToIntendedRoute();
    }
  }

  @override
  void dispose() {
    _autoFillTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _phoneFocusNode.dispose();
    _smsAutofillService.stopListening();
    super.dispose();
  }
}


