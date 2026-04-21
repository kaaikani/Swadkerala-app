import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import '../../graphql/order.graphql.dart';
import '../../graphql/cart.graphql.dart' as cart_graphql;
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../cart/Cartcontroller.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../banner/bannercontroller.dart';
import '../base_controller.dart';
import '../../utils/price_formatter.dart';
import '../../utils/logger.dart';
import '../../widgets/loading_dialog.dart';
import '../customer/customer_controller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class OrderController extends BaseController {
  Rx<Fragment$Cart?> currentOrder = Rx<Fragment$Cart?>(null);
  Rx<Fragment$ErrorResult?> error = Rx<Fragment$ErrorResult?>(null);
  final UtilityController utilityController = Get.find();

  /// When true, getEligibleShippingMethods and (via CustomerController) getActiveCustomer
  /// return early without calling APIs. Set during post-add-payment flow to avoid redundant calls.
  bool skipPostPaymentRefresh = false;

  /// Callback invoked when user returns from addresses page after address mismatch dialog.
  /// Set by checkout page to refresh data when user comes back.
  VoidCallback? onAddressMismatchReturn;

  RxList<Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled> shippingMethods = <Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled>[].obs;
  RxList<Query$GetEligiblePaymentMethods$eligiblePaymentMethods> paymentMethods = <Query$GetEligiblePaymentMethods$eligiblePaymentMethods>[].obs;
  Rx<Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled?> selectedShippingMethod = Rx<Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled?>(null);
  Rx<Query$GetEligiblePaymentMethods$eligiblePaymentMethods?> selectedPaymentMethod = Rx<Query$GetEligiblePaymentMethods$eligiblePaymentMethods?>(null);

  /// Get active order (cart)
  Future<bool> getActiveOrder({bool skipLoading = false}) async {
    try {
      Logger.logFunction(functionName: 'getActiveOrder', queryName: 'ActiveOrder');
      
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
        if (kDebugMode) {
          // debugPrint('[OrderController] getActiveOrder: hasOrder=true, code=${orderData.code}, state=${orderData.state}, linesCount=${orderData.lines.length}');
        }
        final orderJson = orderData.toJson();
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
              // ignore: unused_local_variable
              final variantData = line['productVariant'] as Map<String, dynamic>;
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
        final newOrder = orderData;
        final previousOrderId = currentOrder.value?.id;
        
        // If this is a new order (different ID) or order has no shipping lines, clear selected shipping method
        if (previousOrderId != null && previousOrderId != newOrder.id) {
          selectedShippingMethod.value = null;
          // Also reset loyalty points state for new order
          try {
            final bannerController = Get.find<BannerController>();
            bannerController.resetLoyaltyPoints();
          } catch (e) {
            // BannerController might not be initialized yet, ignore
          }
        } else if (newOrder.shippingLines.isEmpty && selectedShippingMethod.value != null) {
          selectedShippingMethod.value = null;
        } else if (newOrder.shippingLines.isNotEmpty && selectedShippingMethod.value != null) {
          // Verify the selected method is still applied to the order
          final isMethodStillApplied = newOrder.shippingLines.any((line) => 
            line.shippingMethod.id == selectedShippingMethod.value?.id);
          if (!isMethodStillApplied) {
            selectedShippingMethod.value = null;
          }
        }
        
        currentOrder.value = newOrder;
        return true;
      } else {
        if (kDebugMode) {
          // debugPrint('[OrderController] getActiveOrder: hasOrder=false (no active order)');
        }
        if (selectedShippingMethod.value != null) {
          selectedShippingMethod.value = null;
        }
      }

      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to load order', functionName: 'getActiveOrder');
      return false;
    } finally {
      if (!skipLoading) {
        utilityController.setLoadingState(false);
      }
    }
  }

  /// Remove item from cart
  Future<bool> removeOrderLine(String orderLineId) async {
    Logger.logFunction(functionName: 'removeOrderLine', mutationName: 'RemoveOrderLine');
    
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
        return false;
      }

      if (result is! Mutation$RemoveOrderLine$removeOrderLine$$Order) {
        // Suppress "does not contain an orderline with the id" error —
        // this is a race condition where the item was already removed
        final errorMsg = _readOrderMutationMessage(result) ?? '';
        if (errorMsg.toLowerCase().contains('does not contain an orderline')) {
          // debugPrint('[OrderController] Orderline already removed, refreshing cart');
          await getActiveOrder();
          return true;
        }
        _handleOrderMutationError(result, 'Failed to remove item');
        return false;
      }

      currentOrder.value = result;
      return true;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to remove item');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Remove all items from cart
  Future<bool> removeAllOrderLines() async {
    Logger.logFunction(functionName: 'removeAllOrderLines', mutationName: 'RemoveAllOrderLines');
    
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
        return false;
      }

      if (result is! Mutation$RemoveAllOrderLines$removeAllOrderLines$$Order) {
        _handleOrderMutationError(result, 'Failed to clear cart');
        return false;
      }

      currentOrder.value = result;
      return true;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to clear cart');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get eligible shipping methods
  Future<bool> getEligibleShippingMethods() async {
    if (skipPostPaymentRefresh) return false;
    try {
          Logger.logFunction(functionName: 'getEligibleShippingMethods');
    utilityController.setLoadingState(false);

      final options = Options$Query$GetEligibleShippingMethodsEnabled();
      final response = await GraphqlService.client.value
          .query$GetEligibleShippingMethodsEnabled(options);

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to load shipping methods')) {
        return false;
      }

      final methods = response.parsedData?.eligibleShippingMethodsEnabled;

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

  /// Get shipping price from calculator args
  /// The price is stored in calculator.args where name == "rate"
  int getShippingPrice(Query$GetEligibleShippingMethodsEnabled$eligibleShippingMethodsEnabled? method) {
    if (method == null) return 0;
    
    try {
      final rateArg = method.calculator.args.firstWhere(
        (arg) => arg.name == 'rate',
        orElse: () => throw Exception('Rate not found'),
      );
      return int.tryParse(rateArg.value) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Set shipping method
  Future<bool> setShippingMethod(String methodId, {bool skipIfAlreadySet = false}) async {
    Logger.logFunction(functionName: 'setShippingMethod', mutationName: 'SetShippingMethod');
    
    try {
      // If method is already set and skipIfAlreadySet is true, return early without loading
      if (skipIfAlreadySet && 
          selectedShippingMethod.value?.id == methodId &&
          currentOrder.value?.shippingLines.isNotEmpty == true) {
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



      final result = response.parsedData?.setOrderShippingMethod;
      if (result != null && result is Mutation$SetShippingMethod$setOrderShippingMethod$$Order) {
        currentOrder.value = result;
        selectedShippingMethod.value = shippingMethods.firstWhereOrNull((m) => m.id == methodId);
        // Sync cart controller so totalWithTax reflects the updated shipping cost
        try {
          final cartController = Get.find<CartController>();
          cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(result.toJson());
        } catch (_) {
          // CartController may not be registered yet
        }
        // Check if order needs shipping address, if so, set default shipping address
        // Note: Fragment$Cart doesn't include shippingAddress, so we check by trying to set it
        // The setShippingAddress will only succeed if address is needed
        try {
          final customerController = Get.find<CustomerController>();
          final defaultAddress = customerController.defaultAddress;
          
          if (defaultAddress != null) {
            // Try to set default shipping address (will only succeed if not already set)
              await setShippingAddress(
                fullName: defaultAddress.fullName ?? '',
                streetLine1: defaultAddress.streetLine1,
                streetLine2: defaultAddress.streetLine2,
                city: defaultAddress.city ?? '',
                postalCode: defaultAddress.postalCode ?? '',
                countryCode: defaultAddress.country.code,
                phoneNumber: defaultAddress.phoneNumber ?? '',
                province: null,
                skipLoading: true, // Don't show loading as shipping method already handled it
              );
          } else {
          }
        } catch (e) {
          // Don't fail the shipping method setting if address setting fails
        }
        
        return true;
      }

      return false;
    } catch (e) {
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
    Logger.logFunction(functionName: 'setShippingAddress', mutationName: 'SetShippingAddress');
    final order = currentOrder.value;
    if (order == null) {
      if (kDebugMode) debugPrint('[OrderController] setShippingAddress: SKIP (no currentOrder) -> return true');
      return true;
    }
    final state = order.state.toLowerCase();
    if (state != 'addingitems' && state != 'arrangingpayment') {
      if (kDebugMode) debugPrint('[OrderController] setShippingAddress: SKIP (state=$state, not AddingItems/ArrangingPayment) -> return true');
      return true;
    }
    // Debug: Log input parameters
    if (kDebugMode) {
      // debugPrint('[setShippingAddress] Input Data: {fullName: $fullName, streetLine1: $streetLine1, streetLine2: $streetLine2, city: $city, postalCode: $postalCode, countryCode: $countryCode, phoneNumber: $phoneNumber, province: $province}');
    }
    try {
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
      final response =
          await GraphqlService.client.value.mutate$SetShippingAddress(
        Options$Mutation$SetShippingAddress(
          variables: Variables$Mutation$SetShippingAddress(
            input: input,
          ),
        ),
      );
      
      // Debug: Log response data
      if (kDebugMode) {
        if (response.data != null) {
          // debugPrint('[setShippingAddress] Response Data: ${response.data}');
        }
        if (response.hasException) {
          // debugPrint('[setShippingAddress] Response Exception: ${response.exception}');
        }
      }
      // Detailed error logging before checking for errors
      if (response.hasException) {
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          final msg = response.exception!.graphqlErrors.first.message;
          if (kDebugMode) debugPrint('[OrderController] setShippingAddress: API error (dialog will show): $msg');
          for (int i = 0; i < response.exception!.graphqlErrors.length; i++) {
            final error = response.exception!.graphqlErrors[i];
            if (error.locations != null && error.locations!.isNotEmpty) {
            }
            if (error.path != null && error.path!.isNotEmpty) {
            }
          }
        }
        
        // Log link exception
        if (response.exception?.linkException != null) {
          final linkException = response.exception!.linkException;
          
          if (linkException is NetworkException) {
          } else if (linkException is ServerException) {
            if (linkException.parsedResponse != null) {
            }
          } else if (linkException is UnknownException) {
          }
        }
        
        // Log general exception
        if (response.exception != null) {
        }
      }
      
      // Log response data if available (for debugging)
      if (response.data != null) {
        if (response.data!.containsKey('setOrderShippingAddress')) {
          final resultData = response.data!['setOrderShippingAddress'];
          if (resultData is Map) {
            if (resultData.containsKey('__typename')) {
            }
            if (resultData.containsKey('errorCode')) {
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
              }
            }
          }
        }
      }

      // Show dialog for postal code errors
      if (isPostalCodeError) {
        // Close loading dialog first
        if (!skipLoading) {
          LoadingDialog.hide();
        }
        
        // Show address mismatch dialog
        _showAddressMismatchDialog();
        
        return false;
      }

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to set shipping address')) {
        return false;
      }

      final result = response.parsedData?.setOrderShippingAddress;
      if (result != null) {
        final orderJson = result.toJson();
        
        // Debug: Log parsed result
        if (kDebugMode) {
          // debugPrint('[setShippingAddress] Parsed Result: ${orderJson.toString()}');
          if (orderJson.containsKey('shippingAddress') && orderJson['shippingAddress'] != null) {
            // debugPrint('[setShippingAddress] Shipping Address in Result: ${orderJson['shippingAddress']}');
          }
        }
        
        // Check if shipping address is in the result
        if (orderJson.containsKey('shippingAddress') && orderJson['shippingAddress'] != null) {
          // ignore: unused_local_variable
          final _shippingAddr = orderJson['shippingAddress'];
        } else {
        }
        
        if (result is Mutation$SetShippingAddress$setOrderShippingAddress$$Order) {
          currentOrder.value = result;
          
          // Debug: Log success
          if (kDebugMode) {
            // debugPrint('[setShippingAddress] Success: Order updated with shipping address');
          }
          
          return true;
        }
      }
      
      // Debug: Log failure
      if (kDebugMode) {
        // debugPrint('[setShippingAddress] Failed: Result is null or not an Order type');
      }
      
      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to set shipping address', functionName: 'setShippingAddress');
      return false;
    } finally {
      if (!skipLoading) {
        LoadingDialog.hide();
      }
    }
  }

  /// Show address mismatch dialog when postal code error occurs
  void _showAddressMismatchDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        ),
        child: Container(
          padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_off,
                    size: ResponsiveUtils.rp(28),
                    color: AppColors.error,
                  ),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  Expanded(
                    child: Text(
                      'Address Mismatch',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
              Text(
                'Invalid postal code. Please change your address to continue.',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtils.sp(14),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await Get.toNamed('/addresses');
                      onAddressMismatchReturn?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.rp(20),
                        vertical: ResponsiveUtils.rp(12),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                      ),
                    ),
                    child: Text(
                      'Change Address',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  /// Set other instructions for the order
  Future<bool> setOtherInstruction(String instruction) async {
    try {
      if (currentOrder.value == null) {
        return false;
      }

      final orderId = currentOrder.value!.id;
      if (orderId.isEmpty) {
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
        return true;
      }

      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to set instructions');
      return false;
    }
  }

  /// Get eligible payment methods
  Future<bool> getEligiblePaymentMethods() async {
    try {
          Logger.logFunction(functionName: 'getEligiblePaymentMethods');
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
        return true;
      }

      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to load payment methods');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Transition order to a specific state
  Future<bool> transitionToState(String targetState, {bool skipLoading = false}) async {
    Logger.logFunction(functionName: 'transitionToState', mutationName: 'TransitionOrderToState');

    // debugPrint('[OrderController] transitionToState: START | targetState=$targetState | skipLoading=$skipLoading');
    // debugPrint('[OrderController] transitionToState: currentOrder BEFORE transition | code=${currentOrder.value?.code} | state=${currentOrder.value?.state} | id=${currentOrder.value?.id}');

    try {
      if (!skipLoading) {
        utilityController.setLoadingState(true);
      }

      // debugPrint('[OrderController] transitionToState: sending GraphQL mutation TransitionOrderToState(state: "$targetState")');
      final response =
          await GraphqlService.client.value.mutate$TransitionOrderToState(
        Options$Mutation$TransitionOrderToState(
          variables: Variables$Mutation$TransitionOrderToState(
            state: targetState,
          ),
        ),
      );

      // debugPrint('[OrderController] transitionToState: response received | hasException=${response.hasException} | parsedData=${response.parsedData != null ? "exists" : "null"}');

      // Log raw response data
      if (response.data != null) {
        // debugPrint('[OrderController] transitionToState: response.data keys=${response.data!.keys.toList()}');
        final transitionData = response.data!['transitionOrderToState'];
        if (transitionData is Map) {
          // debugPrint('[OrderController] transitionToState: response __typename=${transitionData['__typename']}');
          // debugPrint('[OrderController] transitionToState: response state=${transitionData['state']}');
          // debugPrint('[OrderController] transitionToState: response code=${transitionData['code']}');
          // debugPrint('[OrderController] transitionToState: response id=${transitionData['id']}');
          if (transitionData.containsKey('errorCode')) {
            // debugPrint('[OrderController] transitionToState: response errorCode=${transitionData['errorCode']}');
            // debugPrint('[OrderController] transitionToState: response message=${transitionData['message']}');
          }
          if (transitionData.containsKey('transitionError')) {
            // debugPrint('[OrderController] transitionToState: response transitionError=${transitionData['transitionError']}');
          }
        } else {
          // debugPrint('[OrderController] transitionToState: transitionOrderToState data=$transitionData');
        }
      } else {
        // debugPrint('[OrderController] transitionToState: response.data is NULL');
      }

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to transition order')) {
        // debugPrint('[OrderController] transitionToState: checkResponseForErrors=true (FAILED) | targetState=$targetState | currentOrder.state=${currentOrder.value?.state}');
        if (response.hasException) {
          // debugPrint('[OrderController] transitionToState: exception=${response.exception}');
          for (final e in response.exception?.graphqlErrors ?? []) {
            // debugPrint('[OrderController] transitionToState: graphqlError message=${e.message} path=${e.path} extensions=${e.extensions}');
          }
          if (response.exception?.linkException != null) {
            // debugPrint('[OrderController] transitionToState: linkException=${response.exception!.linkException}');
          }
        }
        return false;
      }

      final result = response.parsedData?.transitionOrderToState;
      // debugPrint('[OrderController] transitionToState: parsedData result type=${result?.runtimeType} | __typename=${result?.$__typename}');

      if (result != null) {
        final resultJson = result.toJson();
        // debugPrint('[OrderController] transitionToState: resultJson keys=${resultJson.keys.toList()}');
        // Check if it's an error result
        if (resultJson.containsKey('errorCode')) {
          // debugPrint('[OrderController] transitionToState: RESULT IS ERROR | targetState=$targetState | errorCode=${resultJson['errorCode']} | message=${resultJson['message']}');
          if (resultJson.containsKey('transitionError')) {
            // debugPrint('[OrderController] transitionToState: transitionError=${resultJson['transitionError']}');
          }
          return false;
        }

        // If it's an Order, update current order
        if (result is Mutation$TransitionOrderToState$transitionOrderToState$$Order) {
          // debugPrint('[OrderController] transitionToState: SUCCESS - result is Order | newState=${result.state} | code=${result.code} | id=${result.id}');
          currentOrder.value = result;
          return true;
        }
      }

      // debugPrint('[OrderController] transitionToState: UNEXPECTED result (not Order, not error) | targetState=$targetState | parsedData type=${result?.runtimeType}');
      return false;
    } catch (e, st) {
      // debugPrint('[OrderController] transitionToState: CATCH ERROR | e=$e');
      // debugPrint('[OrderController] transitionToState: stackTrace=${st.toString().split("\n").take(8).join("\n")}');
      handleException(e, customErrorMessage: 'Failed to transition order');
      return false;
    } finally {
      // debugPrint('[OrderController] transitionToState: FINALLY | currentOrder.state=${currentOrder.value?.state} | targetState=$targetState');
      if (!skipLoading) {
        utilityController.setLoadingState(false);
      }
    }
  }

  /// Transition to ArrangingPayment state
  /// Handles cases where order might be in "AddingItems" state
  Future<bool> transitionToArrangingPayment() async {
    // debugPrint('[OrderController] transitionToArrangingPayment: START');
    // debugPrint('[OrderController] transitionToArrangingPayment: currentOrder BEFORE | code=${currentOrder.value?.code} | state=${currentOrder.value?.state} | id=${currentOrder.value?.id} | total=${currentOrder.value?.totalWithTax}');

    try {
      // First, refresh to get current state
      // debugPrint('[OrderController] transitionToArrangingPayment: refreshing active order to get current state...');
      await getActiveOrder(skipLoading: true);

      final currentState = currentOrder.value?.state;
      // debugPrint('[OrderController] transitionToArrangingPayment: after refresh | state=$currentState | code=${currentOrder.value?.code} | id=${currentOrder.value?.id}');

      // Log order lines for debugging
      final order = currentOrder.value;
      if (order != null) {
        // debugPrint('[OrderController] transitionToArrangingPayment: order lines count=${order.lines.length} | totalQuantity=${order.totalQuantity} | totalWithTax=${order.totalWithTax} | shippingWithTax=${order.shippingWithTax}');
        for (int i = 0; i < order.lines.length; i++) {
          final line = order.lines[i];
          // debugPrint('[OrderController] transitionToArrangingPayment: line[$i] id=${line.id} | variant=${line.productVariant.name} | qty=${line.quantity} | stockLevel=${line.productVariant.stockLevel} | isAvailable=${line.isAvailable} | unitPriceWithTax=${line.unitPriceWithTax} | linePriceWithTax=${line.linePriceWithTax}');
          if (line.unavailableReason != null) {
            // debugPrint('[OrderController] transitionToArrangingPayment: line[$i] unavailableReason=${line.unavailableReason}');
          }
        }
        // debugPrint('[OrderController] transitionToArrangingPayment: shippingLines count=${order.shippingLines.length}');
        for (final sl in order.shippingLines) {
          // debugPrint('[OrderController] transitionToArrangingPayment: shippingLine method=${sl.shippingMethod.name} (${sl.shippingMethod.id}) | priceWithTax=${sl.priceWithTax}');
        }
        // debugPrint('[OrderController] transitionToArrangingPayment: validationStatus isValid=${order.validationStatus.isValid} | hasUnavailableItems=${order.validationStatus.hasUnavailableItems} | totalUnavailableItems=${order.validationStatus.totalUnavailableItems}');
        if (order.validationStatus.hasUnavailableItems) {
          for (final item in order.validationStatus.unavailableItems) {
            // debugPrint('[OrderController] transitionToArrangingPayment: unavailableItem lineId=${item.orderLineId} | product=${item.productName} | variant=${item.variantName} | reason=${item.reason}');
          }
        }
        // debugPrint('[OrderController] transitionToArrangingPayment: quantityLimitStatus hasViolations=${order.quantityLimitStatus.hasViolations} | totalViolations=${order.quantityLimitStatus.totalViolations}');
        if (order.quantityLimitStatus.hasViolations) {
          for (final v in order.quantityLimitStatus.violations) {
            // debugPrint('[OrderController] transitionToArrangingPayment: violation lineId=${v.orderLineId} | product=${v.productName} | currentQty=${v.currentQuantity} | maxQty=${v.maxQuantity} | reason=${v.reason}');
          }
        }
      }

      // If already in ArrangingPayment, no need to transition
      if (currentState == 'ArrangingPayment') {
        // debugPrint('[OrderController] transitionToArrangingPayment: ALREADY in ArrangingPayment, returning true');
        return true;
      }

      // If in AddingItems, transition directly to ArrangingPayment (no Draft needed)
      if (currentState == 'AddingItems') {
        // debugPrint('[OrderController] transitionToArrangingPayment: currentState=AddingItems, calling transitionToState(ArrangingPayment)');
        final directTransitioned = await transitionToState('ArrangingPayment', skipLoading: true);
        // debugPrint('[OrderController] transitionToArrangingPayment: transitionToState returned=$directTransitioned | currentOrder.state after=${currentOrder.value?.state}');
        if (directTransitioned) {
          return true;
        } else {
          // debugPrint('[OrderController] transitionToArrangingPayment: FAILED from AddingItems -> ArrangingPayment (see transitionToState logs above)');
          return false;
        }
      }

      // debugPrint('[OrderController] transitionToArrangingPayment: state=$currentState is not AddingItems, using dedicated TransitionToArrangingPayment mutation');

      // For other states, use the standard transition to ArrangingPayment
      utilityController.setLoadingState(true);

      final response =
          await GraphqlService.client.value.mutate$TransitionToArrangingPayment(
        Options$Mutation$TransitionToArrangingPayment(),
      );

      // debugPrint('[OrderController] transitionToArrangingPayment: mutation response | hasException=${response.hasException} | parsedData=${response.parsedData != null ? "exists" : "null"}');

      // Log raw response data
      if (response.data != null) {
        final transitionData = response.data!['transitionOrderToState'];
        if (transitionData is Map) {
          // debugPrint('[OrderController] transitionToArrangingPayment: response __typename=${transitionData['__typename']} | state=${transitionData['state']} | code=${transitionData['code']} | id=${transitionData['id']}');
          if (transitionData.containsKey('errorCode')) {
            // debugPrint('[OrderController] transitionToArrangingPayment: response errorCode=${transitionData['errorCode']} | message=${transitionData['message']}');
          }
          if (transitionData.containsKey('transitionError')) {
            // debugPrint('[OrderController] transitionToArrangingPayment: response transitionError=${transitionData['transitionError']}');
          }
        } else {
          // debugPrint('[OrderController] transitionToArrangingPayment: raw transitionOrderToState=$transitionData');
        }
      } else {
        // debugPrint('[OrderController] transitionToArrangingPayment: response.data is NULL');
      }

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to transition order')) {
        // debugPrint('[OrderController] transitionToArrangingPayment: checkResponseForErrors=true (FAILED) | currentOrder.state=${currentOrder.value?.state}');
        if (response.hasException) {
          // debugPrint('[OrderController] transitionToArrangingPayment: exception=${response.exception}');
          for (final e in response.exception?.graphqlErrors ?? []) {
            // debugPrint('[OrderController] transitionToArrangingPayment: graphqlError message=${e.message} | extensions=${e.extensions}');
          }
          if (response.exception?.linkException != null) {
            // debugPrint('[OrderController] transitionToArrangingPayment: linkException=${response.exception!.linkException}');
          }
        }
        return false;
      }

      final result = response.parsedData?.transitionOrderToState;
      // debugPrint('[OrderController] transitionToArrangingPayment: parsedData result type=${result?.runtimeType} | __typename=${result?.$__typename}');

      if (result != null) {
        final resultJson = result.toJson();
        // debugPrint('[OrderController] transitionToArrangingPayment: resultJson keys=${resultJson.keys.toList()}');
        // Check if it's an error result
        if (resultJson.containsKey('errorCode')) {
          // debugPrint('[OrderController] transitionToArrangingPayment: RESULT IS ERROR | errorCode=${resultJson['errorCode']} | message=${resultJson['message']}');
          if (resultJson.containsKey('transitionError')) {
            // debugPrint('[OrderController] transitionToArrangingPayment: transitionError=${resultJson['transitionError']}');
          }
          return false;
        }

        // If it's an Order, update current order
        if (result is Mutation$TransitionToArrangingPayment$transitionOrderToState$$Order) {
          // debugPrint('[OrderController] transitionToArrangingPayment: SUCCESS - result is Order | newState=${result.state} | code=${result.code} | id=${result.id}');
          currentOrder.value = result;
          return true;
        }
      }

      // debugPrint('[OrderController] transitionToArrangingPayment: UNEXPECTED result | currentOrder.state=${currentOrder.value?.state} | parsedData type=${result?.runtimeType}');
      return false;
    } catch (e, st) {
      // debugPrint('[OrderController] transitionToArrangingPayment: CATCH ERROR | e=$e');
      // debugPrint('[OrderController] transitionToArrangingPayment: stackTrace=${st.toString().split("\n").take(8).join("\n")}');
      handleException(e, customErrorMessage: 'Failed to transition order');
      return false;
    } finally {
      // debugPrint('[OrderController] transitionToArrangingPayment: FINALLY | currentOrder.state=${currentOrder.value?.state}');
      utilityController.setLoadingState(false);
    }
  }

  /// Add payment to order
  /// Returns a map with 'success' (bool) and 'errorMessage' (String?) keys
  Future<Map<String, dynamic>> addPayment({
    required String method,
    Map<String, dynamic>? metadata,
  }) async {
    Logger.logFunction(functionName: 'addPayment', mutationName: 'AddPayment');
    if (kDebugMode) {
      final order = currentOrder.value;
      // debugPrint('[OrderController] addPayment: method=$method, currentOrder.code=${order?.code}, currentOrder.state=${order?.state}, orderId=${order?.id}');
    }
    try {
      utilityController.setLoadingState(true);
      // For online payments (Razorpay), pass metadata with:
      // - razorpayPaymentId: Payment ID from Razorpay success response
      // - razorpayOrderId: Razorpay order ID (from response.orderId or empty string)
      // - razorpaySignature: Payment signature from Razorpay (for verification)
      // For offline payments, pass metadata with total, payment_method, and payment_id
      final input = Input$PaymentInput(
        method: method,
        metadata: metadata ?? {}, // If null, use empty map
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
        return {'success': false, 'errorMessage': 'Failed to add payment'};
      }

      final result = response.parsedData?.addPaymentToOrder;
      if (result != null) {
        // Check if it's an error result
        final resultJson = result.toJson();
        if (resultJson.containsKey('errorCode')) {
          final errorMessage = _readOrderMutationMessage(result) ?? 
                              resultJson['message']?.toString() ?? 
                              'Payment failed';
          if (kDebugMode) {
            // debugPrint('[OrderController] addPayment: success=false, errorCode=${resultJson['errorCode']}, message=$errorMessage');
          }
          return {'success': false, 'errorMessage': errorMessage};
        }

        if (result is Mutation$AddPayment$addPaymentToOrder$$Order) {
          currentOrder.value = result;
          if (kDebugMode) {
            // debugPrint('[OrderController] addPayment: success=true, result.code=${result.code}, result.state=${result.state}');
          }
          return {'success': true, 'errorMessage': null};
        }
      }
      if (kDebugMode) {
        // debugPrint('[OrderController] addPayment: success=false, unknown result');
      }
      return {'success': false, 'errorMessage': 'Unknown error occurred'};
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to add payment', functionName: 'addPayment');
      return {'success': false, 'errorMessage': 'Failed to add payment'};
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Get order by code
  /// Fetch order by code. When [silent] is true, errors are logged but no
  /// dialogs/snackbars are shown — useful when the caller handles errors itself
  /// (e.g. share invoice flow where a LoadingDialog is already visible).
  Future<Fragment$Cart?> getOrderByCode(String code, {bool silent = false}) async {
    try {
          Logger.logFunction(functionName: 'getOrderByCode');
    utilityController.setLoadingState(true);

      final response = await GraphqlService.client.value.query$GetOrderByCode(
        Options$Query$GetOrderByCode(
          variables: Variables$Query$GetOrderByCode(
            code: code,
          ),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (response.hasException && response.parsedData?.orderByCode == null) {
        if (!silent) {
          checkResponseForErrors(response,
              customErrorMessage: 'Failed to load order');
        }
        return null;
      }

      final orderData = response.parsedData?.orderByCode;
      if (orderData != null) {
        currentOrder.value = orderData; // Set the current order so UI can react to it
        return orderData;
      }

      currentOrder.value = null; // Clear if order not found
      return null;
    } catch (e) {
      currentOrder.value = null; // Clear on error
      if (!silent) {
        handleException(e, customErrorMessage: 'Failed to load order');
      }
      return null;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// FGenerate Razorpay Order ID from backend
  Future<Mutation$GenerateRazorpayOrderId$generateRazorpayOrderId?> generateRazorpayOrderId(String orderId) async {
        Logger.logFunction(functionName: 'generateRazorpayOrderId', mutationName: 'GenerateRazorpayOrderId');
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

      // Check for GraphQL errors first
      if (response.hasException) {
        final exception = response.exception;
        String errorMessage = 'Failed to generate payment order';
        
        // Extract error message from GraphQL errors
        if (exception?.graphqlErrors.isNotEmpty == true) {
          final graphQLError = exception!.graphqlErrors.first;
          errorMessage = graphQLError.message;
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
          return result;
        } else {
          // Handle error case
          final errorMessage = result.errorMessage ?? 'Failed to create Razorpay order';
          // Show user-friendly error
          handleException(
            Exception(errorMessage),
            customErrorMessage: 'Payment setup failed: $errorMessage. Please try again or contact support.',
          );
          return null;
        }
      }
      handleException(
        Exception('Invalid response from payment gateway'),
        customErrorMessage: 'Payment gateway returned an invalid response. Please try again.',
      );
      return null;
    } catch (e) {
      handleException(e,
          customErrorMessage: 'Failed to initialize payment. Please try again or contact support.');
      return null;
    } finally {
          Logger.logFunction(functionName: 'transitionToNextState', mutationName: 'TransitionToArrangingPayment');
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
        if (resultJson.containsKey('errorCode')) {
          return false;
        }

        if (result is Mutation$TransitionToArrangingPayment$transitionOrderToState$$Order) {
          currentOrder.value = result;
          return true;
        }
      }

      return false;
    } catch (e) {
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
  }

  void _handleOrderMutationError(dynamic result, String fallbackMessage) {
    // ignore: unused_local_variable
    final _code = result?.$__typename ?? 'UNKNOWN_ERROR';
    final message = _readOrderMutationMessage(result) ?? fallbackMessage;
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
