import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../controllers/referral/referral_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../routes.dart';
import '../../widgets/snackbar.dart';

class AccountReferralSection extends StatelessWidget {
  final CustomerController customerController;
  final ReferralController referralController;
  final GlobalKey shareReferralKey;

  const AccountReferralSection({
    super.key,
    required this.customerController,
    required this.referralController,
    required this.shareReferralKey,
  });

  Rect? _shareOrigin(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> _shareReferralLink() async {
    final customer = customerController.activeCustomer.value;
    if (customer == null) return;
    final customerId = customer.id;
    final link = 'https://www.avsecomhub.com/products/kaaikani/refer?referrerId=$customerId';
    try {
      await Share.share(
        'Hey! Use my referral link to sign up on Kaaikani and we both earn rewards!\n\n$link',
        sharePositionOrigin: _shareOrigin(shareReferralKey),
      );
    } catch (e) {
      debugPrint('Error sharing referral: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_giftcard_outlined,
                  color: AppColors.iconLight, size: ResponsiveUtils.rp(20)),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Text(
                'Refer & Earn',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Obx(() {
                final earned = referralController.totalEarnedCards.value;
                if (earned > 0) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(2),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                    ),
                    child: Text(
                      '$earned cards to scratch!',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(11),
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          // Share referral link
          InkWell(
            key: shareReferralKey,
            onTap: () => _shareReferralLink(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(16),
                vertical: ResponsiveUtils.rp(14),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.button.withValues(alpha: 0.1), AppColors.button.withValues(alpha: 0.05)],
                ),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: Border.all(color: AppColors.button.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.share_outlined, color: AppColors.button, size: ResponsiveUtils.rp(22)),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Share your referral link',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(14),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: ResponsiveUtils.rp(8)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(8),
                                vertical: ResponsiveUtils.rp(2),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.button.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                              ),
                              child: Text(
                                'ID: ${customerController.activeCustomer.value?.id ?? ''}',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(11),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.button,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveUtils.rp(2)),
                        Obx(() => Text(
                          'Earn ${referralController.channelPoints.value} points per referral',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            color: AppColors.textSecondary,
                          ),
                        )),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppColors.button, size: ResponsiveUtils.rp(16)),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          // Quick action icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAction(
                Icons.style_outlined,
                'Scratch Cards',
                Colors.amber.shade700,
                () => Get.toNamed(AppRoutes.scratchCards),
              ),
              _buildQuickAction(
                Icons.people_outline,
                'Referrals',
                Colors.blue.shade700,
                () => Get.toNamed(AppRoutes.myReferrals),
              ),
              _buildQuickAction(
                Icons.location_on_outlined,
                'Addresses',
                Colors.green.shade700,
                () => Get.toNamed('/addresses'),
              ),
              _buildQuickAction(
                Icons.favorite_outline,
                'Wishlist',
                Colors.red.shade700,
                () => Get.toNamed('/favourite'),
              ),
              _buildQuickAction(
                Icons.shopping_bag_outlined,
                'Preferred',
                Colors.purple.shade700,
                () => Get.toNamed('/frequently-ordered'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: ResponsiveUtils.rp(54),
            height: ResponsiveUtils.rp(54),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(27)),
            ),
            child: Icon(icon, color: color, size: ResponsiveUtils.rp(26)),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog for redeeming a referral code
class RedeemReferralDialog {
  static void show({
    required CustomerController customerController,
    required ReferralController referralController,
  }) {
    final textController = TextEditingController();
    final isSubmitting = false.obs;
    Get.dialog(
      AlertDialog(
        title: const Text('Redeem Referral'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the referrer ID to redeem your referral reward.'),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Enter referrer ID',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: isSubmitting.value
                ? null
                : () async {
                    final referrerId = textController.text.trim();
                    if (referrerId.isEmpty) {
                      SnackBarWidget.showError('Please enter a referrer ID');
                      return;
                    }
                    isSubmitting.value = true;
                    final customerId = customerController.activeCustomer.value?.id;
                    final success = await referralController.registerReferral(referrerId, customerId: customerId);
                    isSubmitting.value = false;
                    if (success) {
                      Get.back();
                      SnackBarWidget.showSuccess('Referral redeemed successfully!');
                      referralController.fetchMyReferrals();
                      referralController.fetchEarnedScratchCards();
                    } else {
                      SnackBarWidget.showError('Failed to redeem referral. Please check the ID and try again.');
                    }
                  },
            child: isSubmitting.value
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Redeem'),
          )),
        ],
      ),
    );
  }
}
