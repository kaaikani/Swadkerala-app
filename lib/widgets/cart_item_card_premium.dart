import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'responsive_text.dart';
import 'stock_level_label.dart';
import 'responsive_spacing.dart';
import 'responsive_icon.dart';
import 'cached_app_image.dart';

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
  final String? stockLevel;
  final int? maxQuantity;
  final bool hasQuantityLimitViolation;
  final String? quantityLimitReason;
  final bool hasInsufficientStock;
  final String? insufficientStockMessage;

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
    this.stockLevel,
    this.maxQuantity,
    this.hasQuantityLimitViolation = false,
    this.quantityLimitReason,
    this.hasInsufficientStock = false,
    this.insufficientStockMessage,
  }) : super(key: key);

  String _quantityLimitMessage() {
    if (quantityLimitReason != null && quantityLimitReason!.trim().isNotEmpty) {
      final match = RegExp(r'Your cart can only have \d+ of this item\.?')
          .firstMatch(quantityLimitReason!);
      if (match != null) {
        final part = match.group(0)!.trim();
        return part.endsWith('.') ? '$part Kindly decrease quantity.' : '$part. Kindly decrease quantity.';
      }
      return quantityLimitReason!;
    }
    return 'Max $maxQuantity quantity allowed. Decrease quantity to continue.';
  }

  @override
  Widget build(BuildContext context) {
    final canAdjust = !isUnavailable && !isLoading;
    // When line is grey (e.g. isAvailable false), minus button stays normal if user can decrease
    final canDecrease = onDecreaseQuantity != null && quantity > 1;
    final showMinusInNormalColor = canDecrease && isUnavailable && hasInsufficientStock;

    final card = Container(
      padding: ResponsiveSpacing.padding(all: 10),
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
      decoration: BoxDecoration(
        color: null,
        border: hasInsufficientStock
            ? Border(
                left: BorderSide(
                  color: AppColors.warning,
                  width: 3,
                ),
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              )
            : Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
        borderRadius: null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                child: imageUrl != null
                    ? CachedAppImage(
                        imageUrl: imageUrl!,
                        width: ResponsiveUtils.rp(70),
                        height: ResponsiveUtils.rp(70),
                        fit: BoxFit.cover,
                        cacheWidth: 140,
                        cacheHeight: 140,
                        errorWidget: _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              SizedBox(width: ResponsiveUtils.rp(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      productName,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (variantName != null && variantName!.isNotEmpty) ...[
                      SizedBox(height: ResponsiveUtils.rp(3)),
                      ResponsiveText(
                        variantName!,
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: ResponsiveUtils.rp(4)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (stockLevel != null && stockLevel!.isNotEmpty) ...[
                          StockLevelLabel(stockLevel: stockLevel!, compact: true),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                        ],
                        ResponsiveText(
                          unitPrice == 'FREE' ? 'Price: FREE' : 'Unit: $unitPrice',
                          fontSize: 12,
                          color: unitPrice == 'FREE' ? AppColors.success : AppColors.textSecondary,
                          fontWeight: unitPrice == 'FREE' ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Show quantity controls only if at least one button is available
                        if (onIncreaseQuantity != null || onDecreaseQuantity != null)
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
                                  onTap: canDecrease
                                    ? () {
                                        onDecreaseQuantity!();
                                      }
                                    : null,
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ResponsiveUtils.rp(6)),
                                  child: Icon(
                                    Icons.remove,
                                    size: ResponsiveUtils.rp(18),
                                    color: showMinusInNormalColor
                                        ? AppColors.textPrimary
                                        : (!canAdjust || quantity <= 1 || onDecreaseQuantity == null)
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isUnavailable
                                      ? AppColors.textTertiary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              InkWell(
                                onTap: canAdjust && onIncreaseQuantity != null
                                    ? () {
                                        onIncreaseQuantity!();
                                      }
                                    : null,
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ResponsiveUtils.rp(6)),
                                  child: Icon(
                                    Icons.add,
                                    size: ResponsiveUtils.rp(18),
                                    color: !canAdjust
                                        ? AppColors.textTertiary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          )
                        else
                          // Just show quantity text if no controls
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.rp(12),
                              vertical: ResponsiveUtils.rp(6),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                            ),
                            child: ResponsiveText(
                              'Qty: $quantity',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isUnavailable
                                  ? AppColors.textTertiary
                                  : AppColors.textPrimary,
                            ),
                        ),
                        ResponsiveText(
                          totalPrice,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: totalPrice == 'FREE' 
                              ? AppColors.success
                              : (isUnavailable
                              ? AppColors.textSecondary
                                  : AppColors.button),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveUtils.rp(8)),
              if (onRemove != null)
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
          // Show quantity limit violation message (hide when out of stock - show only out of stock)
          if (hasQuantityLimitViolation && maxQuantity != null && (statusMessage == null || statusMessage!.isEmpty)) ...[
            SizedBox(height: ResponsiveUtils.rp(8)),
            Container(
              padding: ResponsiveSpacing.padding(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: ResponsiveUtils.rp(16),
                    color: AppColors.error,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(6)),
                  Expanded(
                    child: ResponsiveText(
                      _quantityLimitMessage(),
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            ),
          ],
          // Show insufficient stock warning (compact row with icon)
          if (hasInsufficientStock && insufficientStockMessage != null) ...[
            SizedBox(height: ResponsiveUtils.rp(8)),
            Container(
              padding: ResponsiveSpacing.padding(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: ResponsiveUtils.rp(16),
                    color: AppColors.warning,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(6)),
                  Expanded(
                    child: ResponsiveText(
                      insufficientStockMessage!,
                      fontSize: 12,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (statusMessage?.isNotEmpty ?? false) ...[
            SizedBox(height: ResponsiveUtils.rp(12)),
            Container(
              padding: ResponsiveSpacing.padding(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isUnavailable 
                    ? AppColors.warning.withValues(alpha: 0.12)
                    : AppColors.info.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isUnavailable ? Icons.warning_amber_rounded : Icons.info_outline,
                    size: ResponsiveUtils.rp(18),
                    color: isUnavailable ? AppColors.warning : AppColors.info,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Expanded(
                    child: ResponsiveText(
                      statusMessage!,
                      fontSize: 12,
                      color: isUnavailable ? AppColors.warning : AppColors.info,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );

    // When only insufficient stock (user can decrease), keep full opacity so minus button stays normal
    final dimCard = isUnavailable && !hasInsufficientStock;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: dimCard ? 0.65 : 1,
      child: card,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: ResponsiveUtils.rp(90),
      height: ResponsiveUtils.rp(90),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
      ),
      child: Icon(
        Icons.image_outlined,
        size: ResponsiveUtils.rp(36),
        color: AppColors.textTertiary,
      ),
    );
  }
}
