import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../services/channel_service.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/google_auth_env.dart';
import '../../widgets/snackbar.dart';

class AccountUpdateDialogs {
  final CustomerController customerController;
  final VoidCallback? onDialogsComplete;

  AccountUpdateDialogs({
    required this.customerController,
    this.onDialogsComplete,
  });

  bool _isValidGmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email.toLowerCase());
  }

  void checkAndShowUpdateDialogs() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final channelType = ChannelService.getChannelType()?.toUpperCase() ?? '';
    if (channelType.contains('BRAND')) return;

    final isValidEmail = _isValidGmail(customer.emailAddress);
    if (!isValidEmail) {
      showUpdateEmailDialog();
      return;
    }

    final hasPhone = customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty;
    if (!hasPhone) {
      showUpdatePhoneDialog();
    }
  }

  void showUpdateEmailDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    customerController.emailUpdateError.value = '';

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isLoading = false;
              final emailController = TextEditingController();

              return Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email, size: ResponsiveUtils.rp(28), color: AppColors.button),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          child: Text(
                            'Update Email Address',
                            style: TextStyle(fontSize: ResponsiveUtils.sp(20), fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close, size: ResponsiveUtils.rp(24), color: AppColors.textSecondary),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(20)),
                    Text(
                      'Sign in with Google to set your email address',
                      style: TextStyle(fontSize: ResponsiveUtils.sp(14), color: AppColors.textSecondary),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    Obx(() {
                      final errorMsg = customerController.emailUpdateError.value;
                      if (errorMsg.isNotEmpty) {
                        return Container(
                          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                          padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3), width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: AppColors.error, size: ResponsiveUtils.rp(20)),
                              SizedBox(width: ResponsiveUtils.rp(8)),
                              Expanded(
                                child: Text(errorMsg, style: TextStyle(fontSize: ResponsiveUtils.sp(13), color: AppColors.error, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                    SizedBox(height: ResponsiveUtils.rp(16)),
                    SizedBox(
                      width: double.infinity,
                      child: AbsorbPointer(
                        absorbing: isLoading,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            setState(() { isLoading = true; });
                            await _handleGoogleSignInForEmail(context, setState, emailController, () {
                              setState(() { isLoading = false; });
                            });
                          },
                          icon: isLoading
                              ? SizedBox(
                                  width: ResponsiveUtils.rp(20),
                                  height: ResponsiveUtils.rp(20),
                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.button)),
                                )
                              : Image.asset(
                                  'assets/images/google_logo.png',
                                  width: ResponsiveUtils.rp(24),
                                  height: ResponsiveUtils.rp(24),
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.login, size: ResponsiveUtils.rp(20), color: AppColors.button);
                                  },
                                ),
                          label: Text(
                            'Sign in with Google',
                            style: TextStyle(fontSize: ResponsiveUtils.sp(16), fontWeight: FontWeight.w600, color: AppColors.button),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.button, width: 1.5),
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16), vertical: ResponsiveUtils.rp(14)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _handleGoogleSignInForEmail(
    BuildContext context,
    StateSetter setState,
    TextEditingController emailController,
    VoidCallback onComplete,
  ) async {
    setState(() { customerController.emailUpdateError.value = ''; });

    try {
      final googleClientId = GoogleAuthEnv.googleClientId;
      if (googleClientId == null || googleClientId.isEmpty) {
        setState(() { customerController.emailUpdateError.value = 'Google Client ID not configured'; });
        onComplete();
        return;
      }
      if (!GoogleAuthEnv.isIosConfigValid) {
        setState(() {
          customerController.emailUpdateError.value =
              'Set GOOGLE_CLIENT_ID_IOS in .env for iOS (iOS OAuth client). See docs/GOOGLE_AUTH_SETUP.md.';
        });
        onComplete();
        return;
      }
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: googleClientId,
        clientId: GoogleAuthEnv.clientIdForPlatform,
        scopes: ['email'],
      );

      try {
        final currentUser = await googleSignIn.signInSilently();
        if (currentUser != null) await googleSignIn.signOut();
      } catch (e) {
        try { await googleSignIn.signOut(); } catch (_) {}
      }

      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('canceled') || errorStr.contains('cancelled') ||
            errorStr.contains('sign_in_canceled') || errorStr.contains('12501')) {
          onComplete();
          return;
        }
        if (_isDeveloperError(errorStr)) {
          setState(() { customerController.emailUpdateError.value = 'Google Sign-In Configuration Error. Please contact support.'; });
          onComplete();
          return;
        }
        setState(() { customerController.emailUpdateError.value = 'Failed to sign in with Google. Please try again.'; });
        onComplete();
        return;
      }

      if (googleUser == null) { onComplete(); return; }

      final email = googleUser.email;
      if (email.isEmpty) {
        setState(() { customerController.emailUpdateError.value = 'Failed to get email address from Google account'; });
        onComplete();
        return;
      }

      if (!_isValidGmail(email)) {
        setState(() { customerController.emailUpdateError.value = 'Please use a Gmail address (@gmail.com)'; });
        onComplete();
        return;
      }

      setState(() {
        emailController.text = email;
        customerController.emailUpdateError.value = '';
      });

      final success = await customerController.updateCustomerEmail(email);
      onComplete();

      if (success) {
        Get.back();
        showSuccessSnackbar('Email updated successfully');
        checkAndShowUpdateDialogs();
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('canceled') || errorStr.contains('cancelled') ||
          errorStr.contains('sign_in_canceled') || errorStr.contains('12501')) {
        onComplete();
        return;
      }
      if (_isDeveloperError(errorStr)) {
        setState(() { customerController.emailUpdateError.value = 'Google Sign-In Configuration Error. Please contact support.'; });
        onComplete();
        return;
      }
      setState(() { customerController.emailUpdateError.value = 'Failed to sign in with Google. Please try again.'; });
      onComplete();
    }
  }

  bool _isDeveloperError(String errorStr) {
    return errorStr.contains('apiexception: 10') || errorStr.contains('apiException: 10') ||
        errorStr.contains('apiexception:10') || errorStr.contains('error 10') ||
        errorStr.contains('developer_error') || errorStr.contains(': 10:') ||
        errorStr.contains(': 10 ') || RegExp(r'apiexception.*10|error.*10').hasMatch(errorStr);
  }

  void showUpdatePhoneDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final phoneController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20))),
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, size: ResponsiveUtils.rp(28), color: AppColors.button),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: Text('Update Phone Number', style: TextStyle(fontSize: ResponsiveUtils.sp(20), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Text('Please enter your phone number', style: TextStyle(fontSize: ResponsiveUtils.sp(14), color: AppColors.textSecondary)),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  if (errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(12), vertical: ResponsiveUtils.rp(8)),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, size: ResponsiveUtils.rp(18), color: AppColors.error),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Expanded(child: Text(errorMessage!, style: TextStyle(fontSize: ResponsiveUtils.sp(13), color: AppColors.error, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.rp(12)),
                  ],
                  TextField(
                    controller: phoneController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter 10 digit phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)), borderSide: BorderSide(color: errorMessage != null ? AppColors.error : AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)), borderSide: BorderSide(color: errorMessage != null ? AppColors.error : AppColors.border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)), borderSide: BorderSide(color: errorMessage != null ? AppColors.error : AppColors.button, width: 2)),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (errorMessage != null) setState(() { errorMessage = null; });
                      if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        setState(() { errorMessage = 'Only numbers are allowed'; });
                      }
                    },
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          final phone = phoneController.text.trim();
                          if (phone.isEmpty) { setState(() { errorMessage = 'Please enter a phone number'; }); return; }
                          if (!RegExp(r'^[0-9]+$').hasMatch(phone)) { setState(() { errorMessage = 'Only numbers are allowed. No special characters.'; }); return; }
                          if (phone.length != 10) { setState(() { errorMessage = 'Phone number must be exactly 10 digits'; }); return; }

                          setState(() { isLoading = true; });
                          try {
                            final success = await customerController.updateCustomerPhoneNumber(phone);
                            if (success) {
                              Navigator.of(context).pop();
                              showSuccessSnackbar('Phone number updated successfully');
                            } else {
                              setState(() { isLoading = false; errorMessage = 'Failed to update phone number. Please try again.'; });
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                              final errorStr = e.toString();
                              if (errorStr.toLowerCase().contains('already registered') || errorStr.toLowerCase().contains('already exists')) {
                                errorMessage = 'This phone number is already registered with another account.';
                              } else {
                                errorMessage = 'Failed to update phone number. Please try again.';
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.button, foregroundColor: Colors.white),
                        child: isLoading
                            ? SizedBox(width: ResponsiveUtils.rp(20), height: ResponsiveUtils.rp(20), child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : Text('Update Phone'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
