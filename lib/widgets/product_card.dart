import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/shimmers.dart';
import '../widgets/cached_app_image.dart';
import '../widgets/stock_level_label.dart';


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
    this.cartQuantity = 0,
    this.onIncrement,
    this.onDecrement,
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
  final Future<bool> Function()? onIncrement;
  final Future<bool> Function()? onDecrement;
  final int cartQuantity;
  final int? orderCount;
  final bool isOutOfStock;
  /// Raw stock level (IN_STOCK, LOW_STOCK, OUT_OF_STOCK). When set, StockLevelLabel is shown.
  final String? stockLevel;
  final String? groupName;
  final bool hasMultipleVariants;

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          // Very subtle shadow for modern feel
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE SECTION
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                   Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.rp(8))),
                    ),
                    padding: EdgeInsets.all(ResponsiveUtils.rp(2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.rp(8))),
                      child: ColorFiltered(
                        colorFilter: isOutOfStock
                            ? const ColorFilter.matrix(<double>[
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0, 0, 0, 1, 0,
                              ])
                            : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                        child: (imageUrl != null && imageUrl!.isNotEmpty
                            ? CachedAppImage(
                                imageUrl: imageUrl!,
                                fit: BoxFit.contain, // normally fit
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
                  ),
                  
                  // TAGS & BADGES
                  // Order count badge
                  if (orderCount != null && orderCount! > 0)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8), vertical: ResponsiveUtils.rp(4)),
                        decoration: BoxDecoration(
                          color: AppColors.swadKeralaPrimary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ResponsiveUtils.rp(8)),
                            bottomRight: Radius.circular(ResponsiveUtils.rp(8)),
                          ),
                        ),
                        child: Text(
                          '$orderCount Ordered',
                          style: TextStyle(color: Colors.white, fontSize: ResponsiveUtils.sp(11), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  
                  // Discount Flag Ribbon
                  if (discountPercent != null)
                    Positioned(
                      top: 0,
                      left: ResponsiveUtils.rp(6),
                      child: _DiscountRibbon(discountPercent: discountPercent!),
                    ),
                  
                  // Favorite Toggle
                  Positioned(
                    bottom: ResponsiveUtils.rp(4),
                    right: ResponsiveUtils.rp(4),
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(6)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey[400],
                          size: ResponsiveUtils.rp(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // DETAILS SECTION
            Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  SizedBox(
                    height: ResponsiveUtils.rp(36), // Fixed height for 2 lines to align bottoms
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  
                  // Variant & Weight Label
                  if (showVariantSelector && variantSelector != null)
                    variantSelector!
                  else
                    SizedBox(
                      height: ResponsiveUtils.rp(16),
                      child: Text(
                        variantLabel,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(11),
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  
                  // BOTTOM ROW: Price & Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price Container
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              priceText,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(14),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (shadowPriceText != null)
                              Text(
                                shadowPriceText!,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(10),
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(4)),
                      // Button
                      isOutOfStock 
                          ? StockLevelLabel(stockLevel: 'OUT_OF_STOCK', compact: true)
                          : _AddToCartButton(
                              onPressed: onAddToCart ?? () async => false,
                              isDisabled: isOutOfStock,
                              cartQuantity: cartQuantity,
                              onIncrement: onIncrement,
                              onDecrement: onDecrement,
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
    this.cartQuantity = 0,
    this.onIncrement,
    this.onDecrement,
  });

  final Future<bool> Function() onPressed;
  final bool isDisabled;
  final int cartQuantity;
  final Future<bool> Function()? onIncrement;
  final Future<bool> Function()? onDecrement;

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

  Future<void> _handleIncrement() async {
    if (widget.isDisabled) return;
    if (_state == _AddToCartState.loading) return;
    if (widget.onIncrement != null) {
      if (mounted) setState(() => _state = _AddToCartState.loading);
      await widget.onIncrement!();
      if (mounted) setState(() => _state = _AddToCartState.idle);
    }
  }

  Future<void> _handleDecrement() async {
    if (widget.isDisabled) return;
    if (_state == _AddToCartState.loading) return;
    if (widget.onDecrement != null) {
      if (mounted) setState(() => _state = _AddToCartState.loading);
      await widget.onDecrement!();
      if (mounted) setState(() => _state = _AddToCartState.idle);
    }
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
    final resolvedHeight = ResponsiveUtils.rp(36);
    final resolvedWidth = ResponsiveUtils.rp(72);
    
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
              fontSize: ResponsiveUtils.sp(14),
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
    
    if (widget.cartQuantity > 0) {
      return Container(
        width: ResponsiveUtils.rp(80),
        height: resolvedHeight,
        decoration: BoxDecoration(
          color: AppColors.button,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
          boxShadow: [
            BoxShadow(
              color: AppColors.button.withValues(alpha: 0.2),
              blurRadius: 4, offset: Offset(0, 2),
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _state == _AddToCartState.loading ? null : _handleDecrement,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8), vertical: ResponsiveUtils.rp(6)),
                child: Icon(Icons.remove, color: Colors.white, size: ResponsiveUtils.rp(18)),
              ),
            ),
            _state == _AddToCartState.loading 
                ? SizedBox(width: ResponsiveUtils.rp(16), height: ResponsiveUtils.rp(16), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('${widget.cartQuantity}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ResponsiveUtils.sp(15))),
            GestureDetector(
              onTap: _state == _AddToCartState.loading ? null : _handleIncrement,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8), vertical: ResponsiveUtils.rp(6)),
                child: Icon(Icons.add, color: Colors.white, size: ResponsiveUtils.rp(18)),
              ),
            ),
          ],
        )
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _iconController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onDoubleTap: () {}, // Consume double tap
            behavior: HitTestBehavior.opaque,
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
          ),
        );
      },
    );
  }
}

class _DiscountRibbon extends StatelessWidget {
  const _DiscountRibbon({required this.discountPercent});

  final double discountPercent;

  @override
  Widget build(BuildContext context) {
    final ribbonWidth = ResponsiveUtils.rp(44);
    final bodyHeight = ResponsiveUtils.rp(52);
    final notchHeight = ResponsiveUtils.rp(10);
    final foldWidth = ResponsiveUtils.rp(7);
    final foldHeight = ResponsiveUtils.rp(7);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main ribbon body (vertical with V-cut at bottom)
        CustomPaint(
          painter: _VerticalFlagPainter(
            color: AppColors.error,
            notchHeight: notchHeight,
          ),
          child: SizedBox(
            width: ribbonWidth,
            height: bodyHeight + notchHeight,
            child: Padding(
              padding: EdgeInsets.only(
                top: ResponsiveUtils.rp(6),
                bottom: notchHeight + ResponsiveUtils.rp(2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${discountPercent.round()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: ResponsiveUtils.sp(15),
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(1)),
                  Text(
                    'OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveUtils.sp(10),
                      letterSpacing: 1,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Fold triangle on the right side
        CustomPaint(
          painter: _RibbonFoldPainter(color: const Color(0xFFB71C1C)),
          size: Size(foldWidth, foldHeight),
        ),
      ],
    );
  }
}

class _VerticalFlagPainter extends CustomPainter {
  _VerticalFlagPainter({required this.color, required this.notchHeight});

  final Color color;
  final double notchHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final bodyHeight = size.height - notchHeight;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, bodyHeight)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, bodyHeight)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RibbonFoldPainter extends CustomPainter {
  _RibbonFoldPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
