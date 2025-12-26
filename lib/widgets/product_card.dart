import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/shimmers.dart';

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
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ResponsiveUtils.rp(10)),
                      topRight: Radius.circular(ResponsiveUtils.rp(10)),
                    ),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            cacheWidth: 500,
                            cacheHeight: 500,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              // Show shimmer while loading
                              return Skeletons.imageRect(
                                height: double.infinity,
                                width: double.infinity,
                                radius: 0,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              // Show shimmer on error instead of empty container
                              return Skeletons.imageRect(
                                height: double.infinity,
                                width: double.infinity,
                                radius: 0,
                              );
                            },
                          )
                        : Skeletons.imageRect(
                            height: double.infinity,
                            width: double.infinity,
                            radius: 0,
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
                      onPressed: onAddToCart ?? () async => false,
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
                  Flexible(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
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
                  ] else
                    Padding(
                      padding: EdgeInsets.only(top: ResponsiveUtils.rp(1)),
                      child: Text(
                        variantLabel,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
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
                                  fontSize: ResponsiveUtils.sp(15),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (shadowPriceText != null) ...[
                              SizedBox(width: ResponsiveUtils.rp(4)),
                              Flexible(
                                child: Text(
                                  shadowPriceText!,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(11),
                                    color: AppColors.textSecondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
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
  const _AddToCartButton({required this.onPressed});

  final Future<bool> Function() onPressed;

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
    
    // Determine colors and icon based on state
    Color buttonColor1;
    Color buttonColor2;
    Widget iconWidget;
    
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
        buttonColor1 = Colors.green.shade400;
        buttonColor2 = Colors.green.shade600;
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
                onTap: _handleTap,
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
                            ? Colors.green 
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


