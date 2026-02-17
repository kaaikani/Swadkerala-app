import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../controllers/theme_controller.dart';
import '../graphql/product.graphql.dart';
import '../theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_container.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/responsive_icon.dart';

class VerticalListComponent extends StatefulWidget {
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
  State<VerticalListComponent> createState() => _VerticalListComponentState();
}

class _VerticalListComponentState extends State<VerticalListComponent> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      _loadMoreCollections();
    }
  }

  /// Called when horizontal scroll notification is received (reliable when nested in vertical scroll).
  void _onScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    // Only react to horizontal scroll (category list), not vertical (main page).
    if (metrics.axis != Axis.horizontal) return;
    if (metrics.maxScrollExtent <= 0) return;
    if (metrics.pixels >= metrics.maxScrollExtent * 0.8) {
      _loadMoreCollections();
    }
  }

  Future<void> _loadMoreCollections() async {
    if (_isLoadingMore) return;
    
    final collectionsController = Get.find<CollectionsController>();
    if (!collectionsController.hasMoreCollections || 
        collectionsController.isLoadingMoreCollections) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await collectionsController.loadMoreCollections();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title.isNotEmpty)
              Padding(
                padding: ResponsiveSpacing.padding(horizontal: 16, vertical: 8),
                child: ResponsiveText(
                  widget.title,
                  fontSize: ResponsiveUtils.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(
              height: ResponsiveUtils.rp(140) + 4.5,
              child: displayItems.isEmpty
                  ? const SizedBox.shrink()
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        if (notification is ScrollUpdateNotification ||
                            notification is ScrollEndNotification) {
                          _onScrollNotification(notification);
                        }
                        return false;
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: displayItems.length + (collectionsController.hasMoreCollections ? 1 : 0),
                        separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(12),
                        itemBuilder: (_, index) {
                  // Show loading indicator at the end if there are more items
                  if (index >= displayItems.length) {
                    return Container(
                      width: ResponsiveUtils.rp(80),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: ResponsiveUtils.rp(24),
                        height: ResponsiveUtils.rp(24),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                        ),
                      ),
                    );
                  }

                  final collection = displayItems[index];
                  final itemWidth = ResponsiveUtils.rp(80);
                  final imageSize = ResponsiveUtils.rp(60);
                  final asset = collection.featuredAsset;
                  final hasValidAsset = asset != null && 
                                      collection.id.isNotEmpty && 
                                      asset.preview.isNotEmpty;

                  // Get theme controller to check dark mode
                  final themeController = Get.find<ThemeController>();
                  final isDarkMode = themeController.isDarkMode;
                  
                  return GestureDetector(
                    onTap: collection.id.isNotEmpty
                        ? () => widget.onTap(collection)
                        : null,
                    child: ResponsiveContainer(
                      width: itemWidth,
                      borderRadius: BorderRadius.zero,
                      backgroundColor: isDarkMode ? Colors.transparent : null,
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
                            fontSize: ResponsiveUtils.sp(12),
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
