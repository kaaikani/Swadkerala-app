import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../services/sms_autofill_service.dart';
import '../theme/theme.dart';
import '../widgets/snackbar.dart';
import '../utils/navigation_helper.dart';
import '../utils/responsive.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final _authController = Get.find<AuthController>();
  final _smsAutofillService = SmsAutofillService();

  final List<Map<String, String>> _cities = [
    {'name': 'Trichy', 'code': 'ind-trichy'},
    {'name': 'Coimbatore', 'code': 'ind-coimbatore'},
    {'name': 'Salem', 'code': 'ind-salem'},
    {'name': 'Madurai', 'code': 'ind-madurai'},
  ];

  String? _selectedCity;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Validation states
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _cityError;
  String? _otpError;

  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _phoneTouched = false;
  bool _cityTouched = false;
  bool _otpTouched = false;

  // UI state for step-based flow
  int _currentStep = 0; // 0: Personal Info, 1: Contact Info, 2: OTP Verification

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

  Future<void> _initializeSmsAutofill() async {
    try {
      await _smsAutofillService.initialize();
    } catch (e) {
// debugPrint('[SignupPage] SMS autofill init error: $e');
    }
  }

  Future<void> _startSmsAutofill() async {
    try {
      await _smsAutofillService.startListening((otp) {
        _authController.otpController.text = otp;
        _validateOtp(otp);
        if (otp.length == 4 && _otpError == null) _verifyOtp();
      });
    } catch (e) {
// debugPrint('[SignupPage] SMS autofill error: $e');
    }
  }

  void _validateFirstName(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _firstNameError = 'First name is required';
      } else if (value.trim().length < 2) {
        _firstNameError = 'Name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        _firstNameError = 'Only letters are allowed';
      } else {
        _firstNameError = null;
      }
    });
  }

  void _validateLastName(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _lastNameError = 'Last name is required';
      } else if (value.trim().length < 2) {
        _lastNameError = 'Name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        _lastNameError = 'Only letters are allowed';
      } else {
        _lastNameError = null;
      }
    });
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

  void _validateCity(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        _cityError = 'Please select a city';
      } else {
        _cityError = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.button.withValues(alpha: 0.1),
              AppColors.buttonLight.withValues(alpha: 0.05),
              AppColors.background,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Top section with back button and header
                  _buildTopSection(),
                  
                  // Main content card
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
      child: Column(
        children: [
          // Back button
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: ResponsiveUtils.rp(8),
                      offset: Offset(0, ResponsiveUtils.rp(2)),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.textPrimary,
                    size: ResponsiveUtils.rp(20),
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(24)),
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
            child: Icon(
              Icons.person_add_rounded,
              size: ResponsiveUtils.rp(40),
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(24)),
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(28),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            'Join us and start shopping',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtils.rp(32)),
          topRight: Radius.circular(ResponsiveUtils.rp(32)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.rp(20),
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: ResponsiveUtils.rp(8)),
            
            // Progress indicator
            _buildProgressIndicator(),
            
            SizedBox(height: ResponsiveUtils.rp(32)),
            
            // Form content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildCurrentStepContent(),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(24)),
                    _buildNavigationButtons(),
                    if (_currentStep == 2)
                      Obx(() {
                        if (!_authController.isOtpSent) return const SizedBox.shrink();
                        return _buildResendSection();
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(20),
        vertical: ResponsiveUtils.rp(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
      ),
      child: Row(
        children: [
          _buildProgressStep(1, 'Personal', _currentStep == 0, _currentStep > 0),
          Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _currentStep > 0
                    ? AppColors.button
                    : AppColors.border.withValues(alpha: 0.3),
              ),
            ),
          ),
          _buildProgressStep(2, 'Contact', _currentStep == 1, _currentStep > 1),
          Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _currentStep > 1
                    ? AppColors.button
                    : AppColors.border.withValues(alpha: 0.3),
              ),
            ),
          ),
          _buildProgressStep(3, 'Verify', _currentStep == 2, false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive, bool isCompleted) {
    return Column(
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
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    size: ResponsiveUtils.rp(18),
                    color: Colors.white,
                  )
                : Text(
                    '$step',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.sp(14),
                    ),
                  ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(4)),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(11),
            color: isActive || isCompleted
                ? AppColors.textPrimary
                : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoSection(key: const ValueKey('personal'));
      case 1:
        return _buildContactInfoSection(key: const ValueKey('contact'));
      case 2:
        return Obx(() {
          if (!_authController.isOtpSent) {
            return const SizedBox.shrink();
          }
          return _buildOtpSection(key: const ValueKey('otp'));
        });
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalInfoSection({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Text(
          'Tell us about yourself',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(24)),
        _buildTextField(
          controller: _authController.firstname,
          label: 'First Name',
          hint: 'Enter your first name',
          hasError: _firstNameTouched && _firstNameError != null,
          isValid: _firstNameTouched &&
              _firstNameError == null &&
              _authController.firstname.text.trim().isNotEmpty,
          onChanged: (value) {
            if (!_firstNameTouched) setState(() => _firstNameTouched = true);
            _validateFirstName(value);
          },
        ),
        if (_firstNameTouched && _firstNameError != null)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
            child: _buildErrorMessage(_firstNameError!),
          ),
        SizedBox(height: ResponsiveUtils.rp(20)),
        _buildTextField(
          controller: _authController.lastname,
          label: 'Last Name',
          hint: 'Enter your last name',
          hasError: _lastNameTouched && _lastNameError != null,
          isValid: _lastNameTouched &&
              _lastNameError == null &&
              _authController.lastname.text.trim().isNotEmpty,
          onChanged: (value) {
            if (!_lastNameTouched) setState(() => _lastNameTouched = true);
            _validateLastName(value);
          },
        ),
        if (_lastNameTouched && _lastNameError != null)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
            child: _buildErrorMessage(_lastNameError!),
          ),
      ],
    );
  }

  Widget _buildContactInfoSection({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Contact Details',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Text(
          'We need this to verify your account',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(24)),
        _buildPhoneField(),
        if (_phoneTouched && _phoneError != null)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
            child: _buildErrorMessage(_phoneError!),
          ),
        SizedBox(height: ResponsiveUtils.rp(20)),
        _buildCityDropdown(),
        if (_cityTouched && _cityError != null)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
            child: _buildErrorMessage(_cityError!),
          ),
      ],
    );
  }

  Widget _buildOtpSection({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Text(
          'Sent to +91 ${_authController.phoneNumber.text}',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(13),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(24)),
        _buildOtpField(),
        if (_otpTouched && _otpError != null)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
            child: _buildErrorMessage(_otpError!),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool hasError,
    required bool isValid,
    required Function(String) onChanged,
  }) {
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
            border: Border.all(
              color: hasError
                  ? AppColors.errorLight
                  : isValid
                      ? AppColors.successLight
                      : AppColors.inputBorder,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            enabled: !_authController.isOtpSent,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                fontSize: ResponsiveUtils.sp(16),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(16),
                vertical: ResponsiveUtils.rp(16),
              ),
              suffixIcon: isValid
                  ? Padding(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: ResponsiveUtils.rp(20),
                      ),
                    )
                  : hasError
                      ? Padding(
                          padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                          child: Icon(
                            Icons.error,
                            color: AppColors.error,
                            size: ResponsiveUtils.rp(20),
                          ),
                        )
                      : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    bool hasError = _phoneTouched && _phoneError != null;
    bool isValid = _phoneTouched &&
        _phoneError == null &&
        _authController.phoneNumber.text.length == 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
            border: Border.all(
              color: hasError
                  ? AppColors.errorLight
                  : isValid
                      ? AppColors.successLight
                      : AppColors.inputBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(16),
                  vertical: ResponsiveUtils.rp(16),
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ResponsiveUtils.rp(16)),
                    bottomLeft: Radius.circular(ResponsiveUtils.rp(16)),
                  ),
                ),
                child: Text(
                  '+91',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: ResponsiveUtils.rp(24),
                color: AppColors.border,
              ),
              Expanded(
                child: TextField(
                  controller: _authController.phoneNumber,
                  keyboardType: TextInputType.phone,
                  enabled: !_authController.isOtpSent,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (value) {
                    if (!_phoneTouched) setState(() => _phoneTouched = true);
                    _validatePhone(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      fontSize: ResponsiveUtils.sp(16),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(16),
                      vertical: ResponsiveUtils.rp(16),
                    ),
                    suffixIcon: isValid
                        ? Padding(
                            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: ResponsiveUtils.rp(20),
                            ),
                          )
                        : hasError
                            ? Padding(
                                padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                                child: Icon(
                                  Icons.error,
                                  color: AppColors.error,
                                  size: ResponsiveUtils.rp(20),
                                ),
                              )
                            : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCityDropdown() {
    bool hasError = _cityTouched && _cityError != null;
    bool isValid = _cityTouched && _cityError == null && _selectedCity != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your City',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
            border: Border.all(
              color: hasError
                  ? AppColors.errorLight
                  : isValid
                      ? AppColors.successLight
                      : AppColors.inputBorder,
              width: 1.5,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCity,
              hint: Text(
                'Choose your city',
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  fontSize: ResponsiveUtils.sp(16),
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
                size: ResponsiveUtils.rp(24),
              ),
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              items: _cities.map((city) {
                return DropdownMenuItem<String>(
                  value: city['code'],
                  child: Text(city['name']!),
                );
              }).toList(),
              onChanged: _authController.isOtpSent
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCity = value;
                        if (!_cityTouched) _cityTouched = true;
                      });
                      _validateCity(value);
                    },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpField() {
    bool hasError = _otpTouched && _otpError != null;
    bool isValid = _otpTouched &&
        _otpError == null &&
        _authController.otpController.text.length == 4;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        border: Border.all(
          color: hasError
              ? AppColors.errorLight
              : isValid
                  ? AppColors.successLight
                  : AppColors.inputBorder,
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(20),
        vertical: ResponsiveUtils.rp(20),
      ),
      child: TextField(
        controller: _authController.otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ResponsiveUtils.sp(24),
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: ResponsiveUtils.rp(12),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        onChanged: (value) {
          if (!_otpTouched) setState(() => _otpTouched = true);
          _validateOtp(value);
          if (value.length == 4 && _otpError == null) _verifyOtp();
        },
        decoration: InputDecoration(
          hintText: '○ ○ ○ ○',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
            fontSize: ResponsiveUtils.sp(24),
            letterSpacing: ResponsiveUtils.rp(12),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Obx(() {
      final isLoading = _authController.isLoading;
      
      bool isEnabled = false;
      String buttonText = 'Next';
      IconData buttonIcon = Icons.arrow_forward_rounded;

      if (_currentStep == 0) {
        isEnabled = _firstNameError == null &&
            _lastNameError == null &&
            _authController.firstname.text.trim().isNotEmpty &&
            _authController.lastname.text.trim().isNotEmpty;
        buttonText = 'Next';
        buttonIcon = Icons.arrow_forward_rounded;
      } else if (_currentStep == 1) {
        isEnabled = _phoneError == null &&
            _cityError == null &&
            _authController.phoneNumber.text.length == 10 &&
            _selectedCity != null;
        buttonText = 'Send OTP';
        buttonIcon = Icons.send_rounded;
      } else if (_currentStep == 2) {
        isEnabled = _otpError == null &&
            _authController.otpController.text.length == 4;
        buttonText = 'Verify & Sign Up';
        buttonIcon = Icons.verified;
      }

      return Row(
        children: [
          if (_currentStep > 0 && !_authController.isOtpSent)
            Expanded(
              flex: 1,
              child: Container(
                height: ResponsiveUtils.rp(56),
                margin: EdgeInsets.only(right: ResponsiveUtils.rp(12)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                  border: Border.all(color: AppColors.border, width: 1.5),
                  color: AppColors.card,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            color: AppColors.textPrimary,
                            size: ResponsiveUtils.rp(18),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(4)),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            flex: _currentStep > 0 && !_authController.isOtpSent ? 2 : 1,
            child: Container(
              height: ResponsiveUtils.rp(56),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                gradient: isEnabled
                    ? LinearGradient(
                        colors: [AppColors.button, AppColors.buttonLight],
                      )
                    : null,
                color: isEnabled ? null : AppColors.inputBorder,
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
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                buttonIcon,
                                color: Colors.white,
                                size: ResponsiveUtils.rp(20),
                              ),
                              SizedBox(width: ResponsiveUtils.rp(12)),
                              Text(
                                buttonText,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(16),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
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

  Widget _buildResendSection() {
    return Column(
      children: [
        SizedBox(height: ResponsiveUtils.rp(16)),
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
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w600,
              color: AppColors.button,
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
    if (_currentStep == 0) {
      setState(() {
        _firstNameTouched = true;
        _lastNameTouched = true;
      });
      
      _validateFirstName(_authController.firstname.text);
      _validateLastName(_authController.lastname.text);
      
      if (_firstNameError == null && _lastNameError == null) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else if (_currentStep == 1) {
      await _sendOtp();
    } else if (_currentStep == 2) {
      await _verifyOtp();
    }
  }

  Future<void> _sendOtp() async {
    setState(() {
      _phoneTouched = true;
      _cityTouched = true;
    });

    _validatePhone(_authController.phoneNumber.text);
    _validateCity(_selectedCity);

    if (_phoneError != null) {
      showErrorSnackbar(_phoneError!);
      return;
    }
    if (_cityError != null) {
      showErrorSnackbar(_cityError!);
      return;
    }

    final userExists = await _authController.checkUserExists();
    if (userExists) {
      showErrorSnackbar('You are already registered. Please login.');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Get.back();
      });
      return;
    }

    await GraphqlService.setToken(key: 'channel', token: _selectedCity!);
    final success = await _authController.sendOtp(context);
    if (success) {
      await _startSmsAutofill();
      setState(() {
        _currentStep = 2;
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _otpTouched = true);
    _validateOtp(_authController.otpController.text);

    if (_otpError != null) {
      showErrorSnackbar(_otpError!);
      return;
    }

    final success = await _authController.verifyOtp(context);
    if (success) {
      await NavigationHelper.redirectToIntendedRoute();
    }
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
