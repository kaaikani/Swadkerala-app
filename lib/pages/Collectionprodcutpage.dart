import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../routes.dart';
import '../services/graphql_client.dart';
import '../graphql/product.graphql.dart';
import '../widgets/Variant bottom sheet.dart' show VariantBottomSheet;
import '../widgets/appbar.dart';
import '../widgets/cart_button_with_badge.dart';
// import '../widgets/snackbar.dart'; // Unused import
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/product_card.dart';
import '../utils/price_formatter.dart';
import '../utils/navigation_helper.dart';
import '../services/analytics_service.dart';

class CollectionProductsPage extends StatefulWidget {
  final String collectionId;
  final String collectionName;
  final String? slug;

  const CollectionProductsPage({
    Key? key,
    required this.collectionId,
    required this.collectionName,
    this.slug,
  }) : super(key: key);

  @override
  State<CollectionProductsPage> createState() => _CollectionProductsPageState();
}

class _CollectionProductsPageState extends State<CollectionProductsPage> {
  final CollectionsController controller = Get.find();
  final CartController cartController = Get.find<CartController>();
  final BannerController bannerController = Get.find<BannerController>();
  final UtilityController utilityController = Get.find();
  
  // Scroll controller for lazy loading
  final ScrollController _scrollController = ScrollController();
  
