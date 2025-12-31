import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../services/postal_code_service.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/snackbar.dart';

class HomePostalCodeSheet extends StatefulWidget {
  final CustomerController customerController;
  final VoidCallback onPostalCodeSelected;
  final bool isMandatory;

  const HomePostalCodeSheet({
    Key? key,
    required this.customerController,
    required this.onPostalCodeSelected,
    this.isMandatory = false,
  }) : super(key: key);

  @override
  State<HomePostalCodeSheet> createState() => _HomePostalCodeSheetState();
}

class _HomePostalCodeSheetState extends State<HomePostalCodeSheet> {
  final box = GetStorage();
  final pincodeController = TextEditingController();
  List<PostalCodeData> searchResults = [];
  bool isSearching = false;
  bool isGettingLocation = false;
  bool isServiceUnavailable = false;

  @override
  void dispose() {
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if postal code is already saved - if not, hide close button
    // Also hide close button if this is mandatory (invalid postal code)
    final storedPostalCode = box.read('postal_code');
    final bool hasPostalCode = storedPostalCode != null && storedPostalCode.toString().isNotEmpty && !widget.isMandatory;

    return PopScope(
      canPop: !widget.isMandatory, // Prevent back button when mandatory
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveUtils.rp(20)),
          ),
        ),
        child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: ResponsiveUtils.rp(12)),
            width: ResponsiveUtils.rp(40),
            height: ResponsiveUtils.rp(4),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.button, size: ResponsiveUtils.rp(24)),
                SizedBox(width: ResponsiveUtils.rp(12)),
                Expanded(
                  child: Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // Only show close button if postal code is already saved
                if (hasPostalCode)
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () {
                      try {
                        final navigator = Navigator.of(context, rootNavigator: false);
                        if (mounted && navigator.canPop()) {
                          navigator.pop();
                        }
                      } catch (e) {
                        debugPrint('[HomePostalCodeSheet] Error closing sheet: $e');
                      }
                    },
                  ),
              ],
            ),
          ),
          Divider(height: 1),
          // Search section
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Column(
              children: [
                // Location button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isGettingLocation ? null : () async {
                      setState(() {
                        isGettingLocation = true;
                        searchResults = [];
                      });
                      
                      final postalCodeService = PostalCodeService();
                      final locationData = await postalCodeService.getPostalCodeFromLocation();
                      
                      setState(() {
                        isGettingLocation = false;
                      });
                      
                      if (locationData != null) {
                        // Just show the postal code data from location
                        // Service availability will be checked only when user taps on it
                        setState(() {
                          pincodeController.text = locationData.pincode;
                          searchResults = [locationData];
                          isServiceUnavailable = false; // Reset service availability flag
                        });
                      } else {
                        SnackBarWidget.showError('Could not get location. Please enter postal code manually.');
                      }
                    },
                    icon: isGettingLocation
                        ? SizedBox(
                            width: ResponsiveUtils.rp(20),
                            height: ResponsiveUtils.rp(20),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.my_location, color: AppColors.button),
                    label: Text(
                      isGettingLocation ? 'Getting location...' : 'Use Current Location',
                      style: TextStyle(color: AppColors.button),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.button),
                      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(12)),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                // Search field
                TextField(
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'Enter 6-digit postal code',
                    hintText: '628008',
                    prefixIcon: Icon(Icons.pin),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 6) {
                      // Close keyboard when 6 digits are entered
                      FocusScope.of(context).unfocus();
                      
                      // Auto-search when 6 digits are entered - just show postal code data
                      // Don't check service availability yet
                      setState(() {
                        isSearching = true;
                        searchResults = [];
                        isServiceUnavailable = false; // Reset service availability flag
                      });
                      widget.customerController.searchPostalCodes(value).then((results) {
                        if (mounted) {
                          // Just show postal code results from India postal code data
                          // Service availability will be checked only when user taps on a result
                          setState(() {
                            searchResults = results;
                            isSearching = false;
                            isServiceUnavailable = false;
                          });
                        }
                      }).catchError((error) {
                        if (mounted) {
                          setState(() {
                            searchResults = [];
                            isSearching = false;
                            isServiceUnavailable = false;
                          });
                        }
                      });
                    } else {
                      setState(() {
                        searchResults = [];
                        isServiceUnavailable = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Results section
          Expanded(
            child: isSearching
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          Text(
                            'Checking service availability...',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: ResponsiveUtils.sp(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : isServiceUnavailable && searchResults.isNotEmpty
                    ? Column(
                        children: [
                          // Error message banner
                          Container(
                            margin: EdgeInsets.all(ResponsiveUtils.rp(16)),
                            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: ResponsiveUtils.rp(24),
                                ),
                                SizedBox(width: ResponsiveUtils.rp(12)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Service Not Available',
                                        style: TextStyle(
                                          color: AppColors.error,
                                          fontSize: ResponsiveUtils.sp(16),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveUtils.rp(4)),
                                      Text(
                                        'Service is not available for this location. Please try another postal code.',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: ResponsiveUtils.sp(14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, size: ResponsiveUtils.rp(20)),
                                  color: AppColors.textSecondary,
                                  onPressed: () {
                                    setState(() {
                                      isServiceUnavailable = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Show postal codes list so user can try another
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final result = searchResults[index];
                                return ListTile(
                                  leading: Icon(Icons.location_city, color: AppColors.button),
                                  title: Text(
                                    '${result.city}, ${result.district}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${result.state} - ${result.pincode}',
                                    style: TextStyle(color: AppColors.textSecondary),
                                  ),
                                  onTap: () async {
                                    // Show loading indicator in the sheet
                                    if (!mounted) return;
                                    
                                    // Save navigator reference BEFORE async operation
                                    final navigator = Navigator.of(context, rootNavigator: false);
                                    
                                    setState(() {
                                      isSearching = true;
                                      isServiceUnavailable = false;
                                    });
                                    
                                    // Now check service availability when user taps on a postal code
                                    // Don't show loading dialog - show message in sheet instead
                                    final success = await widget.customerController.switchChannelByPostalCode(
                                      result.pincode,
                                      city: result.city,
                                      showLoading: false, // Don't show dialog, show in sheet instead
                                    );
                                    
                                    if (!mounted) return;
                                    
                                    setState(() {
                                      isSearching = false;
                                    });
                                  
                                    if (success) {
                                      // Service available - close sheet and trigger callback
                                      // Use a post-frame callback to ensure context is still valid
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          try {
                                            if (navigator.canPop()) {
                                              navigator.pop();
                                            }
                                            widget.onPostalCodeSelected();
                                          } catch (e) {
                                            // Navigator already popped or context invalid
                                            debugPrint('[HomePostalCodeSheet] Error closing sheet: $e');
                                          }
                                        }
                                      });
                                    } else {
                                      // Service not available - show error message in the sheet
                                      // Keep the list visible so user can try another postal code
                                      setState(() {
                                        isServiceUnavailable = true;
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : searchResults.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(ResponsiveUtils.rp(20)),
                              child: Text(
                                pincodeController.text.length == 6
                                    ? 'Enter valid postal code'
                                    : 'Enter 6-digit postal code or use current location',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.sp(14),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final result = searchResults[index];
                              return ListTile(
                                leading: Icon(Icons.location_city, color: AppColors.button),
                                title: Text(
                                  '${result.city}, ${result.district}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${result.state} - ${result.pincode}',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                onTap: () async {
                                  // Show loading indicator in the sheet
                                  if (!mounted) return;
                                  
                                  // Save navigator reference BEFORE async operation
                                  final navigator = Navigator.of(context, rootNavigator: false);
                                  
                                  setState(() {
                                    isSearching = true;
                                  });
                                  
                                  // Now check service availability when user taps on a postal code
                                  // Don't show loading dialog - show message in sheet instead
                                  final success = await widget.customerController.switchChannelByPostalCode(
                                    result.pincode,
                                    city: result.city,
                                    showLoading: false, // Don't show dialog, show in sheet instead
                                  );
                                  
                                  if (!mounted) return;
                                  
                                  setState(() {
                                    isSearching = false;
                                  });
                                
                                  if (success) {
                                    // Service available - close sheet and trigger callback
                                    // Use a post-frame callback to ensure context is still valid
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                                        try {
                                          if (navigator.canPop()) {
                                            navigator.pop();
                                          }
                                          widget.onPostalCodeSelected();
                                        } catch (e) {
                                          // Navigator already popped or context invalid
                                          debugPrint('[HomePostalCodeSheet] Error closing sheet: $e');
                                        }
                                      }
                                    });
                                  } else {
                                    // Service not available - show error message in the sheet
                                    // Keep the list visible so user can try another postal code
                                    setState(() {
                                      isServiceUnavailable = true;
                                    });
                                  }
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
      ),
    );
  }
}

