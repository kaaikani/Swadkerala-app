import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/collection controller/Collectionmodel.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/premium_card.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/responsive_icon.dart';
import '../widgets/responsive_container.dart';

class CollectionGrid extends StatefulWidget {
  final Function(Collection) onCollectionTap;

  const CollectionGrid({Key? key, required this.onCollectionTap})
      : super(key: key);

  @override
  State<CollectionGrid> createState() => _CollectionGridState();
}

class _CollectionGridState extends State<CollectionGrid> {
  final CollectionsController collectionsController =
      Get.find<CollectionsController>();
  final UtilityController utilityController = Get.find<UtilityController>();

  @override
  void initState() {
    super.initState();
    // Fetch collections only if empty (controller handles duplicate prevention)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionsController.fetchAllCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final items = collectionsController.allCollections;
      final displayItems = isLoading
          ? List.filled(
              4,
              Collection(
                id: '',
                name: 'Loading...',
                slug: '',
                productVariants: ProductVariants(totalItems: 0),
              ))
          : items;

      if (items.isEmpty && !isLoading) {
        return const SizedBox.shrink();
      }

      return Skeletonizer(
        enabled: isLoading,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(20)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.gridCrossAxisCount,
            crossAxisSpacing: ResponsiveUtils.rp(16),
            mainAxisSpacing: ResponsiveUtils.rp(16),
            childAspectRatio: 0.82,
          ),
          itemCount: displayItems.length,
          itemBuilder: (context, index) {
            if (isLoading) {
              return CollectionCard(
                collection: Collection(
                  id: '',
                  name: 'Loading...',
                  slug: '',
                  productVariants: ProductVariants(totalItems: 0),
                ),
              );
            }
            final collection = items[index];
            return GestureDetector(
              onTap: () => widget.onCollectionTap(collection),
              child: CollectionCard(collection: collection),
            );
          },
        ),
      );
    });
  }
}

class CollectionCard extends StatelessWidget {
  final Collection collection;

  const CollectionCard({Key? key, required this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(24)),
      backgroundColor: AppColors.surface,
      boxShadow: [
        BoxShadow(
          color: AppColors.zomatoRed.withValues(alpha: 0.12),
          blurRadius: ResponsiveUtils.rp(20),
          offset: Offset(0, ResponsiveUtils.rp(8)),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: ResponsiveUtils.rp(12),
          offset: Offset(0, ResponsiveUtils.rp(4)),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Collection Image with Premium Styling
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveUtils.rp(24))),
              child: ResponsiveContainer(
                width: double.infinity,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: collection.featuredAsset != null
                      ? [
                          AppColors.grey100,
                          AppColors.grey200,
                          AppColors.grey300,
                        ]
                      : [
                          AppColors.grey200,
                          AppColors.grey300,
                          AppColors.grey400,
                        ],
                ),
                borderRadius: BorderRadius.zero,
                boxShadow: [],
                child: Stack(
                  children: [
                    collection.featuredAsset != null
                        ? Positioned.fill(
                            child: Image.network(
                              collection.featuredAsset!.preview,
                              fit: BoxFit.cover,
                              cacheWidth: 500,
                              cacheHeight: 500,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: AppColors.zomatoRed,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: ResponsiveIcon(
                                    Icons.broken_image_rounded,
                                    size: 52,
                                    color: AppColors.textTertiary,
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: ResponsiveIcon(
                              Icons.category_rounded,
                              size: 52,
                              color: AppColors.textTertiary,
                            ),
                          ),
                    ResponsiveContainer(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.zero,
                      boxShadow: [],
                      child: SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Collection Info with Enhanced Styling
          Expanded(
            flex: 1,
            child: ResponsiveContainer(
              padding: ResponsiveSpacing.padding(horizontal: 14, vertical: 14),
              backgroundColor: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(ResponsiveUtils.rp(24))),
              boxShadow: [],
              child: Center(
                child: ResponsiveText(
                  collection.name,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: ResponsiveUtils.rp(-0.3),
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
