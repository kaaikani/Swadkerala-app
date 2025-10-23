import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../graphql/cart.graphql.dart'; // Generated GraphQL queries/mutations
import '../../graphql/order.graphql.dart';
import '../../services/graphql_client.dart';
import '../order/ordercontroller.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'cartmodels.dart';

class CartController extends GetxController {
  Rx<Order?> cart = Rx<Order?>(null);
  Rx<ErrorResult?> error = Rx<ErrorResult?>(null);
  final UtilityController utilityController = Get.find();
  final OrderController orderController = Get.put(OrderController());

  Future<bool> addToCart({required int productVariantId, int quantity = 1}) async {
    debugPrint('[Cart] Starting addToCart: variantId=$productVariantId quantity=$quantity');
    utilityController.setLoadingState(true);

    try {
      final response = await GraphqlService.client.value.mutate$AddToCart(
        Options$Mutation$AddToCart(
          variables: Variables$Mutation$AddToCart(
            variantId: productVariantId.toString(), // ✅ Ensure String conversion
            qty: quantity,
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Cart] GraphQL Exception: ${response.exception}');
        error.value = ErrorResult(
          errorCode: "GRAPHQL_ERROR",
          message: response.exception.toString(),
        );
        return false;
      }

      final addItemResult = response.parsedData?.addItemToOrder;

      if (addItemResult == null) {
        debugPrint('[Cart] No addItemToOrder result');
        return false;
      }

      // ✅ Directly assume success & update cart
      cart.value = Order.fromJson(addItemResult.toJson());
      debugPrint('[Cart] Item added. Cart now has ${cart.value?.totalQuantity} items.');

      return true;

    } catch (e, stacktrace) {
      debugPrint('[Cart] Exception: $e');
      debugPrint('[Cart] Stacktrace: $stacktrace');
      error.value = ErrorResult(errorCode: "NETWORK_ERROR", message: e.toString());
      return false;
    } finally {
      utilityController.setLoadingState(false);
      debugPrint('[Cart] addToCart finished.');
    }
  }

  /// Get active order (current cart)
  Future<bool> getActiveOrder() async {
    debugPrint('[Cart] Fetching active order...');
    utilityController.setLoadingState(false);

    try {
      final response = await GraphqlService.client.value.query$ActiveOrder(
        Options$Query$ActiveOrder(),
      );

      if (response.hasException) {
        debugPrint('[Cart] GraphQL Exception: ${response.exception}');
        return false;
      }

      final orderData = response.parsedData?.activeOrder;
      if (orderData != null) {
        cart.value = Order.fromJson(orderData.toJson());
        debugPrint('[Cart] Active order loaded with ${cart.value?.totalQuantity ?? 0} items');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Cart] Exception: $e');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Adjust line quantity
  Future<bool> adjustOrderLine({required String orderLineId, required int quantity}) async {
    utilityController.setLoadingState(true);

    try {
      final response = await GraphqlService.client.value.mutate$AdjustOrderLine(
        Options$Mutation$AdjustOrderLine(
          variables: Variables$Mutation$AdjustOrderLine(
            orderLineId: orderLineId,
            quantity: quantity,
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Cart] Adjust line exception: ${response.exception}');
        return false;
      }

      final result = response.parsedData?.adjustOrderLine;
      if (result != null) {
        cart.value = Order.fromJson(result.toJson());
        debugPrint('[Cart] Order line adjusted');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Cart] Adjust line error: $e');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get cart total items count
  int get cartItemCount => cart.value?.totalQuantity ?? 0;

  /// Get cart total price
  int get cartTotalPrice => (cart.value?.totalWithTax ?? 0).toInt();

  /// Format price (assuming price is in cents)
  String formatPrice(int price) {
    return 'Rs.${(price / 100).toStringAsFixed(2)}';
  }

  /// Clear cart
  void clearCart() {
    cart.value = null;
    error.value = null;
    debugPrint('[Cart] Cart cleared');
  }

  /// Check if any applied coupon has free_shipping action
  bool hasFreeShippingCoupon() {
    if (cart.value == null) return false;
    
    final order = cart.value!;
    
    debugPrint('[Cart] Checking for free shipping coupon...');
    debugPrint('[Cart] Current shipping cost: ${order.shipping}, ${order.shippingWithTax}');
    debugPrint('[Cart] Applied coupon codes: ${order.couponCodes}');
    debugPrint('[Cart] Promotions count: ${order.promotions.length}');
    
    // Check if shipping cost is 0
    if (order.shipping == 0 && order.shippingWithTax == 0) {
      debugPrint('[Cart] Shipping cost is 0 - free shipping detected');
      return true;
    }
    
    // Check promotions for free_shipping action
    for (final promotion in order.promotions) {
      debugPrint('[Cart] Checking promotion: ${promotion.name}');
      debugPrint('[Cart] Promotion actions count: ${promotion.actions.length}');
      
      for (final action in promotion.actions) {
        debugPrint('[Cart] Action code: ${action.code}');
        if (action.code == 'free_shipping') {
          debugPrint('[Cart] Found free_shipping action in promotion: ${promotion.name}');
          return true;
        }
      }
    }
    
    debugPrint('[Cart] No free shipping coupon found');
    return false;
  }

  /// Get shipping display text
  String getShippingDisplayText() {
    if (hasFreeShippingCoupon()) {
      debugPrint('[Cart] Returning Free for shipping display');
      return 'Free';
    }
    
    if (cart.value == null) return 'Rs.0.00';
    
    final shippingCost = cart.value!.shippingWithTax;
    debugPrint('[Cart] Returning shipping cost: ${formatPrice(shippingCost.toInt())}');
    return formatPrice(shippingCost.toInt());
  }

  /// Force refresh cart data to get updated shipping costs
  Future<void> refreshCartData() async {
    debugPrint('[Cart] Refreshing cart data...');
    await getActiveOrder();
  }
}
