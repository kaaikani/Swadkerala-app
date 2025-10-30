import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../theme/theme.dart';
import '../widgets/snackbar.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController = Get.find<CustomerController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Addresses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(context, customerController),
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
      body: Obx(() {
        final addresses = customerController.addresses;
        
        if (addresses.isEmpty) {
          return _buildEmptyState(context, customerController);
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            return _buildAddressCard(context, addresses[index], customerController);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context, CustomerController customerController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          SizedBox(height: 24),
          Text(
            'No Addresses Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Add your delivery address to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddAddressDialog(context, customerController),
            icon: Icon(Icons.add_rounded),
            label: Text('Add First Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, dynamic address, CustomerController customerController) {
    final isDefault = address.defaultShippingAddress;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault ? AppColors.primary : Colors.grey[200]!,
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDefault ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: isDefault ? AppColors.primary : Colors.grey[600],
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.fullName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (isDefault)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () => _showEditAddressDialog(context, address, customerController),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, address.id, customerController),
                ),
              ],
            ),
          ),
          
          // Address Details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.home_outlined, address.streetLine1),
                if (address.streetLine2 != null && address.streetLine2.isNotEmpty)
                  _buildDetailRow(Icons.home_work_outlined, address.streetLine2),
                _buildDetailRow(
                  Icons.location_city_outlined,
                  '${address.city}, ${address.province ?? ''}',
                ),
                _buildDetailRow(
                  Icons.map_outlined,
                  '${address.postalCode}, ${address.country.name}',
                ),
                if (address.phoneNumber != null && address.phoneNumber.isNotEmpty)
                  _buildDetailRow(Icons.phone_outlined, address.phoneNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, CustomerController customerController) {
    _showAddressForm(context, customerController, null);
  }

  void _showEditAddressDialog(BuildContext context, dynamic address, CustomerController customerController) {
    _showAddressForm(context, customerController, address);
  }

  void _showAddressForm(BuildContext context, CustomerController customerController, dynamic existingAddress) {
    final isEdit = existingAddress != null;
    final box = GetStorage();
    
    // Get channel code from storage and use it as city
    final channelCode = box.read('channel_code') ?? '';
    
    // Get customer data for auto-fill (only when adding new address)
    final customer = customerController.activeCustomer.value;
    final autoFullName = !isEdit && customer != null 
        ? '${customer.firstName} ${customer.lastName}'.trim() 
        : '';
    final autoPhone = !isEdit && customer != null 
        ? (customer.phoneNumber ?? '') 
        : '';
    
    final fullNameController = TextEditingController(
      text: existingAddress?.fullName ?? (autoFullName.isNotEmpty ? autoFullName : '')
    );
    final streetLine1Controller = TextEditingController(text: existingAddress?.streetLine1 ?? '');
    final streetLine2Controller = TextEditingController(text: existingAddress?.streetLine2 ?? '');
    final cityController = TextEditingController(text: channelCode.isNotEmpty ? channelCode : (existingAddress?.city ?? ''));
    final postalCodeController = TextEditingController(text: existingAddress?.postalCode ?? '');
    final phoneController = TextEditingController(
      text: existingAddress?.phoneNumber ?? (autoPhone.isNotEmpty ? autoPhone : '')
    );
    
    bool defaultShipping = existingAddress?.defaultShippingAddress ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isEdit ? Icons.edit_location : Icons.add_location,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        isEdit ? 'Edit Address' : 'Add New Address',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField(fullNameController, 'Full Name', Icons.person, required: true),
                        SizedBox(height: 16),
                        _buildTextField(streetLine1Controller, 'Address Line 1', Icons.home, required: true),
                        SizedBox(height: 16),
                        _buildTextField(streetLine2Controller, 'Address Line 2 (Optional)', Icons.home_work),
                        SizedBox(height: 16),
                        _buildTextField(cityController, 'City', Icons.location_city, required: true, keyboardType: TextInputType.text, readOnly: true),
                        SizedBox(height: 16),

                         _buildTextField(postalCodeController, 'Postal Code', Icons.markunread_mailbox, required: true),
                        SizedBox(height: 16),
                             _buildTextField(phoneController, 'Phone', Icons.phone, keyboardType: TextInputType.phone),

                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: defaultShipping ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: defaultShipping ? AppColors.primary : Colors.grey[300]!,
                            ),
                          ),
                          child: CheckboxListTile(
                            value: defaultShipping,
                            onChanged: (value) => setState(() => defaultShipping = value ?? false),
                            title: Text(
                              'Set as default address',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Actions
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (fullNameController.text.isEmpty ||
                                streetLine1Controller.text.isEmpty ||
                                cityController.text.isEmpty ||
                                postalCodeController.text.isEmpty) {
                              showErrorSnackbar('Please fill in all required fields');
                              return;
                            }

                            final addressData = AddressModel(
                              id: existingAddress?.id ?? '',
                              fullName: fullNameController.text,
                              streetLine1: streetLine1Controller.text,
                              streetLine2: streetLine2Controller.text,
                              city: cityController.text,
                              province: '',  // No state needed
                              postalCode: postalCodeController.text,
                              phoneNumber: phoneController.text,
                              company: '',
                              defaultShippingAddress: defaultShipping,
                              defaultBillingAddress: defaultShipping,
                              country: existingAddress?.country ?? CountryModel(
                                id: 'IN',
                                name: 'India',
                                code: 'IN',
                                languageCode: 'en',
                              ),
                            );

                            bool success;
                            if (isEdit) {
                              success = await customerController.updateAddress(addressData);
                            } else {
                              success = await customerController.createAddress(addressData);
                            }

                            if (success) {
                              Navigator.pop(context);
                              showSuccessSnackbar(isEdit ? 'Address updated!' : 'Address added!');
                              customerController.refreshAddresses();
                            } else {
                              showErrorSnackbar('Failed to ${isEdit ? 'update' : 'add'} address');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isEdit ? 'Update' : 'Add Address',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: TextStyle(
        fontSize: 15,
        color: readOnly ? Colors.grey[600] : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : '') + (readOnly ? ' (Auto)' : ''),
        prefixIcon: Icon(icon, color: readOnly ? Colors.grey[400] : AppColors.primary),
        suffixIcon: readOnly ? Icon(Icons.lock_outline, color: Colors.grey[400], size: 18) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: readOnly ? Colors.grey[300]! : AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey[100] : Colors.grey[50],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String addressId, CustomerController customerController) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Delete Address?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this address? This action cannot be undone.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
