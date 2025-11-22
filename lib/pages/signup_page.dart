import 'package:flutter/material.dart';
import '../widgets/shimmers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../services/sms_autofill_service.dart';
import '../theme/theme.dart';
import '../widgets/snackbar.dart';
import '../utils/navigation_helper.dart';

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
      debugPrint('[SignupPage] SMS autofill init error: $e');
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
      debugPrint('[SignupPage] SMS autofill error: $e');
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
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
                    const SizedBox(height: 20),

                    // Back Button and Header
                    _buildHeader(),

                    const SizedBox(height: 40),

                    // Main Form Card
                    _buildFormCard(),

                    const SizedBox(height: 30),
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
    return Column(
      children: [
        // Back Button
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.person_add_alt_1,
            size: 50,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 30),

        // Welcome Text
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Join us today',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Info Section
            _buildPersonalInfoSection(),

            const SizedBox(height: 30),

            // Contact Info Section
            _buildContactInfoSection(),

            const SizedBox(height: 30),

            // OTP Section
            Obx(() {
              if (!_authController.isOtpSent) return const SizedBox.shrink();
              return _buildOtpSection();
            }),

            const SizedBox(height: 30),

            // Action Button
            _buildActionButton(),

            // Resend OTP
            Obx(() {
              if (!_authController.isOtpSent) return const SizedBox.shrink();
              return _buildResendSection();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // First Name
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
          _buildErrorMessage(_firstNameError!),

        if (_firstNameTouched &&
            _firstNameError == null &&
            _authController.firstname.text.trim().isNotEmpty)
          _buildSuccessMessage('Valid name'),

        const SizedBox(height: 20),

        // Last Name
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
          _buildErrorMessage(_lastNameError!),

        if (_lastNameTouched &&
            _lastNameError == null &&
            _authController.lastname.text.trim().isNotEmpty)
          _buildSuccessMessage('Valid name'),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.contact_phone,
                color: Colors.blue[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Contact Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Phone Number
        _buildPhoneField(),

        if (_phoneTouched && _phoneError != null)
          _buildErrorMessage(_phoneError!),

        if (_phoneTouched &&
            _phoneError == null &&
            _authController.phoneNumber.text.length == 10)
          _buildSuccessMessage('Valid phone number'),

        const SizedBox(height: 20),

        // City
        _buildCityDropdown(),

        if (_cityTouched && _cityError != null) _buildErrorMessage(_cityError!),

        if (_cityTouched && _cityError == null && _selectedCity != null)
          _buildSuccessMessage('City selected'),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.verified_user,
                color: Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Sent to +91 ${_authController.phoneNumber.text}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 15),
        _buildOtpField(),
        if (_otpTouched && _otpError != null) _buildErrorMessage(_otpError!),
        if (_otpTouched &&
            _otpError == null &&
            _authController.otpController.text.length == 4)
          _buildSuccessMessage('Valid OTP'),
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
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : isValid
                      ? Colors.green
                      : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            enabled: !_authController.isOtpSent,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: isValid
                  ? const Icon(Icons.check_circle,
                      color: Colors.green, size: 20)
                  : hasError
                      ? const Icon(Icons.error, color: Colors.red, size: 20)
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
        const Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : isValid
                      ? Colors.green
                      : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: const Text(
                  '+91',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey[300],
              ),
              Expanded(
                child: TextField(
                  controller: _authController.phoneNumber,
                  keyboardType: TextInputType.phone,
                  enabled: !_authController.isOtpSent,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                    hintText: 'Enter 10 digit mobile number',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    suffixIcon: isValid
                        ? const Icon(Icons.check_circle,
                            color: Colors.green, size: 20)
                        : hasError
                            ? const Icon(Icons.error,
                                color: Colors.red, size: 20)
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
        const Text(
          'Select Your City',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : isValid
                      ? Colors.green
                      : Colors.grey[300]!,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCity,
              hint: Text(
                'Choose your city',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: Colors.grey[700], size: 24),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError
              ? Colors.red
              : isValid
                  ? Colors.green
                  : Colors.grey[300]!,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: TextField(
        controller: _authController.otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 16,
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
            color: Colors.grey[300],
            fontSize: 24,
            letterSpacing: 16,
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

      bool isEnabled;
      if (isOtpSent) {
        isEnabled =
            _otpError == null && _authController.otpController.text.length == 4;
      } else {
        isEnabled = _firstNameError == null &&
            _lastNameError == null &&
            _phoneError == null &&
            _cityError == null &&
            _authController.firstname.text.trim().isNotEmpty &&
            _authController.lastname.text.trim().isNotEmpty &&
            _authController.phoneNumber.text.length == 10 &&
            _selectedCity != null;
      }

      return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8)
                  ],
                )
              : null,
          color: isEnabled ? null : Colors.grey[300],
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isLoading || !isEnabled) ? null : _handleButtonPress,
            borderRadius: BorderRadius.circular(15),
            child: Center(
              child: isLoading
                  ? Skeletons.smallBox(size: 28)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isOtpSent ? Icons.check_circle_outline : Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isOtpSent ? 'Verify & Sign Up' : 'Send OTP',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
        const SizedBox(height: 20),
        Text(
          "Didn't receive the code?",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _authController.isLoading ? null : _handleResendOtp,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Resend OTP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.red[700],
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
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 18),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.green[700],
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
    // Touch all fields to show validation
    setState(() {
      _firstNameTouched = true;
      _lastNameTouched = true;
      _phoneTouched = true;
      _cityTouched = true;
    });

    // Validate all fields
    _validateFirstName(_authController.firstname.text);
    _validateLastName(_authController.lastname.text);
    _validatePhone(_authController.phoneNumber.text);
    _validateCity(_selectedCity);

    // Check for any errors
    if (_firstNameError != null) {
      showErrorSnackbar(_firstNameError!);
      return;
    }
    if (_lastNameError != null) {
      showErrorSnackbar(_lastNameError!);
      return;
    }
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
      // After successful signup, redirect to intended route or home through AuthWrapper
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
