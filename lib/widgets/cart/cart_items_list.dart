import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../widgets/cart_item_card_premium.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/analytics_helper.dart';

class CartItemsList extends StatefulWidget {
  final dynamic cart;
  final CartController cartController;
  final UtilityController utilityController;
  final Function(String, int) onQuantityChange;
  final Function(String, String) onRemoveItem;
  final ScrollController scrollController;
  final String? removingItemId;
  final bool isClearingCart;
  final Set<String> adjustingOrderLineIds;
  /// When true, auto-expand to show all items (used when any item has isAvailable false)
  final bool expandIfHasUnavailableItems;

  const CartItemsList({
    super.key,
    required this.cart,
    required this.cartController,
    required this.utilityController,
    required this.onQuantityChange,
    required this.onRemoveItem,
    required this.scrollController,
    this.removingItemId,
    this.isClearingCart = false,
    required this.adjustingOrderLineIds,
    this.expandIfHasUnavailableItems = false,
  });

  @override
  State<CartItemsList> createState() => _CartItemsListState();
}

class _CartItemsListState extends State<CartItemsList> {
  bool _showAllItems = false;

  Widget _wrapItemCard({
    required BuildContext context,
    required bool isRemoving,
    required bool isFadingOut,
    required Widget child,
  }) {
    return AnimatedOpacity(
      opacity: isRemoving || isFadingOut ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isRemoving
            ? Matrix4.translationValues(MediaQuery.of(context).size.width, 0, 0)
            : Matrix4.identity(),
        margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }

  void expandList() {
    if (!_showAllItems) {
      setState(() {
        _showAllItems = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.expandIfHasUnavailableItems) {
      _showAllItems = true;
    }
  }

  @override
  void didUpdateWidget(CartItemsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expandIfHasUnavailableItems && !_showAllItems) {
      setState(() {
        _showAllItems = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = widget.cartController.cart.value;
      if (cart == null || cart.lines.isEmpty) {
        return const SizedBox.shrink();
      }
      
      // Separate coupon products from regular products
      final bannerController = Get.find<BannerController>();
      // Access reactive map to ensure UI updates when coupon tracking changes
      final _ = bannerController.couponAddedProducts;
      final regularProducts = <Map<String, dynamic>>[];
      final couponProducts = <Map<String, dynamic>>[];
      
      for (final line in cart.lines) {
        final variant = line.productVariant;
        final couponCode = bannerController.isCouponAddedProduct(variant.id);
        
        // Check if this product was actually added by a coupon (not just if it exists in map)
        if (couponCode != null) {
          // This product has coupon-added quantity
          final couponAddedQty = bannerController.getCouponAddedQuantity(variant.id, couponCode);
          // ignore: unused_local_variable
          final _originalQty = bannerController.getOriginalQuantity(variant.id, couponCode);
          
          
          // Only split display if there's actually coupon-added quantity > 0
          if (couponAddedQty > 0 && couponAddedQty <= line.quantity) {
            // Calculate regular quantity as: current total - coupon-added quantity
            // This ensures we always show the correct split even if user modified quantities after coupon was applied
            final regularQty = line.quantity - couponAddedQty;
            
            
            // If there's a regular quantity (after subtracting coupon quantity), show it as regular product
            if (regularQty > 0) {
              // Create a virtual line item for the regular quantity (paid product)
              regularProducts.add({
                'line': line,
                'displayQuantity': regularQty, // Use calculated regular quantity, not original
                'isVirtual': true, // Flag to indicate this is a split display
              });
            }
            
            // Show coupon-added quantity as separate FREE item
            couponProducts.add({
              'line': line,
              'displayQuantity': couponAddedQty,
              'couponCode': couponCode,
              'isVirtual': true,
            });
          } else {
            // Product is in couponAddedProducts map but:
            // - couponAddedQty is 0, OR
            // - couponAddedQty > line.quantity (shouldn't happen, but handle it)
            // This means the product wasn't actually added by the coupon or there's a mismatch
            // Show as regular product with full quantity
            regularProducts.add({
              'line': line,
              'displayQuantity': line.quantity,
              'isVirtual': false,
            });
          }
        } else {
          // Regular product, no coupon involvement - show full quantity
          regularProducts.add({
            'line': line,
            'displayQuantity': line.quantity,
            'isVirtual': false,
          });
        }
      }
      
      // Combine coupon products (shown first) with regular products
      final allProducts = <Map<String, dynamic>>[
        ...couponProducts, // Coupon products shown at top
        ...regularProducts, // Regular products shown below
      ];

      final totalItems = allProducts.length;
      final itemsToShow = _showAllItems 
          ? allProducts 
          : allProducts.take(3).toList();
      final hasMoreItems = totalItems > 3;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combined Items Section (coupon products first, then regular)
          if (allProducts.isNotEmpty) ...[

            ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: ResponsiveUtils.rp(8),
          bottom: ResponsiveUtils.rp(12),
        ),
        itemCount: itemsToShow.length + 
            (hasMoreItems && !_showAllItems ? 1 : 0) +
            (hasMoreItems && _showAllItems ? 1 : 0),
        itemBuilder: (context, index) {
          // Show "Show More" button after first 3 items
          if (hasMoreItems && !_showAllItems && index == 3) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
              child: Center(
                child: TextButton.icon(
                  onPressed: AnalyticsHelper.trackButton(
                    'Show More Items',
                    screenName: 'Cart',
                    callback: () {
                      setState(() {
                        _showAllItems = true;
                      });
                    },
                  ),
                  icon: Icon(
                    Icons.expand_more,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(20),
                  ),
                  label: Text(
                          'Show ${totalItems - 3} more items',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.button,
                    ),
                  ),
                ),
              ),
            );
          }

          // Show "Show Less" button if all items are shown
                if (_showAllItems && hasMoreItems && index == totalItems) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
              child: Center(
                child: TextButton.icon(
                  onPressed: AnalyticsHelper.trackButton(
                    'Show Less Items',
                    screenName: 'Cart',
                    callback: () {
                      setState(() {
                        _showAllItems = false;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (widget.scrollController.hasClients) {
                          widget.scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    },
                  ),
                  icon: Icon(
                    Icons.expand_less,
                    color: AppColors.button,
                    size: ResponsiveUtils.rp(20),
                  ),
                  label: Text(
                    'Show less',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.button,
                    ),
                  ),
                ),
              ),
            );
          }

                final itemData = itemsToShow[index];
                
                // Check if this is a coupon product (has couponCode in itemData)
                final isCouponProduct = itemData.containsKey('couponCode');
                final couponCode = itemData['couponCode'] as String?;
                
                final line = itemData['line'] as dynamic;
                final displayQuantity = itemData['displayQuantity'] as int;
                final isVirtual = itemData['isVirtual'] as bool? ?? false;
                
          final variant = line.productVariant;
          final imageUrl = line.featuredAsset?.preview;
          final isLoading = widget.adjustingOrderLineIds.contains(line.id);
          
          // Check for quantity limit violations for this line
          final cart = widget.cartController.cart.value;
          int? maxQuantityForLine;
          bool hasQuantityLimitViolationForLine = false;
          String? quantityLimitReasonForLine;
          if (cart != null && cart.quantityLimitStatus.hasViolations) {
            try {
              final violation = cart.quantityLimitStatus.violations.firstWhere(
                (v) => v.orderLineId == line.id,
              );
              maxQuantityForLine = violation.maxQuantity;
              hasQuantityLimitViolationForLine = true;
              quantityLimitReasonForLine = violation.reason;
            } catch (e) {
              // No violation found for this line
            }
          }
          
          final stockLevelRaw = variant.stockLevel.trim();
          final stockLevel = stockLevelRaw.toUpperCase();
          final isOutOfStock = stockLevel == 'OUT_OF_STOCK';

          final isProductDisabled = variant.product.enabled == false;
          final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true;
          final isProductDisabledAny = isProductDisabled || isDisabledByReason;

          // Parse numeric stock level (Vendure may return "2", "10", etc.; trim so " 2 " parses)
          final numericStock = int.tryParse(stockLevelRaw);

          // Detect insufficient stock (user can fix by decreasing qty):
          // Exclude "out of stock" / "no longer available" - those require removal, not quantity decrease
          final reason = line.unavailableReason?.toLowerCase() ?? '';
          final isMustRemoveNotDecrease = reason.contains('no longer available') ||
              reason.contains('out of stock') ||
              reason.contains('currently out of stock');
          final hasInsufficientStock = (numericStock != null && numericStock > 0 && line.quantity > numericStock) ||
              (!line.isAvailable && !isOutOfStock && !isProductDisabledAny && !isMustRemoveNotDecrease);

          // Build the insufficient stock message with actual numbers when available
          String? insufficientStockMessage;
          if (hasInsufficientStock) {
            // First try the line's own unavailableReason from the backend (e.g. "Only 10 available, but 20 requested")
            final lineReason = line.unavailableReason;
            if (lineReason != null && lineReason.toString().isNotEmpty && !lineReason.toString().toLowerCase().contains('disabled')) {
              insufficientStockMessage = '$lineReason - to checkout';
            } else if (numericStock != null && line.quantity > numericStock) {
              insufficientStockMessage = 'Only $numericStock in stock - $numericStock to checkout';
            } else {
              // Try to get reason from validationStatus
              if (cart != null && cart.validationStatus.hasUnavailableItems) {
                try {
                  final unavailableItem = cart.validationStatus.unavailableItems.firstWhere(
                    (item) => item.orderLineId == line.id,
                  );
                  insufficientStockMessage = unavailableItem.reason;
                } catch (_) {}
              }
              insufficientStockMessage ??= 'Insufficient stock - Please decrease quantity to checkout';
            }
          }

          // Grey/disabled when: OUT_OF_STOCK, product disabled, or isAvailable false (e.g. "This variant is no longer available")
          final isUnavailable = isOutOfStock || isProductDisabledAny || !line.isAvailable;

          String statusMessage;
          if (hasInsufficientStock) {
            // "Only X available, kindly decrease quantity" - show insufficient stock banner only, not "remove from cart"
            statusMessage = '';
          } else if (isOutOfStock || isProductDisabledAny) {
            statusMessage = 'OUT OF STOCK - Please remove from cart';
          } else if (!line.isAvailable) {
            statusMessage = 'OUT OF STOCK - Please remove from cart';
          } else {
            statusMessage = '';
          }

          final isRemoving = widget.removingItemId == line.id;
          final isFadingOut = widget.isClearingCart;

                // Handle coupon products differently (shown first at top)
                if (isCouponProduct && couponCode != null) {
                  // Original price from variant catalog price × quantity
                  final originalUnitPrice = variant.price.toInt();
                  final originalLinePrice = originalUnitPrice * displayQuantity;
                  // Discounted price (after coupon applied)
                  final discountedLinePrice = (line.discountedLinePriceWithTax / line.quantity * displayQuantity).toInt();
                  // Find the promotion's discount % from cart.promotions by matching couponCode
                  String couponLabel = 'Coupon: $couponCode';
                  final cartData = widget.cartController.cart.value;
                  if (cartData != null) {
                    try {
                      final promo = cartData.promotions.firstWhere(
                        (p) => p.couponCode == couponCode,
                      );
                      for (final action in promo.actions) {
                        if (action.code.contains('percentage')) {
                          final discountArg = action.args.firstWhere(
                            (a) => a.name == 'discount',
                            orElse: () => action.args.first,
                          );
                          couponLabel = 'Coupon: $couponCode (${discountArg.value}% off)';
                          break;
                        }
                      }
                    } catch (_) {}
                  }
                  return _wrapItemCard(
                    context: context,
                    isRemoving: isRemoving,
                    isFadingOut: isFadingOut,
                    child: CartItemCardPremium(
                      imageUrl: imageUrl,
                      productName: variant.name,
                      variantName: couponLabel,
                      stockLevel: line.isAvailable ? variant.stockLevel : null,
                      unitPrice: widget.cartController.formatPrice(originalUnitPrice),
                      totalPrice: widget.cartController.formatPrice(discountedLinePrice),
                      originalPrice: null,
                      quantity: displayQuantity,
                      onIncreaseQuantity: null,
                      onDecreaseQuantity: null,
                      onRemove: null,
                      isLoading: isLoading,
                      isUnavailable: isUnavailable,
                      statusMessage: isUnavailable ? statusMessage : '',
                      maxQuantity: maxQuantityForLine,
                      hasQuantityLimitViolation: hasQuantityLimitViolationForLine,
                      quantityLimitReason: quantityLimitReasonForLine,
                    ),
                  );
                }

                // Regular products (including virtual split items)
                // For virtual items (split display), calculate price proportionally
                final unitPriceInt = line.unitPriceWithTax.toInt();
                // unitPriceInt is already in smallest currency unit (paise), so multiply by displayQuantity
                final linePriceForDisplay = isVirtual 
                    ? (unitPriceInt * displayQuantity)  // Proportional price for virtual split items
                    : line.linePriceWithTax.toInt();

          return _wrapItemCard(
            context: context,
            isRemoving: isRemoving,
            isFadingOut: isFadingOut,
            child: CartItemCardPremium(
              imageUrl: imageUrl,
              productName: variant.name,
              variantName: isVirtual ? '(Regular quantity)' : null,
              stockLevel: line.isAvailable ? variant.stockLevel : null,
              unitPrice: widget.cartController.formatPrice(unitPriceInt),
              totalPrice: widget.cartController.formatPrice(linePriceForDisplay),
              quantity: displayQuantity,
              hasInsufficientStock: hasInsufficientStock,
              insufficientStockMessage: insufficientStockMessage,
              onIncreaseQuantity: !isUnavailable && !hasQuantityLimitViolationForLine && !hasInsufficientStock
                  ? () => widget.onQuantityChange(line.id, line.quantity + 1)
                  : null,
              onDecreaseQuantity: displayQuantity > 1 && (!isUnavailable || hasInsufficientStock)
                  ? () {
                      if (displayQuantity <= 1) return;
                      if (isVirtual) {
                        final couponCodeForProduct = bannerController.isCouponAddedProduct(variant.id);
                        if (couponCodeForProduct != null) {
                          final couponQty = bannerController.getCouponAddedQuantity(variant.id, couponCodeForProduct);
                          final newTotal = line.quantity - 1;
                          if (newTotal > couponQty) widget.onQuantityChange(line.id, newTotal);
                        } else if (displayQuantity > 1) {
                          widget.onQuantityChange(line.id, line.quantity - 1);
                        }
                      } else if (displayQuantity > 1) {
                        widget.onQuantityChange(line.id, line.quantity - 1);
                      }
                    }
                  : null,
              onRemove: !isVirtual ? () => widget.onRemoveItem(line.id, variant.name) : null,
              isLoading: isLoading,
              isUnavailable: isUnavailable,
              statusMessage: isVirtual ? '' : (isUnavailable ? statusMessage : null),
              maxQuantity: maxQuantityForLine,
              hasQuantityLimitViolation: hasQuantityLimitViolationForLine,
              quantityLimitReason: quantityLimitReasonForLine,
            ),
          );
        },
            ),
          ],
        ],
      );
    });
  }
}

