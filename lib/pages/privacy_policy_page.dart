import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/premium_card.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/snackbar.dart';
import '../services/analytics_service.dart';
import '../services/graphql_client.dart';
import '../graphql/Customer.graphql.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../routes.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => AnalyticsService().logScreenView(screenName: 'PrivacyPolicy'));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction
            _buildSection(
              title: 'Privacy Policy',
              content: 'At SwadKerala, your privacy is our priority. This policy explains how we collect, use, and protect your personal information when you shop for authentic Kerala spices on our platform.\n\nLast Updated: November 2024',
              icon: Icons.privacy_tip_outlined,
              iconColor: AppColors.button,
            ),

            ResponsiveSpacing.vertical(16),

            // 1. Information We Collect
            _buildNumberedSection(
              number: '1',
              title: 'Information We Collect',
              subsections: [
                _SubSection(
                  title: 'Personal Information',
                  content: 'When you create an account or place an order, we collect:\n\n• Name and contact information (email, phone number)\n• Delivery address and billing information\n• Payment details (processed securely through third-party providers)\n• Account preferences and order history',
                ),
                _SubSection(
                  title: 'Usage Information',
                  content: 'We automatically collect information about how you use our platform:\n\n• Device information and browser type\n• IP address and location data\n• Pages visited and time spent on our site\n• Search queries and product preferences',
                ),
              ],
              icon: Icons.info_outline,
              iconColor: AppColors.info,
            ),

            ResponsiveSpacing.vertical(16),

            // 2. How We Use Your Information
            _buildNumberedSection(
              number: '2',
              title: 'How We Use Your Information',
              subsections: [
                _SubSection(
                  title: 'Order Processing & Delivery',
                  content: 'We use your information to process your authentic Kerala spice orders, arrange delivery to your doorstep, provide order tracking, and offer exceptional customer support for all your spice needs.',
                ),
                _SubSection(
                  title: 'Communication',
                  content: 'We may send you order confirmations, delivery updates for your spice orders, exclusive offers on Kerala spices, seasonal promotions, and important service announcements. You can opt-out of promotional emails anytime.',
                ),
                _SubSection(
                  title: 'Service Improvement',
                  content: 'We analyze usage patterns to improve our platform, personalize your shopping experience with relevant spice recommendations, optimize our product offerings, and develop new features to better serve your culinary needs.',
                ),
              ],
              icon: Icons.settings_outlined,
              iconColor: AppColors.button,
            ),

            ResponsiveSpacing.vertical(16),

            // 3. Information Sharing
            _buildSection(
              title: '3. Information Sharing',
              content: 'We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:\n\n• Service Providers: With trusted partners who help us operate our platform (payment processors, delivery services, email providers)\n• Legal Requirements: When required by law or to protect our rights and safety\n• Business Transfers: In case of merger, acquisition, or sale of business assets\n• Consent: When you explicitly give us permission to share your information',
              icon: Icons.share_outlined,
              iconColor: AppColors.warning,
            ),

            ResponsiveSpacing.vertical(16),

            // 4. Data Security
            _buildSection(
              title: '4. Data Security',
              content: 'We implement industry-standard security measures to protect your personal information:\n\n• SSL encryption for all data transmission\n• Secure servers with regular security updates\n• Limited access to personal information\n• Regular security audits and monitoring\n\nAt SwadKerala, we take your data security seriously and implement industry-leading practices. While we strive to protect your information with the highest standards, no method of transmission over the internet is 100% secure. We continuously update our security measures to ensure your information remains protected.',
              icon: Icons.security_outlined,
              iconColor: AppColors.success,
            ),

            ResponsiveSpacing.vertical(16),

            // 5. Cookies & Tracking
            _buildSection(
              title: '5. Cookies & Tracking',
              content: 'We use cookies and similar technologies to enhance your experience:\n\n• Essential Cookies: Required for basic platform functionality\n• Analytics Cookies: Help us understand how you use our platform\n• Preference Cookies: Remember your settings and preferences\n• Marketing Cookies: Used to show relevant advertisements\n\nYou can control cookie settings through your browser preferences. However, disabling certain cookies may affect platform functionality.',
              icon: Icons.cookie_outlined,
              iconColor: AppColors.warning,
            ),

            ResponsiveSpacing.vertical(16),

            // 6. Your Rights
            _buildSection(
              title: '6. Your Rights',
              content: 'You have the following rights regarding your personal information:\n\n• Access: Request a copy of your personal information\n• Correction: Update or correct inaccurate information\n• Deletion: Request deletion of your personal information\n• Portability: Receive your data in a structured format\n• Objection: Opt-out of certain data processing activities\n• Restriction: Limit how we process your information\n\nTo exercise these rights, please contact us using the information provided below.',
              icon: Icons.gavel_outlined,
              iconColor: AppColors.button,
            ),

            ResponsiveSpacing.vertical(16),

            // 7. Data Retention
            _buildSection(
              title: '7. Data Retention',
              content: 'We retain your personal information for as long as necessary to provide our Kerala spice delivery services and fulfill the purposes outlined in this policy. Account information is typically retained for the duration of your active account plus a reasonable period for legal, tax, and business purposes (typically 3-5 years). You may request deletion of your account and associated data at any time by contacting our support team.',
              icon: Icons.storage_outlined,
              iconColor: AppColors.info,
            ),

            ResponsiveSpacing.vertical(16),

            // 8. Children's Privacy
            _buildSection(
              title: '8. Children\'s Privacy',
              content: 'Our platform is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information promptly.',
              icon: Icons.child_care_outlined,
              iconColor: AppColors.warning,
            ),

            ResponsiveSpacing.vertical(16),

            // 9. Policy Updates
            _buildSection(
              title: '9. Policy Updates',
              content: 'We may update this privacy policy from time to time to reflect changes in our practices or legal requirements. We will notify you of any material changes by posting the updated policy on this page and updating the "Last updated" date. We encourage you to review this policy periodically.',
              icon: Icons.update_outlined,
              iconColor: AppColors.success,
            ),

            ResponsiveSpacing.vertical(16),

            // 10. Cancellation Policy
            _buildNumberedSection(
              number: '10',
              title: 'Cancellation Policy',
              subsections: [
                _SubSection(
                  title: 'Cancellation Before Shipping',
                  content: 'You have the right to cancel your order at any time before it has been shipped.\n\n• Time Window: Orders can be cancelled anytime before the shipping confirmation email is sent to you\n• Processing Time: Cancellation requests are typically processed within 24 hours of receipt\n• Automatic Cancellation: If your order has not yet entered the processing stage, you may be able to cancel it directly from your account dashboard\n• Manual Cancellation: For orders that have entered processing, please contact our customer service team immediately',
                ),
                _SubSection(
                  title: 'Refund Process',
                  content: 'When you cancel an order before shipping, you are entitled to a refund of the amount paid:\n\n• Refund Method: Refunds will be processed to the original payment method used for the order\n• Processing Time: Refunds typically appear in your account within 5-10 business days, depending on your bank or payment provider\n• Shipping Charges: If applicable, shipping charges will also be refunded in full when cancelling before shipment\n• Confirmation: You will receive an email confirmation once your cancellation has been processed and refund initiated',
                ),
              ],
              icon: Icons.cancel_outlined,
              iconColor: AppColors.error,
            ),

            ResponsiveSpacing.vertical(16),

            // 11. Account Deletion
            _buildNumberedSection(
              number: '11',
              title: 'Account Deletion',
              subsections: [
                _SubSection(
                  title: 'Deletion Process',
                  content: 'You may request the deletion of your SwadKerala account at any time. Once a deletion request is submitted, your account will be scheduled for permanent removal.\n\n• Grace Period: You have a 3-day window after submitting your request to cancel the deletion by logging back into your account\n• Login Cancellation: If you log in during the 3-day grace period, your deletion request will be automatically cancelled\n• Permanent Deletion: After the 3-day grace period, your account and all associated personal data will be permanently deleted\n• Data Removed: Personal information, order history, saved addresses, and account preferences will be erased\n\nImportant: Account deletion is irreversible after the 3-day grace period. Please ensure you have saved any important order information before requesting deletion. Some data may be retained for legal and tax compliance purposes as outlined in our Data Retention policy.',
                ),
              ],
              icon: Icons.delete_outline,
              iconColor: AppColors.error,
            ),

            ResponsiveSpacing.vertical(16),

            // Request account deletion button (only when logged in, not for guest)
            if (Get.find<AuthController>().isLoggedIn) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showRequestAccountDeletionDialog(context),
                  icon: Icon(Icons.delete_outline, size: ResponsiveUtils.rp(20), color: AppColors.error),
                  label: Text(
                    'Request account deletion',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error),
                    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    ),
                  ),
                ),
              ),
              ResponsiveSpacing.vertical(16),
            ],

            ResponsiveSpacing.vertical(24),
          ],
        ),
      ),
    );
  }

  void _showRequestAccountDeletionDialog(BuildContext context) {
    final reasonController = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: AppColors.error, size: ResponsiveUtils.rp(24)),
            SizedBox(width: ResponsiveUtils.rp(8)),
            Expanded(
              child: Text(
                'Request account deletion',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(18),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your account will be deleted within 3 days. Please provide a reason (required).',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(16)),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: 'Reason (required)',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.rp(12),
                    vertical: ResponsiveUtils.rp(12),
                  ),
                ),
                maxLines: 3,
                style: TextStyle(fontSize: ResponsiveUtils.sp(14), color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                reasonController.dispose();
              });
            },
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final reasonText = reasonController.text.trim();
              if (reasonText.isEmpty) {
                showErrorSnackbar('Please enter a reason for account deletion');
                return;
              }
              Get.back();
              // Dispose after dialog is fully closed to avoid "used after dispose" error
              WidgetsBinding.instance.addPostFrameCallback((_) {
                reasonController.dispose();
              });
              try {
                final response = await GraphqlService.client.value.mutate$RequestAccountDeletion(
                  Options$Mutation$RequestAccountDeletion(
                    variables: Variables$Mutation$RequestAccountDeletion(reason: reasonText),
                  ),
                );
                if (response.hasException) {
                  final msg = response.exception?.graphqlErrors.firstOrNull?.message ??
                      response.exception?.linkException?.toString() ??
                      'Failed to request account deletion';
                  showErrorSnackbar(msg.toString().replaceAll('Exception:', '').trim());
                  return;
                }
                final data = response.parsedData?.requestAccountDeletion;
                if (data == null) {
                  showErrorSnackbar('Failed to request account deletion');
                  return;
                }
                if (data.success) {
                  SnackBarWidget.showSuccess(data.message);
                  final authController = Get.find<AuthController>();
                  final ctx = Get.context;
                  if (ctx != null) {
                    await authController.logout(ctx);
                  } else {
                    await GraphqlService.clearToken('auth');
                    await GraphqlService.clearToken('channel');
                    await GraphqlService.clearGuestSession();
                    Get.offAllNamed(AppRoutes.home);
                  }
                } else {
                  showErrorSnackbar(data.message);
                }
              } catch (e) {
                showErrorSnackbar('Failed to request account deletion. Please try again.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedSection({
    required String number,
    required String title,
    required List<_SubSection> subsections,
    IconData? icon,
    Color? iconColor,
  }) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 20),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.button).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.button,
                    size: ResponsiveUtils.rp(24),
                  ),
                ),
                ResponsiveSpacing.horizontal(12),
              ],
              Expanded(
                child: ResponsiveText(
                  '$number. $title',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          ...subsections.map((sub) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveSpacing.vertical(16),
              ResponsiveText(
                sub.title,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              ResponsiveSpacing.vertical(8),
              ResponsiveText(
                sub.content,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    IconData? icon,
    Color? iconColor,
  }) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 20),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with Icon
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.button).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.button,
                    size: ResponsiveUtils.rp(24),
                  ),
                ),
                ResponsiveSpacing.horizontal(12),
              ],
              Expanded(
                child: ResponsiveText(
                  title,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          ResponsiveSpacing.vertical(16),
          
          // Content
          ResponsiveText(
            content,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ],
      ),
    );
  }
}

class _SubSection {
  final String title;
  final String content;
  const _SubSection({required this.title, required this.content});
}
