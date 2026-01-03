import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/responsive_spacing.dart';

class CartShimmerLoading extends StatelessWidget {
  const CartShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        children: List.generate(5, (index) {
          return PremiumCard(
            padding: ResponsiveSpacing.padding(all: 12),
            margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image shimmer
                Container(
                  width: ResponsiveUtils.rp(100),
                  height: ResponsiveUtils.rp(100),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                  ),
                ),
                ResponsiveSpacing.horizontal(12),
                // Details shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: ResponsiveUtils.rp(18),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      Container(
                        height: ResponsiveUtils.rp(16),
                        width: ResponsiveUtils.rp(150),
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Container(
                        height: ResponsiveUtils.rp(14),
                        width: ResponsiveUtils.rp(100),
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: ResponsiveUtils.rp(32),
                            width: ResponsiveUtils.rp(100),
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Container(
                            height: ResponsiveUtils.rp(16),
                            width: ResponsiveUtils.rp(80),
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

