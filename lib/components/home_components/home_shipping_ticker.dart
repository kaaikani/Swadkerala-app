import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import '../../utils/responsive.dart';
import '../../services/remote_config_service.dart';

class HomeShippingTicker extends StatelessWidget {
  const HomeShippingTicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<RemoteConfigService>()) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final remoteConfigService = Get.find<RemoteConfigService>();
      final tickerText = remoteConfigService.shippingTickerText.value;

      if (tickerText.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        height: ResponsiveUtils.rp(36), // Fixed slim height for ticker
        color: const Color(0xFFFFF8E1), // Light yellow warning color
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(12)),
              color: const Color(0xFFFFE082), // Darker yellow label
              alignment: Alignment.center,
              child: Icon(
                Icons.campaign_rounded,
                color: Colors.brown,
                size: ResponsiveUtils.rp(20),
              ),
            ),
            Expanded(
              child: Marquee(
                key: const ValueKey('shippingTicker'),
                text: tickerText,
                style: TextStyle(
                  color: Colors.brown[800],
                  fontSize: ResponsiveUtils.sp(12),
                  fontWeight: FontWeight.w600,
                ),
                blankSpace: 50,
                velocity: 30,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10,
              ),
            ),
          ],
        ),
      );
    });
  }
}