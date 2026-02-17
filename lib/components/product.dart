import 'package:flutter/material.dart';

import '../context/context.dart';
import '../theme/colors.dart';
import '../widgets/cached_app_image.dart';
import '../theme/sizes.dart';
import '../widgets/snackbar.dart';

class ProductComponent extends StatefulWidget {
  final String imageUrl;
  final String title;

  const ProductComponent({
    super.key,
    required this.imageUrl,
    this.title = AppContent.addToCart,
  });

  @override
  State<ProductComponent> createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.cardElevation,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      margin: const EdgeInsets.all(AppSizes.defaultMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min, // wraps content tightly
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image with heart overlay
          Stack(
            children: [
              Container(
                height: AppSizes.imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  child: CachedAppImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 400,
                    cacheHeight: 300,
                    errorWidget: Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => setState(() => isLiked = !isLiked),
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked
                        ? AppColors.heartActive
                        : AppColors.heartInactive,
                    size: AppSizes.heartIconSize,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6), // small gap above button

          // Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.buttonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.cardRadius / 1.3),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.buttonHorizontalPadding,
                vertical: AppSizes.buttonVerticalPadding,
              ),
            ),
            onPressed: () {
              SnackBarWidget.show(
                context,
                AppContent.addedToCartMsg,
                backgroundColor: AppColors.primary,
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(widget.title),
          ),
        ],
      ),
    );
  }
}
