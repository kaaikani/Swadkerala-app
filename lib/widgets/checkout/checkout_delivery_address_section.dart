import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/app_strings.dart';
import '../../graphql/Customer.graphql.dart';

class CheckoutDeliveryAddressSection extends StatelessWidget {
  final Query$GetActiveCustomer$activeCustomer$addresses? selectedAddress;
  final RxBool shouldBlinkAddress;
  final Future<void> Function() onLoadAddresses;

  const CheckoutDeliveryAddressSection({
    super.key,
    required this.selectedAddress,
    required this.shouldBlinkAddress,
    required this.onLoadAddresses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final shouldBlink = shouldBlinkAddress.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(18),
                    fontWeight: FontWeight.bold,
                    color: shouldBlink && selectedAddress == null
                        ? AppColors.error
                        : AppColors.textPrimary,
                  ),
                ),
                if (selectedAddress != null)
                  TextButton(
                    onPressed: () async {
                      await Get.toNamed('/addresses');
                      await onLoadAddresses();
                    },
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
          );
        }),
        SizedBox(height: ResponsiveUtils.rp(16)),
        if (selectedAddress == null)
          Obx(() {
            final shouldBlink = shouldBlinkAddress.value;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(shouldBlink ? ResponsiveUtils.rp(4) : 0),
                decoration: BoxDecoration(
                  color: shouldBlink
                      ? AppColors.error.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                  border: shouldBlink
                      ? Border.all(
                          color: AppColors.error.withValues(alpha: 0.5),
                          width: 2,
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                      decoration: BoxDecoration(
                        color: shouldBlink
                            ? AppColors.error.withValues(alpha: 0.15)
                            : AppColors.buttonLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                        border: Border.all(
                          color: shouldBlink
                              ? AppColors.error.withValues(alpha: 0.8)
                              : AppColors.button.withValues(alpha: 0.2),
                          width: shouldBlink ? 2.5 : 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: ResponsiveUtils.rp(48),
                            color: shouldBlink ? AppColors.error : AppColors.textSecondary,
                          ),
                          SizedBox(height: ResponsiveUtils.rp(12)),
                          Text(
                            'No delivery address selected',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              color: shouldBlink ? AppColors.error : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.rp(16)),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Get.toNamed('/addresses');
                              await onLoadAddresses();
                            },
                            icon: Icon(Icons.add_location_alt_rounded, size: ResponsiveUtils.rp(20)),
                            label: Text(AppStrings.addAddress),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: shouldBlink ? AppColors.error : AppColors.button,
                              foregroundColor: AppColors.buttonText,
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(24),
                                vertical: ResponsiveUtils.rp(14),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                              ),
                              elevation: shouldBlink ? 4 : 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        else
          Obx(() {
            final shouldBlink = shouldBlinkAddress.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(shouldBlink ? ResponsiveUtils.rp(4) : 0),
              decoration: BoxDecoration(
                color: shouldBlink
                    ? AppColors.error.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                border: shouldBlink
                    ? Border.all(
                        color: AppColors.error.withValues(alpha: 0.5),
                        width: 2,
                      )
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
                child: Container(
                  padding: EdgeInsets.all(shouldBlink ? ResponsiveUtils.rp(16) : 0),
                  decoration: BoxDecoration(
                    color: shouldBlink
                        ? AppColors.error.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
                    border: shouldBlink
                        ? Border.all(
                            color: AppColors.error.withValues(alpha: 0.8),
                            width: 2.5,
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAddress!.fullName ?? '',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(16),
                          fontWeight: FontWeight.w600,
                          color: shouldBlink ? AppColors.error : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      Text(
                        '${selectedAddress!.streetLine1}${(selectedAddress!.streetLine2?.isNotEmpty ?? false) ? ', ${selectedAddress!.streetLine2}' : ''}, ${selectedAddress!.city ?? ''}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(14),
                          color: shouldBlink ? AppColors.error : AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(8)),
                      Row(
                        children: [
                          Text(
                            selectedAddress!.phoneNumber ?? '',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14),
                              color: shouldBlink ? AppColors.error : AppColors.textSecondary,
                            ),
                          ),
                          if (selectedAddress!.defaultShippingAddress ?? false) ...[
                            SizedBox(width: ResponsiveUtils.rp(12)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.rp(8),
                                vertical: ResponsiveUtils.rp(4),
                              ),
                              decoration: BoxDecoration(
                                color: shouldBlink
                                    ? AppColors.error.withValues(alpha: 0.2)
                                    : AppColors.button.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(4)),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(12),
                                  color: shouldBlink ? AppColors.error : AppColors.button,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

