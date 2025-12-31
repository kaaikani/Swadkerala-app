import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class HomeDeliveryAddressHeader extends StatelessWidget {
  final VoidCallback onTap;
  final RxString channelName;
  final RxString postalCode;

  const HomeDeliveryAddressHeader({
    Key? key,
    required this.onTap,
    required this.channelName,
    required this.postalCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return Obx(() {
      final displayChannelName = channelName.value.isEmpty
          ? (box.read('channel_name') ?? box.read('channel_code') ?? 'Select Location')
          : channelName.value;

      final postalCodeValue = postalCode.value;
      final storagePostalCode = box.read('postal_code');
      final displayPostalCode = postalCodeValue.isNotEmpty
          ? postalCodeValue
          : (storagePostalCode != null ? storagePostalCode.toString() : '');

      return InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(16),
                ),
                SizedBox(width: 4),
                Text(
                  'Delivery to',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.button,
                  size: ResponsiveUtils.rp(18),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.rp(2)),
            Text(
              "$displayChannelName${displayPostalCode.isNotEmpty ? ' - $displayPostalCode' : ''}",
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(15),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }
}