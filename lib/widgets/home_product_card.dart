import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/shimmers.dart';
import 'cached_app_image.dart';
import 'stock_level_label.dart';

/// Smaller product card widget specifically for home page (favorites, frequently ordered)
/// Same concept as ProductCard but in smaller size with attractive animations
class HomeProductCard extends StatefulWidget {
  const HomeProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
    required this.onDoubleTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.variantLabel,
    required this.priceText,
    required this.onAddToCart,
    this.discountPercent,
    this.variantSelector,
    this.showVariantSelector = false,
    this.shadowPriceText,
    this.orderCount,
    this.isOutOfStock = false,
    this.stockLevel,
    this.groupName,
    this.hasMultipleVariants = false,
  });

  final String name;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final double? discountPercent;
  final Widget? variantSelector;
  final bool showVariantSelector;
  final String variantLabel;
  final String priceText;
  final String? shadowPriceText;
  final Future<bool> Function()? onAddToCart;
  final int? orderCount;
  final bool isOutOfStock;
  /// Raw stock level (IN_STOCK, LOW_STOCK, OUT_OF_STOCK). When set, StockLevelLabel is shown.
  final String? stockLevel;
  final String? groupName;
  final bool hasMultipleVariants;

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _shadowAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 0.04, end: 0.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _shadowAnimation.value),
              blurRadius: ResponsiveUtils.rp(12) * (1 + _controller.value * 0.5),
              offset: Offset(0, ResponsiveUtils.rp(4) * (1 + _controller.value * 0.3)),
              spreadRadius: _controller.value * 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ColorFiltered(
                    colorFilter: widget.isOutOfStock
                        ? const ColorFilter.matrix(<double>[
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0, 0, 0, 1, 0,
                          ])
                        : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: Container(
                      color: Color(0xFFF6F6F6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ResponsiveUtils.rp(8)),
                          topRight: Radius.circular(ResponsiveUtils.rp(8)),
                        ),
                        child: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                                ? _AnimatedProductImage(
                                    imageUrl: widget.imageUrl!,
                                  )
                                : Skeletons.imageRect(
                                    height: double.infinity,
                                    width: double.infinity,
                                    radius: 0,
                                  )),
                      ),
                    ),
                  ),
                  if (widget.orderCount != null && widget.orderCount! > 0)
                    Positioned(
                      top: ResponsiveUtils.rp(6),
                      left: ResponsiveUtils.rp(6),
                      child: _AnimatedOrderCountBadge(
                        orderCount: widget.orderCount!,
                      ),
                    ),
                  Positioned(
                    top: ResponsiveUtils.rp(4),
                    right: ResponsiveUtils.rp(4),
                    child: _AnimatedFavoriteButton(
                      isFavorite: widget.isFavorite,
                      onTap: widget.onFavoriteToggle,
                    ),
                  ),
                  if (widget.discountPercent != null)
                    Positioned(
                      top: ResponsiveUtils.rp(4),
                      left: ResponsiveUtils.rp(4),
                      child: _AnimatedDiscountBadge(
                        discountPercent: widget.discountPercent!,
                      ),
                    ),
                  Positioned(
                    bottom: -ResponsiveUtils.rp(0),
                    right: -ResponsiveUtils.rp(0),
                    child: _AddToCartButton(
                      onPressed: widget.isOutOfStock ? () async => false : (widget.onAddToCart ?? () async => false),
                      isDisabled: widget.isOutOfStock,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(6),
                vertical: ResponsiveUtils.rp(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name - Bold, larger, primary color
                  Flexible(
                    child: _AnimatedText(
                      text: widget.name,
                      fontSize: ResponsiveUtils.sp(13),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(2)),
                  if (widget.showVariantSelector && widget.variantSelector != null) ...[
                            widget.variantSelector!,
                            SizedBox(height: ResponsiveUtils.rp(2)),
                          ] else ...[
                            // If only one variant, show group name and option name on same line
                            if (!widget.hasMultipleVariants && widget.groupName != null && widget.groupName!.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            widget.groupName!,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(10),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(3)),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(10),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(3)),
                          Expanded(
                            child: Text(
                              widget.variantLabel,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(11),
                                fontWeight: FontWeight.w500,
                                color: AppColors.button,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else ...[
                      // If multiple variants, show group name and option name on separate lines
                      if (widget.groupName != null && widget.groupName!.isNotEmpty)
                        Text(
                          widget.groupName!,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(10),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (widget.groupName != null && widget.groupName!.isNotEmpty)
                        SizedBox(height: ResponsiveUtils.rp(2)),
                      // Option Name - Medium size, different color
                      Padding(
                        padding: EdgeInsets.only(top: ResponsiveUtils.rp(1)),
                        child: Text(
                          widget.variantLabel,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(11),
                            fontWeight: FontWeight.w500,
                            color: AppColors.button,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                  SizedBox(height: ResponsiveUtils.rp(3)),
                  // Total row: price on left, stock status on right corner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: _AnimatedPriceText(
                                price: widget.priceText,
                                fontSize: ResponsiveUtils.sp(15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stock status on right corner
                      widget.stockLevel != null
                          ? StockLevelLabel(
                              stockLevel: widget.stockLevel!,
                              compact: true,
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(6),
                                vertical: ResponsiveUtils.rp(3),
                              ),
                              decoration: BoxDecoration(
                                color: widget.isOutOfStock
                                    ? AppColors.error.withValues(alpha: 0.12)
                                    : AppColors.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(5)),
                                border: Border.all(
                                  color: widget.isOutOfStock
                                      ? AppColors.error.withValues(alpha: 0.4)
                                      : AppColors.success.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.isOutOfStock ? 'Out of Stock' : 'In Stock',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(10),
                                  fontWeight: FontWeight.w600,
                                  color: widget.isOutOfStock ? AppColors.error : AppColors.success,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Animated product image with fade-in and scale effect
class _AnimatedProductImage extends StatefulWidget {
  final String imageUrl;

  const _AnimatedProductImage({required this.imageUrl});

  @override
  State<_AnimatedProductImage> createState() => _AnimatedProductImageState();
}

class _AnimatedProductImageState extends State<_AnimatedProductImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: CachedAppImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              cacheWidth: 300,
              cacheHeight: 300,
            ),
          ),
        );
      },
    );
  }
}

/// Animated favorite button with pulse effect
class _AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _AnimatedFavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  @override
  State<_AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<_AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      upperBound: 1.0, // Ensure controller never exceeds 1.0
    );

    // Use a safer curve that doesn't overshoot to prevent TweenSequence errors
    // Curves.elasticOut can overshoot, causing values outside [0.0, 1.0]
    // Use easeOutBack which has a slight overshoot but is safer
    final baseAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    
    // Create a clamped wrapper animation to ensure values stay in [0.0, 1.0]
    final clampedAnimation = _ClampedAnimation(
      parent: baseAnimation,
      min: 0.0,
      max: 1.0,
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3), weight: 0.5),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 0.5),
    ]).animate(clampedAnimation);
  }

  @override
  void didUpdateWidget(_AnimatedFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite && mounted) {
      // Stop any ongoing animation first
      if (_controller.isAnimating) {
        _controller.stop();
      }
      // Reset controller to beginning and ensure value is 0.0
      _controller.reset();
      // Schedule animation after the current frame to avoid layout issues
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        
        // Ensure controller is in a valid state before starting animation
        if (_controller.status == AnimationStatus.dismissed || 
            _controller.status == AnimationStatus.completed) {
          try {
            // Ensure value is exactly 0.0 before starting
            if (_controller.value != 0.0) {
              _controller.reset();
            }
            _controller.forward(from: 0.0);
          } catch (e) {
            // Ignore animation errors during widget rebuild
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(ResponsiveUtils.rp(3)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.isFavorite
                        ? Colors.red.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: ResponsiveUtils.rp(4),
                    spreadRadius: widget.isFavorite ? 2 : 0,
                  ),
                ],
              ),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : Colors.grey[600],
                size: ResponsiveUtils.rp(16),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Animated order count badge with bounce effect
class _AnimatedOrderCountBadge extends StatefulWidget {
  final int orderCount;

  const _AnimatedOrderCountBadge({required this.orderCount});

  @override
  State<_AnimatedOrderCountBadge> createState() => _AnimatedOrderCountBadgeState();
}

class _AnimatedOrderCountBadgeState extends State<_AnimatedOrderCountBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 0.3),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.9), weight: 0.2),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 0.5),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(6),
              vertical: ResponsiveUtils.rp(3),
            ),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.button.withValues(alpha: 0.4),
                  blurRadius: ResponsiveUtils.rp(4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: ResponsiveUtils.rp(12),
                  color: Colors.white,
                ),
                SizedBox(width: ResponsiveUtils.rp(3)),
                Text(
                  '${widget.orderCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveUtils.sp(10),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animated discount badge with shimmer effect
class _AnimatedDiscountBadge extends StatefulWidget {
  final double discountPercent;

  const _AnimatedDiscountBadge({required this.discountPercent});

  @override
  State<_AnimatedDiscountBadge> createState() => _AnimatedDiscountBadgeState();
}

class _AnimatedDiscountBadgeState extends State<_AnimatedDiscountBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.rp(6),
            vertical: ResponsiveUtils.rp(3),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.error,
                AppColors.error.withValues(alpha: 0.8),
                AppColors.error,
              ],
              stops: [
                0.0,
                0.5 + _shimmerAnimation.value * 0.25,
                1.0,
              ],
            ),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: 0.5),
                blurRadius: ResponsiveUtils.rp(4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            '${widget.discountPercent.toStringAsFixed(0)}% OFF',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.sp(9),
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}

