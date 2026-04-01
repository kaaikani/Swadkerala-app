import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/premium_card.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_spacing.dart';
import '../services/analytics_service.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => AnalyticsService().logScreenView(screenName: 'AboutUs'));
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
          'About Us',
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
            // Hero Section
            PremiumCard(
              padding: ResponsiveSpacing.padding(all: 24),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              child: Column(
                children: [
                  Icon(
                    Icons.spa_outlined,
                    size: ResponsiveUtils.rp(48),
                    color: AppColors.button,
                  ),
                  ResponsiveSpacing.vertical(12),
                  ResponsiveText(
                    'Our Spice Journey',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                  ResponsiveSpacing.vertical(8),
                  ResponsiveText(
                    'Bringing Pure Spices and True Flavours from God\'s Own Country',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    textAlign: TextAlign.center,
                    height: 1.5,
                  ),
                ],
              ),
            ),

            ResponsiveSpacing.vertical(16),

            // Mission
            _buildSection(
              title: 'Our Mission',
              content: 'To bring authentic, pure spices from Kerala to kitchens worldwide. We\'re committed to preserving the rich flavors and aromas of traditional Kerala spices, ensuring every dish is enhanced with the finest quality ingredients sourced directly from God\'s Own Country.',
              icon: Icons.flag_outlined,
              iconColor: AppColors.button,
            ),

            ResponsiveSpacing.vertical(16),

            // Vision
            _buildSection(
              title: 'Our Vision',
              content: 'To be recognized as the premier destination for authentic Kerala spices, known for our commitment to purity, traditional sourcing methods, and bringing the true flavors of Kerala to every kitchen around the world.',
              icon: Icons.visibility_outlined,
              iconColor: AppColors.success,
            ),

            ResponsiveSpacing.vertical(16),

            // Our Story
            _buildSection(
              title: 'Our Spice Story',
              content: 'SwadKerala was born from a passion to share the authentic flavors of Kerala\'s rich spice heritage with the world. As part of the Kaaikani family, we leverage our expertise in quality sourcing to bring you pure, handpicked spices directly from Kerala\'s finest farms. With our commitment to traditional methods and uncompromising quality, we ensure every spice preserves its natural aroma and flavor, bringing true Kerala taste to your kitchen.',
              icon: Icons.auto_stories_outlined,
              iconColor: AppColors.info,
            ),

            ResponsiveSpacing.vertical(16),

            // Stats
            _buildStatsSection(),

            ResponsiveSpacing.vertical(16),

            // Features
            _buildFeatureCard(
              icon: Icons.workspace_premium_outlined,
              title: 'Premium Quality',
              description: 'We source only the finest, pure spices from Kerala\'s best farms, ensuring every spice maintains its authentic aroma and flavor.',
              color: AppColors.button,
            ),

            ResponsiveSpacing.vertical(12),

            _buildFeatureCard(
              icon: Icons.local_shipping_outlined,
              title: 'Fast Delivery',
              description: 'Get your premium spices delivered fresh to your doorstep with our reliable shipping and careful packaging.',
              color: AppColors.success,
            ),

            ResponsiveSpacing.vertical(12),

            _buildFeatureCard(
              icon: Icons.favorite_outline,
              title: 'Made with Love',
              description: 'Every spice is handpicked and packed with care and attention to detail, preserving the authentic taste of Kerala.',
              color: AppColors.error,
            ),

            ResponsiveSpacing.vertical(16),

            // Values
            PremiumCard(
              padding: ResponsiveSpacing.padding(all: 20),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText(
                    'What We Stand For',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  ResponsiveSpacing.vertical(16),
                  _buildValueItem(
                    icon: Icons.eco_outlined,
                    title: 'Sustainability',
                    description: 'We\'re committed to eco-friendly practices and sustainable sourcing from Kerala\'s organic farms.',
                    color: AppColors.success,
                  ),
                  ResponsiveSpacing.vertical(12),
                  _buildValueItem(
                    icon: Icons.local_fire_department_outlined,
                    title: 'Passion',
                    description: 'We pour our hearts into bringing authentic Kerala spices that unite families and cultures through food.',
                    color: AppColors.error,
                  ),
                  ResponsiveSpacing.vertical(12),
                  _buildValueItem(
                    icon: Icons.verified_outlined,
                    title: 'Integrity',
                    description: 'We believe in transparency, purity, and doing what\'s right, ensuring you get 100% authentic Kerala spices.',
                    color: AppColors.info,
                  ),
                ],
              ),
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

  Widget _buildStatsSection() {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 20),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
      child: Row(
        children: [
          _buildStatItem('2023', 'Founded'),
          _buildStatDivider(),
          _buildStatItem('200+', 'Products'),
          _buildStatDivider(),
          _buildStatItem('20K+', 'Happy\nCustomers'),
          _buildStatDivider(),
          _buildStatItem('24/7', 'Support'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          ResponsiveText(
            value,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.button,
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.vertical(4),
          ResponsiveText(
            label,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: ResponsiveUtils.rp(40),
      width: 1,
      color: AppColors.divider,
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return PremiumCard(
      padding: ResponsiveSpacing.padding(all: 16),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
            ),
            child: Icon(icon, color: color, size: ResponsiveUtils.rp(24)),
          ),
          ResponsiveSpacing.horizontal(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                ResponsiveSpacing.vertical(4),
                ResponsiveText(
                  description,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: ResponsiveUtils.rp(20)),
        ),
        ResponsiveSpacing.horizontal(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                title,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              ResponsiveSpacing.vertical(4),
              ResponsiveText(
                description,
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
