import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'cached_app_image.dart';
import '../utils/responsive.dart';
import 'premium_card.dart';
import 'responsive_text.dart';
import 'responsive_spacing.dart';

/// Premium product card like Amazon/Swiggy
class ProductCardPremium extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final String? price;
  final String? originalPrice;
  final String? discount;
  final VoidCallback? onTap;
  final Widget? badge;
  final bool showWishlist;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;
  final double? imageHeight;

  const ProductCardPremium({
    Key? key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.price,
    this.originalPrice,
    this.discount,
    this.onTap,
    this.badge,
    this.showWishlist = true,
    this.isWishlisted = false,
    this.onWishlistTap,
    this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      margin: EdgeInsets.only(right: ResponsiveUtils.rp(12)),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Section with Badge
          Stack(
            children: [
              Container(
                height: imageHeight ?? ResponsiveUtils.rp(140),
                width: double.infinity,
                color: Color(0xFFF6F6F6),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ResponsiveUtils.rp(16)),
                    topRight: Radius.circular(ResponsiveUtils.rp(16)),
                  ),
                  child: imageUrl != null
                      ? CachedAppImage(
                          imageUrl: imageUrl!,
                          height: imageHeight ?? ResponsiveUtils.rp(140),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          cacheWidth: 400,
                          cacheHeight: 280,
                          errorWidget: _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              // Badge
              if (badge != null)
                Positioned(
                  top: ResponsiveUtils.rp(8),
                  left: ResponsiveUtils.rp(8),
                  child: badge!,
                ),
              // Wishlist Button
              if (showWishlist)
                Positioned(
                  top: ResponsiveUtils.rp(8),
                  right: ResponsiveUtils.rp(8),
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(6)),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: ResponsiveUtils.rp(4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: ResponsiveUtils.rp(18),
                        color: isWishlisted
                            ? AppColors.button
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              // Discount Badge
              if (discount != null)
                Positioned(
                  bottom: ResponsiveUtils.rp(8),
                  left: ResponsiveUtils.rp(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(4),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.error,
                          AppColors.error.withValues(alpha: 0.8)
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(6)),
                    ),
                    child: ResponsiveText(
                      discount!,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
            ],
          ),
          // Content Section
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                ResponsiveText(
                  title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  ResponsiveSpacing.vertical(4),
                  ResponsiveText(
                    subtitle!,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                ResponsiveSpacing.vertical(8),
                // Price Section
                if (price != null)
                  Row(
                    children: [
                      ResponsiveText(
                        price!,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.button,
                      ),
                      if (originalPrice != null) ...[
                        ResponsiveSpacing.horizontal(8),
                        ResponsiveText(
                          originalPrice!,
                          fontSize: 12,
                          color: AppColors.textTertiary,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: imageHeight ?? ResponsiveUtils.rp(140),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.grey100,
            AppColors.grey200,
          ],
        ),
      ),
      child: Icon(
        Icons.image,
        size: ResponsiveUtils.rp(40),
        color: AppColors.textTertiary,
      ),
    );
  }
}
