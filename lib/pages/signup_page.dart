import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/sms_autofill_service.dart';
import '../services/sim_detection_service.dart';
import '../services/graphql_client.dart';
import '../theme/theme.dart';
import '../utils/navigation_helper.dart';
import '../utils/responsive.dart';
import '../widgets/snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final _authController = Get.find<AuthController>();
  final _smsAutofillService = SmsAutofillService();

  // Form Keys for separate validation per step
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  int _currentStep = 0;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSmsAutofill();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authController.resetFormField();
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

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _smsAutofillService.stopListening();
    super.dispose();
  }

  Future<void> _initializeSmsAutofill() async {
    try {
      await _smsAutofillService.initialize();
    } catch (e) {
    }
  }

  Future<void> _startSmsAutofill() async {
    try {
      await _smsAutofillService.startListening((otp) {
        _authController.otpController.text = otp;
        if (otp.length == 4) _handleFinalSubmit();
      });
    } catch (e) {
    }
  }

  // --- Logic Handlers ---

  void _nextStep() async {
    FocusScope.of(context).unfocus(); // Close keyboard

    // Step 1: Personal Info + Phone Number & Send OTP
    if (_currentStep == 0) {
      if (_step1Key.currentState!.validate()) {
        await _processSendOtp();
      }
    }
    // Step 2: Verify OTP
    else if (_currentStep == 1) {
      if (_step2Key.currentState!.validate()) {
        _handleFinalSubmit();
      }
    }
  }

  void _prevStep() async {
    if (_currentStep > 0) {
      _animateToPage(_currentStep - 1);
    } else {
      // Clear cache when going back to login page
      await _clearCache();
      Get.back();
    }
  }

  Future<void> _clearCache() async {
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
      _authController.resetFormField();
    } catch (e) {
    }
  }

  void _animateToPage(int page) {
    setState(() => _currentStep = page);
  }

  Future<void> _processSendOtp() async {
    final success = await _authController.sendOtp(context, isLogin: false);

    if (success) {
      // Wait a moment to ensure success message is shown
      await Future.delayed(Duration(milliseconds: 300));
      
      // Start SMS autofill
      await _startSmsAutofill();
      
      // Navigate to OTP page
      _animateToPage(1);
    }
  }

  Future<void> _handleFinalSubmit() async {
    final success = await _authController.verifyOtpForRegistration(context);
    if (success) {
      await NavigationHelper.redirectToIntendedRoute();
    }
  }

  Future<void> _showSimSelectionDialog() async {
    if (!mounted) return;
    
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
        // Trigger validation if form is already touched
        if (_step1Key.currentState != null) {
          _step1Key.currentState!.validate();
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar('Error loading SIM numbers: $e');
      }
    }
  }

  // --- UI Construction ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
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
                  ResponsiveUtils.rp(24),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 420,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Simple Header
                      _buildSimpleHeader(),
                      
                      SizedBox(height: ResponsiveUtils.rp(48)),
                      
                      // Progress Indicator
                      _buildProgressBar(),
                      
                      SizedBox(height: ResponsiveUtils.rp(40)),
                      
                      // Form Content
                      _currentStep == 0
                          ? _buildStep1PersonalInfo()
                          : _buildStep2Otp(),
                      
                      SizedBox(height: ResponsiveUtils.rp(32)),
                      
                      // Action Button
                      _buildActionButton(),
                      
                      SizedBox(height: ResponsiveUtils.rp(16)),
                      
                      // Already have account? Login link
                      _buildLoginLink(),
                      
                      SizedBox(height: ResponsiveUtils.rp(24)),
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

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProgressStep(
          step: 1,
          label: 'Details',
          isActive: _currentStep == 0,
          isCompleted: _currentStep > 0,
        ),
        Container(
          width: ResponsiveUtils.rp(50),
          height: 2,
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(4)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: _currentStep > 0
                ? AppColors.button
                : AppColors.border.withValues(alpha: 0.3),
          ),
        ),
        _buildProgressStep(
          step: 2,
          label: 'Verify',
          isActive: _currentStep == 1,
          isCompleted: false,
        ),
      ],
    );
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
          width: ResponsiveUtils.rp(36),
          height: ResponsiveUtils.rp(36),
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
                  size: ResponsiveUtils.rp(20),
                  color: Colors.white,
                )
              : Center(
                  child: Text(
                    '$step',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontSize: ResponsiveUtils.sp(15),
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

  Widget _buildSimpleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Create Account',
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
          'Sign up to get started',
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

  // --- Step 1: Personal Info + Phone Number ---
  Widget _buildStep1PersonalInfo() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Personal Information', 'Enter your details to get started'),
          SizedBox(height: ResponsiveUtils.rp(32)),

          ModernTextField(
            controller: _authController.firstname,
            label: 'First Name',
            hint: 'e.g. John',
            icon: Icons.person_outline_rounded,
            validator: (v) {
              if (v == null || v.trim().length < 2) return 'Min 2 characters required';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) return 'Only alphabets allowed';
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.rp(20)),
          ModernTextField(
            controller: _authController.lastname,
            label: 'Last Name',
            hint: 'e.g. Doe',
            icon: Icons.family_restroom_rounded,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Last name required';
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.rp(20)),
          ModernTextField(
            controller: _authController.phoneNumber,
            label: 'Mobile Number',
            hint: '10-digit number',
            icon: Icons.phone_iphone_rounded,
            inputType: TextInputType.phone,
            prefixText: '+91 ',
            maxLength: 10,
            onSimTap: _showSimSelectionDialog,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Phone number is required';
              if (v.length != 10) return 'Enter valid 10-digit number';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // --- Step 2: OTP Verification ---
  Widget _buildStep2Otp() {
    return Form(
      key: _step2Key,
      child: Column(
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
                    _currentStep = 0;
                    _authController.setOtpSent(false);
                    _authController.otpController.clear();
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
          SizedBox(height: ResponsiveUtils.rp(24)),
          _buildResendSection(),
        ],
      ),
    );
  }

  Widget _buildOtpField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.rp(12),
            offset: Offset(0, ResponsiveUtils.rp(4)),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(24),
        vertical: ResponsiveUtils.rp(24),
      ),
      child: TextFormField(
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
          if (value.length == 4) {
            _handleFinalSubmit();
          }
        },
        validator: (v) => (v?.length ?? 0) < 4 ? "" : null,
        decoration: InputDecoration(
          hintText: '○ ○ ○ ○',
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.3),
            fontSize: ResponsiveUtils.sp(32),
            letterSpacing: ResponsiveUtils.rp(16),
            fontWeight: FontWeight.w300,
          ),
          border: InputBorder.none,
        ),
      ),
    );
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
        Obx(() => TextButton.icon(
          onPressed: _authController.isLoading ? null : () => _authController.resendOtp(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(20),
              vertical: ResponsiveUtils.rp(12),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            ),
          ),
          icon: Icon(
            Icons.refresh_rounded,
            size: ResponsiveUtils.rp(18),
            color: AppColors.button,
          ),
          label: Text(
            'Resend Code',
            style: TextStyle(
              color: AppColors.button,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.sp(14),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(24),
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.8,
            height: 1.2,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(10)),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            color: AppColors.textSecondary,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Obx(() {
      final isLoading = _authController.isLoading;

      return Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              flex: 1,
              child: Container(
                height: ResponsiveUtils.rp(58),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: ResponsiveUtils.rp(12),
                      offset: Offset(0, ResponsiveUtils.rp(4)),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isLoading ? null : _prevStep,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.textPrimary,
                            size: ResponsiveUtils.rp(18),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(6)),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.textPrimary,
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
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(16)),
          ],

          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: Container(
              height: ResponsiveUtils.rp(58),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
                gradient: LinearGradient(
                  colors: [AppColors.button, AppColors.buttonLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
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
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : _nextStep,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: ResponsiveUtils.rp(26),
                            height: ResponsiveUtils.rp(26),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentStep == 1 ? 'Verify & Finish' : 'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ResponsiveUtils.sp(17),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(width: ResponsiveUtils.rp(12)),
                              Container(
                                padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                                ),
                                child: Icon(
                                  _currentStep == 1 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: ResponsiveUtils.rp(18),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed('/login'),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.button,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

// --- Reusable Modern Text Field ---
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final String? prefixText;
  final int? maxLength;
  final String? Function(String?) validator;
  final VoidCallback? onSimTap;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.inputType = TextInputType.text,
    this.prefixText,
    this.maxLength,
    this.onSimTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(6)),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              ),
              child: Icon(
                icon,
                color: AppColors.button,
                size: ResponsiveUtils.rp(16),
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(10)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(15),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.rp(12)),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(16),
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0.3,
          ),
          cursorColor: Colors.black,
          validator: validator,
          maxLength: maxLength,
          textCapitalization: TextCapitalization.words,
          inputFormatters: inputType == TextInputType.phone
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            counterText: "",
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black.withValues(alpha: 0.4),
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveUtils.sp(15),
            ),
            prefixText: prefixText,
            prefixStyle: TextStyle(
              color: AppColors.button,
              fontWeight: FontWeight.w700,
              fontSize: ResponsiveUtils.sp(16),
              letterSpacing: 0.5,
            ),
            suffixIcon: inputType == TextInputType.phone && onSimTap != null
                ? Padding(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                    child: IconButton(
                      icon: Icon(
                        Icons.sim_card_rounded,
                        color: AppColors.button,
                        size: ResponsiveUtils.rp(22),
                      ),
                      onPressed: onSimTap,
                      tooltip: 'Select from SIM',
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.rp(18),
              horizontal: ResponsiveUtils.rp(20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
              borderSide: BorderSide(
                color: AppColors.button,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            errorStyle: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
