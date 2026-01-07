import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/customer/customer_controller.dart';
import '../theme/theme.dart';
import '../widgets/snackbar.dart';
import '../graphql/Customer.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../services/postal_code_service.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  bool _showAddForm = false;
  dynamic _editingAddress;
  bool _isUpdatingAddress = false; // Loading state for address updates

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
      floatingActionButton: (_showAddForm || _editingAddress != null || _isUpdatingAddress) ? null : FloatingActionButton.extended(
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
      body: Stack(
        children: [
          Obx(() {
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
          // Loading overlay
          if (_isUpdatingAddress)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Please Wait...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Updating address',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
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
            icon: Icon(Icons.add_rounded, color: Colors.white),
            label: Text(
              'Add First Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 4,
              shadowColor: AppColors.button.withValues(alpha: 0.3),
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
    final hasMultipleAddresses = customerController.addresses.length > 1;

    // Build compact address text
    List<String> addressParts = [];
    if (address.streetLine1.isNotEmpty) addressParts.add(address.streetLine1);
    if (address.streetLine2 != null && address.streetLine2!.isNotEmpty) {
      addressParts.add(address.streetLine2!);
    }
    String addressLine = addressParts.join(', ');
    final cityText = address.city ?? '';
    final postalCodeText = address.postalCode ?? '';
    String cityLine = '$cityText${postalCodeText.isNotEmpty ? ', $postalCodeText' : ''}, ${address.country.name}';

    return Obx(() {
      // Get current default address reactively
      final currentDefaultAddress = customerController.addresses.firstWhereOrNull(
        (addr) => addr.defaultShippingAddress ?? false,
      );
      final isCurrentlyDefault = address.id == currentDefaultAddress?.id;

      return InkWell(
        onTap: hasMultipleAddresses && !_isUpdatingAddress ? () async {
          // Only allow tap to select if there are multiple addresses and not currently updating
          if (!isCurrentlyDefault) {
            await _setAsDefaultAndShipping(
              context,
              address,
              customerController,
            );
          }
        } : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCurrentlyDefault ? AppColors.button : AppColors.border,
              width: isCurrentlyDefault ? 2 : 1,
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
                // Radio Button (only show if multiple addresses)
                if (hasMultipleAddresses) ...[
                  Radio<dynamic>(
                    value: address,
                    groupValue: currentDefaultAddress,
                    onChanged: _isUpdatingAddress ? null : (dynamic selectedAddress) async {
                      if (selectedAddress != null && !_isUpdatingAddress) {
                        debugPrint('═══════════════════════════════════════════════════════════');
                        debugPrint('[AddressesPage] 📻 Radio button selected - Changing default address');
                        debugPrint('[AddressesPage] Selected Address ID: ${selectedAddress.id}');
                        debugPrint('[AddressesPage] Selected Address: ${selectedAddress.fullName ?? "N/A"}');
                        debugPrint('[AddressesPage] Address Location: ${selectedAddress.city ?? "N/A"}, ${selectedAddress.postalCode ?? "N/A"}');
                        debugPrint('[AddressesPage] Current Default Address ID: ${currentDefaultAddress?.id ?? "N/A"}');
                        debugPrint('[AddressesPage] Setting as both Shipping and Billing address...');
                        await _setAsDefaultAndShipping(
                          context, 
                          selectedAddress, 
                          customerController,
                          previousDefaultAddress: currentDefaultAddress,
                        );
                      }
                    },
                    activeColor: AppColors.button,
                  ),
                  SizedBox(width: 8),
                ],
                // Location Icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCurrentlyDefault
                        ? AppColors.button.withValues(alpha: 0.1)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: isCurrentlyDefault ? AppColors.button : AppColors.textSecondary,
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
                          if (isCurrentlyDefault)
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
              // Action Buttons - Stop event propagation so they don't trigger card tap
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
                    onPressed: () {
                      // Check if this is the only address
                      if (customerController.addresses.length <= 1) {
                        SnackBarWidget.show(
                          context,
                          'Cannot delete the only address. At least one address must be kept.',
                          backgroundColor: AppColors.error,
                        );
                        return;
                      }
                      _showDeleteDialog(context, address.id, customerController);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      );
    });
  }

  /// Set address as both default shipping and default billing address
  /// If update fails, reverts to previous default address
  Future<void> _setAsDefaultAndShipping(
    BuildContext context,
    dynamic address,
    CustomerController customerController, {
    dynamic previousDefaultAddress,
  }) async {
    // Prevent duplicate calls
    if (_isUpdatingAddress) {
      debugPrint('[AddressesPage] ⚠️ Address update already in progress, ignoring duplicate call');
      return;
    }
    
    debugPrint('[AddressesPage] ========== SET DEFAULT ADDRESS START ==========');
    debugPrint('[AddressesPage] Target Address ID: ${address.id}');
    debugPrint('[AddressesPage] Target Address: ${address.fullName ?? "N/A"}');
    debugPrint('[AddressesPage] Target Location: ${address.city ?? "N/A"}, ${address.postalCode ?? "N/A"}');
    if (previousDefaultAddress != null) {
      debugPrint('[AddressesPage] Previous Default Address ID: ${previousDefaultAddress.id}');
      debugPrint('[AddressesPage] Previous Default Address: ${previousDefaultAddress.fullName ?? "N/A"}');
    }
    debugPrint('[AddressesPage] Total Addresses: ${customerController.addresses.length}');
    
    // Show loading indicator
    setState(() {
      _isUpdatingAddress = true;
    });

    try {
      // Store the previous default address state for rollback
      dynamic previousDefaultForRollback = previousDefaultAddress;
      
      // If previous default not provided, find it from current addresses
      if (previousDefaultForRollback == null) {
        previousDefaultForRollback = customerController.addresses.firstWhereOrNull(
          (addr) => addr.defaultShippingAddress == true,
        );
      }
      
      // Find the previous default address (if any) that needs to be unset
      final previousDefault = customerController.addresses.firstWhereOrNull(
        (addr) => addr.id != address.id && 
                  ((addr.defaultShippingAddress ?? false) || (addr.defaultBillingAddress ?? false)),
      );
      
      // Only update the necessary addresses:
      // 1. Unset previous default (if exists and different from target)
      // 2. Set target address as default
      
      bool allSuccess = true;
      
      // Step 1: Unset previous default address (if it exists and is different from target)
      if (previousDefault != null) {
        debugPrint('[AddressesPage] Unsetting default from Address ID: ${previousDefault.id} (${previousDefault.fullName ?? "N/A"})');
        debugPrint('[AddressesPage]   - Was Shipping: ${previousDefault.defaultShippingAddress ?? false}');
        debugPrint('[AddressesPage]   - Was Billing: ${previousDefault.defaultBillingAddress ?? false}');
        
        final unsetAddress = Query$GetActiveCustomer$activeCustomer$addresses(
          id: previousDefault.id,
          fullName: previousDefault.fullName,
          streetLine1: previousDefault.streetLine1,
          streetLine2: previousDefault.streetLine2,
          city: previousDefault.city,
          postalCode: previousDefault.postalCode,
          phoneNumber: previousDefault.phoneNumber,
          company: previousDefault.company,
            defaultShippingAddress: false,
            defaultBillingAddress: false,
          country: previousDefault.country,
          );
        
        debugPrint('[AddressesPage] Calling updateAddress to unset default for ID: ${previousDefault.id}');
        final unsetResult = await customerController.updateAddress(unsetAddress, skipRefresh: true);
        debugPrint('[AddressesPage] Unset result for ID ${previousDefault.id}: $unsetResult');
        
        if (!unsetResult) {
          allSuccess = false;
          debugPrint('[AddressesPage] ❌ Failed to unset default from address ID: ${previousDefault.id}');
        } else {
          debugPrint('[AddressesPage] ✅ Successfully unset default from address ID: ${previousDefault.id}');
        }
      } else {
        debugPrint('[AddressesPage] No previous default address to unset');
      }

      // Step 2: Set the target address as default (only if unset succeeded or wasn't needed)
      if (allSuccess || previousDefault == null) {
      debugPrint('[AddressesPage] Setting Address ID: ${address.id} as default');
      debugPrint('[AddressesPage]   - Setting as Shipping Address: true');
      debugPrint('[AddressesPage]   - Setting as Billing Address: true');
        
      final selectedUpdatedAddress = Query$GetActiveCustomer$activeCustomer$addresses(
        id: address.id,
        fullName: address.fullName,
        streetLine1: address.streetLine1,
        streetLine2: address.streetLine2,
        city: address.city,
        postalCode: address.postalCode,
        phoneNumber: address.phoneNumber,
        company: address.company,
        defaultShippingAddress: true,
        defaultBillingAddress: true,
        country: address.country,
      );
        
        debugPrint('[AddressesPage] Calling updateAddress to set default for ID: ${address.id}');
        final setResult = await customerController.updateAddress(selectedUpdatedAddress, skipRefresh: false);
        debugPrint('[AddressesPage] Set result for ID ${address.id}: $setResult');
        
        if (!setResult) {
          allSuccess = false;
          debugPrint('[AddressesPage] ❌ Failed to set default for address ID: ${address.id}');
        } else {
          debugPrint('[AddressesPage] ✅ Successfully set default for address ID: ${address.id}');
        }
      }
      
      if (allSuccess) {
        debugPrint('[AddressesPage] ✅ Successfully set Address ID: ${address.id} as default shipping and billing');
        debugPrint('[AddressesPage]   - Shipping Address: ${address.fullName ?? "N/A"} (${address.city ?? "N/A"})');
        debugPrint('[AddressesPage]   - Billing Address: ${address.fullName ?? "N/A"} (${address.city ?? "N/A"})');
        // Refresh customer data once after both updates complete
        // (First update skipped refresh, second one will refresh)
        if (mounted) {
          debugPrint('[AddressesPage] Addresses updated successfully');
        }
      } else {
        debugPrint('[AddressesPage] ❌ Address update failed - Attempting rollback');
        
        // Rollback: Restore previous default address if it existed
        if (previousDefaultForRollback != null) {
          debugPrint('[AddressesPage] 🔄 Rolling back to previous default address ID: ${previousDefaultForRollback.id}');
          try {
            final rollbackAddress = Query$GetActiveCustomer$activeCustomer$addresses(
              id: previousDefaultForRollback.id,
              fullName: previousDefaultForRollback.fullName,
              streetLine1: previousDefaultForRollback.streetLine1,
              streetLine2: previousDefaultForRollback.streetLine2,
              city: previousDefaultForRollback.city,
              postalCode: previousDefaultForRollback.postalCode,
              phoneNumber: previousDefaultForRollback.phoneNumber,
              company: previousDefaultForRollback.company,
              defaultShippingAddress: true,
              defaultBillingAddress: true,
              country: previousDefaultForRollback.country,
            );
            
            final rollbackResult = await customerController.updateAddress(rollbackAddress);
            if (rollbackResult) {
              debugPrint('[AddressesPage] ✅ Rollback successful - Previous default address restored');
            } else {
              debugPrint('[AddressesPage] ⚠️ Rollback failed - Previous default address could not be restored');
            }
          } catch (rollbackError) {
            debugPrint('[AddressesPage] ❌ Rollback error: $rollbackError');
          }
        } else {
          debugPrint('[AddressesPage] ⚠️ No previous default address to rollback to');
        }
        
        // Note: getActiveCustomer() may have been called by updateAddress() already
        // Refresh addresses list to reflect current state
        customerController.refreshAddresses();
        if (mounted) {
          showErrorSnackbar('Failed to set default address. Please try again.');
        }
      }
      debugPrint('[AddressesPage] ========== SET DEFAULT ADDRESS END ==========');
      debugPrint('═══════════════════════════════════════════════════════════');
    } catch (e, stackTrace) {
      debugPrint('[AddressesPage] ❌ Error setting default address: $e');
      debugPrint('[AddressesPage] Stack trace: $stackTrace');
      
      // Rollback on exception
      if (previousDefaultAddress != null) {
        debugPrint('[AddressesPage] 🔄 Exception occurred - Attempting rollback to previous default');
        try {
          final rollbackAddress = Query$GetActiveCustomer$activeCustomer$addresses(
            id: previousDefaultAddress.id,
            fullName: previousDefaultAddress.fullName,
            streetLine1: previousDefaultAddress.streetLine1,
            streetLine2: previousDefaultAddress.streetLine2,
            city: previousDefaultAddress.city,
            postalCode: previousDefaultAddress.postalCode,
            phoneNumber: previousDefaultAddress.phoneNumber,
            company: previousDefaultAddress.company,
            defaultShippingAddress: true,
            defaultBillingAddress: true,
            country: previousDefaultAddress.country,
          );
          await customerController.updateAddress(rollbackAddress);
          debugPrint('[AddressesPage] ✅ Rollback successful after exception');
        } catch (rollbackError) {
          debugPrint('[AddressesPage] ❌ Rollback error after exception: $rollbackError');
        }
      }
      
      // Refresh to get correct state from server
      customerController.refreshAddresses();
      if (mounted) {
        showErrorSnackbar('Failed to set default address. Previous selection restored.');
      }
      debugPrint('[AddressesPage] ========== SET DEFAULT ADDRESS ERROR ==========');
      debugPrint('═══════════════════════════════════════════════════════════');
    } finally {
      // Hide loading indicator
      if (mounted) {
        setState(() {
          _isUpdatingAddress = false;
        });
      }
    }
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
    // Check if this is the only address
    if (customerController.addresses.length <= 1) {
      SnackBarWidget.show(
        context,
        'Cannot delete the only address. At least one address must be kept.',
        backgroundColor: AppColors.error,
      );
      return;
    }

    bool isDeleting = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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
            onPressed: isDeleting ? null : () async {
              // Prevent multiple clicks
              setState(() {
                isDeleting = true;
              });
              
              // Double check before deletion
              if (customerController.addresses.length <= 1) {
                if (Get.isDialogOpen == true) {
                Get.back();
                }
                SnackBarWidget.show(
                  context,
                  'Cannot delete the only address. At least one address must be kept.',
                  backgroundColor: AppColors.error,
                );
                return;
              }
              
              // Check if the address being deleted is a default address
              final addressToDelete = customerController.addresses.firstWhere(
                (addr) => addr.id == addressId,
                orElse: () => customerController.addresses.first,
              );
              
              final isDefaultAddress = (addressToDelete.defaultShippingAddress ?? false) || 
                                      (addressToDelete.defaultBillingAddress ?? false);
              
              // If this is a default address, set another address as default before deletion
              if (isDefaultAddress) {
                final otherAddresses = customerController.addresses
                    .where((addr) => addr.id != addressId)
                    .toList();
                
                if (otherAddresses.isNotEmpty) {
                  // Set the first other address as both shipping and billing
                  final newDefaultAddress = otherAddresses.first;
                  await _setAsDefaultAndShipping(context, newDefaultAddress, customerController);
                }
              }
              
              // Close dialog first
              if (Get.isDialogOpen == true) {
              Get.back();
              }
              
              // Perform deletion
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
            child: isDeleting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('Delete'),
          ),
        ],
      ),
      ),
      barrierDismissible: true,
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
  late final TextEditingController fullNameController;
  late final TextEditingController streetLine1Controller;
  late final TextEditingController streetLine2Controller;
  late final TextEditingController cityController;
  late final TextEditingController postalCodeController;
  late final TextEditingController provinceController;
  late final TextEditingController phoneController;
  
  // Postal codes state
  List<Query$PostalCodes$postalCodes> _postalCodesList = [];
  bool _isLoadingPostalCodes = true;
  bool _isIndSnacksChannel = false; // Track if channel is Ind-Snacks

  @override
  void initState() {
    super.initState();
    debugPrint('[AddressesPage] ========== ADD ADDRESS FORM INIT ==========');
    debugPrint('[AddressesPage] Fetching postal codes for add address form...');
    
    // Pre-initialize controllers for better performance
    final box = GetStorage();
    final channelCode = box.read('channel_code') ?? '';
    final channelToken = box.read('channel_token')?.toString() ?? '';
    final customer = widget.customerController.activeCustomer.value;
    final autoFullName = customer != null
        ? '${customer.firstName} ${customer.lastName}'.trim()
        : '';
    final autoPhone = customer != null ? (customer.phoneNumber ?? '') : '';

    fullNameController = TextEditingController(
        text: autoFullName.isNotEmpty ? autoFullName : '');
    streetLine1Controller = TextEditingController();
    streetLine2Controller = TextEditingController();
    cityController = TextEditingController(
        text: channelCode.isNotEmpty ? channelCode : '');
    
    // Get postal code from local storage if available
    final storedPostalCode = box.read('postal_code');
    postalCodeController = TextEditingController(
        text: storedPostalCode != null && storedPostalCode.toString().isNotEmpty
            ? storedPostalCode.toString()
            : '');
    
    // Check if channel is Ind-Snacks
    _isIndSnacksChannel = channelToken == 'Ind-Snacks' || channelToken == 'ind-snacks';
    provinceController = TextEditingController();
    
    phoneController = TextEditingController(
        text: autoPhone.isNotEmpty ? autoPhone : '');
    
    // Fetch postal codes when form is initialized
    _fetchPostalCodes();
  }
  
  /// Fetch postal codes for the current channel
  void _fetchPostalCodes() {
    debugPrint('[AddressesPage] Calling customerController.fetchPostalCodes()...');
    widget.customerController.fetchPostalCodes().then((codes) {
      debugPrint('[AddressesPage] ========== POSTAL CODES FETCH COMPLETED ==========');
      debugPrint('[AddressesPage] Received ${codes.length} postal codes');
      if (codes.isNotEmpty) {
        debugPrint('[AddressesPage] Postal codes list:');
        for (var code in codes) {
          debugPrint('[AddressesPage]   - ${code.code} (ID: ${code.id}, isAnywhere: ${code.isAnywhere})');
        }
      } else {
        debugPrint('[AddressesPage] No postal codes returned');
      }
      if (mounted) {
        setState(() {
          _postalCodesList = codes;
          _isLoadingPostalCodes = false;
        });
        debugPrint('[AddressesPage] State updated - postalCodesList.length: ${_postalCodesList.length}, isLoadingPostalCodes: $_isLoadingPostalCodes');
      }
    }).catchError((error) {
      debugPrint('[AddressesPage] ========== POSTAL CODES FETCH ERROR ==========');
      debugPrint('[AddressesPage] Error type: ${error.runtimeType}');
      debugPrint('[AddressesPage] Error message: $error');
      if (mounted) {
        setState(() {
          _isLoadingPostalCodes = false;
        });
      }
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    streetLine1Controller.dispose();
    streetLine2Controller.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    provinceController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get address count - if no addresses, first one must be default
    final addressCount = widget.customerController.addresses.length;
    final isOnlyAddress = addressCount == 0; // No addresses yet
    final bool? isOnlyDefault = null; // Not applicable for add form
    
    // If adding first address, it must be default
    bool defaultShipping = addressCount == 0;
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
              // Address Line 1
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
              _buildPostalCodeField(
                postalCodeController,
                _postalCodesList,
                _isLoadingPostalCodes,
                errors['postalCode'],
                setState,
                () {
                  if (errors.containsKey('postalCode')) {
                    errors.remove('postalCode');
                    setState(() {});
                  }
                },
                provinceController, // Pass province controller to auto-populate state
              ),
              SizedBox(height: 16),
              // Show State field only if channel is Ind-Snacks
              if (_isIndSnacksChannel) ...[
                _buildTextField(
                  provinceController,
                  'State',
                  Icons.map,
                ),
                SizedBox(height: 16),
              ],
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
                child: Opacity(
                  opacity: (isOnlyAddress && defaultShipping) ? 0.6 : 1.0,
                  child: Row(
                    children: [
                      Checkbox(
                        value: defaultShipping,
                        onChanged: (isOnlyAddress && defaultShipping)
                            ? null // Disable if only default address
                            : (value) {
                                // Prevent unchecking if it's the only default address (edit form only)
                                if (isOnlyDefault == true && defaultShipping && value == false) {
                                  SnackBarWidget.show(
                                    context,
                                    'Unable to deselect default address. At least one address must be set as default.',
                                    backgroundColor: AppColors.error,
                                  );
                                  return;
                                }
                                // Prevent unchecking if it's the only address
                                if (isOnlyAddress && defaultShipping && value == false) {
                                  SnackBarWidget.show(
                                    context,
                                    'Unable to deselect default address. At least one address must be set as default.',
                                    backgroundColor: AppColors.error,
                                  );
                                  return;
                                }
                                setState(() => defaultShipping = value ?? false);
                              },
                        activeColor: AppColors.button,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Set as default address',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontSize: 15,
                              ),
                            ),
                            if (isOnlyAddress && defaultShipping)
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  isOnlyAddress && addressCount == 0
                                      ? 'This will be your default address'
                                      : 'This is your only address and must remain default',
                                  style: TextStyle(
                                    fontSize: 12,
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

                        final country = Query$GetActiveCustomer$activeCustomer$addresses$country(
                          id: 'IN',
                          name: 'India',
                          code: 'IN',
                          languageCode: Enum$LanguageCode.en,
                        );
                        
                        // If this is the first address, it must be set as both shipping and billing
                        final isFirstAddress = widget.customerController.addresses.isEmpty;
                        final shouldBeDefault = isFirstAddress || defaultShipping;
                        
                        final addressData = Query$GetActiveCustomer$activeCustomer$addresses(
                          id: '',
                          fullName: fullNameController.text.trim().isEmpty ? null : fullNameController.text.trim(),
                          streetLine1: streetLine1Controller.text.trim(),
                          streetLine2: streetLine2Controller.text.trim().isEmpty ? null : streetLine2Controller.text.trim(),
                          city: cityController.text.trim().isEmpty ? null : cityController.text.trim(),
                          postalCode: postalCodeController.text.trim().isEmpty ? null : postalCodeController.text.trim(),
                          phoneNumber: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                          company: null,
                          defaultShippingAddress: shouldBeDefault,
                          defaultBillingAddress: shouldBeDefault,
                          country: country,
                        );
                        
                        // If setting as default, unset other addresses first
                        if (shouldBeDefault && !isFirstAddress) {
                          // Unset all other addresses as default
                          final addressesToUpdate = <Query$GetActiveCustomer$activeCustomer$addresses>[];
                          for (final addr in widget.customerController.addresses) {
                            if ((addr.defaultShippingAddress ?? false) || (addr.defaultBillingAddress ?? false)) {
                              final updatedAddress = Query$GetActiveCustomer$activeCustomer$addresses(
                                id: addr.id,
                                fullName: addr.fullName,
                                streetLine1: addr.streetLine1,
                                streetLine2: addr.streetLine2,
                                city: addr.city,
                                postalCode: addr.postalCode,
                                phoneNumber: addr.phoneNumber,
                                company: addr.company,
                                defaultShippingAddress: false,
                                defaultBillingAddress: false,
                                country: addr.country,
                              );
                              addressesToUpdate.add(updatedAddress);
                            }
                          }
                          // Update all other addresses first
                          if (addressesToUpdate.isNotEmpty) {
                            await Future.wait(
                              addressesToUpdate.map((addr) => widget.customerController.updateAddress(addr)),
                              eagerError: false,
                            );
                          }
                        }

                        // For Ind-Snacks channel, use province from field; for others, use 'Tamilnadu' as default
                        final provinceValue = _isIndSnacksChannel 
                            ? (provinceController.text.trim().isEmpty ? null : provinceController.text.trim())
                            : 'Tamilnadu';
                        
                        final success = await widget.customerController
                            .createAddress(addressData, province: provinceValue);

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

  Widget _buildPostalCodeField(
    TextEditingController controller,
    List<Query$PostalCodes$postalCodes> postalCodesList,
    bool isLoadingPostalCodes,
    String? errorText,
    StateSetter setState,
    VoidCallback onChanged,
    [TextEditingController? provinceController,]
  ) {
    final hasPostalCodes = postalCodesList.isNotEmpty;
    final hasError = errorText != null && errorText.isNotEmpty;
    
    debugPrint('[AddressesPage] _buildPostalCodeField called:');
    debugPrint('[AddressesPage]   - isLoadingPostalCodes: $isLoadingPostalCodes');
    debugPrint('[AddressesPage]   - postalCodesList.length: ${postalCodesList.length}');
    debugPrint('[AddressesPage]   - hasPostalCodes: $hasPostalCodes');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Postal Code',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (isLoadingPostalCodes)
          // Show loading state
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                ),
              ),
            ),
          )
        else if (hasPostalCodes)
          // Show dropdown when postal codes are available
          Builder(
            builder: (context) {
              // Get unique postal codes
              final uniqueCodes = postalCodesList
                  .map((postalCode) => postalCode.code)
                  .toSet()
                  .toList();
              
              // Only set value if it exists in the unique codes list
              final selectedValue = controller.text.isNotEmpty && 
                  uniqueCodes.contains(controller.text)
                  ? controller.text
                  : null;
              
              return SizedBox(
                height: 56,
                child: DropdownButtonFormField<String>(
                value: selectedValue,
            decoration: InputDecoration(
              hintText: 'Select Postal Code',
              hintStyle: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.markunread_mailbox,
                color: hasError ? AppColors.error : AppColors.textSecondary,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.inputFill,
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
                  color: hasError ? AppColors.error : AppColors.button,
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorText: hasError ? errorText : null,
              errorStyle: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
            items: postalCodesList
                .map((postalCode) => postalCode.code)
                .toSet()
                .toList()
                .map((code) {
                  final postalCode = postalCodesList.firstWhere(
                    (pc) => pc.code == code,
                    orElse: () => postalCodesList.first,
                  );
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            code,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (postalCode.isAnywhere == true)
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.button.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Anywhere',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.button,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    controller.text = value;
                  });
                  onChanged();
                }
              },
              dropdownColor: AppColors.surface,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
                ),
              );
            },
          )
        else
          // Show text field when no postal codes available
          _buildTextField(
            controller,
            'Postal Code',
            Icons.markunread_mailbox,
            required: true,
            errorText: errorText,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: onChanged,
          ),
        if (hasError && hasPostalCodes)
          Padding(
            padding: EdgeInsets.only(top: 4, left: 12),
            child: Text(
              errorText,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
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
  late final TextEditingController fullNameController;
  late final TextEditingController streetLine1Controller;
  late final TextEditingController streetLine2Controller;
  late final TextEditingController cityController;
  late final TextEditingController postalCodeController;
  late final TextEditingController provinceController;
  late final TextEditingController phoneController;
  
  // Postal codes state
  List<Query$PostalCodes$postalCodes> _postalCodesList = [];
  bool _isLoadingPostalCodes = true;
  bool _isIndSnacksChannel = false; // Track if channel is Ind-Snacks

  @override
  void initState() {
    super.initState();
    debugPrint('[AddressesPage] ========== EDIT ADDRESS FORM INIT ==========');
    debugPrint('[AddressesPage] Fetching postal codes for edit address form...');
    
    // Pre-initialize controllers for better performance
    final existingAddress = widget.existingAddress;
    fullNameController = TextEditingController(
        text: existingAddress?.fullName ?? '');
    streetLine1Controller = TextEditingController(
        text: existingAddress?.streetLine1 ?? '');
    streetLine2Controller = TextEditingController(
        text: existingAddress?.streetLine2 ?? '');
    final box = GetStorage();
    final channelCode = box.read('channel_code') ?? '';
    final channelToken = box.read('channel_token')?.toString() ?? '';
    cityController = TextEditingController(
        text: channelCode.isNotEmpty
            ? channelCode
            : (existingAddress?.city ?? ''));
    postalCodeController = TextEditingController(
        text: existingAddress?.postalCode ?? '');
    
    // Check if channel is Ind-Snacks
    _isIndSnacksChannel = channelToken == 'Ind-Snacks' || channelToken == 'ind-snacks';
    provinceController = TextEditingController();
    
    phoneController = TextEditingController(
        text: existingAddress?.phoneNumber ?? '');
    
    // Fetch postal codes when form is initialized
    _fetchPostalCodes();
    
    // If postal code exists and channel is Ind-Snacks, fetch state for province
    if (_isIndSnacksChannel && existingAddress?.postalCode != null && existingAddress!.postalCode.isNotEmpty) {
      _fetchStateForPostalCode(existingAddress.postalCode);
    }
  }
  
  /// Fetch postal codes for the current channel
  void _fetchPostalCodes() {
    debugPrint('[AddressesPage] Calling customerController.fetchPostalCodes()...');
    widget.customerController.fetchPostalCodes().then((codes) {
      debugPrint('[AddressesPage] ========== POSTAL CODES FETCH COMPLETED ==========');
      debugPrint('[AddressesPage] Received ${codes.length} postal codes');
      if (codes.isNotEmpty) {
        debugPrint('[AddressesPage] Postal codes list:');
        for (var code in codes) {
          debugPrint('[AddressesPage]   - ${code.code} (ID: ${code.id}, isAnywhere: ${code.isAnywhere})');
        }
      } else {
        debugPrint('[AddressesPage] No postal codes returned');
      }
      if (mounted) {
        setState(() {
          _postalCodesList = codes;
          _isLoadingPostalCodes = false;
        });
        debugPrint('[AddressesPage] State updated - postalCodesList.length: ${_postalCodesList.length}, isLoadingPostalCodes: $_isLoadingPostalCodes');
      }
    }).catchError((error) {
      debugPrint('[AddressesPage] ========== POSTAL CODES FETCH ERROR ==========');
      debugPrint('[AddressesPage] Error type: ${error.runtimeType}');
      debugPrint('[AddressesPage] Error message: $error');
      if (mounted) {
        setState(() {
          _isLoadingPostalCodes = false;
        });
      }
    });
  }

  /// Fetch state for a postal code and populate province field
  void _fetchStateForPostalCode(String postalCode) async {
    if (postalCode.length != 6) return;
    try {
      final postalCodeService = PostalCodeService();
      final results = await postalCodeService.searchPostalCode(postalCode);
      if (results.isNotEmpty && mounted) {
        final postalData = results.first;
        setState(() {
          provinceController.text = postalData.state;
        });
        debugPrint('[AddressesPage] Auto-populated province for existing address: ${postalData.state}');
      }
    } catch (e) {
      debugPrint('[AddressesPage] Error fetching state for postal code: $e');
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    streetLine1Controller.dispose();
    streetLine2Controller.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    provinceController.dispose();
    phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Controllers are already initialized in initState for better performance
    // Get address count and determine if this is the only address
    final addressCount = widget.customerController.addresses.length;
    final isOnlyAddress = addressCount <= 1; // Only one address
    final isOnlyDefault = ((widget.existingAddress?.defaultShippingAddress ?? false) || 
                          (widget.existingAddress?.defaultBillingAddress ?? false)) &&
        addressCount == 1;
    
    // If editing only default address, it must remain default (both shipping and billing)
    bool defaultShipping = widget.existingAddress?.defaultShippingAddress ?? false;
    if (isOnlyDefault) {
      defaultShipping = true; // Force to remain default
    }
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
              // Address Line 1
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
              _buildPostalCodeField(
                postalCodeController,
                _postalCodesList,
                _isLoadingPostalCodes,
                errors['postalCode'],
                setState,
                () {
                  if (errors.containsKey('postalCode')) {
                    errors.remove('postalCode');
                    setState(() {});
                  }
                },
                provinceController, // Pass province controller to auto-populate state
              ),
              SizedBox(height: 16),
              // Show State field only if channel is Ind-Snacks
              if (_isIndSnacksChannel) ...[
                _buildTextField(
                  provinceController,
                  'State',
                  Icons.map,
                ),
                SizedBox(height: 16),
              ],
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
                child: Opacity(
                  opacity: (isOnlyAddress && defaultShipping) ? 0.6 : 1.0,
                  child: Row(
                    children: [
                      Checkbox(
                        value: defaultShipping,
                        onChanged: (isOnlyAddress && defaultShipping)
                            ? null // Disable if only default address
                            : (value) {
                                // Prevent unchecking if it's the only default address (edit form only)
                                if (isOnlyDefault == true && defaultShipping && value == false) {
                                  SnackBarWidget.show(
                                    context,
                                    'Unable to deselect default address. At least one address must be set as default.',
                                    backgroundColor: AppColors.error,
                                  );
                                  return;
                                }
                                // Prevent unchecking if it's the only address
                                if (isOnlyAddress && defaultShipping && value == false) {
                                  SnackBarWidget.show(
                                    context,
                                    'Unable to deselect default address. At least one address must be set as default.',
                                    backgroundColor: AppColors.error,
                                  );
                                  return;
                                }
                                setState(() => defaultShipping = value ?? false);
                              },
                        activeColor: AppColors.button,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Set as default address',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontSize: 15,
                              ),
                            ),
                            if (isOnlyAddress && defaultShipping)
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  isOnlyAddress && addressCount == 0
                                      ? 'This will be your default address'
                                      : 'This is your only address and must remain default',
                                  style: TextStyle(
                                    fontSize: 12,
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

                        final country = widget.existingAddress?.country ??
                            Query$GetActiveCustomer$activeCustomer$addresses$country(
                              id: 'IN',
                              name: 'India',
                              code: 'IN',
                              languageCode: Enum$LanguageCode.en,
                            );
                        
                        // Ensure at least one address remains as both shipping and billing
                        // If this is the only default address, it must remain default
                        final shouldBeDefault = isOnlyDefault || defaultShipping;
                        
                        // If setting as default and not the only address, unset other addresses first
                        if (shouldBeDefault && !isOnlyDefault && addressCount > 1) {
                          // Unset all other addresses as default
                          final addressesToUpdate = <Query$GetActiveCustomer$activeCustomer$addresses>[];
                          for (final addr in widget.customerController.addresses) {
                            if (addr.id != widget.existingAddress?.id && 
                                ((addr.defaultShippingAddress ?? false) || (addr.defaultBillingAddress ?? false))) {
                              final updatedAddress = Query$GetActiveCustomer$activeCustomer$addresses(
                                id: addr.id,
                                fullName: addr.fullName,
                                streetLine1: addr.streetLine1,
                                streetLine2: addr.streetLine2,
                                city: addr.city,
                                postalCode: addr.postalCode,
                                phoneNumber: addr.phoneNumber,
                                company: addr.company,
                                defaultShippingAddress: false,
                                defaultBillingAddress: false,
                                country: addr.country,
                              );
                              addressesToUpdate.add(updatedAddress);
                            }
                          }
                          // Update all other addresses first
                          if (addressesToUpdate.isNotEmpty) {
                            await Future.wait(
                              addressesToUpdate.map((addr) => widget.customerController.updateAddress(addr)),
                              eagerError: false,
                            );
                          }
                        }
                        
                        final addressData = Query$GetActiveCustomer$activeCustomer$addresses(
                          id: widget.existingAddress?.id ?? '',
                          fullName: fullNameController.text.trim().isEmpty ? null : fullNameController.text.trim(),
                          streetLine1: streetLine1Controller.text.trim(),
                          streetLine2: streetLine2Controller.text.trim().isEmpty ? null : streetLine2Controller.text.trim(),
                          city: cityController.text.trim().isEmpty ? null : cityController.text.trim(),
                          postalCode: postalCodeController.text.trim().isEmpty ? null : postalCodeController.text.trim(),
                          phoneNumber: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                          company: null,
                          defaultShippingAddress: shouldBeDefault,
                          defaultBillingAddress: shouldBeDefault,
                          country: country,
                        );

                        // For Ind-Snacks channel, use province from field; for others, use 'Tamilnadu' as default
                        final provinceValue = _isIndSnacksChannel 
                            ? (provinceController.text.trim().isEmpty ? null : provinceController.text.trim())
                            : 'Tamilnadu';
                        
                        final success = await widget.customerController
                            .updateAddress(addressData, province: provinceValue);

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

  Widget _buildPostalCodeField(
    TextEditingController controller,
    List<Query$PostalCodes$postalCodes> postalCodesList,
    bool isLoadingPostalCodes,
    String? errorText,
    StateSetter setState,
    VoidCallback onChanged,
    [TextEditingController? provinceController,]
  ) {
    final hasPostalCodes = postalCodesList.isNotEmpty;
    final hasError = errorText != null && errorText.isNotEmpty;
    
    debugPrint('[AddressesPage] _buildPostalCodeField called:');
    debugPrint('[AddressesPage]   - isLoadingPostalCodes: $isLoadingPostalCodes');
    debugPrint('[AddressesPage]   - postalCodesList.length: ${postalCodesList.length}');
    debugPrint('[AddressesPage]   - hasPostalCodes: $hasPostalCodes');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Postal Code',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (isLoadingPostalCodes)
          // Show loading state
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                ),
              ),
            ),
          )
        else if (hasPostalCodes)
          // Show dropdown when postal codes are available
          Builder(
            builder: (context) {
              // Get unique postal codes
              final uniqueCodes = postalCodesList
                  .map((postalCode) => postalCode.code)
                  .toSet()
                  .toList();
              
              // Only set value if it exists in the unique codes list
              final selectedValue = controller.text.isNotEmpty && 
                  uniqueCodes.contains(controller.text)
                  ? controller.text
                  : null;
              
              return SizedBox(
                height: 56,
                child: DropdownButtonFormField<String>(
                value: selectedValue,
            decoration: InputDecoration(
              hintText: 'Select Postal Code',
              hintStyle: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.markunread_mailbox,
                color: hasError ? AppColors.error : AppColors.textSecondary,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.inputFill,
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
                  color: hasError ? AppColors.error : AppColors.button,
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorText: hasError ? errorText : null,
              errorStyle: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
            items: postalCodesList
                .map((postalCode) => postalCode.code)
                .toSet()
                .toList()
                .map((code) {
                  final postalCode = postalCodesList.firstWhere(
                    (pc) => pc.code == code,
                    orElse: () => postalCodesList.first,
                  );
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            code,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (postalCode.isAnywhere == true)
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.button.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Anywhere',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.button,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    controller.text = value;
                  });
                  onChanged();
                }
              },
              dropdownColor: AppColors.surface,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
                ),
              );
            },
          )
        else
          // Show text field when no postal codes available
          _buildTextField(
            controller,
            'Postal Code',
            Icons.markunread_mailbox,
            required: true,
            errorText: errorText,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: onChanged,
          ),
        if (hasError && hasPostalCodes)
          Padding(
            padding: EdgeInsets.only(top: 4, left: 12),
            child: Text(
              errorText,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
