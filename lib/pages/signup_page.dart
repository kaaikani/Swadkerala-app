import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../services/graphql_client.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';
import '../widgets/button.dart';
import '../widgets/snackbar.dart';
import '../widgets/textbox.dart';
import 'homepage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _authController = Get.find<AuthController>();
  bool _isOtpVisible = false;



  @override
  void initState() {
    super.initState();
    // Schedule state reset after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetState();
    });
  }

  void _resetState() {
    _authController.resetFormField();
    setState(() {
      _isOtpVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping anywhere on screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Top half background image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.45,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const Spacer(),
                      // Logo or Image placeholder
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_add,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom card with form
            Positioned(
              top: screenHeight * 0.40,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSizes.defaultPadding * 1.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _buildFirstNameField(),
                      const SizedBox(height: 20),
                      _buildLastNameField(),
                      const SizedBox(height: 20),
                      _buildPhoneNumberField(),
                      const SizedBox(height: 20),
/*
                      _buildCityDropdown(),
*/
                      const SizedBox(height: 20),
                      _buildOtpField(),
                      const SizedBox(height: 30),
                      _buildSignupButton(),
                      const SizedBox(height: 16),
                      _buildResendButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextButtonField(
      controller: _authController.firstname,
      hint: 'First Name',
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      enabled: !_isOtpVisible,
    );
  }

  Widget _buildLastNameField() {
    return TextButtonField(
      controller: _authController.lastname,
      hint: 'Last Name',
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      enabled: !_isOtpVisible,
    );
  }

  Widget _buildPhoneNumberField() {
    return TextButtonField(
      controller: _authController.phoneNumber,
      hint: 'Phone Number',
      prefixText: '+91 ',
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      enabled: !_isOtpVisible,
    );
  }



  Widget _buildOtpField() {
    return Obx(() {
      if (!_authController.isOtpSent) return const SizedBox.shrink();

      return Column(
        children: [
          TextButtonField(
            controller: _authController.otpController,
            hint: '4-Digit OTP',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'OTP sent to +91 ${_authController.phoneNumber.text}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      );
    });
  }

  Widget _buildSignupButton() {
    return Obx(() {
      final isLoading = _authController.isLoading;
      final isOtpSent = _authController.isOtpSent;

      return AppButton(
        text: isOtpSent ? 'Verify & Sign Up' : 'Send OTP',
        backgroundColor: AppColors.primary,
        onPressed: isLoading ? null : _handleButtonPress,
      );
    });
  }

  Widget _buildResendButton() {
    return Obx(() {
      if (!_authController.isOtpSent) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Didn't receive OTP? ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          TextButton(
            onPressed: _authController.isLoading ? null : _handleResendOtp,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text(
              'Resend',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    });
  }

  Future<void> _handleButtonPress() async {
    if (_authController.isOtpSent) {
      await _verifyOtp();
    } else {
      await _sendOtp();
    }
  }

  Future<void> _sendOtp() async {

    final String defaultCityName = dotenv.env['DEFAULT_CITY_NAME'] ?? "";
    final String defaultChannelToken = "";


    // Validate first name
    if (_authController.firstname.text.trim().isEmpty) {
      SnackBarWidget.show(
        context,
        'Please enter your first name',
        backgroundColor: AppColors.error,
      );

      return;
    }

    // Validate last name
    if (_authController.lastname.text.trim().isEmpty) {
      SnackBarWidget.show(
        context,
        'Please enter your last name',
        backgroundColor: AppColors.error,
      );

      return;
    }

    // Validate phone number
    if (_authController.phoneNumber.text.length != 10) {
      SnackBarWidget.show(
        context,
        'Please enter a valid 10-digit phone number',
        backgroundColor: AppColors.error, // optional, uses AppColors.background by default
      );

      return;
    }

    // Check if user is already registered (across all channels)
    debugPrint('[Signup] Checking if user already exists in any channel');

    final userExists = await _authController.checkUserExists();

    if (userExists) {
      final channelCode = _authController.currentChannelCode;
      SnackBarWidget.show(
        context,
        'You are already registered in $channelCode. Please login.',
        backgroundColor: AppColors.error, // optional, override default
        duration: const Duration(seconds: 5), // optional, override default
      );

      debugPrint('[Signup] User already registered in channel: $channelCode');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Get.back();
        }
      });
      return;
    }

    // Set hardcoded channel token BEFORE sending OTP
    _authController.setChannelCode(defaultCityName);
    _authController.setChannelToken(defaultChannelToken);
    await GraphqlService.setToken(key: 'channel', token: defaultChannelToken);
    debugPrint('[Signup] New user - Sending OTP with channel: $defaultCityName, token: $defaultChannelToken');

    final success = await _authController.sendOtp(context);
    if (success) {
      setState(() => _isOtpVisible = true);
    }
  }

  Future<void> _verifyOtp() async {
    if (_authController.otpController.text.length != 4) {
      SnackBarWidget.show(
        context,
        'Please enter a valid 4-digit OTP',
        backgroundColor: AppColors.error,
      );

      return;
    }

    final success = await _authController.verifyOtp(context);
    if (success) {
      Get.offAll(() =>  MyHomePage());
    }
  }

  Future<void> _handleResendOtp() async {
    await _authController.resendOtp(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}