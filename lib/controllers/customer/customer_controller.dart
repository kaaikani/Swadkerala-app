import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' show FetchPolicy;
import 'package:recipe.app/graphql/Customer.graphql.dart';
import '../../graphql/authenticate.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../../utils/app_strings.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_dialog.dart';
import '../../services/analytics_service.dart';
import '../base_controller.dart';
import '../utilitycontroller/utilitycontroller.dart';

class CustomerController extends BaseController {
  // Observable variables
  final Rx<Query$GetActiveCustomer$activeCustomer?> activeCustomer = Rx<Query$GetActiveCustomer$activeCustomer?>(null);
  final RxList<Query$GetActiveCustomer$activeCustomer$addresses> addresses = <Query$GetActiveCustomer$activeCustomer$addresses>[].obs;
  final RxList<Query$GetActiveCustomer$activeCustomer$orders$items> orders = <Query$GetActiveCustomer$activeCustomer$orders$items>[].obs;
  final RxBool isEditingProfile = false.obs;
  final RxString error = ''.obs;
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
  Future<void> getActiveCustomer() async {
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

  /// Update customer email address using UpdateCustomer mutation
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
      debugPrint('[CustomerController] 📝 Using UpdateCustomer mutation');

      debugPrint('[CustomerController] 📋 Preparing UpdateCustomerInput');
      debugPrint('[CustomerController] - firstName: "${customer.firstName}"');
      debugPrint('[CustomerController] - lastName: "${customer.lastName}"');
      debugPrint('[CustomerController] - phoneNumber: "${customer.phoneNumber}"');
      debugPrint('[CustomerController] - emailAddress: "$emailAddress" (attempting to include)');

      // Use raw variables to include emailAddress (even though it's not in the schema)
      final variables = {
        'input': {
          'firstName': customer.firstName,
          'lastName': customer.lastName,
          'phoneNumber': customer.phoneNumber,
          'emailAddress': emailAddress, // Attempting to include emailAddress
        },
      };

      debugPrint('[CustomerController] 🚀 Executing UpdateCustomer mutation...');
      debugPrint('[CustomerController] - Variables: $variables');
      
      final response = await GraphqlService.client.value.mutate(
        graphql.MutationOptions(
          document: documentNodeMutationUpdateCustomer,
          variables: variables,
          fetchPolicy: graphql.FetchPolicy.networkOnly,
        ),
      );

      debugPrint('[CustomerController] 📥 GraphQL response received');
      debugPrint('[CustomerController] - Has Exception: ${response.hasException}');
      
      if (response.hasException) {
        debugPrint('[CustomerController] ❌ GraphQL exception detected');
        debugPrint('[CustomerController] - Exception: ${response.exception}');
        debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (FAILED) ==========');
        return false;
      }

      // Check for errors in response
      if (checkResponseForErrors(response, customErrorMessage: 'Failed to update email')) {
        debugPrint('[CustomerController] ❌ Response has errors, update failed');
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
      debugPrint('[CustomerController] ========== UPDATE EMAIL ID END (ERROR) ==========');
      handleException(e, customErrorMessage: 'Failed to update email');
      return false;
    } finally {
      utilityController.setLoadingState(false);
      debugPrint('[CustomerController] 🔄 Setting loading state to false');
    }
  }

  /// Update customer phone number using UpdateCustomer mutation
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
        debugPrint('[CustomerController] ========== UPDATE PHONE NUMBER END (FAILED) ==========');
        return false;
      }

      // Check for errors in response
      if (checkResponseForErrors(response, customErrorMessage: 'Failed to update phone number')) {
        debugPrint('[CustomerController] ❌ Response has errors, update failed');
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
  Future<bool> createAddress(Query$GetActiveCustomer$activeCustomer$addresses address) async {
    try {
      LoadingDialog.show(message: 'Please wait');

debugPrint('[Customer] Creating address...');

      final input = Input$CreateAddressInput(
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2,
        city: address.city,
        province: null, // Province not available in query address type
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
debugPrint('[Customer] Address created successfully');
        return true;
      }

      return false;
    } catch (e) {
debugPrint('[Customer] Create address error: $e');
      handleException(e, customErrorMessage: 'Failed to create address');
      return false;
    } finally {
      LoadingDialog.hide();
    }
  }

  /// Update existing address
  Future<bool> updateAddress(Query$GetActiveCustomer$activeCustomer$addresses address, {bool skipLoading = true}) async {
    try {
      // Don't show loading dialog by default - only show on error if needed
      debugPrint('[Customer] Updating address...');

      final input = Input$UpdateAddressInput(
        id: address.id,
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2,
        city: address.city,
        province: null, // Province not available in query address type
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
        // Refresh customer data to get updated addresses
        await getActiveCustomer();
        // Force UI refresh
        addresses.refresh();
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
}
