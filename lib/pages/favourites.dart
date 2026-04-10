import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/app_image_cache_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../graphql/banner.graphql.dart';
import '../widgets/appbar.dart';
import '../widgets/cart_button_with_badge.dart';
import '../widgets/snackbar.dart';
import '../theme/colors.dart';
import '../utils/price_formatter.dart';
import '../utils/responsive.dart';
import '../utils/app_strings.dart';
import '../widgets/product_card.dart';
import '../utils/navigation_helper.dart';
import '../routes.dart';
import '../services/analytics_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final BannerController bannerController = Get.find<BannerController>();
  final CartController cartController = Get.put(CartController());
  final UtilityController utilityController = Get.find<UtilityController>();

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'Favorites');
    // Fetch favorites when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bannerController.getCustomerFavorites();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache images for better performance (only for enabled products)
    for (var favorite in bannerController.favoritesList) {
      final product = favorite.product;
      if (product != null && product.enabled) {
        final imageUrl = product.featuredAsset?.preview;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          precacheImage(
            CachedNetworkImageProvider(
              imageUrl,
              cacheManager: AppImageCacheManager.instance,
              cacheKey: AppImageCacheManager.normalizedCacheKey(imageUrl),
            ),
            context,
          );
        }
      }
    }
  }

  /// Handle removing a product from favorites
  Future<void> _handleRemoveFavorite(
      String productId, String productName) async {

    // Add small delay to ensure image has time to render if loading
    await Future.delayed(const Duration(milliseconds: 100));

    final success = await bannerController.toggleFavorite(productId: productId);
    // On failure, the error dialog already shows the API message (e.g. "No customer found for current user") — do not show a second static message.
    if (success && mounted) {
      setState(() {});
    }
  }

  /// Handle adding first variant to cart
  Future<bool> _handleAddToCart(
      String productName, String? firstVariantId) async {
    if (firstVariantId == null) {
      showErrorSnackbar('No variants available for this product');
      return false;
    }

    final variantId = int.tryParse(firstVariantId);
    if (variantId == null) {
      showErrorSnackbar('Invalid variant ID');
      return false;
    }

    final success = await cartController.addToCart(
        productVariantId: variantId, quantity: 1);

    if (success) {
      if (mounted) setState(() {});
    } else {
      showErrorSnackbar('Failed to add to cart');
    }
    
    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: AppStrings.myFavorites,
        actions: [
          CartButtonWithBadge(
            cartController: cartController,
            useIconButton: true,
          ),
        ],
      ),
      body: Obx(() {
        if (utilityController.isLoadingRx.value) {
          return _buildShimmerGrid();
        }

        // Filter out disabled products
        final enabledFavorites = bannerController.favoritesList
            .where((item) => item.product?.enabled == true)
            .where((item) => item.product != null)
            .toList();

        // Wrap both empty state and grid with RefreshIndicator
        return RefreshIndicator(
          onRefresh: () async {
            await bannerController.getCustomerFavorites();
          },
          color: AppColors.refreshIndicator,
          child: enabledFavorites.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(20),
            ),
            itemCount: enabledFavorites.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ResponsiveUtils.rp(14),
              mainAxisSpacing: ResponsiveUtils.rp(18),
              childAspectRatio: 0.52,
            ),
            itemBuilder: (context, index) {
              final favoriteItem = enabledFavorites[index];
              final product = favoriteItem.product;
              if (product == null) return SizedBox.shrink();

              final name = product.name;
              final imageUrl = product.featuredAsset?.preview;
              final productId = product.id;
              final firstVariant =
                  product.variants.isNotEmpty ? product.variants.first : null;

              return _buildFavoriteTile(
                name: name,
                imageUrl: imageUrl,
                productId: productId,
                product: product,
                variant: firstVariant,
              );
            },
          ),
        );
      }),
    );
  }

  /// Build empty state with improved UI
  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: screenHeight - appBarHeight - statusBarHeight,
        color: AppColors.background,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.rp(24),
          vertical: ResponsiveUtils.rp(40),
        ),
        child: Builder(builder: (context) {
          final iconColor = AppColors.button;
          final gradientColors = isDark
              ? [
                  Colors.grey[800]!.withOpacity(0.3),
                  Colors.grey[700]!.withOpacity(0.2),
                ]
              : [
                      AppColors.backgroundLight,
                      AppColors.primaryLight,
                    ];
          final shadowColor = isDark
              ? Colors.black.withOpacity(0.3)
              : AppColors.button.withOpacity(0.1);
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Large heart icon with gradient background
                Container(
                  width: ResponsiveUtils.rp(140),
                  height: ResponsiveUtils.rp(140),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: ResponsiveUtils.rp(70),
                      color: isDark
                          ? Colors.grey[400]
                          : iconColor.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(40)),
                // Title with better styling
                Text(
                  'No Favorites Yet',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(24),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                // Subtitle with better styling
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.rp(20),
                  ),
                  child: Text(
                    'Double tap on any product to add it to your favorites',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(48)),
                // Browse Products button with better styling
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.rp(16),
                        horizontal: ResponsiveUtils.rp(24),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.rp(12),
                        ),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Browse Products',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(16),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShimmerGrid() {
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
          childAspectRatio: 0.52,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return _buildSkeletonTile();
        },
      ),
    );
  }

  /// Get variant label from selected variant (option name)
  String _getVariantLabel(
      Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants? variant) {
    if (variant == null) return 'Default';
    
    // If variant has options, return the first option name
    if (variant.options.isNotEmpty) {
      return variant.options.first.name;
    }
    
    // Fallback to variant name if no options
    return variant.name;
  }

  Widget _buildFavoriteTile({
    required String name,
    required String? imageUrl,
    required String productId,
    required Query$GetCustomerFavorites$activeCustomer$favorites$items$product product, // <-- correct type
    required Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants? variant,
  }) {
    final priceText = variant != null
        ? PriceFormatter.formatPrice(variant.priceWithTax.round())
        : 'Rs --';

    return ProductCard(
      name: name,
      imageUrl: imageUrl,
      onTap: () {
        NavigationHelper.navigateToProductDetail(
          productId: productId,
          productName: name,
        );
      },
      onDoubleTap: () => _handleRemoveFavorite(productId, name),
      isFavorite: true,
      onFavoriteToggle: () => _handleRemoveFavorite(productId, name),
      discountPercent: null,
      variantSelector: variant == null
          ? null
          : _buildVariantDropdown(
              productId: productId,
              currentVariantId: variant.id,
            ),
      showVariantSelector: variant != null && product.variants.length > 1,
      variantLabel: _getVariantLabel(variant),
      priceText: priceText,
      shadowPriceText: null,
      isOutOfStock: false,
      cartQuantity: variant != null ? cartController.getVariantQuantity(variant.id) : 0,
      onIncrement: () => _handleAddToCart(name, variant?.id),
      onDecrement: variant != null ? () => cartController.decrementOrRemoveVariant(variantId: variant.id) : null,
      onAddToCart: () => _handleAddToCart(name, variant?.id),
    );
  }


  Widget _buildSkeletonTile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppColors.border.withValues(alpha: isDark ? 0.45 : 0.2);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(12),
              vertical: ResponsiveUtils.rp(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Container(
                  height: 16,
                  width: ResponsiveUtils.rp(100),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(14)),
                Container(
                  height: ResponsiveUtils.rp(40),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantDropdown({
    required String productId,
    required String currentVariantId,
  }) {
    final favorite = bannerController.favoritesList
        .firstWhere((item) => item.product?.id == productId);
    final product = favorite.product;
    if (product == null) return SizedBox.shrink();

    final variantOptions = product.variants;

    return Container(
        height: ResponsiveUtils.rp(36),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(8)),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(6)),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentVariantId,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: ResponsiveUtils.rp(18),
            color: AppColors.icon,
          ),
          items: variantOptions.map((variant) {
            return DropdownMenuItem<String>(
              value: variant.id,
              child: Text(
                variant.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(12),
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newVariantId) {
            if (newVariantId == null) return;
            setState(() {
              final favIndex = bannerController.favoritesList
                  .indexWhere((item) => item.product?.id == productId);
              if (favIndex != -1) {
                final product = bannerController.favoritesList[favIndex].product;
                if (product == null) return;
                final productVariants = product.variants;
                Query$GetCustomerFavorites$activeCustomer$favorites$items$product$variants? newVariant;
                for (final v in productVariants) {
                  if (v.id == newVariantId) {
                    newVariant = v;
                    break;
                  }
                }
                if (newVariant != null) {
                  product.variants
                    ..remove(newVariant)
                    ..insert(0, newVariant);
                }
              }
            });
          },
        ),
      ),
    );
  }
}