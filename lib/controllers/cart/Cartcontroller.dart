import 'package:get/get.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:flutter/foundation.dart';
import '../../graphql/cart.graphql.dart' as cart_graphql; // Generated GraphQL queries/mutations
import '../../graphql/order.graphql.dart';
import '../../services/graphql_client.dart';
import '../../utils/price_formatter.dart';
import '../../services/app_icon_service.dart';
import '../order/ordercontroller.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';
import '../banner/bannercontroller.dart';
import '../../utils/logger.dart';

class CartController extends BaseController {
  Rx<cart_graphql.Fragment$Cart?> cart = Rx<cart_graphql.Fragment$Cart?>(null);
  Rx<cart_graphql.Fragment$ErrorResult?> error = Rx<cart_graphql.Fragment$ErrorResult?>(null);
  final UtilityController utilityController = Get.find();
  final OrderController orderController = Get.put(OrderController());
  
  // Track previous cart count to update badge only when it changes
  int _previousCartCount = 0;

  // Flag to prevent concurrent transitions to AddingItems
  bool _isTransitioningToAddingItems = false;

  // Flag to prevent concurrent calls to getActiveOrder
  bool _isFetchingActiveOrder = false;

  Future<bool> addToCart(
      {required int productVariantId, int quantity = 1}) async {
    Logger.logFunction(functionName: 'addToCart', mutationName: 'AddToCart');
    
    try {
      // Check if order exists and is in a state that prevents adding items
      final currentCart = cart.value;
      if (currentCart != null) {
        final currentState = currentCart.state.toLowerCase();
        
        // Don't transition if order is in ArrangingPayment - user should complete payment first
        if (currentState == 'arrangingpayment') {
          // Error handled by handleException
          error.value = null;
          handleException(Exception('Cannot add items while payment is being arranged. Please complete or cancel the payment first.'), 
            customErrorMessage: 'Cannot add items while payment is being arranged. Please complete or cancel the payment first.');
          return false;
        }
        
        // If order is in other non-AddingItems state and not already transitioning, transition to AddingItems first
        if (currentState != 'addingitems' && !_isTransitioningToAddingItems) {
          _isTransitioningToAddingItems = true;
          try {
            // Transition to AddingItems state
            final transitioned = await orderController.transitionToState('AddingItems', skipLoading: true);
            if (!transitioned) {
              // Error handled by handleException
              error.value = null;
              handleException(Exception('Unable to modify order. Please try again.'), 
                customErrorMessage: 'Unable to modify order. Please try again.');
              return false;
            }
            
            // Refresh cart to get updated state
            await getActiveOrder();
          } finally {
            _isTransitioningToAddingItems = false;
          }
        } else if (_isTransitioningToAddingItems) {
          // If transition is already in progress, wait a bit and check again
          await Future.delayed(Duration(milliseconds: 500));
          // Try to get updated cart state
          await getActiveOrder();
          final updatedState = cart.value?.state.toLowerCase();
          if (updatedState != 'addingitems') {
            // Error handled by handleException
            error.value = null;
            handleException(Exception('Please wait for the current operation to complete.'), 
              customErrorMessage: 'Please wait for the current operation to complete.');
            return false;
          }
        }
      }
      
      final response = await GraphqlService.client.value.mutate$AddToCart(
        cart_graphql.Options$Mutation$AddToCart(
          variables: cart_graphql.Variables$Mutation$AddToCart(
            variantId:
                productVariantId.toString(), // ✅ Ensure String conversion
            qty: quantity,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to add item to cart')) {
        // Error handled by checkResponseForErrors
        error.value = null;
        return false;
      }

      final addItemResult = response.parsedData?.addItemToOrder;

      if (addItemResult == null) {
        return false;
      }

      if (addItemResult is! cart_graphql.Mutation$AddToCart$addItemToOrder$$Order) {
        _handleAddToCartError(addItemResult);
        return false;
      }

      cart.value = addItemResult;

      if (!await _ensureOrderConsistency()) {
        return false;
      }

      // Validate and remove coupons if cart total is below minimum
      // Also validate loyalty points if discount exceeds subtotal
      // Note: This is less critical when adding items (cart total increases)
      // but we still check in case multiple items were removed elsewhere
      try {
        final bannerController = Get.find<BannerController>();
        await bannerController.validateAndRemoveCouponsIfNeeded();
      } catch (e) {
      }

      return true;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to add item to cart', functionName: 'addToCart');
      // Error handled by handleException
      error.value = null;
      return false;
    } finally {
    }
  }

  /// Get active order (current cart)
  Future<bool> getActiveOrder() async {
    Logger.logFunction(functionName: 'getActiveOrder', queryName: 'ActiveOrder');
    
    // Prevent concurrent calls
    if (_isFetchingActiveOrder) {
      return false;
    }
    
    _isFetchingActiveOrder = true;
    try {
      final response = await GraphqlService.client.value.query$ActiveOrder(
        Options$Query$ActiveOrder(
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
        // Validation Status
        if (orderJson['validationStatus'] != null) {
          final validationStatus = orderJson['validationStatus'] as Map<String, dynamic>;
          if (validationStatus['unavailableItems'] != null) {
            final unavailableItems = validationStatus['unavailableItems'] as List<dynamic>;
            for (int i = 0; i < unavailableItems.length; i++) {
              // ignore: unused_local_variable
              final itemData = unavailableItems[i] as Map<String, dynamic>;
            }
          }
        } else {
        }
        
        // Order Lines
        if (orderJson['lines'] != null) {
          final lines = orderJson['lines'] as List<dynamic>;
          for (int i = 0; i < lines.length; i++) {
            final line = lines[i] as Map<String, dynamic>;
            if (line['productVariant'] != null) {
              // final variant = line['productVariant'] as Map<String, dynamic>; // Unused variable

            }
          }
        }
        
        // Shipping Lines
        if (orderJson['shippingLines'] != null) {
          final shippingLines = orderJson['shippingLines'] as List<dynamic>;
          for (int i = 0; i < shippingLines.length; i++) {
            final shippingLine = shippingLines[i] as Map<String, dynamic>;
            if (shippingLine['shippingMethod'] != null) {
              // ignore: unused_local_variable
              final methodData = shippingLine['shippingMethod'] as Map<String, dynamic>;
            }
          }
        }
        // Check if order has lines or valid total
        final hasLines = orderJson['lines'] != null && 
                       (orderJson['lines'] as List).isNotEmpty;
        final hasValidTotal = (orderJson['totalQuantity'] ?? 0) > 0;
        
        if (hasLines || hasValidTotal) {
          // Extract loyalty points from response before converting to Fragment$Cart
          // The response.parsedData?.activeOrder is Query$ActiveOrder$activeOrder which has customFields
          try {
            final bannerController = Get.find<BannerController>();
            if (response.parsedData?.activeOrder != null) {
              final activeOrder = response.parsedData!.activeOrder!;
              // activeOrder is Query$ActiveOrder$activeOrder type which has customFields
              if (activeOrder.customFields != null) {
                final customFields = activeOrder.customFields as Query$ActiveOrder$activeOrder$customFields;
                final loyaltyPointsUsed = customFields.loyaltyPointsUsed;
                if (loyaltyPointsUsed != null && loyaltyPointsUsed > 0) {
                  bannerController.loyaltyPointsUsed.value = loyaltyPointsUsed;
                  bannerController.loyaltyPointsApplied.value = true;
                } else {
                  // If loyaltyPointsUsed is 0 or null, reset the applied state
                  bannerController.loyaltyPointsUsed.value = 0;
                  bannerController.loyaltyPointsApplied.value = false;
                }
              } else {
                // If customFields is null, reset the applied state
                bannerController.loyaltyPointsUsed.value = 0;
                bannerController.loyaltyPointsApplied.value = false;
              }
            }
          } catch (e) {
            // Reset on error to ensure UI is in correct state
            try {
              final bannerController = Get.find<BannerController>();
              bannerController.loyaltyPointsUsed.value = 0;
              bannerController.loyaltyPointsApplied.value = false;
            } catch (_) {}
          }
          
          // Parse order from JSON using generated type
          final cartData = cart_graphql.Fragment$Cart.fromJson(orderJson);
          cart.value = cartData;
          
          // Also update OrderController to avoid duplicate API call
          // Convert cart_graphql.Fragment$Cart to order.graphql Fragment$Cart
          try {
            // Parse the same JSON to get the order.graphql version
            final orderCartData = Fragment$Cart.fromJson(orderJson);
            orderController.currentOrder.value = orderCartData;
          } catch (e) {
          }
          // Restore coupon tracking from cart (before validation)
          try {
            final bannerController = Get.find<BannerController>();
            await bannerController.restoreCouponTrackingFromCart();
            // Then validate and remove coupons if cart total is below minimum
            await bannerController.validateAndRemoveCouponsIfNeeded();
          } catch (e) {
          }
          
          return true;
        } else {
          // Cart is empty - clear it so UI updates properly
          cart.value = null;
          _updateAppBadge(); // Update badge when cart is empty
          // Remove any applied coupons when cart is empty
          try {
            final bannerController = Get.find<BannerController>();
            await bannerController.validateAndRemoveCouponsIfNeeded();
          } catch (e) {
          }
          
          return true;
        }
      }

      // If orderData is null, clear the cart
      cart.value = null;
      _updateAppBadge(); // Update badge when no order found
      return true;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to load cart', functionName: 'getActiveOrder');
      return false;
    } finally {
      _isFetchingActiveOrder = false;
    }
  }

  /// Adjust line quantity
  Future<bool> adjustOrderLine(
      {required String orderLineId, required int quantity}) async {
    Logger.logFunction(functionName: 'adjustOrderLine', mutationName: 'AdjustOrderLine');
    
    // Ensure minimum quantity is 1
    if (quantity < 1) {
      quantity = 1;
    }
    
    try {
      // Check if order exists and is in a state that prevents modifying items
      final currentCart = cart.value;
      if (currentCart != null) {
        final currentState = currentCart.state.toLowerCase();
        
        // Don't transition if order is in ArrangingPayment - user should complete payment first
        if (currentState == 'arrangingpayment') {
          // Error handled by handleException
          error.value = null;
          handleException(Exception('Cannot modify items while payment is being arranged. Please complete or cancel the payment first.'), 
            customErrorMessage: 'Cannot modify items while payment is being arranged. Please complete or cancel the payment first.');
          return false;
        }
        
        // If order is in other non-AddingItems state and not already transitioning, transition to AddingItems first
        if (currentState != 'addingitems' && !_isTransitioningToAddingItems) {
          _isTransitioningToAddingItems = true;
          try {
            // Transition to AddingItems state
            final transitioned = await orderController.transitionToState('AddingItems', skipLoading: true);
            if (!transitioned) {
              // Error handled by handleException
              error.value = null;
              handleException(Exception('Unable to modify order. Please try again.'), 
                customErrorMessage: 'Unable to modify order. Please try again.');
              return false;
            }
            
            // Refresh cart to get updated state
            await getActiveOrder();
          } finally {
            _isTransitioningToAddingItems = false;
          }
        } else if (_isTransitioningToAddingItems) {
          // If transition is already in progress, wait a bit and check again
          await Future.delayed(Duration(milliseconds: 500));
          // Try to get updated cart state
          await getActiveOrder();
          final updatedState = cart.value?.state.toLowerCase();
          if (updatedState != 'addingitems') {
            // Error handled by handleException
            error.value = null;
            handleException(Exception('Please wait for the current operation to complete.'), 
              customErrorMessage: 'Please wait for the current operation to complete.');
            return false;
          }
        }
      }
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
        return false;
      }

      if (result is! Mutation$AdjustOrderLine$adjustOrderLine$$Order) {
        _handleAdjustOrderError(result);
        return false;
      }

      // Convert result to JSON and parse as Fragment$Cart to avoid type mismatch
      final orderJson = result.toJson();
      cart.value = cart_graphql.Fragment$Cart.fromJson(orderJson);
      // Also update OrderController to keep them in sync
      try {
        orderController.currentOrder.value = result;
      } catch (e) {
      }

      if (!await _ensureOrderConsistency()) {
        return false;
      }

      // Validate and remove coupons if cart total is below minimum
      try {
        final bannerController = Get.find<BannerController>();
        await bannerController.validateAndRemoveCouponsIfNeeded();
      } catch (e) {
      }

      return true;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to update cart item', functionName: 'adjustOrderLine');
      return false;
    } finally {}
  }

  /// Returns the [OrderLine] associated with the given variant ID if present in the cart
  cart_graphql.Fragment$Cart$lines? _findOrderLineByVariant(String variantId) {
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
    if (order.validationStatus.hasUnavailableItems) {
      return true;
    }
    return order.lines.any((line) => !line.isAvailable);
  }

  List<cart_graphql.Fragment$Cart$lines> get unavailableLines {
    final order = cart.value;
    if (order == null) return [];
    return order.lines.where((line) => !line.isAvailable).toList();
  }

  String? get firstUnavailableReason {
    final order = cart.value;
    if (order == null) return null;

    final validationReason =
        order.validationStatus.unavailableItems.isNotEmpty
            ? order.validationStatus.unavailableItems.first.reason
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
  Future<void> clearCart() async {
    cart.value = null;
    error.value = null;
    _updateAppBadge(); // Update badge when cart is cleared
    // Remove any applied coupons when cart is cleared
    try {
      final bannerController = Get.find<BannerController>();
      await bannerController.validateAndRemoveCouponsIfNeeded();
    } catch (e) {
    }
  }

  /// Check if any applied coupon has free_shipping action
  bool hasFreeShippingCoupon() {
    if (cart.value == null) return false;

    final order = cart.value!;
    // Check if shipping cost is 0
    if (order.shipping == 0 && order.shippingWithTax == 0) {
      return true;
    }

    // Check promotions for free_shipping action
    for (final promotion in order.promotions) {
      for (final action in promotion.actions) {
        if (action.code == 'free_shipping') {
          return true;
        }
      }
    }
    return false;
  }

  /// Get shipping display text
  String getShippingDisplayText() {
    if (hasFreeShippingCoupon()) {
      return 'Free';
    }

    if (cart.value == null) return formatPrice(0);

    final shippingCost = cart.value!.shippingWithTax;
    return formatPrice(shippingCost.toInt());
  }

  /// Force refresh cart data to get updated shipping costs
  Future<void> refreshCartData() async {
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
    // Error handled by handleException
    error.value = null;
    handleException(Exception(message), customErrorMessage: message);
  }

  void _handleAddToCartError(cart_graphql.Mutation$AddToCart$addItemToOrder result) {
    final message = _mapAddToCartErrorMessage(result);
    _setCartError(result.$__typename, message);
  }

  void _handleAdjustOrderError(
      Mutation$AdjustOrderLine$adjustOrderLine result) {
    final message = _mapAdjustOrderErrorMessage(result);
    _setCartError(result.$__typename, message);
  }

  String _mapAddToCartErrorMessage(cart_graphql.Mutation$AddToCart$addItemToOrder result) {
    switch (result.$__typename) {
      case 'InsufficientStockError':
        return (result
                as cart_graphql.Mutation$AddToCart$addItemToOrder$$InsufficientStockError)
            .message;
      case 'OrderModificationError':
        return (result
                as cart_graphql.Mutation$AddToCart$addItemToOrder$$OrderModificationError)
            .message;
      case 'OrderLimitError':
        return (result as cart_graphql.Mutation$AddToCart$addItemToOrder$$OrderLimitError)
            .message;
      case 'NegativeQuantityError':
        return (result
                as cart_graphql.Mutation$AddToCart$addItemToOrder$$NegativeQuantityError)
            .message;
      case 'OrderInterceptorError':
        return (result
                as cart_graphql.Mutation$AddToCart$addItemToOrder$$OrderInterceptorError)
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

  /// Update app icon badge with current cart count
  Future<void> _updateAppBadge() async {
    final currentCount = cartItemCount;
    // Only update if count changed to avoid unnecessary calls
    if (currentCount != _previousCartCount) {
      _previousCartCount = currentCount;
      await AppIconService.instance.updateBadgeCount(currentCount);
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