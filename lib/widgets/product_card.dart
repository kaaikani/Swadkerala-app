import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/shimmers.dart';
import '../widgets/cached_app_image.dart';
import '../widgets/stock_level_label.dart';
import '../services/graphql_client.dart';

/// Unified product card widget used across all pages
/// (Collection products, Favourites, Frequently Ordered, Home page)
class ProductCard extends StatelessWidget {
  const ProductCard({
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
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
                  Container(
                    color: Color(0xFFF6F6F6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ResponsiveUtils.rp(10)),
                        topRight: Radius.circular(ResponsiveUtils.rp(10)),
                      ),
                      child: isOutOfStock
                          ? Stack(
                              children: [
                                // Show product image in background (dimmed) if available
                                if (imageUrl != null && imageUrl!.isNotEmpty)
                                  Opacity(
                                    opacity: 0.3,
                                    child: CachedAppImage(
                                      imageUrl: imageUrl!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                      cacheWidth: 300,
                                      cacheHeight: 300,
                                      errorWidget: Container(color: AppColors.backgroundLight),
                                    ),
                                  )
                                else
                                  // If no image URL, show placeholder background
                                  Container(
                                    color: AppColors.backgroundLight,
                                  ),
                                // Show "Out of Stock" text in the center of the image
                                Positioned.fill(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUtils.rp(12),
                                        vertical: ResponsiveUtils.rp(8),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                                      ),
                                      child: Text(
                                        'Out of Stock',
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(14),
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (imageUrl != null && imageUrl!.isNotEmpty
                          ? CachedAppImage(
                              imageUrl: imageUrl!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              cacheWidth: 300,
                              cacheHeight: 300,
                            )
                          : Skeletons.imageRect(
                              height: double.infinity,
                              width: double.infinity,
                              radius: 0,
                                )),
                    ),
                  ),
                  // Order count badge (top-left)
                  if (orderCount != null && orderCount! > 0)
                    Positioned(
                      top: ResponsiveUtils.rp(6),
                      left: ResponsiveUtils.rp(6),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(8),
                          vertical: ResponsiveUtils.rp(4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: ResponsiveUtils.rp(4),
                              offset: Offset(0, ResponsiveUtils.rp(2)),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: ResponsiveUtils.rp(14),
                              color: Colors.white,
                            ),
                            SizedBox(width: ResponsiveUtils.rp(4)),
                            Text(
                              '$orderCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.sp(12),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                            ),
                    ),
                  ),
                  Positioned(
                    top: ResponsiveUtils.rp(6),
                    right: ResponsiveUtils.rp(6),
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey[600],
                          size: ResponsiveUtils.rp(24),
                        ),
                      ),
                    ),
                  ),
                  if (discountPercent != null)
                    _DiscountRibbon(discountPercent: discountPercent!),
                  Positioned(
                    bottom: -ResponsiveUtils.rp(0),
                    right: -ResponsiveUtils.rp(0),
                    child: _AddToCartButton(
                      onPressed: isOutOfStock ? () async => false : (onAddToCart ?? () async => false),
                      isDisabled: isOutOfStock,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(8),
                vertical: ResponsiveUtils.rp(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name - Bold, larger, primary color
                  Flexible(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(16),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(3)),
                  if (showVariantSelector && variantSelector != null) ...[
                    variantSelector!,
                    SizedBox(height: ResponsiveUtils.rp(3)),
                  ] else ...[
                    // If only one variant, show group name and option name on same line
                    if (!hasMultipleVariants && groupName != null && groupName!.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            groupName!,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(4)),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(4)),
                          Expanded(
                            child: Text(
                              variantLabel,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(15),
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
                      if (groupName != null && groupName!.isNotEmpty)
                        Text(
                          groupName!,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (groupName != null && groupName!.isNotEmpty)
                        SizedBox(height: ResponsiveUtils.rp(3)),
                      // Option Name - Medium size, different color
                    Padding(
                      padding: EdgeInsets.only(top: ResponsiveUtils.rp(1)),
                      child: Text(
                        variantLabel,
                        style: TextStyle(
                            fontSize: ResponsiveUtils.sp(15),
                            fontWeight: FontWeight.w500,
                            color: AppColors.button,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ],
                  ],
                  SizedBox(height: ResponsiveUtils.rp(5)),
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
                              child: Text(
                                priceText,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(19),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stock status on right corner
                      stockLevel != null
                          ? StockLevelLabel(
                              stockLevel: stockLevel!,
                              compact: true,
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(8),
                                vertical: ResponsiveUtils.rp(4),
                              ),
                              decoration: BoxDecoration(
                                color: isOutOfStock
                                    ? AppColors.error.withValues(alpha: 0.12)
                                    : AppColors.success.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
                                border: Border.all(
                                  color: isOutOfStock
                                      ? AppColors.error.withValues(alpha: 0.4)
                                      : AppColors.success.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isOutOfStock ? 'Out of Stock' : 'In Stock',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(11),
                                  fontWeight: FontWeight.w600,
                                  color: isOutOfStock ? AppColors.error : AppColors.success,
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
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _iconScaleAnimation;
  
  _AddToCartState _state = _AddToCartState.idle;

  @override
  void initState() {
    super.initState();
    
    // Scale animation for button appearance
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutBack,
      ),
    );
    
    // Icon animation for state changes - very fast for immediate feedback
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeInOut,
      ),
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
    
    // Show loading state immediately for instant feedback
    setState(() {
      _state = _AddToCartState.loading;
    });
    
    // Prepare animation controller
    _iconController.reset();
    
    try {
      // Execute add to cart operation
      final success = await widget.onPressed();
      
      if (mounted) {
        // Immediately show success/error state - no delay
        setState(() {
          _state = success ? _AddToCartState.success : _AddToCartState.error;
        });
        
        // Start animation immediately
        _iconController.forward();
        
        // Reset to idle after animation completes
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted && _state != _AddToCartState.loading) {
            setState(() {
              _state = _AddToCartState.idle;
            });
            _iconController.reset();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = _AddToCartState.error;
        });
        _iconController.forward();
        
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _state = _AddToCartState.idle;
            });
            _iconController.reset();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedSize = ResponsiveUtils.rp(42);
    
    // Check if channel is Ind-Snacks or Ind-Non-Veg - use reactive observable
    return Obx(() {
      final channelToken = GraphqlService.channelTokenRx.value.isNotEmpty 
          ? GraphqlService.channelTokenRx.value 
          : GraphqlService.channelToken;
      final channelTokenLower = channelToken.toLowerCase();
      final isIndSnacksChannel = channelTokenLower == 'ind-snacks';
      final isIndNonVegChannel = channelTokenLower == 'ind' || channelTokenLower == 'ind-non veg';
    
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
      case _AddToCartState.loading:
        buttonColor1 = AppColors.buttonLight;
        buttonColor2 = AppColors.button;
        iconWidget = SizedBox(
          width: resolvedSize * 0.4,
          height: resolvedSize * 0.4,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
        break;
      case _AddToCartState.success:
        // Use AppColors for ind-snacks, red for ind-non-veg, green for other channels
        if (isIndSnacksChannel) {
          buttonColor1 = AppColors.buttonLight;
          buttonColor2 = AppColors.button;
        } else if (isIndNonVegChannel) {
          // Red color for non-veg channel
          buttonColor1 = AppColors.indNonVegRedLight;
          buttonColor2 = AppColors.indNonVegRed;
        } else {
          buttonColor1 = Colors.green.shade400;
          buttonColor2 = Colors.green.shade600;
        }
        iconWidget = AnimatedBuilder(
          animation: _iconController,
          builder: (context, child) {
            return Transform.scale(
              scale: _iconScaleAnimation.value,
              child: Transform.rotate(
                angle: _iconRotationAnimation.value,
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: resolvedSize * 0.5,
                ),
              ),
            );
          },
        );
        break;
      case _AddToCartState.error:
        buttonColor1 = Colors.red.shade400;
        buttonColor2 = Colors.red.shade600;
        iconWidget = AnimatedBuilder(
          animation: _iconController,
          builder: (context, child) {
            return Transform.scale(
              scale: _iconScaleAnimation.value,
              child: Transform.rotate(
                angle: _iconRotationAnimation.value,
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: resolvedSize * 0.5,
                ),
              ),
            );
          },
        );
        break;
      case _AddToCartState.idle:
      default:
        buttonColor1 = AppColors.buttonLight;
        buttonColor2 = AppColors.button;
        iconWidget = Icon(
          Icons.add,
          color: Colors.white,
          size: resolvedSize * 0.45,
        );
        break;
      }
    }
    
      return AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _iconController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              // Consume double tap to prevent it from bubbling to parent ProductCard
              // This prevents favorites toggle when double-tapping add to cart button
              onDoubleTap: () {
                // Consume the double tap event - do nothing but prevent propagation
              },
              behavior: HitTestBehavior.opaque,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.isDisabled ? null : _handleTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    height: resolvedSize,
                    width: resolvedSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [buttonColor1, buttonColor2],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_state == _AddToCartState.success 
                              ? (isIndSnacksChannel ? AppColors.button : Colors.green)
                              : _state == _AddToCartState.error 
                              ? Colors.red 
                              : Colors.black).withValues(alpha: 0.25),
                          blurRadius: ResponsiveUtils.rp(12),
                          offset: Offset(0, ResponsiveUtils.rp(4)),
                          spreadRadius: _state == _AddToCartState.success || _state == _AddToCartState.error ? 2 : 0,
                        ),
                      ],
                    ),
                    child: Center(child: iconWidget),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class _DiscountRibbon extends StatelessWidget {
  const _DiscountRibbon({required this.discountPercent});

  final double discountPercent;

  @override
  Widget build(BuildContext context) {
    final ribbonWidth = ResponsiveUtils.rp(60);
    final ribbonHeight = ResponsiveUtils.rp(34);
    final notchHeight = ResponsiveUtils.rp(10);

    return Positioned(
      top: ResponsiveUtils.rp(6),
      left: ResponsiveUtils.rp(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ribbonWidth,
            height: ribbonHeight,
            decoration: BoxDecoration(
              color: AppColors.error, // Red color like the image
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveUtils.rp(10)),
                topRight: Radius.circular(ResponsiveUtils.rp(10)),
                bottomRight: Radius.circular(ResponsiveUtils.rp(4)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: ResponsiveUtils.rp(6),
                  offset: Offset(0, ResponsiveUtils.rp(4)),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${discountPercent.round()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: ResponsiveUtils.sp(12),
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  'OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.sp(9),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          ClipPath(
            clipper: _RibbonTriangleClipper(),
            child: Container(
              width: ribbonWidth,
              height: notchHeight,
              decoration: BoxDecoration(
                color: AppColors.error, // Red color for the triangle notch
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RibbonTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}