/// Animated text with fade-in effect
class _AnimatedText extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final int maxLines;

  const _AnimatedText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    this.maxLines = 1,
  });

  @override
  State<_AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.color,
            height: 1.2,
          ),
          maxLines: widget.maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Animated price text with count-up effect
class _AnimatedPriceText extends StatefulWidget {
  final String price;
  final double fontSize;

  const _AnimatedPriceText({
    required this.price,
    required this.fontSize,
  });

  @override
  State<_AnimatedPriceText> createState() => _AnimatedPriceTextState();
}

class _AnimatedPriceTextState extends State<_AnimatedPriceText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1.1), weight: 0.5),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 0.5),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Text(
            widget.price,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class _AddToCartButton extends StatefulWidget {
  const _AddToCartButton({
    required this.onPressed,
    this.isDisabled = false,
  });

  final Future<bool> Function() onPressed;
  final bool isDisabled;

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

enum _AddToCartState { idle, loading, success, error }

class _AddToCartButtonState extends State<_AddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _iconController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconScaleAnimation;
  
  _AddToCartState _state = _AddToCartState.idle;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3).chain(
        CurveTween(curve: Curves.easeOut),
      ), weight: 0.4),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0).chain(
        CurveTween(curve: Curves.elasticOut),
      ), weight: 0.6),
    ]).animate(_iconController);
    
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.isDisabled) return;
    if (_state == _AddToCartState.loading || _state == _AddToCartState.success) return;
    
    setState(() {
      _state = _AddToCartState.loading;
    });
    _iconController.forward(from: 0.0);
    
    try {
      final success = await widget.onPressed();
      
      if (mounted) {
        setState(() {
          _state = success ? _AddToCartState.success : _AddToCartState.error;
        });
        
        if (success) {
          _iconController.forward(from: 0.0).then((_) {
            _iconController.reverse();
          });
          
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              setState(() {
                _state = _AddToCartState.idle;
              });
            }
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _state = _AddToCartState.idle;
              });
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = _AddToCartState.error;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _state = _AddToCartState.idle;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedSize = ResponsiveUtils.rp(36);
    
    // Determine colors and icon based on state
    Color buttonColor1;
    Color buttonColor2;
    Widget iconWidget;
    
    // If disabled (out of stock), use grey colors
    if (widget.isDisabled) {
      buttonColor1 = Colors.grey.shade400;
      buttonColor2 = Colors.grey.shade600;
      iconWidget = Icon(
        Icons.add,
        color: Colors.white,
        size: resolvedSize * 0.45,
      );
    } else {
      switch (_state) {
        case _AddToCartState.idle:
          buttonColor1 = AppColors.button;
          buttonColor2 = AppColors.button.withValues(alpha: 0.8);
          iconWidget = Icon(
            Icons.add,
            color: Colors.white,
            size: resolvedSize * 0.45,
          );
          break;
        case _AddToCartState.loading:
          buttonColor1 = AppColors.button.withValues(alpha: 0.7);
          buttonColor2 = AppColors.button.withValues(alpha: 0.5);
          iconWidget = SizedBox(
            width: resolvedSize * 0.45,
            height: resolvedSize * 0.45,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
          break;
        case _AddToCartState.success:
          buttonColor1 = AppColors.success;
          buttonColor2 = AppColors.success.withValues(alpha: 0.8);
          iconWidget = Icon(
            Icons.check,
            color: Colors.white,
            size: resolvedSize * 0.5,
          );
          break;
        case _AddToCartState.error:
          buttonColor1 = AppColors.error;
          buttonColor2 = AppColors.error.withValues(alpha: 0.8);
          iconWidget = Icon(
            Icons.close,
            color: Colors.white,
            size: resolvedSize * 0.45,
          );
          break;
      }
    }
    
      return AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _iconScaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: resolvedSize,
              height: resolvedSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [buttonColor1, buttonColor2],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: buttonColor1.withValues(alpha: 0.4),
                    blurRadius: ResponsiveUtils.rp(8),
                    offset: Offset(0, ResponsiveUtils.rp(2)),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.isDisabled ? null : _handleTap,
                  child: AnimatedBuilder(
                    animation: _iconScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconScaleAnimation.value,
                        child: Center(child: iconWidget),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
  }
}

/// A custom animation that clamps values to a specific range
/// This prevents TweenSequence from receiving values outside [0.0, 1.0]
class _ClampedAnimation extends Animation<double> {
  final Animation<double> parent;
  final double min;
  final double max;

  _ClampedAnimation({
    required this.parent,
    required this.min,
    required this.max,
  }) : assert(min <= max);

  @override
  void addListener(VoidCallback listener) => parent.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => parent.removeListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      parent.addStatusListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      parent.removeStatusListener(listener);

  @override
  AnimationStatus get status => parent.status;

  @override
  double get value => parent.value.clamp(min, max);
}
