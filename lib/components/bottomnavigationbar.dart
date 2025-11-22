import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../context/context.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../utils/navigation_helper.dart';

class BottomNavComponent extends StatefulWidget {
  final int cartCount;

  const BottomNavComponent({
    super.key,
    this.cartCount = AppContent.defaultCartCount,
  });

  @override
  State<BottomNavComponent> createState() => _BottomNavComponentState();
}

class _BottomNavComponentState extends State<BottomNavComponent> {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    // Only show cart button when cart has more than 1 item
    // Don't show bottom navigation bar (home, category, cart) at all
    if (widget.cartCount > 0) {
      return Obx(() {
        final cartTotal = cartController.cartTotalPrice;
        final formattedTotal = cartController.formatPrice(cartTotal);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: ResponsiveUtils.rp(8),
                offset: Offset(0, -ResponsiveUtils.rp(2)),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: InkWell(
              onTap: () => NavigationHelper.navigateToCart(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(16),
                  vertical: ResponsiveUtils.rp(12),
                ),
                child: Row(
                  children: [
                    // Cart Icon with Badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                          decoration: BoxDecoration(
                            color: AppColors.button,
                            borderRadius:
                                BorderRadius.circular(ResponsiveUtils.rp(12)),
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            color: AppColors.textLight,
                            size: ResponsiveUtils.rp(24),
                          ),
                        ),
                        if (widget.cartCount > 0)
                          Positioned(
                            right: -ResponsiveUtils.rp(6),
                            top: -ResponsiveUtils.rp(3),
                            child: Container(
                              padding: EdgeInsets.all(ResponsiveUtils.rp(2)),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.rp(10)),
                              ),
                              constraints: BoxConstraints(
                                minWidth: ResponsiveUtils.rp(18),
                                minHeight: ResponsiveUtils.rp(18),
                              ),
                              child: Text(
                                '${widget.cartCount}',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: ResponsiveUtils.sp(10),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: ResponsiveUtils.rp(12)),
                    // Total Amount and Coupon Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formattedTotal,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(18),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.rp(2)),
                          Text(
                            'Show coupon code to apply',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(12),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: ResponsiveUtils.rp(16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }

    // Return empty container when cart has 1 or fewer items
    // No bottom navigation bar will be shown
    return const SizedBox.shrink();
  }
}
