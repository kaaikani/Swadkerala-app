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
            // Introduction Section
            _buildSection(
              title: 'About Kaaikani',
              content: 'Kaaikani application is an online sales platform for fresh fruits and vegetables. Customers can place orders through the app a day in advance, with delivery made to their doorstep the next day. We prioritize privacy and security of your personal information.',
              icon: Icons.info_outline,
              iconColor: AppColors.button,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Personnel Data Collection and Usage Section
            _buildSection(
              title: 'Personal Data Collection and Usage',
              content: 'Kaaikani Application collects and uses personal data to provide you with the best service experience.',
              icon: Icons.security_outlined,
              iconColor: AppColors.success,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Login and Password Section
            _buildSection(
              title: 'Login and Password',
              content: 'Each customer creates an account with unique login credentials for security purposes.',
              icon: Icons.lock_outline,
              iconColor: AppColors.button,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Address Section
            _buildSection(
              title: 'Address',
              content: 'Kaaikani Application collects addresses to deliver products directly to customers.',
              icon: Icons.location_on_outlined,
              iconColor: AppColors.success,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Bank Details Section
            _buildSection(
              title: 'Bank Details',
              content: 'Bank details are collected for online payment through credit/debit cards, Gpay, Phonepe, and internet banking. We do not share personal data with any third party without permission.',
              icon: Icons.account_balance_outlined,
              iconColor: AppColors.warning,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Children's Privacy Section
            _buildSection(
              title: 'Children\'s Privacy',
              content: 'The application does not target individuals under 13 years of age, and we do not collect personal information from children.',
              icon: Icons.child_care_outlined,
              iconColor: AppColors.error,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Complaint Policy Section
            _buildSection(
              title: 'Complaint Policy',
              content: 'For cut vegetables and cut fruits, complaints will be taken within 24 hours. For normal vegetables and fruits, complaints will be taken within 48 hours.',
              icon: Icons.report_problem_outlined,
              iconColor: AppColors.warning,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Policy Updates Section
            _buildSection(
              title: 'Policy Updates',
              content: 'We may update our policies periodically. Changes will be communicated by posting the updated policy on this page.',
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

  @override
  Widget build(BuildContext context) {
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
            // Introduction Section
            _buildSection(
              title: 'About Kaaikani',
              content: 'Kaaikani application is an online sales platform for fresh fruits and vegetables. Customers can place orders through the app a day in advance, with delivery made to their doorstep the next day. We prioritize privacy and security of your personal information.',
              icon: Icons.info_outline,
              iconColor: AppColors.button,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Personnel Data Collection and Usage Section
            _buildSection(
              title: 'Personal Data Collection and Usage',
              content: 'Kaaikani Application collects and uses personal data to provide you with the best service experience.',
              icon: Icons.security_outlined,
              iconColor: AppColors.success,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Login and Password Section
            _buildSection(
              title: 'Login and Password',
              content: 'Each customer creates an account with unique login credentials for security purposes.',
              icon: Icons.lock_outline,
              iconColor: AppColors.button,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Address Section
            _buildSection(
              title: 'Address',
              content: 'Kaaikani Application collects addresses to deliver products directly to customers.',
              icon: Icons.location_on_outlined,
              iconColor: AppColors.success,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Bank Details Section
            _buildSection(
              title: 'Bank Details',
              content: 'Bank details are collected for online payment through credit/debit cards, Gpay, Phonepe, and internet banking. We do not share personal data with any third party without permission.',
              icon: Icons.account_balance_outlined,
              iconColor: AppColors.warning,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Children's Privacy Section
            _buildSection(
              title: 'Children\'s Privacy',
              content: 'The application does not target individuals under 13 years of age, and we do not collect personal information from children.',
              icon: Icons.child_care_outlined,
              iconColor: AppColors.error,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Complaint Policy Section
            _buildSection(
              title: 'Complaint Policy',
              content: 'For cut vegetables and cut fruits, complaints will be taken within 24 hours. For normal vegetables and fruits, complaints will be taken within 48 hours.',
              icon: Icons.report_problem_outlined,
              iconColor: AppColors.warning,
            ),
            
            ResponsiveSpacing.vertical(16),
            
            // Policy Updates Section
            _buildSection(
              title: 'Policy Updates',
              content: 'We may update our policies periodically. Changes will be communicated by posting the updated policy on this page.',
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
