import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'premium_card.dart';
import 'responsive_text.dart';
import 'responsive_spacing.dart';
import 'responsive_icon.dart';

/// Premium cart item card like Amazon/Flipkart
class CartItemCardPremium extends StatelessWidget {
  final String? imageUrl;
  final String productName;
  final String? variantName;
  final String unitPrice;
  final String totalPrice;
  final int quantity;
  final VoidCallback? onIncreaseQuantity;
  final VoidCallback? onDecreaseQuantity;
  final VoidCallback? onRemove;
  final bool isLoading;
  final bool isUnavailable;
  final String? statusMessage;

  const CartItemCardPremium({
    Key? key,
    this.imageUrl,
    required this.productName,
    this.variantName,
    required this.unitPrice,
    required this.totalPrice,
    required this.quantity,
    this.onIncreaseQuantity,
    this.onDecreaseQuantity,
    this.onRemove,
    this.isLoading = false,
    this.isUnavailable = false,
    this.statusMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canAdjust = !isUnavailable && !isLoading;

    final card = PremiumCard(
      padding: ResponsiveSpacing.padding(all: 12),
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        width: ResponsiveUtils.rp(100),
                        height: ResponsiveUtils.rp(100),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              ResponsiveSpacing.horizontal(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      productName,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (variantName != null && variantName!.isNotEmpty) ...[
                      ResponsiveSpacing.vertical(4),
                      ResponsiveText(
                        variantName!,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    ResponsiveSpacing.vertical(8),
                    ResponsiveText(
                      'Unit: $unitPrice',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    ResponsiveSpacing.vertical(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius:
                                BorderRadius.circular(ResponsiveUtils.rp(8)),
                            color: isUnavailable
                                ? AppColors.borderLight.withValues(alpha: 0.25)
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: canAdjust ? onDecreaseQuantity : null,
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ResponsiveUtils.rp(6)),
                                  child: Icon(
                                    Icons.remove,
                                    size: ResponsiveUtils.rp(16),
                                    color: !canAdjust || quantity <= 1
                                        ? AppColors.textTertiary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.rp(12),
                                  vertical: ResponsiveUtils.rp(6),
                                ),
                                child: ResponsiveText(
                                  '$quantity',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isUnavailable
                                      ? AppColors.textTertiary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              InkWell(
                                onTap: canAdjust ? onIncreaseQuantity : null,
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ResponsiveUtils.rp(6)),
                                  child: Icon(
                                    Icons.add,
                                    size: ResponsiveUtils.rp(16),
                                    color: !canAdjust
                                        ? AppColors.textTertiary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ResponsiveText(
                          totalPrice,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnavailable
                              ? AppColors.textSecondary
                              : AppColors.button,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ResponsiveSpacing.horizontal(8),
              InkWell(
                onTap: isLoading ? null : onRemove,
                child: ResponsiveIcon(
                  Icons.delete_outline,
                  size: 22,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          if (isUnavailable && (statusMessage?.isNotEmpty ?? false)) ...[
            ResponsiveSpacing.vertical(12),
            Container(
              padding: ResponsiveSpacing.padding(all: 10),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: ResponsiveUtils.rp(18),
                    color: AppColors.warning,
                  ),
                  ResponsiveSpacing.horizontal(8),
                  Expanded(
                    child: ResponsiveText(
                      statusMessage!,
                      fontSize: 12,
                      color: AppColors.warning,
                      maxLines: 4,
                    ),
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isUnavailable ? 0.65 : 1,
      child: card,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: ResponsiveUtils.rp(100),
      height: ResponsiveUtils.rp(100),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
      ),
      child: Icon(
        Icons.image_outlined,
        size: ResponsiveUtils.rp(40),
        color: AppColors.textTertiary,
      ),
    );
  }
}
