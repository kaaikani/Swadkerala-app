import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/sms_autofill_service.dart';
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

  void _prevStep() {
    if (_currentStep > 0) {
      _animateToPage(_currentStep - 1);
    } else {
      Get.back();
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
    final success = await _authController.sendOtp(context);

    if (success) {
      await _startSmsAutofill();
      _animateToPage(1);
    }
  }

  Future<void> _handleFinalSubmit() async {
    final success = await _authController.verifyOtp(context);
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.button.withValues(alpha: 0.08),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Area
              _buildHeader(),

              // Progress Bar
              _buildProgressBar(),

              SizedBox(height: ResponsiveUtils.rp(8)),

              // Content Area
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1PersonalInfo(),
                    _buildStep2Otp(),
                  ],
                ),
              ),

              // Bottom Navigation Bar
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(24),
        vertical: ResponsiveUtils.rp(24),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
              shadowColor: Colors.black12,
              elevation: 2,
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
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
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
    return Container(
      height: 4,
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(24)),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                width: constraints.maxWidth * ((_currentStep + 1) / _totalSteps),
                decoration: BoxDecoration(
                  color: AppColors.button,
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [AppColors.buttonLight, AppColors.button],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Step 1: Personal Info + Phone Number ---
  Widget _buildStep1PersonalInfo() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
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
                if (v == null || v.length != 10) return 'Enter valid 10-digit number';
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
      padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Verification', 'Enter the code sent to +91 ${_authController.phoneNumber.text}'),
            SizedBox(height: ResponsiveUtils.rp(40)),

            Center(
              child: SizedBox(
                width: ResponsiveUtils.rp(220),
                child: TextFormField(
                  controller: _authController.otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(32),
                    fontWeight: FontWeight.bold,
                    letterSpacing: ResponsiveUtils.rp(12),
                    color: AppColors.textPrimary,
                  ),
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "○ ○ ○ ○",
                    hintStyle: TextStyle(
                      color: AppColors.border,
                      fontSize: ResponsiveUtils.sp(32),
                      letterSpacing: ResponsiveUtils.rp(12),
                    ),
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.button, width: 2),
                    ),
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
                icon: Icon(Icons.refresh_rounded, size: 18, color: AppColors.button),
                label: Text(
                  'Resend Code',
                  style: TextStyle(
                    color: AppColors.button,
                    fontWeight: FontWeight.w600,
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
            fontSize: ResponsiveUtils.sp(22),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.rp(20),
            offset: const Offset(0, -5),
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
                child: OutlinedButton(
                  onPressed: isLoading ? null : _prevStep,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(16)),
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveUtils.sp(16),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(16)),
            ],

            Expanded(
              flex: 2,
              child: Container(
                height: ResponsiveUtils.rp(56),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                  gradient: LinearGradient(
                    colors: [AppColors.button, AppColors.buttonLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.3),
                      blurRadius: ResponsiveUtils.rp(20),
                      offset: Offset(0, ResponsiveUtils.rp(8)),
                      spreadRadius: ResponsiveUtils.rp(2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isLoading ? null : _nextStep,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentStep == 1 ? 'Verify & Finish' : 'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveUtils.sp(16),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                if (_currentStep < 1) ...[
                                  SizedBox(width: ResponsiveUtils.rp(8)),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: ResponsiveUtils.rp(20),
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
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(16),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              fontWeight: FontWeight.w400,
            ),
            prefixText: prefixText,
            prefixStyle: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.sp(16),
            ),
            filled: true,
            fillColor: AppColors.inputFill,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
            contentPadding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.rp(16),
              horizontal: ResponsiveUtils.rp(16),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              borderSide: BorderSide(color: AppColors.button, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
