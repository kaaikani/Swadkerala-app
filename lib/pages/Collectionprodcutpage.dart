import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../routes.dart';
import '../services/graphql_client.dart';
import '../graphql/product.graphql.dart';
import '../widgets/Variant bottom sheet.dart' show VariantBottomSheet;
import '../widgets/appbar.dart';
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
  final CartController cartController = Get.put(CartController());
  final BannerController bannerController = Get.put(BannerController());
  final UtilityController utilityController = Get.find();

  @override
  void initState() {
    super.initState();
/// debugPrint(  '🎯 [CollectionProductsPage] Initialized with ID: ${widget.collectionId}, Name: ${widget.collectionName}, Slug: ${widget.slug}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
/// debugPrint(  '🔍 [CollectionProductsPage] Fetching products for collection ID: ${widget.collectionId}, Slug: ${widget.slug}');
      
      try {
        await controller.fetchCollectionproducts(id: widget.collectionId, slug: widget.slug);
        
        // Check if collection was found after fetch attempt
        if (controller.currentCollection.value == null) {
// debugPrint('⚠️ [CollectionProductsPage] Collection not found, handling redirect...');
          _handleCollectionNotFound();
          return;
        }
        
      } catch (e) {
// debugPrint('❌ [CollectionProductsPage] Error fetching collection: $e');
        _handleCollectionNotFound();
        return;
      }
      
      // Fetch favorites to know which products are favorited
      bannerController.getCustomerFavorites();
      cartController.getActiveOrder();
    });
  }

  /// Handle add to cart - show selector only when explicitly allowed.
  void _handleAddToCart(
    Query$Products$collection$productVariants$items variant, {
    bool allowVariantSelector = true,
  }) {
    final product = variant.product;
    final allVariants = controller.getVariantsForProduct(product.id);

    if (!allowVariantSelector || allVariants.length <= 1) {
      _addToCart(variant);
      return;
    }

    // Multiple variants and selector allowed — show sheet for quick pick
    showVariantSheet(product.name, allVariants);
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

    return Container(
      height: ResponsiveUtils.rp(32),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
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
                    if (isSelected) ...[
                      SizedBox(width: ResponsiveUtils.rp(6)),
                      Icon(
                        Icons.check_circle_rounded,
                        size: ResponsiveUtils.rp(16),
                        color: AppColors.button,
                      ),
                    ],
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
  }

  /// Add a variant to cart
  Future<void> _addToCart(
      Query$Products$collection$productVariants$items variant) async {
    final variantId = int.tryParse(variant.id);
    if (variantId == null) {
      return;
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
      appBar: AppBarWidget(
        title: widget.collectionName,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.toNamed('/search');
            },
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

        final children = collection.children;
        final variants = controller.uniqueProductVariants;

        if (children.isEmpty && variants.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              controller.fetchCollectionproducts(id: widget.collectionId),
              bannerController.getCustomerFavorites(),
            ]);
          },
          color: AppColors.refreshIndicator,
          child: GridView.builder(
            // Reduced padding for denser layout
            padding: EdgeInsets.all(ResponsiveUtils.rp(8)),
            itemCount: variants.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ResponsiveUtils.rp(8), // Reduced spacing
              mainAxisSpacing: ResponsiveUtils.rp(8), // Reduced spacing
              childAspectRatio:
                  0.60, // Significantly reduced aspect ratio for a shorter card
            ),
            itemBuilder: (context, index) {
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
    // Shimmer grid adjustment for new aspect ratio
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(8), // Reduced padding
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8, // Reduced spacing
          mainAxisSpacing: 8, // Reduced spacing
          childAspectRatio: 0.60, // Adjusted aspect ratio
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10), // Reduced border radius
              border:
                  Border.all(color: AppColors.border.withValues(alpha: 0.5)),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name shimmer (2 lines)
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 14,
                          width: ResponsiveUtils.rp(100),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Price shimmer
                        Container(
                          height: 14,
                          width: ResponsiveUtils.rp(50),
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Spacer(),
                        // Button shimmer
                        Container(
                          height: 36,
                          width:
                              ResponsiveUtils.rp(80), // Smaller button shimmer
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(8),
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
  }

  /// Handle collection not found error - redirect based on authentication status
  void _handleCollectionNotFound() {
    try {
      // Check authentication status
      final authController = Get.find<AuthController>();
      final authToken = GraphqlService.authToken;
      final channelToken = GraphqlService.channelToken;
      
      final isAuthenticated = authController.isLoggedIn && 
                             authToken.isNotEmpty && 
                             channelToken.isNotEmpty;
      
// debugPrint('🔍 [CollectionProductsPage] Authentication status: $isAuthenticated');
      
      if (isAuthenticated) {
// debugPrint('🏠 [CollectionProductsPage] User authenticated - redirecting to home');
        Get.offAllNamed(AppRoutes.home);
      } else {
// debugPrint('🔐 [CollectionProductsPage] User not authenticated - redirecting to login');
        Get.offAllNamed(AppRoutes.login);
      }
      
    } catch (e) {
// debugPrint('❌ [CollectionProductsPage] Error checking auth status: $e');
      // Fallback to home page if there's any error
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
