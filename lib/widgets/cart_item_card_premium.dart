import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
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

    final card = Container(
      padding: ResponsiveSpacing.padding(all: 10),
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
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
                    ? Image.network(
                        imageUrl!,
                        width: ResponsiveUtils.rp(70),
                        height: ResponsiveUtils.rp(70),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
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
                    ResponsiveText(
                      unitPrice == 'FREE' ? 'Price: FREE' : 'Unit: $unitPrice',
                      fontSize: 12,
                      color: unitPrice == 'FREE' ? AppColors.success : AppColors.textSecondary,
                      fontWeight: unitPrice == 'FREE' ? FontWeight.w600 : FontWeight.normal,
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
                                  onTap: canAdjust && onDecreaseQuantity != null && quantity > 1
                                      ? () {
                                          debugPrint('[CartItemCard] Decrease quantity tapped - current quantity: $quantity');
                                          onDecreaseQuantity!();
                                        }
                                      : null,
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(ResponsiveUtils.rp(6)),
                                    child: Icon(
                                      Icons.remove,
                                      size: ResponsiveUtils.rp(18),
                                      color: (!canAdjust || quantity <= 1 || onDecreaseQuantity == null)
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
                                          debugPrint('[CartItemCard] Increase quantity tapped - current quantity: $quantity');
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

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isUnavailable ? 0.65 : 1,
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
