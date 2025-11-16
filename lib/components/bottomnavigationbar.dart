import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../context/context.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';
import '../utils/responsive.dart';
import '../controllers/cart/Cartcontroller.dart';

class BottomNavComponent extends StatefulWidget {
  final int cartCount;
  final ValueChanged<int>? onTap;

  const BottomNavComponent({
    super.key,
    this.cartCount = AppContent.defaultCartCount,
    this.onTap,
  });

  @override
  State<BottomNavComponent> createState() => _BottomNavComponentState();
}

class _BottomNavComponentState extends State<BottomNavComponent> {
  int _selectedIndex = 0;
  final CartController cartController = Get.find<CartController>();

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    // Handle navigation based on index
    switch (index) {
      case 0:
        // Home - already on home page
        if (widget.onTap != null) widget.onTap!(index);
        break;
      case 1:
        // Categories - can be implemented later
        if (widget.onTap != null) widget.onTap!(index);
        break;
      case 2:
        // Cart - navigate to cart page
        Get.toNamed('/cart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If cart has more than 1 item, show only cart button with total and coupon text
    if (widget.cartCount > 1) {
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
              onTap: () => Get.toNamed('/cart'),
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

    // Normal bottom navigation when cart has 1 or fewer items
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.button,
      unselectedItemColor: AppColors.heartInactive,
      iconSize: AppSizes.heartIconSize,
      elevation: AppSizes.cardElevation,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, color: AppColors.icon),
          activeIcon: const Icon(Icons.home),
          label: AppContent.homeLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined, color: AppColors.icon),
          activeIcon: const Icon(Icons.category),
          label: AppContent.categoryLabel,
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.shopping_cart_outlined, color: AppColors.icon),
              if (widget.cartCount > 0)
                Positioned(
                  right: -ResponsiveUtils.rp(6),
                  top: -ResponsiveUtils.rp(3),
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(2)),
                    decoration: BoxDecoration(
                      color: AppColors.heartActive,
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(10)),
                    ),
                    constraints: BoxConstraints(
                      minWidth: ResponsiveUtils.rp(18),
                      minHeight: ResponsiveUtils.rp(18),
                    ),
                    child: Text(
                      '${widget.cartCount}',
                      style: TextStyle(
                        color: AppColors.buttonText,
                        fontSize: ResponsiveUtils.sp(10),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          activeIcon: const Icon(Icons.shopping_cart),
          label: AppContent.cartLabel,
        ),
      ],
    );
  }
}
