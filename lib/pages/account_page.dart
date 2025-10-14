import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../theme/colors.dart';
import '../widgets/button.dart';
import '../widgets/textbox.dart';
import '../widgets/info_card.dart';
import '../widgets/address_card.dart';
import '../controllers/customer/customer_models.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final CustomerController _customerController = Get.put(CustomerController());
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _customerController.getActiveCustomer(context);
      _customerController.getAddresses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('My Account'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _showLogoutDialog,
            ),
          ],
        ),
        body: Obx(() {
          if (_customerController.utilityController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildProfileCard(),
                _buildLoyaltyCard(),
                _buildShippingAddressCard(),
                _buildBillingAddressCard(),
                _buildAllAddressesCard(),
                const SizedBox(height: 16),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileCard() {
    return InfoCard(
      title: 'Profile Information',
      action: IconButton(
        icon: const Icon(Icons.edit, color: AppColors.primary),
        onPressed: _showEditProfileDialog,
      ),
      children: [
        InfoItem(
          icon: Icons.person,
          label: 'Full Name',
          value: _customerController.fullName,
        ),

        InfoItem(
          icon: Icons.phone,
          label: 'Phone',
          value: _customerController.phone,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildLoyaltyCard() {
    return Obx(() {
      final points = _customerController.points;
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Loyalty Points',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$points Points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildShippingAddressCard() {
    return Obx(() {
      final address = _customerController.shippingAddress;
      if (address == null) return const SizedBox.shrink();

      return InfoCard(
        title: 'Default Shipping Address',
        action: IconButton(
          icon: const Icon(Icons.edit, color: AppColors.primary),
          onPressed: () => _showEditAddressDialog(address),
        ),
        children: [
          AddressCard(
            fullName: address.fullName,
            streetLine1: address.streetLine1,
            streetLine2: address.streetLine2,
            city: address.city,
            province: address.province,
            postalCode: address.postalCode,
            country: address.country,
            phoneNumber: address.phoneNumber,
            isShipping: true,
            isBilling: false,
          ),
        ],
      );
    });
  }

  Widget _buildBillingAddressCard() {
    return Obx(() {
      final address = _customerController.billingAddress;
      if (address == null) return const SizedBox.shrink();

      return InfoCard(
        title: 'Default Billing Address',
        action: IconButton(
          icon: const Icon(Icons.edit, color: AppColors.primary),
          onPressed: () => _showEditAddressDialog(address),
        ),
        children: [
          AddressCard(
            fullName: address.fullName,
            streetLine1: address.streetLine1,
            streetLine2: address.streetLine2,
            city: address.city,
            province: address.province,
            postalCode: address.postalCode,
            country: address.country,
            phoneNumber: address.phoneNumber,
            isShipping: false,
            isBilling: true,
          ),
        ],
      );
    });
  }

  Widget _buildAllAddressesCard() {
    return InfoCard(
      title: 'All Saved Addresses',
      action: IconButton(
        icon: const Icon(Icons.add_circle, color: AppColors.primary),
        onPressed: _showAddAddressDialog,
      ),
      children: [
        Obx(() {
          if (_customerController.addresses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(Icons.location_off, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'No addresses saved',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: _customerController.addresses.map((address) {
              return AddressCard(
                fullName: address.fullName,
                streetLine1: address.streetLine1,
                streetLine2: address.streetLine2,
                city: address.city,
                province: address.province,
                postalCode: address.postalCode,
                country: address.country,
                phoneNumber: address.phoneNumber,
                isShipping: address.defaultShippingAddress,
                isBilling: address.defaultBillingAddress,
                onEdit: () => _showEditAddressDialog(address),
                onDelete: () => _showDeleteDialog(address),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  void _showEditProfileDialog() {
    final firstNameCtrl = TextEditingController(
      text: _customerController.profile.value?.firstName ?? '',
    );
    final lastNameCtrl = TextEditingController(
      text: _customerController.profile.value?.lastName ?? '',
    );


    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextButtonField(
                controller: firstNameCtrl,
                hint: 'First Name',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextButtonField(
                controller: lastNameCtrl,
                hint: 'Last Name',
                textCapitalization: TextCapitalization.words,
              ),

            ],
          )

        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _customerController.updateProfile(
                context: context,
                firstName: firstNameCtrl.text.trim(),
                lastName: lastNameCtrl.text.trim(),
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog() {
    _showAddressDialog(null);
  }

  void _showEditAddressDialog(CustomerAddress address) {
    _showAddressDialog(address);
  }

  void _showAddressDialog(CustomerAddress? address) {
    final isEdit = address != null;
    final fullNameCtrl = TextEditingController(text: address?.fullName ?? '');
    final street1Ctrl = TextEditingController(text: address?.streetLine1 ?? '');
    final street2Ctrl = TextEditingController(text: address?.streetLine2 ?? '');
    final cityCtrl = TextEditingController(text: address?.city ?? '');
    final provinceCtrl = TextEditingController(text: address?.province ?? '');
    final postalCtrl = TextEditingController(text: address?.postalCode ?? '');
    final phoneCtrl = TextEditingController(text: address?.phoneNumber ?? '');
    bool isShipping = address?.defaultShippingAddress ?? false;
    bool isBilling = address?.defaultBillingAddress ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Address' : 'Add Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButtonField(
                  controller: fullNameCtrl,
                  hint: 'Full Name',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextButtonField(
                  controller: street1Ctrl,
                  hint: 'Street Address Line 1',
                ),
                const SizedBox(height: 16),
                TextButtonField(
                  controller: street2Ctrl,
                  hint: 'Street Address Line 2 (Optional)',
                ),
                const SizedBox(height: 16),
                TextButtonField(
                  controller: cityCtrl,
                  hint: 'City',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextButtonField(
                  controller: provinceCtrl,
                  hint: 'State/Province',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextButtonField(
                  controller: postalCtrl,
                  hint: 'Postal Code',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                ),
                const SizedBox(height: 16),
                TextButtonField(
                  controller: phoneCtrl,
                  hint: 'Phone (Optional)',
                  prefixText: '+91 ',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                const SizedBox(height: 16),
                CustomCheckboxTile(
                  title: 'Default Shipping',
                  value: isShipping,
                  onChanged: (v) => setDialogState(() => isShipping = v ?? false),
                  activeColor: AppColors.primary,
                ),
                CustomCheckboxTile(
                  title: 'Default Billing',
                  value: isBilling,
                  onChanged: (v) => setDialogState(() => isBilling = v ?? false),
                  activeColor: AppColors.primary,
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newAddress = CustomerAddress(
                  id: address?.id,
                  fullName: fullNameCtrl.text.trim(),
                  streetLine1: street1Ctrl.text.trim(),
                  streetLine2: street2Ctrl.text.trim().isNotEmpty ? street2Ctrl.text.trim() : null,
                  city: cityCtrl.text.trim(),
                  province: provinceCtrl.text.trim().isNotEmpty ? provinceCtrl.text.trim() : null,
                  postalCode: postalCtrl.text.trim(),
                  country: 'India',
                  phoneNumber: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : null,
                  defaultShippingAddress: isShipping,
                  defaultBillingAddress: isBilling,
                );

                bool success;
                if (isEdit) {
                  success = await _customerController.updateAddress(context, newAddress);
                } else {
                  success = await _customerController.addAddress(context, newAddress);
                }

                if (success) Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(CustomerAddress address) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Delete address for ${address.city}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (address.id != null) {
                await _customerController.deleteAddress(context, address.id!);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _authController.logout(context);
              await _customerController.clearData();
              Get.offAll(() => const LoginPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