  // Flag to prevent multiple simultaneous fetches
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'CollectionProducts', parameters: <String, Object>{'collection_name': widget.collectionName});
    // Add scroll listener for lazy loading
    _scrollController.addListener(_onScroll);
    
    
    // Only fetch once on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_hasInitialized) {
        return;
      }
      
      _hasInitialized = true;
      
      try {
        // Only call these three methods as requested
        await Future.wait([
          controller.fetchCollectionproducts(id: widget.collectionId, slug: widget.slug),
          bannerController.getCustomerFavorites(),
          cartController.getActiveOrder(),
        ], eagerError: false);
        
        // Check if collection was found after fetch attempt
        if (controller.currentCollection.value == null) {
          _handleCollectionNotFound();
          return;
        }
        
      } catch (e) {
        _handleCollectionNotFound();
        return;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll to detect when to load more products
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      if (controller.hasMoreItems && !controller.isLoadingMore) {
        _loadMoreProducts();
      }
    }
  }

  /// Load more products
  Future<void> _loadMoreProducts() async {
    if (controller.isLoadingMore || !controller.hasMoreItems) {
      return;
    }
    
    await controller.loadMoreProducts();
  }

  /// Handle add to cart - show selector only when explicitly allowed.
  Future<bool> _handleAddToCart(
    Query$Products$collection$productVariants$items variant, {
    bool allowVariantSelector = true,
  }) async {
    final product = variant.product;
    final allVariants = controller.getVariantsForProduct(product.id);

    if (!allowVariantSelector || allVariants.length <= 1) {
      return await _addToCart(variant);
    }

    // Multiple variants and selector allowed — show sheet for quick pick
    showVariantSheet(product.name, allVariants);
    return false; // Return false when showing variant sheet
  }

  /// Get display name from variant options, fallback to variant name
  String _getVariantDisplayName(
      Query$Products$collection$productVariants$items variant) {
    final collectionsController = Get.find<CollectionsController>();
    return collectionsController.buildVariantLabel(variant);
  }

  /// Get variant label that matches what's shown in the dropdown
  String _getVariantLabelFromSelectedVariant(
      Query$Products$collection$productVariants$items selectedVariant,
      String? groupName) {
    // If there's an option group, get the option name from that group (same as dropdown)
    if (groupName != null && selectedVariant.options.isNotEmpty) {
      for (final opt in selectedVariant.options) {
        if (opt.group.name == groupName) {
          return opt.name; // Return the option name (same as dropdown shows)
        }
      }
    }
    
    // Fallback: if no options, use the variant name
    if (selectedVariant.options.isEmpty) {
      return selectedVariant.name;
    }
    
    // If no matching group, return first option name
    return selectedVariant.options.first.name;
  }

  double? _calculateDiscountPercent(
      Query$Products$collection$productVariants$items variant) {
    final shadowPriceMinor = _getShadowPriceMinor(variant);
    if (shadowPriceMinor == null) {
      return null;
    }

    final currentPriceMinor = variant.priceWithTax.round();
    if (shadowPriceMinor <= currentPriceMinor) {
      return null;
    }

    final discount =
        ((shadowPriceMinor - currentPriceMinor) / shadowPriceMinor) * 100;
    if (discount <= 0) {
      return null;
    }
    return discount;
  }

  int? _getShadowPriceMinor(
      Query$Products$collection$productVariants$items variant) {
    final rawValue = variant.customFields?.shadowPrice;
    if (rawValue == null || rawValue <= 0) {
      return null;
    }

    final currentPriceMinor = variant.priceWithTax.round();

    // If the stored value already looks like minor units (>= current price), use it directly
    if (rawValue > currentPriceMinor) {
      return rawValue;
    }

    // Some catalog entries may store shadow price in rupees; scale up to paise
    final scaledValue = rawValue * 100;
    if (scaledValue > currentPriceMinor) {
      return scaledValue;
    }

    return null;
  }

  /// Dropdown selector for product option groups (Blinkit style)
  Widget _buildVariantSelector({
    required String productId,
    required List<Query$Products$collection$productVariants$items>
        variantsForProduct,
  }) {
    final referenceVariant = variantsForProduct.first;

    if (referenceVariant.product.optionGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    final optionGroup = referenceVariant.product.optionGroups.first;
    final groupName = optionGroup.name;

    final uniqueOptions =
        controller.getUniqueOptionsForGroup(productId, groupName);
    if (uniqueOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedVariant =
        controller.getSelectedVariantForProduct(productId) ?? referenceVariant;

    String? currentOptionValue;
    for (final opt in selectedVariant.options) {
      if (opt.group.name == groupName) {
        currentOptionValue = opt.name;
        break;
      }
    }

    // Check if channel is Ind-Snacks - use reactive observable
    return Obx(() {
      final channelToken = GraphqlService.channelTokenRx.value.isNotEmpty 
          ? GraphqlService.channelTokenRx.value 
          : GraphqlService.channelToken;
      final isIndSnacksChannel = channelToken == 'Ind-Snacks' || channelToken == 'ind-snacks';
      
      return Container(
      height: ResponsiveUtils.rp(32),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(
          color: isIndSnacksChannel ? AppColors.indSnacksAccent : AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentOptionValue,
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: ResponsiveUtils.rp(20),
            color: AppColors.icon.withValues(alpha: 0.7),
          ),
          iconSize: ResponsiveUtils.rp(20),
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(12),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          hint: Text(
            groupName,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: uniqueOptions.map((optionName) {
            final isSelected = optionName == currentOptionValue;
            return DropdownMenuItem<String>(
              value: optionName,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.rp(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(13),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          dropdownColor: AppColors.card,
          menuMaxHeight: ResponsiveUtils.rp(200),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
          onChanged: (String? newOptionName) {
            if (newOptionName == null) return;

            Query$Products$collection$productVariants$items? matchingVariant;
            for (final variant in variantsForProduct) {
              final hasOption = variant.options.any(
                (opt) =>
                    opt.name == newOptionName && opt.group.name == groupName,
              );
              if (hasOption) {
                matchingVariant = variant;
                break;
              }
            }

            if (matchingVariant != null) {
              controller.setSelectedVariant(productId, matchingVariant.id);
            }
          },
        ),
      ),
    );
    });
  }

  /// Add a variant to cart
  Future<bool> _addToCart(
      Query$Products$collection$productVariants$items variant) async {
    final variantId = int.tryParse(variant.id);
    if (variantId == null) {
      return false;
    }

    final success = await cartController.addToCart(
        productVariantId: variantId, quantity: 1);

    if (success) {
      final displayName = _getVariantDisplayName(variant);


      // Track add to cart event
      final price = variant.priceWithTax / 100.0; // Convert from minor units
      await AnalyticsService().logAddToCart(
        itemId: variant.id,
        itemName: displayName,
        itemCategory: variant.product.name,
        price: price,
        currency: 'INR',
        quantity: 1,
      );
      
      // Trigger state update for UI refresh
      if (mounted) {
        setState(() {});
      }
    }
    
    return success;
  }

  /// Show bottom sheet with variant options
  void showVariantSheet(String productName,
      List<Query$Products$collection$productVariants$items> variants) {
    Get.bottomSheet(
      VariantBottomSheet(
        productName: productName,
        variants: variants,
      ),
      isScrollControlled: true,
    );
  }

  /// Handle double tap to toggle favorite
  Future<void> _handleFavoriteToggle(
      String productId, String productName) async {
    final wasFavorite = bannerController.isFavorite(productId);

    final success = await bannerController.toggleFavorite(productId: productId);

    if (success) {
      if (wasFavorite) {
      } else {
        
        // Track add to wishlist event
        final variants = controller.getVariantsForProduct(productId);
        if (variants.isNotEmpty) {
          final variant = variants.first;
          final price = variant.priceWithTax / 100.0;
          await AnalyticsService().logAddToWishlist(
            itemId: variant.id,
            itemName: productName,
            itemCategory: 'Product',
            price: price,
            currency: 'INR',
          );
        }
      }
    } else {}
  }


  // --- Start of UI Restructure: Blinkit Style ---



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: widget.collectionName,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.toNamed('/search');
            },
          ),
          CartButtonWithBadge(
            cartController: cartController,
            useIconButton: true,
          ),
        ],
      ),
      body: Obx(() {
        // Show shimmer grid while loading
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerGrid();
        }

        final collection = controller.currentCollection.value;

        // Show shimmer grid when collection is null
        if (collection == null) {
          return _buildShimmerGrid();
        }

        final variants = controller.uniqueProductVariants;

        if (variants.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Only refresh these three as requested
            await Future.wait([
              controller.fetchCollectionproducts(id: widget.collectionId, slug: widget.slug),
              bannerController.getCustomerFavorites(),
              cartController.getActiveOrder(),
            ], eagerError: false);
          },
          color: AppColors.refreshIndicator,
          child: GridView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(20),
            ),
            itemCount: variants.length + (controller.hasMoreItems ? 1 : 0), // Add 1 for loading indicator
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ResponsiveUtils.rp(14),
              mainAxisSpacing: ResponsiveUtils.rp(18),
              childAspectRatio: ResponsiveUtils.rp(0.72),
            ),
            itemBuilder: (context, index) {
              // Show loading indicator at the end
              if (index >= variants.length) {
                return _buildLoadingIndicator();
              }
              final variant = variants[index];
              final product = variant.product;

              final name = product.name;
              final imageUrl = product.featuredAsset?.preview;
              final productId = product.id;

              return Obx(() {
                final variantsForProduct =
                    controller.getVariantsForProduct(productId);
                if (variantsForProduct.isEmpty) {
                  return const SizedBox.shrink();
                }

                final selectedVariant =
                    controller.getSelectedVariantForProduct(productId) ??
                        variant;
                final priceMinorUnits = selectedVariant.priceWithTax.round();
                final priceText = PriceFormatter.formatPrice(priceMinorUnits);

                // Get the same option value that's shown in the dropdown
                final variantLabel = _getVariantLabelFromSelectedVariant(
                  selectedVariant,
                  product.optionGroups.isNotEmpty
                      ? product.optionGroups.first.name
                      : null,
                );
                final shadowPriceMinor = _getShadowPriceMinor(selectedVariant);
                final discountPercent =
                    _calculateDiscountPercent(selectedVariant);

                final isFavorite = bannerController.isFavorite(productId);

                final showVariantSelector = product.optionGroups.isNotEmpty &&
                    variantsForProduct.length > 1;
                final shadowPriceText = (shadowPriceMinor != null &&
                        shadowPriceMinor > priceMinorUnits)
                    ? PriceFormatter.formatPrice(shadowPriceMinor)
                    : null;

                // Stock level from the selected product variant (IN_STOCK, LOW_STOCK, OUT_OF_STOCK)
                final stockLevelStr = selectedVariant.stockLevel;
                final isOutOfStock = stockLevelStr.toUpperCase() == 'OUT_OF_STOCK';

                // Get group name for display
                final groupName = product.optionGroups.isNotEmpty
                    ? product.optionGroups.first.name
                    : null;

                // Check if product has multiple variants
                final hasMultipleVariants = variantsForProduct.length > 1;

                return ProductCard(
                  name: name,
                  imageUrl: imageUrl,
                  onTap: () {
                    NavigationHelper.navigateToProductDetail(
                      productId: productId,
                      productName: name,
                    );
                  },
                  onDoubleTap: () => _handleFavoriteToggle(productId, name),
                  isFavorite: isFavorite,
                  onFavoriteToggle: () =>
                      _handleFavoriteToggle(productId, name),
                  discountPercent: discountPercent,
                  variantSelector: showVariantSelector
                      ? _buildVariantSelector(
                          productId: productId,
                          variantsForProduct: variantsForProduct,
                        )
                      : null,
                  showVariantSelector: showVariantSelector,
                  variantLabel: variantLabel,
                  priceText: priceText,
                  shadowPriceText: shadowPriceText,
                  isOutOfStock: isOutOfStock,
                  stockLevel: stockLevelStr,
                  groupName: groupName,
                  hasMultipleVariants: hasMultipleVariants,
                  onAddToCart: () => _handleAddToCart(
                    selectedVariant,
                    allowVariantSelector: false,
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }

  // Rest of the class methods (_buildShimmerGrid, etc.) remain the same...

  Widget _buildShimmerGrid() {
    // Check if channel is Ind-Snacks - use reactive observable
    return Obx(() {
      final channelToken = GraphqlService.channelTokenRx.value.isNotEmpty 
          ? GraphqlService.channelTokenRx.value 
          : GraphqlService.channelToken;
      final isIndSnacksChannel = channelToken == 'Ind-Snacks' || channelToken == 'ind-snacks';
      
      return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(16),
          vertical: ResponsiveUtils.rp(20),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: ResponsiveUtils.rp(14),
          mainAxisSpacing: ResponsiveUtils.rp(18),
          childAspectRatio: ResponsiveUtils.rp(0.72),
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10), // Reduced border radius
              border: Border.all(
                color: isIndSnacksChannel ? AppColors.black : AppColors.border.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image shimmer (proportional)
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                // Content shimmer
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.rp(8),
                      vertical: ResponsiveUtils.rp(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product name shimmer (2 lines)
                        Container(
                          height: ResponsiveUtils.rp(14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(3)),
                        Container(
                          height: ResponsiveUtils.rp(12),
                          width: ResponsiveUtils.rp(80),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.rp(4)),
                        // Price shimmer
                        Container(
                          height: ResponsiveUtils.rp(14),
                          width: ResponsiveUtils.rp(50),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      );
    });
  }

  /// Build loading indicator for lazy loading
  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.button,
              strokeWidth: 2,
            ),
            SizedBox(height: ResponsiveUtils.rp(8)),
            Text(
              'Loading more...',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle collection not found / load error - redirect to home (browsing categories does not require login)
  void _handleCollectionNotFound() {
    try {
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
