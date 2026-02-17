import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'cached_app_image.dart';
import 'premium_card.dart';
import 'responsive_text.dart';
import 'responsive_spacing.dart';

/// Premium category card with icon/image
class CategoryCardPremium extends StatelessWidget {
  final String? imageUrl;
  final IconData? icon;
  final String title;
  final Color? iconColor;
  final Color? cardColor;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const CategoryCardPremium({
    Key? key,
    this.imageUrl,
    this.icon,
    required this.title,
    this.iconColor,
    this.cardColor,
    this.onTap,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
      gradient: gradient,
      backgroundColor:
          gradient == null ? (cardColor ?? AppColors.surface) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon/Image Container
          Container(
            width: ResponsiveUtils.rp(56),
            height: ResponsiveUtils.rp(56),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              shape: BoxShape.circle,
            ),
            child: imageUrl != null
                ? ClipOval(
                    child: CachedAppImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      cacheWidth: 112,
                      cacheHeight: 112,
                      errorWidget: Icon(
                        icon ?? Icons.category,
                        size: ResponsiveUtils.rp(28),
                        color: iconColor ?? AppColors.button,
                      ),
                    ),
                  )
                : Icon(
                    icon ?? Icons.category,
                    size: ResponsiveUtils.rp(28),
                    color: iconColor ?? AppColors.button,
                  ),
          ),
          ResponsiveSpacing.vertical(8),
          // Title
          ResponsiveText(
            title,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
