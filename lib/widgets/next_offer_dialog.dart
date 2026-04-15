import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../graphql/banner.graphql.dart';
import '../routes.dart';
import '../utils/responsive.dart';
import 'cached_app_image.dart';

/// Full-image dialog that shows the next custom offer for the channel.
/// Tapping the image navigates based on the offer's link target:
///   - productVariant → product detail page (with selected variant)
///   - product        → product detail page
///   - collection     → collection products page
///
/// Shows only **once per day per offer id** (based on local date).
class NextOfferDialog extends StatelessWidget {
  final Query$NextOffer$nextBannerPopup offer;

  const NextOfferDialog({super.key, required this.offer});

  static const _storageKey = 'next_offer_shown';

  /// Show the dialog once per day per offer id.
  /// Returns immediately if already shown today for this offer.
  static Future<void> show(Query$NextOffer$nextBannerPopup offer) async {
    final imageUrl = offer.asset.source;
    if (imageUrl.isEmpty) return;

    // Check if this offer was already shown today
    final box = GetStorage();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastShown = box.read<String>('${_storageKey}_${offer.id}');
    if (lastShown == today) return; // Already shown today for this offer

    // Mark as shown today
    await box.write('${_storageKey}_${offer.id}', today);

    await Get.dialog(
      NextOfferDialog(offer: offer),
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
    );
  }

  void _handleTap() {
    // Close the dialog first
    if (Get.isDialogOpen ?? false) Get.back();

    final variant = offer.productVariant;
    final product = offer.product;
    final collection = offer.collection;

    // 1. productVariant → product detail with pre-selected variant
    //    Use top-level product if available, otherwise fall back to variant.product
    if (variant != null) {
      final productId = product?.id ?? variant.product.id;
      final productName = product?.name ?? variant.product.name;
      Get.toNamed(AppRoutes.productDetail, arguments: {
        'productId': productId,
        'productName': productName,
        'selectedVariantId': variant.id,
      });
      return;
    }

    // 2. product only → product detail
    if (product != null) {
      Get.toNamed(AppRoutes.productDetail, arguments: {
        'productId': product.id,
        'productName': product.name,
      });
      return;
    }

    // 3. collection → collection products page
    if (collection != null) {
      Get.toNamed(AppRoutes.collectionProducts, arguments: {
        'collectionId': collection.id,
        'collectionName': collection.name,
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = offer.asset.source;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(16),
        vertical: ResponsiveUtils.rp(24),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Tappable offer image — original aspect ratio
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
              child: CachedAppImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                cacheWidth: 1080,
                placeholder: Container(
                  width: ResponsiveUtils.rp(280),
                  height: ResponsiveUtils.rp(280),
                  color: Colors.black.withValues(alpha: 0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
                errorWidget: const SizedBox.shrink(),
              ),
            ),
          ),
          // Close button at top-center, with a gap above the dialog card
          Positioned(
            top: ResponsiveUtils.rp(-60),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (Get.isDialogOpen ?? false) Get.back();
              },
              child: Container(
                width: ResponsiveUtils.rp(36),
                height: ResponsiveUtils.rp(36),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: ResponsiveUtils.rp(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
