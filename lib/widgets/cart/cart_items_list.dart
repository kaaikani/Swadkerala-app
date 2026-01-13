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
  });

  @override
  State<CartItemsList> createState() => _CartItemsListState();
}

class _CartItemsListState extends State<CartItemsList> {
  bool _showAllItems = false;

  void expandList() {
    if (!_showAllItems) {
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
          final originalQty = bannerController.getOriginalQuantity(variant.id, couponCode);
          
          debugPrint('[CartItemsList] Variant ${variant.id}: Total=${line.quantity}, Original=$originalQty, CouponAdded=$couponAddedQty');
          
          // Only split display if there's actually coupon-added quantity > 0
          if (couponAddedQty > 0 && couponAddedQty <= line.quantity) {
            // Calculate regular quantity as: current total - coupon-added quantity
            // This ensures we always show the correct split even if user modified quantities after coupon was applied
            final regularQty = line.quantity - couponAddedQty;
            
            debugPrint('[CartItemsList] Variant ${variant.id}: RegularQty=$regularQty (Total=${line.quantity} - Coupon=$couponAddedQty)');
            
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
            debugPrint('[CartItemsList] Warning: Variant ${variant.id} in coupon map but not splitting. Total=${line.quantity}, CouponAdded=$couponAddedQty. Showing as regular product.');
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
        padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
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
          
          final stockLevel = variant.stockLevel.toUpperCase();
          final isLowStock = stockLevel == 'LOW_STOCK';
          final isOutOfStock = stockLevel == 'OUT_OF_STOCK';
          final isStockUnavailable = isLowStock || isOutOfStock;
          
          final isProductDisabled = variant.product.enabled == false;
          final isDisabledByReason = line.unavailableReason?.toLowerCase().contains('disabled') == true;
          final isProductDisabledAny = isProductDisabled || isDisabledByReason;
          
          final isUnavailable = !line.isAvailable || isStockUnavailable || isProductDisabledAny;
          
          String statusMessage;
          if (isStockUnavailable || isProductDisabledAny) {
            statusMessage = 'OUT OF STOCK - Please remove from cart';
          } else if (line.unavailableReason?.isNotEmpty == true) {
            statusMessage = 'OUT OF STOCK - Please remove from cart';
          } else {
            statusMessage = 'OUT OF STOCK - Please remove from cart';
          }

          final isRemoving = widget.removingItemId == line.id;
          final isFadingOut = widget.isClearingCart;

                // Handle coupon products differently (shown first at top)
                if (isCouponProduct && couponCode != null) {
                  return AnimatedOpacity(
                    opacity: isRemoving || isFadingOut ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      transform: isRemoving
                          ? Matrix4.translationValues(
                              MediaQuery.of(context).size.width, 0, 0)
                          : Matrix4.identity(),
                      child: CartItemCardPremium(
                        imageUrl: imageUrl,
                        productName: variant.name,
                        variantName: 'Included with coupon: $couponCode',
                        unitPrice: 'FREE',
                        totalPrice: 'FREE',
                        quantity: displayQuantity,
                        onIncreaseQuantity: null, // No quantity controls for coupon products
                        onDecreaseQuantity: null, // No quantity controls for coupon products
                        onRemove: null, // Cannot delete coupon products
                        isLoading: isLoading,
                        isUnavailable: isUnavailable,
                        statusMessage: '',
                      ),
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

          return AnimatedOpacity(
            opacity: isRemoving || isFadingOut ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: isRemoving
                  ? Matrix4.translationValues(
                      MediaQuery.of(context).size.width, 0, 0)
                  : Matrix4.identity(),
              child: CartItemCardPremium(
                imageUrl: imageUrl,
                productName: variant.name,
                      variantName: isVirtual ? '(Regular quantity)' : null,
                unitPrice: widget.cartController.formatPrice(unitPriceInt),
                      totalPrice: widget.cartController.formatPrice(linePriceForDisplay),
                      quantity: displayQuantity,
                      // Allow quantity changes even for virtual (split) items
                      // This will update the total quantity, and the display will automatically adjust
                      // because we calculate regularQty = line.quantity - couponAddedQty
                      onIncreaseQuantity: !isUnavailable
                          ? () {
                              // Increase total quantity (which includes both regular and coupon quantities)
                              widget.onQuantityChange(line.id, line.quantity + 1);
                            }
                          : null,
                      onDecreaseQuantity: !isUnavailable && displayQuantity > 1
                          ? () {
                              // Double-check: prevent decreasing if displayQuantity is 1 or less
                              if (displayQuantity <= 1) {
                                debugPrint('[CartItemsList] Prevented decrease: displayQuantity is $displayQuantity (minimum is 1)');
                                return;
                              }
                              
                              // For virtual items (split display), check if we can decrease without going below coupon quantity
                              if (isVirtual) {
                                final couponCodeForProduct = bannerController.isCouponAddedProduct(variant.id);
                                if (couponCodeForProduct != null) {
                                  final couponQty = bannerController.getCouponAddedQuantity(variant.id, couponCodeForProduct);
                                  final newTotal = line.quantity - 1;
                                  // Only decrease if new total is greater than coupon quantity (so regular quantity stays > 0)
                                  // newTotal > couponQty ensures regularQty = newTotal - couponQty > 0
                                  if (newTotal > couponQty) {
                                    widget.onQuantityChange(line.id, newTotal);
                                  } else {
                                    debugPrint('[CartItemsList] Prevented decrease: newTotal ($newTotal) would be <= couponQty ($couponQty)');
                                  }
                                } else {
                                  // Fallback: allow decrease only if displayQuantity > 1
                                  if (displayQuantity > 1) {
                                    widget.onQuantityChange(line.id, line.quantity - 1);
                                  }
                                }
                              } else {
                                // Regular non-virtual item: decrease normally only if displayQuantity > 1
                                if (displayQuantity > 1) {
                                  widget.onQuantityChange(line.id, line.quantity - 1);
                                }
                              }
                            }
                          : null,
                      onRemove: !isVirtual
                          ? () => widget.onRemoveItem(line.id, variant.name)
                          : null,
                isLoading: isLoading,
                isUnavailable: isUnavailable,
                      statusMessage: isVirtual 
                          ? ''
                          : (isUnavailable ? statusMessage : null),
              ),
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

