import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/referral/referral_controller.dart';
import '../services/graphql_client.dart';
import '../controllers/theme_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../services/in_app_update_service.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../services/analytics_service.dart';
import '../widgets/account/account_guest_profile_card.dart';
import '../widgets/account/account_profile_card.dart';
import '../widgets/account/account_orders_section.dart';
import '../widgets/account/account_referral_section.dart';
import '../widgets/account/account_options_section.dart';
import '../widgets/account/account_footer.dart';
import '../widgets/account/account_shimmer.dart';
import '../widgets/account/account_edit_profile_dialog.dart';
import '../widgets/account/account_update_dialogs.dart';

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
  final ReferralController referralController = Get.put(ReferralController());
  final GlobalKey _shareReferralKey = GlobalKey();
  final GlobalKey _shareAppKey = GlobalKey();

  late final AccountUpdateDialogs _updateDialogs;
  Worker? _loginWorker;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'Account');

    _updateDialogs = AccountUpdateDialogs(
      customerController: customerController,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadAuthenticatedData();
      _updateService.checkAndShowFlexibleUpdateInAccount(context);
    });

    // Listen for login state changes so data loads when user registers/logs in
    // while this page is already mounted (e.g. bottom nav bar keeps it alive).
    _loginWorker = ever<bool>(authController.isLoggedInRx, (bool isLoggedIn) {
      if (isLoggedIn) {
        _loadAuthenticatedData();
      }
    });
  }

  @override
  void dispose() {
    _loginWorker?.dispose();
    super.dispose();
  }

  /// Load customer, referral, and order data for authenticated users
  Future<void> _loadAuthenticatedData() async {
    if (!_isUserAuthenticated()) return;
    await customerController.getActiveCustomer();
    final cid = customerController.activeCustomer.value?.id;
    if (cid != null) referralController.loadRedeemedStatus(cid);
    referralController.fetchMyReferrals();
    referralController.fetchEarnedScratchCards();
    referralController.fetchChannelPoints();
    if (mounted) _updateDialogs.checkAndShowUpdateDialogs();
  }

  /// Check if user is authenticated
  bool _isUserAuthenticated() {
    final authToken = GraphqlService.authToken;
    final channelToken = GraphqlService.channelToken;
    return authController.isLoggedIn &&
        authToken.isNotEmpty &&
        channelToken.isNotEmpty;
  }

  void _showEditProfileDialog() {
    AccountEditProfileDialog(
      customerController: customerController,
      onEmailUpdateRequested: () => _updateDialogs.showUpdateEmailDialog(),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Force rebuild when theme changes
      final _ = themeController.isDarkMode;

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
            return const AccountShimmer();
          }

          final customer = customerController.activeCustomer.value;
          // Read isLoggedIn directly inside Obx so GetX tracks it for reactivity.
          final isAuthenticated = authController.isLoggedIn &&
              GraphqlService.authToken.isNotEmpty &&
              GraphqlService.channelToken.isNotEmpty;

          return RefreshIndicator(
            onRefresh: () async {
              if (isAuthenticated) {
                await customerController.getActiveCustomer();
              }
            },
            color: AppColors.refreshIndicator,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Card
                  if (customer != null)
                    AccountProfileCard(
                      customer: customer,
                      onEditProfile: _showEditProfileDialog,
                      customerController: customerController,
                    )
                  else if (isAuthenticated)
                    AccountProfileErrorCard(
                      onRetry: () async {
                        if (_isUserAuthenticated()) {
                          await customerController.getActiveCustomer();
                        }
                      },
                    )
                  else
                    const AccountGuestProfileCard(),

                  // Referral Section (hide for guest)
                  if (isAuthenticated) ...[
                    AccountReferralSection(
                      customerController: customerController,
                      referralController: referralController,
                      shareReferralKey: _shareReferralKey,
                    ),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                  ],

                  // Orders Section (hide for guest)
                  if (isAuthenticated) ...[
                    AccountOrdersSection(customerController: customerController),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                  ],

                  // Account Options
                  AccountOptionsSection(
                    isGuest: !isAuthenticated,
                    customerController: customerController,
                    referralController: referralController,
                  ),

                  SizedBox(height: ResponsiveUtils.rp(8)),

                  // Support Section
                  AccountSupportSection(
                    isGuest: !isAuthenticated,
                    onRateApp: AccountActions.openStoreForRating,
                    onShareApp: () => AccountActions.shareApp(_shareAppKey),
                    shareAppKey: _shareAppKey,
                  ),

                  SizedBox(height: ResponsiveUtils.rp(16)),

                  // Footer (company info, login/logout, version)
                  AccountFooter(isGuest: !isAuthenticated),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}
