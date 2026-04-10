import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/analytics_helper.dart';
import '../../widgets/snackbar.dart';

class AccountEditProfileDialog {
  final CustomerController customerController;
  final VoidCallback? onEmailUpdateRequested;

  AccountEditProfileDialog({
    required this.customerController,
    this.onEmailUpdateRequested,
  });

  Widget _buildFieldLabel(String label, bool isEmpty) {
    return Row(
      children: [
        if (isEmpty) ...[
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(right: ResponsiveUtils.rp(6)),
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  bool _isValidGmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email.toLowerCase());
  }

  void show() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final hasValidPhone = customer.phoneNumber != null && customer.phoneNumber!.isNotEmpty;
    final hasValidEmail = _isValidGmail(customer.emailAddress);
    final canEditOnlyName = hasValidPhone || hasValidEmail;

    final firstNameController = TextEditingController(text: customer.firstName);
    final lastNameController = TextEditingController(text: customer.lastName);
    final emailController = TextEditingController(
      text: customer.emailAddress.isNotEmpty ? customer.emailAddress : '',
    );
    // Sanitize phone: strip non-digits, then take last 10 digits
    // Server may store phone with country code (e.g. "+919876543210")
    // which bypasses inputFormatters set on the TextField
    final rawPhone = customer.phoneNumber ?? '';
    final digitsOnly = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final sanitizedPhone = digitsOnly.length > 10 ? digitsOnly.substring(digitsOnly.length - 10) : digitsOnly;
    final phoneController = TextEditingController(
      text: sanitizedPhone,
    );
    const List<String> titleOptions = ['Mr.', 'Ms.', 'Miss'];
    String? selectedTitle;
    if (customer.title != null && customer.title!.isNotEmpty) {
      final t = customer.title!.trim();
      final lower = t.toLowerCase();
      if (lower == 'male' || lower == 'mr' || lower == 'mr.') {
        selectedTitle = 'Mr.';
      } else if (lower == 'female' || lower == 'ms' || lower == 'ms.') {
        selectedTitle = 'Ms.';
      } else if (lower == 'miss' || lower == 'others') {
        selectedTitle = 'Miss';
      } else if (titleOptions.contains(t)) {
        selectedTitle = t;
      } else {
        selectedTitle = t;
      }
    }
    bool isLoading = false;
    String? titleError;
    String? firstNameError;
    String? lastNameError;
    String? emailError;
    String? phoneError;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(20),
          vertical: ResponsiveUtils.rp(40),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: ResponsiveUtils.rp(20),
                    offset: Offset(0, ResponsiveUtils.rp(10)),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                    decoration: BoxDecoration(
                      color: AppColors.button.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(ResponsiveUtils.rp(20)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                          decoration: BoxDecoration(
                            color: AppColors.button,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: ResponsiveUtils.rp(24),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(20),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close_rounded),
                          color: AppColors.textSecondary,
                          iconSize: ResponsiveUtils.rp(24),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title dropdown
                          _buildFieldLabel('Title', selectedTitle?.isEmpty ?? true),
                          SizedBox(height: ResponsiveUtils.rp(8)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(12)),
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                              border: Border.all(color: AppColors.border, width: 1),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedTitle != null && titleOptions.contains(selectedTitle)
                                    ? selectedTitle
                                    : null,
                                isExpanded: true,
                                hint: Text(
                                  'Select',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(16),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
                                items: titleOptions
                                    .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        selectedTitle = value;
                                        titleError = null;
                                        setState(() {});
                                      },
                              ),
                            ),
                          ),
                          if (titleError != null) ...[
                            SizedBox(height: ResponsiveUtils.rp(4)),
                            Text(titleError!, style: TextStyle(fontSize: ResponsiveUtils.sp(12), color: AppColors.error)),
                          ],
                          SizedBox(height: ResponsiveUtils.rp(20)),
                          // First Name
                          _buildFieldLabel('First Name', firstNameController.text.trim().isEmpty),
                          SizedBox(height: ResponsiveUtils.rp(8)),
                          _buildTextField(
                            controller: firstNameController,
                            hint: 'Enter first name',
                            icon: Icons.person_outline,
                            error: firstNameError,
                            enabled: !isLoading,
                            onChanged: (_) {
                              firstNameError = null;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: ResponsiveUtils.rp(20)),
                          // Last Name
                          _buildFieldLabel('Last Name', lastNameController.text.trim().isEmpty),
                          SizedBox(height: ResponsiveUtils.rp(8)),
                          _buildTextField(
                            controller: lastNameController,
                            hint: 'Enter last name',
                            icon: Icons.person_outline,
                            error: lastNameError,
                            enabled: !isLoading,
                            onChanged: (_) {
                              lastNameError = null;
                              setState(() {});
                            },
                          ),
                          SizedBox(height: ResponsiveUtils.rp(20)),
                          if (!canEditOnlyName) ...[
                            // Email Field
                            _buildFieldLabel('Email', emailController.text.trim().isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            _buildTextField(
                              controller: emailController,
                              hint: 'Enter email address',
                              icon: Icons.email_outlined,
                              error: emailError,
                              enabled: !isLoading && !canEditOnlyName,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) {
                                emailError = null;
                                setState(() {});
                              },
                            ),
                            if (customer.emailAddress.isEmpty ||
                                !customer.emailAddress.toLowerCase().endsWith('@gmail.com')) ...[
                              SizedBox(height: ResponsiveUtils.rp(12)),
                              OutlinedButton.icon(
                                onPressed: isLoading ? null : () {
                                  AnalyticsHelper.trackButton(
                                    'Connect with Google - Profile',
                                    screenName: 'Account',
                                    callback: () {
                                      _showGoogleAccountSelectionDialog(context, setState, emailController);
                                    },
                                  )?.call();
                                },
                                icon: Image.asset(
                                  'assets/images/google_logo.png',
                                  width: ResponsiveUtils.rp(20),
                                  height: ResponsiveUtils.rp(20),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.login, size: ResponsiveUtils.rp(20), color: AppColors.button);
                                  },
                                ),
                                label: Text(
                                  'Connect with Google',
                                  style: TextStyle(fontSize: ResponsiveUtils.sp(14), fontWeight: FontWeight.w600, color: AppColors.button),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.button, width: 1.5),
                                  padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16), vertical: ResponsiveUtils.rp(12)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12))),
                                ),
                              ),
                            ],
                            SizedBox(height: ResponsiveUtils.rp(20)),
                            // Phone Number
                            _buildFieldLabel('Phone Number', phoneController.text.trim().isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            _buildPhoneField(phoneController, phoneError, isLoading, (_) {
                              phoneError = null;
                              setState(() {});
                            }),
                          ] else ...[
                            // Read-only email with Edit button
                            _buildFieldLabel('Email', customer.emailAddress.isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(16),
                                vertical: ResponsiveUtils.rp(14),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                                border: Border.all(color: AppColors.border, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.email_outlined, color: AppColors.textSecondary, size: ResponsiveUtils.rp(22)),
                                  SizedBox(width: ResponsiveUtils.rp(12)),
                                  Expanded(
                                    child: Text(
                                      customer.emailAddress.isNotEmpty ? customer.emailAddress : 'No email address',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(16),
                                        color: customer.emailAddress.isNotEmpty ? AppColors.textPrimary : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Get.back();
                                      onEmailUpdateRequested?.call();
                                    },
                                    icon: Icon(Icons.edit_outlined, size: ResponsiveUtils.rp(18), color: AppColors.button),
                                    label: Text('Edit', style: TextStyle(fontSize: ResponsiveUtils.sp(14), fontWeight: FontWeight.w600, color: AppColors.button)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ResponsiveUtils.rp(20)),
                            // Phone Number
                            _buildFieldLabel('Phone Number', phoneController.text.trim().isEmpty),
                            SizedBox(height: ResponsiveUtils.rp(8)),
                            _buildPhoneField(phoneController, phoneError, isLoading, (_) {
                              phoneError = null;
                              setState(() {});
                            }),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Actions
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border, width: 1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading ? null : () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.border),
                              foregroundColor: AppColors.textPrimary,
                              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12))),
                            ),
                            child: Text('Cancel', style: TextStyle(fontSize: ResponsiveUtils.sp(16), fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () async {
                              final firstName = firstNameController.text.trim();
                              final lastName = lastNameController.text.trim();
                              final phone = phoneController.text.trim();

                              titleError = null;
                              firstNameError = null;
                              lastNameError = null;
                              emailError = null;
                              phoneError = null;

                              bool hasError = false;
                              if (selectedTitle == null || selectedTitle!.trim().isEmpty) { titleError = 'Required'; hasError = true; }
                              if (firstName.isEmpty) { firstNameError = 'Required'; hasError = true; }
                              if (lastName.isEmpty) { lastNameError = 'Required'; hasError = true; }
                              if (!canEditOnlyName) {
                                if (emailController.text.trim().isEmpty) { emailError = 'Required'; hasError = true; }
                                if (phone.isEmpty) { phoneError = 'Required'; hasError = true; }
                              }
                              if (phone.isNotEmpty) {
                                if (!RegExp(r'^[0-9]+$').hasMatch(phone)) { phoneError = 'Phone must be digits only'; hasError = true; }
                                else if (phone.length != 10) { phoneError = 'Must be exactly 10 digits'; hasError = true; }
                              }

                              if (hasError) {
                                setState(() {});
                                // Show specific error instead of generic message
                                if (phoneError != null && phoneError != 'Required') {
                                  showErrorSnackbar(phoneError!);
                                } else {
                                  showErrorSnackbar('Please fill all required fields');
                                }
                                return;
                              }

                              setState(() { isLoading = true; });

                              customerController.firstNameController.text = firstName;
                              customerController.lastNameController.text = lastName;

                              bool success = await customerController.updateCustomer(title: selectedTitle);
                              if (success && phone.isNotEmpty && phone != (customer.phoneNumber ?? '')) {
                                try {
                                  final phoneSuccess = await customerController.updateCustomerPhoneNumber(phone);
                                  if (!phoneSuccess) {
                                    showErrorSnackbar('Profile saved but phone update failed. Try updating phone separately.');
                                  }
                                } catch (e) {
                                  final msg = e.toString().replaceFirst('Exception: ', '');
                                  showErrorSnackbar(msg.isNotEmpty ? msg : 'Failed to update phone number');
                                }
                              }

                              setState(() { isLoading = false; });

                              if (success) {
                                // Close all open dialogs to ensure edit profile dialog closes
                                // even if a nested dialog (Google account, manual email) is stacked
                                if (Get.isDialogOpen == true) {
                                  Get.back();
                                }
                                showSuccessSnackbar('Profile updated successfully');
                              } else {
                                showErrorSnackbar('Failed to update profile');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.button,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12))),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: ResponsiveUtils.rp(20),
                                    height: ResponsiveUtils.rp(20),
                                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                  )
                                : Text('Save Changes', style: TextStyle(fontSize: ResponsiveUtils.sp(16), fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? error,
    bool enabled = true,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(fontSize: ResponsiveUtils.sp(16), color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        errorText: error,
        prefixIcon: Icon(icon, color: AppColors.button),
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          borderSide: BorderSide(color: AppColors.button, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(16),
          vertical: ResponsiveUtils.rp(16),
        ),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller, String? error, bool isLoading, ValueChanged<String> onChanged) {
    return TextField(
      controller: controller,
      enabled: !isLoading,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      style: TextStyle(fontSize: ResponsiveUtils.sp(16), color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Enter phone number',
        errorText: error,
        prefixIcon: Icon(Icons.phone_outlined, color: AppColors.button),
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          borderSide: BorderSide(color: AppColors.button, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(16),
          vertical: ResponsiveUtils.rp(16),
        ),
        counterText: '',
      ),
    );
  }

  Future<void> _showGoogleAccountSelectionDialog(
    BuildContext context,
    StateSetter setState,
    TextEditingController emailController,
  ) async {
    try {
      const platform = MethodChannel('com.Swadkerala.Swadkerala/account_manager');
      final List<dynamic> accounts = await platform.invokeMethod('getGoogleAccounts') as List<dynamic>;

      if (accounts.isNotEmpty) {
        final List<Map<String, String>> accountList = accounts.map((account) {
          return {
            'email': account['email'] as String,
            'type': account['type'] as String? ?? 'com.google',
          };
        }).toList();

        final selectedAccount = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20))),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, size: ResponsiveUtils.rp(28), color: AppColors.button),
                      SizedBox(width: ResponsiveUtils.rp(12)),
                      Expanded(
                        child: Text('Select Google Account', style: TextStyle(fontSize: ResponsiveUtils.sp(20), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ),
                      IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close), color: AppColors.textSecondary),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.rp(20)),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: accountList.length,
                      itemBuilder: (context, index) {
                        final account = accountList[index];
                        final email = account['email'] ?? '';
                        return ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person)),
                          title: Text(email, style: TextStyle(fontSize: ResponsiveUtils.sp(16), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          trailing: Icon(Icons.arrow_forward_ios, size: ResponsiveUtils.rp(16), color: AppColors.textSecondary),
                          onTap: () => Navigator.of(context).pop(account),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12))),
                          contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16), vertical: ResponsiveUtils.rp(8)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        if (selectedAccount != null) {
          final selectedEmail = selectedAccount['email'] ?? '';
          if (selectedEmail.isNotEmpty) {
            emailController.text = selectedEmail;
            setState(() {});
            return;
          }
        }
      }
    } catch (e) {
      // Fall through to manual input
    }

    _showManualEmailInputDialog(context, setState, emailController);
  }

  void _showManualEmailInputDialog(
    BuildContext context,
    StateSetter setState,
    TextEditingController emailController,
  ) {
    final manualEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20))),
        child: Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.email, size: ResponsiveUtils.rp(28), color: AppColors.button),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(child: Text('Enter Email Address', style: TextStyle(fontSize: ResponsiveUtils.sp(20), fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close), color: AppColors.textSecondary),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
              TextField(
                controller: manualEmailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)), borderSide: BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)), borderSide: BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)), borderSide: BorderSide(color: AppColors.button, width: 2)),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  ElevatedButton(
                    onPressed: () {
                      final email = manualEmailController.text.trim();
                      if (email.isNotEmpty) {
                        emailController.text = email;
                        setState(() {});
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.button, foregroundColor: Colors.white),
                    child: Text('Use Email'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
