import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart/Cartcontroller.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';
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
      
      final itemsToShow = _showAllItems 
          ? cart.lines 
          : cart.lines.take(3).toList();
      final hasMoreItems = cart.lines.length > 3;

      return ListView.builder(
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
                    'Show ${cart.lines.length - 3} more items',
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
          if (_showAllItems && hasMoreItems && index == cart.lines.length) {
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

          final line = itemsToShow[index];
          final variant = line.productVariant;
          final imageUrl = line.featuredAsset?.preview;
          final unitPriceInt = line.unitPriceWithTax.toInt();
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
                variantName: null,
                unitPrice: widget.cartController.formatPrice(unitPriceInt),
                totalPrice: widget.cartController
                    .formatPrice(line.linePriceWithTax.toInt()),
                quantity: line.quantity,
                onIncreaseQuantity: isUnavailable
                    ? null
                    : () => widget.onQuantityChange(line.id, line.quantity + 1),
                onDecreaseQuantity: isUnavailable
                    ? null
                    : () => widget.onQuantityChange(line.id, line.quantity - 1),
                onRemove: () => widget.onRemoveItem(line.id, variant.name),
                isLoading: isLoading,
                isUnavailable: isUnavailable,
                statusMessage: isUnavailable ? statusMessage : null,
              ),
            ),
          );
        },
      );
    });
  }
}

