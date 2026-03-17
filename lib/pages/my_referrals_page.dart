import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/referral/referral_controller.dart';
import '../graphql/referral.graphql.dart';
import '../graphql/schema.graphql.dart' show Enum$ReferralStatus;
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../services/analytics_service.dart';

class MyReferralsPage extends StatefulWidget {
  const MyReferralsPage({super.key});

  @override
  State<MyReferralsPage> createState() => _MyReferralsPageState();
}

class _MyReferralsPageState extends State<MyReferralsPage> {
  final ReferralController referralController = Get.find<ReferralController>();

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'MyReferrals');
    referralController.fetchMyReferrals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Referrals',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0.5,
      ),
      body: Obx(() {
        if (referralController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = referralController.referrals;
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
                SizedBox(height: ResponsiveUtils.rp(16)),
                Text(
                  'No referrals yet',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Text(
                  'Share your referral link to get started!',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => referralController.fetchMyReferrals(),
          child: ListView.builder(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildReferralItem(item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildReferralItem(Query$MyReferrals$myReferrals$items item) {
    final statusColor = _getStatusColor(item.status);
    final statusLabel = item.status.name;
    final referredName = '${item.referredCustomer.firstName} ${item.referredCustomer.lastName}'.trim();
    final displayName = referredName.isNotEmpty ? referredName : 'Unknown';
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(10)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.rp(40),
            height: ResponsiveUtils.rp(40),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
            ),
            child: Center(
              child: Text(
                '#${item.referralNumber}',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveUtils.rp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(2)),
                if (item.order != null)
                  Text(
                    'Order: ${item.order!.code} (${item.order!.state})',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(11),
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(8),
                  vertical: ResponsiveUtils.rp(3),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(10),
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              if (item.points > 0) ...[
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  '+${item.points} pts',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(13),
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
              SizedBox(height: ResponsiveUtils.rp(2)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.isScratched ? Icons.check_circle : Icons.circle_outlined,
                    size: ResponsiveUtils.rp(12),
                    color: item.isScratched ? Colors.green : Colors.grey,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(3)),
                  Text(
                    item.isScratched ? 'Scratched' : 'Not Scratched',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(10),
                      color: item.isScratched ? Colors.green.shade700 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(Enum$ReferralStatus status) {
    switch (status) {
      case Enum$ReferralStatus.REGISTERED:
        return Colors.orange;
      case Enum$ReferralStatus.ELIGIBLE:
        return Colors.blue;
      case Enum$ReferralStatus.CLAIMED:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
