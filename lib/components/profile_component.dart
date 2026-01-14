import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../widgets/button.dart';
import '../widgets/shimmers.dart';
import '../widgets/snackbar.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

class ProfileComponent extends StatelessWidget {
  final CustomerController customerController;

  const ProfileComponent({
    super.key,
    required this.customerController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.rp(20),
            offset: Offset(0, ResponsiveUtils.rp(10)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: AppColors.primary, size: ResponsiveUtils.rp(24)),
              SizedBox(width: ResponsiveUtils.rp(12)),
              Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(20)),
          _buildEditProfileForm(),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm() {
    return Obx(() {
      final customer = customerController.activeCustomer.value;
      if (customer == null) return Skeletons.fullScreen();

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            // Form Fields
            _buildModernTextField(
              controller: customerController.firstNameController,
              hint: 'First Name',
              enabled: customerController.isEditingProfile.value,
              icon: Icons.person_outline,
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
            _buildModernTextField(
              controller: customerController.lastNameController,
              hint: 'Last Name',
              enabled: customerController.isEditingProfile.value,
              icon: Icons.person_outline,
            ),
            SizedBox(height: ResponsiveUtils.rp(24)),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: customerController.isEditingProfile.value
                        ? 'Save Changes'
                        : 'Edit Profile',
                    icon: customerController.isEditingProfile.value
                        ? Icons.save
                        : Icons.edit,
                    onPressed: customerController.isEditingProfile.value
                        ? () async {
                            final success =
                                await customerController.updateCustomer();
                            if (success) {
                              showSuccessSnackbar(
                                  'Profile updated successfully');
                            } else {
                              showErrorSnackbar('Failed to update profile');
                            }
                          }
                        : customerController.toggleEditProfile,
                  ),
                ),
                if (customerController.isEditingProfile.value) ...[
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      icon: Icons.close,
                      onPressed: customerController.toggleEditProfile,
                      backgroundColor: Colors.grey[600]!,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hint,
    required bool enabled,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.grey[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(
          color: enabled ? Colors.black87 : Colors.grey[600],
          fontSize: ResponsiveUtils.sp(16),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: AppColors.primary, size: ResponsiveUtils.rp(20)),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16), vertical: ResponsiveUtils.rp(16)),
        ),
      ),
    );
  }
}
