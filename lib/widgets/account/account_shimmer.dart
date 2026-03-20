import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class AccountShimmer extends StatelessWidget {
  const AccountShimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
                          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
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
                            margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
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
