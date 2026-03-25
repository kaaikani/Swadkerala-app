import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/order/ordercontroller.dart';
import '../../controllers/coupon/coupon_controller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../graphql/cart.graphql.dart';
import '../cached_app_image.dart';

class CheckoutSummarySection extends StatefulWidget {
  final CartController cartController;
  final OrderController orderController;

  const CheckoutSummarySection({
    Key? key,
    required this.cartController,
    required this.orderController,
  }) : super(key: key);

  @override
  State<CheckoutSummarySection> createState() => _CheckoutSummarySectionState();
}

class _CheckoutSummarySectionState extends State<CheckoutSummarySection> {
  late final CouponController couponController;
  late final BannerController bannerController;
  bool _showAllProducts = false;
  bool _showAllSummaryDetails = false;

  @override
  void initState() {
    super.initState();
    couponController = Get.find<CouponController>();
    bannerController = Get.find<BannerController>();
    // Auto-expand if any item is unavailable (isAvailable false, out of stock, or disabled)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cart = widget.cartController.cart.value;
      if (cart != null &&
          cart.lines.any((l) {
            final stock = l.productVariant.stockLevel.toUpperCase();
            return !l.isAvailable || stock == 'OUT_OF_STOCK' || l.productVariant.product.enabled == false;
          })) {
        if (mounted) setState(() => _showAllProducts = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Order',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.rp(12)),
        Obx(() {
          // Observe both cart and coupon products to update UI when coupon is applied
          final cart = widget.cartController.cart.value;
          final _ = couponController.couponAddedProducts; // Observe coupon products
          if (cart == null) return SizedBox.shrink();

          final shippingMethod = widget.orderController.selectedShippingMethod.value;
          final shippingCost = widget.orderController.getShippingPrice(shippingMethod).toDouble();
          final isFreeShipping = widget.cartController.hasFreeShippingCoupon();
          final finalShippingCost = isFreeShipping ? 0.0 : shippingCost;

          // Calculate total discount from all order lines
          final totalDiscount = cart.lines.fold<double>(
            0.0,
            (sum, line) => sum +
                (line.discountedLinePriceWithTax > 0
                    ? (line.linePriceWithTax - line.discountedLinePriceWithTax)
                    : 0.0),
          );

          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Column(
              children: [
                // Cart Items List - Show first 3 or all based on state
                ...(_showAllProducts 
                    ? cart.lines 
                    : cart.lines.take(3))
                    .map((line) => _buildCartItem(line))
                    .toList(),
                
                // Show "Show more" button if there are more than 3 products
                if (cart.lines.length > 3 && !_showAllProducts) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAllProducts = true;
                      });
                    },
                    icon: Icon(
                      Icons.expand_more,
                      size: ResponsiveUtils.rp(20),
                      color: AppColors.button,
                    ),
                    label: Text(
                      'Show ${cart.lines.length - 3} more items',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.button,
                      ),
                    ),
                  ),
                ],
                
                // Show "Show less" button if all products are shown
                if (cart.lines.length > 3 && _showAllProducts) ...[
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAllProducts = false;
                      });
                    },
                    icon: Icon(
                      Icons.expand_less,
                      size: ResponsiveUtils.rp(20),
                      color: AppColors.button,
                    ),
                    label: Text(
                      'Show less',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.button,
                      ),
                    ),
                  ),
                ],
                
                Divider(height: ResponsiveUtils.rp(32), color: AppColors.divider),

                // Summary Totals - Collapsible
                if (_showAllSummaryDetails) ...[
                  // Show all details when expanded
                  _buildSummaryRow('Subtotal', cart.subTotalWithTax),
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  _buildSummaryRow(
                    'Shipping',
                    finalShippingCost,
                    isFree: isFreeShipping,
                  ),
                  if (totalDiscount > 0) ...[
                    SizedBox(height: ResponsiveUtils.rp(8)),
                    _buildSummaryRow(
                      'Discount',
                      -totalDiscount,
                      isDiscount: true,
                    ),
                  ],
                  // Loyalty Points Applied Section
                  Obx(() {
                    if (bannerController.loyaltyPointsApplied.value) {
                      final pointsUsed = bannerController.loyaltyPointsUsed.value;
                      final config = bannerController.loyaltyPointsConfig.value;
                      
                      // Calculate discount from points: divide by pointsPerRupee only
                      double discountAmountInRupees = 0.0;
                      if (config != null && config.pointsPerRupee > 0) {
                        discountAmountInRupees = pointsUsed / config.pointsPerRupee.toDouble();
                      }
                      
                      final discountAmountInCents = (discountAmountInRupees * 100).toInt();
                      
                      return Column(
                        children: [
                          SizedBox(height: ResponsiveUtils.rp(8)),
                          Container(
                            padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                              border: Border.all(
                                color: AppColors.info.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.stars,
                                      color: AppColors.info,
                                      size: ResponsiveUtils.rp(18),
                                    ),
                                    SizedBox(width: ResponsiveUtils.rp(8)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Points Applied',
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(14),
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.info,
                                          ),
                                        ),
                                        SizedBox(height: ResponsiveUtils.rp(4)),
                                        Text(
                                          '$pointsUsed points used',
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(12),
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '- ${widget.cartController.formatPrice(discountAmountInCents)}',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(14),
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveUtils.rp(2)),
                                    Text(
                                      'Discount',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(11),
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),
                  Divider(
                      height: ResponsiveUtils.rp(24), color: AppColors.divider),
                ],
                
                // Total Amount Row with Show More/Less button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildTotalRow(
                        'Total Amount',
                        cart.totalWithTax,
                      ),
                    ),
                    if (!_showAllSummaryDetails)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAllSummaryDetails = true;
                          });
                        },
                        icon: Icon(
                          Icons.expand_more,
                          size: ResponsiveUtils.rp(18),
                          color: AppColors.button,
                        ),
                        label: Text(
                          'Show more',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            fontWeight: FontWeight.w600,
                            color: AppColors.button,
                          ),
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAllSummaryDetails = false;
                          });
                        },
                        icon: Icon(
                          Icons.expand_less,
                          size: ResponsiveUtils.rp(18),
                          color: AppColors.button,
                        ),
                        label: Text(
                          'Show less',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(12),
                            fontWeight: FontWeight.w600,
                            color: AppColors.button,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCartItem(Fragment$Cart$lines line) {
    // Check if product was added via coupon code
    final variantId = line.productVariant.id;
    final isCouponProduct = _isProductAddedByCoupon(variantId);

    // Check if product is unavailable (out of stock or disabled)
    final stockLevel = line.productVariant.stockLevel.toUpperCase();
    final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
    final isProductDisabled = line.productVariant.product.enabled == false;
    final isUnavailable = !line.isAvailable || isOutOfStock || isProductDisabled;
    
    // Check if product is actually free (discounted price is 0 and not a coupon product)
    final isFree = !isCouponProduct && line.discountedLinePriceWithTax == 0;
    // Coupon products or items with a discount show the discounted price
    final isDiscounted = (isCouponProduct && line.discountedLinePriceWithTax < line.linePriceWithTax) ||
                        (!isCouponProduct &&
                        line.discountedLinePriceWithTax < line.linePriceWithTax &&
                        line.discountedLinePriceWithTax > 0);

    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: ResponsiveUtils.rp(60),
            height: ResponsiveUtils.rp(60),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: line.featuredAsset != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedAppImage(
                      imageUrl: line.featuredAsset!.preview,
                      fit: BoxFit.cover,
                      cacheWidth: 120,
                      cacheHeight: 120,
                      errorWidget: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: ResponsiveUtils.rp(20),
                      ),
                    ),
                  )
                : Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.rp(24),
                  ),
          ),
          SizedBox(width: ResponsiveUtils.rp(12)),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productVariant.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isCouponProduct && isDiscounted) ...[
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Builder(builder: (context) {
                    // Find promotion discount % from cart.promotions
                    String discountLabel = 'Coupon applied';
                    final cart = widget.cartController.cart.value;
                    if (cart != null) {
                      final couponCodes = cart.couponCodes;
                      for (final code in couponCodes) {
                        try {
                          final promo = cart.promotions.firstWhere((p) => p.couponCode == code);
                          for (final action in promo.actions) {
                            if (action.code.contains('percentage')) {
                              final discountArg = action.args.firstWhere(
                                (a) => a.name == 'discount',
                                orElse: () => action.args.first,
                              );
                              discountLabel = '${discountArg.value}% off with $code';
                              break;
                            }
                          }
                        } catch (_) {}
                      }
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(6),
                        vertical: ResponsiveUtils.rp(2),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        discountLabel,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(10),
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    );
                  }),
                ] else if (isFree) ...[
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(6),
                      vertical: ResponsiveUtils.rp(2),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FREE GIFT',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(10),
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
                if (isUnavailable) ...[
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(6),
                      vertical: ResponsiveUtils.rp(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Text(
                      'Out of stock - kindly remove from cart',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(11),
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: ResponsiveUtils.rp(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         if (isFree)
                          Text(
                            'FREE',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          )
                        else if (isDiscounted)
                          Row(
                            children: [
                              Text(
                                widget.cartController.formatPrice(line.discountedLinePriceWithTax.toInt()),
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(14),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(width: ResponsiveUtils.rp(4)),
                              Text(
                                widget.cartController.formatPrice(line.linePriceWithTax.toInt()),
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(12),
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            widget.cartController.formatPrice(line.linePriceWithTax.toInt()),
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                      ],
                    ),
                    
                    // Quantity Controls - ALWAYS disabled for coupon products and free products
                    if (isCouponProduct || isFree)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.rp(12),
                          vertical: ResponsiveUtils.rp(6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${line.quantity}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            _buildQtyBtn(
                              icon: Icons.remove,
                              onTap: () {
                                if (line.quantity > 1) {
                                  widget.cartController.decrementVariant(
                                      variantId: line.productVariant.id);
                                }
                              },
                              isDisabled: line.quantity <= 1,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8)),
                              child: Text(
                                '${line.quantity}',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(14),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _buildQtyBtn(
                              icon: Icons.add,
                              onTap: () {
                                widget.cartController.addToCart(
                                    productVariantId: int.parse(line.productVariant.id),
                                    quantity: 1);
                              },
                            ),
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
    );
  }

  Widget _buildQtyBtn({
    required IconData icon, 
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.rp(6)),
        child: Icon(
          icon,
          size: ResponsiveUtils.rp(16),
          color: isDisabled 
              ? AppColors.textTertiary 
              : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {bool isFree = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          isFree
              ? 'FREE'
              : (isDiscount ? '- ' : '') +
                  widget.cartController.formatPrice(amount.abs().toInt()),
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(14),
            fontWeight: FontWeight.w500,
            color: isFree || isDiscount
                ? AppColors.success
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(16),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          widget.cartController.formatPrice(amount.toInt()),
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Check if a product variant was added by any coupon code
  bool _isProductAddedByCoupon(String variantId) {
    // Check all coupon-added products to see if this variant ID is in any map
    for (final couponCode in couponController.couponAddedProducts.keys) {
      final addedProducts = couponController.couponAddedProducts[couponCode];
      if (addedProducts != null && addedProducts.containsKey(variantId)) {
        return true;
      }
    }
    return false;
  }
}
