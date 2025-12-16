import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' show FetchPolicy;
import 'package:recipe.app/graphql/Customer.graphql.dart';
import '../../graphql/authenticate.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../../widgets/error_dialog.dart';
import '../../services/analytics_service.dart';
import '../base_controller.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'customer_models.dart';

class CustomerController extends BaseController {
  // Observable variables
  final Rx<CustomerModel?> activeCustomer = Rx<CustomerModel?>(null);
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
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
      if (response.hasException) {
debugPrint('[Customer] Exception: ${response.exception}');

        // Check if error contains "User not found"
        final exceptionString = response.exception.toString().toLowerCase();
        if (exceptionString.contains('user not found') ||
            exceptionString.contains('user not found with this email')) {
debugPrint(  '[Customer] User not found error detected - triggering logout');
          error.value = 'User not found. Please login again.';

          // Trigger logout and redirect to login
          await _handleUserNotFoundError();
          return;
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

        activeCustomer.value = CustomerModel.fromJson(customerJson);
        addresses.value = activeCustomer.value?.addresses ?? [];
        
        // Reset pagination state on initial load
        final ordersData = activeCustomer.value?.orders;
        if (ordersData != null) {
          orders.value = ordersData.items ?? [];
          totalOrdersCount.value = ordersData.totalItems ?? 0;
          hasMoreOrders.value = orders.length < totalOrdersCount.value;
        } else {
          orders.value = [];
          totalOrdersCount.value = 0;
          hasMoreOrders.value = false;
        }

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
        error.value = 'No customer data found';
debugPrint('[Customer] No customer data found when this occurs clear cache and log out and go to login page');
        // Clear cache and logout when customer data is null
        await handleCustomerDataNotFound();
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
            // Convert GraphQL orders to OrderModel
            final orderModels = newOrders.map((order) {
              return OrderModel.fromJson(order as Map<String, dynamic>);
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

  /// Create new address
  Future<bool> createAddress(AddressModel address) async {
    try {
      utilityController.setLoadingState(true);

debugPrint('[Customer] Creating address...');

      final input = Input$CreateAddressInput(
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2,
        city: address.city,
        province: address.province,
        postalCode: address.postalCode,
        countryCode: address.country.code,
        phoneNumber: address.phoneNumber,
        defaultShippingAddress: address.defaultShippingAddress,
        defaultBillingAddress: address.defaultBillingAddress,
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
      utilityController.setLoadingState(false);
    }
  }

  /// Update existing address
  Future<bool> updateAddress(AddressModel address) async {
    try {
      utilityController.setLoadingState(true);

debugPrint('[Customer] Updating address...');

      final input = Input$UpdateAddressInput(
        id: address.id,
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2,
        city: address.city,
        province: address.province,
        postalCode: address.postalCode,
        countryCode: address.country.code,
        phoneNumber: address.phoneNumber,
        defaultShippingAddress: address.defaultShippingAddress,
        defaultBillingAddress: address.defaultBillingAddress,
      );

      final response =
          await GraphqlService.client.value.mutate$UpdateCustomerAddress(
        Options$Mutation$UpdateCustomerAddress(
          variables: Variables$Mutation$UpdateCustomerAddress(input: input),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to update address')) {
        return false;
      }

      final result = response.parsedData?.updateCustomerAddress;
      if (result != null) {
        // Refresh customer data to get updated addresses
        await getActiveCustomer();
        // Force UI refresh
        addresses.refresh();
debugPrint('[Customer] Address updated successfully');
        return true;
      }

      return false;
    } catch (e) {
debugPrint('[Customer] Update address error: $e');
      handleException(e, customErrorMessage: 'Failed to update address');
      return false;
    } finally {
      utilityController.setLoadingState(false);
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
        title: 'Session Expired',
        message: 'User not found. Please login again.',
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
        title: 'Session Expired',
        message: 'No customer data found. Please login again.',
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
  AddressModel? get defaultAddress {
    return addresses
        .firstWhereOrNull((address) => address.defaultShippingAddress);
  }
}
