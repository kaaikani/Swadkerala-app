import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:unified_ecomapp/graphql/Customer.graphql.dart';
import 'package:unified_ecomapp/graphql/authenticate.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import 'customer_models.dart';

class CustomerController extends GetxController {
  // Observable variables
  final Rx<CustomerModel?> activeCustomer = Rx<CustomerModel?>(null);
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEditingProfile = false.obs;
  final RxString error = ''.obs;

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
      isLoading.value = true;
      error.value = '';

      debugPrint('[Customer] Fetching active customer...');

      final response = await GraphqlService.client.value.query$GetActiveCustomer();

      if (response.hasException) {
        debugPrint('[Customer] Exception: ${response.exception}');
        error.value = 'Failed to load customer data';
        return;
      }

      final customerData = response.parsedData?.activeCustomer;
      if (customerData != null) {
        // Convert the GraphQL response to a Map
        final customerJson = customerData.toJson();
        debugPrint('[Customer] Raw customer data: $customerJson');
        
        activeCustomer.value = CustomerModel.fromJson(customerJson);
        addresses.value = activeCustomer.value?.addresses ?? [];
        orders.value = activeCustomer.value?.orders?.items ?? [];
        
        _initializeProfileFields();
        
        debugPrint('[Customer] Customer loaded: ${activeCustomer.value?.firstName} ${activeCustomer.value?.lastName}');
        debugPrint('[Customer] Addresses: ${addresses.length}');
        debugPrint('[Customer] Orders: ${orders.length}');
      } else {
        error.value = 'No customer data found';
        debugPrint('[Customer] No customer data found');
      }
    } catch (e) {
      debugPrint('[Customer] Error: $e');
      error.value = 'Failed to load customer data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Update customer profile
  Future<bool> updateCustomer() async {
    try {
      isLoading.value = true;
      debugPrint('[Customer] Updating customer profile...');

      // Log the input values clearly
      debugPrint('[Customer] Mutation input: firstName=${firstNameController.value}, lastName=${lastNameController.value}');

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
      if (response.hasException) {
        debugPrint('[Customer] Update exception: ${response.exception}');
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
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new address
  Future<bool> createAddress(AddressModel address) async {
    try {
      isLoading.value = true;

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

      final response = await GraphqlService.client.value.mutate$CreateCustomerAddress(
        Options$Mutation$CreateCustomerAddress(
          variables: Variables$Mutation$CreateCustomerAddress(input: input),
        ),
      );

      if (response.hasException) {
        debugPrint('[Customer] Create address exception: ${response.exception}');
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
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing address
  Future<bool> updateAddress(AddressModel address) async {
    try {
      isLoading.value = true;

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

      final response = await GraphqlService.client.value.mutate$UpdateCustomerAddress(
        Options$Mutation$UpdateCustomerAddress(
          variables: Variables$Mutation$UpdateCustomerAddress(input: input),
        ),
      );

      if (response.hasException) {
        debugPrint('[Customer] Update address exception: ${response.exception}');
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
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete address
  Future<bool> deleteAddress(String addressId) async {
    try {
      isLoading.value = true;

      debugPrint('[Customer] Deleting address: $addressId');

      final response = await GraphqlService.client.value.mutate$DeleteCustomerAddress(
        Options$Mutation$DeleteCustomerAddress(
          variables: Variables$Mutation$DeleteCustomerAddress(id: addressId),
        ),
      );

      if (response.hasException) {
        debugPrint('[Customer] Delete address exception: ${response.exception}');
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
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle profile editing mode
Future  <void> toggleEditProfile() async {
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

  /// Logout customer
  void logout() async {
    try {
      debugPrint('[Customer] Logging out...');
      
      final response = await GraphqlService.client.value.mutate$LogoutUser(
        Options$Mutation$LogoutUser(),
      );

      if (response.hasException) {
        debugPrint('[Customer] Logout exception: ${response.exception}');
      }

      // Clear local data
      activeCustomer.value = null;
      addresses.clear();
      orders.clear();
      isEditingProfile.value = false;
      
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
  int get loyaltyPoints => activeCustomer.value?.customFields?.loyaltyPointsAvailable ?? 0;

  /// Get total orders
  int get totalOrders => orders.length;

  /// Get default address
  AddressModel? get defaultAddress {
    return addresses.firstWhereOrNull((address) => address.defaultShippingAddress);
  }
}
