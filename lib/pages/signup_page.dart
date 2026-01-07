import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/sms_autofill_service.dart';
import '../services/graphql_client.dart';
import '../theme/theme.dart';
import '../utils/navigation_helper.dart';
import '../utils/responsive.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _authController = Get.find<AuthController>();
  final _smsAutofillService = SmsAutofillService();

  // Use PageController for smooth sliding between steps
  final PageController _pageController = PageController();

  // Form Keys for separate validation per step
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  int _currentStep = 0;
  final int _totalSteps = 2;

  @override
  void initState() {
    super.initState();
    _initializeSmsAutofill();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authController.resetFormField();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _smsAutofillService.stopListening();
    super.dispose();
  }

  Future<void> _initializeSmsAutofill() async {
    try {
      await _smsAutofillService.initialize();
    } catch (e) {
      debugPrint('[SignupPage] SMS init error: $e');
    }
  }

  Future<void> _startSmsAutofill() async {
    try {
      await _smsAutofillService.startListening((otp) {
        _authController.otpController.text = otp;
        if (otp.length == 4) _handleFinalSubmit();
      });
    } catch (e) {
      debugPrint('[SignupPage] SMS listening error: $e');
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
      debugPrint('[SignupPage] Clearing cache before returning to login...');
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      final storage = GetStorage();
      await storage.erase();
      _authController.setLoggedIn(false);
      _authController.setOtpSent(false);
      _authController.resetFormField();
      debugPrint('[SignupPage] ✅ Cache cleared successfully');
    } catch (e) {
      debugPrint('[SignupPage] Error clearing cache: $e');
    }
  }

  void _animateToPage(int page) {
    setState(() => _currentStep = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutQuart,
    );
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

  // --- UI Construction ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Container(
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
          child: Stack(
            children: [
              // Decorative Background
              _buildBackgroundDecorations(),
              
              // Main Content
              Column(
                children: [
                  // Compact Header
                  _buildCompactHeader(),
                  
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  
                  // Progress Indicator
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(20)),
                    child: _buildProgressBar(),
                  ),
                  
                  SizedBox(height: ResponsiveUtils.rp(24)),
                  
                  // Content Area - Floating Card
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(20)),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 420,
                                minHeight: constraints.maxHeight,
                              ),
                              child: _buildFloatingContentCard(
                                availableHeight: constraints.maxHeight,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Bottom Navigation Bar
                  _buildBottomBar(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // Top Right Circle
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.button.withValues(alpha: 0.1),
                  AppColors.button.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Bottom Left Circle
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.button.withValues(alpha: 0.08),
                  AppColors.button.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(20),
        ResponsiveUtils.rp(16),
        ResponsiveUtils.rp(20),
        ResponsiveUtils.rp(8),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: ResponsiveUtils.rp(12),
                  offset: Offset(0, ResponsiveUtils.rp(4)),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: ResponsiveUtils.rp(18),
              ),
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
            ),
          ),
          SizedBox(width: ResponsiveUtils.rp(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(24),
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.8,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(13),
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildFloatingContentCard({double? availableHeight}) {
    final height = availableHeight != null && availableHeight > 0
        ? availableHeight - ResponsiveUtils.rp(40)
        : MediaQuery.of(context).size.height * 0.6;
    
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: ResponsiveUtils.rp(40),
            offset: Offset(0, ResponsiveUtils.rp(15)),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.rp(30),
            offset: Offset(0, ResponsiveUtils.rp(10)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SizedBox(
        height: height,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStep1PersonalInfo(),
            _buildStep2Otp(),
          ],
        ),
      ),
    );
  }

  // --- Step 1: Personal Info + Phone Number ---
  Widget _buildStep1PersonalInfo() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(ResponsiveUtils.rp(28)),
      child: Form(
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
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Phone number is required';
                if (v.length != 10) return 'Enter valid 10-digit number';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 2: OTP Verification ---
  Widget _buildStep2Otp() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(ResponsiveUtils.rp(28)),
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Verification', 'Enter the code sent to +91 ${_authController.phoneNumber.text}'),
            SizedBox(height: ResponsiveUtils.rp(40)),

            Center(
              child: Container(
                width: ResponsiveUtils.rp(240),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(24),
                  vertical: ResponsiveUtils.rp(24),
                ),
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
                child: TextFormField(
                  controller: _authController.otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(32),
                    fontWeight: FontWeight.w800,
                    letterSpacing: ResponsiveUtils.rp(16),
                    color: AppColors.textPrimary,
                  ),
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "○ ○ ○ ○",
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                      fontSize: ResponsiveUtils.sp(32),
                      letterSpacing: ResponsiveUtils.rp(16),
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    if (val.length == 4) _handleFinalSubmit();
                  },
                  validator: (v) => (v?.length ?? 0) < 4 ? "" : null,
                ),
              ),
            ),

            SizedBox(height: ResponsiveUtils.rp(32)),
            Center(
              child: Obx(() => TextButton.icon(
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
            ),
          ],
        ),
      ),
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

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.rp(24),
        ResponsiveUtils.rp(20),
        ResponsiveUtils.rp(24),
        ResponsiveUtils.rp(24),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.rp(30),
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Obx(() {
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
              flex: 2,
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
                                if (_currentStep < 1) ...[
                                  SizedBox(width: ResponsiveUtils.rp(12)),
                                  Container(
                                    padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: ResponsiveUtils.rp(18),
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(width: ResponsiveUtils.rp(12)),
                                  Container(
                                    padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: ResponsiveUtils.rp(18),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
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
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
          cursorColor: AppColors.button,
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
              color: AppColors.textSecondary.withValues(alpha: 0.4),
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
