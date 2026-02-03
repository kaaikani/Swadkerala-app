import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/premium_card.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_spacing.dart';
import '../services/analytics_service.dart';

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
          'Privacy & Policy',
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
            // Introduction Section
            _buildSection(
              title: 'About Kaaikani',
              content: 'Kaaikani is a reliable doorstep delivery service offering fresh, handpicked vegetables and fruits. Founded by Soma Sundaram Arumugam, we proudly serve customers across Madurai, Coimbatore, Salem, and Trichy. Customers can place orders through our app a day in advance and receive fresh produce at their doorstep the next day. We are committed to delivering quality, convenience, and trusted service—while prioritizing the privacy and security of your personal information.',
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Return Policy Section
            _buildSection(
              title: 'Return Policy',
              content: 'We will not accept return without order cancellation.',
              icon: Icons.assignment_return_outlined,
              iconColor: AppColors.error,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Replacement Policy Section
            _buildSection(
              title: 'Replacement Policy',
              content: 'Need to report to our customer care within 2 hours of delivery time if any product quality is not good.',
              icon: Icons.swap_horiz_outlined,
              iconColor: AppColors.warning,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Cancellation Policy Section
            _buildSection(
              title: 'Cancellation Policy',
              content: 'We accept order cancellations up to 6 hours before the scheduled delivery time. Please note that cancellations are approved only when a valid and genuine reason is provided. After this 6-hour window, cancellations cannot be processed as the order will already be under preparation or dispatch.',
              icon: Icons.cancel_outlined,
              iconColor: AppColors.error,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Shipping Policy Section
            _buildSection(
              title: 'Shipping Policy',
              content: 'We strive to deliver your orders quickly and efficiently. All orders placed will be delivered on the next day.\n\nDelivery timing will depend on the slot you choose at checkout:\n\n• Morning Delivery: Your order will be delivered the next day in the morning time slot.\n\n• Evening Delivery: Your order will be delivered the next day in the evening time slot.\n\nWe ensure timely delivery based on the slot selected to provide you with a smooth and convenient shopping experience.',
              icon: Icons.local_shipping_outlined,
              iconColor: AppColors.success,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Privacy & Refund Policy Section
            _buildSection(
              title: 'Privacy & Refund Policy',
              content: 'A privacy policy is implemented because of how businesses handle digital data. It\'s used to communicate how companies take that information in all cases. Therefore, a privacy policy is a statement describing how a website collects, uses, and manages personal information. A privacy policy can appear in just about any medium as long as it\'s formally presented to the person or entity owning the personal or applicable information. Users can often request and receive a printed version of a privacy policy.',
              icon: Icons.privacy_tip_outlined,
              iconColor: AppColors.button,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Additional Refund Policy Section
            _buildSection(
              title: 'Additional Refund Policy',
              content: 'For prepaid orders, refunds will be processed within 2 to 4 working days. If the ordered product was unavailable, the equivalent amount will be refunded the next day.',
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.success,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Offers Terms Section
            _buildSection(
              title: 'Offers',
              content: '• Offers are valid for one user per offer only.\n\n• Multiple accounts, phone numbers, or logins used by the same person or same address will be treated as one user.\n\n• Misuse of offers may result in withdrawal of benefits or account suspension.\n\n• Offers may be modified or withdrawn at any time.',
              icon: Icons.local_offer_outlined,
              iconColor: AppColors.warning,
            ),
            
            ResponsiveSpacing.vertical(24),
          ],
        ),
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
