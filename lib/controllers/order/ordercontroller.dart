import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql/order.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../banner/bannercontroller.dart';
import '../base_controller.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/error_dialog.dart';
import 'package:flutter/foundation.dart';

class OrderController extends BaseController {
  Rx<Fragment$Cart?> currentOrder = Rx<Fragment$Cart?>(null);
  Rx<Fragment$ErrorResult?> error = Rx<Fragment$ErrorResult?>(null);
  final UtilityController utilityController = Get.find();

  RxList<Query$GetEligibleShippingMethods$eligibleShippingMethods> shippingMethods = <Query$GetEligibleShippingMethods$eligibleShippingMethods>[].obs;
  RxList<Query$GetEligiblePaymentMethods$eligiblePaymentMethods> paymentMethods = <Query$GetEligiblePaymentMethods$eligiblePaymentMethods>[].obs;
  Rx<Query$GetEligibleShippingMethods$eligibleShippingMethods?> selectedShippingMethod = Rx<Query$GetEligibleShippingMethods$eligibleShippingMethods?>(null);
  Rx<Query$GetEligiblePaymentMethods$eligiblePaymentMethods?> selectedPaymentMethod = Rx<Query$GetEligiblePaymentMethods$eligiblePaymentMethods?>(null);

  /// Get active order (cart)
  Future<bool> getActiveOrder({bool skipLoading = false}) async {
    try {
      if (!skipLoading) {
        utilityController.setLoadingState(true);
      }

      final response = await GraphqlService.client.value.query$ActiveOrder(
        Options$Query$ActiveOrder(),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load order')) {
        return false;
      }

      final orderData = response.parsedData?.activeOrder;
      if (orderData != null) {
        // Debug: Print all order data
        final orderJson = orderData.toJson();
debugPrint('═══════════════════════════════════════════════════════════');
debugPrint('[Order] ========== ACTIVE ORDER DATA ==========');
debugPrint('[Order] Order ID: ${orderJson['id']}');
debugPrint('[Order] Order Code: ${orderJson['code']}');
debugPrint('[Order] State: ${orderJson['state']}');
debugPrint('[Order] Active: ${orderJson['active']}');
debugPrint('[Order] Total Quantity: ${orderJson['totalQuantity']}');
debugPrint('[Order] Subtotal: ${orderJson['subTotal']}');
debugPrint('[Order] Subtotal With Tax: ${orderJson['subTotalWithTax']}');
debugPrint('[Order] Total: ${orderJson['total']}');
debugPrint('[Order] Total With Tax: ${orderJson['totalWithTax']}');
debugPrint('[Order] Shipping: ${orderJson['shipping']}');
debugPrint('[Order] Shipping With Tax: ${orderJson['shippingWithTax']}');
debugPrint('[Order] Coupon Codes: ${orderJson['couponCodes']}');
        
        // Validation Status
        if (orderJson['validationStatus'] != null) {
          final validationStatus = orderJson['validationStatus'] as Map<String, dynamic>;
debugPrint('[Order] ──── Validation Status ────');
debugPrint('[Order] Is Valid: ${validationStatus['isValid']}');
debugPrint('[Order] Has Unavailable Items: ${validationStatus['hasUnavailableItems']}');
debugPrint('[Order] Total Unavailable Items: ${validationStatus['totalUnavailableItems']}');
          if (validationStatus['unavailableItems'] != null) {
            final unavailableItems = validationStatus['unavailableItems'] as List<dynamic>;
debugPrint('[Order] Unavailable Items Count: ${unavailableItems.length}');
            for (int i = 0; i < unavailableItems.length; i++) {
              // ignore: unused_local_variable
              final itemData = unavailableItems[i] as Map<String, dynamic>;
debugPrint('[Order]   [$i] OrderLineId: ${itemData['orderLineId']}');
debugPrint('[Order]   [$i] ProductName: ${itemData['productName']}');
debugPrint('[Order]   [$i] VariantName: ${itemData['variantName']}');
debugPrint('[Order]   [$i] Reason: ${itemData['reason']}');
            }
          }
        } else {
debugPrint('[Order] Validation Status: null');
        }
        
        // Order Lines
        if (orderJson['lines'] != null) {
          final lines = orderJson['lines'] as List<dynamic>;
debugPrint('[Order] ──── Order Lines (${lines.length}) ────');
          for (int i = 0; i < lines.length; i++) {
            final line = lines[i] as Map<String, dynamic>;
debugPrint('[Order]   Line [$i]:');
debugPrint('[Order]     ID: ${line['id']}');
debugPrint('[Order]     Quantity: ${line['quantity']}');
debugPrint('[Order]     Unit Price: ${line['unitPrice']}');
debugPrint('[Order]     Unit Price With Tax: ${line['unitPriceWithTax']}');
debugPrint('[Order]     Line Price With Tax: ${line['linePriceWithTax']}');
debugPrint('[Order]     Is Available: ${line['isAvailable']}');
debugPrint('[Order]     Unavailable Reason: ${line['unavailableReason']}');
            if (line['productVariant'] != null) {
              // ignore: unused_local_variable
              final variantData = line['productVariant'] as Map<String, dynamic>;
debugPrint('[Order]     Product Variant:');
debugPrint('[Order]       ID: ${variantData['id']}');
debugPrint('[Order]       Name: ${variantData['name']}');
debugPrint('[Order]       Stock Level: ${variantData['stockLevel']}');
debugPrint('[Order]       Price: ${variantData['price']}');
            }
          }
        }
        
        // Shipping Lines
        if (orderJson['shippingLines'] != null) {
          final shippingLines = orderJson['shippingLines'] as List<dynamic>;
debugPrint('[Order] ──── Shipping Lines (${shippingLines.length}) ────');
          for (int i = 0; i < shippingLines.length; i++) {
            final shippingLine = shippingLines[i] as Map<String, dynamic>;
debugPrint('[Order]   Shipping Line [$i]:');
debugPrint('[Order]     Price With Tax: ${shippingLine['priceWithTax']}');
            if (shippingLine['shippingMethod'] != null) {
              // ignore: unused_local_variable
              final methodData = shippingLine['shippingMethod'] as Map<String, dynamic>;
debugPrint('[Order]     Method ID: ${methodData['id']}');
debugPrint('[Order]     Method Code: ${methodData['code']}');
debugPrint('[Order]     Method Name: ${methodData['name']}');
            }
          }
        }
        
debugPrint('[Order] ===================================================');
debugPrint('═══════════════════════════════════════════════════════════');
        
        final newOrder = orderData;
        final previousOrderId = currentOrder.value?.id;
        
        // If this is a new order (different ID) or order has no shipping lines, clear selected shipping method
        if (previousOrderId != null && previousOrderId != newOrder.id) {
debugPrint('[Order] New order detected (ID changed from $previousOrderId to ${newOrder.id}), clearing selected shipping method');
          selectedShippingMethod.value = null;
          // Also reset loyalty points state for new order
          try {
            final bannerController = Get.find<BannerController>();
            bannerController.resetLoyaltyPoints();
debugPrint('[Order] Reset loyalty points state for new order');
          } catch (e) {
            // BannerController might not be initialized yet, ignore
          }
        } else if (newOrder.shippingLines.isEmpty && selectedShippingMethod.value != null) {
debugPrint('[Order] Order has no shipping lines, clearing selected shipping method');
          selectedShippingMethod.value = null;
        } else if (newOrder.shippingLines.isNotEmpty && selectedShippingMethod.value != null) {
          // Verify the selected method is still applied to the order
          final isMethodStillApplied = newOrder.shippingLines.any((line) => 
            line.shippingMethod.id == selectedShippingMethod.value?.id);
          if (!isMethodStillApplied) {
debugPrint('[Order] Selected shipping method is not applied to order, clearing selection');
            selectedShippingMethod.value = null;
          }
        }
        
        currentOrder.value = newOrder;
debugPrint('[Order] Active order loaded: ${currentOrder.value?.code}');
        return true;
      } else {
        // No active order, clear selected shipping method
        if (selectedShippingMethod.value != null) {
debugPrint('[Order] No active order, clearing selected shipping method');
          selectedShippingMethod.value = null;
        }
      }

      return false;
    } catch (e) {
debugPrint('[Order] Get active order error: $e');
      handleException(e, customErrorMessage: 'Failed to load order');
      return false;
    } finally {
      if (!skipLoading) {
        utilityController.setLoadingState(false);
      }
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

      currentOrder.value = result;
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

      currentOrder.value = result;
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
      utilityController.setLoadingState(false);

      final options = Options$Query$GetEligibleShippingMethods();
      final response = await GraphqlService.client.value
          .query$GetEligibleShippingMethods(options);

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load shipping methods')) {
        return false;
      }

      final methods = response.parsedData?.eligibleShippingMethods;

      if (methods != null) {
        shippingMethods.value = methods;
        return true;
      }

      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to load shipping methods');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Set shipping method
  Future<bool> setShippingMethod(String methodId, {bool skipIfAlreadySet = false}) async {
    try {
      // If method is already set and skipIfAlreadySet is true, return early without loading
      if (skipIfAlreadySet && 
          selectedShippingMethod.value?.id == methodId &&
          currentOrder.value?.shippingLines.isNotEmpty == true) {
debugPrint('[Order] Shipping method already set, skipping');
        return true;
      }

      // Don't show loading state when selecting shipping method
      // This provides instant feedback to the user

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
      if (result != null && result is Mutation$SetShippingMethod$setOrderShippingMethod$$Order) {
        currentOrder.value = result;
debugPrint('[Order] Shipping method set successfully');
        return true;
      }

      return false;
    } catch (e) {
debugPrint('[Order] Set shipping method error: $e');
      handleException(e, customErrorMessage: 'Failed to set shipping method');
      return false;
    }
    // Removed finally block - no loading state management needed
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

    if (currentOrder.value == null) return PriceFormatter.formatPrice(0);

    final shippingCost = currentOrder.value!.shippingWithTax;
    return PriceFormatter.formatPrice(shippingCost.toInt());
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
    bool skipLoading = false,
  }) async {
    try {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('[Order] ========== SET SHIPPING ADDRESS START ==========');
      debugPrint('[Order] Full Name: $fullName');
      debugPrint('[Order] Phone Number: $phoneNumber');
      debugPrint('[Order] Street Line 1: $streetLine1');
      debugPrint('[Order] Street Line 2: ${streetLine2 ?? "N/A"}');
      debugPrint('[Order] City: $city');
      debugPrint('[Order] Province: ${province ?? "N/A"}');
      debugPrint('[Order] Postal Code: $postalCode');
      debugPrint('[Order] Country Code: $countryCode');
      debugPrint('[Order] Skip Loading: $skipLoading');
      debugPrint('[Order] Current Order ID: ${currentOrder.value?.id ?? "N/A"}');
      debugPrint('[Order] Current Order Code: ${currentOrder.value?.code ?? "N/A"}');
      
      // Show loading dialog for shipping address
      if (!skipLoading) {
        LoadingDialog.show(message: 'Please wait');
      }

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

      debugPrint('[Order] Created address input object');
      debugPrint('[Order] Sending GraphQL mutation: SetShippingAddress');

      final response =
          await GraphqlService.client.value.mutate$SetShippingAddress(
        Options$Mutation$SetShippingAddress(
          variables: Variables$Mutation$SetShippingAddress(
            input: input,
          ),
        ),
      );

      debugPrint('[Order] GraphQL response received: ${response.data != null ? "Data present" : "No data"}');
      debugPrint('[Order] Response has exception: ${response.hasException}');

      // Detailed error logging before checking for errors
      if (response.hasException) {
        debugPrint('[Order] ⚠️ EXCEPTION DETECTED IN RESPONSE');
        
        // Log GraphQL errors
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          debugPrint('[Order] ──── GraphQL Errors ────');
          for (int i = 0; i < response.exception!.graphqlErrors.length; i++) {
            final error = response.exception!.graphqlErrors[i];
            debugPrint('[Order] Error ${i + 1}:');
            debugPrint('[Order]   Message: ${error.message}');
            debugPrint('[Order]   Extensions: ${error.extensions}');
            if (error.locations != null && error.locations!.isNotEmpty) {
              debugPrint('[Order]   Locations: ${error.locations}');
            }
            if (error.path != null && error.path!.isNotEmpty) {
              debugPrint('[Order]   Path: ${error.path}');
            }
          }
        }
        
        // Log link exception
        if (response.exception?.linkException != null) {
          final linkException = response.exception!.linkException;
          debugPrint('[Order] ──── Link Exception ────');
          debugPrint('[Order] Type: ${linkException.runtimeType}');
          debugPrint('[Order] Message: ${linkException.toString()}');
          
          if (linkException is NetworkException) {
            debugPrint('[Order] Network Exception Details:');
            debugPrint('[Order]   Original Exception: ${linkException.originalException}');
          } else if (linkException is ServerException) {
            debugPrint('[Order] Server Exception Details:');
            debugPrint('[Order]   Original Exception: ${linkException.originalException}');
            if (linkException.parsedResponse != null) {
              debugPrint('[Order]   Parsed Response: ${linkException.parsedResponse}');
            }
          } else if (linkException is UnknownException) {
            debugPrint('[Order] Unknown Exception Details:');
            debugPrint('[Order]   Original Exception: ${linkException.originalException}');
          }
        }
        
        // Log general exception
        if (response.exception != null) {
          debugPrint('[Order] ──── General Exception ────');
          debugPrint('[Order] Exception: ${response.exception}');
        }
      }
      
      // Log response data if available (for debugging)
      if (response.data != null) {
        debugPrint('[Order] Response data keys: ${response.data!.keys}');
        if (response.data!.containsKey('setOrderShippingAddress')) {
          final resultData = response.data!['setOrderShippingAddress'];
          debugPrint('[Order] setOrderShippingAddress result type: ${resultData.runtimeType}');
          if (resultData is Map) {
            debugPrint('[Order] Result keys: ${resultData.keys}');
            if (resultData.containsKey('__typename')) {
              debugPrint('[Order] Result typename: ${resultData['__typename']}');
            }
            if (resultData.containsKey('errorCode')) {
              debugPrint('[Order] ⚠️ Error in result: ${resultData['errorCode']} - ${resultData['message']}');
            }
          }
        }
      }

      // Check for postal code errors specifically before general error check
      bool isPostalCodeError = false;
      if (response.hasException) {
        // Check GraphQL errors for postal code related errors
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          for (final error in response.exception!.graphqlErrors) {
            final errorMessage = error.message.toLowerCase();
            if (errorMessage.contains('postal') || 
                errorMessage.contains('postcode') ||
                errorMessage.contains('zip code') ||
                errorMessage.contains('invalid postal') ||
                errorMessage.contains('postal code')) {
              isPostalCodeError = true;
              debugPrint('[Order] 🚫 Invalid postal code error detected');
              break;
            }
          }
        }
        
        // Also check response data for error codes related to postal code
        if (!isPostalCodeError && response.data != null) {
          if (response.data!.containsKey('setOrderShippingAddress')) {
            final resultData = response.data!['setOrderShippingAddress'];
            if (resultData is Map) {
              final errorCode = resultData['errorCode']?.toString().toLowerCase() ?? '';
              final errorMessage = resultData['message']?.toString().toLowerCase() ?? '';
              if (errorCode.contains('postal') || 
                  errorMessage.contains('postal') ||
                  errorCode.contains('postcode') ||
                  errorMessage.contains('postcode') ||
                  errorMessage.contains('invalid postal')) {
                isPostalCodeError = true;
                debugPrint('[Order] 🚫 Invalid postal code error detected in result');
              }
            }
          }
        }
      }

