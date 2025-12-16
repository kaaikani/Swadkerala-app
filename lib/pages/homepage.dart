import 'package:marquee/marquee.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../components/collectioncomponent.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/banner/bannermodels.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/collection controller/Collectionmodel.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../components/bannercomponent.dart';
import '../components/vertical_list_component.dart';
import '../components/searchbarcomponent.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/product_card.dart';
import '../utils/price_formatter.dart';
import '../utils/navigation_helper.dart';
import '../components/bottomnavigationbar.dart';
import '../services/analytics_service.dart';
import '../services/graphql_client.dart';
import '../services/remote_config_service.dart';
import '../graphql/banner.graphql.dart';
import '../controllers/theme_controller.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();
  final BannerController bannerController = Get.put(BannerController());
  final CollectionsController collectionController =
      Get.put(CollectionsController());
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final CustomerController customerController = Get.put(CustomerController());
  final UtilityController utilityController = Get.put(UtilityController());
  final ThemeController themeController = Get.find<ThemeController>();
  
  // Track selected variant for each product in favorites
  final Map<String, String> _selectedVariantIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only fetch authenticated data if user is logged in
      if (_isUserAuthenticated()) {
        cartController.getActiveOrder();
        customerController.getActiveCustomer();
        bannerController.getCustomerFavorites();
      }
      
      // These can be fetched regardless of authentication status
      collectionController.fetchAllCollections();
      bannerController.getFrequentlyOrderedProducts();
     
      
      // Track screen view
      AnalyticsService().logScreenView(screenName: 'Home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final channelCode = box.read('channel_code') ?? '';
    final cityName = _formatCityName(channelCode);

    // Observe theme changes to rebuild the entire page
    return Obx(() {
      // Force rebuild when theme changes
      final _ = themeController.isDarkMode;
      
      return Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
        onRefresh: () async {
          // Create list of futures based on authentication status
          List<Future> futures = [
            collectionController.fetchAllCollections(),
            bannerController.getFrequentlyOrderedProducts(),
          ];
          
          // Only add authenticated requests if user is logged in
          if (_isUserAuthenticated()) {
            futures.addAll([
              cartController.getActiveOrder(),
              customerController.getActiveCustomer(),
              bannerController.getCustomerFavorites(),
            ]);
          }
          
          await Future.wait(futures);
        },
        color: AppColors.refreshIndicator,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ==================== HEADER ====================
            _buildHeader(cityName),

            // ==================== MAIN CONTENT ====================
            SliverToBoxAdapter(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavComponent(
            cartCount: cartController.cartItemCount,
          )),
      );
    });
  }

  SliverToBoxAdapter _buildHeader(String cityName) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.background,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.rp(16),
              vertical: ResponsiveUtils.rp(12),
            ),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: SearchComponent(
                    hintText: 'Search for fresh cuts...',
                    onSearch: (String query) {
                      bannerController.searchProducts({'term': query});
                    },
                  ),
                ),
                SizedBox(width: ResponsiveUtils.rp(12)),
                // Location with Channel Code (only show when authenticated)
                if (_isUserAuthenticated()) ...[
                  _buildLocationInfo(cityName),
                  SizedBox(width: ResponsiveUtils.rp(12)),
                ],
                // Account Text with Icon
                InkWell(
                  onTap: () => Get.toNamed('/account'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        color: AppColors.textPrimary,
                        size: ResponsiveUtils.rp(24),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveUtils.rp(12)),
                // Cart Icon with Badge
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build location info widget with channel code
  Widget _buildLocationInfo(String cityName) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.rp(8),
        vertical: ResponsiveUtils.rp(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: ResponsiveUtils.rp(16),
          ),
          SizedBox(width: ResponsiveUtils.rp(4)),
          Text(
            cityName,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: ResponsiveUtils.rp(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildShippingTicker(),
        ResponsiveSpacing.vertical(12),
        // Hero Banner Section - Clean without overlay
        _buildHeroBanner(),
        ResponsiveSpacing.vertical(10),

        // Category Selection Horizontal Scroll
        _buildCategorySelection(),
        ResponsiveSpacing.vertical(4),

        // Reward Points Section

        // Favorites Section (prioritized over frequently ordered)
        _buildFavoritesSection(),
        ResponsiveSpacing.vertical(18),

        // Frequently Ordered Section
        _buildFrequentlyOrderedSection(),
        ResponsiveSpacing.vertical(32),

        // All Products Section
        CollectionGrid(
          onCollectionTap: (Collection collection) {
            Get.toNamed('/collection-products', arguments: {
              'collectionId': collection.id,
              'collectionName': collection.name,
              'collectionSlug': collection.slug ?? '',
              'collectionImage': collection.featuredAsset?.preview ?? '',
              'totalItems': collection.productVariants.totalItems,
            });
          },
        ),
        ResponsiveSpacing.vertical(40),
      ],
    );
  }

  Widget _buildShippingTicker() {
    return Obx(() {
      try {
        // Get Remote Config service
        final remoteConfigService = Get.find<RemoteConfigService>();
        // Access observable directly instead of calling methods
        final tickerText = remoteConfigService.shippingTickerText.value;
        
        // Only show if text is fetched from Remote Config
        if (tickerText.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.rp(8),
            horizontal: ResponsiveUtils.rp(16),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.button.withValues(alpha: 0.14),
                AppColors.button.withValues(alpha: 0.04),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            border: Border.all(
              color: AppColors.button.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: AppColors.button,
                size: ResponsiveUtils.rp(18),
              ),
              SizedBox(width: ResponsiveUtils.rp(8)),
              Expanded(
                child: SizedBox(
                  height: ResponsiveUtils.rp(20),
                  child: Marquee(
                    key: const ValueKey('shippingTicker'),
                    text: tickerText,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveUtils.sp(13),
                      fontWeight: FontWeight.w600,
                    ),
                    blankSpace: 50,
                    velocity: 25,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10,
                  ),
                ),
              ),
            ],
          ),
        );
      } catch (e) {
debugPrint('🔥 _buildShippingTicker crashed: $e');
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildHeroBanner() {
    return BannerComponent();
  }

  Widget _buildCategorySelection() {
    return Obx(() {
      final isLoading = utilityController.isLoadingRx.value;
      final hasCollections = collectionController.allCollections.isNotEmpty;

      if (!isLoading && !hasCollections) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(
          top: ResponsiveUtils.rp(2),
          bottom: ResponsiveUtils.rp(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalListComponent(
              title: '',
              onTap: (collection) {
                Get.toNamed('/collection-products', arguments: {
                  'collectionId': collection.id,
                  'collectionName': collection.name,
                });
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFrequentlyOrderedSection() {
    return Obx(() {
      // Filter out disabled products
      final enabledProducts = bannerController.frequentlyOrderedProducts
          .where((item) => item.product.enabled == true)
          .toList();
      
      if (enabledProducts.isEmpty) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: ResponsiveSpacing.screenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Frequently Ordered',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (enabledProducts.length > 3)
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/frequently-ordered');
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.button,
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.rp(260),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: ResponsiveSpacing.screenPadding,
                physics: const BouncingScrollPhysics(),
                itemCount: enabledProducts.length > 10 ? 10 : enabledProducts.length,
                separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(16),
                itemBuilder: (context, index) {
                  final item = enabledProducts[index];
                  final product = item.product;
                  final variants = product.variants;
                  
                  if (variants.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  // Get selected variant ID or default to first variant
                  final selectedVariantId = _selectedVariantIds[product.id] ?? 
                      (variants.isNotEmpty ? variants.first.id : '');
                  
                  final selectedVariant = selectedVariantId.isNotEmpty
                      ? variants.firstWhere(
                          (v) => v.id == selectedVariantId,
                          orElse: () => variants.first,
                        )
                      : variants.first;
                  
                  final priceText = PriceFormatter.formatPrice(
                      selectedVariant.priceWithTax.round());
                  final isFavorite = bannerController.isFavorite(product.id);
                  final hasMultipleVariants = variants.length > 1;
                  
                  // Get option value from variant name (like category product page)
                  final variantLabel = _getVariantLabelFromName(selectedVariant.name);

                  return SizedBox(
                    width: ResponsiveUtils.rp(170),
                    child: ProductCard(
                      name: product.name,
                      imageUrl: product.featuredAsset?.preview,
                      onTap: () {
                        NavigationHelper.navigateToProductDetail(
                          productId: product.id,
                          productName: product.name,
                        );
                      },
                      onDoubleTap: () => bannerController.toggleFavorite(
                          productId: product.id),
                      isFavorite: isFavorite,
                      onFavoriteToggle: () => bannerController.toggleFavorite(
                          productId: product.id),
                      discountPercent: null,
                      variantSelector: hasMultipleVariants
                          ? _buildFrequentlyOrderedVariantDropdown(
                              productId: product.id,
                              variants: variants,
                              currentVariantId: selectedVariantId,
                            )
                          : null,
                      showVariantSelector: hasMultipleVariants,
                      variantLabel: variantLabel,
                      priceText: priceText,
                      shadowPriceText: null,
                      onAddToCart: () {
                        if (selectedVariantId.isEmpty) {
                          Get.snackbar(
                            'Variant unavailable',
                            'Unable to add this item right now.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          _addVariantToCartById(
                            selectedVariantId,
                            product.name,
                          );
                        }
                      },
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

  Widget _buildFavoritesSection() {
    return Obx(() {
      // Filter out disabled products
      final enabledFavorites = bannerController.favoritesList
          .where((item) => item.product.enabled == true)
          .toList();
      
      if (enabledFavorites.isEmpty) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: ResponsiveSpacing.screenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: AppColors.error,
                        size: ResponsiveUtils.rp(20),
                      ),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Your Favorites',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveUtils.sp(18),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (enabledFavorites.length > 3)
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/favourite');
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.button,
                          fontSize: ResponsiveUtils.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.rp(260),
              child: utilityController.isLoadingRx.value && enabledFavorites.isEmpty
                  ? _buildFavoritesShimmerRow()
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: ResponsiveSpacing.screenPadding,
                      physics: const BouncingScrollPhysics(),
                itemCount: enabledFavorites.length > 10 ? 10 : enabledFavorites.length,
                      separatorBuilder: (_, __) =>
                          ResponsiveSpacing.horizontal(16),
                itemBuilder: (context, index) {
                  final favorite = enabledFavorites[index];
                  final product = favorite.product;
                  final imageUrl = product.featuredAsset?.preview;
                  
                  // Get selected variant or default to first variant
                  final selectedVariantId = _selectedVariantIds[product.id] ?? 
                      (product.variants.isNotEmpty ? product.variants.first.id : '');
                  
                  final selectedVariant = selectedVariantId.isNotEmpty
                      ? product.variants.firstWhere(
                          (v) => v.id == selectedVariantId,
                          orElse: () => product.variants.first,
                        )
                      : (product.variants.isNotEmpty ? product.variants.first : null);
                  
                  final hasMultipleVariants = product.variants.length > 1;

                  return SizedBox(
                    width: ResponsiveUtils.rp(170),
                    child: ProductCard(
                      name: product.name,
                      imageUrl: imageUrl,
                      onTap: () {
                        NavigationHelper.navigateToProductDetail(
                          productId: product.id,
                          productName: product.name,
                        );
                      },
                      onDoubleTap: () => bannerController.toggleFavorite(
                          productId: product.id),
                      isFavorite: true,
                      onFavoriteToggle: () => bannerController
                          .toggleFavorite(productId: product.id),
                      discountPercent: null,
                      variantSelector: hasMultipleVariants
                          ? _buildFavoritesVariantDropdown(
                              productId: product.id,
                              variants: product.variants,
                              currentVariantId: selectedVariantId,
                            )
                          : null,
                      showVariantSelector: hasMultipleVariants,
                      variantLabel: selectedVariant != null
                          ? _getVariantLabelFromName(selectedVariant.name)
                          : 'Default',
                      priceText: selectedVariant != null
                          ? PriceFormatter.formatPrice(
                              selectedVariant.priceWithTax.round())
                          : 'Rs --',
                      shadowPriceText: null,
                      onAddToCart: () {
                        if (selectedVariantId.isEmpty) {
                          Get.snackbar(
                            'Variant unavailable',
                            'Unable to add this item right now.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          _addVariantToCartById(
                            selectedVariantId,
                            product.name,
                          );
                        }
                      },
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


  /// Build variant dropdown for favorites (shows option group names and option names like category products)
  Widget _buildFavoritesVariantDropdown({
    required String productId,
    required List<FavoriteVariantModel> variants,
    required String currentVariantId,
  }) {
    // Extract unique option values from variant names (same as category product page: opt.name)
    final uniqueOptions = <String>{};
    final optionToVariantMap = <String, String>{};
    
    for (final variant in variants) {
      // Extract option name from variant name (same as category page: opt.name)
      // Category page uses: opt.name where opt.group.name == groupName
      // For favourites, extract from variant name (part after colon = option name)
      String optionValue;
      if (variant.name.contains(':')) {
        optionValue = variant.name.split(':').last.trim();
      } else {
        optionValue = variant.name;
      }
      uniqueOptions.add(optionValue);
      optionToVariantMap[optionValue] = variant.id;
    }
    
    final uniqueOptionsList = uniqueOptions.toList();
    if (uniqueOptionsList.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Get current option value for selected variant (same as category page: opt.name)
    final currentVariant = variants.firstWhere(
      (v) => v.id == currentVariantId,
      orElse: () => variants.first,
    );
    // Extract option name from variant name (same as category page: opt.name)
    // Category page uses: opt.name where opt.group.name == groupName
    String currentOptionValue;
    if (currentVariant.name.contains(':')) {
      currentOptionValue = currentVariant.name.split(':').last.trim();
    } else {
      currentOptionValue = currentVariant.name;
    }
    
    // Get option group name (like category product page)
    String groupName = 'Size'; // Default
    if (variants.isNotEmpty) {
      final firstVariantName = variants.first.name;
      if (firstVariantName.contains(':')) {
        groupName = firstVariantName.split(':').first.trim();
      } else {
        // Try common group names
        final commonGroupNames = ['Size', 'Color', 'Weight', 'Pack'];
        for (final name in commonGroupNames) {
          if (firstVariantName.toLowerCase().contains(name.toLowerCase())) {
            groupName = name;
            break;
          }
        }
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
          items: uniqueOptionsList.map((optionName) {
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
            
            // Find matching variant for the selected option (same as category product page)
            FavoriteVariantModel? matchingVariant;
            for (final variant in variants) {
              // Extract option name from variant name (same as category page: opt.name == newOptionName)
              String? optionValue;
              if (variant.name.contains(':')) {
                optionValue = variant.name.split(':').last.trim();
              } else {
                optionValue = variant.name;
              }
              
              if (optionValue == newOptionName) {
                matchingVariant = variant;
                break;
              }
            }
            
            if (matchingVariant != null) {
              setState(() {
                _selectedVariantIds[productId] = matchingVariant!.id;
              });
            }
          },
        ),
      ),
    );
  }

  /// Build variant dropdown for frequently ordered products (shows option group names and option names like category products)
  Widget _buildFrequentlyOrderedVariantDropdown({
    required String productId,
    required List<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants> variants,
    required String currentVariantId,
  }) {
    // Extract unique option values from variant names
    final uniqueOptions = <String>{};
    final optionToVariantMap = <String, String>{};
    
    for (final variant in variants) {
      final optionValue = _getVariantLabelFromName(variant.name);
      uniqueOptions.add(optionValue);
      optionToVariantMap[optionValue] = variant.id;
    }
    
    final uniqueOptionsList = uniqueOptions.toList();
    if (uniqueOptionsList.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Get current option value for selected variant
    final currentVariant = variants.firstWhere(
      (v) => v.id == currentVariantId,
      orElse: () => variants.first,
    );
    final currentOptionValue = _getVariantLabelFromName(currentVariant.name);
    
    // Get option group name (like category product page)
    String groupName = 'Size'; // Default
    if (variants.isNotEmpty) {
      final firstVariantName = variants.first.name;
      if (firstVariantName.contains(':')) {
        groupName = firstVariantName.split(':').first.trim();
      } else {
        // Try common group names
        final commonGroupNames = ['Size', 'Color', 'Weight', 'Pack'];
        for (final name in commonGroupNames) {
          if (firstVariantName.toLowerCase().contains(name.toLowerCase())) {
            groupName = name;
            break;
          }
        }
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
          items: uniqueOptionsList.map((optionName) {
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
            
            // Find matching variant for the selected option (like category product page)
            Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts$product$variants? matchingVariant;
            for (final variant in variants) {
              final optionValue = _getVariantLabelFromName(variant.name);
              if (optionValue == newOptionName) {
                matchingVariant = variant;
                break;
              }
            }
            
            if (matchingVariant != null) {
              setState(() {
                _selectedVariantIds[productId] = matchingVariant!.id;
              });
            }
          },
        ),
      ),
    );
  }

  /// Extract variant label from variant name (remove text before colon if present)
  String _getVariantLabelFromName(String variantName) {
    // If variant name contains ":", return only the part after colon
    if (variantName.contains(':')) {
      return variantName.split(':').last.trim();
    }
    return variantName;
  }

  Future<void> _addVariantToCartById(
      String variantId, String productName) async {
    final parsedVariantId = int.tryParse(variantId);
    if (parsedVariantId == null) {
      Get.snackbar(
        'Variant unavailable',
        'Unable to add $productName right now.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success =
        await cartController.addToCart(productVariantId: parsedVariantId);
    if (success && mounted) {
      setState(() {});

    }
  }


  Widget _buildFavoritesShimmerRow() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: ResponsiveSpacing.screenPadding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => ResponsiveSpacing.horizontal(16),
        itemBuilder: (context, index) {
          return Container(
            width: ResponsiveUtils.rp(170),
        decoration: BoxDecoration(
          color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
              borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
              ),
            ),
                ),
                Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(6)),
                    Container(
                        height: 14,
                        width: ResponsiveUtils.rp(80),
                      decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.rp(12)),
                      Container(
                        height: ResponsiveUtils.rp(32),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Check if user is authenticated
  bool _isUserAuthenticated() {
    final authController = Get.find<AuthController>();
    final authToken = GraphqlService.authToken;
    final channelToken = GraphqlService.channelToken;
    
    return authController.isLoggedIn && 
           authToken.isNotEmpty && 
           channelToken.isNotEmpty;
  }

  /// Format channel code to display name
  String _formatCityName(String channelCode) {
    if (channelCode.isEmpty) return 'Location';
    
    // Handle common channel code formats
    if (channelCode.contains('-')) {
      final parts = channelCode.split('-');
      if (parts.length > 1) {
        // Convert "ind-madurai" to "Madurai"
        return parts.last.split(' ').map((word) => 
          word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : ''
        ).join(' ');
      }
    }
    
    // Fallback: capitalize first letter
    return channelCode.isNotEmpty 
        ? channelCode[0].toUpperCase() + channelCode.substring(1).toLowerCase()
        : 'Location';
  }
}
