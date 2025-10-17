import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../graphql/order.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'ordermodels.dart';

class OrderController extends GetxController {
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

      if (response.hasException) {
        debugPrint('[Order] Get active order exception: ${response.exception}');
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
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Remove item from cart
  Future<bool> removeOrderLine(String orderLineId) async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.mutate$RemoveOrderLine(
        Options$Mutation$RemoveOrderLine(
          variables: Variables$Mutation$RemoveOrderLine(
            orderLineId: orderLineId,
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Order] Remove order line exception: ${response.exception}');
        return false;
      }

      final result = response.parsedData?.removeOrderLine;
      if (result != null) {
        currentOrder.value = OrderModel.fromJson(result.toJson());
        debugPrint('[Order] Order line removed successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Remove order line error: $e');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Remove all items from cart
  Future<bool> removeAllOrderLines() async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.mutate$RemoveAllOrderLines(
        Options$Mutation$RemoveAllOrderLines(),
      );

      if (response.hasException) {
        debugPrint('[Order] Remove all order lines exception: ${response.exception}');
        return false;
      }

      final result = response.parsedData?.removeAllOrderLines;
      if (result != null) {
        currentOrder.value = OrderModel.fromJson(result.toJson());
        debugPrint('[Order] All order lines removed');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Remove all order lines error: $e');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get eligible shipping methods
  Future<bool> getEligibleShippingMethods() async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.query$GetEligibleShippingMethods(
        Options$Query$GetEligibleShippingMethods(),
      );

      if (response.hasException) {
        debugPrint('[Order] Get shipping methods exception: ${response.exception}');
        return false;
      }

      final methods = response.parsedData?.eligibleShippingMethods;
      if (methods != null) {
        shippingMethods.value = methods
            .map((m) => ShippingMethod.fromJson(m.toJson()))
            .toList();
        debugPrint('[Order] Loaded ${shippingMethods.length} shipping methods');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Get shipping methods error: $e');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Set shipping method
  Future<bool> setShippingMethod(String methodId) async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.mutate$SetShippingMethod(
        Options$Mutation$SetShippingMethod(
          variables: Variables$Mutation$SetShippingMethod(
            id: [methodId],
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Order] Set shipping method exception: ${response.exception}');
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
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
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

      final response = await GraphqlService.client.value.mutate$SetShippingAddress(
        Options$Mutation$SetShippingAddress(
          variables: Variables$Mutation$SetShippingAddress(
            input: input,
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Order] Set shipping address exception: ${response.exception}');
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
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get eligible payment methods
  Future<bool> getEligiblePaymentMethods() async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.query$GetEligiblePaymentMethods(
        Options$Query$GetEligiblePaymentMethods(),
      );

      if (response.hasException) {
        debugPrint('[Order] Get payment methods exception: ${response.exception}');
        return false;
      }

      final methods = response.parsedData?.eligiblePaymentMethods;
      if (methods != null) {
        paymentMethods.value = methods
            .map((m) => PaymentMethod.fromJson(m.toJson()))
            .toList();
        debugPrint('[Order] Loaded ${paymentMethods.length} payment methods');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[Order] Get payment methods error: $e');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Transition to ArrangingPayment state
  Future<bool> transitionToArrangingPayment() async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.mutate$TransitionToArrangingPayment(
        Options$Mutation$TransitionToArrangingPayment(),
      );

      if (response.hasException) {
        debugPrint('[Order] Transition exception: ${response.exception}');
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

      if (response.hasException) {
        debugPrint('[Order] Add payment exception: ${response.exception}');
        debugPrint('[Order] Exception details: ${response.exception?.graphqlErrors}');
        return false;
      }

      final result = response.parsedData?.addPaymentToOrder;
      if (result != null) {
        // Check if it's an error result
        final resultJson = result.toJson();
        debugPrint('[Order] Payment result: $resultJson');
        
        if (resultJson.containsKey('errorCode')) {
          debugPrint('[Order] Payment error: ${resultJson['message']} (${resultJson['errorCode']})');
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

      if (response.hasException) {
        debugPrint('[Order] Get order by code exception: ${response.exception}');
        return null;
      }

      final orderData = response.parsedData?.orderByCode;
      if (orderData != null) {
        final order = OrderModel.fromJson(orderData.toJson());
        debugPrint('[Order] Order retrieved: ${order.code}');
        return order;
      }

      return null;
    } catch (e) {
      debugPrint('[Order] Get order by code error: $e');
      return null;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Generate Razorpay Order ID from backend
  Future<RazorpayOrderResponse?> generateRazorpayOrderId(String orderId) async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.mutate$GenerateRazorpayOrderId(
        Options$Mutation$GenerateRazorpayOrderId(
          variables: Variables$Mutation$GenerateRazorpayOrderId(
            orderId: orderId,
          ),
        ),
      );

      if (response.hasException) {
        debugPrint('[Order] Generate Razorpay order exception: ${response.exception}');
        return null;
      }

      final result = response.parsedData?.generateRazorpayOrderId;
      if (result != null) {
        // Check if it's a success result
        final data = result.toJson();
        if (data.containsKey('razorpayOrderId')) {
          final razorpayOrder = RazorpayOrderResponse.fromJson(data);
          debugPrint('[Order] Razorpay order created: ${razorpayOrder.razorpayOrderId}');
          return razorpayOrder;
        } else if (data.containsKey('errorCode')) {
          debugPrint('[Order] Razorpay order error: ${data['message']}');
          return null;
        }
      }

      return null;
    } catch (e) {
      debugPrint('[Order] Generate Razorpay order error: $e');
      return null;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Transition order to next state (after payment)
  Future<bool> transitionToNextState() async {
    try {
      utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.mutate$TransitionToArrangingPayment(
        Options$Mutation$TransitionToArrangingPayment(),
      );

      if (response.hasException) {
        debugPrint('[Order] Transition exception: ${response.exception}');
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
}

