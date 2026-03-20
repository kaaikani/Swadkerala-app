import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../controllers/referral/referral_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import 'account_referral_section.dart';

class AccountOptionsSection extends StatelessWidget {
  final bool isGuest;
  final CustomerController customerController;
  final ReferralController referralController;

  const AccountOptionsSection({
    super.key,
    this.isGuest = false,
    required this.customerController,
    required this.referralController,
  });

  bool _isAccountCreatedWithin24Hours() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return false;
    final createdAt = customer.createdAt;
    return DateTime.now().difference(createdAt).inHours < 24;
  }

  Widget _buildRedeemReferralTile() {
    if (!_isAccountCreatedWithin24Hours()) return const SizedBox.shrink();
    final customer = customerController.activeCustomer.value;
    if (customer?.referredBy != null) return const SizedBox.shrink();
    return Obx(() {
      if (referralController.hasRedeemed.value) return const SizedBox.shrink();
      return Column(
        children: [
          AccountListTile(
            leadingIcon: Icons.card_giftcard_outlined,
            title: 'Redeem Referral',
            trailingIcon: Icons.arrow_forward_ios,
            subtitle: 'Enter referrer ID to earn rewards',
            onTap: () => RedeemReferralDialog.show(
              customerController: customerController,
              referralController: referralController,
            ),
          ),
          const AccountDivider(),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          if (!isGuest) ...[
            _buildRedeemReferralTile(),
          ],
          const AccountDarkModeTile(),
        ],
      ),
    );
  }
}

class AccountSupportSection extends StatelessWidget {
  final bool isGuest;
  final VoidCallback onRateApp;
  final VoidCallback onShareApp;
  final GlobalKey shareAppKey;

  const AccountSupportSection({
    super.key,
    this.isGuest = false,
    required this.onRateApp,
    required this.onShareApp,
    required this.shareAppKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          AccountListTile(
            leadingIcon: Icons.link_outlined,
            title: 'Connect with Us',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/connect-with-us'),
          ),
          const AccountDivider(),
          AccountListTile(
            leadingIcon: Icons.help_outline,
            title: 'Help & Support',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/help-support'),
          ),
          const AccountDivider(),
          AccountListTile(
            leadingIcon: Icons.star_outline,
            title: 'Rate Our App',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: onRateApp,
          ),
          const AccountDivider(),
          KeyedSubtree(
            key: shareAppKey,
            child: AccountListTile(
              leadingIcon: Icons.share_outlined,
              title: 'Share App',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: onShareApp,
            ),
          ),
          const AccountDivider(),
          AccountListTile(
            leadingIcon: Icons.privacy_tip_outlined,
            title: 'Privacy & Policy',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/privacy-policy'),
          ),
          const AccountDivider(),
          AccountListTile(
            leadingIcon: Icons.description_outlined,
            title: 'Terms & Conditions',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/terms-conditions'),
          ),
        ],
      ),
    );
  }
}

class AccountListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData trailingIcon;
  final String? subtitle;
  final VoidCallback? onTap;

  const AccountListTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.trailingIcon,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: ResponsiveUtils.rp(36),
        height: ResponsiveUtils.rp(36),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
        ),
        child: Icon(leadingIcon,
            color: AppColors.button, size: ResponsiveUtils.rp(20)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveUtils.sp(14),
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: Icon(trailingIcon,
          size: ResponsiveUtils.rp(16), color: AppColors.textTertiary),
      contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
      minLeadingWidth: 0,
    );
  }
}

class AccountDarkModeTile extends StatelessWidget {
  const AccountDarkModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => ListTile(
          leading: Container(
            width: ResponsiveUtils.rp(36),
            height: ResponsiveUtils.rp(36),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(18)),
            ),
            child: Icon(
              themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.button,
              size: ResponsiveUtils.rp(20),
            ),
          ),
          title: Text(
            'Dark Mode',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            themeController.isDarkMode ? 'Enabled' : 'Disabled',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Switch(
            value: themeController.isDarkMode,
            onChanged: (value) {
              themeController.setDarkMode(value);
            },
            activeColor: AppColors.button,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          minLeadingWidth: 0,
        ));
  }
}

class AccountDivider extends StatelessWidget {
  const AccountDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: 60, endIndent: 16);
  }
}
