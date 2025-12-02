import 'package:get/get.dart';
import 'package:graphql/client.dart' as graphql;

import '../../graphql/cart.graphql.dart'; // Generated GraphQL queries/mutations
import '../../graphql/order.graphql.dart';
import '../../services/graphql_client.dart';
import '../../utils/price_formatter.dart';
import '../order/ordercontroller.dart';
import '../order/ordermodels.dart' as order_models;
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';
import 'cartmodels.dart';

class CartController extends BaseController {
  Rx<Order?> cart = Rx<Order?>(null);
  Rx<ErrorResult?> error = Rx<ErrorResult?>(null);
  final UtilityController utilityController = Get.find();
  final OrderController orderController = Get.put(OrderController());

  Future<bool> addToCart(
      {required int productVariantId, int quantity = 1}) async {
/// debugPrint(  '[Cart] Starting addToCart: variantId=$productVariantId quantity=$quantity');

    try {
      final response = await GraphqlService.client.value.mutate$AddToCart(
        Options$Mutation$AddToCart(
          variables: Variables$Mutation$AddToCart(
            variantId:
                productVariantId.toString(), // ✅ Ensure String conversion
            qty: quantity,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to add item to cart')) {
        error.value = ErrorResult(
          errorCode: "GRAPHQL_ERROR",
          message:
              response.exception?.toString() ?? 'Failed to add item to cart',
        );
        return false;
      }

      final addItemResult = response.parsedData?.addItemToOrder;

      if (addItemResult == null) {
// debugPrint('[Cart] No addItemToOrder result');
        return false;
      }

      if (addItemResult is! Mutation$AddToCart$addItemToOrder$$Order) {
        _handleAddToCartError(addItemResult);
        return false;
      }

      cart.value = Order.fromJson(addItemResult.toJson());
/// debugPrint(  '[Cart] Item added. State: ${cart.value?.state}, active: ${cart.value?.active}. Cart now has ${cart.value?.totalQuantity} items.');

      if (!await _ensureOrderConsistency()) {
        return false;
      }

      return true;
    } catch (e) {
// debugPrint('[Cart] Exception: $e');
      handleException(e, customErrorMessage: 'Failed to add item to cart');
      error.value =
          ErrorResult(errorCode: "NETWORK_ERROR", message: e.toString());
      return false;
    } finally {
// debugPrint('[Cart] addToCart finished.');
    }
  }

  /// Get active order (current cart)
  Future<bool> getActiveOrder() async {
// debugPrint('[Cart] Fetching active order...');

    try {
      final response = await GraphqlService.client.value.query$GetCartTotals(
        Options$Query$GetCartTotals(
          fetchPolicy: graphql.FetchPolicy.networkOnly,
          cacheRereadPolicy: graphql.CacheRereadPolicy.ignoreAll,
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load cart')) {
        return false;
      }

      final orderData = response.parsedData?.activeOrder;
      if (orderData != null) {
        final orderJson = orderData.toJson();
        
        // Debug: Print all order data
// debugPrint('═══════════════════════════════════════════════════════════');
// debugPrint('[Cart] ========== ACTIVE ORDER DATA ==========');
// debugPrint('[Cart] Order ID: ${orderJson['id']}');
// debugPrint('[Cart] Order Code: ${orderJson['code']}');
// debugPrint('[Cart] State: ${orderJson['state']}');
// debugPrint('[Cart] Active: ${orderJson['active']}');
// debugPrint('[Cart] Total Quantity: ${orderJson['totalQuantity']}');
// debugPrint('[Cart] Subtotal: ${orderJson['subTotal']}');
// debugPrint('[Cart] Subtotal With Tax: ${orderJson['subTotalWithTax']}');
// debugPrint('[Cart] Total: ${orderJson['total']}');
// debugPrint('[Cart] Total With Tax: ${orderJson['totalWithTax']}');
// debugPrint('[Cart] Shipping: ${orderJson['shipping']}');
// debugPrint('[Cart] Shipping With Tax: ${orderJson['shippingWithTax']}');
// debugPrint('[Cart] Coupon Codes: ${orderJson['couponCodes']}');
        
        // Validation Status
        if (orderJson['validationStatus'] != null) {
          final validationStatus = orderJson['validationStatus'] as Map<String, dynamic>;
// debugPrint('[Cart] ──── Validation Status ────');
// debugPrint('[Cart] Is Valid: ${validationStatus['isValid']}');
// debugPrint('[Cart] Has Unavailable Items: ${validationStatus['hasUnavailableItems']}');
// debugPrint('[Cart] Total Unavailable Items: ${validationStatus['totalUnavailableItems']}');
          if (validationStatus['unavailableItems'] != null) {
            final unavailableItems = validationStatus['unavailableItems'] as List<dynamic>;
// debugPrint('[Cart] Unavailable Items Count: ${unavailableItems.length}');
            for (int i = 0; i < unavailableItems.length; i++) {
              // ignore: unused_local_variable
              final itemData = unavailableItems[i] as Map<String, dynamic>;
// debugPrint('[Cart]   [$i] OrderLineId: ${itemData['orderLineId']}');
// debugPrint('[Cart]   [$i] ProductName: ${itemData['productName']}');
// debugPrint('[Cart]   [$i] VariantName: ${itemData['variantName']}');
// debugPrint('[Cart]   [$i] Reason: ${itemData['reason']}');
            }
          }
        } else {
// debugPrint('[Cart] Validation Status: null');
        }
        
        // Order Lines
        if (orderJson['lines'] != null) {
          final lines = orderJson['lines'] as List<dynamic>;
// debugPrint('[Cart] ──── Order Lines (${lines.length}) ────');
          for (int i = 0; i < lines.length; i++) {
            final line = lines[i] as Map<String, dynamic>;
// debugPrint('[Cart]   Line [$i]:');
// debugPrint('[Cart]     ID: ${line['id']}');
// debugPrint('[Cart]     Quantity: ${line['quantity']}');
// debugPrint('[Cart]     Unit Price: ${line['unitPrice']}');
// debugPrint('[Cart]     Unit Price With Tax: ${line['unitPriceWithTax']}');
// debugPrint('[Cart]     Line Price With Tax: ${line['linePriceWithTax']}');
// debugPrint('[Cart]     Is Available: ${line['isAvailable']}');
// debugPrint('[Cart]     Unavailable Reason: ${line['unavailableReason']}');
            if (line['productVariant'] != null) {
              // final variant = line['productVariant'] as Map<String, dynamic>; // Unused variable
// debugPrint('[Cart]     Product Variant:');
// debugPrint('[Cart]       ID: ${variantData['id']}');
// debugPrint('[Cart]       Name: ${variantData['name']}');
// debugPrint('[Cart]       Stock Level: ${variantData['stockLevel']}');
// debugPrint('[Cart]       Price: ${variantData['price']}');
            }
          }
        }
        
        // Shipping Lines
        if (orderJson['shippingLines'] != null) {
          final shippingLines = orderJson['shippingLines'] as List<dynamic>;
// debugPrint('[Cart] ──── Shipping Lines (${shippingLines.length}) ────');
          for (int i = 0; i < shippingLines.length; i++) {
            final shippingLine = shippingLines[i] as Map<String, dynamic>;
// debugPrint('[Cart]   Shipping Line [$i]:');
// debugPrint('[Cart]     Price With Tax: ${shippingLine['priceWithTax']}');
            if (shippingLine['shippingMethod'] != null) {
              // ignore: unused_local_variable
              final methodData = shippingLine['shippingMethod'] as Map<String, dynamic>;
// debugPrint('[Cart]     Method ID: ${methodData['id']}');
// debugPrint('[Cart]     Method Code: ${methodData['code']}');
// debugPrint('[Cart]     Method Name: ${methodData['name']}');
            }
          }
        }
        
// debugPrint('[Cart] ===================================================');
// debugPrint('═══════════════════════════════════════════════════════════');
        
        cart.value = Order.fromJson(orderJson);
/// debugPrint(  '[Cart] Active order loaded with ${cart.value?.totalQuantity ?? 0} items');
        return true;
      }

      return false;
    } catch (e) {
// debugPrint('[Cart] Exception: $e');
      handleException(e, customErrorMessage: 'Failed to load cart');
      return false;
    } finally {}
  }

  /// Adjust line quantity
  Future<bool> adjustOrderLine(
      {required String orderLineId, required int quantity}) async {
    // Ensure minimum quantity is 1
    if (quantity < 1) {
// debugPrint('[Cart] Quantity cannot be less than 1. Setting to 1.');
      quantity = 1;
    }
    
    try {
      final response = await GraphqlService.client.value.mutate$AdjustOrderLine(
        Options$Mutation$AdjustOrderLine(
          variables: Variables$Mutation$AdjustOrderLine(
            orderLineId: orderLineId,
            quantity: quantity,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to update cart item')) {
        return false;
      }

      final result = response.parsedData?.adjustOrderLine;
      if (result == null) {
// debugPrint('[Cart] No adjustOrderLine result');
        return false;
      }

      if (result is! Mutation$AdjustOrderLine$adjustOrderLine$$Order) {
        _handleAdjustOrderError(result);
        return false;
      }

      cart.value = Order.fromJson(result.toJson());
// debugPrint(  '[Cart] Order line adjusted. State: ${cart.value?.state}, qty: ${cart.value?.totalQuantity}');
      
      // Also update OrderController to keep them in sync
      try {
        orderController.currentOrder.value = order_models.OrderModel.fromJson(result.toJson());
//         debugPrint('[Cart] OrderController updated after adjusting line');
      } catch (e) {
//         debugPrint('[Cart] Could not update OrderController: $e');
      }

      if (!await _ensureOrderConsistency()) {
        return false;
      }

      return true;
    } catch (e) {
// debugPrint('[Cart] Adjust line error: $e');
      handleException(e, customErrorMessage: 'Failed to update cart item');
      return false;
    } finally {}
  }

  /// Returns the [OrderLine] associated with the given variant ID if present in the cart
  OrderLine? _findOrderLineByVariant(String variantId) {
    final currentCart = cart.value;
    if (currentCart == null) return null;

    try {
      return currentCart.lines
          .firstWhere((line) => line.productVariant.id == variantId);
    } catch (_) {
      return null;
    }
  }

  /// Get the quantity for a specific product variant currently in the cart
  int getVariantQuantity(String variantId) {
    return _findOrderLineByVariant(variantId)?.quantity ?? 0;
  }

  /// Decrement the quantity of a given variant. Minimum quantity is 1.
  Future<bool> decrementVariant({required String variantId}) async {
    final line = _findOrderLineByVariant(variantId);
    if (line == null) {
      return false;
    }

    final newQuantity = line.quantity - 1;
    // Ensure minimum quantity is 1, not 0
    final targetQuantity = newQuantity < 1 ? 1 : newQuantity;
    try {
      return await adjustOrderLine(
          orderLineId: line.id, quantity: targetQuantity);
    } finally {}
  }

  /// Get cart total items count
  int get cartItemCount => cart.value?.totalQuantity ?? 0;

  /// Get cart total price
  int get cartTotalPrice => (cart.value?.totalWithTax ?? 0).toInt();

  bool get hasUnavailableItems {
    final order = cart.value;
    if (order == null) return false;
    if (order.validationStatus?.hasUnavailableItems ?? false) {
      return true;
    }
    return order.lines.any((line) => !line.isAvailable);
  }

  List<OrderLine> get unavailableLines {
    final order = cart.value;
    if (order == null) return [];
    return order.lines.where((line) => !line.isAvailable).toList();
  }

  String? get firstUnavailableReason {
    final order = cart.value;
    if (order == null) return null;

    final validationReason =
        order.validationStatus?.unavailableItems.isNotEmpty == true
            ? order.validationStatus!.unavailableItems.first.reason
            : null;
    if (validationReason != null && validationReason.isNotEmpty) {
      return validationReason;
    }

    for (final line in order.lines) {
      if (!line.isAvailable && (line.unavailableReason?.isNotEmpty ?? false)) {
        return line.unavailableReason;
      }
    }

    return null;
  }

  /// Format price (assuming price is in cents)
  /// If price is 2000, shows "Rs 20" (not "Rs 20.00")
  String formatPrice(int price) {
    return PriceFormatter.formatPrice(price);
  }

  /// Clear cart
  void clearCart() {
    cart.value = null;
    error.value = null;
// debugPrint('[Cart] Cart cleared');
  }

  /// Check if any applied coupon has free_shipping action
  bool hasFreeShippingCoupon() {
    if (cart.value == null) return false;

    final order = cart.value!;

// debugPrint('[Cart] Checking for free shipping coupon...');
/// debugPrint(  '[Cart] Current shipping cost: ${order.shipping}, ${order.shippingWithTax}');
// debugPrint('[Cart] Applied coupon codes: ${order.couponCodes}');
// debugPrint('[Cart] Promotions count: ${order.promotions.length}');

    // Check if shipping cost is 0
    if (order.shipping == 0 && order.shippingWithTax == 0) {
// debugPrint('[Cart] Shipping cost is 0 - free shipping detected');
      return true;
    }

    // Check promotions for free_shipping action
    for (final promotion in order.promotions) {
// debugPrint('[Cart] Checking promotion: ${promotion.name}');
// debugPrint('[Cart] Promotion actions count: ${promotion.actions.length}');

      for (final action in promotion.actions) {
// debugPrint('[Cart] Action code: ${action.code}');
        if (action.code == 'free_shipping') {
/// debugPrint(  '[Cart] Found free_shipping action in promotion: ${promotion.name}');
          return true;
        }
      }
    }

// debugPrint('[Cart] No free shipping coupon found');
    return false;
  }

  /// Get shipping display text
  String getShippingDisplayText() {
    if (hasFreeShippingCoupon()) {
// debugPrint('[Cart] Returning Free for shipping display');
      return 'Free';
    }

    if (cart.value == null) return 'Rs 0';

    final shippingCost = cart.value!.shippingWithTax;
/// debugPrint(  '[Cart] Returning shipping cost: ${formatPrice(shippingCost.toInt())}');
    return formatPrice(shippingCost.toInt());
  }

  /// Force refresh cart data to get updated shipping costs
  Future<void> refreshCartData() async {
// debugPrint('[Cart] Refreshing cart data...');
    await getActiveOrder();
  }

  Future<bool> _ensureOrderConsistency() async {
    final current = cart.value;
    if (current == null) {
      return true;
    }

    final locked = _isOrderLocked(current.state) || !current.active;
    final zeroQuantityWithLines =
        current.totalQuantity == 0 && current.lines.isNotEmpty;

    if (!locked && !zeroQuantityWithLines) {
      return true;
    }

/// debugPrint(  '[Cart] Detected locked/inconsistent order (state: ${current.state}, qty: ${current.totalQuantity}). Refreshing...');
    await getActiveOrder();
    final refreshed = cart.value;

    if (refreshed == null) {
      _setCartError('ORDER_REFRESH_FAILED',
          'Unable to refresh your cart. Please try again.');
      return false;
    }

    if (_isOrderLocked(refreshed.state) || !refreshed.active) {
      _setCartError('ORDER_LOCKED',
          'Your current order is being processed. Please wait until it completes before making further changes.');
      return false;
    }

    if (refreshed.totalQuantity == 0 && refreshed.lines.isNotEmpty) {
      _setCartError('ORDER_REFRESH_FAILED',
          'Unable to update the cart right now. Please refresh the cart and try again.');
      return false;
    }

    return true;
  }

  void _setCartError(String code, String message) {
// debugPrint('[Cart] Error [$code]: $message');
    error.value = ErrorResult(errorCode: code, message: message);
    handleException(Exception(message), customErrorMessage: message);
  }

  void _handleAddToCartError(Mutation$AddToCart$addItemToOrder result) {
    final message = _mapAddToCartErrorMessage(result);
// debugPrint('[Cart] AddToCart error (${result.$__typename}): $message');
    _setCartError(result.$__typename, message);
  }

  void _handleAdjustOrderError(
      Mutation$AdjustOrderLine$adjustOrderLine result) {
    final message = _mapAdjustOrderErrorMessage(result);
/// debugPrint(  '[Cart] AdjustOrderLine error (${result.$__typename}): $message');
    _setCartError(result.$__typename, message);
  }

  String _mapAddToCartErrorMessage(Mutation$AddToCart$addItemToOrder result) {
    switch (result.$__typename) {
      case 'InsufficientStockError':
        return (result
                as Mutation$AddToCart$addItemToOrder$$InsufficientStockError)
            .message;
      case 'OrderModificationError':
        return (result
                as Mutation$AddToCart$addItemToOrder$$OrderModificationError)
            .message;
      case 'OrderLimitError':
        return (result as Mutation$AddToCart$addItemToOrder$$OrderLimitError)
            .message;
      case 'NegativeQuantityError':
        return (result
                as Mutation$AddToCart$addItemToOrder$$NegativeQuantityError)
            .message;
      case 'OrderInterceptorError':
        return (result
                as Mutation$AddToCart$addItemToOrder$$OrderInterceptorError)
            .message;
      default:
        return 'Unable to add this item to your cart right now.';
    }
  }

  String _mapAdjustOrderErrorMessage(
      Mutation$AdjustOrderLine$adjustOrderLine result) {
    switch (result.$__typename) {
      case 'InsufficientStockError':
        return (result
                as Mutation$AdjustOrderLine$adjustOrderLine$$InsufficientStockError)
            .message;
      case 'OrderModificationError':
        return (result
                as Mutation$AdjustOrderLine$adjustOrderLine$$OrderModificationError)
            .message;
      case 'OrderLimitError':
        return (result
                as Mutation$AdjustOrderLine$adjustOrderLine$$OrderLimitError)
            .message;
      case 'NegativeQuantityError':
        return (result
                as Mutation$AdjustOrderLine$adjustOrderLine$$NegativeQuantityError)
            .message;
      case 'OrderInterceptorError':
        return (result
                as Mutation$AdjustOrderLine$adjustOrderLine$$OrderInterceptorError)
            .message;
      default:
        return 'Unable to update this cart item right now.';
    }
  }

  bool _isOrderLocked(String? state) {
    if (state == null) return false;
    final normalized = state.toLowerCase();
    return normalized == 'arrangingpayment' ||
        normalized == 'paymentauthorized' ||
        normalized == 'paymentsettled';
  }
}
