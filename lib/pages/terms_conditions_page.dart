import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/premium_card.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_spacing.dart';
import '../services/analytics_service.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => AnalyticsService().logScreenView(screenName: 'TermsConditions'));
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
          'Terms & Conditions',
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
              title: 'Terms & Conditions',
              content: 'Welcome to SwadKerala, your trusted source for authentic Kerala spices sourced directly from God\'s Own Country. Please read these terms carefully before using our services.\n\nLast Updated: November 2024',
              icon: Icons.description_outlined,
              iconColor: AppColors.button,
            ),

            ResponsiveSpacing.vertical(16),

            // 1. Acceptance of Terms
            _buildSection(
              title: '1. Acceptance of Terms',
              content: 'By accessing and using SwadKerala\'s razorpay-payment platform for authentic Kerala spices, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
              icon: Icons.check_circle_outline,
              iconColor: AppColors.success,
            ),

            ResponsiveSpacing.vertical(16),

            // 2. Product Information
            _buildSection(
              title: '2. Product Information',
              content: 'We specialize in authentic Kerala spices sourced directly from God\'s Own Country, including:\n\n• Premium whole spices (cardamom, pepper, cinnamon, cloves, nutmeg)\n• Ground spices and spice blends\n• Traditional Kerala spice mixes and masalas\n• Organic and premium quality variants\n\nAll spices are handpicked from Kerala\'s finest farms, ensuring purity and authentic flavor. Product images are for reference only and actual products may vary slightly in appearance while maintaining the same premium quality.',
              icon: Icons.spa_outlined,
              iconColor: AppColors.button,
            ),

            ResponsiveSpacing.vertical(16),

            // 3. Orders & Payment
            _buildSection(
              title: '3. Orders & Payment',
              content: 'Payment Methods\nWe accept all major credit/debit cards, UPI payments, net banking, and digital wallets. All transactions are secured with SSL encryption.\n\nOrder Processing\nYour Kerala spice orders are processed within 24-48 hours during business days. Custom spice blends or bulk orders may require additional processing time. You will receive order confirmation via email/SMS along with tracking details once your order is dispatched.',
              icon: Icons.payment_outlined,
              iconColor: AppColors.warning,
            ),

            ResponsiveSpacing.vertical(16),

            // 4. Delivery & Shipping
            _buildSection(
              title: '4. Delivery & Shipping',
              content: 'We deliver authentic Kerala spices across major cities and towns in India. Delivery charges vary by location and order value. Enjoy free delivery on orders above Rs.500. Typical delivery time is 3-7 business days depending on your location.\n\nNote: All spices are packed in airtight, food-grade containers to maintain freshness and aroma during transit. We recommend storing in a cool, dry place to preserve quality and flavor.',
              icon: Icons.local_shipping_outlined,
              iconColor: AppColors.success,
            ),

            ResponsiveSpacing.vertical(16),

            // 5. Returns & Refunds
            _buildSection(
              title: '5. Returns & Refunds',
              content: 'We stand behind the quality of our spices. Our return policy ensures your satisfaction:\n\n• Returns accepted within 7 days of delivery\n• Products must be in original packaging and unopened\n• Quality issues will be addressed immediately with full refund or replacement\n• Refunds processed within 5-7 business days to the original payment method',
              icon: Icons.assignment_return_outlined,
              iconColor: AppColors.error,
            ),

            ResponsiveSpacing.vertical(16),

            // 6. Customer Responsibilities
            _buildSection(
              title: '6. Customer Responsibilities',
              content: 'Customers are responsible for providing accurate delivery information, being available for delivery, and ensuring proper storage of products upon receipt.',
              icon: Icons.person_outline,
              iconColor: AppColors.info,
            ),

            ResponsiveSpacing.vertical(16),

            // 7. Limitation of Liability
            _buildSection(
              title: '7. Limitation of Liability',
              content: 'Our liability is limited to the value of the products purchased. We are not responsible for any indirect, incidental, or consequential damages arising from the use of our products or services.',
              icon: Icons.gavel_outlined,
              iconColor: AppColors.warning,
            ),

            ResponsiveSpacing.vertical(16),

            // 8. Modifications
            _buildSection(
              title: '8. Modifications',
              content: 'We reserve the right to modify these terms at any time. Changes will be posted on this page with an updated revision date. Continued use of our services constitutes acceptance of the modified terms.',
              icon: Icons.update_outlined,
              iconColor: AppColors.button,
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
