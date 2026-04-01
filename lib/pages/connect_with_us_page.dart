import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/premium_card.dart';
import '../services/analytics_service.dart';
import 'help_support_page.dart';

class ConnectWithUsPage extends StatelessWidget {
  const ConnectWithUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => AnalyticsService().logScreenView(screenName: 'ConnectWithUs'));
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
          'Connect with Us',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ResponsiveUtils.rp(16)),
            // Social Media Section
            PremiumCard(
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Follow Us',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  _buildSocialTile(
                    icon: FontAwesomeIcons.facebook,
                    title: 'Facebook',
                    subtitle: 'Like and follow us on Facebook',
                    color: Color(0xFF1877F2),
                    onTap: () => _launchSocialMedia('https://www.facebook.com/profile.php?id=61584309481086'),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildSocialTile(
                    icon: FontAwesomeIcons.instagram,
                    title: 'Instagram',
                    subtitle: 'Follow us on Instagram',
                    color: Color(0xFFE4405F),
                    onTap: () => _launchSocialMedia('https://www.instagram.com/swadkerala.official/'),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
            // Help & Support Section
            PremiumCard(
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  _buildSupportTile(
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help Center',
                    subtitle: 'Get answers to common questions',
                    onTap: () => Get.to(() => const HelpSupportPage()),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.rp(48),
              height: ResponsiveUtils.rp(48),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              child: Center(
                child: FaIcon(icon, color: Colors.white, size: ResponsiveUtils.rp(24)),
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(13),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveUtils.rp(16),
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: AppColors.button.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(color: AppColors.button.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.rp(48),
              height: ResponsiveUtils.rp(48),
              decoration: BoxDecoration(
                color: AppColors.button,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              child: Center(
                child: FaIcon(icon, color: Colors.white, size: ResponsiveUtils.rp(24)),
              ),
            ),
            SizedBox(width: ResponsiveUtils.rp(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(13),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveUtils.rp(16),
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchSocialMedia(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        showErrorSnackbar('Could not open $url');
      }
    } catch (e) {
      showErrorSnackbar('Error opening link');
    }
  }
}

void showErrorSnackbar(String message) {
  Get.snackbar(
    'Error',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

