import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' show FetchPolicy;
import 'package:recipe.app/graphql/Customer.graphql.dart';
import '../../graphql/authenticate.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../../services/postal_code_service.dart';
import '../../utils/app_strings.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_dialog.dart';
import '../../services/analytics_service.dart';
import '../base_controller.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../banner/bannercontroller.dart';
import '../collection controller/collectioncontroller.dart';
import '../cart/Cartcontroller.dart';
import '../order/ordercontroller.dart';

class CustomerController extends BaseController {
  // Observable variables
  final Rx<Query$GetActiveCustomer$activeCustomer?> activeCustomer = Rx<Query$GetActiveCustomer$activeCustomer?>(null);
  final RxList<Query$GetActiveCustomer$activeCustomer$addresses> addresses = <Query$GetActiveCustomer$activeCustomer$addresses>[].obs;
  final RxList<Query$GetActiveCustomer$activeCustomer$orders$items> orders = <Query$GetActiveCustomer$activeCustomer$orders$items>[].obs;
  final RxBool isEditingProfile = false.obs;
  final RxString error = ''.obs;
  final RxString emailUpdateError = ''.obs; // Store email update error message
  final UtilityController utilityController = Get.find();
  
  // Pagination state
  final RxInt totalOrdersCount = 0.obs;
  final RxBool isLoadingMoreOrders = false.obs;
  final RxBool hasMoreOrders = true.obs;
  static const int ordersPerPage = 10;

  RxBool get isLoading => utilityController.isLoadingRx;

