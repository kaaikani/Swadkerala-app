import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/textbox.dart';
import '../widgets/snackbar.dart';
import '../widgets/empty_state.dart';
import '../theme/colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with TickerProviderStateMixin {
  final CustomerController customerController = Get.put(CustomerController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch customer data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.getActiveCustomer();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'My Account',
          actions: [
            IconButton(
            onPressed: () => _showLogoutDialog(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Obx(() {
        if (customerController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (customerController.activeCustomer.value == null) {
          return const EmptyState(
            icon: Icons.person_off,
            title: 'No Account Data',
            subtitle: 'Unable to load your account information',
          );
        }

        return Column(
          children: [
            // Customer Info Header
            _buildCustomerHeader(),
            
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Profile', icon: Icon(Icons.person)),
                  Tab(text: 'Addresses', icon: Icon(Icons.location_on)),
                  Tab(text: 'Orders', icon: Icon(Icons.shopping_bag)),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
              children: [
                  _buildProfileTab(),
                  _buildAddressesTab(),
                  _buildOrdersTab(),
                ],
              ),
            ),
          ],
          );
        }),
    );
  }

  Widget _buildCustomerHeader() {
    final customer = customerController.activeCustomer.value!;
    final loyaltyPoints = customer.customFields?.loyaltyPointsAvailable ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
      children: [
          // Profile Picture
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              '${customer.firstName[0]}${customer.lastName[0]}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Name
          Text(
            '${customer.firstName} ${customer.lastName}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          

          
          // Loyalty Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                  Text(
                  '$loyaltyPoints Points',
                    style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                      color: Colors.white,
                  ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Edit Profile Form
          _buildEditProfileForm(),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm() {
    final controller = customerController;

    return Obx(() {
      final customer = controller.activeCustomer.value;
      if (customer == null) return const CircularProgressIndicator();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            TextButtonField(
              controller: controller.firstNameController,
              hint: 'First Name',
              enabled: controller.isEditingProfile.value,
            ),
            const SizedBox(height: 16),
            TextButtonField(
              controller: controller.lastNameController,
              hint: 'Last Name',
              enabled: controller.isEditingProfile.value,
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: controller.isEditingProfile.value ? 'Save Changes' : 'Edit Profile',
                    onPressed: controller.isEditingProfile.value
                        ? () async {
                      final success = await controller.updateCustomer();
                      if (success) {
                        showSuccessSnackbar('Profile updated successfully');
                      } else {
                        showErrorSnackbar('Failed to update profile');
                      }
                    }
                        : controller.toggleEditProfile,
                  ),
                ),
                if (controller.isEditingProfile.value) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      onPressed: controller.toggleEditProfile,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddressesTab() {
    return Obx(() {
      final addresses = customerController.addresses;
      
      return Column(
        children: [
          // Add Address Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: AppButton(
              text: 'Add New Address',
              onPressed: () async => _addNewAddress(),
              backgroundColor: AppColors.primary,
            ),
          ),
          // Addresses List
          Expanded(
            child: addresses.isEmpty
                ? const EmptyState(
                    icon: Icons.location_off,
                    title: 'No Addresses',
                    subtitle: 'You haven\'t added any addresses yet',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return _buildAddressCard(address, index);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildAddressCard(dynamic address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
                  children: [
              Expanded(
                child: Text(
                  address.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (address.defaultShippingAddress)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${address.streetLine1}, ${address.city}',
            style: const TextStyle(fontSize: 14),
          ),
          if (address.streetLine2.isNotEmpty)
            Text(
              address.streetLine2,
              style: const TextStyle(fontSize: 14),
            ),
          Text(
            '${address.postalCode}, ${address.country.name}',
            style: const TextStyle(fontSize: 14),
          ),
          if (address.phoneNumber.isNotEmpty)
            Text(
              address.phoneNumber,
              style: const TextStyle(fontSize: 14),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Edit',
                  onPressed: () async => _editAddress(address),
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: 'Delete',
                  onPressed: () async => _deleteAddress(address.id),
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return Obx(() {
      final orders = customerController.orders;
      
      if (orders.isEmpty) {
        return const EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: 'No Orders',
          subtitle: 'You haven\'t placed any orders yet',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      );
    });
  }

  Widget _buildOrderCard(dynamic order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Order #${order.code}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getOrderStatusColor(order.state).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.state,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getOrderStatusColor(order.state),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Placed on ${_formatDate(order.orderPlacedAt)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Total: Rs.${(order.totalWithTax / 100).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getOrderStatusColor(String state) {
    switch (state.toLowerCase()) {
      case 'paymentauthorized':
      case 'paymentsettled':
        return Colors.green;
      case 'arrangingpayment':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              customerController.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    final success = await customerController.updateCustomer();
    if (success) {
      showSuccessSnackbar('Profile updated successfully');
    } else {
      showErrorSnackbar('Failed to update profile');
    }
  }

  void _editAddress(dynamic address) {

    // Create controllers for the form
    final fullNameController = TextEditingController(text: address.fullName ?? '');
    final streetLine1Controller = TextEditingController(text: address.streetLine1 ?? '');
    final streetLine2Controller = TextEditingController(text: address.streetLine2 ?? '');
    final cityController = TextEditingController(text: address.city ?? '');
    final provinceController = TextEditingController(text: address.province ?? '');
    final postalCodeController = TextEditingController(text: address.postalCode ?? '');
    final phoneController = TextEditingController(text: address.phoneNumber ?? '');
    final companyController = TextEditingController(text: address.company ?? '');
    
    bool defaultShipping = address.defaultShippingAddress ?? false;
    bool defaultBilling = address.defaultBillingAddress ?? false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButtonField(
                controller: fullNameController,
                  hint: 'Full Name',
                ),
                const SizedBox(height: 16),
                TextButtonField(
                controller: streetLine1Controller,
                hint: 'Street Address 1',
                ),
                const SizedBox(height: 16),
                TextButtonField(
                controller: streetLine2Controller,
                hint: 'Street Address 2 (Optional)',
                ),
                const SizedBox(height: 16),
                TextButtonField(
                controller: cityController,
                  hint: 'City',
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 16),
                TextButtonField(
                controller: postalCodeController,
                  hint: 'Postal Code',
                ),
                const SizedBox(height: 16),
                TextButtonField(
                controller: phoneController,
                hint: 'Phone Number',
                ),
                const SizedBox(height: 16),

              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: defaultShipping,
                    onChanged: (value) {
                      setState(() {
                        defaultShipping = value ?? false;
                      });
                    },
                  ),
                  const Text('Default Shipping Address'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: defaultBilling,
                    onChanged: (value) {
                      setState(() {
                        defaultBilling = value ?? false;
                      });
                    },
                  ),
                  const Text('Default Billing Address'),
                ],
              ),
              ],
            ),
          ),
          actions: [
            TextButton(
            onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          AppButton(
            text: 'Save',
              onPressed: () async {
              // Prevent multiple submissions
              if (customerController.isLoading.value) {
                return;
              }
              
              if (fullNameController.text.isEmpty ||
                  streetLine1Controller.text.isEmpty ||
                  cityController.text.isEmpty ||
                  postalCodeController.text.isEmpty) {
                showErrorSnackbar('Please fill in all required fields');
                return;
              }

              // Create AddressModel from the form data
              final updatedAddress = AddressModel(
                id: address.id,
                fullName: fullNameController.text,
                streetLine1: streetLine1Controller.text,
                streetLine2: streetLine2Controller.text.isNotEmpty ? streetLine2Controller.text : '',
                city: cityController.text,
                province: provinceController.text.isNotEmpty ? provinceController.text : '',
                postalCode: postalCodeController.text,
                phoneNumber: phoneController.text.isNotEmpty ? phoneController.text : '',
                company: companyController.text.isNotEmpty ? companyController.text : '',
                defaultShippingAddress: defaultShipping,
                defaultBillingAddress: defaultBilling,
                country: address.country, // Keep the existing country
              );

              // Call the update method
              final success = await customerController.updateAddress(updatedAddress);
              if (success) {
                // Close dialog first
                Get.back();
                // Show success message
                showSuccessSnackbar('Address updated successfully');
                // Force UI refresh
                customerController.refreshAddresses();
              } else {
                showErrorSnackbar('Failed to update address');
              }
              },
            ),
          ],
      );
        },
      ),
    );
  }

  void _deleteAddress(String addressId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Delete',
            onPressed: () async {
              Get.back();
              
              // Show loading indicator
              showSuccessSnackbar('Deleting address...');
              
              final success = await customerController.deleteAddress(addressId);
              if (success) {
                // Force UI refresh first
                customerController.refreshAddresses();
                // Show success message
                showSuccessSnackbar('Address deleted successfully');
              } else {
                showErrorSnackbar('Failed to delete address. ${customerController.error.value}');
              }
            },
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  void _addNewAddress() {
    // Create controllers for the form
    final fullNameController = TextEditingController();
    final streetLine1Controller = TextEditingController();
    final streetLine2Controller = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final postalCodeController = TextEditingController();
    final phoneController = TextEditingController();
    final companyController = TextEditingController();
    
    bool defaultShipping = false;
    bool defaultBilling = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Address'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              TextButtonField(
                controller: fullNameController,
                hint: 'Full Name',
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: streetLine1Controller,
                hint: 'Street Address 1',
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: streetLine2Controller,
                hint: 'Street Address 2 (Optional)',
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: cityController,
                hint: 'City',
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: provinceController,
                hint: 'State/Province',
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: postalCodeController,
                hint: 'Postal Code',
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: phoneController,
                hint: 'Phone Number',
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: companyController,
                hint: 'Company (Optional)',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: defaultShipping,
                    onChanged: (value) {
                      setState(() {
                        defaultShipping = value ?? false;
                      });
                    },
                  ),
                  const Text('Default Shipping Address'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: defaultBilling,
                    onChanged: (value) {
                      setState(() {
                        defaultBilling = value ?? false;
                      });
                    },
                  ),
                  const Text('Default Billing Address'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Add Address',
            onPressed: () async {
              // Prevent multiple submissions
              if (customerController.isLoading.value) {
                return;
              }
              
              if (fullNameController.text.isEmpty ||
                  streetLine1Controller.text.isEmpty ||
                  cityController.text.isEmpty ||
                  postalCodeController.text.isEmpty) {
                showErrorSnackbar('Please fill in all required fields');
                return;
              }

              // Create AddressModel for the API
              final newAddress = AddressModel(
                id: '', // Will be generated by the backend
                fullName: fullNameController.text,
                streetLine1: streetLine1Controller.text,
                streetLine2: streetLine2Controller.text.isNotEmpty ? streetLine2Controller.text : '',
                city: cityController.text,
                province: provinceController.text.isNotEmpty ? provinceController.text : '',
                postalCode: postalCodeController.text,
                phoneNumber: phoneController.text.isNotEmpty ? phoneController.text : '',
                company: companyController.text.isNotEmpty ? companyController.text : '',
                defaultShippingAddress: defaultShipping,
                defaultBillingAddress: defaultBilling,
                country: CountryModel(
                  id: 'IN',
                  name: 'India',
                  code: 'IN',
                  languageCode: 'en',
                ), // Default to India
              );

              // Call the create method
              final success = await customerController.createAddress(newAddress);
              if (success) {
                // Close dialog first
                Get.back();
                // Show success message
                showSuccessSnackbar('Address added successfully');
                // Force UI refresh
                customerController.refreshAddresses();
              } else {
                showErrorSnackbar('Failed to add address. ${customerController.error.value}');
              }
            },
          ),
        ],
      );
        },
      ),
    );
  }
}