      // Show custom dialog for postal code errors
      if (isPostalCodeError) {
        debugPrint('[Order] ❌ Invalid postal code - showing custom error dialog');
        ErrorDialog.show(
          title: 'Postal Code Invalid',
          message: 'Kindly change the address',
          buttonText: 'OK',
          secondButtonText: 'Change Address',
          onSecondButtonPressed: () {
            Get.toNamed('/addresses');
          },
        );
        debugPrint('[Order] ========== SET SHIPPING ADDRESS FAILED (Invalid Postal Code) ==========');
        debugPrint('═══════════════════════════════════════════════════════════');
        return false;
      }

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to set shipping address')) {
        debugPrint('[Order] ❌ Response contained errors - shipping address not set');
        debugPrint('[Order] ========== SET SHIPPING ADDRESS FAILED ==========');
        debugPrint('═══════════════════════════════════════════════════════════');
        return false;
      }

      final result = response.parsedData?.setOrderShippingAddress;
      if (result != null) {
        final orderJson = result.toJson();
        debugPrint('[Order] ✅ Shipping address set successfully');
        debugPrint('[Order] Updated Order ID: ${orderJson['id']}');
        debugPrint('[Order] Updated Order Code: ${orderJson['code']}');
        debugPrint('[Order] Updated Order State: ${orderJson['state']}');
        
        // Check if shipping address is in the result
        if (orderJson.containsKey('shippingAddress') && orderJson['shippingAddress'] != null) {
          final shippingAddr = orderJson['shippingAddress'];
          debugPrint('[Order] Shipping Address in Order:');
          debugPrint('[Order]   - Full Name: ${shippingAddr['fullName'] ?? "N/A"}');
          debugPrint('[Order]   - Street Line 1: ${shippingAddr['streetLine1'] ?? "N/A"}');
          debugPrint('[Order]   - City: ${shippingAddr['city'] ?? "N/A"}');
          debugPrint('[Order]   - Postal Code: ${shippingAddr['postalCode'] ?? "N/A"}');
        } else {
          debugPrint('[Order] ⚠️ Warning: Shipping address not found in order response');
        }
        
        if (result is Mutation$SetShippingAddress$setOrderShippingAddress$$Order) {
          currentOrder.value = result;
          debugPrint('[Order] ========== SET SHIPPING ADDRESS SUCCESS ==========');
          debugPrint('═══════════════════════════════════════════════════════════');
          return true;
        }
      }

      debugPrint('[Order] ❌ No result in response - shipping address not set');
      debugPrint('[Order] ========== SET SHIPPING ADDRESS FAILED ==========');
      debugPrint('═══════════════════════════════════════════════════════════');
      return false;
    } catch (e, stackTrace) {
      debugPrint('[Order] ❌ Exception setting shipping address: $e');
      debugPrint('[Order] Stack trace: $stackTrace');
      debugPrint('[Order] ========== SET SHIPPING ADDRESS ERROR ==========');
      debugPrint('═══════════════════════════════════════════════════════════');
      handleException(e, customErrorMessage: 'Failed to set shipping address');
      return false;
    } finally {
      if (!skipLoading) {
        LoadingDialog.hide();
      }
      debugPrint('[Order] Loading state reset');
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

      // Don't show loading state for instructions - provides instant feedback
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
        // Refresh the active order to get updated customFields without showing loading
        await getActiveOrder(skipLoading: true);
debugPrint('[Order] Other instructions set successfully');
        return true;
      }

      return false;
    } catch (e) {
debugPrint('[Order] Set other instructions error: $e');
      handleException(e, customErrorMessage: 'Failed to set instructions');
      return false;
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
        paymentMethods.value = methods;
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

  /// Transition order to a specific state
  Future<bool> transitionToState(String targetState, {bool skipLoading = false}) async {
    try {
      if (!skipLoading) {
        utilityController.setLoadingState(true);
      }

      final response =
          await GraphqlService.client.value.mutate$TransitionOrderToState(
        Options$Mutation$TransitionOrderToState(
          variables: Variables$Mutation$TransitionOrderToState(
            state: targetState,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to transition order')) {
        return false;
      }

      final result = response.parsedData?.transitionOrderToState;
      if (result != null) {
        final resultJson = result.toJson();
        // Check if it's an error result
        if (resultJson.containsKey('errorCode')) {
debugPrint('[Order] Transition error: ${resultJson['message']} (${resultJson['errorCode']})');
          return false;
        }

        // If it's an Order, update current order
        if (result is Mutation$TransitionOrderToState$transitionOrderToState$$Order) {
          currentOrder.value = result;
debugPrint('[Order] Transitioned to $targetState');
          return true;
        }
      }

      return false;
    } catch (e) {
debugPrint('[Order] Transition error: $e');
      handleException(e, customErrorMessage: 'Failed to transition order');
      return false;
    } finally {
      if (!skipLoading) {
        utilityController.setLoadingState(false);
      }
    }
  }

  /// Transition to ArrangingPayment state
  /// Handles cases where order might be in "AddingItems" state
  Future<bool> transitionToArrangingPayment() async {
    try {
      // First, refresh to get current state
      await getActiveOrder(skipLoading: true);
      
      final currentState = currentOrder.value?.state;
debugPrint('[Order] Current order state: $currentState');
      
      // If already in ArrangingPayment, no need to transition
      if (currentState == 'ArrangingPayment') {
debugPrint('[Order] Already in ArrangingPayment state, skipping transition');
        return true;
      }
      
      // If in AddingItems, transition directly to ArrangingPayment (no Draft needed)
      if (currentState == 'AddingItems') {
debugPrint('[Order] Order is in AddingItems state, transitioning directly to ArrangingPayment...');
        // Use the generic transition method to go directly to ArrangingPayment
        final directTransitioned = await transitionToState('ArrangingPayment', skipLoading: true);
        if (directTransitioned) {
debugPrint('[Order] ✅ Successfully transitioned directly from AddingItems to ArrangingPayment');
          return true;
        } else {
debugPrint('[Order] ❌ Direct transition from AddingItems to ArrangingPayment failed');
          return false;
        }
      }

      // For other states, use the standard transition to ArrangingPayment
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
        // Check if it's an error result
        if (resultJson.containsKey('errorCode')) {
debugPrint('[Order] Transition to ArrangingPayment error: ${resultJson['message']} (${resultJson['errorCode']})');
          return false;
        }

        // If it's an Order, update current order
        if (result is Mutation$TransitionToArrangingPayment$transitionOrderToState$$Order) {
          currentOrder.value = result;
debugPrint('[Order] Transitioned to ArrangingPayment');
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

  /// Add payment to order
  Future<bool> addPayment({
    required String method,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      utilityController.setLoadingState(true);

debugPrint('[Order] Adding payment with method: $method');
debugPrint('[Order] Payment metadata: $metadata');

      // For online payments, don't pass metadata (use empty map)
      // For offline payments, pass metadata with total, payment_method, and payment_id
      final input = Input$PaymentInput(
        method: method,
        metadata: metadata ?? {}, // If null, use empty map (no metadata for online payments)
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
debugPrint(  '[Order] Payment error: ${resultJson['message']} (${resultJson['errorCode']})');
          return false;
        }

        // If it's an Order, update current order
        if (result is Mutation$AddPayment$addPaymentToOrder$$Order) {
          currentOrder.value = result;
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
  Future<Fragment$Cart?> getOrderByCode(String code) async {
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
        currentOrder.value = orderData; // Set the current order so UI can react to it
debugPrint('[Order] Order retrieved: ${orderData.code}');
        return orderData;
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
  Future<Mutation$GenerateRazorpayOrderId$generateRazorpayOrderId?> generateRazorpayOrderId(String orderId) async {
    try {
      utilityController.setLoadingState(true);

debugPrint('[Order] Generating Razorpay order for order ID: $orderId');

      final response =
          await GraphqlService.client.value.mutate$GenerateRazorpayOrderId(
        Options$Mutation$GenerateRazorpayOrderId(
          variables: Variables$Mutation$GenerateRazorpayOrderId(
            orderId: orderId,
          ),
        ),
      );

      // Check for GraphQL errors first
      if (response.hasException) {
        final exception = response.exception;
        String errorMessage = 'Failed to generate payment order';
        
        // Extract error message from GraphQL errors
        if (exception?.graphqlErrors.isNotEmpty == true) {
          final graphQLError = exception!.graphqlErrors.first;
          errorMessage = graphQLError.message;
debugPrint('[Order] Razorpay GraphQL Error: $errorMessage');
          
          // Check if it's a Razorpay-specific error
          if (errorMessage.contains('Razorpay') || 
              errorMessage.contains('razorpay') ||
              errorMessage.contains('Could not create')) {
            // Show user-friendly error message
            handleException(
              Exception(errorMessage),
              customErrorMessage: 'Payment gateway error: $errorMessage. Please try again or contact support.',
            );
          } else {
            handleException(
              Exception(errorMessage),
              customErrorMessage: errorMessage,
            );
          }
        } else if (exception != null && exception.linkException != null) {
debugPrint('[Order] Razorpay Link Exception: ${exception.linkException}');
          handleException(
            exception.linkException!,
            customErrorMessage: 'Network error. Please check your connection and try again.',
          );
        } else {
          handleException(
            Exception(exception.toString()),
            customErrorMessage: errorMessage,
          );
        }
        return null;
      }

      final result = response.parsedData?.generateRazorpayOrderId;
      if (result != null) {
        // Check if request was successful
        if (result.success == true && result.razorpayOrderId != null) {
debugPrint(  '[Order] ✅ Razorpay order created successfully: ${result.razorpayOrderId}');
          return result;
        } else {
          // Handle error case
          final errorMessage = result.errorMessage ?? 'Failed to create Razorpay order';
debugPrint('[Order] ❌ Razorpay order error: $errorMessage');
          
          // Show user-friendly error
          handleException(
            Exception(errorMessage),
            customErrorMessage: 'Payment setup failed: $errorMessage. Please try again or contact support.',
          );
          return null;
        }
      }

debugPrint('[Order] ⚠️ No valid response from Razorpay order generation');
      handleException(
        Exception('Invalid response from payment gateway'),
        customErrorMessage: 'Payment gateway returned an invalid response. Please try again.',
      );
      return null;
    } catch (e) {
debugPrint('[Order] ❌ Generate Razorpay order exception: $e');
      handleException(e,
          customErrorMessage: 'Failed to initialize payment. Please try again or contact support.');
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

        if (result is Mutation$TransitionToArrangingPayment$transitionOrderToState$$Order) {
          currentOrder.value = result;
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
    if (result is Fragment$ErrorResult) {
      error.value = result;
    }
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
