import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe.app/controllers/collection%20controller/Collectionmodel.dart';

import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/sizes.dart';
import '../widgets/card.dart';

class CollectionCarousel extends StatefulWidget {
  final Function(Collection) onCollectionTap;

  const CollectionCarousel({Key? key, required this.onCollectionTap})
      : super(key: key);

  @override
  State<CollectionCarousel> createState() => _CollectionCarouselState();
}

class _CollectionCarouselState extends State<CollectionCarousel> {
  // Using Get.find() safely, assuming controllers are bound
  final CollectionsController collectionsController =
      Get.put(CollectionsController());
  final UtilityController utilityController = Get.put(UtilityController());

  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  // 🔥 UX IMPROVEMENT 1: Increase target item width for better spacing
  static const double _targetItemWidth = 130.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionsController.fetchAllCollections();
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final totalPages = _computeTotalPages();
      if (totalPages <= 1) return;
      _currentPage = (_currentPage + 1) % totalPages;
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // 🔥 UX IMPROVEMENT 2: Use the new wider item width
  int _itemsPerPage(double availableWidth) {
    final count = (availableWidth / _targetItemWidth).floor();
    // keep at least two cards visible
    if (count > 4) return 4; // avoid overly tiny cards on very wide screens
    return count;
  }

  int _computeTotalPages() {
    final total = collectionsController.allCollections.length;
    if (total == 0) return 0;
    // Get screen width safely using context and handle case where context might be null during very early build stages
    final screenWidth = MediaQuery.of(context).size.width;
    final itemsPerPage = _itemsPerPage(screenWidth);
    if (itemsPerPage == 0)
      return 1; // Prevent division by zero if screen is tiny
    return ((total - 1) / itemsPerPage).floor() + 1;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (utilityController.isLoadingRx.value) {
        // 🔥 UX IMPROVEMENT 3: Increased skeleton height
        return SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Match carousel padding
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                _itemsPerPage(MediaQuery.of(context)
                    .size
                    .width), // Show appropriate number of skeletons
                (_) => const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0), // Match item padding
                    child: _CollectionSkeleton(),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      final items = collectionsController.allCollections;
      if (items.isEmpty) {
        return const SizedBox.shrink();
      }

      final screenWidth = MediaQuery.of(context).size.width;
      final itemsPerPage = _itemsPerPage(screenWidth);
      final totalPages = _computeTotalPages();

      // 🔥 Stable layout: fill row with placeholders to keep spacing
      return SizedBox(
        height: 50,
        child: PageView.builder(
          controller: _pageController,
          itemCount: totalPages,
          itemBuilder: (context, pageIndex) {
            final start = pageIndex * itemsPerPage;
            final end = (start + itemsPerPage).clamp(0, items.length);
            final pageItems = items.sublist(start, end);

            final children = <Widget>[];
            for (final collection in pageItems) {
              children.add(
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () => widget.onCollectionTap(collection),
                      child: CollectionCard(collection: collection),
                    ),
                  ),
                ),
              );
            }
            while (children.length < itemsPerPage) {
              children.add(const Expanded(child: SizedBox.shrink()));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
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
    return AppSmallCard(
      elevation: 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.cardRadius * 0.5)),
                color: Colors.white,
              ),
              child: collection.featuredAsset != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppSizes.cardRadius * 0.5)),
                      child: Image.network(
                        collection.featuredAsset!.preview,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Icon(Icons.folder_open,
                          size: 24, color: Colors.blueGrey[300]),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Text(
              collection.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionSkeleton extends StatelessWidget {
  const _CollectionSkeleton();

  @override
  Widget build(BuildContext context) {
    // 🔥 UX IMPROVEMENT 12: Skeleton structure matches the new card layout
    return AppSmallCard(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.cardRadius * 0.75)),
                color: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
