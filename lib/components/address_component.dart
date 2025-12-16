import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../widgets/snackbar.dart';
import '../theme/theme.dart';
import '../utils/responsive.dart';

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

      if (addresses.isEmpty) {
        return _buildEmptyState(context);
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: addresses.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _buildAddressCard(context, addresses[index]),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(40)),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: ResponsiveUtils.rp(80),
            color: AppColors.textTertiary,
          ),
          SizedBox(height: ResponsiveUtils.rp(20)),
          Text(
            'No addresses yet',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(20),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            'Add your delivery address',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, dynamic address) {
    final isDefault = address.defaultShippingAddress;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: isDefault ? AppColors.button : AppColors.border,
          width: isDefault ? ResponsiveUtils.rp(2) : ResponsiveUtils.rp(1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            decoration: BoxDecoration(
              color: isDefault
                  ? AppColors.button.withValues(alpha: 0.08)
                  : AppColors.grey100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveUtils.rp(12)),
                topRight: Radius.circular(ResponsiveUtils.rp(12)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: ResponsiveUtils.rp(20),
                            color: isDefault
                                ? AppColors.button
                                : AppColors.textSecondary,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Expanded(
                            child: Text(
                              address.fullName,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isDefault)
                        Container(
                          margin: EdgeInsets.only(top: ResponsiveUtils.rp(8)),
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.rp(10),
                              vertical: ResponsiveUtils.rp(4)),
                          decoration: BoxDecoration(
                            color: AppColors.button,
                            borderRadius:
                                BorderRadius.circular(ResponsiveUtils.rp(4)),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: ResponsiveUtils.sp(10),
                              fontWeight: FontWeight.bold,
                              letterSpacing: ResponsiveUtils.rp(0.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _showEditDialog(context, address),
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                        child: Icon(Icons.edit_outlined,
                            color: AppColors.info,
                            size: ResponsiveUtils.rp(20)),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.rp(4)),
                    InkWell(
                      onTap: () {
                        // Check if this is the only address
                        if (customerController.addresses.length <= 1) {
                          showErrorSnackbar('Cannot delete the only address. At least one address must be kept.');
                          return;
                        }
                        _showDeleteDialog(context, address.id);
                      },
                      borderRadius:
                          BorderRadius.circular(ResponsiveUtils.rp(8)),
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
                        child: Icon(Icons.delete_outline,
                            color: AppColors.error,
                            size: ResponsiveUtils.rp(20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Address Details
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.streetLine1,
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textPrimary,
                      height: 1.4),
                ),
                if (address.streetLine2 != null &&
                    address.streetLine2.isNotEmpty) ...[
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Text(
                    address.streetLine2,
                    style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        color: AppColors.textPrimary,
                        height: 1.4),
                  ),
                ],
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  '${address.city}, ${address.province ?? ''}',
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textPrimary,
                      height: 1.4),
                ),
                SizedBox(height: ResponsiveUtils.rp(4)),
                Text(
                  '${address.postalCode}, ${address.country.name}',
                  style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textSecondary,
                      height: 1.4),
                ),
                if (address.phoneNumber != null &&
                    address.phoneNumber.isNotEmpty) ...[
                  SizedBox(height: ResponsiveUtils.rp(8)),
                  Row(
                    children: [
                      Icon(Icons.phone,
                          size: ResponsiveUtils.rp(16),
                          color: AppColors.textSecondary),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        address.phoneNumber,
                        style: TextStyle(
                            fontSize: ResponsiveUtils.sp(14),
                            color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, dynamic address) {
    _showAddressForm(context, existingAddress: address);
  }

  void _showDeleteDialog(BuildContext context, String addressId) {
    // Check if this is the only address
    if (customerController.addresses.length <= 1) {
      showErrorSnackbar('Cannot delete the only address. At least one address must be kept.');
      return;
    }

    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12))),
        title: Text('Delete Address?',
            style: TextStyle(
                fontSize: ResponsiveUtils.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        content: Text('Are you sure you want to delete this address?',
            style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: isDeleting ? null : () async {
              // Prevent multiple clicks
              setState(() {
                isDeleting = true;
              });
              
              // Double check before deletion
              if (customerController.addresses.length <= 1) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                showErrorSnackbar('Cannot delete the only address. At least one address must be kept.');
                return;
              }
              
              // Close dialog first
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              
              // Perform deletion
              final success = await customerController.deleteAddress(addressId);
              if (success) {
                customerController.refreshAddresses();
                showSuccessSnackbar('Address deleted');
              } else {
                showErrorSnackbar('Failed to delete address');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textLight,
            ),
            child: isDeleting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textLight),
                    ),
                  )
                : Text('Delete', style: TextStyle(color: AppColors.textLight)),
          ),
        ],
      ),
      ),
    );
  }

  void _showAddressForm(BuildContext context, {dynamic existingAddress}) {
    final isEdit = existingAddress != null;
    final box = GetStorage();

    // Get channel code from storage and use it as city
    final channelCode = box.read('channel_code') ?? '';

    // Get customer data for auto-fill (only when adding new address)
    final customer = customerController.activeCustomer.value;
    final autoFullName = !isEdit && customer != null
        ? '${customer.firstName} ${customer.lastName}'.trim()
        : '';
    final autoPhone =
        !isEdit && customer != null ? (customer.phoneNumber ?? '') : '';

    final nameController = TextEditingController(
        text: existingAddress?.fullName ??
            (autoFullName.isNotEmpty ? autoFullName : ''));
    final line1Controller =
        TextEditingController(text: existingAddress?.streetLine1 ?? '');
    final line2Controller =
        TextEditingController(text: existingAddress?.streetLine2 ?? '');
    final cityController = TextEditingController(
        text: channelCode.isNotEmpty
            ? channelCode
            : (existingAddress?.city ?? ''));
    final postalController =
        TextEditingController(text: existingAddress?.postalCode ?? '');
    final phoneController = TextEditingController(
        text: existingAddress?.phoneNumber ??
            (autoPhone.isNotEmpty ? autoPhone : ''));

    // Get address count and determine default address logic
    final addressCount = customerController.addresses.length;
    final isOnlyAddress = addressCount <= 1; // Only one address or no addresses
    final isOnlyDefault = isEdit && 
        existingAddress?.defaultShippingAddress == true && 
        addressCount == 1;
    
    // If adding first address, it must be default
    // If editing only address, it must remain default
    bool isDefault = isEdit 
        ? (existingAddress?.defaultShippingAddress ?? false)
        : (addressCount == 0); // Auto-default if no addresses exist

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent, // Faster rendering
            insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(ResponsiveUtils.rp(16))),
                      border:
                          Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                          decoration: BoxDecoration(
                            color: AppColors.button.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(ResponsiveUtils.rp(10)),
                          ),
                          child: Icon(
                            isEdit ? Icons.edit : Icons.add,
                            color: AppColors.button,
                            size: ResponsiveUtils.rp(24),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          child: Text(
                            isEdit ? 'Edit Address' : 'Add New Address',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(20),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.close, color: AppColors.textSecondary),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                  // Form
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                              nameController, 'Full Name', Icons.person,
                              required: true),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          _buildFormField(
                              line1Controller, 'Street Address', Icons.home,
                              required: true),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          _buildFormField(line2Controller,
                              'Apt, Suite, etc (Optional)', Icons.apartment),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          _buildFormField(
                              cityController, 'City', Icons.location_city,
                              required: true, readOnly: true),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          _buildFormField(postalController, 'ZIP Code',
                              Icons.markunread_mailbox,
                              required: true),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          _buildFormField(phoneController, 'Phone', Icons.phone,
                              keyboardType: TextInputType.phone),
                          SizedBox(height: ResponsiveUtils.rp(20)),
                          InkWell(
                            onTap: () {
                              // Prevent unchecking if it's the only default address
                              if (isOnlyDefault && isDefault) {
                                showErrorSnackbar('Unable to deselect default address. At least one address must be set as default.');
                                return;
                              }
                              // Prevent unchecking if it's the only address
                              if (isOnlyAddress && isDefault) {
                                showErrorSnackbar('Unable to deselect default address. At least one address must be set as default.');
                                return;
                              }
                              setState(() => isDefault = !isDefault);
                            },
                            borderRadius:
                                BorderRadius.circular(ResponsiveUtils.rp(10)),
                            child: Opacity(
                              opacity: (isOnlyAddress && isDefault) ? 0.6 : 1.0,
                              child: Container(
                                padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                                decoration: BoxDecoration(
                                  color: isDefault
                                      ? AppColors.button.withValues(alpha: 0.08)
                                      : AppColors.grey100,
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveUtils.rp(10)),
                                  border: Border.all(
                                    color: isDefault
                                        ? AppColors.button.withValues(alpha: 0.3)
                                        : AppColors.border,
                                    width: ResponsiveUtils.rp(1.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: ResponsiveUtils.rp(24),
                                      height: ResponsiveUtils.rp(24),
                                      decoration: BoxDecoration(
                                        color: isDefault
                                            ? AppColors.button
                                            : AppColors.surface,
                                        borderRadius: BorderRadius.circular(
                                            ResponsiveUtils.rp(6)),
                                        border: Border.all(
                                          color: isDefault
                                              ? AppColors.button
                                              : AppColors.border,
                                          width: ResponsiveUtils.rp(2),
                                        ),
                                      ),
                                      child: isDefault
                                          ? Icon(Icons.check,
                                              color: AppColors.textLight,
                                              size: ResponsiveUtils.rp(16))
                                          : null,
                                    ),
                                    SizedBox(width: ResponsiveUtils.rp(12)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Make this my default address',
                                            style: TextStyle(
                                              fontSize: ResponsiveUtils.sp(15),
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          if (isOnlyAddress && isDefault)
                                            Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: Text(
                                                'This is your only address and must remain default',
                                                style: TextStyle(
                                                  fontSize: ResponsiveUtils.sp(12),
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(ResponsiveUtils.rp(16))),
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveUtils.rp(16)),
                              side: BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.rp(10)),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.rp(12)),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (nameController.text.isEmpty ||
                                  line1Controller.text.isEmpty ||
                                  cityController.text.isEmpty ||
                                  postalController.text.isEmpty) {
                                showErrorSnackbar(
                                    'Please fill all required fields');
                                return;
                              }

                              final addressData = AddressModel(
                                id: existingAddress?.id ?? '',
                                fullName: nameController.text,
                                streetLine1: line1Controller.text,
                                streetLine2: line2Controller.text,
                                city: cityController.text,
                                province: 'Tamil Nadu', // Default province
                                postalCode: postalController.text,
                                phoneNumber: phoneController.text,
                                company: '',
                                defaultShippingAddress: isDefault,
                                defaultBillingAddress: isDefault,
                                country: existingAddress?.country ??
                                    CountryModel(
                                      id: 'IN',
                                      name: 'India',
                                      code: 'IN',
                                      languageCode: 'en',
                                    ),
                              );

                              bool success;
                              if (isEdit) {
                                success = await customerController
                                    .updateAddress(addressData);
                              } else {
                                success = await customerController
                                    .createAddress(addressData);
                              }

                              if (success) {
                                Navigator.pop(context);
                                showSuccessSnackbar(isEdit
                                    ? 'Address updated successfully!'
                                    : 'Address added successfully!');
                                customerController.refreshAddresses();
                              } else {
                                showErrorSnackbar(
                                    'Failed to save address. Please try again.');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.button,
                              foregroundColor: AppColors.textLight,
                              padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveUtils.rp(16)),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.rp(10)),
                              ),
                            ),
                            child: Text(
                              isEdit ? 'Update Address' : 'Save Address',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildFormField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            if (readOnly)
              Container(
                margin: EdgeInsets.only(left: ResponsiveUtils.rp(8)),
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.rp(6),
                    vertical: ResponsiveUtils.rp(2)),
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
                ),
                child: Text(
                  'Auto',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(10),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.rp(8)),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(15),
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: readOnly ? 'Auto-filled' : 'Enter $label',
            hintStyle: TextStyle(
                color: AppColors.textTertiary,
                fontSize: ResponsiveUtils.sp(14)),
            prefixIcon: Icon(icon,
                color:
                    readOnly ? AppColors.textTertiary : AppColors.textSecondary,
                size: ResponsiveUtils.rp(20)),
            suffixIcon: readOnly
                ? Icon(Icons.lock_outline,
                    color: AppColors.textTertiary, size: ResponsiveUtils.rp(18))
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
              borderSide: BorderSide(
                  color: readOnly ? AppColors.border : AppColors.button,
                  width: ResponsiveUtils.rp(2)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(16),
                vertical: ResponsiveUtils.rp(14)),
            filled: true,
            fillColor: readOnly ? AppColors.grey100 : AppColors.inputFill,
          ),
        ),
      ],
    );
  }
}
