import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/responsive_spacing.dart';
import '../utils/navigation_helper.dart';
import '../widgets/shimmers.dart';

class SearchComponent extends StatelessWidget {
  const SearchComponent({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search products...',
  }) : super(key: key);

  final Function(String) onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/search');
      },
      child: ResponsiveContainer(
        height: ResponsiveUtils.rp(44),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(14.0)),
        backgroundColor: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
        child: Row(
          children: [
            ResponsiveIcon(Icons.search,
                color: AppColors.textSecondary, size: 20),
            ResponsiveSpacing.horizontal(10),
            Expanded(
              child: ResponsiveText(
                hintText,
                style: ResponsiveTextStyles.bodyMedium(
                    color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenSearchPage extends StatefulWidget {
  const FullScreenSearchPage({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search products...',
  }) : super(key: key);

  final Function(String) onSearch;
  final String hintText;

  @override
  State<FullScreenSearchPage> createState() => _FullScreenSearchPageState();
}

class _FullScreenSearchPageState extends State<FullScreenSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final text = _controller.text.trim();
      widget.onSearch(text); // trigger BannerController search
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerController bannerController = Get.find<BannerController>();
    final UtilityController utilityController = Get.find<UtilityController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      bannerController.searchResults.clear(); // reset results
                    },
                  )
                : null,
          ),
        ),
      ),
      body: Obx(() {
        final results = bannerController.searchResults;
        final isLoading = utilityController.isLoadingRx.value;

        if (isLoading && results.isEmpty) {
          return _buildShimmerList();
        }

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: ResponsiveUtils.rp(64),
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: ResponsiveSpacing.padding(all: 16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return _buildSearchResultCard(item);
          },
        );
      }),
    );
  }

  /// Build search result card with box structure
  Widget _buildSearchResultCard(item) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.1),
            blurRadius: ResponsiveUtils.rp(4),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            NavigationHelper.navigateToProductDetail(
              productId: item.productId,
              productName: item.productName,
            );
          },
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
            child: Row(
              children: [
                // Product Image with shimmer
                ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  child: _buildProductImage(item.previewImage),
                ),
                ResponsiveSpacing.horizontal(12),
                // Product Name
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: AppColors.icon.withValues(alpha: 0.5),
                  size: ResponsiveUtils.rp(24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build shimmer list for loading state
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: ResponsiveSpacing.padding(all: 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Image shimmer
              Skeletons.imageRect(
                height: ResponsiveUtils.rp(80),
                width: ResponsiveUtils.rp(80),
                radius: 8,
              ),
              ResponsiveSpacing.horizontal(12),
              // Text shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeletons.textLine(
                      height: ResponsiveUtils.rp(16),
                      width: double.infinity,
                    ),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                    Skeletons.textLine(
                      height: ResponsiveUtils.rp(14),
                      width: ResponsiveUtils.rp(120),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build product image with shimmer on loading and error
  Widget _buildProductImage(String? imageUrl) {
    final imageSize = ResponsiveUtils.rp(80);
    
    // Show shimmer if no image URL
    if (imageUrl == null || imageUrl.isEmpty) {
      return Skeletons.imageRect(
        height: imageSize,
        width: imageSize,
        radius: 8,
      );
    }

    return SizedBox(
      width: imageSize,
      height: imageSize,
      child: Image.network(
        imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          // Show shimmer while loading
          return Skeletons.imageRect(
            height: imageSize,
            width: imageSize,
            radius: 8,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Show shimmer on error instead of error message
          return Skeletons.imageRect(
            height: imageSize,
            width: imageSize,
            radius: 8,
          );
        },
      ),
    );
  }
}
