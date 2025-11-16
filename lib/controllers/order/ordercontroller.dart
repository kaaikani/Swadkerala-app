import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../graphql/order.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';
import '../../utils/price_formatter.dart';
import 'ordermodels.dart';

class OrderController extends BaseController {
  Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);
  Rx<ErrorResult?> error = Rx<ErrorResult?>(null);
  final UtilityController utilityController = Get.find();

  RxList<ShippingMethod> shippingMethods = <ShippingMethod>[].obs;
  RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  Rx<ShippingMethod?> selectedShippingMethod = Rx<ShippingMethod?>(null);
  Rx<PaymentMethod?> selectedPaymentMethod = Rx<PaymentMethod?>(null);

  /// Get active order (cart)
  Future<bool> getActiveOrder() async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.query$ActiveOrder(
        Options$Query$ActiveOrder(),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load order')) {
        return false;
      }

      final orderData = response.parsedData?.activeOrder;
      if (orderData != null) {
        currentOrder.value = OrderModel.fromJson(orderData.toJson());
        debugPrint('[Order] Active order loaded: ${currentOrder.value?.code}');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Get active order error: $e');
      handleException(e, customErrorMessage: 'Failed to load order');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Remove item from cart
  Future<bool> removeOrderLine(String orderLineId) async {
    try {
      utilityController.setLoadingState(false);

      final response = await GraphqlService.client.value.mutate$RemoveOrderLine(
        Options$Mutation$RemoveOrderLine(
          variables: Variables$Mutation$RemoveOrderLine(
            orderLineId: orderLineId,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to remove item')) {
        return false;
      }

      final result = response.parsedData?.removeOrderLine;
      if (result == null) {
        debugPrint('[Order] No removeOrderLine result');
        return false;
      }

      if (result is! Mutation$RemoveOrderLine$removeOrderLine$$Order) {
        _handleOrderMutationError(result, 'Failed to remove item');
        return false;
      }

      currentOrder.value = OrderModel.fromJson(result.toJson());
      debugPrint('[Order] Order line removed successfully');
      return true;
    } catch (e) {
      debugPrint('[Order] Remove order line error: $e');
      handleException(e, customErrorMessage: 'Failed to remove item');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Remove all items from cart
  Future<bool> removeAllOrderLines() async {
    try {
      utilityController.setLoadingState(true);

      final response =
          await GraphqlService.client.value.mutate$RemoveAllOrderLines(
        Options$Mutation$RemoveAllOrderLines(),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to clear cart')) {
        return false;
      }

      final result = response.parsedData?.removeAllOrderLines;
      if (result == null) {
        debugPrint('[Order] No removeAllOrderLines result');
        return false;
      }

      if (result is! Mutation$RemoveAllOrderLines$removeAllOrderLines$$Order) {
        _handleOrderMutationError(result, 'Failed to clear cart');
        return false;
      }

      currentOrder.value = OrderModel.fromJson(result.toJson());
      debugPrint('[Order] All order lines removed');
      return true;
    } catch (e) {
      debugPrint('[Order] Remove all order lines error: $e');
      handleException(e, customErrorMessage: 'Failed to clear cart');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get eligible shipping methods
  Future<bool> getEligibleShippingMethods() async {
    try {
      debugPrint('[Order] Starting getEligibleShippingMethods...');
      utilityController.setLoadingState(false);

      // Prepare query options
      final options = Options$Query$GetEligibleShippingMethods();

      // Print out what’s being fetched (query + variables)
      debugPrint(
          '[Order] Preparing to send GraphQL query: GetEligibleShippingMethods');
      debugPrint('[Order] Query variables: ${options.variables}');

      debugPrint(
          '[Order] Sending GraphQL query for eligible shipping methods...');
      final response = await GraphqlService.client.value
          .query$GetEligibleShippingMethods(options);

      debugPrint(
          '[Order] GraphQL response received: ${response.data != null ? 'Data present' : 'No data'}');
      debugPrint('[Order] Checking response for errors...');

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load shipping methods')) {
        debugPrint('[Order] Response contained errors');
        return false;
      }

      final methods = response.parsedData?.eligibleShippingMethods;
      debugPrint(
          '[Order] Parsed methods: ${methods != null ? methods.length : 0}');

      if (methods != null) {
        shippingMethods.value =
            methods.map((m) => ShippingMethod.fromJson(m.toJson())).toList();

        debugPrint(
            '[Order] Loaded ${shippingMethods.length} shipping methods successfully');
        for (var method in shippingMethods) {
          debugPrint('[Order] Method: ${method.name} (ID: ${method.id})');
        }

        return true;
      } else {
        debugPrint('[Order] No eligible shipping methods found in response.');
      }

      return false;
    } catch (e, stack) {
      debugPrint('[Order] Get shipping methods error: $e');
      debugPrint('[Order] Stack trace: $stack');
      handleException(e, customErrorMessage: 'Failed to load shipping methods');
      return false;
    } finally {
      debugPrint(
          '[Order] Finished getEligibleShippingMethods. Resetting loading state.');
      utilityController.setLoadingState(false);
    }
  }

  /// Set shipping method
  Future<bool> setShippingMethod(String methodId) async {
    try {
      utilityController.setLoadingState(false);

      final response =
          await GraphqlService.client.value.mutate$SetShippingMethod(
        Options$Mutation$SetShippingMethod(
          variables: Variables$Mutation$SetShippingMethod(
            id: [methodId],
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to set shipping method')) {
        return false;
      }

      final result = response.parsedData?.setOrderShippingMethod;
      if (result != null) {
        currentOrder.value = OrderModel.fromJson(result.toJson());
        debugPrint('[Order] Shipping method set successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Set shipping method error: $e');
      handleException(e, customErrorMessage: 'Failed to set shipping method');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Check if any applied coupon has free_shipping action
  bool hasFreeShippingCoupon() {
    if (currentOrder.value == null) return false;

    final order = currentOrder.value!;

    // Check if shipping cost is 0
    if (order.shipping == 0 && order.shippingWithTax == 0) {
      return true;
    }

    // Check if any coupon codes are applied that might provide free shipping
    if (order.couponCodes.isNotEmpty) {
      // This is a simple check - in a real implementation, you'd check the promotion actions
      // For now, we'll assume if shipping is 0, it's free due to coupon
      return order.shipping == 0;
    }

    return false;
  }

  /// Get shipping display text
  String getShippingDisplayText() {
    if (hasFreeShippingCoupon()) {
      return 'Free';
    }

    if (currentOrder.value == null) return 'Rs 0';

    final shippingCost = currentOrder.value!.shippingWithTax;
    return PriceFormatter.formatPrice(shippingCost);
  }

  /// Set shipping address
  Future<bool> setShippingAddress({
    required String fullName,
    required String streetLine1,
    required String city,
    required String postalCode,
    required String countryCode,
    required String phoneNumber,
    String? streetLine2,
    String? province,
  }) async {
    try {
      utilityController.setLoadingState(true);

      final input = Input$CreateAddressInput(
        fullName: fullName,
        streetLine1: streetLine1,
        streetLine2: streetLine2,
        city: city,
        postalCode: postalCode,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        province: province,
      );

      final response =
          await GraphqlService.client.value.mutate$SetShippingAddress(
        Options$Mutation$SetShippingAddress(
          variables: Variables$Mutation$SetShippingAddress(
            input: input,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to set shipping address')) {
        return false;
      }

      final result = response.parsedData?.setOrderShippingAddress;
      if (result != null) {
        currentOrder.value = OrderModel.fromJson(result.toJson());
        debugPrint('[Order] Shipping address set successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Set shipping address error: $e');
      handleException(e, customErrorMessage: 'Failed to set shipping address');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Set other instructions for the order
  Future<bool> setOtherInstruction(String instruction) async {
    try {
      if (currentOrder.value == null) {
        debugPrint('[Order] Cannot set instructions: No active order');
        return false;
      }

      final orderId = currentOrder.value!.id;
      if (orderId.isEmpty) {
        debugPrint('[Order] Cannot set instructions: Order ID is empty');
        return false;
      }

      utilityController.setLoadingState(true);

      final response =
          await GraphqlService.client.value.mutate$SetOtherInstruction(
        Options$Mutation$SetOtherInstruction(
          variables: Variables$Mutation$SetOtherInstruction(
            orderId: orderId,
            value: instruction,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to set instructions')) {
        return false;
      }

      final result = response.parsedData?.otherInstructions;
      if (result != null) {
        // Refresh the active order to get updated customFields
        await getActiveOrder();
        debugPrint('[Order] Other instructions set successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Set other instructions error: $e');
      handleException(e, customErrorMessage: 'Failed to set instructions');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get eligible payment methods
  Future<bool> getEligiblePaymentMethods() async {
    try {
      utilityController.setLoadingState(true);

      final response =
          await GraphqlService.client.value.query$GetEligiblePaymentMethods(
        Options$Query$GetEligiblePaymentMethods(),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load payment methods')) {
        return false;
      }

      final methods = response.parsedData?.eligiblePaymentMethods;
      if (methods != null) {
        paymentMethods.value =
            methods.map((m) => PaymentMethod.fromJson(m.toJson())).toList();
        debugPrint('[Order] Loaded ${paymentMethods.length} payment methods');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Get payment methods error: $e');
      handleException(e, customErrorMessage: 'Failed to load payment methods');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Transition to ArrangingPayment state
  Future<bool> transitionToArrangingPayment() async {
    try {
      utilityController.setLoadingState(true);

      final response =
          await GraphqlService.client.value.mutate$TransitionToArrangingPayment(
        Options$Mutation$TransitionToArrangingPayment(),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to transition order')) {
        return false;
      }

      final result = response.parsedData?.transitionOrderToState;
      if (result != null) {
        currentOrder.value = OrderModel.fromJson(result.toJson());
        debugPrint('[Order] Transitioned to ArrangingPayment');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Transition error: $e');
      handleException(e, customErrorMessage: 'Failed to transition order');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Add payment to order
  Future<bool> addPayment({
    required String method,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      utilityController.setLoadingState(true);

      debugPrint('[Order] Adding payment with method: $method');
      debugPrint('[Order] Payment metadata: $metadata');

      final input = Input$PaymentInput(
        method: method,
        metadata: metadata ?? {},
      );

      final response = await GraphqlService.client.value.mutate$AddPayment(
        Options$Mutation$AddPayment(
          variables: Variables$Mutation$AddPayment(
            input: input,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to add payment')) {
        return false;
      }

      final result = response.parsedData?.addPaymentToOrder;
      if (result != null) {
        // Check if it's an error result
        final resultJson = result.toJson();
        debugPrint('[Order] Payment result: $resultJson');

        if (resultJson.containsKey('errorCode')) {
          debugPrint(
              '[Order] Payment error: ${resultJson['message']} (${resultJson['errorCode']})');
          return false;
        }

        // If it's an Order, update current order
        if (resultJson.containsKey('id')) {
          currentOrder.value = OrderModel.fromJson(resultJson);
          debugPrint('[Order] Payment added successfully, order updated');
          return true;
        }
      }

      debugPrint('[Order] No valid payment result received');
      return false;
    } catch (e) {
      debugPrint('[Order] Add payment error: $e');
      handleException(e, customErrorMessage: 'Failed to add payment');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get order by code
  Future<OrderModel?> getOrderByCode(String code) async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.query$GetOrderByCode(
        Options$Query$GetOrderByCode(
          variables: Variables$Query$GetOrderByCode(
            code: code,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load order')) {
        return null;
      }

      final orderData = response.parsedData?.orderByCode;
      if (orderData != null) {
        final order = OrderModel.fromJson(orderData.toJson());
        currentOrder.value =
            order; // Set the current order so UI can react to it
        debugPrint('[Order] Order retrieved: ${order.code}');
        return order;
      }

      currentOrder.value = null; // Clear if order not found
      return null;
    } catch (e) {
      debugPrint('[Order] Get order by code error: $e');
      currentOrder.value = null; // Clear on error
      handleException(e, customErrorMessage: 'Failed to load order');
      return null;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Generate Razorpay Order ID from backend
  Future<RazorpayOrderResponse?> generateRazorpayOrderId(String orderId) async {
    try {
      utilityController.setLoadingState(true);

      final response =
          await GraphqlService.client.value.mutate$GenerateRazorpayOrderId(
        Options$Mutation$GenerateRazorpayOrderId(
          variables: Variables$Mutation$GenerateRazorpayOrderId(
            orderId: orderId,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to generate payment order')) {
        return null;
      }

      final result = response.parsedData?.generateRazorpayOrderId;
      if (result != null) {
        // Check if it's a success result
        final data = result.toJson();
        if (data.containsKey('razorpayOrderId')) {
          final razorpayOrder = RazorpayOrderResponse.fromJson(data);
          debugPrint(
              '[Order] Razorpay order created: ${razorpayOrder.razorpayOrderId}');
          return razorpayOrder;
        } else if (data.containsKey('errorCode')) {
          debugPrint('[Order] Razorpay order error: ${data['message']}');
          return null;
        }
      }

      return null;
    } catch (e) {
      debugPrint('[Order] Generate Razorpay order error: $e');
      handleException(e,
          customErrorMessage: 'Failed to generate payment order');
      return null;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Transition order to next state (after payment)
  Future<bool> transitionToNextState() async {
    try {
      utilityController.setLoadingState(true);

      final response =
          await GraphqlService.client.value.mutate$TransitionToArrangingPayment(
        Options$Mutation$TransitionToArrangingPayment(),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to transition order')) {
        return false;
      }

      final result = response.parsedData?.transitionOrderToState;
      if (result != null) {
        final resultJson = result.toJson();
        debugPrint('[Order] Transition result: $resultJson');

        if (resultJson.containsKey('errorCode')) {
          debugPrint('[Order] Transition error: ${resultJson['message']}');
          return false;
        }

        if (resultJson.containsKey('id')) {
          currentOrder.value = OrderModel.fromJson(resultJson);
          debugPrint('[Order] Order transitioned successfully');
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Transition error: $e');
      handleException(e, customErrorMessage: 'Failed to transition order');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Clear order
  void clearOrder() {
    currentOrder.value = null;
    error.value = null;
    selectedShippingMethod.value = null;
    selectedPaymentMethod.value = null;
    debugPrint('[Order] Order cleared');
  }

  void _handleOrderMutationError(dynamic result, String fallbackMessage) {
    final code = result?.$__typename ?? 'UNKNOWN_ERROR';
    final message = _readOrderMutationMessage(result) ?? fallbackMessage;
    debugPrint('[Order] Mutation error ($code): $message');
    error.value = ErrorResult(errorCode: code, message: message);
    handleException(Exception(message), customErrorMessage: message);
  }

  String? _readOrderMutationMessage(dynamic result) {
    try {
      final message = (result as dynamic).message;
      if (message is String) {
        return message;
      }
    } catch (_) {}
    return null;
  }
}
