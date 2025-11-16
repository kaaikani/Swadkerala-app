import 'dart:async';
import 'package:marquee/marquee.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../components/collectioncomponent.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/cart/Cartcontroller.dart';
import '../controllers/order/ordercontroller.dart';
import '../controllers/collection controller/Collectionmodel.dart';
import '../controllers/collection controller/collectioncontroller.dart';
import '../controllers/order/ordermodels.dart';
import '../components/bannercomponent.dart';
import '../components/vertical_list_component.dart';
import '../components/searchbarcomponent.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../components/bottomnavigationbar.dart';
import '../widgets/responsive_spacing.dart';
import '../utils/shipping_utils.dart';
import '../utils/collection_product_card.dart';
import '../utils/price_formatter.dart';

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

  final Duration _shippingTickerInterval = const Duration(seconds: 4);
  Timer? _shippingTickerTimer;
  Worker? _shippingWorker;
  int _shippingTickerIndex = 0;

  @override
  void initState() {
    super.initState();
    _observeShippingMethods();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.getActiveOrder();
      customerController.getActiveCustomer();
      collectionController.fetchAllCollections();
      bannerController.getFrequentlyOrderedProducts();
      bannerController.getCustomerFavorites();
      orderController.getEligibleShippingMethods();
    });
  }

  void _observeShippingMethods() {
    _shippingWorker =
        ever<List<ShippingMethod>>(orderController.shippingMethods, (methods) {
      if (!mounted) return;
      if (methods.isEmpty) {
        _shippingTickerTimer?.cancel();
        setState(() => _shippingTickerIndex = 0);
        return;
      }
      setState(() {
        _shippingTickerIndex = _shippingTickerIndex % methods.length;
      });
      _startShippingTicker();
    });
  }

  void _startShippingTicker() {
    _shippingTickerTimer?.cancel();
    final methods = orderController.shippingMethods;
    if (methods.length <= 1) return;

    _shippingTickerTimer = Timer.periodic(_shippingTickerInterval, (_) {
      if (!mounted || methods.isEmpty) return;
      setState(() {
        _shippingTickerIndex = (_shippingTickerIndex + 1) % methods.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityName = box.read('channel_code') ?? 'Default City';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
          cartController.getActiveOrder(),
          customerController.getActiveCustomer(),
          collectionController.fetchAllCollections(),
          bannerController.getFrequentlyOrderedProducts(),
          bannerController.getCustomerFavorites(),
          orderController.getEligibleShippingMethods(),
          ]);
        },
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
            onTap: (index) {
              // Handle navigation if needed
              switch (index) {
                case 0:
                  // Home - already on home
                  break;
                case 1:
                  // Categories
                  Get.toNamed('/categories');
                  break;
                case 2:
                  // Cart
                  Get.toNamed('/cart');
                  break;
              }
            },
          )),
    );
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

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildShippingTicker(),
        ResponsiveSpacing.vertical(12),
        // Hero Banner Section - Clean without overlay
        _buildHeroBanner(),
        ResponsiveSpacing.vertical(24),

        // Category Selection Horizontal Scroll
        _buildCategorySelection(),

        // Reward Points Section

        // Favorites Section (prioritized over frequently ordered)
        _buildFavoritesSection(),
        ResponsiveSpacing.vertical(32),

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
        final methods = orderController.shippingMethods;
        if (methods.isEmpty) return const SizedBox.shrink();

        final tickerText = _buildShippingTickerText(methods);

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
      } catch (e, stack) {
        debugPrint('🔥 _buildShippingTicker crashed: $e');
        debugPrint('$stack');
        return const SizedBox.shrink();
      }
    });
  }

  String _buildShippingTickerText(List<ShippingMethod> methods) {
    final segments = <String>[];

    final note = ShippingUtils.buildDeliveryNote(methods);
    if (note != null) {
      segments.add(note);
    }

    return segments.join('   •   ');
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
        padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(8)),
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
                      onPressed: () {},
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
                  final variant = product.variants.isNotEmpty
                      ? product.variants.first
                      : null;

                  if (variant == null) {
                    return const SizedBox.shrink();
                  }

                  final variantId = variant.id;
                  final quantity = cartController.getVariantQuantity(variantId);
                  final priceText =
                      PriceFormatter.formatPrice(variant.priceWithTax.round());
                  final isFavorite = bannerController.isFavorite(product.id);

                  return SizedBox(
                    width: ResponsiveUtils.rp(170),
                    child: CollectionProductCard(
                      name: product.name,
                      imageUrl: product.featuredAsset?.preview,
                      onTap: () {
                        Get.toNamed('/product-detail', arguments: {
                          'productId': product.id,
                          'productName': product.name,
                        });
                      },
                      onDoubleTap: () => bannerController.toggleFavorite(
                          productId: product.id),
                      isFavorite: isFavorite,
                      onFavoriteToggle: () => bannerController.toggleFavorite(
                          productId: product.id),
                      discountPercent: null,
                      variantSelector: null,
                      showVariantSelector: false,
                      variantLabel: variant.name,
                      priceText: priceText,
                      shadowPriceText: null,
                      quantity: quantity,
                      counterBuilder: () => _buildVariantCounter(
                        variantId: variantId,
                        productName: product.name,
                      ),
                      onAddToCart: () => _addVariantToCartById(
                        variantId,
                        product.name,
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
                  final variant = product.variants.isNotEmpty
                      ? product.variants.first
                      : null;
                        final variantId = variant?.id ?? '';
                        final quantity = variantId.isNotEmpty
                            ? cartController.getVariantQuantity(variantId)
                            : 0;

                        return SizedBox(
                          width: ResponsiveUtils.rp(170),
                          child: CollectionProductCard(
                            name: product.name,
                    imageUrl: imageUrl,
                            onTap: () {
                              Get.toNamed('/product-detail', arguments: {
                                'productId': product.id,
                                'productName': product.name,
                              });
                            },
                            onDoubleTap: () => bannerController.toggleFavorite(
                                productId: product.id),
                            isFavorite: true,
                            onFavoriteToggle: () => bannerController
                                .toggleFavorite(productId: product.id),
                            discountPercent: null,
                            variantSelector: null,
                            showVariantSelector: false,
                            variantLabel: variant?.name ?? 'Default',
                            priceText: variant != null
                                ? PriceFormatter.formatPrice(
                                    variant.priceWithTax.round())
                                : 'Rs --',
                            shadowPriceText: null,
                            quantity: quantity,
                            counterBuilder: () => variantId.isEmpty
                                ? const SizedBox.shrink()
                                : _buildVariantCounter(
                                    variantId: variantId,
                    productName: product.name,
                                  ),
                            onAddToCart: () => variantId.isEmpty
                                ? Get.snackbar(
                                    'Variant unavailable',
                                    'Unable to add this item right now.',
                            snackPosition: SnackPosition.BOTTOM,
                                  )
                                : _addVariantToCartById(
                                    variantId,
                                    product.name,
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

  Widget _buildVariantCounter({
    required String variantId,
    required String productName,
  }) {
    final quantity = cartController.getVariantQuantity(variantId);
    if (quantity <= 0) {
      return SizedBox(
        height: ResponsiveUtils.rp(36),
      );
    }

    return Container(
      width: ResponsiveUtils.rp(90),
      height: ResponsiveUtils.rp(32),
      decoration: BoxDecoration(
        color: AppColors.button,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _decrementVariantById(variantId),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
              child: Icon(
                Icons.remove,
                size: ResponsiveUtils.rp(18),
                color: Colors.white,
              ),
            ),
          ),
          Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(13),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () => _addVariantToCartById(variantId, productName),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.rp(4)),
              child: Icon(
                Icons.add,
                size: ResponsiveUtils.rp(18),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
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
      Get.snackbar(
        'Added to Cart',
        '$productName added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _decrementVariantById(String variantId) async {
    await cartController.decrementVariant(variantId: variantId);
    if (mounted) setState(() {});
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
    _shippingTickerTimer?.cancel();
    _shippingWorker?.dispose();
    super.dispose();
  }
}