  // Profile editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize with current customer data if available
    if (activeCustomer.value != null) {
      _initializeProfileFields();
    }
  }

  /// Get active customer data
  /// [skipPostalCodeCheck] - if true, skip postal code/channel check to prevent unnecessary API calls
  Future<void> getActiveCustomer({bool skipPostalCodeCheck = false}) async {
    try {
      utilityController.setLoadingState(false);
      error.value = '';

debugPrint('[Customer] Fetching active customer...');

      final response =
          await GraphqlService.client.value.query$GetActiveCustomer();

      // Check if error contains "User not found" - handle specially
      bool isNetworkError = false;
      if (response.hasException) {
debugPrint('[Customer] Exception: ${response.exception}');

        final exception = response.exception;
        final exceptionString = exception?.toString() ?? '';
        final linkException = exception?.linkException;

        // Check for network/connection errors
        final linkExceptionStr = linkException?.toString() ?? '';
        isNetworkError = exceptionString.contains('Connection closed before full header was received') ||
            exceptionString.contains('Connection closed') ||
            exceptionString.contains('SocketException') ||
            exceptionString.contains('ClientException') ||
            exceptionString.contains('ServerException') ||
            exceptionString.contains('NetworkException') ||
            exceptionString.contains('TimeoutException') ||
            linkExceptionStr.contains('Connection closed') ||
            linkExceptionStr.contains('ClientException') ||
            linkExceptionStr.contains('ServerException');

        // Check if error contains "User not found"
        if (exceptionString.toLowerCase().contains('user not found') ||
            exceptionString.toLowerCase().contains('user not found with this email')) {
debugPrint(  '[Customer] User not found error detected - triggering logout');
          error.value = 'User not found. Please login again.';

          // Trigger logout and redirect to login
          await _handleUserNotFoundError();
          return;
        }

        // For network errors, don't show error dialog and don't logout
        if (isNetworkError) {
debugPrint('[Customer] Network error detected - not logging out: ${response.exception}');
          error.value = 'Network error. Please check your connection.';
          return; // Exit early, don't process data or logout
        }

        // Use base controller error handling for other errors
        if (checkResponseForErrors(response,
            customErrorMessage: 'Failed to load customer data')) {
          error.value = 'Failed to load customer data';
          return;
        }
      }

      final customerData = response.parsedData?.activeCustomer;
      if (customerData != null) {
        // Convert the GraphQL response to a Map
        final customerJson = customerData.toJson();
debugPrint('[Customer] Raw customer data: $customerJson');

        // Use the parsed data directly (it's already the correct type)
        activeCustomer.value = customerData;
        addresses.value = customerData.addresses ?? [];
        
        // Reset pagination state on initial load
        final ordersData = customerData.orders;
        orders.value = ordersData.items;
        totalOrdersCount.value = ordersData.totalItems;
        hasMoreOrders.value = orders.length < totalOrdersCount.value;

        _initializeProfileFields();

        // Set analytics user ID
        if (activeCustomer.value?.id != null) {
          await AnalyticsService().setUserId(activeCustomer.value!.id);
          await AnalyticsService().setUserProperty(
            name: 'email',
            value: activeCustomer.value!.emailAddress,
          );
        }

debugPrint(  '[Customer] Customer loaded: ${activeCustomer.value?.firstName} ${activeCustomer.value?.lastName}');
debugPrint('[Customer] Addresses: ${addresses.length}');
debugPrint('[Customer] Orders: ${orders.length}');

        // Check if postal code is in local storage, if not get from shipping address
        // Skip this check when called from loyalty points operations to prevent unnecessary channel fetches
        if (!skipPostalCodeCheck) {
        await checkAndSetPostalCodeFromShippingAddress();
        } else {
          debugPrint('[Customer] Skipping postal code/channel check (skipPostalCodeCheck=true)');
        }
      } else {
        orders.value = [];
        totalOrdersCount.value = 0;
        hasMoreOrders.value = false;
        error.value = 'No customer data found';
debugPrint('[Customer] No customer data found when this occurs clear cache and log out and go to login page');
        // Only logout if it's NOT a network error
        // Network errors should not trigger logout as they're temporary connection issues
        if (!isNetworkError) {
          // Clear cache and logout when customer data is null (only if not a network error)
          await handleCustomerDataNotFound();
        } else {
          debugPrint('[Customer] Network error detected - skipping logout to prevent unnecessary session termination');
          error.value = 'Network error. Please check your connection and try again.';
        }
      }
    } catch (e) {
debugPrint('[Customer] Error: $e');

      // Check if error contains "User not found"
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('user not found') ||
          errorString.contains('user not found with this email')) {
debugPrint(  '[Customer] User not found error detected in catch - triggering logout');
        error.value = 'User not found. Please login again.';

        // Trigger logout and redirect to login
        await _handleUserNotFoundError();
        return;
      }

      // Use base controller error handling
      handleException(e, customErrorMessage: 'Failed to load customer data');
      error.value = 'Failed to load customer data: $e';
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Load more orders with pagination
  Future<bool> loadMoreOrders() async {
    // Don't load if already loading or no more orders
    if (isLoadingMoreOrders.value || !hasMoreOrders.value) {
      return false;
    }

    try {
      isLoadingMoreOrders.value = true;
      final skip = orders.length;
      
      debugPrint('[Customer] Loading more orders: skip=$skip, take=$ordersPerPage');

      // Use raw GraphQL query until code generation runs
      const query = '''
        query GetCustomerOrders(\$skip: Int!, \$take: Int!) {
          activeCustomer {
            __typename
            ... on Customer {
              orders(options: { skip: \$skip, take: \$take }) {
                totalItems
                items {
                  id
                  currencyCode
                  orderPlacedAt
                  lines {
                    id
                    quantity
                    productVariant {
                      name
                    }
                    featuredAsset {
                      name
                      preview
                    }
                  }
                  active
                  discounts {
                    amount
                  }
                  code
                  state
                  customer {
                    firstName
                    lastName
                  }
                  shippingAddress {
                    country
                    city
                    phoneNumber
                    streetLine1
                    streetLine2
                    postalCode
                    fullName
                  }
                  surcharges {
                    price
                    priceWithTax
                  }
                  couponCodes
                  payments {
                    state
                    createdAt
                    method
                    amount
                    transactionId
                  }
                  totalQuantity
                  totalWithTax
                  billingAddress {
                    postalCode
                    streetLine2
                    fullName
                    city
                    phoneNumber
                    streetLine1
                  }
                  customFields {
                    loyaltyPointsUsed
                    loyaltyPointsEarned
                    otherInstructions
                  }
                }
              }
            }
          }
        }
      ''';

      final response = await GraphqlService.client.value.query(
        graphql.QueryOptions(
          document: graphql.gql(query),
          variables: {
            'skip': skip,
            'take': ordersPerPage,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (response.hasException) {
        final exception = response.exception;
        final exceptionString = exception.toString();
        
        // Ignore cache-related exceptions (they're not real errors)
        if (exceptionString.contains('CacheMissException') ||
            exceptionString.contains('cache.readQuery')) {
          debugPrint('[Customer] Cache miss (expected) - continuing with network data');
          // Continue processing if we have data despite cache miss
          if (response.data == null) {
            debugPrint('[Customer] No data available after cache miss');
            return false;
          }
        } else {
          // Only show error dialog for real errors, not cache misses
          debugPrint('[Customer] Error loading more orders: $exception');
          // Don't show error dialog for pagination - just fail silently
          return false;
        }
      }

      final data = response.data;
      if (data != null && data['activeCustomer'] != null) {
        final customerData = data['activeCustomer'];
        if (customerData != null && customerData['orders'] != null) {
          final ordersData = customerData['orders'];
          final newOrders = ordersData['items'] as List<dynamic>? ?? [];
          final totalItems = ordersData['totalItems'] as int? ?? 0;
          
          if (newOrders.isNotEmpty) {
            // Convert GraphQL orders to generated type
            final orderModels = newOrders.map((order) {
              return Query$GetActiveCustomer$activeCustomer$orders$items.fromJson(order as Map<String, dynamic>);
            }).toList();
            
            orders.addAll(orderModels);
            totalOrdersCount.value = totalItems;
            hasMoreOrders.value = orders.length < totalOrdersCount.value;
            
            debugPrint('[Customer] Loaded ${newOrders.length} more orders. Total: ${orders.length}/${totalOrdersCount.value}');
            return true;
          } else {
            hasMoreOrders.value = false;
            debugPrint('[Customer] No more orders to load');
            return false;
          }
        }
      }
      
      hasMoreOrders.value = false;
      return false;
    } catch (e) {
      debugPrint('[Customer] Exception loading more orders: $e');
      handleException(e, customErrorMessage: 'Failed to load more orders');
      return false;
    } finally {
      isLoadingMoreOrders.value = false;
    }
  }

  /// Update customer profile
  Future<bool> updateCustomer() async {
    try {
      utilityController.setLoadingState(true);
debugPrint('[Customer] Updating customer profile...');

      // Log the input values clearly
debugPrint(  '[Customer] Mutation input: firstName=${firstNameController.value}, lastName=${lastNameController.value}');

      // Prepare mutation input
      final input = Input$UpdateCustomerInput(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
      );

      // Execute mutation
      final response = await GraphqlService.client.value.mutate$UpdateCustomer(
        Options$Mutation$UpdateCustomer(
          variables: Variables$Mutation$UpdateCustomer(input: input),
          // Optionally disable cache for mutation
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      // Check for exceptions
      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to update profile')) {
        return false;
      }

      // Log full mutation response
debugPrint('[Customer] Mutation response: ${response.data}');

      final result = response.parsedData?.updateCustomer;

      if (result != null) {
        // Force fetch fresh customer data from network
        await getActiveCustomer();

        isEditingProfile.value = false;
debugPrint('[Customer] Profile updated successfully');

        // Log new customer data to confirm

        return true;
      }

debugPrint('[Customer] Mutation returned null result');
      return false;
    } catch (e) {
debugPrint('[Customer] Update error: $e');
      handleException(e, customErrorMessage: 'Failed to update profile');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Update customer email address using UpdateProfileEmail mutation
  Future<bool> updateCustomerEmail(String emailAddress) async {
    debugPrint('[CustomerController] ========== UPDATE EMAIL ID START ==========');
    debugPrint('[CustomerController] 📧 Email Update Request:');
    debugPrint('[CustomerController] - New Email: "$emailAddress"');
    
    // Get current customer data
    final customer = activeCustomer.value;
    if (customer == null) {
      debugPrint('[CustomerController] ❌ Customer is null, cannot update email');
      return false;
    }
    
    final currentEmail = customer.emailAddress;
    debugPrint('[CustomerController] - Current Email: "$currentEmail"');
    
    try {
      utilityController.setLoadingState(true);
      debugPrint('[CustomerController] 🔄 Setting loading state to true');
      debugPrint('[CustomerController] 📝 Using UpdateProfileEmail mutation');

      debugPrint('[CustomerController] 📋 Preparing UpdateProfileEmail variables');
      debugPrint('[CustomerController] - email: "$emailAddress"');

      // Execute UpdateProfileEmail mutation
      final response = await GraphqlService.client.value.mutate$UpdateProfileEmail(
        Options$Mutation$UpdateProfileEmail(
          variables: Variables$Mutation$UpdateProfileEmail(email: emailAddress),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      debugPrint('[CustomerController] 📥 GraphQL response received');
      debugPrint('[CustomerController] - Has Exception: ${response.hasException}');
      
      // Clear previous error
      emailUpdateError.value = '';
      
      if (response.hasException) {
        debugPrint('[CustomerController] ❌ GraphQL exception detected');
        debugPrint('[CustomerController] - Exception: ${response.exception}');
        
        // Extract error message from GraphQL errors
        String? errorMessage;
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          errorMessage = response.exception!.graphqlErrors.first.message;
          debugPrint('[CustomerController] - Error message: $errorMessage');
          
          // Store error message for UI display in dialog
          emailUpdateError.value = errorMessage;
        } else {
          // Fallback error message if no GraphQL error found
          emailUpdateError.value = 'Failed to update email. Please try again.';
        }
        
        // Don't call checkResponseForErrors here as it shows a dialog
        // We're handling error display in the dialog UI instead
        debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (FAILED) ==========');
        return false;
      }

      // Check for errors in response (but don't show dialog - we handle it in UI)
      // Only check if there are errors, but don't show dialog
      if (response.hasException || response.data == null) {
        debugPrint('[CustomerController] ❌ Response has errors, update failed');
        
        // Extract error message from GraphQL errors if available
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          final errorMessage = response.exception!.graphqlErrors.first.message;
          emailUpdateError.value = errorMessage;
          debugPrint('[CustomerController] - Error message: $errorMessage');
        } else {
          emailUpdateError.value = 'Failed to update email. Please try again.';
        }
        
        debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (FAILED) ==========');
        return false;
      }

      debugPrint('[CustomerController] ✅ GraphQL mutation successful');
      
      // Refresh customer data to verify update
      debugPrint('[CustomerController] 🔄 Refreshing customer data...');
      await getActiveCustomer();
      
      final updatedCustomer = activeCustomer.value;
      final updatedEmail = updatedCustomer?.emailAddress ?? 'N/A';
      debugPrint('[CustomerController] 📧 Email Verification:');
      debugPrint('[CustomerController] - Previous Email: "$currentEmail"');
      debugPrint('[CustomerController] - New Email: "$updatedEmail"');
      debugPrint('[CustomerController] - Update Successful: ${updatedEmail == emailAddress}');
      
      if (updatedEmail == emailAddress) {
        debugPrint('[CustomerController] ✅ Email ID updated successfully');
        debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (SUCCESS) ==========');
        return true;
      } else {
        debugPrint('[CustomerController] ⚠️ Email mismatch - Expected: "$emailAddress", Got: "$updatedEmail"');
        debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (WARNING) ==========');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[CustomerController] ❌ Exception occurred during email update');
      debugPrint('[CustomerController] - Error: $e');
      debugPrint('[CustomerController] - Stack Trace: $stackTrace');
      
      // Check if it's a GraphQL error with email-related message
      String? errorMessage;
      if (e is graphql.OperationException) {
        if (e.graphqlErrors.isNotEmpty) {
          errorMessage = e.graphqlErrors.first.message;
          debugPrint('[CustomerController] - GraphQL Error message: $errorMessage');
          // Store error message for UI display in dialog
          emailUpdateError.value = errorMessage;
          // Don't call handleException as we're showing error in dialog UI
          debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (ERROR - UI HANDLED) ==========');
          return false;
        }
      }
      
      // For other exceptions, show dialog via handleException
      debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (ERROR) ==========');
      handleException(e, customErrorMessage: 'Failed to update email');
      return false;
    } finally {
      utilityController.setLoadingState(false);
      debugPrint('[CustomerController] 🔄 Setting loading state to false');
    }
  }

  /// Update customer phone number using UpdateCustomer mutation
  /// Returns true on success, false on failure
  /// Throws exception with error message if phone number is already registered
  Future<bool> updateCustomerPhoneNumber(String phoneNumber) async {
    debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER START ==========');
    debugPrint('[CustomerController] 📱 Phone Number Update Request:');
    debugPrint('[CustomerController] - New Phone Number: "$phoneNumber"');
    
    // Get current customer data
    final customer = activeCustomer.value;
    if (customer == null) {
      debugPrint('[CustomerController] ❌ Customer is null, cannot update phone number');
      return false;
    }
    
    final currentPhone = customer.phoneNumber ?? 'N/A';
    debugPrint('[CustomerController] - Current Phone Number: "$currentPhone"');
    
    try {
      utilityController.setLoadingState(true);
      debugPrint('[CustomerController] 🔄 Setting loading state to true');
      debugPrint('[CustomerController] 📝 Using UpdateCustomer mutation');

      // Prepare UpdateCustomerInput with current data and new phone number
      final input = Input$UpdateCustomerInput(
        firstName: customer.firstName,
        lastName: customer.lastName,
        phoneNumber: phoneNumber,
      );

      debugPrint('[CustomerController] 📋 Preparing UpdateCustomerInput');
      debugPrint('[CustomerController] - firstName: "${customer.firstName}"');
      debugPrint('[CustomerController] - lastName: "${customer.lastName}"');
      debugPrint('[CustomerController] - phoneNumber: "$phoneNumber"');

      debugPrint('[CustomerController] 🚀 Executing UpdateCustomer mutation...');
      
      final response = await GraphqlService.client.value.mutate$UpdateCustomer(
        Options$Mutation$UpdateCustomer(
          variables: Variables$Mutation$UpdateCustomer(input: input),
        ),
      );

      debugPrint('[CustomerController] 📥 GraphQL response received');
      debugPrint('[CustomerController] - Has Exception: ${response.hasException}');
      
      if (response.hasException) {
        debugPrint('[CustomerController] ❌ GraphQL exception detected');
        debugPrint('[CustomerController] - Exception: ${response.exception}');
        
        // Extract error message from GraphQL errors
        String? errorMessage;
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          errorMessage = response.exception!.graphqlErrors.first.message;
          debugPrint('[CustomerController] - Error message: $errorMessage');
          
          // Check if it's the "already registered" error
          if (errorMessage.toLowerCase().contains('already registered') ||
              errorMessage.toLowerCase().contains('already exists')) {
            debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (ALREADY REGISTERED) ==========');
            throw Exception(errorMessage); // Throw exception with the error message
          }
        }
        
        debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (FAILED) ==========');
        return false;
      }

      // Check for errors in response
      if (checkResponseForErrors(response, customErrorMessage: 'Failed to update phone number')) {
        debugPrint('[CustomerController] ❌ Response has errors, update failed');
        
        // Extract error message from GraphQL errors
        String? errorMessage;
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          errorMessage = response.exception!.graphqlErrors.first.message;
          debugPrint('[CustomerController] - Error message: $errorMessage');
          
          // Check if it's the "already registered" error
          if (errorMessage.toLowerCase().contains('already registered') ||
              errorMessage.toLowerCase().contains('already exists')) {
            debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (ALREADY REGISTERED) ==========');
            throw Exception(errorMessage); // Throw exception with the error message
          }
        }
        
        debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (FAILED) ==========');
        return false;
      }

      debugPrint('[CustomerController] ✅ GraphQL mutation successful');
      
      // Refresh customer data to verify update
      debugPrint('[CustomerController] 🔄 Refreshing customer data...');
      await getActiveCustomer();
      
      final updatedCustomer = activeCustomer.value;
      final updatedPhone = updatedCustomer?.phoneNumber ?? 'N/A';
      debugPrint('[CustomerController] 📱 Phone Number Verification:');
      debugPrint('[CustomerController] - Previous Phone: "$currentPhone"');
      debugPrint('[CustomerController] - New Phone: "$updatedPhone"');
      debugPrint('[CustomerController] - Update Successful: ${updatedPhone == phoneNumber}');
      
      if (updatedPhone == phoneNumber) {
        debugPrint('[CustomerController] ✅ Phone number updated successfully');
        debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (SUCCESS) ==========');
        return true;
      } else {
        debugPrint('[CustomerController] ⚠️ Phone number mismatch - Expected: "$phoneNumber", Got: "$updatedPhone"');
        debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (WARNING) ==========');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[CustomerController] ❌ Exception occurred during phone number update');
      debugPrint('[CustomerController] - Error: $e');
      debugPrint('[CustomerController] - Stack Trace: $stackTrace');
      debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (ERROR) ==========');
      handleException(e, customErrorMessage: 'Failed to update phone number');
      return false;
    } finally {
      utilityController.setLoadingState(false);
      debugPrint('[CustomerController] 🔄 Setting loading state to false');
    }
  }

  /// Create new address
  Future<bool> createAddress(Query$GetActiveCustomer$activeCustomer$addresses address, {String? province}) async {
    try {
      LoadingDialog.show(message: 'Please wait');

debugPrint('[Customer] Creating address...');
      debugPrint('[Customer] Province: ${province ?? "null"}');

      final input = Input$CreateAddressInput(
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2,
        city: address.city,
        province: province?.trim().isEmpty == true ? null : province,
        postalCode: address.postalCode,
        countryCode: address.country.code,
        phoneNumber: address.phoneNumber,
        defaultShippingAddress: address.defaultShippingAddress ?? false,
        defaultBillingAddress: address.defaultBillingAddress ?? false,
      );

      final response =
          await GraphqlService.client.value.mutate$CreateCustomerAddress(
        Options$Mutation$CreateCustomerAddress(
          variables: Variables$Mutation$CreateCustomerAddress(input: input),
        ),
      );

      // Hide loading dialog first before checking for errors
      // This ensures error dialog can be displayed properly
      LoadingDialog.hide();

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to create address')) {
        return false;
      }

      final result = response.parsedData?.createCustomerAddress;
      if (result != null) {
        // Refresh customer data to get updated addresses
        await getActiveCustomer();
        // Force UI refresh
        addresses.refresh();
        
        // If this is the default shipping address, update the order's shipping address
        if (address.defaultShippingAddress == true) {
          try {
            final orderController = Get.find<OrderController>();
            final activeOrder = orderController.currentOrder.value;
            
            // Only set shipping address if there's an active order
            if (activeOrder != null) {
              debugPrint('[Customer] New default shipping address created - updating order shipping address');
              await orderController.setShippingAddress(
                fullName: address.fullName ?? '',
                streetLine1: address.streetLine1,
                streetLine2: address.streetLine2,
                city: address.city ?? '',
                postalCode: address.postalCode ?? '',
                countryCode: address.country.code,
                phoneNumber: address.phoneNumber ?? '',
                province: province,
                skipLoading: true, // Don't show loading dialog as address creation already handled it
              );
              debugPrint('[Customer] ✅ Order shipping address updated successfully');
            } else {
              debugPrint('[Customer] No active order - skipping shipping address update');
            }
          } catch (e) {
            debugPrint('[Customer] Error updating order shipping address: $e');
            // Don't fail the address creation if order update fails
          }
        }
        
debugPrint('[Customer] Address created successfully');
        return true;
      }

      return false;
    } catch (e) {
debugPrint('[Customer] Create address error: $e');
      LoadingDialog.hide(); // Hide loading dialog before showing error
      handleException(e, customErrorMessage: 'Failed to create address');
      return false;
    }
  }

  /// Update existing address
  Future<bool> updateAddress(Query$GetActiveCustomer$activeCustomer$addresses address, {bool skipLoading = true, String? province, bool skipRefresh = false}) async {
    try {
      // Don't show loading dialog by default - only show on error if needed
      debugPrint('[Customer] Updating address...');

      final input = Input$UpdateAddressInput(
        id: address.id,
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2,
        city: address.city,
        province: province,
        postalCode: address.postalCode,
        countryCode: address.country.code,
        phoneNumber: address.phoneNumber,
        defaultShippingAddress: address.defaultShippingAddress ?? false,
        defaultBillingAddress: address.defaultBillingAddress ?? false,
      );

      debugPrint('[Customer] Address update input:');
      debugPrint('[Customer]   - ID: ${address.id}');
      debugPrint('[Customer]   - Full Name: ${address.fullName}');
      debugPrint('[Customer]   - Default Shipping: ${address.defaultShippingAddress ?? false}');
      debugPrint('[Customer]   - Default Billing: ${address.defaultBillingAddress ?? false}');
      
      final response =
          await GraphqlService.client.value.mutate$UpdateCustomerAddress(
        Options$Mutation$UpdateCustomerAddress(
          variables: Variables$Mutation$UpdateCustomerAddress(input: input),
        ),
      );

      debugPrint('[Customer] GraphQL response received: ${response.data != null ? "Data present" : "No data"}');
      debugPrint('[Customer] Response has exception: ${response.hasException}');
      
      if (response.hasException) {
        debugPrint('[Customer] ⚠️ EXCEPTION IN UPDATE ADDRESS RESPONSE');
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          debugPrint('[Customer] ──── GraphQL Errors ────');
          for (int i = 0; i < response.exception!.graphqlErrors.length; i++) {
            final error = response.exception!.graphqlErrors[i];
            debugPrint('[Customer] Error ${i + 1}: ${error.message}');
            debugPrint('[Customer]   Extensions: ${error.extensions}');
          }
        }
        if (response.exception?.linkException != null) {
          debugPrint('[Customer] ──── Link Exception ────');
          debugPrint('[Customer] Type: ${response.exception!.linkException.runtimeType}');
          debugPrint('[Customer] Message: ${response.exception!.linkException.toString()}');
        }
      }

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to update address')) {
        debugPrint('[Customer] ❌ Address update failed - checkResponseForErrors returned true');
        // Don't show loading dialog - error dialog will be shown by checkResponseForErrors
        return false;
      }

      final result = response.parsedData?.updateCustomerAddress;
      debugPrint('[Customer] Update result: ${result != null ? "Result present" : "Result is null"}');
      
      if (result != null) {
        debugPrint('[Customer] Result type: ${result.runtimeType}');
        // Refresh customer data to get updated addresses (unless skipRefresh is true)
        if (!skipRefresh) {
        await getActiveCustomer();
        // Force UI refresh
        addresses.refresh();
        }
        
        // If this is the default shipping address, update the order's shipping address
        if (address.defaultShippingAddress == true) {
          try {
            final orderController = Get.find<OrderController>();
            final activeOrder = orderController.currentOrder.value;
            
            // Only set shipping address if there's an active order
            if (activeOrder != null) {
              debugPrint('[Customer] Default shipping address changed - updating order shipping address');
              await orderController.setShippingAddress(
                fullName: address.fullName ?? '',
                streetLine1: address.streetLine1,
                streetLine2: address.streetLine2,
                city: address.city ?? '',
                postalCode: address.postalCode ?? '',
                countryCode: address.country.code,
                phoneNumber: address.phoneNumber ?? '',
                province: province,
                skipLoading: true, // Don't show loading dialog as address update already handled it
              );
              debugPrint('[Customer] ✅ Order shipping address updated successfully');
            } else {
              debugPrint('[Customer] No active order - skipping shipping address update');
            }
          } catch (e) {
            debugPrint('[Customer] Error updating order shipping address: $e');
            // Don't fail the address update if order update fails
          }
        }
        
        debugPrint('[Customer] ✅ Address updated successfully');
        return true;
      }

      debugPrint('[Customer] ❌ Address update failed - result is null');
      if (response.data != null) {
        debugPrint('[Customer] Response data keys: ${response.data!.keys}');
        if (response.data!.containsKey('updateCustomerAddress')) {
          final updateResult = response.data!['updateCustomerAddress'];
          debugPrint('[Customer] updateCustomerAddress in data: $updateResult');
          if (updateResult is Map) {
            debugPrint('[Customer] Result keys: ${updateResult.keys}');
            if (updateResult.containsKey('__typename')) {
              debugPrint('[Customer] Result typename: ${updateResult['__typename']}');
            }
            if (updateResult.containsKey('errorCode')) {
              debugPrint('[Customer] ⚠️ Error in result: ${updateResult['errorCode']} - ${updateResult['message']}');
            }
          }
        }
      }
      // Don't show loading dialog - error will be handled by error dialog
      return false;
    } catch (e) {
      debugPrint('[Customer] Update address error: $e');
      // Don't show loading dialog - error dialog will be shown by handleException
      handleException(e, customErrorMessage: 'Failed to update address');
      return false;
    } finally {
      if (!skipLoading) {
        LoadingDialog.hide();
      }
    }
  }

  /// Delete address
  Future<bool> deleteAddress(String addressId) async {
    try {
      utilityController.setLoadingState(true);

debugPrint('[Customer] Deleting address: $addressId');

      final response =
          await GraphqlService.client.value.mutate$DeleteCustomerAddress(
        Options$Mutation$DeleteCustomerAddress(
          variables: Variables$Mutation$DeleteCustomerAddress(id: addressId),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to delete address')) {
        return false;
      }

      final result = response.parsedData?.deleteCustomerAddress;
      if (result?.success == true) {
        // Refresh customer data to get updated addresses
        await getActiveCustomer();
        // Force UI refresh
        addresses.refresh();
debugPrint('[Customer] Address deleted successfully');
        return true;
      }

      return false;
    } catch (e) {
debugPrint('[Customer] Delete address error: $e');
      handleException(e, customErrorMessage: 'Failed to delete address');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Toggle profile editing mode
  Future<void> toggleEditProfile() async {
    isEditingProfile.value = !isEditingProfile.value;
    if (isEditingProfile.value) {
      _initializeProfileFields();
    }
  }

  /// Update phone number

  /// Initialize profile fields with current customer data
  void _initializeProfileFields() {
    if (activeCustomer.value != null) {
      firstNameController.text = activeCustomer.value!.firstName;
      lastNameController.text = activeCustomer.value!.lastName;
    }
  }

  /// Force refresh addresses list
  void refreshAddresses() {
    addresses.refresh();
    // Also trigger a rebuild of the UI
    update();
  }

  /// Handle user not found error - logout and redirect
  Future<void> _handleUserNotFoundError() async {
    try {
debugPrint('[Customer] Handling user not found error...');

      // Clear local data immediately
      activeCustomer.value = null;
      addresses.clear();
      orders.clear();
      isEditingProfile.value = false;

      // Clear authentication tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');

      // Show message to user
      ErrorDialog.show(
        title: AppStrings.sessionExpired,
        message: AppStrings.userNotFoundLoginAgain,
      );

      // Navigate to login page
      Get.offAllNamed('/login');

debugPrint('[Customer] User logged out due to user not found error');
    } catch (e) {
debugPrint('[Customer] Error handling user not found: $e');
      // Still navigate to login even if cleanup fails
      Get.offAllNamed('/login');
    }
  }

  /// Handle customer data not found - clear cache and logout
  /// This method is public so other controllers can call it
  Future<void> handleCustomerDataNotFound() async {
    try {
debugPrint('[Customer] Handling customer data not found - clearing cache and logging out...');

      // Clear local data immediately
      activeCustomer.value = null;
      addresses.clear();
      orders.clear();
      isEditingProfile.value = false;

      // Clear authentication tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');

      // Show message to user
      ErrorDialog.show(
        title: AppStrings.sessionExpired,
        message: AppStrings.noCustomerDataLoginAgain,
      );

      // Navigate to login page
      Get.offAllNamed('/login');

debugPrint('[Customer] User logged out due to customer data not found');
    } catch (e) {
debugPrint('[Customer] Error handling customer data not found: $e');
      // Still navigate to login even if cleanup fails
      Get.offAllNamed('/login');
    }
  }

  /// Logout customer
  Future<void> logout() async {
    try {
debugPrint('[Customer] Logging out...');

      final response = await GraphqlService.client.value.mutate$LogoutUser(
        Options$Mutation$LogoutUser(),
      );

      // Don't show error dialog for logout - just log it
      if (response.hasException) {
debugPrint('[Customer] Logout exception: ${response.exception}');
      }

      // Clear local data
      activeCustomer.value = null;
      addresses.clear();
      orders.clear();
      isEditingProfile.value = false;

      // Clear authentication tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');

      // Navigate to login
      Get.offAllNamed('/login');

debugPrint('[Customer] Logged out successfully');
    } catch (e) {
debugPrint('[Customer] Logout error: $e');
      // Still navigate to login even if logout fails
      Get.offAllNamed('/login');
    }
  }

  /// Get loyalty points
  int get loyaltyPoints =>
      activeCustomer.value?.customFields?.loyaltyPointsAvailable ?? 0;

  /// Get total orders
  int get totalOrders => orders.length;

  /// Get default address
  Query$GetActiveCustomer$activeCustomer$addresses? get defaultAddress {
    return addresses
        .firstWhereOrNull((address) => address.defaultShippingAddress ?? false);
  }

  final GetStorage _storage = GetStorage();
  final PostalCodeService _postalCodeService = PostalCodeService();

  /// Search postal codes by pincode
  Future<List<PostalCodeData>> searchPostalCodes(String pincode) async {
    return await _postalCodeService.searchPostalCode(pincode);
  }

  /// Switch channel based on postal code
  /// If city is found in the channel and is available, use that channel
  /// If not available, show dialog
  Future<bool> switchChannelByPostalCode(String postalCode, {String? city, bool showLoading = true}) async {
    try {
      if (showLoading) {
        LoadingDialog.show(message: 'Checking availability...');
      }
      final channelToken = GraphqlService.channelToken;
      debugPrint('[Customer] Checking channel availability for postal code: $postalCode');
      debugPrint('[Customer] Channel token: ${channelToken.isNotEmpty ? channelToken : 'NOT SET'}');

      final response = await GraphqlService.client.value.query$GetAvailableChannels(
        Options$Query$GetAvailableChannels(
          variables: Variables$Query$GetAvailableChannels(postalCode: postalCode),
        ),
      );

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to get available channels')) {
        if (showLoading) {
          LoadingDialog.hide();
        }
        return false;
      }

      final channels = response.parsedData?.getAvailableChannels ?? [];
      debugPrint('[Customer] ========== CHANNEL AVAILABILITY CHECK ==========');
      debugPrint('[Customer] Found ${channels.length} channels for postal code: $postalCode');

      if (channels.isEmpty) {
        debugPrint('[Customer] No channels returned from API');
        if (showLoading) {
          LoadingDialog.hide();
          ErrorDialog.show(
            title: 'Service Not Available',
            message: 'Service is not available for this location.',
          );
        }
        return false;
      }

      // Debug: Print all channels received
      debugPrint('[Customer] All channels received:');
      for (int i = 0; i < channels.length; i++) {
        final channel = channels[i];
        debugPrint('[Customer]   Channel ${i + 1}:');
        debugPrint('[Customer]     - ID: ${channel.id}');
        debugPrint('[Customer]     - Code: ${channel.code}');
        debugPrint('[Customer]     - Name: ${channel.name}');
        debugPrint('[Customer]     - Type: ${channel.type}');
        debugPrint('[Customer]     - isAvailable: ${channel.isAvailable}');
        debugPrint('[Customer]     - Message: ${channel.message ?? "null"}');
        debugPrint('[Customer]     - Token: ${channel.token ?? "null"}');
      }

      // Debug: Check enum comparison
      debugPrint('[Customer] Checking enum types:');
      final cityEnum = Enum$ChannelType.CITY;
      debugPrint('[Customer]   Enum\$ChannelType.CITY value: $cityEnum');
      debugPrint('[Customer]   Enum\$ChannelType.CITY toString: ${cityEnum.toString()}');
      
      // Filter for CITY type channels
      final cityChannels = <Query$GetAvailableChannels$getAvailableChannels>[];
      for (final channel in channels) {
        debugPrint('[Customer]   Comparing channel ${channel.code}:');
        debugPrint('[Customer]     - channel.type: ${channel.type}');
        debugPrint('[Customer]     - channel.type.toString(): ${channel.type.toString()}');
        debugPrint('[Customer]     - channel.type == Enum\$ChannelType.CITY: ${channel.type == cityEnum}');
        debugPrint('[Customer]     - channel.type.runtimeType: ${channel.type.runtimeType}');
        debugPrint('[Customer]     - cityEnum.runtimeType: ${cityEnum.runtimeType}');
        
        if (channel.type == Enum$ChannelType.CITY) {
          cityChannels.add(channel);
          debugPrint('[Customer]     - ✓ MATCH: Added to cityChannels');
        } else {
          debugPrint('[Customer]     - ✗ NO MATCH: Not a CITY channel');
        }
      }
      debugPrint('[Customer] Found ${cityChannels.length} CITY type channel(s)');

      // Debug: Print CITY channels
      if (cityChannels.isNotEmpty) {
        debugPrint('[Customer] CITY channels:');
        for (int i = 0; i < cityChannels.length; i++) {
          final channel = cityChannels[i];
          debugPrint('[Customer]   CITY ${i + 1}: ${channel.code} (${channel.name}) - isAvailable: ${channel.isAvailable}');
        }
      }

      // Filter for CITY type channels with isAvailable == true
      final availableCityChannels = channels.where(
        (channel) => channel.type == Enum$ChannelType.CITY && 
                     channel.isAvailable == true,
      ).toList();

      debugPrint('[Customer] Found ${availableCityChannels.length} available CITY channel(s) (type == CITY && isAvailable == true)');
      
      // Debug: Print available CITY channels
      if (availableCityChannels.isNotEmpty) {
        debugPrint('[Customer] Available CITY channels:');
        for (int i = 0; i < availableCityChannels.length; i++) {
          final channel = availableCityChannels[i];
          debugPrint('[Customer]   Available CITY ${i + 1}: ${channel.code} (${channel.name})');
        }
      } else {
        debugPrint('[Customer] No available CITY channels found - checking why:');
        if (cityChannels.isEmpty) {
          debugPrint('[Customer]   - Reason: No CITY type channels found at all');
        } else {
          debugPrint('[Customer]   - Reason: CITY channels exist but none have isAvailable == true');
          for (final cityChannel in cityChannels) {
            debugPrint('[Customer]     - ${cityChannel.code}: isAvailable = ${cityChannel.isAvailable}');
          }
        }
      }

      // Check if there are any available CITY channels at all
      if (availableCityChannels.isEmpty) {
        debugPrint('[Customer] No available CITY channels found');
        if (showLoading) {
          LoadingDialog.hide();
          ErrorDialog.show(
            title: 'Service Not Available',
            message: 'Service is not available for this location.',
          );
        }
        return false;
      }

      // If city is provided, try to find matching CITY channel
      Query$GetAvailableChannels$getAvailableChannels? selectedChannel;
      
      if (city != null && city.isNotEmpty) {
        debugPrint('[Customer] Looking for CITY channel matching city: $city');
        
        // Find CITY channel matching the city name
        selectedChannel = availableCityChannels.firstWhereOrNull(
          (channel) => channel.code.toLowerCase().contains(city.toLowerCase()) ||
                       channel.name.toLowerCase().contains(city.toLowerCase()) ||
                       channel.name.toLowerCase() == city.toLowerCase(),
        );
        
        if (selectedChannel != null) {
          debugPrint('[Customer] Found matching available CITY channel: ${selectedChannel.code}');
        } else {
          // No city match found, but we have available CITY channels, use the first one
          debugPrint('[Customer] No CITY channel found matching city: $city, using first available CITY channel');
          selectedChannel = availableCityChannels.first;
          debugPrint('[Customer] Using first available CITY channel: ${selectedChannel.code}');
        }
      } else {
        // If no city provided, use first available CITY channel
        selectedChannel = availableCityChannels.first;
        debugPrint('[Customer] Using first available CITY channel: ${selectedChannel.code}');
      }

      debugPrint('[Customer] Selected channel: ${selectedChannel.code} (${selectedChannel.name})');
      debugPrint('[Customer] Channel type: ${selectedChannel.type}');
      debugPrint('[Customer] Channel is available: ${selectedChannel.isAvailable}');

      // Save channel token and postal code
      await _storage.write('channel_code', selectedChannel.code);
      await _storage.write('channel_token', selectedChannel.token ?? '');
      await _storage.write('channel_name', selectedChannel.name);
      await _storage.write('channel_type', selectedChannel.type.toString());
      await _storage.write('postal_code', postalCode);
      
      if (selectedChannel.token != null && selectedChannel.token!.isNotEmpty) {
        await GraphqlService.setToken(key: 'channel', token: selectedChannel.token!);
      }

      debugPrint('[Customer] Channel switched successfully');
      debugPrint('[Customer] Saved postal code: $postalCode');
      
      // Refresh all data after channel change
      debugPrint('[Customer] Refreshing all data after channel change...');
      await refreshAllDataAfterChannelChange();
      
      // Force UI refresh by updating reactive variables
      // This ensures the UI rebuilds when channel token changes
      debugPrint('[Customer] Forcing UI refresh after channel change...');
      await Future.delayed(Duration(milliseconds: 100)); // Small delay to ensure storage is written
      
      // Hide loading dialog before returning success
      if (showLoading) {
        LoadingDialog.hide();
      }
      
      return true;
    } catch (e) {
      if (showLoading) {
        LoadingDialog.hide();
      }
      debugPrint('[Customer] Error switching channel: $e');
      handleException(e, customErrorMessage: 'Failed to switch channel');
      return false;
    }
  }

  /// Check if postal code has valid available channels (without showing dialogs)
  Future<bool> hasValidPostalCode(String postalCode) async {
    try {
      final channels = await getAvailableChannels(postalCode);
      if (channels.isEmpty) {
        return false;
      }
      
      // Check if there are any available CITY type channels
      final availableCityChannels = channels.where(
        (channel) => channel.type == Enum$ChannelType.CITY && 
                     channel.isAvailable == true,
      ).toList();
      
      return availableCityChannels.isNotEmpty;
    } catch (e) {
      debugPrint('[Customer] Error checking postal code validity: $e');
      return false;
    }
  }

  /// Get available channels for a postal code
  Future<List<Query$GetAvailableChannels$getAvailableChannels>> getAvailableChannels(String postalCode) async {
    try {
      debugPrint('[Customer] ========== FETCHING AVAILABLE CHANNELS ==========');
      debugPrint('[Customer] Postal code: $postalCode');
      debugPrint('[Customer] GraphQL client status: Available');
      
      // Check channel token before making query
      final channelToken = GraphqlService.channelToken;
      final storedChannelToken = _storage.read('channel_token');
      debugPrint('[Customer] Current channel token in GraphQL service: $channelToken');
      debugPrint('[Customer] Stored channel token: ${storedChannelToken ?? "null"}');
      
      debugPrint('[Customer] Executing GraphQL query: getAvailableChannels');
      debugPrint('[Customer] Query variables: {postalCode: "$postalCode"}');

      final response = await GraphqlService.client.value.query$GetAvailableChannels(
        Options$Query$GetAvailableChannels(
          variables: Variables$Query$GetAvailableChannels(postalCode: postalCode),
        ),
      );

      debugPrint('[Customer] ========== GRAPHQL RESPONSE RECEIVED ==========');
      debugPrint('[Customer] Response has exception: ${response.hasException}');
      debugPrint('[Customer] Response has data: ${response.data != null}');
      debugPrint('[Customer] Parsed data is null: ${response.parsedData == null}');
      
      if (response.hasException) {
        debugPrint('[Customer] ⚠️ GraphQL Exception Details:');
        debugPrint('[Customer] Exception: ${response.exception}');
        if (response.exception?.linkException != null) {
          debugPrint('[Customer] Link Exception: ${response.exception?.linkException}');
        }
        if (response.exception?.graphqlErrors != null) {
          debugPrint('[Customer] GraphQL Errors: ${response.exception?.graphqlErrors}');
        }
      }

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to get available channels')) {
        debugPrint('[Customer] ❌ Response contains errors, returning empty list');
        return [];
      }

      final channels = response.parsedData?.getAvailableChannels ?? [];
      debugPrint('[Customer] ========== CHANNELS FETCHED SUCCESSFULLY ==========');
      debugPrint('[Customer] Total channels found: ${channels.length}');
      
      if (channels.isNotEmpty) {
        debugPrint('[Customer] ──── CHANNELS LIST ────');
        for (int i = 0; i < channels.length; i++) {
          final channel = channels[i];
          debugPrint('[Customer] Channel ${i + 1}:');
          debugPrint('[Customer]   - ID: ${channel.id}');
          debugPrint('[Customer]   - Code: ${channel.code}');
          debugPrint('[Customer]   - Name: ${channel.name}');
          debugPrint('[Customer]   - Token: ${channel.token ?? "null"}');
          debugPrint('[Customer]   - Type: ${channel.type}');
          debugPrint('[Customer]   - isAvailable: ${channel.isAvailable}');
          debugPrint('[Customer]   - Message: ${channel.message ?? "null"}');
        }
        debugPrint('[Customer] ──────────────────────────────────────────────');
      } else {
        debugPrint('[Customer] ⚠️ No channels returned from API');
      }
      
      debugPrint('[Customer] ========== FETCH COMPLETED ==========');
      return channels;
    } catch (e, stackTrace) {
      debugPrint('[Customer] ========== ERROR FETCHING CHANNELS ==========');
      debugPrint('[Customer] ❌ Exception: $e');
      debugPrint('[Customer] Stack trace: $stackTrace');
      debugPrint('[Customer] Error type: ${e.runtimeType}');
      handleException(e, customErrorMessage: 'Failed to fetch available channels');
      return [];
    }
  }

  /// Refresh all data after channel change
  Future<void> refreshAllDataAfterChannelChange() async {
    try {
      debugPrint('[Customer] ========== REFRESHING DATA AFTER CHANNEL CHANGE ==========');
      
      // Get controllers
      final BannerController? bannerController = Get.isRegistered<BannerController>() 
          ? Get.find<BannerController>() 
          : null;
      final CollectionsController? collectionController = Get.isRegistered<CollectionsController>() 
          ? Get.find<CollectionsController>() 
          : null;
      final CartController? cartController = Get.isRegistered<CartController>() 
          ? Get.find<CartController>() 
          : null;
      
      // Refresh banners (channel-specific)
      if (bannerController != null) {
        debugPrint('[Customer] Refreshing banners...');
        bannerController.bannerList.clear(); // Clear old banners
        await bannerController.getBannersForChannel();
        debugPrint('[Customer] Banners refreshed');
      }
      
      // Refresh collections (channel-specific)
      if (collectionController != null) {
        debugPrint('[Customer] Refreshing collections...');
        collectionController.allCollections.clear(); // Clear old collections
        await collectionController.fetchAllCollections(force: true);
        debugPrint('[Customer] Collections refreshed');
      }
      
      // Refresh frequently ordered products
      if (bannerController != null) {
        debugPrint('[Customer] Refreshing frequently ordered products...');
        await bannerController.getFrequentlyOrderedProducts();
        debugPrint('[Customer] Frequently ordered products refreshed');
      }
      
      // Refresh cart (if user is logged in)
      if (cartController != null && _isUserAuthenticated()) {
        debugPrint('[Customer] Refreshing cart...');
        await cartController.getActiveOrder();
        debugPrint('[Customer] Cart refreshed');
      }
      
      // Refresh customer favorites (if user is logged in)
      if (bannerController != null && _isUserAuthenticated()) {
        debugPrint('[Customer] Refreshing customer favorites...');
        await bannerController.getCustomerFavorites();
        debugPrint('[Customer] Customer favorites refreshed');
      }
      
      debugPrint('[Customer] ========== DATA REFRESH COMPLETED ==========');
    } catch (e) {
      debugPrint('[Customer] Error refreshing data after channel change: $e');
      // Don't throw - channel change was successful, data refresh is secondary
    }
  }

  /// Check if user is authenticated
  bool _isUserAuthenticated() {
    final authToken = GraphqlService.authToken;
    return authToken.isNotEmpty;
  }

  /// Fetch postal codes
  Future<List<Query$PostalCodes$postalCodes>> fetchPostalCodes() async {
    try {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('[Customer] ========== FETCHING POSTAL CODES ==========');
      debugPrint('[Customer] Function called at: ${DateTime.now()}');
      debugPrint('[Customer] Starting postal codes query...');
      
      // Check channel token before making query
      final channelToken = GraphqlService.channelToken;
      final storedChannelToken = _storage.read('channel_token');
      final channelCode = _storage.read('channel_code');
      final channelType = _storage.read('channel_type')?.toString() ?? '';
      
      debugPrint('[Customer] ──── CHANNEL TOKEN CHECK ────');
      debugPrint('[Customer] Current channel token from GraphQLService: ${channelToken.isNotEmpty ? "$channelToken (length: ${channelToken.length})" : "NOT SET"}');
      debugPrint('[Customer] Current channel token from storage: ${storedChannelToken != null ? "$storedChannelToken (length: ${storedChannelToken.toString().length})" : "NOT SET"}');
      debugPrint('[Customer] Channel code from storage: ${channelCode ?? "NOT SET"}');
      debugPrint('[Customer] Channel type from storage: ${channelType.isNotEmpty ? channelType : "NOT SET"}');
      debugPrint('[Customer] ✅ Postal codes will be fetched for ALL channel types (CITY, BRAND, etc.)');
      
      // Ensure channel token is set in GraphQLService
      if (channelToken.isEmpty && storedChannelToken != null && storedChannelToken.toString().isNotEmpty) {
        debugPrint('[Customer] ⚠️ Channel token not set in GraphQLService, setting it now...');
        await GraphqlService.setToken(key: 'channel', token: storedChannelToken.toString());
        debugPrint('[Customer] ✅ Channel token set in GraphQLService: ${GraphqlService.channelToken}');
      }
      
      if (GraphqlService.channelToken.isEmpty) {
        debugPrint('[Customer] ⚠️⚠️⚠️ WARNING: Channel token is empty! Postal codes query may fail or return wrong results.');
      } else {
        debugPrint('[Customer] ✅ Channel token is set: ${GraphqlService.channelToken}');
      }
      
      debugPrint('[Customer] ──── EXECUTING GRAPHQL QUERY ────');
      debugPrint('[Customer] Query: postalCodes { id code isAnywhere }');
      debugPrint('[Customer] Making GraphQL request...');
      
      final response = await GraphqlService.client.value.query$PostalCodes(
        Options$Query$PostalCodes(),
      );
      
      debugPrint('[Customer] ──── GRAPHQL RESPONSE RECEIVED ────');
      debugPrint('[Customer] Response received at: ${DateTime.now()}');
      debugPrint('[Customer] Response has exception: ${response.hasException}');
      debugPrint('[Customer] Response data is null: ${response.data == null}');
      
      // Print raw response data for debugging
      if (response.data != null) {
        debugPrint('[Customer] ──── RAW RESPONSE DATA ────');
        debugPrint('[Customer] Raw response data keys: ${response.data!.keys.toList()}');
        if (response.data!['postalCodes'] != null) {
          final postalCodesData = response.data!['postalCodes'];
          debugPrint('[Customer] Raw postalCodes type: ${postalCodesData.runtimeType}');
          debugPrint('[Customer] Raw postalCodes length: ${postalCodesData is List ? postalCodesData.length : "N/A"}');
          debugPrint('[Customer] Raw postalCodes from data: $postalCodesData');
        } else {
          debugPrint('[Customer] ⚠️ postalCodes key not found in response data');
        }
      } else {
        debugPrint('[Customer] ⚠️ Response data is null');
      }
      
      if (response.hasException) {
        debugPrint('[Customer] ═══════════════════════════════════════════════════════════');
        debugPrint('[Customer] ========== GRAPHQL EXCEPTION ==========');
        debugPrint('[Customer] Exception type: ${response.exception.runtimeType}');
        debugPrint('[Customer] GraphQL exception: ${response.exception}');
        debugPrint('[Customer] Exception link: ${response.exception?.linkException}');
        debugPrint('[Customer] Exception graphql errors: ${response.exception?.graphqlErrors}');
        if (response.exception?.graphqlErrors != null) {
          debugPrint('[Customer] GraphQL Errors count: ${response.exception!.graphqlErrors.length}');
          for (var error in response.exception!.graphqlErrors) {
            debugPrint('[Customer]   ──── GraphQL Error ────');
            debugPrint('[Customer]   Message: ${error.message}');
            debugPrint('[Customer]   Locations: ${error.locations}');
            debugPrint('[Customer]   Path: ${error.path}');
            debugPrint('[Customer]   Extensions: ${error.extensions}');
          }
        }
        debugPrint('[Customer] ═══════════════════════════════════════════════════════════');
      }

      // Check for errors in response
      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to fetch postal codes')) {
        debugPrint('═══════════════════════════════════════════════════════════');
        debugPrint('[Customer] ========== POSTAL CODES QUERY ERROR ==========');
        debugPrint('[Customer] Response contains errors - checkResponseForErrors returned true');
        debugPrint('[Customer] Response has exception: ${response.hasException}');
        debugPrint('[Customer] Response data is null: ${response.data == null}');
        
        if (response.hasException) {
          debugPrint('[Customer] ──── EXCEPTION DETAILS ────');
          debugPrint('[Customer] Exception type: ${response.exception.runtimeType}');
          debugPrint('[Customer] Exception: ${response.exception}');
          
          if (response.exception?.graphqlErrors != null) {
            debugPrint('[Customer] GraphQL Errors count: ${response.exception!.graphqlErrors.length}');
            for (var error in response.exception!.graphqlErrors) {
              debugPrint('[Customer]   ──── GraphQL Error Details ────');
              debugPrint('[Customer]   Message: ${error.message}');
              debugPrint('[Customer]   Path: ${error.path}');
              debugPrint('[Customer]   Locations: ${error.locations}');
              debugPrint('[Customer]   Extensions: ${error.extensions}');
            }
          }
          
          if (response.exception?.linkException != null) {
            debugPrint('[Customer] ──── LINK EXCEPTION ────');
            debugPrint('[Customer] Link Exception: ${response.exception!.linkException}');
            debugPrint('[Customer] Link Exception type: ${response.exception!.linkException.runtimeType}');
          }
        }
        
        debugPrint('[Customer] Returning empty list due to errors');
        debugPrint('═══════════════════════════════════════════════════════════');
        return [];
      }

      debugPrint('[Customer] ──── PARSING RESPONSE ────');
      debugPrint('[Customer] parsedData is null: ${response.parsedData == null}');
      final postalCodes = response.parsedData?.postalCodes ?? [];
      debugPrint('[Customer] Parsed postalCodes count: ${postalCodes.length}');
      
      debugPrint('[Customer] ═══════════════════════════════════════════════════════════');
      debugPrint('[Customer] ========== POSTAL CODES RESULT ==========');
      debugPrint('[Customer] Found ${postalCodes.length} postal codes');
      debugPrint('[Customer] Channel used: ${GraphqlService.channelToken}');
      
      if (postalCodes.isNotEmpty) {
        debugPrint('[Customer] ──── POSTAL CODES LIST ────');
        for (int i = 0; i < postalCodes.length; i++) {
          final code = postalCodes[i];
          debugPrint('[Customer]   Postal Code ${i + 1}:');
          debugPrint('[Customer]     - ID: ${code.id}');
          debugPrint('[Customer]     - Code: ${code.code}');
          debugPrint('[Customer]     - isAnywhere: ${code.isAnywhere}');
        }
      } else {
        debugPrint('[Customer] ⚠️ No postal codes found in response');
        debugPrint('[Customer] This could mean:');
        debugPrint('[Customer]   1. No postal codes available for this channel');
        debugPrint('[Customer]   2. Channel token is incorrect');
        debugPrint('[Customer]   3. Backend returned empty array');
      }
      
      debugPrint('[Customer] ========== POSTAL CODES FETCH COMPLETED ==========');
      debugPrint('[Customer] Completed at: ${DateTime.now()}');
      debugPrint('═══════════════════════════════════════════════════════════');
      return postalCodes;
    } catch (e, stackTrace) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('[Customer] ========== POSTAL CODES FETCH ERROR ==========');
      debugPrint('[Customer] Error occurred at: ${DateTime.now()}');
      debugPrint('[Customer] ──── ERROR DETAILS ────');
      debugPrint('[Customer] Exception type: ${e.runtimeType}');
      debugPrint('[Customer] Error message: $e');
      debugPrint('[Customer] Error toString: ${e.toString()}');
      
      // Print stack trace
      debugPrint('[Customer] ──── STACK TRACE ────');
      debugPrint('[Customer] $stackTrace');
      
      // Additional error context
      debugPrint('[Customer] ──── ERROR CONTEXT ────');
      debugPrint('[Customer] Channel token at error: ${GraphqlService.channelToken.isNotEmpty ? GraphqlService.channelToken : "NOT SET"}');
      debugPrint('[Customer] Storage channel token: ${_storage.read('channel_token') ?? "NOT SET"}');
      debugPrint('[Customer] Storage channel code: ${_storage.read('channel_code') ?? "NOT SET"}');
      
      // Check if it's a GraphQL specific error
      if (e.toString().contains('GraphQL') || e.toString().contains('graphql')) {
        debugPrint('[Customer] ⚠️ This appears to be a GraphQL-related error');
      }
      
      // Check if it's a network error
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection') ||
          e.toString().contains('Network')) {
        debugPrint('[Customer] ⚠️ This appears to be a network-related error');
      }
      
      debugPrint('[Customer] ================================================');
      debugPrint('═══════════════════════════════════════════════════════════');
      
      // Still call handleException for user-facing error dialog
      handleException(e, customErrorMessage: 'Failed to fetch postal codes');
      return [];
    }
  }

  /// Check if postal code is in local storage, if not get from shipping address and fetch channel
  Future<void> checkAndSetPostalCodeFromShippingAddress() async {
    try {
      debugPrint('[Customer] ========== CHECKING POSTAL CODE FROM SHIPPING ADDRESS ==========');
      
      // Check if postal code exists in local storage
      final storedPostalCode = _storage.read('postal_code');
      debugPrint('[Customer] Postal code in local storage: ${storedPostalCode ?? "NOT FOUND"}');
      
      if (storedPostalCode != null && storedPostalCode.toString().isNotEmpty) {
        debugPrint('[Customer] Postal code already exists in local storage, skipping...');
        return;
      }

      // Get default shipping address
      final defaultShippingAddress = addresses.firstWhereOrNull(
        (address) => address.defaultShippingAddress == true,
      );

      if (defaultShippingAddress == null) {
        debugPrint('[Customer] No default shipping address found');
        return;
      }

      final postalCode = defaultShippingAddress.postalCode;
      if (postalCode == null || postalCode.isEmpty) {
        debugPrint('[Customer] Default shipping address has no postal code');
        return;
      }

      debugPrint('[Customer] Found postal code from shipping address: $postalCode');
      debugPrint('[Customer] Shipping address city: ${defaultShippingAddress.city}');
      
      // Save postal code to local storage
      await _storage.write('postal_code', postalCode);
      debugPrint('[Customer] Postal code saved to local storage: $postalCode');

      // Fetch channel by postal code
      debugPrint('[Customer] Fetching channel for postal code: $postalCode');
      final success = await switchChannelByPostalCode(
        postalCode,
        city: defaultShippingAddress.city,
        showLoading: false, // Don't show loading dialog during background operation
      );

      if (success) {
        debugPrint('[Customer] Channel successfully fetched and set for postal code: $postalCode');
      } else {
        debugPrint('[Customer] Failed to fetch channel for postal code: $postalCode');
      }
    } catch (e) {
      debugPrint('[Customer] Error checking postal code from shipping address: $e');
      // Don't throw - this is a background operation
    }
  }
}
