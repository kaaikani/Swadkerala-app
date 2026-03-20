import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../graphql/Customer.graphql.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class AccountProfileCard extends StatelessWidget {
  final Query$GetActiveCustomer$activeCustomer customer;
  final VoidCallback onEditProfile;
  final CustomerController customerController;

  const AccountProfileCard({
    super.key,
    required this.customer,
    required this.onEditProfile,
    required this.customerController,
  });

  String _getInitials(String firstName, String lastName) {
    String firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    if (firstInitial.isEmpty && lastInitial.isEmpty) return 'U';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
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
                    if (customer.groups.isNotEmpty) ...[
                      SizedBox(height: ResponsiveUtils.rp(6)),
                      Wrap(
                        spacing: ResponsiveUtils.rp(6),
                        runSpacing: ResponsiveUtils.rp(4),
                        children: customer.groups.map((g) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.rp(8),
                            vertical: ResponsiveUtils.rp(3),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.button.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
                          ),
                          child: Text(
                            g.name,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(11),
                              fontWeight: FontWeight.w600,
                              color: AppColors.button,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              // Edit Button with red dot when any profile field is empty
              Obx(() {
                final c = customerController.activeCustomer.value;
                final hasIncomplete = c != null && CustomerController.isProfileIncomplete(c);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: onEditProfile,
                      icon: Icon(Icons.edit_outlined),
                      color: AppColors.button,
                      iconSize: ResponsiveUtils.rp(24),
                      tooltip: 'Edit Profile',
                    ),
                    if (hasIncomplete)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: ResponsiveUtils.rp(10),
                          height: ResponsiveUtils.rp(10),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          // Loyalty Points
          InkWell(
            onTap: () {
              Get.toNamed('/loyalty-points-transactions');
            },
            child: Container(
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
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.rp(20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountProfileErrorCard extends StatelessWidget {
  final VoidCallback onRetry;

  const AccountProfileErrorCard({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline,
            size: ResponsiveUtils.rp(40),
            color: AppColors.textSecondary,
          ),
          SizedBox(width: ResponsiveUtils.rp(16)),
          Expanded(
            child: Text(
              'Unable to load profile',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh, size: ResponsiveUtils.rp(18), color: AppColors.button),
            label: Text('Retry', style: TextStyle(color: AppColors.button, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
