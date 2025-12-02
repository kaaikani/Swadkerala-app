import 'package:flutter/material.dart';
import '../../controllers/customer/customer_controller.dart';
import '../../controllers/customer/customer_models.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../address_card_premium.dart';

class CheckoutAddressSection extends StatelessWidget {
  final CustomerController customerController;
  final AddressModel? selectedAddress;
  final VoidCallback onAddressChange;
  final VoidCallback onAddAddress;

  const CheckoutAddressSection({
    Key? key,
    required this.customerController,
    required this.selectedAddress,
    required this.onAddressChange,
    required this.onAddAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (selectedAddress != null)
              TextButton(
                onPressed: onAddressChange,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: AppColors.button,
                    fontSize: ResponsiveUtils.sp(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.rp(12)),
        if (selectedAddress != null)
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: AppColors.button, size: ResponsiveUtils.rp(18)),
                    SizedBox(width: ResponsiveUtils.rp(8)),
                    Text(
                      'Delivering to',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.rp(12)),
                AddressCardPremium(
                  fullName: selectedAddress!.fullName,
                  streetLine1: selectedAddress!.streetLine1,
                  streetLine2: selectedAddress!.streetLine2,
                  city: selectedAddress!.city,
                  postalCode: selectedAddress!.postalCode,
                  phoneNumber: selectedAddress!.phoneNumber,
                  isSelected: true,
                  isDefault: selectedAddress!.defaultShippingAddress,
                  onTap: onAddressChange,
                ),
              ],
            ),
          )
        else
          _buildEmptyAddressState(),
      ],
    );
  }

  Widget _buildEmptyAddressState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: ResponsiveUtils.rp(40),
            color: AppColors.textSecondary,
          ),
          SizedBox(height: ResponsiveUtils.rp(12)),
          Text(
            'No delivery address selected',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            'Please add an address to continue checkout',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(16)),
          ElevatedButton.icon(
            onPressed: onAddAddress,
            icon: Icon(Icons.add, size: ResponsiveUtils.rp(18)),
            label: const Text('Add New Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: AppColors.textLight,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.rp(24),
                vertical: ResponsiveUtils.rp(12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
