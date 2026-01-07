import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../graphql/product.graphql.dart';
import '../theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_container.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/responsive_icon.dart';

class VerticalListComponent extends StatelessWidget {
  final String title;
  final bool showPrice;
  final void Function(Query$Collections$collections$items) onTap;

  const VerticalListComponent({
    Key? key,
    this.title = '',
    this.showPrice = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final collectionsController = Get.find<CollectionsController>();
      final utilityController = Get.find<UtilityController>();

      final bool isLoading = utilityController.isLoadingRx.value;
      final items = collectionsController.allCollections;
      final displayItems = isLoading
          ? List<Query$Collections$collections$items>.filled(
              6,
              Query$Collections$collections$items(
                id: '',
                name: 'Loading...',
                slug: '',
                productVariants: Query$Collections$collections$items$productVariants(totalItems: 0),
              ))
          : items;

      // Ensure we always have items or return a sized widget
      if (displayItems.isEmpty && !isLoading) {
        return const SizedBox.shrink();
      }

      return Skeletonizer(
        enabled: isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: ResponsiveSpacing.padding(horizontal: 16, vertical: 8),
                child: ResponsiveText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(
              height: ResponsiveUtils.rp(140),
              child: displayItems.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: displayItems.length,
                      separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(12),
                itemBuilder: (_, index) {
                  final collection = displayItems[index];
                  final itemWidth = ResponsiveUtils.rp(80);
                  final imageSize = ResponsiveUtils.rp(60);
                  final asset = collection.featuredAsset;
                  final hasValidAsset = asset != null && 
                                      collection.id.isNotEmpty && 
                                      asset.preview.isNotEmpty;

                  return GestureDetector(
                    onTap: collection.id.isNotEmpty
                        ? () => onTap(collection)
                        : null,
                    child: ResponsiveContainer(
                      width: itemWidth,
                      borderRadius: BorderRadius.zero,
                      boxShadow: [],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ResponsiveContainer(
                            width: imageSize,
                            height: imageSize,
                            borderRadius:
                                BorderRadius.circular(ResponsiveUtils.rp(16)),
                            backgroundColor: Color(0xFFF6F6F6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(ResponsiveUtils.rp(16)),
                              child: hasValidAsset
                                  ? Image.network(
                                      asset.preview,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _buildCategoryPlaceholder(imageSize),
                                    )
                                  : _buildCategoryPlaceholder(imageSize),
                            ),
                          ),
                          ResponsiveSpacing.vertical(8),
                          ResponsiveText(
                            collection.name.isNotEmpty
                                ? collection.name
                                : 'Collection',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.white,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryPlaceholder(double size) {
    return Center(
      child: ResponsiveIcon(
        Icons.category_rounded,
        color: Colors.white,
        size: size * 0.4,
      ),
    );
  }
}
