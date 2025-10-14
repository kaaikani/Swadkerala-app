import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../graphql/cart.graphql.dart'; // Generated GraphQL queries/mutations
import '../../services/graphql_client.dart';
import 'cartmodels.dart';

class CartController extends GetxController {
  Rx<Order?> cart = Rx<Order?>(null);
  RxBool isLoading = false.obs;
  Rx<ErrorResult?> error = Rx<ErrorResult?>(null);

  Future<bool> addToCart({required int productVariantId, int quantity = 1}) async {
    debugPrint('[Cart] Starting addToCart: variantId=$productVariantId quantity=$quantity');
    isLoading.value = true;

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
      isLoading.value = false;
      debugPrint('[Cart] addToCart finished.');
    }
  }

  /// Clear cart
  void clearCart() {
    cart.value = null;
    error.value = null;
    debugPrint('[Cart] Cart cleared');
  }
}
