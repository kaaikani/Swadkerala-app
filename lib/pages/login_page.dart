import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';
import '../widgets/button.dart';
import '../widgets/textbox.dart';
import 'homepage.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top gradient container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.65,
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
              child: Center(
                child: Container(
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
                    Icons.login,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          // Bottom draggable card
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    left: AppSizes.defaultPadding * 1.5,
                    right: AppSizes.defaultPadding * 1.5,
                    top: AppSizes.defaultPadding * 1.5,
                    bottom: keyboardHeight + AppSizes.defaultPadding * 1.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _buildPhoneNumberField(),
                      const SizedBox(height: 20),
                      _buildOtpField(),
                      const SizedBox(height: 30),
                      _buildLoginButton(),
                      const SizedBox(height: 16),
                      _buildResendButton(),
                      const SizedBox(height: 24),
                      _buildSignupLink(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
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

  Widget _buildLoginButton() {
    return Obx(() {
      final isLoading = _authController.isLoading;
      final isOtpSent = _authController.isOtpSent;

      return AppButton(
        text: isOtpSent ? 'Verify & Login' : 'Send OTP',
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

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => const SignupPage());
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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
    if (_authController.phoneNumber.text.length != 10) {
      return;
    }

    final success = await _authController.startLoginFlow(context);
    if (success) {
      setState(() => _isOtpVisible = true);
    }
  }

  Future<void> _verifyOtp() async {
    if (_authController.otpController.text.length != 4) {
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


