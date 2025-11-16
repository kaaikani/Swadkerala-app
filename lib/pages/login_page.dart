import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../services/sim_detection_service.dart';
import '../services/sms_autofill_service.dart';
import '../theme/theme.dart';

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

  // Validation states
  String? _phoneError;
  String? _otpError;
  bool _phoneFieldTouched = false;
  bool _otpFieldTouched = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSmsAutofill();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllCache();
      _authController.resetFormField();
      Future.delayed(const Duration(milliseconds: 1500), () {
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
    setState(() => _isDetectingSim = true);
    try {
      final simService = SimDetectionService();
      bool hasPermission = await simService.hasPhonePermission();

      if (!hasPermission) {
        bool granted = await simService.requestPhonePermission();
        if (!granted) {
          setState(() => _isDetectingSim = false);
          return;
        }
      }

      List<SimInfo> simInfoList =
          await simService.getAllSimInfoWithRetry().timeout(
                const Duration(seconds: 15),
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
          }
        }
      }
    } catch (e) {
      debugPrint('[LoginPage] SIM detection failed: $e');
    } finally {
      setState(() => _isDetectingSim = false);
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final gradientColors = [
      AppColors.gradientStart,
      AppColors.gradientEnd,
      isDarkMode ? AppColors.background : AppColors.backgroundLight,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Logo and Welcome Section
                    _buildHeader(),

                    const SizedBox(height: 50),

                    // Main Form Card
                    _buildFormCard(),

                    const SizedBox(height: 30),

                    // Sign Up Link
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color primaryTextColor = AppColors.textLight;
    final Color subtitleColor =
        primaryTextColor.withValues(alpha: isDarkMode ? 0.7 : 0.85);

    return Column(
      children: [
        // Logo
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: isDarkMode ? 0.95 : 1),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withValues(alpha: 0.45)
                    : AppColors.shadowMedium,
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 48,
            color: AppColors.button,
          ),
        ),

        const SizedBox(height: 30),

        // Welcome Text
        Text(
          'Welcome Back!',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
                color: primaryTextColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ) ??
              TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
                letterSpacing: 0.5,
              ),
        ),

        const SizedBox(height: 8),

        Text(
          'Sign in to continue',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
                color: subtitleColor,
                fontWeight: FontWeight.w400,
              ) ??
              TextStyle(
                fontSize: 16,
                color: subtitleColor,
              ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.35)
                : AppColors.shadowMedium,
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone Number Section
            _buildPhoneSection(),

            const SizedBox(height: 24),

            // OTP Section
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _authController.isOtpSent
                    ? Column(
                        key: const ValueKey('otp-section'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOtpSection(),
                          const SizedBox(height: 20),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // Action Button
            _buildActionButton(),

            const SizedBox(height: 12),

            // Resend OTP
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _authController.isOtpSent
                    ? Padding(
                        key: const ValueKey('resend-section'),
                        padding: const EdgeInsets.only(top: 8),
                        child: _buildResendSection(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ) ??
              TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 15),
        _buildPhoneField(),
        if (_phoneFieldTouched && _phoneError != null)
          _buildErrorMessage(_phoneError!),
        if (_phoneFieldTouched &&
            _phoneError == null &&
            _authController.phoneNumber.text.length == 10)
          _buildSuccessMessage('Valid phone number'),
      ],
    );
  }

  Widget _buildOtpSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_user, color: AppColors.success, size: 20),
            const SizedBox(width: 8),
            Text(
              'Enter OTP',
              style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ) ??
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Sent to +91 ${_authController.phoneNumber.text}',
          style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ) ??
              TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 15),
        _buildOtpField(),
        if (_otpFieldTouched && _otpError != null)
          _buildErrorMessage(_otpError!),
        if (_otpFieldTouched &&
            _otpError == null &&
            _authController.otpController.text.length == 4)
          _buildSuccessMessage('Valid OTP'),
      ],
    );
  }

  Widget _buildPhoneField() {
    bool hasError = _phoneFieldTouched && _phoneError != null;
    bool isValid = _phoneFieldTouched &&
        _phoneError == null &&
        _authController.phoneNumber.text.length == 10;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final suffix = _buildPhoneSuffixIcon(hasError, isValid);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasError
              ? AppColors.errorLight
              : isValid
                  ? AppColors.successLight
                  : AppColors.inputBorder,
          width: 1.6,
        ),
        boxShadow: [
          if (isValid)
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: isDarkMode ? 0.8 : 1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
            child: Text(
              '+91',
              style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ) ??
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.border,
          ),
          Expanded(
            child: TextField(
              controller: _authController.phoneNumber,
              keyboardType: TextInputType.phone,
              enabled: !_authController.isOtpSent && !_isDetectingSim,
              style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ) ??
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
                hintText: 'Enter 10 digit mobile number',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.45),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                suffixIcon: suffix == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: suffix,
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
      return Skeletons.smallBox(size: 22);
    }
    if (isValid) {
      return const Icon(Icons.check_circle, color: AppColors.success, size: 24);
    }
    if (hasError) {
      return const Icon(Icons.error_outline, color: AppColors.error, size: 24);
    }
    return null;
  }

  Widget _buildOtpField() {
    bool hasError = _otpFieldTouched && _otpError != null;
    bool isValid = _otpFieldTouched &&
        _otpError == null &&
        _authController.otpController.text.length == 4;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasError
              ? AppColors.errorLight
              : isValid
                  ? AppColors.successLight
                  : AppColors.inputBorder,
          width: 1.6,
        ),
        boxShadow: [
          if (isValid)
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextField(
        controller: _authController.otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 18,
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
            color: AppColors.textSecondary.withValues(alpha: 0.35),
            fontSize: 24,
            letterSpacing: 18,
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

      final gradient = isEnabled
          ? LinearGradient(
              colors: const [
                AppColors.button,
                AppColors.buttonLight,
              ],
            )
          : null;

      final Color disabledColor =
          AppColors.inputBorder.withValues(alpha: Get.isDarkMode ? 0.3 : 0.6);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: gradient,
          color: gradient == null ? disabledColor : null,
          boxShadow: gradient == null
              ? null
              : [
                  BoxShadow(
                    color: AppColors.button.withValues(alpha: 0.28),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isLoading || !isEnabled) ? null : _handleButtonPress,
            borderRadius: BorderRadius.circular(18),
            splashColor: AppColors.buttonLight.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Center(
              child: isLoading
                  ? Skeletons.textLine(width: 120, height: 18)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isOtpSent
                              ? Icons.verified_outlined
                              : Icons.send_rounded,
                          color: AppColors.buttonText,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isOtpSent ? 'Verify & Login' : 'Send OTP',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.buttonText,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.4,
                                      ) ??
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.buttonText,
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
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          "Didn't receive the code?",
          style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ) ??
              TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _authController.isLoading ? null : _handleResendOtp,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            foregroundColor: AppColors.button,
            textStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Resend OTP'),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final overlayColor = isDarkMode
        ? AppColors.textLight.withValues(alpha: 0.06)
        : AppColors.textLight.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
      decoration: BoxDecoration(
        color: overlayColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color:
                AppColors.textLight.withValues(alpha: isDarkMode ? 0.12 : 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textLight.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w500,
                ) ??
                TextStyle(
                  fontSize: 16,
                  color: AppColors.textLight.withValues(alpha: 0.85),
                ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Get.toNamed('/signup'),
            child: Text(
              'Sign Up',
              style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ) ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color background =
        AppColors.error.withValues(alpha: isDarkMode ? 0.18 : 0.12);
    final Color border =
        AppColors.error.withValues(alpha: isDarkMode ? 0.45 : 0.25);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color:
                      AppColors.error.withValues(alpha: isDarkMode ? 0.9 : 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(String message) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color background =
        AppColors.success.withValues(alpha: isDarkMode ? 0.18 : 0.12);
    final Color border =
        AppColors.success.withValues(alpha: isDarkMode ? 0.35 : 0.22);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 18),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(
                color:
                    AppColors.success.withValues(alpha: isDarkMode ? 0.9 : 0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(_phoneError!)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    await _startSmsAutofill();
    await _authController.startLoginFlow(context);
  }

  Future<void> _verifyOtp() async {
    setState(() => _otpFieldTouched = true);
    _validateOtp(_authController.otpController.text);

    if (_otpError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(_otpError!)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final success = await _authController.verifyOtp(context);
    if (success) Get.offAllNamed('/home');
  }

  Future<void> _handleResendOtp() async {
    await _authController.resendOtp(context);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _smsAutofillService.stopListening();
    super.dispose();
  }
}
