
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../graphql/Customer.graphql.dart';
import '../../graphql/schema.graphql.dart';
import 'customer_models.dart';
import '../../services/graphql_client.dart';
import '../../theme/colors.dart';
import '../../widgets/snackbar.dart';
import '../utilitycontroller/utilitycontroller.dart';

class CustomerController extends GetxController {
  final UtilityController utilityController = Get.find();
  final GetStorage _storage = GetStorage();

  // State
  final Rx<CustomerProfile?> profile = Rx<CustomerProfile?>(null);
  final RxList<CustomerAddress> addresses = <CustomerAddress>[].obs;
  final RxInt loyaltyPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Get active customer
  Future<bool> getActiveCustomer(BuildContext context) async {
    utilityController.setLoadingState(true);

    try {
      debugPrint('[Customer] Fetching active customer');

      final response = await GraphqlService.client.value.query$GetActiveCustomer(
        Options$Query$GetActiveCustomer(),
      );

      if (response.hasException) {
        debugPrint('[Customer] GraphQL exception: ${response.exception.toString()}');
        utilityController.setLoadingState(false);
        return false;
      }

      final customerData = response.parsedData?.activeCustomer;
      if (customerData != null) {
        debugPrint('[Customer] Active customer found');

        // Parse customer profile
        profile.value = CustomerProfile.fromJson(customerData.toJson());

        // Parse loyalty points safely
        loyaltyPoints.value = customerData.customFields?.loyaltyPointsAvailable ?? 0;

        // Parse addresses
        if (customerData.addresses != null) {
          final list = customerData.addresses!
              .map((a) => CustomerAddress.fromJson(a.toJson()))
              .toList();
          addresses.assignAll(list);
        }

        debugPrint('[Customer] Customer profile and addresses loaded successfully');
      } else {
        debugPrint('[Customer] No active customer found');
      }

      utilityController.setLoadingState(false);
      return true;
    } catch (e, stacktrace) {
      debugPrint('[Customer] Exception getting customer: $e');
      debugPrint('[Customer] Stacktrace: $stacktrace');
      SnackBarWidget.show(
        context,
        'Error loading profile',
        backgroundColor: AppColors.error,
      );
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Update customer profile
  Future<bool> updateProfile({
    required BuildContext context,
    required String firstName,
    required String lastName,
  })
  async {
    utilityController.setLoadingState(true);
    
    try {
      debugPrint('[Customer] Updating profile: $firstName $lastName');


      final response = await GraphqlService.client.value.mutate$UpdateCustomer(
        Options$Mutation$UpdateCustomer(
          variables: Variables$Mutation$UpdateCustomer(
            input: Input$UpdateCustomerInput(
           firstName: firstName,
            lastName: lastName,
          ),
       ),
      ),
    );

    if (response.hasException) {
      utilityController.setLoadingState(false);
      SnackBarWidget.show(
        context,
        'Failed to update profile',
        backgroundColor: AppColors.error,
      );
     return false;
    }
    if (response.parsedData?.updateCustomer != null) {
      profile.value = CustomerProfile.fromJson(response.parsedData!.updateCustomer!.toJson());
    }

      SnackBarWidget.show(
        context,
        'Profile updated successfully!',
        backgroundColor: AppColors.accent,
      );
      utilityController.setLoadingState(false);
      return true;
    } catch (e) {
      debugPrint('[Customer] Exception updating profile: $e');
      SnackBarWidget.show(
        context,
        'Error updating profile',
        backgroundColor: AppColors.error,
      );
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Get customer addresses (same as getActiveCustomer - addresses included)
  Future<bool> getAddresses(BuildContext context) async {
    return await getActiveCustomer(context);
  }

  /// Add new address
  Future<bool> addAddress(BuildContext context, CustomerAddress address) async {
    debugPrint('[Customer] Starting addAddress function');

    utilityController.setLoadingState(true);
    debugPrint('[Customer] Loading state set to true');

    try {
      debugPrint('[Customer] Adding address for: ${address.city}');
      debugPrint('[Customer] Full address object: $address');

      // Construct GraphQL input safely
      final input = Input$CreateAddressInput(
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2 ?? '',
        city: address.city,
        province: address.province ?? '',
        postalCode: address.postalCode,
        phoneNumber: address.phoneNumber ?? '',
        defaultShippingAddress: address.defaultShippingAddress,
        defaultBillingAddress: address.defaultBillingAddress,
        countryCode: 'In',
      );

      debugPrint('[Customer] Address Input JSON: ${input.toJson()}');

      // Call GraphQL mutation
      debugPrint('[Customer] Sending GraphQL mutation...');
      final response = await GraphqlService.client.value.mutate$CreateCustomerAddress(
        Options$Mutation$CreateCustomerAddress(
          variables: Variables$Mutation$CreateCustomerAddress(input: input),
        ),
      );
      debugPrint('[Customer] GraphQL mutation complete');

      // Log response fully
      debugPrint('[Customer] GraphQL Response Data: ${response.data}');
      if (response.hasException) {
        debugPrint('[Customer] GraphQL Errors: ${response.exception.toString()}');
        SnackBarWidget.show(context, 'Failed to add address', backgroundColor: AppColors.error);
        utilityController.setLoadingState(false);
        debugPrint('[Customer] Loading state set to false after exception');
        return false;
      }

      if (response.parsedData?.createCustomerAddress != null) {
        final newAddress = CustomerAddress.fromJson(
          response.parsedData!.createCustomerAddress!.toJson(),
        );
        addresses.add(newAddress);
        debugPrint('[Customer] Address added to local list: $newAddress');
      }

      SnackBarWidget.show(context, 'Address added successfully!', backgroundColor: AppColors.accent);
      utilityController.setLoadingState(false);
      debugPrint('[Customer] Loading state set to false after success');
      return true;
    } catch (e, stackTrace) {
      debugPrint('[Customer] Exception adding address: $e');
      debugPrint('[Customer] Stack trace: $stackTrace');
      SnackBarWidget.show(context, 'Error adding address', backgroundColor: AppColors.error);
      utilityController.setLoadingState(false);
      debugPrint('[Customer] Loading state set to false after exception');
      return false;
    }
  }

  /// Update address
  Future<bool> updateAddress(BuildContext context, CustomerAddress address) async {
    if (address.id == null) {
      SnackBarWidget.show(
        context,
        'Invalid address',
        backgroundColor: AppColors.error,
      );
      return false;
    }

    utilityController.setLoadingState(true);
    
    try {
      debugPrint('[Customer] Updating address: ${address.id}');


   final response = await GraphqlService.client.value.mutate$UpdateCustomerAddress(
         Options$Mutation$UpdateCustomerAddress(
          variables: Variables$Mutation$UpdateCustomerAddress(
             input: Input$UpdateAddressInput.fromJson(address.toJson()),
           ),
         ),
       );

       if (response.hasException) {
         utilityController.setLoadingState(false);
         SnackBarWidget.show(
           context,
           'Failed to update address',
           backgroundColor: AppColors.error,
         );
         return false;
       }

       if (response.parsedData?.updateCustomerAddress != null) {
         final updated = CustomerAddress.fromJson(response.parsedData!.updateCustomerAddress!.toJson());
         final index = addresses.indexWhere((a) => a.id == address.id);
         if (index != -1) {
           addresses[index] = updated;
         }
       }

      SnackBarWidget.show(
        context,
        'Address updated successfully!',
        backgroundColor: AppColors.accent,
      );
      utilityController.setLoadingState(false);
      return true;
    } catch (e) {
      debugPrint('[Customer] Exception updating address: $e');
      SnackBarWidget.show(
        context,
        'Error updating address',
        backgroundColor: AppColors.error,
      );
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Delete address
  Future<bool> deleteAddress(BuildContext context, String addressId) async {
    utilityController.setLoadingState(true);
    
    try {
      debugPrint('[Customer] Deleting address: $addressId');

      final response = await GraphqlService.client.value.mutate$DeleteCustomerAddress(
        Options$Mutation$DeleteCustomerAddress(
          variables: Variables$Mutation$DeleteCustomerAddress(id: addressId),
        ),
      );

      if (response.hasException) {
        utilityController.setLoadingState(false);
        SnackBarWidget.show(
          context,
          'Failed to delete address',
          backgroundColor: AppColors.error,
        );
        return false;
      }

      if (response.parsedData?.deleteCustomerAddress?.success == true) {
        addresses.removeWhere((a) => a.id == addressId);
      }

      SnackBarWidget.show(
        context,
        'Address deleted successfully!',
        backgroundColor: AppColors.accent,
      );
      utilityController.setLoadingState(false);
      return true;
    } catch (e) {
      debugPrint('[Customer] Exception deleting address: $e');
      SnackBarWidget.show(
        context,
        'Error deleting address',
        backgroundColor: AppColors.error,
      );
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Clear all customer data
  Future<void> clearData() async {
    profile.value = null;
    addresses.clear();
    loyaltyPoints.value = 0;
    await _storage.remove('customer_profile');
    await _storage.remove('customer_addresses');
    debugPrint('[Customer] Data cleared');
  }



  /// Getters
  String get fullName => profile.value?.fullName ?? 'Guest';
  String get email => profile.value?.emailAddress ?? '';
  String get phone => profile.value?.phoneNumber ?? '';
  bool get isVerified => profile.value?.verified ?? false;
  int get points => loyaltyPoints.value;

  CustomerAddress? get shippingAddress {
    try {
      return addresses.firstWhere((a) => a.defaultShippingAddress);
    } catch (e) {
      return null;
    }
  }

  CustomerAddress? get billingAddress {
    try {
      return addresses.firstWhere((a) => a.defaultBillingAddress);
    } catch (e) {
      return null;
    }
  }
}