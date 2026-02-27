import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' show FetchPolicy;
import 'package:recipe.app/graphql/Customer.graphql.dart';
import '../../graphql/authenticate.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../graphql/schema.graphql.dart' show Input$OrderFilterParameter, Input$StringOperators;
import '../../services/graphql_client.dart';
import '../../pages/orders_page.dart';
import '../../services/postal_code_service.dart';
import '../../services/channel_service.dart';
import '../../services/notification_service.dart';
import '../../utils/app_strings.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_dialog.dart';
import '../../services/analytics_service.dart';
import '../base_controller.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../authentication/authenticationcontroller.dart';
import '../banner/bannercontroller.dart';
import '../collection controller/collectioncontroller.dart';
import '../cart/Cartcontroller.dart';
import '../order/ordercontroller.dart';
import '../../utils/logger.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../routes.dart';

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
  
  // Current order filter state
  OrderFilter? _currentOrderFilter;

  RxBool get isLoading => utilityController.isLoadingRx;

  /// True if any profile field is empty (title, firstName, lastName, phone, email) or email is placeholder.
  static bool isProfileIncomplete(Query$GetActiveCustomer$activeCustomer? c) {
    if (c == null) return false;
    if (c.title == null || c.title!.trim().isEmpty) return true;
    if (c.firstName.trim().isEmpty) return true;
    if (c.lastName.trim().isEmpty) return true;
    if (c.phoneNumber == null || c.phoneNumber!.trim().isEmpty) return true;
    if (c.emailAddress.trim().isEmpty) return true;
    if (c.emailAddress.endsWith('@kaikani.com')) return true;
    return false;
  }

  /// Convert OrderFilter to Input$OrderFilterParameter
  Input$OrderFilterParameter? _getOrderStateFilter(OrderFilter? filter) {
    if (filter == null || filter == OrderFilter.all) {
      return null;
    }
    
    switch (filter) {
      case OrderFilter.paid:
        return Input$OrderFilterParameter(
          state: Input$StringOperators(eq: 'PaymentSettled'),
        );
      
      case OrderFilter.paymentAuthorized:
        return Input$OrderFilterParameter(
          state: Input$StringOperators(eq: 'PaymentAuthorized'),
        );
      
      case OrderFilter.delivered:
        return Input$OrderFilterParameter(
          state: Input$StringOperators(
            $in: ['Fulfilled', 'Delivered', 'Shipped', 'PartiallyFulfilled'],
          ),
        );
      
      case OrderFilter.cancellationRequest:
        return Input$OrderFilterParameter(
          state: Input$StringOperators(eq: 'CancellationRequested'),
        );

      case OrderFilter.cancelled:
        return Input$OrderFilterParameter(
          state: Input$StringOperators(eq: 'Cancelled'),
        );

      case OrderFilter.all:
        return null;
    }
  }

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
    // On app restart, switch to channel based on saved postal code
    _initializeChannelFromSavedPostalCode();
  }

  /// Initialize channel from saved postal code on app restart
  /// This ensures the app always uses the correct brand city channel for the saved postal code
  Future<void> _initializeChannelFromSavedPostalCode() async {
    try {
      // Skip if app is restarting (channel token already exists) - don't call switchChannelByPostalCode
      final existingChannelToken = ChannelService.getChannelToken();
      if (existingChannelToken != null && existingChannelToken.toString().isNotEmpty) {
        return; // Channel already set, skip on app restart
      }
      
      // Also check GraphqlService channel token
      final graphqlChannelToken = GraphqlService.channelToken;
      if (graphqlChannelToken.isNotEmpty) {
        return; // Channel token exists in GraphqlService, skip on app restart
      }
      
      // Only run if user is authenticated (has auth token)
      final authToken = GraphqlService.authToken;
      if (authToken.isEmpty) {
        return;
      }
      
      final storedPostalCode = ChannelService.getPostalCode();
      // If postal code exists, always switch to the channel for that postal code
      // This ensures the channel is always correct for the saved postal code on app restart
      if (storedPostalCode != null && storedPostalCode.toString().isNotEmpty) {
        final postalCode = storedPostalCode.toString();
        
        // Get city from channel service if available (from previous channel switch)
        final storedCity = ChannelService.getChannelName(); // Channel name might contain city info
        // Switch channel based on saved postal code (without showing loading dialog)
        // This ensures the app always uses the correct channel for the saved postal code
        final success = await switchChannelByPostalCode(
          postalCode,
          city: storedCity?.toString(),
          showLoading: false, // Don't show loading dialog on app startup
        );
        
        if (success) {
        } else {
        }
      } else {
      }
    } catch (e) {
      // Don't throw error - app should still start even if channel switch fails
    }
  }

  /// Get active customer data
  /// [skipPostalCodeCheck] - if true, skip postal code/channel check to prevent unnecessary API calls
  Future<void> getActiveCustomer({bool skipPostalCodeCheck = false, OrderFilter? orderFilter}) async {
    try {
      if (Get.isRegistered<OrderController>() &&
          (Get.find<OrderController>().skipPostPaymentRefresh)) {
        return;
      }
      // Guest user (no auth token): set empty customer state but still load coupon codes for cart page
      if (GraphqlService.authToken.isEmpty) {
        utilityController.setLoadingState(false);
        activeCustomer.value = null;
        addresses.value = [];
        orders.value = [];
        totalOrdersCount.value = 0;
        hasMoreOrders.value = false;
        error.value = '';
        if (Get.isRegistered<BannerController>()) {
          final bannerController = Get.find<BannerController>();
          Future.wait([
            bannerController.getCouponCodeList(),
            bannerController.fetchLoyaltyPointsConfig(),
          ], eagerError: false).catchError((_) {});
        }
        return;
      }
          Logger.logFunction(functionName: 'getActiveCustomer');
    utilityController.setLoadingState(false);
      error.value = '';
      
      // Store current filter
      _currentOrderFilter = orderFilter;
      
      // Build filter parameter
      final stateFilter = _getOrderStateFilter(orderFilter);
      
      final response = await GraphqlService.client.value.query$GetActiveCustomer(
        Options$Query$GetActiveCustomer(
          variables: Variables$Query$GetActiveCustomer(
            orderStateFilter: stateFilter,
          ),
        ),
      );

      // Check if error contains "User not found" - handle specially
      bool isNetworkError = false;
      if (response.hasException) {
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

        // Only redirect to login for "User not found" when we had auth (session expired)
        if (exceptionString.toLowerCase().contains('user not found') ||
            exceptionString.toLowerCase().contains('user not found with this email')) {
          if (GraphqlService.authToken.isNotEmpty) {
            error.value = 'User not found. Please login again.';
            await _handleUserNotFoundError();
          } else {
            error.value = '';
          }
          return;
        }

        // For network/timeout errors, don't show error dialog, don't show message in UI, don't logout
        if (isNetworkError) {
          error.value = '';
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
        // ignore: unused_local_variable
        final _customerJson = customerData.toJson();
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
        
        // Load coupon codes and loyalty points config in parallel (fire and forget)
        if (Get.isRegistered<BannerController>()) {
          final bannerController = Get.find<BannerController>();
          Future.wait([
            bannerController.getCouponCodeList(),
            bannerController.fetchLoyaltyPointsConfig(),
          ], eagerError: false).then((_) {
            // Data loaded successfully
          }).catchError((_) {
            // Silently handle errors - these are supplementary data
          });
        }
        
        // Check if postal code is in local storage, if not get from shipping address
        // Skip this check when called from loyalty points operations to prevent unnecessary channel fetches
        if (!skipPostalCodeCheck) {
        await checkAndSetPostalCodeFromShippingAddress();
        } else {
        }
      } else {
        orders.value = [];
        totalOrdersCount.value = 0;
        hasMoreOrders.value = false;
        error.value = 'No customer data found';
        // Only redirect to login when we had auth (logged-in user) but got no customer (session expired)
        // Do NOT redirect for network errors or when token was already empty (guest)
        if (!isNetworkError && GraphqlService.authToken.isNotEmpty) {
          await handleCustomerDataNotFound();
        } else if (isNetworkError) {
          error.value = 'Network error. Please check your connection and try again.';
        } else {
          error.value = '';
        }
      }
    } catch (e) {
      // Only redirect for "User not found" when we had auth (session expired)
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('user not found') ||
          errorString.contains('user not found with this email')) {
        if (GraphqlService.authToken.isNotEmpty) {
          error.value = 'User not found. Please login again.';
          await _handleUserNotFoundError();
        } else {
          error.value = '';
        }
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
  Future<bool> loadMoreOrders({OrderFilter? orderFilter}) async {
    // Don't load if already loading or no more orders
    if (isLoadingMoreOrders.value || !hasMoreOrders.value) {
      return false;
    }

    try {
      isLoadingMoreOrders.value = true;
      final skip = orders.length;
      
      // Use current filter if not provided
      final filter = orderFilter ?? _currentOrderFilter;
      final stateFilter = _getOrderStateFilter(filter);
      
      // Use raw GraphQL query with filter support
      final query = '''
        query GetCustomerOrders(\$skip: Int!, \$take: Int!, \$orderStateFilter: OrderFilterParameter) {
          activeCustomer {
            __typename
            ... on Customer {
              orders(options: { skip: \$skip, take: \$take, filter: \$orderStateFilter }) {
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
            'orderStateFilter': stateFilter?.toJson(),
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
          // Continue processing if we have data despite cache miss
          if (response.data == null) {
            return false;
          }
        } else {
          // Only show error dialog for real errors, not cache misses
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
            return true;
          } else {
            hasMoreOrders.value = false;
            return false;
          }
        }
      }
      
      hasMoreOrders.value = false;
      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to load more orders');
      return false;
    } finally {
      isLoadingMoreOrders.value = false;
    }
  }

  /// Update customer profile. [title] is used as gender (Male/Female/Others) when GraphQL has no gender field.
  Future<bool> updateCustomer({String? title}) async {
    try {
          Logger.logFunction(functionName: 'updateCustomer', mutationName: 'UpdateCustomer');
    utilityController.setLoadingState(true);
      final input = Input$UpdateCustomerInput(
        title: title,
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
      final result = response.parsedData?.updateCustomer;

      if (result != null) {
        // Force fetch fresh customer data from network
        await getActiveCustomer();

        isEditingProfile.value = false;
        // Log new customer data to confirm

        return true;
      }
      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to update profile');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Update customer location (customFields.location) with channel name. Used after switching channel by postal code.
  Future<bool> updateCustomerLocation(String channelName) async {
    final customer = activeCustomer.value;
    if (customer == null) {
      debugPrint('[UpdateLocation] updateCustomerLocation skipped: no active customer');
      return false;
    }
    try {
      Logger.logFunction(functionName: 'updateCustomerLocation', mutationName: 'UpdateCustomer');
      final input = Input$UpdateCustomerInput(
        title: customer.title,
        firstName: customer.firstName,
        lastName: customer.lastName,
        phoneNumber: customer.phoneNumber,
        customFields: Input$UpdateCustomerCustomFieldsInput(
          location: channelName,
          loyaltyPointsAvailable: customer.customFields?.loyaltyPointsAvailable,
        ),
      );
      final response = await GraphqlService.client.value.mutate$UpdateCustomer(
        Options$Mutation$UpdateCustomer(
          variables: Variables$Mutation$UpdateCustomer(input: input),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (checkResponseForErrors(response, customErrorMessage: 'Failed to update location')) {
        return false;
      }
      if (response.parsedData?.updateCustomer != null) {
        await getActiveCustomer();
        debugPrint('[UpdateLocation] updateCustomerLocation success: location=$channelName');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[UpdateLocation] updateCustomerLocation error: $e');
      return false;
    }
  }

  /// Sync customer location from stored postal code (home page): read postal from GetStorage,
  /// get channel by postal code, then pass that channel name to updateCustomer (customFields.location).
  Future<void> syncCustomerLocationFromStoredPostalCode() async {
    final storedPostalCode = _storage.read('postal_code');
    if (storedPostalCode == null || storedPostalCode.toString().trim().isEmpty) {
      debugPrint('[UpdateLocation] syncCustomerLocationFromStoredPostalCode: no postal_code in storage');
      return;
    }
    if (activeCustomer.value == null) {
      debugPrint('[UpdateLocation] syncCustomerLocationFromStoredPostalCode: no active customer');
      return;
    }
    final postalCode = storedPostalCode.toString().trim();
    final channels = await getAvailableChannels(postalCode);
    if (channels.isEmpty) {
      debugPrint('[UpdateLocation] syncCustomerLocationFromStoredPostalCode: no channels for postalCode=$postalCode');
      return;
    }
    final availableCity = channels
        .where((c) => c.type == Enum$ChannelType.CITY && c.isAvailable == true)
        .toList();
    if (availableCity.isEmpty) {
      debugPrint('[UpdateLocation] syncCustomerLocationFromStoredPostalCode: no available CITY channel');
      return;
    }
    final currentCode = ChannelService.getChannelCode();
    final selected = currentCode != null
        ? availableCity.firstWhereOrNull((c) => c.code == currentCode) ?? availableCity.first
        : availableCity.first;
    debugPrint('[UpdateLocation] syncCustomerLocationFromStoredPostalCode: postalCode=$postalCode -> channelName=${selected.name}');
    await updateCustomerLocation(selected.name);
  }

  /// Update customer email address using UpdateProfileEmail mutation
  Future<bool> updateCustomerEmail(String emailAddress) async {
    // Get current customer data
    final customer = activeCustomer.value;
    if (customer == null) {
      return false;
    }
    
    // ignore: unused_local_variable
    final _currentEmail = customer.emailAddress;
    try {
      Logger.logFunction(functionName: 'updateProfileEmail', mutationName: 'UpdateProfileEmail');
      
      utilityController.setLoadingState(true);
      // Execute UpdateProfileEmail mutation
      final response = await GraphqlService.client.value.mutate$UpdateProfileEmail(
        Options$Mutation$UpdateProfileEmail(
          variables: Variables$Mutation$UpdateProfileEmail(email: emailAddress),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      // Clear previous error
      emailUpdateError.value = '';
      
      if (response.hasException) {
        // Extract error message from GraphQL errors
        String? errorMessage;
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          errorMessage = response.exception!.graphqlErrors.first.message;
          // Store error message for UI display in dialog
          emailUpdateError.value = errorMessage;
        } else {
          // Fallback error message if no GraphQL error found
          emailUpdateError.value = 'Failed to update email. Please try again.';
        }
        
        // Don't call checkResponseForErrors here as it shows a dialog
        // We're handling error display in the dialog UI instead
        return false;
      }

      // Check for errors in response (but don't show dialog - we handle it in UI)
      // Only check if there are errors, but don't show dialog
      if (response.hasException || response.data == null) {
        // Extract error message from GraphQL errors if available
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          final errorMessage = response.exception!.graphqlErrors.first.message;
          emailUpdateError.value = errorMessage;
        } else {
          emailUpdateError.value = 'Failed to update email. Please try again.';
        }
        
        return false;
      }
      // Refresh customer data to verify update
      await getActiveCustomer();
      
      final updatedCustomer = activeCustomer.value;
      final updatedEmail = updatedCustomer?.emailAddress ?? 'N/A';
      if (updatedEmail == emailAddress) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Check if it's a GraphQL error with email-related message
      String? errorMessage;
      if (e is graphql.OperationException) {
        if (e.graphqlErrors.isNotEmpty) {
          errorMessage = e.graphqlErrors.first.message;
          // Store error message for UI display in dialog
          emailUpdateError.value = errorMessage;
          // Don't call handleException as we're showing error in dialog UI
          return false;
        }
      }
      
      // For other exceptions, show dialog via handleException
      handleException(e, customErrorMessage: 'Failed to update email');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Update customer phone number using UpdateCustomer mutation
  /// Returns true on success, false on failure
  /// Throws exception with error message if phone number is already registered
  Future<bool> updateCustomerPhoneNumber(String phoneNumber) async {
    // Get current customer data
    final customer = activeCustomer.value;
    if (customer == null) {
      return false;
    }
    
    // ignore: unused_local_variable
    final _currentPhone = customer.phoneNumber ?? 'N/A';
    try {
      Logger.logFunction(functionName: 'updateCustomerPhone', mutationName: 'UpdateCustomer');
      
      utilityController.setLoadingState(true);
      // Prepare UpdateCustomerInput with current data and new phone number
      final input = Input$UpdateCustomerInput(
        firstName: customer.firstName,
        lastName: customer.lastName,
        phoneNumber: phoneNumber,
      );
      final response = await GraphqlService.client.value.mutate$UpdateCustomer(
        Options$Mutation$UpdateCustomer(
          variables: Variables$Mutation$UpdateCustomer(input: input),
        ),
      );
      if (response.hasException) {
        // Extract error message from GraphQL errors
        String? errorMessage;
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          errorMessage = response.exception!.graphqlErrors.first.message;
          // Check if it's the "already registered" error
          if (errorMessage.toLowerCase().contains('already registered') ||
              errorMessage.toLowerCase().contains('already exists')) {
            throw Exception(errorMessage); // Throw exception with the error message
          }
        }
        
        return false;
      }

      // Check for errors in response
      if (checkResponseForErrors(response, customErrorMessage: 'Failed to update phone number')) {
        // Extract error message from GraphQL errors
        String? errorMessage;
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          errorMessage = response.exception!.graphqlErrors.first.message;
          // Check if it's the "already registered" error
          if (errorMessage.toLowerCase().contains('already registered') ||
              errorMessage.toLowerCase().contains('already exists')) {
            throw Exception(errorMessage); // Throw exception with the error message
          }
        }
        
        return false;
      }
      // Refresh customer data to verify update
      await getActiveCustomer();
      
      final updatedCustomer = activeCustomer.value;
      final updatedPhone = updatedCustomer?.phoneNumber ?? 'N/A';
      if (updatedPhone == phoneNumber) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to update phone number');
      return false;
    } finally {
      utilityController.setLoadingState(false);
    }
  }

  /// Create new address
  Future<bool> createAddress(Query$GetActiveCustomer$activeCustomer$addresses address, {String? province}) async {
    try {
          Logger.logFunction(functionName: 'createAddress');
    LoadingDialog.show(message: 'Please wait');
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
          if (response.data!.containsKey('createCustomerAddress')) {
            final resultData = response.data!['createCustomerAddress'];
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
        _showAddressMismatchDialog();
        return false;
      }

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
            } else {
            }
          } catch (e) {
            // Don't fail the address creation if order update fails
          }
        }
        return true;
      }

      return false;
    } catch (e) {
      LoadingDialog.hide(); // Hide loading dialog before showing error
      handleException(e, customErrorMessage: 'Failed to create address');
      return false;
    }
  }

  /// Update existing address
  Future<bool> updateAddress(Query$GetActiveCustomer$activeCustomer$addresses address, {
    bool skipLoading = true, String? province, bool skipRefresh = false}) async {
    Logger.logFunction(functionName: 'updateAddress', mutationName: 'UpdateCustomerAddress');
    
    try {
      // Don't show loading dialog by default - only show on error if needed
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
      final response =
          await GraphqlService.client.value.mutate$UpdateCustomerAddress(
        Options$Mutation$UpdateCustomerAddress(
          variables: Variables$Mutation$UpdateCustomerAddress(input: input),
        ),
      );
      if (response.hasException) {
        if (response.exception?.graphqlErrors.isNotEmpty == true) {
          for (int i = 0; i < response.exception!.graphqlErrors.length; i++) {
            // ignore: unused_local_variable
            final _error = response.exception!.graphqlErrors[i];
          }
        }
        if (response.exception?.linkException != null) {
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
          if (response.data!.containsKey('updateCustomerAddress')) {
            final resultData = response.data!['updateCustomerAddress'];
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
        if (!skipLoading) {
          LoadingDialog.hide();
        }
        _showAddressMismatchDialog();
        return false;
      }

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to update address')) {
        // Don't show loading dialog - error dialog will be shown by checkResponseForErrors
        return false;
      }

      final result = response.parsedData?.updateCustomerAddress;
      if (result != null) {
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
            } else {
            }
          } catch (e) {
            // Don't fail the address update if order update fails
          }
        }
        return true;
      }
      if (response.data != null) {
        if (response.data!.containsKey('updateCustomerAddress')) {
          final updateResult = response.data!['updateCustomerAddress'];
          if (updateResult is Map) {
            if (updateResult.containsKey('__typename')) {
            }
            if (updateResult.containsKey('errorCode')) {
            }
          }
        }
      }
      // Don't show loading dialog - error will be handled by error dialog
      return false;
    } catch (e) {
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
    Logger.logFunction(functionName: 'deleteAddress', mutationName: 'DeleteCustomerAddress');
    
    try {
      utilityController.setLoadingState(true);
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
        return true;
      }

      return false;
    } catch (e) {
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
    if (AuthController.isLoggingOut) return;
    try {
      // Clear local data immediately
      activeCustomer.value = null;
      addresses.clear();
      orders.clear();
      isEditingProfile.value = false;

      // Clear authentication tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      await _storage.remove('preserve_guest_channel');

      // Show message to user
      ErrorDialog.show(
        title: AppStrings.sessionExpired,
        message: AppStrings.userNotFoundLoginAgain,
      );

      // Navigate to login page (or home if logout in progress)
      if (AuthController.isLoggingOut) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      if (AuthController.isLoggingOut) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  /// Handle customer data not found - clear cache and logout
  /// This method is public so other controllers can call it
  Future<void> handleCustomerDataNotFound() async {
    if (AuthController.isLoggingOut) return;
    try {
      // Clear local data immediately
      activeCustomer.value = null;
      addresses.clear();
      orders.clear();
      isEditingProfile.value = false;

      // Clear authentication tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');
      await _storage.remove('preserve_guest_channel');

      // Show message to user
      ErrorDialog.show(
        title: AppStrings.sessionExpired,
        message: AppStrings.noCustomerDataLoginAgain,
      );

      if (AuthController.isLoggingOut) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
          Logger.logFunction(functionName: 'logout', mutationName: 'LogoutUser');
      if (AuthController.isLoggingOut) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  /// Logout customer
  Future<void> logout() async {
    if (AuthController.isLoggingOut) return;
    try {
      final response = await GraphqlService.client.value.mutate$LogoutUser(
        Options$Mutation$LogoutUser(),
      );

      // Don't show error dialog for logout - just log it
      if (response.hasException) {
      }

      // Clear local data
      activeCustomer.value = null;
      addresses.clear();
      orders.clear();
      isEditingProfile.value = false;

      // Clear authentication tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');

      // Clear guest channel preservation flag
      await _storage.remove('preserve_guest_channel');

      // Navigate to home after logout (AuthController also navigates to home)
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      if (!AuthController.isLoggingOut) Get.offAllNamed(AppRoutes.home);
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
    debugPrint('[UpdateLocation] switchChannelByPostalCode START: postalCode=$postalCode, city=$city, showLoading=$showLoading');
    Logger.logFunction(functionName: 'switchChannelByPostalCode', queryName: 'GetAvailableChannels');

    try {
      if (showLoading) {
        LoadingDialog.show(message: 'Checking availability...');
      }
      debugPrint('[UpdateLocation] GetAvailableChannels QUERY START');
      debugPrint('[UpdateLocation]   operationName: GetAvailableChannels');
      debugPrint('[UpdateLocation]   variables: { postalCode: "$postalCode" }');
      final response = await GraphqlService.client.value.query$GetAvailableChannels(
        Options$Query$GetAvailableChannels(
          variables: Variables$Query$GetAvailableChannels(postalCode: postalCode),
        ),
      );

      debugPrint('[UpdateLocation] GetAvailableChannels QUERY RESPONSE');
      debugPrint('[UpdateLocation]   hasException: ${response.hasException}');
      final exc = response.exception;
      if (exc != null) {
        debugPrint('[UpdateLocation]   exception: $exc');
        final gqlErrors = exc.graphqlErrors;
        if (gqlErrors.isNotEmpty) {
          for (int i = 0; i < gqlErrors.length; i++) {
            final err = gqlErrors[i];
            debugPrint('[UpdateLocation]   graphqlError[$i]: message=${err.message}, locations=${err.locations}');
          }
        }
        if (exc.linkException != null) {
          debugPrint('[UpdateLocation]   linkException: ${exc.linkException}');
        }
      }
      debugPrint('[UpdateLocation]   response.data present: ${response.data != null}');
      if (response.data != null) {
        debugPrint('[UpdateLocation]   response.data keys: ${response.data!.keys.toList()}');
        if (response.data!.containsKey('getAvailableChannels')) {
          final list = response.data!['getAvailableChannels'];
          debugPrint('[UpdateLocation]   getAvailableChannels type: ${list.runtimeType}, length: ${list is List ? list.length : "n/a"}');
        }
      }
      debugPrint('[UpdateLocation]   parsedData present: ${response.parsedData != null}');

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to get available channels')) {
        debugPrint('[UpdateLocation] GetAvailableChannels checkResponseForErrors=true, returning false');
        if (showLoading) LoadingDialog.hide();
        return false;
      }

      final channels = response.parsedData?.getAvailableChannels ?? [];
      debugPrint('[UpdateLocation] GetAvailableChannels parsed ${channels.length} channel(s)');
      for (int i = 0; i < channels.length; i++) {
        final ch = channels[i];
        debugPrint('[UpdateLocation]   channel[$i]: code=${ch.code}, name=${ch.name}, type=${ch.type}, isAvailable=${ch.isAvailable}, token=${ch.token != null ? "***" : null}');
      }

      if (channels.isEmpty) {
        debugPrint('[UpdateLocation] No channels returned, showing error');
        if (showLoading) {
          LoadingDialog.hide();
          ErrorDialog.show(
            title: 'Service Not Available',
            message: 'Service is not available for this location.',
          );
        }
        return false;
      }

      final cityChannels = channels.where((c) => c.type == Enum$ChannelType.CITY).toList();
      debugPrint('[UpdateLocation] CITY-type channels: ${cityChannels.length}');

      final availableCityChannels = channels.where(
        (channel) => channel.type == Enum$ChannelType.CITY && channel.isAvailable == true,
      ).toList();
      debugPrint('[UpdateLocation] Available CITY channels: ${availableCityChannels.length}');

      if (availableCityChannels.isEmpty) {
        debugPrint('[UpdateLocation] No available CITY channel, showing error');
        if (showLoading) {
          LoadingDialog.hide();
          ErrorDialog.show(
            title: 'Service Not Available',
            message: 'Service is not available for this location.',
          );
        }
        return false;
      }

      Query$GetAvailableChannels$getAvailableChannels? selectedChannel;
      if (city != null && city.isNotEmpty) {
        selectedChannel = availableCityChannels.firstWhereOrNull(
          (channel) => channel.code.toLowerCase().contains(city.toLowerCase()) ||
                       channel.name.toLowerCase().contains(city.toLowerCase()) ||
                       channel.name.toLowerCase() == city.toLowerCase(),
        );
        if (selectedChannel != null) {
          debugPrint('[UpdateLocation] Selected channel by city match: code=${selectedChannel.code}, name=${selectedChannel.name}');
        } else {
          selectedChannel = availableCityChannels.first;
          debugPrint('[UpdateLocation] No city match, using first available: code=${selectedChannel.code}, name=${selectedChannel.name}');
        }
      } else {
        selectedChannel = availableCityChannels.first;
        debugPrint('[UpdateLocation] No city provided, using first available: code=${selectedChannel.code}, name=${selectedChannel.name}');
      }

      debugPrint('[UpdateLocation] Calling ChannelService.setChannelInfo: token=***, code=${selectedChannel.code}, name=${selectedChannel.name}, type=${selectedChannel.type}, postalCode=$postalCode');
      await ChannelService.setChannelInfo(
        token: selectedChannel.token ?? '',
        code: selectedChannel.code,
        name: selectedChannel.name,
        type: selectedChannel.type.toString(),
        postalCode: postalCode,
      );
      debugPrint('[UpdateLocation] setChannelInfo done, calling refreshAllDataAfterChannelChange');
      // Clear guest channel preservation flag since user is explicitly changing location
      await _storage.remove('preserve_guest_channel');
      await refreshAllDataAfterChannelChange();
      // Subscribe to FCM topic for this channel so Firebase messages use the channel topic
      await NotificationService.instance.subscribeToChannelTopic();
      // Update customer customFields.location with channel name so backend has the selected location
      await updateCustomerLocation(selectedChannel.name);
      await Future.delayed(Duration(milliseconds: 100));
      if (showLoading) LoadingDialog.hide();
      debugPrint('[UpdateLocation] switchChannelByPostalCode SUCCESS, returning true');
      return true;
    } catch (e, stack) {
      debugPrint('[UpdateLocation] switchChannelByPostalCode EXCEPTION: $e');
      debugPrint('[UpdateLocation] stackTrace: $stack');
      if (showLoading) LoadingDialog.hide();
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
      return false;
    }
  }

  /// Get available channels for a postal code
  Future<List<Query$GetAvailableChannels$getAvailableChannels>> getAvailableChannels(String postalCode) async {
    debugPrint('[UpdateLocation] getAvailableChannels QUERY START: postalCode=$postalCode');
    Logger.logFunction(functionName: 'getAvailableChannels', queryName: 'GetAvailableChannels');

    try {
      final response = await GraphqlService.client.value.query$GetAvailableChannels(
        Options$Query$GetAvailableChannels(
          variables: Variables$Query$GetAvailableChannels(postalCode: postalCode),
        ),
      );

      debugPrint('[UpdateLocation] getAvailableChannels QUERY RESPONSE: hasException=${response.hasException}, dataPresent=${response.data != null}, parsedPresent=${response.parsedData != null}');
      final exc2 = response.exception;
      if (exc2 != null) {
        debugPrint('[UpdateLocation] getAvailableChannels exception: $exc2');
        final gqlErrors2 = exc2.graphqlErrors;
        if (gqlErrors2.isNotEmpty) {
          for (int i = 0; i < gqlErrors2.length; i++) {
            debugPrint('[UpdateLocation] getAvailableChannels graphqlError[$i]: ${gqlErrors2[i].message}');
          }
        }
        if (exc2.linkException != null) {
          debugPrint('[UpdateLocation] getAvailableChannels linkException: ${exc2.linkException}');
        }
      }
      if (response.data != null && response.data!.containsKey('getAvailableChannels')) {
        final raw = response.data!['getAvailableChannels'];
        debugPrint('[UpdateLocation] getAvailableChannels raw list length: ${raw is List ? raw.length : "n/a"}');
      }

      if (checkResponseForErrors(response, customErrorMessage: 'Failed to get available channels')) {
        debugPrint('[UpdateLocation] getAvailableChannels checkResponseForErrors=true, returning []');
        return [];
      }

      final channels = response.parsedData?.getAvailableChannels ?? [];
      debugPrint('[UpdateLocation] getAvailableChannels returning ${channels.length} channel(s)');
      return channels;
    } catch (e, stack) {
      debugPrint('[UpdateLocation] getAvailableChannels EXCEPTION: $e');
      debugPrint('[UpdateLocation] getAvailableChannels stackTrace: $stack');
      handleException(e, customErrorMessage: 'Failed to fetch available channels');
      return [];
    }
  }

  /// Refresh all data after channel change
  Future<void> refreshAllDataAfterChannelChange() async {
    try {
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
        bannerController.bannerList.clear(); // Clear old banners
        await bannerController.getBannersForChannel();
      }
      
      // Refresh collections (channel-specific)
      if (collectionController != null) {
        collectionController.allCollections.clear(); // Clear old collections
        await collectionController.fetchAllCollections(force: true);
      }
      
      // Refresh frequently ordered products
      if (bannerController != null) {
        await bannerController.getFrequentlyOrderedProducts();
      }
      
      // Refresh active order for new channel (guest and logged-in) so cart shows correctly when switching A→B and back B→A
      if (cartController != null) {
        await cartController.getActiveOrder();
      }
      
      // Refresh customer favorites (if user is logged in)
      if (bannerController != null && _isUserAuthenticated()) {
        await bannerController.getCustomerFavorites();
      }
    } catch (e) {
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
      // Check channel token before making query
      // ignore: unused_local_variable
      final _channelToken = GraphqlService.channelToken;
      final _storedChannelToken = ChannelService.getChannelToken();
      
      // Ensure channel token is set in GraphQLService
      if (_channelToken.isEmpty && _storedChannelToken != null && _storedChannelToken.toString().isNotEmpty) {
        await GraphqlService.setToken(key: 'channel', token: _storedChannelToken.toString());
      }
      
      if (GraphqlService.channelToken.isEmpty) {
      } else {
      }
      final response = await GraphqlService.client.value.query$PostalCodes(
        Options$Query$PostalCodes(),
      );
      // Print raw response data for debugging
      if (response.data != null) {
        if (response.data!['postalCodes'] != null) {
          // Postal codes data available
        } else {
        }
      } else {
      }
      
      if (response.hasException) {
        if (response.exception?.graphqlErrors != null) {
          // ignore: unused_local_variable
          for (var error in response.exception!.graphqlErrors) {
          }
        }
      }

      // Check for errors in response
      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to fetch postal codes')) {
        if (response.hasException) {
          if (response.exception?.graphqlErrors != null) {
            // ignore: unused_local_variable
            for (var error in response.exception!.graphqlErrors) {
            }
          }
          
          if (response.exception?.linkException != null) {
          }
        }
        return [];
      }
      final postalCodes = response.parsedData?.postalCodes ?? [];
      if (postalCodes.isNotEmpty) {
        for (int i = 0; i < postalCodes.length; i++) {
          // ignore: unused_local_variable
          final _code = postalCodes[i];
        }
      } else {
      }
      return postalCodes;
    } catch (e) {
      
      // Print stack trace
      // Additional error context
      
      // Check if it's a GraphQL specific error
      if (e.toString().contains('GraphQL') || e.toString().contains('graphql')) {
      }
      
      // For timeout/network errors, don't show error dialog in UI
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection') ||
          e.toString().contains('Network')) {
        return [];
      }
      handleException(e, customErrorMessage: 'Failed to fetch postal codes');
      return [];
    }
  }

  /// Check if postal code is in local storage, if not get from shipping address and fetch channel
  /// Skips when preserve_guest_channel is set (guest cart claimed at login) so guest's channel stays.
  Future<void> checkAndSetPostalCodeFromShippingAddress() async {
    try {
      final preserveGuestChannel = _storage.read('preserve_guest_channel') == true;
      if (preserveGuestChannel) {
        debugPrint('[UpdateLocation] checkAndSetPostalCodeFromShippingAddress: SKIP (guest cart claimed, preserve channel)');
        return;
      }

      // Check if postal code exists in local storage
      final storedPostalCode = _storage.read('postal_code');
      if (storedPostalCode != null && storedPostalCode.toString().isNotEmpty) {
        return;
      }

      // Get default shipping address
      final defaultShippingAddress = addresses.firstWhereOrNull(
        (address) => address.defaultShippingAddress == true,
      );

      if (defaultShippingAddress == null) {
        return;
      }

      final postalCode = defaultShippingAddress.postalCode;
      if (postalCode == null || postalCode.isEmpty) {
        return;
      }
      // Save postal code to local storage
      await _storage.write('postal_code', postalCode);
      // Fetch channel by postal code
      final success = await switchChannelByPostalCode(
        postalCode,
        city: defaultShippingAddress.city,
        showLoading: false, // Don't show loading dialog during background operation
      );

      if (success) {
      } else {
      }
    } catch (e) {
      // Don't throw - this is a background operation
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
                    onPressed: () {
                      Get.back();
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
}
