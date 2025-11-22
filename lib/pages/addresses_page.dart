import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/customer/customer_models.dart';
import '../theme/theme.dart';
import '../widgets/snackbar.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  bool _showAddForm = false;
  dynamic _editingAddress;

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController =
        Get.find<CustomerController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Addresses',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.card,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: (_showAddForm || _editingAddress != null) ? null : FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _showAddForm = true;
          });
        },
        backgroundColor: AppColors.button,
        icon: Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: Text('Add Address',
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      body: Obx(() {
        final addresses = customerController.addresses;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Add Address Form (shown inline)
              if (_showAddForm)
                _buildAddAddressForm(context, customerController),
              
              // Edit Address Form (shown inline)
              if (_editingAddress != null)
                _buildEditAddressForm(context, customerController, _editingAddress),
              
              // Addresses List (only show when form is not visible)
              if (!_showAddForm && _editingAddress == null) ...[
                if (addresses.isEmpty)
                  _buildEmptyState(context, customerController)
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Addresses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...addresses.map((address) => Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: _buildAddressCard(
                              context, address, customerController),
                        )).toList(),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, CustomerController customerController) {
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
            onPressed: () {
              setState(() {
                _showAddForm = true;
              });
            },
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

  Widget _buildAddressCard(BuildContext context, dynamic address,
      CustomerController customerController) {
    final isDefault = address.defaultShippingAddress;

    // Build compact address text
    List<String> addressParts = [];
    if (address.streetLine1.isNotEmpty) addressParts.add(address.streetLine1);
    if (address.streetLine2 != null && address.streetLine2.isNotEmpty) {
      addressParts.add(address.streetLine2);
    }
    String addressLine = addressParts.join(', ');
    String cityLine = '${address.city}${address.postalCode.isNotEmpty ? ', ${address.postalCode}' : ''}, ${address.country.name}';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDefault ? AppColors.button : AppColors.border,
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Icon
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDefault
                    ? AppColors.button.withValues(alpha: 0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.location_on,
                color: isDefault ? AppColors.button : AppColors.textSecondary,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name and Default Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.fullName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isDefault)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.button,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6),
                  // Address lines (compact)
                  if (addressLine.isNotEmpty)
                    Text(
                      addressLine,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 4),
                  // City and postal code
                  Text(
                    cityLine,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                  if (address.phoneNumber != null &&
                      address.phoneNumber.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          address.phoneNumber,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8),
            // Action Buttons
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.edit_outlined, 
                      color: AppColors.button, size: 20),
                  onPressed: () => _showEditAddressDialog(
                      context, address, customerController),
                ),
                SizedBox(height: 4),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.delete_outline, 
                      color: Colors.red, size: 20),
                  onPressed: () => _showDeleteDialog(
                      context, address.id, customerController),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressForm(
      BuildContext context, CustomerController customerController) {
    return _AddAddressFormWidget(
      onCancel: () {
        setState(() {
          _showAddForm = false;
        });
      },
      onSuccess: () {
        setState(() {
          _showAddForm = false;
        });
      },
      customerController: customerController,
    );
  }

  void _showEditAddressDialog(BuildContext context, dynamic address,
      CustomerController customerController) {
    setState(() {
      _editingAddress = address;
    });
  }

  Widget _buildEditAddressForm(
      BuildContext context, CustomerController customerController, dynamic existingAddress) {
    return _EditAddressFormWidget(
      existingAddress: existingAddress,
      onCancel: () {
        setState(() {
          _editingAddress = null;
        });
      },
      onSuccess: () {
        setState(() {
          _editingAddress = null;
        });
      },
      customerController: customerController,
    );
  }

  void _showDeleteDialog(BuildContext context, String addressId,
      CustomerController customerController) {
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

class _AddAddressFormWidget extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSuccess;
  final CustomerController customerController;

  const _AddAddressFormWidget({
    required this.onCancel,
    required this.onSuccess,
    required this.customerController,
  });

  @override
  State<_AddAddressFormWidget> createState() => _AddAddressFormWidgetState();
}

class _AddAddressFormWidgetState extends State<_AddAddressFormWidget> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final channelCode = box.read('channel_code') ?? '';
    final customer = widget.customerController.activeCustomer.value;
    final autoFullName = customer != null
        ? '${customer.firstName} ${customer.lastName}'.trim()
        : '';
    final autoPhone = customer != null ? (customer.phoneNumber ?? '') : '';

    final fullNameController = TextEditingController(
        text: autoFullName.isNotEmpty ? autoFullName : '');
    final streetLine1Controller = TextEditingController();
    final streetLine2Controller = TextEditingController();
    final cityController = TextEditingController(
        text: channelCode.isNotEmpty ? channelCode : '');
    final postalCodeController = TextEditingController();
    final phoneController = TextEditingController(
        text: autoPhone.isNotEmpty ? autoPhone : '');

    bool defaultShipping = false;
    final Map<String, String?> errors = {};

    return StatefulBuilder(
      builder: (context, setState) {
        void validateFields() {
          errors.clear();
          if (fullNameController.text.trim().isEmpty) {
            errors['fullName'] = 'Full name is required';
          }
          if (streetLine1Controller.text.trim().isEmpty) {
            errors['streetLine1'] = 'Address line 1 is required';
          }
          if (postalCodeController.text.trim().isEmpty) {
            errors['postalCode'] = 'Postal code is required';
          }
          if (phoneController.text.isNotEmpty && 
              phoneController.text.length < 10) {
            errors['phone'] = 'Please enter a valid phone number';
          }
          setState(() {});
        }

        return Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.add_location, color: AppColors.button, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add New Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: widget.onCancel,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Form Fields
              _buildTextField(
                  fullNameController, 'Full Name', Icons.person,
                  required: true,
                  errorText: errors['fullName'],
                  onChanged: () {
                    if (errors.containsKey('fullName')) {
                      errors.remove('fullName');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 16),
              _buildTextField(
                  streetLine1Controller, 'Address Line 1', Icons.home,
                  required: true,
                  errorText: errors['streetLine1'],
                  onChanged: () {
                    if (errors.containsKey('streetLine1')) {
                      errors.remove('streetLine1');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 16),
              _buildTextField(streetLine2Controller,
                  'Address Line 2 (Optional)', Icons.home_work),
              SizedBox(height: 16),
              _buildTextField(
                  cityController, 'City', Icons.location_city,
                  required: true,
                  keyboardType: TextInputType.text,
                  readOnly: true),
              SizedBox(height: 16),
              _buildTextField(postalCodeController, 'Postal Code',
                  Icons.markunread_mailbox,
                  required: true,
                  errorText: errors['postalCode'],
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: () {
                    if (errors.containsKey('postalCode')) {
                      errors.remove('postalCode');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 16),
              _buildTextField(phoneController, 'Phone', Icons.phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  errorText: errors['phone'],
                  onChanged: () {
                    if (errors.containsKey('phone')) {
                      errors.remove('phone');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: defaultShipping
                      ? AppColors.button.withValues(alpha: 0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: defaultShipping
                        ? AppColors.button
                        : AppColors.border,
                    width: defaultShipping ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: defaultShipping,
                      onChanged: (value) => setState(
                          () => defaultShipping = value ?? false),
                      activeColor: AppColors.button,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Set as default address',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Cancel',
                          style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        validateFields();
                        if (errors.isNotEmpty) {
                          return;
                        }

                        final addressData = AddressModel(
                          id: '',
                          fullName: fullNameController.text.trim(),
                          streetLine1: streetLine1Controller.text.trim(),
                          streetLine2: streetLine2Controller.text.trim(),
                          city: cityController.text.trim(),
                          province: '',
                          postalCode: postalCodeController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          company: '',
                          defaultShippingAddress: defaultShipping,
                          defaultBillingAddress: defaultShipping,
                          country: CountryModel(
                            id: 'IN',
                            name: 'India',
                            code: 'IN',
                            languageCode: 'en',
                          ),
                        );

                        final success = await widget.customerController
                            .createAddress(addressData);

                        if (success) {
                          widget.onSuccess();
                          showSuccessSnackbar('Address added!');
                          widget.customerController.refreshAddresses();
                        } else {
                          showErrorSnackbar('Failed to add address');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                      child: Text(
                        'Add Address',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? errorText,
    VoidCallback? onChanged,
    int? maxLength,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLength: maxLength,
          onChanged: (_) => onChanged?.call(),
          style: TextStyle(
            fontSize: 15,
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : '') + (readOnly ? ' (Auto)' : ''),
            labelStyle: TextStyle(
              color: hasError 
                  ? AppColors.error 
                  : (readOnly ? AppColors.textSecondary : AppColors.textSecondary),
            ),
            prefixIcon: Icon(
              icon, 
              color: hasError 
                  ? AppColors.error 
                  : (readOnly ? AppColors.textSecondary : AppColors.button),
            ),
            suffixIcon: readOnly
                ? Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 18)
                : null,
            errorText: hasError ? errorText : null,
            errorStyle: TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.5 : 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError 
                    ? AppColors.error 
                    : (readOnly ? AppColors.border : AppColors.button),
                width: hasError ? 1.5 : 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: readOnly 
                ? AppColors.background 
                : (hasError 
                    ? AppColors.error.withValues(alpha: 0.05)
                    : AppColors.inputFill),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
class _EditAddressFormWidget extends StatefulWidget {
  final dynamic existingAddress;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;
  final CustomerController customerController;

  const _EditAddressFormWidget({
    required this.existingAddress,
    required this.onCancel,
    required this.onSuccess,
    required this.customerController,
  });

  @override
  State<_EditAddressFormWidget> createState() => _EditAddressFormWidgetState();
}

class _EditAddressFormWidgetState extends State<_EditAddressFormWidget> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final channelCode = box.read('channel_code') ?? '';

    final fullNameController = TextEditingController(
        text: widget.existingAddress?.fullName ?? '');
    final streetLine1Controller =
        TextEditingController(text: widget.existingAddress?.streetLine1 ?? '');
    final streetLine2Controller =
        TextEditingController(text: widget.existingAddress?.streetLine2 ?? '');
    final cityController = TextEditingController(
        text: channelCode.isNotEmpty
            ? channelCode
            : (widget.existingAddress?.city ?? ''));
    final postalCodeController =
        TextEditingController(text: widget.existingAddress?.postalCode ?? '');
    final phoneController = TextEditingController(
        text: widget.existingAddress?.phoneNumber ?? '');

    bool defaultShipping = widget.existingAddress?.defaultShippingAddress ?? false;
    final Map<String, String?> errors = {};

    return StatefulBuilder(
      builder: (context, setState) {
        void validateFields() {
          errors.clear();
          if (fullNameController.text.trim().isEmpty) {
            errors['fullName'] = 'Full name is required';
          }
          if (streetLine1Controller.text.trim().isEmpty) {
            errors['streetLine1'] = 'Address line 1 is required';
          }
          if (postalCodeController.text.trim().isEmpty) {
            errors['postalCode'] = 'Postal code is required';
          }
          if (phoneController.text.isNotEmpty && 
              phoneController.text.length < 10) {
            errors['phone'] = 'Please enter a valid phone number';
          }
          setState(() {});
        }

        return Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.edit_location, color: AppColors.button, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Edit Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: widget.onCancel,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Form Fields
              _buildTextField(
                  fullNameController, 'Full Name', Icons.person,
                  required: true,
                  errorText: errors['fullName'],
                  onChanged: () {
                    if (errors.containsKey('fullName')) {
                      errors.remove('fullName');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 16),
              _buildTextField(
                  streetLine1Controller, 'Address Line 1', Icons.home,
                  required: true,
                  errorText: errors['streetLine1'],
                  onChanged: () {
                    if (errors.containsKey('streetLine1')) {
                      errors.remove('streetLine1');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 16),
              _buildTextField(streetLine2Controller,
                  'Address Line 2 (Optional)', Icons.home_work),
              SizedBox(height: 16),
              _buildTextField(
                  cityController, 'City', Icons.location_city,
                  required: true,
                  keyboardType: TextInputType.text,
                  readOnly: true),
              SizedBox(height: 16),
              _buildTextField(postalCodeController, 'Postal Code',
                  Icons.markunread_mailbox,
                  required: true,
                  errorText: errors['postalCode'],
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: () {
                    if (errors.containsKey('postalCode')) {
                      errors.remove('postalCode');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 16),
              _buildTextField(phoneController, 'Phone', Icons.phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  errorText: errors['phone'],
                  onChanged: () {
                    if (errors.containsKey('phone')) {
                      errors.remove('phone');
                      setState(() {});
                    }
                  }),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: defaultShipping
                      ? AppColors.button.withValues(alpha: 0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: defaultShipping
                        ? AppColors.button
                        : AppColors.border,
                    width: defaultShipping ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: defaultShipping,
                      onChanged: (value) => setState(
                          () => defaultShipping = value ?? false),
                      activeColor: AppColors.button,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Set as default address',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Cancel',
                          style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        validateFields();
                        if (errors.isNotEmpty) {
                          return;
                        }

                        final addressData = AddressModel(
                          id: widget.existingAddress?.id ?? '',
                          fullName: fullNameController.text.trim(),
                          streetLine1: streetLine1Controller.text.trim(),
                          streetLine2: streetLine2Controller.text.trim(),
                          city: cityController.text.trim(),
                          province: '',
                          postalCode: postalCodeController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          company: '',
                          defaultShippingAddress: defaultShipping,
                          defaultBillingAddress: defaultShipping,
                          country: widget.existingAddress?.country ??
                              CountryModel(
                                id: 'IN',
                                name: 'India',
                                code: 'IN',
                                languageCode: 'en',
                              ),
                        );

                        final success = await widget.customerController
                            .updateAddress(addressData);

                        if (success) {
                          widget.onSuccess();
                          showSuccessSnackbar('Address updated!');
                          widget.customerController.refreshAddresses();
                        } else {
                          showErrorSnackbar('Failed to update address');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                      child: Text(
                        'Update Address',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? errorText,
    VoidCallback? onChanged,
    int? maxLength,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLength: maxLength,
          onChanged: (_) => onChanged?.call(),
          style: TextStyle(
            fontSize: 15,
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : '') + (readOnly ? ' (Auto)' : ''),
            labelStyle: TextStyle(
              color: hasError 
                  ? AppColors.error 
                  : (readOnly ? AppColors.textSecondary : AppColors.textSecondary),
            ),
            prefixIcon: Icon(
              icon, 
              color: hasError 
                  ? AppColors.error 
                  : (readOnly ? AppColors.textSecondary : AppColors.button),
            ),
            suffixIcon: readOnly
                ? Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 18)
                : null,
            errorText: errorText,
            errorStyle: TextStyle(
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.5 : 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError 
                    ? AppColors.error 
                    : (readOnly ? AppColors.border : AppColors.button),
                width: hasError ? 1.5 : 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: readOnly 
                ? AppColors.background 
                : (hasError 
                    ? AppColors.error.withValues(alpha: 0.05)
                    : AppColors.inputFill),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

