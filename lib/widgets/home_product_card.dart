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
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03 + _shadowAnimation.value * 0.2),
              blurRadius: ResponsiveUtils.rp(8),
              offset: Offset(0, ResponsiveUtils.rp(4)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                clipBehavior: Clip.hardEdge,
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
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.rp(12))),
                      ),
                      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        child: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                                ? _AnimatedProductImage(imageUrl: widget.imageUrl!)
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
                      top: ResponsiveUtils.rp(8),
                      left: ResponsiveUtils.rp(8),
                      child: _AnimatedOrderCountBadge(orderCount: widget.orderCount!),
                    ),
                  Positioned(
                    top: ResponsiveUtils.rp(8),
                    right: ResponsiveUtils.rp(8),
                    child: _AnimatedFavoriteButton(
                      isFavorite: widget.isFavorite,
                      onTap: widget.onFavoriteToggle,
                    ),
                  ),
                  if (widget.discountPercent != null)
                    Positioned(
                      bottom: ResponsiveUtils.rp(8),
                      left: ResponsiveUtils.rp(8),
                      child: _AnimatedDiscountBadge(discountPercent: widget.discountPercent!),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveUtils.rp(10),
                ResponsiveUtils.rp(10),
                ResponsiveUtils.rp(10),
                ResponsiveUtils.rp(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: _AnimatedText(
                      text: widget.name,
                      fontSize: ResponsiveUtils.sp(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  if (widget.showVariantSelector && widget.variantSelector != null) ...[
                    widget.variantSelector!,
                    SizedBox(height: ResponsiveUtils.rp(4)),
                  ] else ...[
                    if (!widget.hasMultipleVariants && widget.groupName != null && widget.groupName!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.variantLabel,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(11),
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else ...[
                      Padding(
                        padding: EdgeInsets.only(top: ResponsiveUtils.rp(1)),
                        child: Text(
                          widget.variantLabel,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(11),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _AnimatedPriceText(
                              price: widget.priceText,
                              fontSize: ResponsiveUtils.sp(14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(4)),
                      widget.isOutOfStock 
                        ? StockLevelLabel(stockLevel: 'OUT_OF_STOCK', compact: true)
                        : _AddToCartButton(
                            onPressed: widget.onAddToCart ?? () async => false,
                            isDisabled: widget.isOutOfStock,
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
    final resolvedHeight = ResponsiveUtils.rp(30);
    final resolvedWidth = ResponsiveUtils.rp(65);
    
    // Determine colors and icon based on state
    Color buttonBgColor;
    Color buttonBorderColor;
    Color textColor;
    Widget contentWidget;
    
    // If disabled (out of stock), use grey colors
    if (widget.isDisabled) {
      buttonBgColor = Colors.grey.shade200;
      buttonBorderColor = Colors.grey.shade300;
      textColor = Colors.grey.shade500;
      contentWidget = Text(
        'ADD',
        style: TextStyle(
          color: textColor,
          fontSize: ResponsiveUtils.sp(12),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      );
    } else {
      switch (_state) {
        case _AddToCartState.idle:
          buttonBgColor = Colors.white;
          buttonBorderColor = AppColors.button;
          textColor = AppColors.button;
          contentWidget = Text(
            'ADD',
            style: TextStyle(
              color: textColor,
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          );
          break;
        case _AddToCartState.loading:
          buttonBgColor = AppColors.button.withValues(alpha: 0.1);
          buttonBorderColor = AppColors.button;
          textColor = AppColors.button;
          contentWidget = SizedBox(
            width: ResponsiveUtils.rp(14),
            height: ResponsiveUtils.rp(14),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
            ),
          );
          break;
        case _AddToCartState.success:
          buttonBgColor = AppColors.button;
          buttonBorderColor = AppColors.button;
          textColor = Colors.white;
          contentWidget = Icon(
            Icons.check,
            color: Colors.white,
            size: ResponsiveUtils.rp(18),
          );
          break;
        case _AddToCartState.error:
          buttonBgColor = AppColors.error;
          buttonBorderColor = AppColors.error;
          textColor = Colors.white;
          contentWidget = Icon(
            Icons.close,
            color: Colors.white,
            size: ResponsiveUtils.rp(18),
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
            width: resolvedWidth,
            height: resolvedHeight,
            decoration: BoxDecoration(
              color: buttonBgColor,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
              border: Border.all(
                color: buttonBorderColor,
                width: 1,
              ),
              boxShadow: _state == _AddToCartState.idle && !widget.isDisabled
                  ? [
                      BoxShadow(
                        color: AppColors.button.withValues(alpha: 0.1),
                        blurRadius: ResponsiveUtils.rp(4),
                        offset: Offset(0, ResponsiveUtils.rp(2)),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                onTap: widget.isDisabled ? null : _handleTap,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _iconScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconScaleAnimation.value,
                        child: contentWidget,
                      );
                    },
                  ),
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
