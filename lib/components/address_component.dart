import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../widgets/snackbar.dart';

class AddressComponent extends StatelessWidget {
  final CustomerController customerController;

  const AddressComponent({
    super.key,
    required this.customerController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final addresses = customerController.addresses;
      
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.green, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'My Addresses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: () => _addNewAddress(),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            addresses.isEmpty
                ? _buildEmptyAddressState()
                : Column(
                    children: addresses.map((address) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCompactAddressCard(address, 0),
                      ),
                    ).toList(),
                  ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyAddressState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off,
              size: 48,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Addresses Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first address to get started with faster checkout',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _addNewAddress(),
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactAddressCard(dynamic address, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        address.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (address.defaultShippingAddress)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.streetLine1}, ${address.city}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${address.postalCode}, ${address.country.name}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                onPressed: () => _editAddress(address),
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              ),
              IconButton(
                onPressed: () => _deleteAddress(address.id),
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ],
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
                  TextFormField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: streetLine1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Street Address 1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: streetLine2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Street Address 2 (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: provinceController,
                    decoration: const InputDecoration(
                      labelText: 'State/Province',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: postalCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Postal Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company (Optional)',
                      border: OutlineInputBorder(),
                    ),
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
              ElevatedButton(
                onPressed: () async {
                  if (fullNameController.text.isEmpty ||
                      streetLine1Controller.text.isEmpty ||
                      cityController.text.isEmpty ||
                      postalCodeController.text.isEmpty) {
                    showErrorSnackbar('Please fill in all required fields');
                    return;
                  }

                  final newAddress = AddressModel(
                    id: '',
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
                    ),
                  );

                  final success = await customerController.createAddress(newAddress);
                  if (success) {
                    Get.back();
                    showSuccessSnackbar('Address added successfully');
                    customerController.refreshAddresses();
                  } else {
                    showErrorSnackbar('Failed to add address');
                  }
                },
                child: const Text('Add Address'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editAddress(dynamic address) {
    // Implementation for editing address
    showSuccessSnackbar('Edit address functionality');
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
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await customerController.deleteAddress(addressId);
              if (success) {
                customerController.refreshAddresses();
                showSuccessSnackbar('Address deleted successfully');
              } else {
                showErrorSnackbar('Failed to delete address');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
