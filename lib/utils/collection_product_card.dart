import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/responsive.dart';

class CollectionProductCard extends StatelessWidget {
  const CollectionProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
    required this.onDoubleTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.discountPercent,
    required this.variantSelector,
    required this.showVariantSelector,
    required this.variantLabel,
    required this.priceText,
    required this.shadowPriceText,
    required this.quantity,
    required this.counterBuilder,
    required this.onAddToCart,
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
  final int quantity;
  final Widget Function() counterBuilder;
  final VoidCallback onAddToCart;

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
                  ClipPath(
                    clipper: InnerRightCurveClipper(
                      cornerRadius: ResponsiveUtils.rp(10),
                      cutoutRadius: ResponsiveUtils.rp(28),
                    ),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            cacheWidth: 500,
                            cacheHeight: 500,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image,
                              size: ResponsiveUtils.rp(30),
                              color: Colors.grey[400],
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
                          size: ResponsiveUtils.rp(16),
                        ),
                      ),
                    ),
                  ),
                  if (discountPercent != null)
                    _DiscountRibbon(discountPercent: discountPercent!),
                  if (quantity == 0)
                    Positioned(
                      bottom: -ResponsiveUtils.rp(14),
                      right: -ResponsiveUtils.rp(8),
                      child: _AddToCartButton(onPressed: onAddToCart),
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
                  Text(
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
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  if (showVariantSelector && variantSelector != null) ...[
                    variantSelector!,
                    SizedBox(height: ResponsiveUtils.rp(4)),
                  ] else
                    Padding(
                      padding: EdgeInsets.only(top: ResponsiveUtils.rp(2)),
                      child: Text(
                        variantLabel,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  SizedBox(height: ResponsiveUtils.rp(6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              priceText,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(15),
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (shadowPriceText != null) ...[
                              SizedBox(width: ResponsiveUtils.rp(6)),
                              Text(
                                shadowPriceText!,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(12),
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: quantity > 0
                              ? counterBuilder()
                              : SizedBox(height: ResponsiveUtils.rp(36)),
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

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = ResponsiveUtils.rp(42);
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          height: resolvedSize,
          width: resolvedSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8A5C), Color(0xFFFF3D6E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: ResponsiveUtils.rp(10),
                offset: Offset(0, ResponsiveUtils.rp(4)),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: resolvedSize * 0.45,
            ),
          ),
        ),
      ),
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
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7B9D), Color(0xFFFF3D6E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF3D6E), Color(0xFFE62857)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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

class InnerRightCurveClipper extends CustomClipper<Path> {
  InnerRightCurveClipper({
    required this.cornerRadius,
    required this.cutoutRadius,
  });

  final double cornerRadius;
  final double cutoutRadius;

  @override
  Path getClip(Size size) {
    final r = cornerRadius.clamp(0, size.height / 2).toDouble();
    final cutout = cutoutRadius.clamp(0, size.width).toDouble();
    final path = Path();

    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);
    path.lineTo(size.width, size.height - cutout);
    path.arcToPoint(
      Offset(size.width - cutout, size.height),
      radius: Radius.circular(cutout),
      clockwise: false,
    );
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
