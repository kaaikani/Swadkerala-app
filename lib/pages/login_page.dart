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
import '../utils/navigation_helper.dart';
import '../utils/responsive.dart';
import '../services/analytics_service.dart';
import '../widgets/snackbar.dart';

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
debugPrint('[LoginPage] Error initializing SMS autofill: $e');
    }
  }

  Future<void> _clearAllCache() async {
    try {
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      final storage = GetStorage();
      await storage.erase();
      _authController.setLoggedIn(false);
      _authController.setOtpSent(false);
    } catch (e) {
debugPrint('[LoginPage] Error clearing cache: $e');
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
      debugPrint('[LoginPage] SIM detection failed: $e');
      await _tryGetPhoneFromGoogle();
    } finally {
      if (mounted) setState(() => _isDetectingSim = false);
    }
  }

  Future<void> _tryGetPhoneFromGoogle() async {
    if (!mounted) return;
    try {
      debugPrint('[LoginPage] Attempting to get phone number from Google/device...');
      
      final mobileNumber = await MobileNumber.mobileNumber;
      
      if (mobileNumber != null && mobileNumber.isNotEmpty) {
        String phoneNumber = mobileNumber.replaceAll(RegExp(r'[^0-9]'), '');
        
        if (phoneNumber.length >= 10) {
          phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
          _authController.phoneNumber.text = phoneNumber;
          _validatePhone(phoneNumber);
          debugPrint('[LoginPage] Phone number from Google/device: $phoneNumber');
        }
      }
    } catch (e) {
      debugPrint('[LoginPage] Failed to get phone number from Google/device: $e');
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
debugPrint('[LoginPage] SMS autofill error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.button.withValues(alpha: 0.08),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header Section
                  _buildHeader(),
                  
                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: ResponsiveUtils.rp(8)),
                          
                          // Progress Indicator
                          _buildProgressIndicator(),
                          
                          SizedBox(height: ResponsiveUtils.rp(40)),
                          
                          // Form Card
                          _buildFormCard(),
                          
                          SizedBox(height: ResponsiveUtils.rp(24)),
                          
                          // Sign Up Link
                          _buildSignUpLink(),
                          
                          SizedBox(height: ResponsiveUtils.rp(24)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(24),
        vertical: ResponsiveUtils.rp(32),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: ResponsiveUtils.rp(80),
            height: ResponsiveUtils.rp(80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.button, AppColors.buttonLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.button.withValues(alpha: 0.3),
                  blurRadius: ResponsiveUtils.rp(20),
                  offset: Offset(0, ResponsiveUtils.rp(10)),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Image.asset(
                'assets/images/kklogo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.shopping_bag_rounded,
                    size: ResponsiveUtils.rp(40),
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(24)),
          
          // Title
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(28),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          
          // Subtitle
          Text(
            'Sign in to continue shopping',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(15),
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(() {
      final currentStep = _authController.isOtpSent ? 1 : 0;
      
      return Row(
        children: [
          _buildProgressDot(isActive: currentStep == 0, isCompleted: currentStep > 0),
          Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: currentStep > 0
                    ? AppColors.button
                    : AppColors.border.withValues(alpha: 0.3),
              ),
            ),
          ),
          _buildProgressDot(isActive: currentStep == 1, isCompleted: false),
        ],
      );
    });
  }

  Widget _buildProgressDot({required bool isActive, required bool isCompleted}) {
    return Container(
      width: ResponsiveUtils.rp(10),
      height: ResponsiveUtils.rp(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? AppColors.button
            : isActive
                ? AppColors.button
                : AppColors.border.withValues(alpha: 0.3),
      ),
      child: isCompleted
          ? Icon(
              Icons.check,
              size: ResponsiveUtils.rp(7),
              color: Colors.white,
            )
          : null,
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.rp(20),
            offset: Offset(0, ResponsiveUtils.rp(4)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Content
            Obx(() => _authController.isOtpSent
                ? _buildOtpSection()
                : _buildPhoneSection()),
            
            SizedBox(height: ResponsiveUtils.rp(24)),
            
            // Action Button
            _buildActionButton(),
            
            SizedBox(height: ResponsiveUtils.rp(20)),
            
            // Divider
            Obx(() => !_authController.isOtpSent
                ? _buildDivider()
                : const SizedBox.shrink()),
            
            SizedBox(height: ResponsiveUtils.rp(20)),
            
            // Google Sign In
            Obx(() => !_authController.isOtpSent
                ? _buildGoogleSignInButton()
                : const SizedBox.shrink()),
            
            SizedBox(height: ResponsiveUtils.rp(16)),
            
            // Resend OTP
            Obx(() => _authController.isOtpSent
                ? _buildResendSection()
                : const SizedBox.shrink()),
          ],
        ),
      ),
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
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(6)),
        Text(
          'We\'ll send you a verification code',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(13),
            color: AppColors.textSecondary,
          ),
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
                      fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                  SizedBox(height: ResponsiveUtils.rp(6)),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        size: ResponsiveUtils.rp(14),
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: ResponsiveUtils.rp(6)),
                Text(
                        '+91 ${_authController.phoneNumber.text}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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
        SizedBox(height: ResponsiveUtils.rp(24)),
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : isValid
                  ? AppColors.success
                  : AppColors.inputBorder,
          width: hasError || isValid ? 2 : 1.5,
        ),
        boxShadow: hasError || isValid
            ? [
                BoxShadow(
                  color: (hasError ? AppColors.error : AppColors.success)
                      .withValues(alpha: 0.1),
                  blurRadius: ResponsiveUtils.rp(8),
                  offset: Offset(0, ResponsiveUtils.rp(2)),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(16),
            ),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveUtils.rp(16)),
                bottomLeft: Radius.circular(ResponsiveUtils.rp(16)),
              ),
            ),
            child: Text(
              '+91',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.bold,
                color: AppColors.button,
              ),
            ),
          ),
          Container(
            width: 1,
            height: ResponsiveUtils.rp(24),
            margin: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(8)),
            color: AppColors.border.withValues(alpha: 0.5),
          ),
          Expanded(
            child: TextField(
              controller: _authController.phoneNumber,
              keyboardType: TextInputType.phone,
              enabled: !_authController.isOtpSent && !_isDetectingSim,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
              cursorColor: AppColors.button,
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
                hintText: '1234567890',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                  fontSize: ResponsiveUtils.sp(16),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(16),
                  vertical: ResponsiveUtils.rp(16),
                ),
                suffixIcon: _buildPhoneSuffixIcon(hasError, isValid),
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
      return Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Icon(
          Icons.error_outline,
          color: AppColors.error,
          size: ResponsiveUtils.rp(20),
        ),
      );
    }
    return null;
  }

  Widget _buildOtpField() {
    bool hasError = _otpFieldTouched && _otpError != null;
    bool isValid = _otpFieldTouched &&
        _otpError == null &&
        _authController.otpController.text.length == 4;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : isValid
                  ? AppColors.success
                  : AppColors.inputBorder,
          width: hasError || isValid ? 2 : 1.5,
        ),
        boxShadow: hasError || isValid
            ? [
                BoxShadow(
                  color: (hasError ? AppColors.error : AppColors.success)
                      .withValues(alpha: 0.1),
                  blurRadius: ResponsiveUtils.rp(8),
                  offset: Offset(0, ResponsiveUtils.rp(2)),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(24),
        vertical: ResponsiveUtils.rp(20),
      ),
      child: TextField(
        controller: _authController.otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ResponsiveUtils.sp(28),
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: ResponsiveUtils.rp(12),
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
            color: AppColors.textSecondary.withValues(alpha: 0.25),
            fontSize: ResponsiveUtils.sp(28),
            letterSpacing: ResponsiveUtils.rp(12),
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

      return Container(
        height: ResponsiveUtils.rp(56),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          gradient: isEnabled
              ? LinearGradient(
                  colors: [AppColors.button, AppColors.buttonLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : AppColors.inputBorder,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.button.withValues(alpha: 0.3),
                    blurRadius: ResponsiveUtils.rp(20),
                    offset: Offset(0, ResponsiveUtils.rp(8)),
                    spreadRadius: ResponsiveUtils.rp(2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isLoading || !isEnabled) ? null : _handleButtonPress,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: ResponsiveUtils.rp(24),
                      height: ResponsiveUtils.rp(24),
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveUtils.sp(16),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(10)),
                        Icon(
                          isOtpSent ? Icons.verified : Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: ResponsiveUtils.rp(20),
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
        height: ResponsiveUtils.rp(56),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: ResponsiveUtils.rp(15),
              offset: Offset(0, ResponsiveUtils.rp(4)),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : _handleGoogleSignIn,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
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
                        Container(
                          width: ResponsiveUtils.rp(24),
                          height: ResponsiveUtils.rp(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                            fontSize: ResponsiveUtils.sp(15),
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

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.sp(14),
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed('/signup'),
          child: Text(
            'Sign Up',
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
    if (_authController.isOtpSent) {
      await _verifyOtp();
    } else {
      await _sendOtp();
    }
  }

  Future<void> _sendOtp() async {
    setState(() => _phoneFieldTouched = true);
    _validatePhone(_authController.phoneNumber.text);

    if (_phoneError != null) {
      SnackBarWidget.showError(_phoneError!);
      return;
    }

    await _startSmsAutofill();
    await _authController.startLoginFlow(context);
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
    _smsAutofillService.stopListening();
    super.dispose();
  }
}
