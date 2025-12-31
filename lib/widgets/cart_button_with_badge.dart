import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';

/// Reusable cart button with quantity badge and glitter animation
class CartButtonWithBadge extends StatefulWidget {
  final CartController cartController;
  final bool useIconButton; // If true, uses IconButton, otherwise uses custom button

  const CartButtonWithBadge({
    Key? key,
    required this.cartController,
    this.useIconButton = true,
  }) : super(key: key);

  @override
  State<CartButtonWithBadge> createState() => _CartButtonWithBadgeState();
}

class _CartButtonWithBadgeState extends State<CartButtonWithBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _glitterController;
  late Animation<double> _glitterAnimation;
  int _previousQuantity = 0;

  @override
  void initState() {
    super.initState();
    
    // Initialize glitter animation
    _glitterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _glitterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glitterController,
      curve: Curves.easeInOut,
    ));
    
    // Initialize previous quantity
    _previousQuantity = widget.cartController.cartItemCount;
  }

  @override
  void dispose() {
    _glitterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentQuantity = widget.cartController.cartItemCount;
      
      // Trigger glitter animation when quantity changes
      if (currentQuantity != _previousQuantity && _previousQuantity > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _glitterController.forward(from: 0.0).then((_) {
            _glitterController.reverse();
          });
        });
        _previousQuantity = currentQuantity;
      } else if (_previousQuantity == 0) {
        _previousQuantity = currentQuantity;
      }
      
      if (widget.useIconButton) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: AnimatedBuilder(
                animation: _glitterAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_glitterAnimation.value * 0.2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _glitterAnimation.value > 0
                            ? RadialGradient(
                                colors: [
                                  AppColors.button.withOpacity(0.3 * _glitterAnimation.value),
                                  Colors.transparent,
                                ],
                              )
                            : null,
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: AppColors.icon,
                      ),
                    ),
                  );
                },
              ),
              onPressed: () {
                Get.toNamed('/cart');
              },
            ),
            if (currentQuantity > 0)
              Positioned(
                right: 6,
                top: 6,
                child: AnimatedBuilder(
                  animation: _glitterAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(6),
                        vertical: ResponsiveUtils.rp(2),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.button,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                        boxShadow: _glitterAnimation.value > 0
                            ? [
                                BoxShadow(
                                  color: AppColors.button.withOpacity(0.6 * _glitterAnimation.value),
                                  blurRadius: 8 * _glitterAnimation.value,
                                  spreadRadius: 2 * _glitterAnimation.value,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        currentQuantity > 99 ? '99+' : currentQuantity.toString(),
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: ResponsiveUtils.sp(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      } else {
        // Custom button style for SliverAppBar (like product detail page)
        return Padding(
          padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: ResponsiveUtils.rp(48),
                height: ResponsiveUtils.rp(48),
                decoration: BoxDecoration(
                  color: AppColors.card.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: ResponsiveUtils.rp(12),
                      offset: Offset(0, ResponsiveUtils.rp(4)),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(24)),
                    onTap: () {
                      Get.toNamed('/cart');
                    },
                    child: AnimatedBuilder(
                      animation: _glitterAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_glitterAnimation.value * 0.15),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _glitterAnimation.value > 0
                                  ? RadialGradient(
                                      colors: [
                                        AppColors.button.withOpacity(0.2 * _glitterAnimation.value),
                                        Colors.transparent,
                                      ],
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.shopping_cart,
                                color: AppColors.icon,
                                size: ResponsiveUtils.rp(24),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (currentQuantity > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: AnimatedBuilder(
                    animation: _glitterAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(6),
                          vertical: ResponsiveUtils.rp(2),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.button,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                          boxShadow: _glitterAnimation.value > 0
                              ? [
                                  BoxShadow(
                                    color: AppColors.button.withOpacity(0.6 * _glitterAnimation.value),
                                    blurRadius: 8 * _glitterAnimation.value,
                                    spreadRadius: 2 * _glitterAnimation.value,
                                  ),
                                ]
                              : null,
                        ),
                        constraints: BoxConstraints(
                          minWidth: ResponsiveUtils.rp(18),
                          minHeight: ResponsiveUtils.rp(18),
                        ),
                        child: Center(
                          child: Text(
                            currentQuantity > 99 ? '99+' : currentQuantity.toString(),
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: ResponsiveUtils.sp(10),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      }
    });
  }
}














