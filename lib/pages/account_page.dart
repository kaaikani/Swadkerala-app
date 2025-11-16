import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../services/in_app_update_service.dart';
import '../widgets/snackbar.dart';
import '../widgets/premium_card.dart';
import '../theme/theme.dart';
import '../utils/responsive.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../theme/colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final CustomerController customerController = Get.put(CustomerController());
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.put(ThemeController());
  final UtilityController utilityController = Get.find();
  final InAppUpdateService _updateService = InAppUpdateService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.getActiveCustomer();
      _updateService.checkAndShowFlexibleUpdateInAccount(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          'My Account',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerAccount();
        }

        final customer = customerController.activeCustomer.value;
        if (customer == null) {
          return Center(
            child: Text(
              'Unable to load account',
              style: AppTextStyles.bodyLarge,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await customerController.getActiveCustomer();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Card
                _buildProfileCard(customer),

                // Orders Section
                _buildOrdersSection(),

                SizedBox(height: 8),

                // Account Options
                _buildAccountOptions(),

                SizedBox(height: 8),

                // Support Section
                _buildSupportSection(),

                SizedBox(height: 16),

                // App Version & Logout
                _buildFooter(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(CustomerModel customer) {
    return PremiumCard(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: ResponsiveUtils.rp(70),
                height: ResponsiveUtils.rp(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.button,
                      AppColors.button.withValues(alpha: 0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getInitials(customer.firstName, customer.lastName),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.sp(24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(16)),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${customer.firstName} ${customer.lastName}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ResponsiveUtils.rp(6)),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: ResponsiveUtils.rp(16),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: ResponsiveUtils.rp(6)),
                        Expanded(
                          child: Text(
                            customer.phoneNumber ?? 'No phone number',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: ResponsiveUtils.sp(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Edit Button
              IconButton(
                onPressed: _showEditProfileDialog,
                icon: Icon(Icons.edit_outlined),
                color: AppColors.button,
                iconSize: ResponsiveUtils.rp(24),
                tooltip: 'Edit Profile',
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          // Loyalty Points & Divider
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(12),
            ),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars_outlined,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(20),
                ),
                SizedBox(width: ResponsiveUtils.rp(10)),
                Text(
                  'Loyalty Points',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.sp(14),
                  ),
                ),
                Spacer(),
                Text(
                  '${customer.customFields?.loyaltyPointsAvailable ?? 0}',
                  style: TextStyle(
                    color: AppColors.button,
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection() {
    final ordersCount = customerController.orders.length;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: AppColors.iconLight, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'My Orders',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => Get.toNamed('/orders'),
                child: Text(
                  'View All ($ordersCount)',
                  style: TextStyle(
                    color: AppColors.button,
                    fontSize: ResponsiveUtils.sp(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStatusItem(
                  Icons.payment_outlined, 'Pending', Colors.orange, () {}),
              _buildOrderStatusItem(
                  Icons.local_shipping_outlined, 'Shipped', Colors.blue, () {}),
              _buildOrderStatusItem(Icons.check_circle_outlined, 'Delivered',
                  Colors.green, () {}),
              _buildOrderStatusItem(Icons.assignment_return_outlined, 'Return',
                  Colors.red, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusItem(
      IconData icon, String status, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: ResponsiveUtils.rp(40),
            height: ResponsiveUtils.rp(40),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
            ),
            child: Icon(icon, color: color, size: ResponsiveUtils.rp(20)),
          ),
          SizedBox(height: ResponsiveUtils.rp(6)),
          Text(
            status,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(11),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOptions() {
    final addressesCount = customerController.addresses.length;

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          _buildListTile(
            Icons.person_outline,
            'Profile Information',
            Icons.arrow_forward_ios,
            onTap: _showEditProfileDialog,
          ),
          _buildDivider(),
          _buildListTile(
            Icons.location_on_outlined,
            'Saved Addresses',
            Icons.arrow_forward_ios,
            subtitle: '$addressesCount addresses',
            onTap: () => Get.toNamed('/addresses'),
          ),
          _buildDivider(),
          _buildListTile(
            Icons.favorite_outline,
            'Wishlist',
            Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/wishlist'),
          ),
          _buildDivider(),
          _buildListTile(
            Icons.notifications_outlined,
            'Notification Settings',
            Icons.arrow_forward_ios,
            onTap: () => Get.toNamed('/notifications'),
          ),
          _buildDivider(),
          _buildDarkModeTile(),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          _buildListTile(
            Icons.help_outline,
            'Help & Support',
            Icons.arrow_forward_ios,
            onTap: _openHelpSupport,
          ),
          _buildDivider(),
          _buildListTile(
            Icons.star_outline,
            'Rate Our App',
            Icons.arrow_forward_ios,
            onTap: _openPlayStore,
          ),
          _buildDivider(),
          _buildListTile(
            Icons.share_outlined,
            'Share App',
            Icons.arrow_forward_ios,
            onTap: _shareApp,
          ),
          _buildDivider(),
          _buildListTile(
            Icons.description_outlined,
            'Terms & Privacy',
            Icons.arrow_forward_ios,
            onTap: _openTermsAndConditions,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      IconData leadingIcon, String title, IconData trailingIcon,
      {String? subtitle, VoidCallback? onTap}) {
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
              subtitle,
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

  // Dark Mode Toggle Tile
  Widget _buildDarkModeTile() {
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
              themeController.toggleTheme();
            },
            activeColor: AppColors.button,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
          minLeadingWidth: 0,
        ));
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 60, endIndent: 16);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            return Text(
              'App Version ${snapshot.data?.version ?? "1.0.0"}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            );
          },
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
            onPressed: _showLogoutDialog,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  String _getInitials(String firstName, String lastName) {
    String firstInitial =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    if (firstInitial.isEmpty && lastInitial.isEmpty) return 'U';
    return '$firstInitial$lastInitial';
  }

  void _showEditProfileDialog() {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;

    final firstNameController = TextEditingController(text: customer.firstName);
    final lastNameController = TextEditingController(text: customer.lastName);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Phone number is read-only, cannot be changed
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              customerController.firstNameController.text =
                  firstNameController.text;
              customerController.lastNameController.text =
                  lastNameController.text;
              // You might need to add phone controller to your customer controller

              final success = await customerController.updateCustomer();
              if (success) {
                Get.back();
                showSuccessSnackbar('Profile updated successfully');
              } else {
                showErrorSnackbar('Failed to update profile');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Logout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareApp() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      final shareText =
          'Check out this amazing app! Download it from: https://play.google.com/store/apps/details?id=$packageName';

      // For now, show a dialog with share text
      // You can integrate with share_plus package for actual sharing
      Get.dialog(
        AlertDialog(
          title: Text('Share App'),
          content: SelectableText(shareText),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      showErrorSnackbar('Could not share app');
    }
  }

  Future<void> _openPlayStore() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;

      final playStoreUrl = Uri.parse('market://details?id=$packageName');
      final webStoreUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName');

      debugPrint('[AccountPage] Opening Play Store for package: $packageName');

      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
        debugPrint('[AccountPage] Opened Play Store app');
      } else {
        await launchUrl(webStoreUrl, mode: LaunchMode.externalApplication);
        debugPrint('[AccountPage] Opened Play Store in browser');
      }
    } catch (e) {
      debugPrint('[AccountPage] Error opening Play Store: $e');
      showErrorSnackbar('Could not open Play Store: $e');
    }
  }

  Future<void> _openTermsAndConditions() async {
    try {
      final url = Uri.parse('https://yourwebsite.com/terms');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.inAppWebView);
      } else {
        _showTermsDialog();
      }
    } catch (e) {
      _showTermsDialog();
    }
  }

  void _showTermsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Please add your terms and conditions URL in the code.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _openHelpSupport() async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone_outlined, color: AppColors.primary),
              title: Text('Phone Support'),
              subtitle: Text('+91 1234567890'),
              onTap: () => _launchPhone(),
            ),
            ListTile(
              leading: Icon(Icons.chat_outlined, color: AppColors.primary),
              title: Text('WhatsApp'),
              subtitle: Text('Chat with us'),
              onTap: () => _launchWhatsApp(),
            ),
            ListTile(
              leading: Icon(Icons.email_outlined, color: AppColors.primary),
              title: Text('Email Support'),
              subtitle: Text('support@yourcompany.com'),
              onTap: () => _launchEmail(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone() async {
    final url = Uri.parse('tel:+911234567890');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showErrorSnackbar('Could not make phone call');
    }
  }

  Future<void> _launchWhatsApp() async {
    final url = Uri.parse('https://wa.me/911234567890');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackbar('Could not open WhatsApp');
    }
  }

  Future<void> _launchEmail() async {
    final url = Uri.parse('mailto:support@yourcompany.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showErrorSnackbar('Could not open email app');
    }
  }

  Widget _buildShimmerAccount() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile card shimmer
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
              child: Row(
                children: [
                  Container(
                    width: ResponsiveUtils.rp(80),
                    height: ResponsiveUtils.rp(80),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: ResponsiveUtils.rp(20),
                          width: ResponsiveUtils.rp(150),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(8)),
                        Container(
                          height: ResponsiveUtils.rp(16),
                          width: ResponsiveUtils.rp(200),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            // Quick actions shimmer
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                children: List.generate(
                    3,
                    (index) => Container(
                          height: ResponsiveUtils.rp(56),
                          margin:
                              EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            // Orders section shimmer
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                children: [
                  Container(
                    height: ResponsiveUtils.rp(20),
                    width: ResponsiveUtils.rp(100),
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  ...List.generate(
                      2,
                      (index) => Container(
                            height: ResponsiveUtils.rp(80),
                            margin:
                                EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
