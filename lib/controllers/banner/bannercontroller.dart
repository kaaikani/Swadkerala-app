import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart'
    show Context, HttpLinkHeaders, QueryResult, gql;
import 'package:flutter/foundation.dart';
import '../../graphql/banner.graphql.dart';
import '../../graphql/cart.graphql.dart' as cart_graphql;
import '../../graphql/order.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
// import '../../utils/html_utils.dart'; // Unused import
import '../../utils/price_formatter.dart';
import '../../services/in_app_update_service.dart';
import '../../services/analytics_service.dart';
import '../../widgets/error_dialog.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';
import '../cart/Cartcontroller.dart';
import '../order/ordercontroller.dart';
import '../customer/customer_controller.dart';

class BannerController extends BaseController {
  // ============================================================================
  // DEPENDENCIES
  // ============================================================================
  final GraphqlService graphqlService = GraphqlService();
  final UtilityController utilityController = Get.find<UtilityController>();

  // ============================================================================
  // BANNER FUNCTIONALITY
  // ============================================================================
  final RxList<Query$customBanners$customBanners> bannerList = <Query$customBanners$customBanners>[].obs;

  // ============================================================================
  // SEARCH FUNCTIONALITY
  // ============================================================================
  final RxList<Query$Search$search$items> searchResults = <Query$Search$search$items>[].obs;
  final RxInt totalItems = 0.obs;


  // ============================================================================
  // FAVORITES FUNCTIONALITY
  // ============================================================================
  final RxList<Query$GetCustomerFavorites$activeCustomer$favorites$items> favoritesList = <Query$GetCustomerFavorites$activeCustomer$favorites$items>[].obs;
  final RxSet<String> favoriteProductIds = <String>{}.obs;
  final RxInt favoritesTotalItems = 0.obs;

  // ============================================================================
  // FREQUENTLY ORDERED PRODUCTS FUNCTIONALITY
  // ============================================================================
  final RxList<Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts>
      frequentlyOrderedProducts =
      <Query$GetFrequentlyOrderedProducts$frequentlyOrderedProducts>[].obs;

  // ============================================================================
  // LOYALTY POINTS FUNCTIONALITY
  // ============================================================================
  final RxInt loyaltyPointsUsed = 0.obs;
  final RxInt loyaltyPointsEarned = 0.obs;
  final RxBool loyaltyPointsApplied = false.obs;
  final Rx<Query$LoyaltyPointsConfig$loyaltyPointsConfig?> loyaltyPointsConfig =
      Rx<Query$LoyaltyPointsConfig$loyaltyPointsConfig?>(null);
  // AppUpdateModel - using InAppUpdateService directly, no model needed
  final Rx<Map<String, dynamic>?> appUpdateInfo = Rx<Map<String, dynamic>?>(null);

  // ============================================================================
  // COUPON CODE FUNCTIONALITY
  // ============================================================================
  final RxList<Query$GetCouponCodeList$getCouponCodeList$items> availableCouponCodes = <Query$GetCouponCodeList$getCouponCodeList$items>[].obs;
  final RxList<String> appliedCouponCodes = <String>[].obs;
  final RxBool couponCodesLoaded = false.obs;

  // Track products added by each coupon: Map<couponCode, Map<variantId, quantity>>
  final RxMap<String, Map<String, int>> couponAddedProducts =
      <String, Map<String, int>>{}.obs;

  // Track original cart quantities before adding coupon products
  // Map<couponCode, Map<variantId, originalQuantity>>
  final RxMap<String, Map<String, int>> originalCartQuantities =
      <String, Map<String, int>>{}.obs;

  // Flag to prevent duplicate addToCart calls when order is complete
  bool _isAddingItems = false;

  // Fetch banners
  Future<void> getBannersForChannel() async {
    try {
      utilityController.setLoadingState(false); // ✅ Set shared loading state

      String channelToken = GraphqlService.channelToken;

      if (channelToken.isEmpty) {
        utilityController.setLoadingState(false);
        return;
      }

      final headers = {'channel-token': channelToken};

      final res = await GraphqlService.client.value.query$customBanners(
        Options$Query$customBanners(
          context: Context().withEntry(HttpLinkHeaders(headers: headers)),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load banners')) {
        utilityController.setLoadingState(false);
        return;
      }

      if (res.data != null) {
        List<dynamic> jsonList = res.data!["customBanners"];
        List<Query$customBanners$customBanners> fetchedBanners =
            jsonList.map((json) => Query$customBanners$customBanners.fromJson(json as Map<String, dynamic>)).toList();

        bannerList.assignAll(fetchedBanners);
      } else {}

      utilityController.setLoadingState(false);
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to load banners');
      utilityController.setLoadingState(false);
    }
  }

  // ============================================================================
  // BANNER METHODS
  // ============================================================================

  // ============================================================================
  // SEARCH METHODS
  // ============================================================================
  Future<void> searchProducts(Map<String, dynamic> input) async {
    final term = (input['term'] ?? '').trim();

// print('🔍 [DEBUG] Starting product search...');
// print('📥 Input term: "$term"');

    // If search term is empty, clear results and return
    if (term.isEmpty) {
// print('⚠️ [DEBUG] Empty search term — clearing results.');
      searchResults.clear();
      totalItems.value = 0;
      return;
    }

    try {
      utilityController.setLoadingState(true);
// print('⏳ [DEBUG] Loading state set to true.');

      final inputObj = Input$SearchInput(term: term);
      final variables = Variables$Query$Search(input: inputObj);
// print('🧩 [DEBUG] Created GraphQL variables: $variables');

      final res = await GraphqlService.client.value.query$Search(
        Options$Query$Search(variables: variables),
      );

// print('🛰️ [DEBUG] GraphQL query executed.');

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to search products')) {
        searchResults.clear();
        totalItems.value = 0;
        utilityController.setLoadingState(false);
        return;
      }

      final items = res.data?['search']['items'] as List<dynamic>? ?? [];
      // final total = res.data?['search']['totalItems'] as int? ?? 0; // Unused variable

// print('📊 [DEBUG] Total items fetched: ${res.data?['search']['totalItems'] ?? 0}');
// print('🧾 [DEBUG] Raw items length: ${items.length}');

      final fetchedItems =
          items.map((e) => Query$Search$search$items.fromJson(e as Map<String, dynamic>)).toList();

      // Filter to show only unique products (not variants)
      // Group by productId and keep only the first variant for each product
      final Map<String, Query$Search$search$items> uniqueProducts = {};
      for (final item in fetchedItems) {
        if (!uniqueProducts.containsKey(item.productId)) {
          uniqueProducts[item.productId] = item;
        }
      }

      final uniqueProductList = uniqueProducts.values.toList();
// print('✅ [DEBUG] Unique products: ${uniqueProductList.length} (from ${fetchedItems.length} variants)');

      searchResults.assignAll(uniqueProductList);
      totalItems.value = uniqueProductList.length;

      // Track search event
      if (term.isNotEmpty) {
        AnalyticsService().logSearch(searchTerm: term);
      }

// print('✅ [DEBUG] Search results updated successfully.');
      utilityController.setLoadingState(false);
// print('🏁 [DEBUG] Loading state set to false.');
    } catch (e) {
// print('💥 [DEBUG] Exception caught during search: $e');
// print('🪜 [DEBUG] Stack trace: $stack');
      searchResults.clear();
      totalItems.value = 0;
      utilityController.setLoadingState(false);
    }
  }

  // ============================================================================
  // FAVORITES METHODS
  // ============================================================================
  /// Toggle favorite for a product
  Future<bool> toggleFavorite({required String productId}) async {
    try {
      debugPrint('[BannerController] ========== TOGGLE FAVORITE START ==========');
      debugPrint('[BannerController] Product ID: $productId');
      debugPrint('[BannerController] Current favorite status: ${favoriteProductIds.contains(productId) ? "FAVORITED" : "NOT FAVORITED"}');
      
      utilityController.setLoadingState(false);

      debugPrint('[BannerController] Executing GraphQL mutation: ToggleFavorite');
      final res = await GraphqlService.client.value.mutate$ToggleFavorite(
        Options$Mutation$ToggleFavorite(
          variables: Variables$Mutation$ToggleFavorite(
            productId: productId,
          ),
        ),
      );

      debugPrint('[BannerController] GraphQL mutation completed');
      debugPrint('[BannerController] Response has data: ${res.data != null}');
      debugPrint('[BannerController] Response has exception: ${res.hasException}');

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to update favorite')) {
        debugPrint('[BannerController] ❌ Toggle favorite failed - checkResponseForErrors returned true');
        utilityController.setLoadingState(false);
        return false;
      }

      // Check if mutation was successful
      final toggleResult = res.data?['toggleFavorite'];
      if (toggleResult != null) {
        final totalItems = toggleResult['totalItems'] as int? ?? 0;
        debugPrint('[BannerController] ✅ Toggle favorite successful');
        debugPrint('[BannerController] New total favorites: $totalItems');
      }

      // Refresh customer favorites to ensure UI is up to date
      // Don't try to convert mutation result to query result format because
      // they have different fields (mutation doesn't include 'enabled' field)
      debugPrint('[BannerController] Refreshing customer favorites list...');
      await getCustomerFavorites();
      
      debugPrint('[BannerController] ========== TOGGLE FAVORITE END ==========');
      utilityController.setLoadingState(false);
      return true;
    } catch (e) {
      debugPrint('[BannerController] ❌ Toggle favorite error: $e');
      debugPrint('[BannerController] Error type: ${e.runtimeType}');
      handleException(e, customErrorMessage: 'Failed to update favorite');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Get customer favorites
  Future<void> getCustomerFavorites() async {
    try {
      debugPrint('[BannerController] ========== GET CUSTOMER FAVORITES START ==========');
      utilityController.setLoadingState(false);

      debugPrint('[BannerController] Executing GraphQL query: GetCustomerFavorites');
      debugPrint('[BannerController] Fetch policy: noCache');
      debugPrint('[BannerController] Error policy: ignore');
      debugPrint('[BannerController] Current favorites count: ${favoritesList.length}');
      debugPrint('[BannerController] Current favorite product IDs: ${favoriteProductIds.length}');

      final res = await GraphqlService.client.value.query$GetCustomerFavorites(
        Options$Query$GetCustomerFavorites(
          fetchPolicy: graphql.FetchPolicy.noCache, // Don't use cache at all
          errorPolicy: graphql.ErrorPolicy
              .ignore, // Ignore errors and try to process data anyway
        ),
      );
      
      debugPrint('[BannerController] GraphQL query completed');
      debugPrint('[BannerController] Response has data: ${res.data != null}');
      debugPrint('[BannerController] Response has exception: ${res.hasException}');

      // Check if this is just a cache miss exception (non-fatal)
      bool isCacheMissException = false;
      bool isNetworkError = false;
      if (res.hasException) {
        final exception = res.exception;
        final exceptionString = exception?.toString() ?? '';
        final linkException = exception?.linkException;

        isCacheMissException = exceptionString.contains('CacheMissException') ||
            exceptionString.contains('cache.readQuery') ||
            exceptionString.contains('Round trip cache re-read failed');

        // Check for network/connection errors
        isNetworkError = exceptionString.contains('Connection closed before full header was received') ||
            exceptionString.contains('Connection closed') ||
            exceptionString.contains('SocketException') ||
            exceptionString.contains('ClientException') ||
            exceptionString.contains('ServerException') ||
            exceptionString.contains('NetworkException') ||
            exceptionString.contains('TimeoutException') ||
            (linkException != null && (
              linkException.toString().contains('Connection closed') ||
              linkException.toString().contains('ClientException') ||
              linkException.toString().contains('ServerException')
            ));

        if (isCacheMissException) {
          // Cache miss is expected and non-fatal - proceed to process data
debugPrint( '[BannerController] Cache miss detected (non-fatal) - proceeding with data processing');
        } else if (isNetworkError) {
          // Network error - don't logout, just log and return
debugPrint(       '[BannerController] GetCustomerFavorites Network Error: ${res.exception} - Not logging out');
          utilityController.setLoadingState(false);
          return; // Exit early, don't process data or logout
        } else {
          // For other exceptions, log but still try to process data if available
debugPrint(       '[BannerController] GetCustomerFavorites Exception: ${res.exception}');
        }
      }

      // Process data if available (even with cache miss exceptions)
      final activeCustomer = res.data?['activeCustomer'];

      if (activeCustomer != null &&
          activeCustomer['__typename'] == 'Customer') {
        final favoritesData = activeCustomer['favorites'];

        if (favoritesData != null) {
          debugPrint('[BannerController] Favorites data found in response');
          final favorites = Query$GetCustomerFavorites$activeCustomer$favorites.fromJson(favoritesData as Map<String, dynamic>);
          
          debugPrint('[BannerController] Parsed favorites - Total items: ${favorites.totalItems}');
          debugPrint('[BannerController] Favorites items count: ${favorites.items.length}');
          
          favoritesList.assignAll(favorites.items);
          favoritesTotalItems.value = favorites.totalItems;

          // Update favorite product IDs set
          favoriteProductIds.clear();
          final productIds = favorites.items.map((item) => item.product?.id ?? '').where((id) => id.isNotEmpty).toList();
          favoriteProductIds.addAll(productIds);

          debugPrint('[BannerController] ✅ Fetched ${favorites.totalItems} favorites');
          debugPrint('[BannerController] Favorite product IDs: ${productIds.length}');
          
          // Debug: Log each favorite item
          for (int i = 0; i < favorites.items.length; i++) {
            final item = favorites.items[i];
            final product = item.product;
            debugPrint('[BannerController] Favorite [$i]:');
            debugPrint('[BannerController]   - ID: ${item.id}');
            debugPrint('[BannerController]   - Product ID: ${product?.id ?? "N/A"}');
            debugPrint('[BannerController]   - Product Name: ${product?.name ?? "N/A"}');
            debugPrint('[BannerController]   - Product Enabled: ${product?.enabled ?? false}');
            debugPrint('[BannerController]   - Variants Count: ${product != null ? product.variants.length : 0}');
            if (product?.featuredAsset != null) {
              debugPrint('[BannerController]   - Featured Image: ${product?.featuredAsset?.preview ?? "N/A"}');
            }
          }
        } else {
          // No favorites data, clear the list
          debugPrint('[BannerController] No favorites data found in response');
          favoritesList.clear();
          favoritesTotalItems.value = 0;
          favoriteProductIds.clear();
          debugPrint('[BannerController] Cleared favorites list');
        }
      } else {
        // Customer not logged in or not a Customer type, clear favorites
        debugPrint('[BannerController] Active customer is null or not a Customer type');
        debugPrint('[BannerController] Active customer data: ${activeCustomer != null ? activeCustomer['__typename'] : "null"}');
        favoritesList.clear();
        favoritesTotalItems.value = 0;
        favoriteProductIds.clear();
        debugPrint('[BannerController] Cleared favorites list (customer not logged in)');
        
        // Only logout if it's NOT a network error
        // Network errors should not trigger logout as they're temporary connection issues
        if (!isNetworkError) {
          // Clear cache and logout when customer data is null (only if not a network error)
          try {
            final customerController = Get.find<CustomerController>();
            await customerController.handleCustomerDataNotFound();
          } catch (e) {
            // If CustomerController is not found, handle logout directly
            debugPrint('[BannerController] CustomerController not found, handling logout directly: $e');
            await _handleCustomerDataNotFound();
          }
        } else {
          debugPrint('[BannerController] Network error detected - skipping logout to prevent unnecessary session termination');
        }
      }

      utilityController.setLoadingState(false);
    } catch (e) {
debugPrint('[BannerController] Get favorites error: $e');
      // Clear favorites on error to prevent stale data
      favoritesList.clear();
      favoritesTotalItems.value = 0;
      favoriteProductIds.clear();
      utilityController.setLoadingState(false);
    }
  }

  /// Check if a product is in favorites
  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }

  // ============================================================================
  // FREQUENTLY ORDERED PRODUCTS METHODS
  // ============================================================================
  /// Get frequently ordered products
  Future<void> getFrequentlyOrderedProducts() async {
    try {
      debugPrint('[BannerController] ========== FETCHING FREQUENTLY ORDERED PRODUCTS ==========');
      utilityController.setLoadingState(false);

      final res =
          await GraphqlService.client.value.query$GetFrequentlyOrderedProducts(
        Options$Query$GetFrequentlyOrderedProducts(),
      );

      debugPrint('[BannerController] GraphQL response received');
      debugPrint('[BannerController] Response has exception: ${res.hasException}');
      debugPrint('[BannerController] Response has data: ${res.data != null}');
      debugPrint('[BannerController] Parsed data is null: ${res.parsedData == null}');

      if (res.hasException) {
        debugPrint('[BannerController] ⚠️ GraphQL Exception: ${res.exception}');
        if (res.exception?.linkException != null) {
          debugPrint('[BannerController] Link Exception: ${res.exception?.linkException}');
        }
        if (res.exception?.graphqlErrors != null) {
          debugPrint('[BannerController] GraphQL Errors: ${res.exception?.graphqlErrors}');
        }
      }

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load frequently ordered products')) {
        debugPrint('[BannerController] ❌ Response contains errors, returning empty list');
        utilityController.setLoadingState(false);
        return;
      }

      final products = res.parsedData?.frequentlyOrderedProducts ?? [];
      debugPrint('[BannerController] ========== FREQUENTLY ORDERED PRODUCTS FETCHED ==========');
      debugPrint('[BannerController] Total products found: ${products.length}');
      
      if (products.isNotEmpty) {
        debugPrint('[BannerController] ──── FREQUENTLY ORDERED PRODUCTS LIST ────');
        for (int i = 0; i < products.length; i++) {
          final item = products[i];
          final product = item.product;
          debugPrint('[BannerController] Product ${i + 1}:');
          debugPrint('[BannerController]   - ID: ${product.id}');
          debugPrint('[BannerController]   - Name: ${product.name}');
          debugPrint('[BannerController]   - Enabled: ${product.enabled}');
          debugPrint('[BannerController]   - Slug: ${product.slug}');
          debugPrint('[BannerController]   - Variants count: ${product.variants.length}');
          if (product.variants.isNotEmpty) {
            final firstVariant = product.variants.first;
            debugPrint('[BannerController]   - First variant ID: ${firstVariant.id}');
            debugPrint('[BannerController]   - First variant price: ${firstVariant.priceWithTax}');
            debugPrint('[BannerController]   - First variant priceWithTax: ${firstVariant.priceWithTax}');
          }
          if (product.featuredAsset != null) {
            debugPrint('[BannerController]   - Featured image: ${product.featuredAsset?.preview ?? "null"}');
          }
        }
        debugPrint('[BannerController] ──────────────────────────────────────────────');
      } else {
        debugPrint('[BannerController] ⚠️ No frequently ordered products found');
      }
      
      frequentlyOrderedProducts.assignAll(products);
      debugPrint('[BannerController] Frequently ordered products list updated: ${frequentlyOrderedProducts.length} items');
      debugPrint('[BannerController] ========== FETCH COMPLETED ==========');
      utilityController.setLoadingState(false);
    } catch (e, stackTrace) {
      debugPrint('[BannerController] ========== ERROR FETCHING FREQUENTLY ORDERED PRODUCTS ==========');
      debugPrint('[BannerController] ❌ Exception: $e');
      debugPrint('[BannerController] Stack trace: $stackTrace');
      handleException(e,
          customErrorMessage: 'Failed to load frequently ordered products');
      utilityController.setLoadingState(false);
    }
  }

  // ============================================================================
  // LOYALTY POINTS METHODS
  // ============================================================================

  /// Apply loyalty points to active order
  Future<bool> applyLoyaltyPoints(int amount) async {
    try {
      utilityController.setLoadingState(true);

      final res = await GraphqlService.client.value.mutate$ApplyLoyaltyPoints(
        Options$Mutation$ApplyLoyaltyPoints(
          variables: Variables$Mutation$ApplyLoyaltyPoints(amount: amount),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to apply loyalty points')) {
        utilityController.setLoadingState(false);
        return false;
      }

      final result = res.parsedData?.applyLoyaltyPointsToActiveOrder;

      if (result != null) {
        loyaltyPointsUsed.value = result.customFields?.loyaltyPointsUsed ?? 0;
        loyaltyPointsEarned.value =
            result.customFields?.loyaltyPointsEarned ?? 0;
        loyaltyPointsApplied.value = true;

        // Refresh cart and customer controllers to get updated totals and loyalty points
        // Note: applyLoyaltyPointsToActiveOrder returns Order but we refresh to ensure consistency
        // and get updated customer loyalty points available
        // CartController.getActiveOrder() also updates OrderController, so we only need one call
        try {
          final cartController = Get.find<CartController>();
          final customerController = Get.find<CustomerController>();
          
          // Refresh cart (which also updates order) and customer in parallel - these are the only calls needed
          await Future.wait([
            cartController.getActiveOrder(), // This also updates OrderController
            customerController.getActiveCustomer(skipPostalCodeCheck: true), // Get updated loyalty points, skip postal code check to prevent channel fetch
          ], eagerError: false);
          
          debugPrint('[BannerController] ✅ Cart, order, and customer controllers refreshed after applying loyalty points');
        } catch (e) {
          debugPrint('[BannerController] Could not refresh controllers after applying loyalty points: $e');
        }

debugPrint(  '[BannerController] Loyalty points applied successfully: ${loyaltyPointsUsed.value}');
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
debugPrint('[BannerController] Apply loyalty points error: $e');
      handleException(e, customErrorMessage: 'Failed to apply loyalty points');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Remove loyalty points from active order
  Future<bool> removeLoyaltyPoints() async {
    try {
      utilityController.setLoadingState(true);

      final res = await GraphqlService.client.value
          .mutate$RemoveLoyaltyPointsFromActiveOrder(
        Options$Mutation$RemoveLoyaltyPointsFromActiveOrder(),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to remove loyalty points')) {
        utilityController.setLoadingState(false);
        return false;
      }

      final result = res.parsedData?.removeLoyaltyPointsFromActiveOrder;

      if (result != null) {
        loyaltyPointsUsed.value = 0;
        loyaltyPointsApplied.value = false;

        // Refresh cart and customer controllers to get updated totals and loyalty points
        // Note: removeLoyaltyPointsFromActiveOrder only returns id, not full Order
        // So we need to refresh to get the updated cart state and customer loyalty points
        // CartController.getActiveOrder() also updates OrderController, so we only need one call
        try {
          final cartController = Get.find<CartController>();
          final customerController = Get.find<CustomerController>();
          
          // Refresh cart (which also updates order) and customer in parallel - these are the only calls needed
          await Future.wait([
            cartController.getActiveOrder(), // This also updates OrderController
            customerController.getActiveCustomer(skipPostalCodeCheck: true), // Get updated loyalty points, skip postal code check to prevent channel fetch
          ], eagerError: false);
          
          debugPrint('[BannerController] ✅ Cart, order, and customer controllers refreshed after removing loyalty points');
        } catch (e) {
          debugPrint('[BannerController] Could not refresh controllers after removing loyalty points: $e');
        }

debugPrint('[BannerController] Loyalty points removed successfully');
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
debugPrint('[BannerController] Remove loyalty points error: $e');
      handleException(e, customErrorMessage: 'Failed to remove loyalty points');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Reset loyalty points state
  void resetLoyaltyPoints() {
    loyaltyPointsUsed.value = 0;
    loyaltyPointsEarned.value = 0;
    loyaltyPointsApplied.value = false;
  }

  /// Fetch loyalty points configuration
  Future<void> fetchLoyaltyPointsConfig() async {
    try {
      utilityController.setLoadingState(true);
debugPrint('[BannerController] Fetching loyalty points configuration...');

      final res = await GraphqlService.client.value.query$LoyaltyPointsConfig(
        Options$Query$LoyaltyPointsConfig(),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load loyalty points configuration')) {
        utilityController.setLoadingState(false);
        return;
      }

      final configData = res.data?['loyaltyPointsConfig'];
      if (configData != null) {
        loyaltyPointsConfig.value =
            Query$LoyaltyPointsConfig$loyaltyPointsConfig.fromJson(configData as Map<String, dynamic>);
debugPrint(  '[BannerController] Loyalty points config loaded successfully');
debugPrint(  '[BannerController] Rupees per point: ${loyaltyPointsConfig.value?.rupeesPerPoint}');
debugPrint(  '[BannerController] Points per rupee: ${loyaltyPointsConfig.value?.pointsPerRupee}');
      } else {
debugPrint('[BannerController] No loyalty points configuration found');
      }

      utilityController.setLoadingState(false);
    } catch (e) {
debugPrint('[BannerController] Fetch loyalty points config error: $e');
      handleException(e,
          customErrorMessage: 'Failed to load loyalty points configuration');
      utilityController.setLoadingState(false);
    }
  }

  // ============================================================================
  // COUPON CODE METHODS
  // ============================================================================

  // Static mapping of coupon codes to their associated products
  // This should be maintained based on your business logic
  // You can add more coupon codes and their associated products here
  /// Get products for a specific coupon code from the actual coupon data
  List<Map<String, dynamic>> getCouponProducts(String couponCode) {
    try {
debugPrint('[BannerController] ===== getCouponProducts for: $couponCode =====');
      // Find the coupon in the available list
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toUpperCase() == couponCode.toUpperCase(),
        );
      } catch (e) {
        debugPrint('[BannerController] ❌ Coupon not found: $couponCode');
        debugPrint('[BannerController] Available coupons: ${availableCouponCodes.map((c) => c.couponCode ?? 'N/A').toList()}');
        return [];
      }

      // Coupon found, continue processing

debugPrint('[BannerController] ✅ Found coupon: ${coupon.name} (${coupon.couponCode ?? 'N/A'})');
debugPrint('[BannerController] Actions count: ${coupon.actions.length}');
debugPrint('[BannerController] Conditions count: ${coupon.conditions.length}');

      // Extract products from coupon actions and conditions
      final products = <Map<String, dynamic>>[];

      // Check actions for product information (actions are what the coupon DOES)
      for (final action in coupon.actions) {
debugPrint('[BannerController] 🔍 Checking action: code=${action.code}, args=${action.args.length}');
        if (action.code == 'add_products' ||
            action.code == 'contains_products' ||
            action.code == 'free_shipping') {
          for (final arg in action.args) {
            if (arg.name == 'productVariantIds' && arg.value is List) {
              final variantIds = arg.value as List<dynamic>;
debugPrint(  '[BannerController] Found product variant IDs in action: $variantIds');

              for (final variantId in variantIds) {
                products.add({
                  'id': variantId.toString(),
                  'name': 'Product from ${coupon.name}',
                  'productVariantId': variantId.toString(),
                  'price': 0.0,
                  'priceWithTax': 0.0,
                  'quantity': 1,
                  'description': 'Product from coupon: ${coupon.name}',
                });
              }
            }
          }
        }
      }

      // Check conditions for product information
      for (final condition in coupon.conditions) {
debugPrint('[BannerController] Condition code: ${condition.code}');
debugPrint(  '[BannerController] Condition args count: ${condition.args.length}');

        if (condition.code == 'contains_products') {
debugPrint(  '[BannerController] Processing contains_products condition');
          for (final arg in condition.args) {
debugPrint(  '[BannerController] Condition arg: ${arg.name} = ${arg.value} (type: ${arg.value.runtimeType})');

            // Check for different possible argument names
            if (arg.name == 'productVariantIds') {
              List<dynamic> variantIds = [];

              if (arg.value is List) {
                variantIds = arg.value as List<dynamic>;
debugPrint(  '[BannerController] Found product variant IDs as List: $variantIds');
              } else {
                final stringValue = arg.value;
debugPrint(  '[BannerController] Found product variant IDs as String: $stringValue');

                // Try to parse string representation of list like "[542]" or "542,543"
                if (stringValue.startsWith('[') && stringValue.endsWith(']')) {
                  // Remove brackets and split by comma
                  final cleanString =
                      stringValue.substring(1, stringValue.length - 1);
                  variantIds =
                      cleanString.split(',').map((e) => e.trim()).toList();
debugPrint(  '[BannerController] Parsed variant IDs from brackets: $variantIds');
                } else if (stringValue.contains(',')) {
                  // Split by comma
                  variantIds =
                      stringValue.split(',').map((e) => e.trim()).toList();
debugPrint(  '[BannerController] Parsed variant IDs from comma-separated: $variantIds');
                } else {
                  // Single value
                  variantIds = [stringValue.trim()];
debugPrint(  '[BannerController] Parsed single variant ID: $variantIds');
                }
              }

              if (variantIds.isNotEmpty) {
debugPrint(  '[BannerController] Processing ${variantIds.length} variant IDs');
                for (final variantId in variantIds) {
                  products.add({
                    'id': variantId.toString(),
                    'name': 'Product from ${coupon.name}',
                    'productVariantId': variantId.toString(),
                    'price': 0.0,
                    'priceWithTax': 0.0,
                    'quantity': 1,
                    'description': 'Product from coupon: ${coupon.name}',
                  });
                }
              }
            } else if (arg.name == 'productIds' && arg.value is List) {
              final productIds = arg.value as List<dynamic>;
debugPrint(  '[BannerController] Found product IDs in condition: $productIds');

              for (final productId in productIds) {
                products.add({
                  'id': productId.toString(),
                  'name': 'Product from ${coupon.name}',
                  'productVariantId': productId.toString(),
                  'price': 0.0,
                  'priceWithTax': 0.0,
                  'quantity': 1,
                  'description': 'Product from coupon: ${coupon.name}',
                });
              }
            } else if (arg.name == 'products' && arg.value is List) {
              final productsList = arg.value as List<dynamic>;
debugPrint(  '[BannerController] Found products list in condition: $productsList');

              for (final product in productsList) {
                if (product is Map<String, dynamic>) {
                  products.add({
                    'id': product['id']?.toString() ?? 'unknown',
                    'name': product['name']?.toString() ??
                        'Product from ${coupon.name}',
                    'productVariantId': product['variantId']?.toString() ??
                        product['id']?.toString() ??
                        'unknown',
                    'price': (product['price'] as num?)?.toDouble() ?? 0.0,
                    'priceWithTax':
                        (product['priceWithTax'] as num?)?.toDouble() ?? 0.0,
                    'quantity': (product['quantity'] as num?)?.toInt() ?? 1,
                    'description': 'Product from coupon: ${coupon.name}',
                  });
                }
              }
            }
          }
        }
      }

debugPrint(  '[BannerController] ===== getCouponProducts result =====');
debugPrint('[BannerController] Extracted ${products.length} products for coupon: $couponCode');
      if (products.isNotEmpty) {
        for (int i = 0; i < products.length; i++) {
debugPrint('[BannerController] Product $i: ${products[i]}');
        }
      } else {
debugPrint('[BannerController] ⚠️ No products found for coupon: $couponCode');
debugPrint('[BannerController] This coupon may not have products to add, or products are in a different format');
      }
      return products;
    } catch (e) {
debugPrint('[BannerController] Error getting coupon products: $e');
      return [];
    }
  }

  /// Check if a coupon has associated products
  bool hasCouponProducts(String couponCode) {
    final products = getCouponProducts(couponCode);
debugPrint('[BannerController] hasCouponProducts($couponCode): ${products.length} products found');
    if (products.isNotEmpty) {
debugPrint('[BannerController] Product IDs: ${products.map((p) => p['productVariantId']).toList()}');
    }
    return products.isNotEmpty;
  }

  /// Check if a product variant is from a coupon-added product
  /// Returns the coupon code if it's a coupon product with quantity > 0, null otherwise
  String? isCouponAddedProduct(String variantId) {
    for (final entry in couponAddedProducts.entries) {
      final couponCode = entry.key;
      final products = entry.value;
      // Only return coupon code if the variant exists AND has quantity > 0
      final quantity = products[variantId];
      if (quantity != null && quantity > 0) {
        debugPrint('[BannerController] Variant $variantId is from coupon: $couponCode (qty: $quantity)');
        return couponCode;
      }
    }
    return null;
  }

  /// Get the coupon-added quantity for a variant
  /// Returns the quantity that was added by coupon, or 0 if not added by coupon
  int getCouponAddedQuantity(String variantId, String? couponCode) {
    if (couponCode == null) return 0;
    return couponAddedProducts[couponCode]?[variantId] ?? 0;
  }

  /// Get the original quantity (before coupon was applied) for a variant
  /// Returns the original quantity, or 0 if not found
  int getOriginalQuantity(String variantId, String? couponCode) {
    if (couponCode == null) return 0;
    return originalCartQuantities[couponCode]?[variantId] ?? 0;
  }

  /// Get available coupon codes
  Future<void> getCouponCodeList() async {
    try {
debugPrint('[BannerController] ===== STARTING COUPON CODE LOADING =====');
debugPrint('[BannerController] Setting loading state to true');
      utilityController.setLoadingState(false);

debugPrint('[BannerController] GraphQL client status: Available');
debugPrint(  '[BannerController] GraphQL client value: ${GraphqlService.client.value}');
debugPrint('[BannerController] Making GraphQL query: GetCouponCodeList');

      // Check if we have authentication token
      final authToken = GraphqlService.authToken;
      final channelToken = GraphqlService.channelToken;
debugPrint(  '[BannerController] Auth token available: ${authToken.isNotEmpty}');
debugPrint(  '[BannerController] Channel token available: ${channelToken.isNotEmpty}');
      if (authToken.isNotEmpty) {
debugPrint('[BannerController] Auth token length: ${authToken.length}');
      } else {
debugPrint(  '[BannerController] ⚠️ No auth token available - this might cause GraphQL query to fail');
      }
      if (channelToken.isNotEmpty) {
debugPrint(  '[BannerController] Channel token length: ${channelToken.length}');
      } else {
debugPrint(  '[BannerController] ⚠️ No channel token available - this might cause GraphQL query to fail');
      }

debugPrint('[BannerController] Executing GraphQL query...');

      // Try the query with retry logic
      QueryResult<Query$GetCouponCodeList>? res;
      int retryCount = 0;
      const maxRetries = 3;

      while (retryCount < maxRetries) {
        try {
debugPrint(  '[BannerController] Attempt ${retryCount + 1} of $maxRetries');

          res = await Future.any([
            GraphqlService.client.value.query$GetCouponCodeList(
              Options$Query$GetCouponCodeList(),
            ),
            Future.delayed(Duration(seconds: 15)).then((_) =>
                throw TimeoutException(
                    'Query timeout after 15 seconds', Duration(seconds: 15))),
          ]);

debugPrint(  '[BannerController] Query completed successfully on attempt ${retryCount + 1}');
          break; // Success, exit retry loop
        } catch (e) {
          retryCount++;

          if (retryCount >= maxRetries) {
debugPrint('[BannerController] All $maxRetries attempts failed');
            rethrow;
          }

          // Wait before retrying
debugPrint('[BannerController] Waiting 2 seconds before retry...');
          await Future.delayed(Duration(seconds: 2));
        }
      }

      if (res == null) {
        throw Exception(
            'Failed to get coupon codes after $maxRetries attempts');
      }
debugPrint('[BannerController] GraphQL query completed');

debugPrint('[BannerController] Has exception: ${res.hasException}');
debugPrint('[BannerController] Has data: ${res.data != null}');
debugPrint('[BannerController] Parsed data: ${res.parsedData != null}');

      if (res.hasException) {
debugPrint('[BannerController] Exception details: ${res.exception}');
debugPrint(  '[BannerController] Exception graphqlErrors: ${res.exception?.graphqlErrors}');
debugPrint(  '[BannerController] Exception linkException: ${res.exception?.linkException}');
      }

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load coupon codes')) {
        utilityController.setLoadingState(false);
        return;
      }

debugPrint('[BannerController] ✅ No GraphQL exceptions');

      if (res.data != null) {
debugPrint(  '[BannerController] Raw response data keys: ${res.data!.keys.toList()}');
debugPrint('[BannerController] Full response data: ${res.data}');
      } else {
debugPrint('[BannerController] ❌ Response data is NULL');
      }

      final couponData = res.parsedData?.getCouponCodeList;
debugPrint(  '[BannerController] Parsed coupon data: ${couponData != null ? 'Available' : 'NULL'}');

      if (couponData != null) {
        final items = couponData.items;
debugPrint('[BannerController] Coupon items count: ${items.length}');
debugPrint(  '[BannerController] Coupon items type: ${items.runtimeType}');

        if (items.isNotEmpty) {
debugPrint('[BannerController] First coupon raw data:');
debugPrint('[BannerController] ${items.first.toJson()}');

          // Check if items are properly structured
debugPrint(  '[BannerController] First item type: ${items.first.runtimeType}');
debugPrint(  '[BannerController] First item properties: ${items.first.toString()}');
        } else {
debugPrint('[BannerController] ❌ No coupon items found in response');
        }

        try {
          final fetchedCoupons = items.map((item) {
debugPrint(  '[BannerController] Converting item to CouponCodeModel: ${item.runtimeType}');
            final json = item.toJson();
debugPrint('[BannerController] Item JSON: $json');
            return Query$GetCouponCodeList$getCouponCodeList$items.fromJson(json);
          }).toList();

debugPrint(  '[BannerController] ✅ Successfully converted ${fetchedCoupons.length} coupons');

          availableCouponCodes.assignAll(fetchedCoupons);
          couponCodesLoaded.value = true;

debugPrint(  '[BannerController] ✅ Updated availableCouponCodes list with ${availableCouponCodes.length} items');
debugPrint('[BannerController] ✅ Set couponCodesLoaded to true');

          // Debug print each coupon details
          for (int i = 0; i < fetchedCoupons.length; i++) {
            final coupon = fetchedCoupons[i];
debugPrint(  '[BannerController] Coupon $i: ${coupon.name} (Code: ${coupon.couponCode ?? 'N/A'})');
debugPrint('[BannerController] - ID: ${coupon.id}');
debugPrint('[BannerController] - Enabled: ${coupon.enabled}');
            // final sanitizedDescription = HtmlUtils.stripHtmlTags(coupon.description); // Unused variable
debugPrint('[BannerController] - Starts At: ${coupon.startsAt?.toString() ?? 'N/A'}');
debugPrint('[BannerController] - Ends At: ${coupon.endsAt?.toString() ?? 'N/A'}');
debugPrint(  '[BannerController] - Actions count: ${coupon.actions.length}');
debugPrint(  '[BannerController] - Conditions count: ${coupon.conditions.length}');

            // Products are extracted from coupon actions/conditions, not directly from coupon
            // This debug section removed as products field doesn't exist in generated type
          }
        } catch (conversionError) {
debugPrint(  '[BannerController] ❌ Error converting items to Query\$GetCouponCodeList\$getCouponCodeList\$items: $conversionError');
debugPrint('[BannerController] Stack trace: ${StackTrace.current}');
        }
      } else {
debugPrint('[BannerController] ❌ Parsed coupon data is NULL');
debugPrint(  '[BannerController] Available coupon codes count: ${availableCouponCodes.length}');
debugPrint(  '[BannerController] Coupon codes loaded: ${couponCodesLoaded.value}');
      }

debugPrint('[BannerController] Setting loading state to false');
      utilityController.setLoadingState(false);
debugPrint(  '[BannerController] ===== COUPON CODE LOADING COMPLETED =====');
    } catch (e) {
debugPrint('[BannerController] ❌ Get coupon codes error: $e');
debugPrint('[BannerController] Error type: ${e.runtimeType}');
debugPrint('[BannerController] Stack trace: ${StackTrace.current}');
      utilityController.setLoadingState(false);
    }
  }

  /// Validate coupon code before applying
  Future<Map<String, dynamic>> validateCouponCode(String couponCode) async {
    try {
      debugPrint('[BannerController] 🔍 Validating coupon code: $couponCode');
      debugPrint('[BannerController] Available coupons count: ${availableCouponCodes.length}');
      
      // First check if coupon code exists in available list
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
        debugPrint('[BannerController] ❌ Validation Error: Coupon code not found');
        debugPrint('[BannerController] ❌ Error type: COUPON_NOT_FOUND');
        debugPrint('[BannerController] ❌ Available coupon codes: ${availableCouponCodes.map((c) => c.couponCode ?? 'N/A').toList()}');
        return {
          'valid': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }


      debugPrint('[BannerController] ✅ Coupon found: ${coupon.name} (${coupon.couponCode ?? 'N/A'})');
      debugPrint('[BannerController] Coupon enabled: ${coupon.enabled}');
      debugPrint('[BannerController] Coupon starts at: ${coupon.startsAt?.toString() ?? 'N/A'}');
      debugPrint('[BannerController] Coupon ends at: ${coupon.endsAt?.toString() ?? 'N/A'}');

      // Check if coupon is enabled
      if (!coupon.enabled) {
        debugPrint('[BannerController] ❌ Validation Error: Coupon code is disabled');
        debugPrint('[BannerController] ❌ Error type: COUPON_DISABLED');
        return {
          'valid': false,
          'message': 'Coupon code is disabled',
          'error': 'COUPON_DISABLED'
        };
      }

      // Check if coupon has expired
      if (coupon.endsAt != null) {
        final endDate = coupon.endsAt!;
        if (DateTime.now().isAfter(endDate)) {
          debugPrint('[BannerController] ❌ Validation Error: Coupon code has expired');
          debugPrint('[BannerController] ❌ Error type: COUPON_EXPIRED');
          debugPrint('[BannerController] ❌ End date: $endDate, Current date: ${DateTime.now()}');
          return {
            'valid': false,
            'message': 'Coupon code has expired',
            'error': 'COUPON_EXPIRED'
          };
        }
      }

      // Check if coupon has started
      if (coupon.startsAt != null) {
        final startDate = coupon.startsAt!;
        if (DateTime.now().isBefore(startDate)) {
          debugPrint('[BannerController] ❌ Validation Error: Coupon code is not yet active');
          debugPrint('[BannerController] ❌ Error type: COUPON_NOT_ACTIVE');
          debugPrint('[BannerController] ❌ Start date: $startDate, Current date: ${DateTime.now()}');
          return {
            'valid': false,
            'message': 'Coupon code is not yet active',
            'error': 'COUPON_NOT_ACTIVE'
          };
        }
      }

      // Check if already applied
      if (appliedCouponCodes.contains(couponCode)) {
        debugPrint('[BannerController] ❌ Validation Error: Coupon code already applied');
        debugPrint('[BannerController] ❌ Error type: COUPON_ALREADY_APPLIED');
        debugPrint('[BannerController] ❌ Applied coupons: ${appliedCouponCodes.toList()}');
        return {
          'valid': false,
          'message': 'Coupon code already applied',
          'error': 'COUPON_ALREADY_APPLIED'
        };
      }

      // Check if another coupon is already applied (one coupon per order policy)
      if (appliedCouponCodes.isNotEmpty) {
        debugPrint('[BannerController] ❌ Validation Error: Another coupon already applied');
        debugPrint('[BannerController] ❌ Error type: ANOTHER_COUPON_APPLIED');
        debugPrint('[BannerController] ❌ Applied coupons: ${appliedCouponCodes.toList()}');
        return {
          'valid': false,
          'message':
              'Only one coupon code can be applied per order. Please remove the current coupon first.',
          'error': 'ANOTHER_COUPON_APPLIED',
          'appliedCoupons': appliedCouponCodes.toList()
        };
      }

      // Check minimum order amount conditions
      debugPrint('[BannerController] 🔍 Checking minimum order amount...');
      final minimumAmountValidation = await _validateMinimumOrderAmount(coupon);
      if (!minimumAmountValidation['valid']) {
        debugPrint('[BannerController] ❌ Validation Error: Minimum order amount not met');
        debugPrint('[BannerController] ❌ Error type: MINIMUM_ORDER_AMOUNT_NOT_MET');
        debugPrint('[BannerController] ❌ Required amount: ${minimumAmountValidation['requiredAmount']}');
        debugPrint('[BannerController] ❌ Current amount: ${minimumAmountValidation['currentAmount']}');
        debugPrint('[BannerController] ❌ Error message: ${minimumAmountValidation['message']}');
        return {
          'valid': false,
          'message': minimumAmountValidation['message'],
          'error': 'MINIMUM_ORDER_AMOUNT_NOT_MET',
          'requiredAmount': minimumAmountValidation['requiredAmount'],
          'currentAmount': minimumAmountValidation['currentAmount']
        };
      }

      debugPrint('[BannerController] ✅ Coupon validation passed: $couponCode');
      return {
        'valid': true,
        'message': 'Coupon code is valid',
        'coupon': coupon
      };
    } catch (e) {
      debugPrint('[BannerController] ❌ Exception validating coupon code: $couponCode');
      debugPrint('[BannerController] ❌ Error: $e');
      debugPrint('[BannerController] ❌ Error type: ${e.runtimeType}');
      debugPrint('[BannerController] ❌ Stack trace: ${StackTrace.current}');
      return {
        'valid': false,
        'message': 'Error validating coupon code',
        'error': 'VALIDATION_ERROR'
      };
    }
  }

  /// Validate minimum order amount for coupon
  Future<Map<String, dynamic>> _validateMinimumOrderAmount(
      Query$GetCouponCodeList$getCouponCodeList$items coupon) async {
    try {
      debugPrint(  '[BannerController] Validating minimum order amount for coupon: ${coupon.couponCode ?? 'N/A'}');

      // Get current cart total from active order
      final orderController = Get.find<OrderController>();
      
      // Try to get from already-loaded order first
      double? cartTotal = orderController.currentOrder.value?.totalWithTax;
      
      // If not available, load active order
      if (cartTotal == null) {
        final loaded = await orderController.getActiveOrder(skipLoading: true);
        if (loaded) {
          cartTotal = orderController.currentOrder.value?.totalWithTax;
        }
      }

      if (cartTotal == null) {
        return {
          'valid': false,
          'message': 'Unable to get cart total',
          'error': 'CART_TOTAL_ERROR'
        };
      }

debugPrint('[BannerController] Current cart total: $cartTotal');

      // Check coupon conditions for minimum order amount
      for (final condition in coupon.conditions) {
debugPrint('[BannerController] Checking condition: ${condition.code}');

        if (condition.code == 'minimum_order_amount') {
          for (final arg in condition.args) {
debugPrint(  '[BannerController] Condition arg: ${arg.name} = ${arg.value}');

            if (arg.name == 'amount') {
              // arg.value is always String, so parse it directly
              final requiredAmount = double.tryParse(arg.value) ?? 0.0;
debugPrint(  '[BannerController] Required minimum amount: $requiredAmount');

              if (cartTotal < requiredAmount) {
                return {
                  'valid': false,
                  'message':
                      'Minimum order amount of ${_formatPrice(requiredAmount.toInt())} required. Current cart total is ${_formatPrice(cartTotal.toInt())}.',
                  'error': 'MINIMUM_ORDER_AMOUNT_NOT_MET',
                  'requiredAmount': requiredAmount,
                  'currentAmount': cartTotal
                };
              }
            }
          }
        }
      }

debugPrint('[BannerController] Minimum order amount validation passed');
      return {'valid': true, 'message': 'Minimum order amount requirement met'};
    } catch (e) {
debugPrint(  '[BannerController] Error validating minimum order amount: $e');
      return {
        'valid': false,
        'message': 'Error validating minimum order amount',
        'error': 'VALIDATION_ERROR'
      };
    }
  }

  /// Get current cart total from active order
  /// Uses orderController to get total from already-loaded active order
  /// If not available, calls getActiveOrder to load it

  /// Format price for display
  String _formatPrice(int priceInCents) {
    return PriceFormatter.formatPrice(priceInCents);
  }

  /// Get minimum order amount from coupon conditions
  int? _getCouponMinimumAmount(Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    try {
      for (final condition in coupon.conditions) {
        if (condition.code == 'minimum_order_amount') {
          for (final arg in condition.args) {
            if (arg.name == 'amount') {
              final value = arg.value; // value is always String in generated type
              return int.tryParse(value);
            }
          }
        }
      }
    } catch (e) {
      // Error getting coupon minimum amount
    }
    return null;
  }

  /// Get eligible coupons that are close to being applicable
  /// Returns coupons where (requiredAmount - subTotal) > 0 && < 40000
  List<Query$GetCouponCodeList$getCouponCodeList$items> getEligibleCoupons(int subTotalInPaise) {
    final eligibleCoupons = <Query$GetCouponCodeList$getCouponCodeList$items>[];
    
    for (final coupon in availableCouponCodes) {
      if (!coupon.enabled) continue;
      
      final requiredAmount = _getCouponMinimumAmount(coupon);
      if (requiredAmount == null) continue;
      
      final difference = requiredAmount - subTotalInPaise;
      
      // If difference is between 1-40000 (₹0.01 to ₹400), coupon is close to eligible
      if (difference > 0 && difference < 40000) {
        eligibleCoupons.add(coupon);
      }
    }
    
    return eligibleCoupons;
  }

  /// Get required amount for a coupon in paise
  int getRequiredAmount(Query$GetCouponCodeList$getCouponCodeList$items coupon) {
    final minimumAmount = _getCouponMinimumAmount(coupon);
    return minimumAmount ?? 0;
  }

  /// Apply coupon code to active order with proper validation
  /// This method checks minimum order amount FIRST, then applies coupon
  Future<Map<String, dynamic>> applyCouponCode(String couponCode) async {
    try {
      utilityController.setLoadingState(true);

      // Step 1: Find the coupon
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
        debugPrint('[BannerController] ❌ Coupon not found: $couponCode');
        utilityController.setLoadingState(false);
        ErrorDialog.showWarning(message: 'Coupon code not found');
        _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }

      // Step 2: Check minimum order amount FIRST (before other validations)
      debugPrint('[BannerController] 🔍 Step 1: Checking minimum order amount FIRST...');
      final minimumAmountValidation = await _validateMinimumOrderAmount(coupon);
      
      if (!minimumAmountValidation['valid']) {
        debugPrint('[BannerController] ❌ Minimum order amount not met');
        debugPrint('[BannerController] Required: ${minimumAmountValidation['requiredAmount']}, Current: ${minimumAmountValidation['currentAmount']}');
        utilityController.setLoadingState(false);
        ErrorDialog.showWarning(
          message: minimumAmountValidation['message'] as String,
        );
        _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': minimumAmountValidation['message'],
          'error': 'MINIMUM_ORDER_AMOUNT_NOT_MET',
          'requiredAmount': minimumAmountValidation['requiredAmount'],
          'currentAmount': minimumAmountValidation['currentAmount']
        };
      }
      debugPrint('[BannerController] ✅ Minimum order amount requirement met');

      // Step 3: Now apply the coupon (minimum is already validated)
      return await _applyCouponCodeWithoutMinimumCheck(couponCode);
    } catch (e) {
      debugPrint('[BannerController] ❌ Exception applying coupon code: $couponCode');
      debugPrint('[BannerController] ❌ Error: $e');
      utilityController.setLoadingState(false);
      handleException(e, customErrorMessage: 'Failed to apply coupon code');
      _refreshCartAfterCouponError();
      return {
        'success': false,
        'message': 'Error applying coupon code',
        'error': 'EXCEPTION'
      };
    }
  }

  /// Internal method to apply coupon code without minimum validation check
  /// (used when minimum has already been validated in applyCouponCodeWithProducts)
  Future<Map<String, dynamic>> _applyCouponCodeWithoutMinimumCheck(String couponCode) async {
    try {
      utilityController.setLoadingState(true);

      // Validate other coupon conditions (enabled, expired, etc.) - but skip minimum check
      debugPrint('[BannerController] 🔍 Validating coupon conditions (excluding minimum)...');
      
      // Find the coupon
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
        debugPrint('[BannerController] ❌ Coupon not found: $couponCode');
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }

      // Check other validations except minimum
      if (!coupon.enabled) {
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': 'Coupon code is disabled',
          'error': 'COUPON_DISABLED'
        };
      }

      if (coupon.endsAt != null && DateTime.now().isAfter(coupon.endsAt!)) {
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': 'Coupon code has expired',
          'error': 'COUPON_EXPIRED'
        };
      }

      if (coupon.startsAt != null && DateTime.now().isBefore(coupon.startsAt!)) {
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': 'Coupon code is not yet active',
          'error': 'COUPON_NOT_ACTIVE'
        };
      }

      if (appliedCouponCodes.contains(couponCode)) {
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': 'Coupon code already applied',
          'error': 'COUPON_ALREADY_APPLIED'
        };
      }

      if (appliedCouponCodes.isNotEmpty) {
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': 'Only one coupon code can be applied per order. Please remove the current coupon first.',
          'error': 'ANOTHER_COUPON_APPLIED'
        };
      }

      // All validations passed (except minimum which was already checked), apply coupon
      debugPrint('[BannerController] ✅ All validations passed, applying coupon...');
      final res = await GraphqlService.client.value.mutate$ApplyCouponCode(
        Options$Mutation$ApplyCouponCode(
          variables: Variables$Mutation$ApplyCouponCode(input: couponCode),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to apply coupon code')) {
        utilityController.setLoadingState(false);
        _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': 'Network error occurred',
          'error': 'NETWORK_ERROR'
        };
      }

      final result = res.parsedData?.applyCouponCode;

      if (result != null && result is Mutation$ApplyCouponCode$applyCouponCode$$Order) {
        appliedCouponCodes.clear();
        appliedCouponCodes.add(couponCode);

        debugPrint('[BannerController] Coupon code applied successfully: $couponCode');
        debugPrint('[BannerController] New total: ${result.total}');
        debugPrint('[BannerController] New totalWithTax: ${result.totalWithTax}');
        debugPrint('[BannerController] New subTotalWithTax: ${result.subTotalWithTax}');
        debugPrint('[BannerController] Discounts count: ${result.discounts.length}');
        
        // Update controllers with full order data from response
        try {
          final cartController = Get.find<CartController>();
          final orderController = Get.find<OrderController>();
          final resultJson = result.toJson();
          
          debugPrint('[BannerController] Updating cart controller with coupon response...');
          
          final hasLines = resultJson['lines'] != null && 
                         (resultJson['lines'] as List).isNotEmpty;
          
          if (hasLines) {
            // Update cart controller directly from response
            cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
            debugPrint('[BannerController] ✅ Cart controller updated with new totals');
            debugPrint('[BannerController] Cart totalWithTax: ${cartController.cart.value?.totalWithTax}');
            
            // Refresh order controller to get updated data
            await orderController.getActiveOrder(skipLoading: true);
            debugPrint('[BannerController] ✅ Order controller refreshed');
            
            // Restore coupon tracking from cart to ensure UI shows free products correctly
            try {
              await restoreCouponTrackingFromCart();
              debugPrint('[BannerController] ✅ Coupon tracking restored after applying coupon');
            } catch (e) {
              debugPrint('[BannerController] Could not restore coupon tracking: $e');
            }
          } else {
            // If no lines in response, refresh both controllers
            debugPrint('[BannerController] No lines in response, refreshing controllers...');
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
            
            // Restore coupon tracking after refresh
            try {
              await restoreCouponTrackingFromCart();
              debugPrint('[BannerController] ✅ Coupon tracking restored after refresh');
            } catch (e) {
              debugPrint('[BannerController] Could not restore coupon tracking: $e');
            }
          }
        } catch (e) {
          debugPrint('[BannerController] Could not update controllers: $e');
          // Fallback: refresh both controllers from server
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            debugPrint('[BannerController] Fallback: refreshing controllers from server...');
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
            
            // Restore coupon tracking after fallback refresh
            try {
              await restoreCouponTrackingFromCart();
              debugPrint('[BannerController] ✅ Coupon tracking restored after fallback refresh');
            } catch (restoreError) {
              debugPrint('[BannerController] Could not restore coupon tracking: $restoreError');
            }
          } catch (refreshError) {
            debugPrint('[BannerController] Failed to refresh controllers: $refreshError');
          }
        }
        
        utilityController.setLoadingState(false);
        return {
          'success': true,
          'message': 'Coupon code applied successfully',
          'couponCode': couponCode,
          'orderTotal': result.total,
          'totalWithTax': result.totalWithTax,
        };
      }

      // Handle error results
      utilityController.setLoadingState(false);
      _refreshCartAfterCouponError();
      return {
        'success': false,
        'message': 'Failed to apply coupon code',
        'error': 'APPLICATION_ERROR'
      };
    } catch (e) {
      debugPrint('[BannerController] ❌ Exception applying coupon code: $couponCode');
      utilityController.setLoadingState(false);
      handleException(e, customErrorMessage: 'Failed to apply coupon code');
      _refreshCartAfterCouponError();
      return {
        'success': false,
        'message': 'Error applying coupon code',
        'error': 'EXCEPTION'
      };
    }
  }

  /// Refresh cart after coupon application error
  /// This ensures the cart state is up to date even when coupon fails
  Future<void> _refreshCartAfterCouponError() async {
    try {
      debugPrint('[BannerController] 🔄 Refreshing cart after coupon error...');
      final cartController = Get.find<CartController>();
      final orderController = Get.find<OrderController>();
      
      // Refresh both controllers to ensure state is synchronized
      await Future.wait([
        cartController.getActiveOrder(),
        orderController.getActiveOrder(skipLoading: true),
      ], eagerError: false);
      
      debugPrint('[BannerController] ✅ Cart refreshed after coupon error');
    } catch (e) {
      debugPrint('[BannerController] ⚠️ Failed to refresh cart after coupon error: $e');
      // Don't throw - this is a best-effort refresh
    }
  }

  /// Remove products added by a specific coupon
  Future<bool> removeCouponProducts(String couponCode) async {
    try {
debugPrint('[BannerController] ===== REMOVING COUPON PRODUCTS =====');
debugPrint('[BannerController] Coupon code: $couponCode');

      if (!couponAddedProducts.containsKey(couponCode)) {
debugPrint(  '[BannerController] No products tracked for coupon: $couponCode');
debugPrint(  '[BannerController] Available tracked coupons: ${couponAddedProducts.keys.toList()}');
        return true; // No products to remove
      }

      final productsToRemove = couponAddedProducts[couponCode]!;
debugPrint(  '[BannerController] Found ${productsToRemove.length} products to remove for coupon: $couponCode');
debugPrint(  '[BannerController] Products to remove: $productsToRemove');

      // Get current cart to find order line IDs for these products
      final cartController = Get.find<CartController>();
      final cart = cartController.cart.value;
      if (cart == null) {
debugPrint(  '[BannerController] No active cart found - cannot remove products');
        return false;
      }

      final cartLines = cart.lines;
debugPrint(  '[BannerController] Current cart has ${cartLines.length} order lines');

      int removedCount = 0;
      
      for (final entry in productsToRemove.entries) {
        final variantId = entry.key;
        final quantityToRemove = entry.value;
debugPrint(  '[BannerController] Processing variant $variantId, quantity to remove: $quantityToRemove');
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineId = line.id;
          final currentQuantity = line.quantity;
          final variantIdFromCart = line.productVariant.id;

debugPrint(  '[BannerController] Checking order line $lineId: variant=$variantIdFromCart, currentQty=$currentQuantity');
          if (variantIdFromCart == variantId) {
            found = true;
debugPrint(  '[BannerController] ✓ Found matching order line $lineId for variant $variantId');
            
            // Calculate new quantity after removing coupon-added quantity
            final newQuantity = currentQuantity - quantityToRemove;
            
            if (newQuantity <= 0) {
              // Remove the entire line if quantity becomes 0 or negative
              // This happens when: currentQuantity <= quantityToRemove
              // Example: currentQuantity=1, quantityToRemove=1 → newQuantity=0 → remove
debugPrint(  '[BannerController] Removing entire order line $lineId (currentQty=$currentQuantity, couponQty=$quantityToRemove, would be $newQuantity)');
              final success = await _removeOrderLineById(lineId);
              if (success) {
                removedCount++;
debugPrint(  '[BannerController] ✓ Successfully removed order line $lineId');
                
                // Refresh cart after removal to get updated state
                try {
                  await cartController.getActiveOrder();
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] Cart and OrderController updated after removing line');
                } catch (e) {
debugPrint('[BannerController] Could not update controllers: $e');
                }
              } else {
debugPrint(  '[BannerController] ✗ Failed to remove order line $lineId');
              }
            } else {
              // Decrease quantity instead of removing the line
              // This happens when: currentQuantity > quantityToRemove
              // Example: currentQuantity=2, quantityToRemove=1 → newQuantity=1 → decrease
debugPrint(  '[BannerController] Decreasing quantity from $currentQuantity to $newQuantity for order line $lineId (removing coupon-added quantity: $quantityToRemove)');
              final success = await cartController.adjustOrderLine(
                orderLineId: lineId,
                quantity: newQuantity,
              );
              if (success) {
                removedCount++;
debugPrint(  '[BannerController] ✓ Successfully decreased quantity for order line $lineId');
                
                // Cart is already updated by adjustOrderLine, just update OrderController
                try {
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] OrderController updated after decreasing quantity');
                } catch (e) {
debugPrint('[BannerController] Could not update OrderController: $e');
                }
              } else {
debugPrint(  '[BannerController] ✗ Failed to decrease quantity for order line $lineId');
              }
            }
            break; // Process only one instance per variant ID
          }
        }

        if (!found) {
debugPrint(  '[BannerController] ⚠ Variant ID $variantId not found in current cart');
        }
      }

debugPrint(  '[BannerController] Processed $removedCount out of ${productsToRemove.length} products');

      // Verify removal by checking cart again
      if (removedCount > 0) {
debugPrint('[BannerController] Verifying product removal...');
        final updatedCart = cartController.cart.value;
        if (updatedCart != null) {
debugPrint(  '[BannerController] Cart after removal has ${updatedCart.lines.length} lines');
        }
      }

      // Clear the tracked products for this coupon
      couponAddedProducts.remove(couponCode);
debugPrint(  '[BannerController] ✓ Cleared tracked products for coupon: $couponCode');
debugPrint(  '[BannerController] ===== COUPON PRODUCT REMOVAL COMPLETE =====');

      return removedCount > 0;
    } catch (e) {
debugPrint('[BannerController] ✗ Error removing coupon products: $e');
      return false;
    }
  }

  /// Get current cart

  /// Remove order line by ID
  Future<bool> _removeOrderLineById(String orderLineId) async {
    try {
      debugPrint('[BannerController] Attempting to remove order line: $orderLineId');

      final response = await GraphqlService.client.value.mutate$RemoveOrderLine(
        Options$Mutation$RemoveOrderLine(
          variables: Variables$Mutation$RemoveOrderLine(
            orderLineId: orderLineId,
          ),
        ),
      );

      if (checkResponseForErrors(response,
          customErrorMessage: 'Failed to remove item from cart')) {
        return false;
      }

      final result = response.parsedData?.removeOrderLine;
      if (result != null) {
        if (result is Mutation$RemoveOrderLine$removeOrderLine$$Order) {
          debugPrint('[BannerController] ✓ Successfully removed order line $orderLineId');
          debugPrint('[BannerController] Updated order ID: ${result.id}');
          
          // Update both controllers after removal
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            final resultJson = result.toJson();
            
            // Update CartController
            cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
debugPrint('[BannerController] CartController updated after removing line');
            
            // Update OrderController
            // Note: result is from data, need to parse it properly
            // For now, refresh the order instead
            await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] OrderController updated after removing line');
          } catch (e) {
debugPrint('[BannerController] Could not update controllers after removal: $e');
            // Fallback: refresh controllers
            try {
              final cartController = Get.find<CartController>();
              final orderController = Get.find<OrderController>();
              await cartController.getActiveOrder();
              await orderController.getActiveOrder(skipLoading: true);
            } catch (refreshError) {
debugPrint('[BannerController] Failed to refresh controllers: $refreshError');
            }
          }
          
          return true;
        } else {
          // Handle error cases - this is not an Order, so it's likely an error
          debugPrint('[BannerController] ✗ Failed to remove order line $orderLineId: Result type: ${result.runtimeType}');
          // Try to extract message if available
          try {
            debugPrint('[BannerController] Error typename: ${result.$__typename}');
            final resultJson = result.toJson();
            final message = resultJson['message'] as String?;
            if (message != null) {
              debugPrint('[BannerController] Error message: $message');
            }
          } catch (e) {
            debugPrint('[BannerController] Could not extract error details: $e');
          }
          return false;
        }
      } else {
debugPrint(  '[BannerController] ✗ No result from removeOrderLine mutation for $orderLineId');
        return false;
      }
    } catch (e) {
debugPrint(  '[BannerController] ✗ Exception removing order line $orderLineId: $e');
      handleException(e, customErrorMessage: 'Failed to remove item from cart');
      return false;
    }
  }

  /// Remove coupon code from active order
  Future<bool> removeCouponCode(String couponCode) async {
    try {
      utilityController.setLoadingState(true);

      // Check if coupon has products that need to be removed
      final hasProducts = hasCouponProducts(couponCode) || 
                         couponAddedProducts.containsKey(couponCode);
debugPrint(  '[BannerController] Coupon $couponCode has products to remove: $hasProducts');

      // If coupon has products, remove them from cart first
      if (hasProducts) {
debugPrint(  '[BannerController] Step 1: Removing products added by coupon: $couponCode');
        final productsRemoved = await removeCouponProducts(couponCode);
        
        // If removing products fails, don't remove coupon
        if (!productsRemoved) {
debugPrint(  '[BannerController] ❌ Failed to remove products for coupon $couponCode');
debugPrint(  '[BannerController] ❌ Not removing coupon code due to product removal failure');
          utilityController.setLoadingState(false);
          return false;
        }
debugPrint(  '[BannerController] ✅ Successfully removed coupon products from cart');
      } else {
debugPrint(  '[BannerController] Coupon has no products, skipping product removal');
      }

debugPrint('[BannerController] Step 2: Removing coupon code...');
      final res = await GraphqlService.client.value.mutate$RemoveCouponCode(
        Options$Mutation$RemoveCouponCode(
          variables:
              Variables$Mutation$RemoveCouponCode(couponCode: couponCode),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to remove coupon code')) {
        debugPrint('[BannerController] ❌ Network error removing coupon: $couponCode');
        debugPrint('[BannerController] ❌ Response exception: ${res.exception}');
        utilityController.setLoadingState(false);
        return false;
      }

      final result = res.parsedData?.removeCouponCode;

      if (result != null) {
        appliedCouponCodes.remove(couponCode);
        // Clear tracked products and original quantities for this coupon
        couponAddedProducts.remove(couponCode);
        originalCartQuantities.remove(couponCode);

debugPrint(  '[BannerController] Coupon code removed successfully: $couponCode');
debugPrint(  '[BannerController] Cleared tracked products and original quantities for coupon: $couponCode');
        
        // Update both cart and order controllers directly from the response
        try {
          final cartController = Get.find<CartController>();
          final orderController = Get.find<OrderController>();
          // Result is Fragment$Cart which contains full order data
          final resultJson = result.toJson();
          if (resultJson.containsKey('id')) {
            // Update CartController
            cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
debugPrint('[BannerController] CartController updated directly from removeCouponCode response');
            
            // Update OrderController
            orderController.currentOrder.value = result;
debugPrint('[BannerController] OrderController updated directly from removeCouponCode response');
          } else {
debugPrint('[BannerController] No order data in removeCouponCode response, refreshing controllers');
            // Fallback: refresh both controllers
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
          }
        } catch (e) {
debugPrint('[BannerController] Could not update controllers directly: $e');
          // Fallback: refresh both controllers
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] Controllers refreshed via getActiveOrder');
          } catch (refreshError) {
debugPrint('[BannerController] Failed to refresh controllers: $refreshError');
          }
        }
        
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
debugPrint('[BannerController] Remove coupon code error: $e');
      handleException(e, customErrorMessage: 'Failed to remove coupon code');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Toggle coupon code (apply if not applied, remove if applied)
  Future<Map<String, dynamic>> toggleCouponCode(String couponCode) async {
    if (appliedCouponCodes.contains(couponCode)) {
      final success = await removeCouponCode(couponCode);
      return {
        'success': success,
        'message': success
            ? 'Coupon code removed successfully'
            : 'Failed to remove coupon code',
        'action': 'removed'
      };
    } else {
      // Use the new method that adds products first, then applies coupon
      return await applyCouponCodeWithProducts(couponCode);
    }
  }

  /// Check if coupon code is applied
  bool isCouponCodeApplied(String couponCode) {
    return appliedCouponCodes.contains(couponCode);
  }

  /// Check if any coupon is currently applied (for one coupon per order policy)
  bool isAnyCouponApplied() {
    return appliedCouponCodes.isNotEmpty;
  }

  /// Get the currently applied coupon code (for one coupon per order policy)
  String? getCurrentlyAppliedCoupon() {
    return appliedCouponCodes.isNotEmpty ? appliedCouponCodes.first : null;
  }

  /// Reset coupon codes state
  void resetCouponCodes() {
    appliedCouponCodes.clear();
    couponAddedProducts.clear();
debugPrint('[BannerController] Coupon codes and tracked products reset');
  }

  /// Restore coupon tracking state from cart
  /// This is called when cart is loaded to reconstruct couponAddedProducts and originalCartQuantities
  Future<void> restoreCouponTrackingFromCart() async {
    try {
      debugPrint('[BannerController] ===== Restoring coupon tracking from cart =====');
      
      // Get current cart
      final orderController = Get.find<OrderController>();
      final currentOrder = orderController.currentOrder.value;
      if (currentOrder == null) {
        debugPrint('[BannerController] No cart found, cannot restore coupon tracking');
        return;
      }

      // Get applied coupon codes from cart
      final cartCouponCodes = currentOrder.couponCodes.map((e) => e.toString()).toList();
      debugPrint('[BannerController] Coupon codes in cart: $cartCouponCodes');
      
      if (cartCouponCodes.isEmpty) {
        debugPrint('[BannerController] No coupon codes in cart, clearing tracking');
        appliedCouponCodes.clear();
        couponAddedProducts.clear();
        originalCartQuantities.clear();
        return;
      }

      // Update appliedCouponCodes to match cart
      appliedCouponCodes.value = cartCouponCodes;
      debugPrint('[BannerController] Restored applied coupon codes: ${appliedCouponCodes.toList()}');

      // Get current cart lines
      final cartController = Get.find<CartController>();
      final cart = cartController.cart.value;
      if (cart == null) {
        debugPrint('[BannerController] No cart found, cannot restore tracking');
        return;
      }
      
      final cartLines = cart.lines;
      final currentQuantities = <String, int>{};
      for (final line in cartLines) {
        final variantId = line.productVariant.id;
        final quantity = line.quantity;
        currentQuantities[variantId] = quantity;
      }

      // For each applied coupon, try to reconstruct tracking
      // Load coupon codes list if not already loaded
      if (!couponCodesLoaded.value) {
        await getCouponCodeList();
      }

      couponAddedProducts.clear();
      originalCartQuantities.clear();

      for (final couponCode in cartCouponCodes) {
        debugPrint('[BannerController] Reconstructing tracking for coupon: $couponCode');
        
        // Find the coupon in available coupons
        Query$GetCouponCodeList$getCouponCodeList$items? coupon;
        try {
          coupon = availableCouponCodes.firstWhere(
            (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
          );
          debugPrint('[BannerController] Found coupon in available list: ${coupon.name}');
        } catch (e) {
          debugPrint('[BannerController] Coupon $couponCode not found in available coupons, skipping tracking reconstruction');
          continue;
        }

        // Get products that should be added by this coupon
        // Note: getCouponProducts will also find the coupon, but we already found it above for early validation
        final couponProducts = getCouponProducts(couponCode);
        if (couponProducts.isEmpty) {
          debugPrint('[BannerController] Coupon $couponCode has no products, skipping tracking');
          continue;
        }

        // Try to identify which products in cart match the coupon products
        final addedQuantities = <String, int>{};
        final originalQuantities = <String, int>{};

        for (final couponProduct in couponProducts) {
          final variantId = couponProduct['productVariantId']?.toString();
          final expectedQuantity = couponProduct['quantity'] as int? ?? 1;
          
          if (variantId == null) continue;

          final currentQty = currentQuantities[variantId] ?? 0;
          
          if (currentQty >= expectedQuantity) {
            // Product exists in cart with at least the expected quantity
            // We assume the coupon-added quantity is the expected quantity
            // and the rest (if any) is original
            addedQuantities[variantId] = expectedQuantity;
            originalQuantities[variantId] = currentQty - expectedQuantity;
            debugPrint('[BannerController] Reconstructed for variant $variantId: Current=$currentQty, CouponAdded=$expectedQuantity, Original=${currentQty - expectedQuantity}');
          } else if (currentQty > 0) {
            // Product exists but with less quantity than expected (maybe user removed some)
            // Assume all current quantity is from coupon
            addedQuantities[variantId] = currentQty;
            originalQuantities[variantId] = 0;
            debugPrint('[BannerController] Reconstructed for variant $variantId: Current=$currentQty (less than expected $expectedQuantity), assuming all coupon-added');
          }
        }

        if (addedQuantities.isNotEmpty) {
          couponAddedProducts[couponCode] = addedQuantities;
          originalCartQuantities[couponCode] = originalQuantities;
          debugPrint('[BannerController] Restored tracking for coupon $couponCode: ${addedQuantities.length} products');
        } else {
          debugPrint('[BannerController] No products found in cart for coupon $couponCode');
        }
      }

      debugPrint('[BannerController] ✅ Coupon tracking restoration complete');
      debugPrint('[BannerController] Applied coupons: ${appliedCouponCodes.toList()}');
      debugPrint('[BannerController] Tracked products: ${couponAddedProducts.keys.toList()}');
    } catch (e) {
      debugPrint('[BannerController] Error restoring coupon tracking: $e');
      // Don't throw - this is best-effort restoration
    }
  }

  /// Check and remove coupons if cart total is below their minimum requirement
  /// Called automatically when cart is cleared or cart total decreases
  Future<void> validateAndRemoveCouponsIfNeeded() async {
    try {
      // First, restore coupon tracking from cart if appliedCouponCodes is empty but cart has coupons
      final orderController = Get.find<OrderController>();
      final currentOrder = orderController.currentOrder.value;
      if (currentOrder != null) {
        final cartCouponCodes = currentOrder.couponCodes.map((e) => e.toString()).toList();
        if (appliedCouponCodes.isEmpty && cartCouponCodes.isNotEmpty) {
          debugPrint('[BannerController] Applied coupons list is empty but cart has coupons, restoring tracking first');
          await restoreCouponTrackingFromCart();
        } else if (appliedCouponCodes.isNotEmpty && cartCouponCodes.isEmpty) {
          // Cart has no coupons but we have applied coupons - clear them
          debugPrint('[BannerController] Cart has no coupons but appliedCouponCodes is not empty, clearing');
          resetCouponCodes();
        }
      }

      // If no coupons applied, nothing to check
      if (appliedCouponCodes.isEmpty) {
        debugPrint('[BannerController] No coupons applied, skipping validation');
        return;
      }

      debugPrint('[BannerController] ===== Validating applied coupons =====');
      debugPrint('[BannerController] Applied coupons: ${appliedCouponCodes.toList()}');

      // Get current cart total from active order (orderController already defined above)
      // Try to get from already-loaded order first
      double? cartTotal = orderController.currentOrder.value?.totalWithTax;
      
      // If not available, load active order
      if (cartTotal == null) {
        final loaded = await orderController.getActiveOrder(skipLoading: true);
        if (loaded) {
          cartTotal = orderController.currentOrder.value?.totalWithTax;
        }
      }
      
      if (cartTotal == null) {
        debugPrint('[BannerController] Could not get cart total, skipping coupon validation');
        return;
      }

      debugPrint('[BannerController] Current cart total: $cartTotal');

      // Check each applied coupon
      final couponsToRemove = <String>[];
      
      for (final couponCode in appliedCouponCodes.toList()) {
        // Find the coupon in available coupons
        Query$GetCouponCodeList$getCouponCodeList$items? coupon;
        try {
          coupon = availableCouponCodes.firstWhere(
            (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
          );
        } catch (e) {
          debugPrint('[BannerController] Coupon $couponCode not found in available coupons');
          // Remove it from applied list if not found
          couponsToRemove.add(couponCode);
          continue;
        }

        // Get minimum amount for this coupon
        final minimumAmount = _getCouponMinimumAmount(coupon);
        if (minimumAmount == null) {
          // No minimum requirement, skip
          debugPrint('[BannerController] Coupon $couponCode has no minimum requirement');
          continue;
        }

        // Check if cart total is below minimum
        if (cartTotal < minimumAmount) {
          debugPrint('[BannerController] ❌ Coupon $couponCode minimum not met');
          debugPrint('[BannerController] Required: $minimumAmount, Current: $cartTotal');
          couponsToRemove.add(couponCode);
        } else {
          debugPrint('[BannerController] ✅ Coupon $couponCode minimum met');
        }
      }

      // Remove coupons that don't meet minimum requirements
      if (couponsToRemove.isNotEmpty) {
        debugPrint('[BannerController] Removing ${couponsToRemove.length} coupons that don\'t meet minimum requirements');
        
        for (final couponCode in couponsToRemove) {
          debugPrint('[BannerController] Removing coupon: $couponCode');
          await removeCouponCode(couponCode);
        }
        
        debugPrint('[BannerController] ✅ Coupon validation and removal complete');
      } else {
        debugPrint('[BannerController] ✅ All applied coupons meet minimum requirements');
      }
    } catch (e) {
      debugPrint('[BannerController] Error validating and removing coupons: $e');
      // Don't throw - this is a background validation
    }
  }

  /// Get coupon validation status for UI display
  Future<Map<String, dynamic>> getCouponValidationStatus(
      String couponCode) async {
    return await validateCouponCode(couponCode);
  }

  /// Check if cart has products for coupon validation
  Future<bool> hasProductsInCart() async {
    try {
      // This would typically check the current cart/order
      // For now, we'll assume there are products if we have an active order
      return true; // This should be implemented based on your cart logic
    } catch (e) {
debugPrint('[BannerController] Check cart products error: $e');
      return false;
    }
  }

  /// Add coupon products to cart
  Future<Map<String, dynamic>> addCouponProductsToCart(
      String couponCode) async {
    try {
      // Prevent duplicate calls - if already adding items, return early
      if (_isAddingItems) {
debugPrint(  '[BannerController] ⚠️ Already adding items, skipping duplicate call');
        return {
          'success': false,
          'message': 'Items are already being added to cart',
          'error': 'ALREADY_ADDING_ITEMS'
        };
      }

      // Set flag to prevent duplicate calls
      _isAddingItems = true;

debugPrint(  '[BannerController] ===== ADDING COUPON PRODUCTS TO CART =====');
debugPrint('[BannerController] Coupon code: $couponCode');

      // Get products from the actual coupon data
      final couponProducts = getCouponProducts(couponCode);

      if (couponProducts.isEmpty) {
debugPrint(  '[BannerController] ✗ No products found for coupon: $couponCode');
        return {
          'success': false,
          'message': 'No products found for this coupon',
          'error': 'NO_PRODUCTS_DEFINED'
        };
      }

debugPrint(  '[BannerController] ✓ Found ${couponProducts.length} products for coupon: $couponCode');
      for (int i = 0; i < couponProducts.length; i++) {
        // final product = couponProducts[i]; // Unused variable
debugPrint(  '[BannerController] Product $i: ${couponProducts[i]['name']} (Variant ID: ${couponProducts[i]['productVariantId']}, Qty: ${couponProducts[i]['quantity']})');
      }

      utilityController.setLoadingState(true);

      // Step 1: Get current cart state BEFORE adding to track original quantities
      final cartController = Get.find<CartController>();
      final cartBefore = cartController.cart.value;
      final originalQuantities = <String, int>{};
      if (cartBefore != null) {
        final cartLines = cartBefore.lines;
        for (final line in cartLines) {
          final variantId = line.productVariant.id;
          final quantity = line.quantity;
          originalQuantities[variantId] = quantity;
        }
        debugPrint('[BannerController] Original cart quantities before adding coupon products: $originalQuantities');
      }
      // Store original quantities for this coupon
      originalCartQuantities[couponCode] = Map<String, int>.from(originalQuantities);

      // Add each product from the coupon to cart
      final addedProducts = <Map<String, dynamic>>[];
      final failedProducts = <Map<String, dynamic>>[];

      for (final product in couponProducts) {
        try {
          final productName = product['name'] as String;
          final productVariantId = product['productVariantId'] as String;
          final quantity = product['quantity'] as int;
          final priceWithTax = product['priceWithTax'] as double;

debugPrint(  '[BannerController] Adding product to cart: $productName (Variant ID: $productVariantId, Qty: $quantity)');

          final res = await GraphqlService.client.value.mutate$AddToCart(
            cart_graphql.Options$Mutation$AddToCart(
              variables: cart_graphql.Variables$Mutation$AddToCart(
                variantId: productVariantId,
                qty: quantity,
              ),
            ),
          );

          if (res.hasException) {
debugPrint(  '[BannerController] - Product from $productName: Network error: ${res.exception}');

            // Extract error message from GraphQL errors
            String errorMessage = 'Failed to add product to cart';
            if (res.exception?.graphqlErrors.isNotEmpty == true) {
              errorMessage = res.exception!.graphqlErrors.first.message;
            } else if (res.exception?.linkException != null) {
              errorMessage =
                  'Network error. Please check your internet connection.';
            } else {
              errorMessage = res.exception.toString();
            }

            // Show error dialog with the specific error message
            ErrorDialog.showError(errorMessage);

            failedProducts.add({'product': productName, 'error': errorMessage});
            continue;
          }

          final result = res.parsedData?.addItemToOrder;
          if (result != null) {
debugPrint(  '[BannerController] Add to cart result for $productName: ${result.runtimeType}');
            if (result is cart_graphql.Mutation$AddToCart$addItemToOrder$$Order) {
debugPrint(  '[BannerController] Successfully added $productName to cart');
              
              // Update both controllers immediately after each product is added
              // This prevents the "cart is empty" UI issue
              try {
                final cartController = Get.find<CartController>();
                final orderController = Get.find<OrderController>();
                final resultJson = result.toJson();
                
                // Update CartController
                cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
debugPrint('[BannerController] CartController updated after adding $productName');
                
                // Update OrderController - refresh to get proper Fragment$Cart type
                await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] OrderController updated after adding $productName');
              } catch (e) {
debugPrint('[BannerController] Could not update controllers after adding $productName: $e');
              }
              
              addedProducts.add({
                'product': productName,
                'quantity': quantity,
                'price': priceWithTax,
                'productVariantId': productVariantId,
              });
            } else if (result
                is cart_graphql.Mutation$AddToCart$addItemToOrder$$InsufficientStockError) {
debugPrint(  '[BannerController] Failed to add $productName: Insufficient stock');
              failedProducts
                  .add({'product': productName, 'error': 'Insufficient stock'});
            } else {
debugPrint(  '[BannerController] Failed to add $productName: Unknown error');
              failedProducts
                  .add({'product': productName, 'error': 'Unknown error'});
            }
          } else {
debugPrint(  '[BannerController] No result returned for adding $productName');
            failedProducts.add({
              'product': productName,
              'error': 'No result returned from server'
            });
          }
        } catch (e) {
debugPrint(  '[BannerController] Exception adding product ${product['name']}: $e');
          handleException(e,
              customErrorMessage: 'Failed to add product to cart');
          failedProducts.add({
            'product': product['name'],
            'error': 'Error adding product: $e'
          });
        }
      }

      utilityController.setLoadingState(false);

debugPrint(  '[BannerController] Coupon products addition completed for $couponCode');
debugPrint(  '[BannerController] Successfully added: ${addedProducts.length} products');
debugPrint(  '[BannerController] Failed to add: ${failedProducts.length} products');

      if (addedProducts.isNotEmpty) {
debugPrint('[BannerController] Added products:');
        final addedProductIds = <String>[];
        for (final product in addedProducts) {
debugPrint(  '[BannerController] - ${product['product']} (Qty: ${product['quantity']}, Price: ${product['price']})');
          // Track the product variant ID for removal later
          if (product['productVariantId'] != null) {
            addedProductIds.add(product['productVariantId'].toString());
          }
        }

        // Step 2: Get cart state AFTER all products have been added to calculate what was actually added
        // Refresh cart first to get the latest state
        try {
          final cartController = Get.find<CartController>();
          final orderController = Get.find<OrderController>();
          await Future.wait([
            cartController.getActiveOrder(),
            orderController.getActiveOrder(skipLoading: true),
          ], eagerError: false);
        } catch (e) {
          debugPrint('[BannerController] Could not refresh cart after adding products: $e');
        }

        final cartAfter = cartController.cart.value;
        final actualAddedQuantities = <String, int>{};
        if (cartAfter != null) {
          final cartLines = cartAfter.lines;
          
          // Only track products that were actually supposed to be added by this coupon
          final couponProductVariantIds = addedProducts.map((p) => p['productVariantId']?.toString()).whereType<String>().toSet();
          
          for (final line in cartLines) {
            final variantId = line.productVariant.id;
            
            // Only calculate difference for products that were intended to be added by this coupon
            if (couponProductVariantIds.contains(variantId)) {
              final quantityAfter = line.quantity;
              final quantityBefore = originalQuantities[variantId] ?? 0;
              final quantityAdded = quantityAfter - quantityBefore;
              
              if (quantityAdded > 0) {
                actualAddedQuantities[variantId] = quantityAdded;
                debugPrint('[BannerController] Variant $variantId: Before=$quantityBefore, After=$quantityAfter, Added=$quantityAdded');
              } else {
                debugPrint('[BannerController] Variant $variantId: Was in coupon list but quantity didn\'t increase (Before=$quantityBefore, After=$quantityAfter). Not tracking as coupon-added.');
          }
        }
          }
        }

        // Store the actual quantities added by this coupon (difference, not absolute)
        couponAddedProducts[couponCode] = actualAddedQuantities;
        debugPrint('[BannerController] Tracked actual added quantities for coupon $couponCode: $actualAddedQuantities');
      }

      if (failedProducts.isNotEmpty) {
debugPrint('[BannerController] ❌ Failed products:');
        for (final _ in failedProducts) {
          // Logging is commented out, so variable is unused
        }
      }

      // If ANY product failed, rollback all added products and return failure
      if (failedProducts.isNotEmpty) {
debugPrint('[BannerController] ❌ Some products failed to add. Rolling back all added products...');
        
        // Rollback: Remove all successfully added products
        for (final addedProduct in addedProducts) {
          try {
            final productVariantId = addedProduct['productVariantId'] as String;
debugPrint('[BannerController] Rolling back product: ${addedProduct['product']} (Variant ID: $productVariantId)');
            
            // Find the order line for this product variant
            final cartController = Get.find<CartController>();
            final cart = cartController.cart.value;
            if (cart != null) {
              final cartLines = cart.lines;
              for (final line in cartLines) {
                final lineId = line.id;
                final variantIdFromCart = line.productVariant.id;
                
                if (variantIdFromCart == productVariantId) {
debugPrint('[BannerController] Removing order line $lineId for variant $productVariantId');
                  final success = await _removeOrderLineById(lineId);
                  if (success) {
debugPrint('[BannerController] ✓ Successfully rolled back order line $lineId');
                  } else {
debugPrint('[BannerController] ✗ Failed to rollback order line $lineId');
                  }
                  break;
                }
              }
            }
          } catch (e) {
debugPrint('[BannerController] Error rolling back product ${addedProduct['product']}: $e');
          }
        }
        
        // Clear tracked products for this coupon
        couponAddedProducts.remove(couponCode);
debugPrint('[BannerController] ❌ Rollback complete. Coupon will not be applied.');
        
        return {
          'success': false,
          'message': 'Failed to add all coupon products. Added products have been removed.',
          'addedProducts': [],
          'failedProducts': failedProducts,
          'totalAdded': 0,
          'totalFailed': failedProducts.length,
          'rollbackPerformed': true,
        };
      }

      // Only return success if ALL products were added successfully
      // If any product failed, success should be false (already handled above with rollback)
      final allProductsAdded = failedProducts.isEmpty && addedProducts.isNotEmpty;
      
      return {
        'success': allProductsAdded,
        'message': allProductsAdded 
            ? 'Added ${addedProducts.length} products to cart'
            : 'Failed to add all products to cart',
        'addedProducts': addedProducts,
        'failedProducts': failedProducts,
        'totalAdded': addedProducts.length,
        'totalFailed': failedProducts.length,
      };
    } catch (e) {
      debugPrint('[BannerController] Add coupon products to cart error: $e');
      handleException(e,
          customErrorMessage: 'Failed to add coupon products to cart');
      utilityController.setLoadingState(false);
      // Refresh cart to ensure state is up to date after error
      _refreshCartAfterCouponError();
      return {
        'success': false,
        'message': 'Error adding coupon products to cart: $e',
        'error': 'ADD_PRODUCTS_ERROR'
      };
    } finally {
      // Reset flag to allow future calls
      _isAddingItems = false;
debugPrint('[BannerController] Reset _isAddingItems flag');
    }
  }

  /// Apply coupon code with products (check minimum first, add products if needed, then apply coupon)
  Future<Map<String, dynamic>> applyCouponCodeWithProducts(
      String couponCode) async {
    try {
      debugPrint('[BannerController] Starting applyCouponCodeWithProducts for: $couponCode');

      // Step 1: Find the coupon
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
        debugPrint('[BannerController] ❌ Coupon not found: $couponCode');
        return {
          'success': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }

      // Step 2: Check minimum order amount FIRST
      debugPrint('[BannerController] Step 1: Checking minimum order amount...');
      final minimumAmountValidation = await _validateMinimumOrderAmount(coupon);
      
      Map<String, dynamic>? addResult;
      
      // Step 2: If minimum not met, show dialog and return (don't add products or apply coupon)
      if (!minimumAmountValidation['valid']) {
        debugPrint('[BannerController] ❌ Minimum order amount not met');
        debugPrint('[BannerController] Required: ${minimumAmountValidation['requiredAmount']}, Current: ${minimumAmountValidation['currentAmount']}');
        debugPrint('[BannerController] ❌ Stopping coupon application - minimum order amount must be met first');
        
        // Show dialog box and return error - don't add products or apply coupon
        ErrorDialog.showWarning(
          message: minimumAmountValidation['message'] as String,
        );
        
        return {
          'success': false,
          'message': minimumAmountValidation['message'],
          'error': 'MINIMUM_ORDER_AMOUNT_NOT_MET',
          'requiredAmount': minimumAmountValidation['requiredAmount'],
          'currentAmount': minimumAmountValidation['currentAmount']
        };
      }
      
      debugPrint('[BannerController] ✅ Minimum order amount already met');
      
      // Step 3: Add coupon products to cart (if coupon has products)
      final hasProducts = hasCouponProducts(couponCode);
      if (hasProducts) {
        debugPrint('[BannerController] Step 2: Adding coupon products to cart...');
        addResult = await addCouponProductsToCart(couponCode);

        // If adding products fails, don't apply coupon
        if (!addResult['success']) {
          debugPrint('[BannerController] ❌ Failed to add products to cart: ${addResult['message']}');
          _refreshCartAfterCouponError();
          return {
            'success': false,
            'message': 'Failed to add coupon products. ${addResult['message']}',
            'error': 'PRODUCT_ADDITION_FAILED',
            'addResult': addResult,
          };
        }
        
        debugPrint('[BannerController] ✅ Successfully added coupon products to cart');
      }
      
      // Step 3: Apply coupon code
      debugPrint('[BannerController] Step 3: Applying coupon code...');
      // Call internal method to apply coupon without minimum validation (already validated)
      final couponResult = await _applyCouponCodeWithoutMinimumCheck(couponCode);

      if (couponResult['success']) {
        debugPrint('[BannerController] ✅ Successfully applied coupon: $couponCode');
        
        final hasProducts = hasCouponProducts(couponCode);
        
        // Ensure cart is refreshed first to get latest state
        try {
          final cartController = Get.find<CartController>();
          await cartController.getActiveOrder();
          debugPrint('[BannerController] ✅ Cart refreshed after applying coupon');
        } catch (e) {
          debugPrint('[BannerController] Could not refresh cart: $e');
        }
        
        // Restore coupon tracking to ensure UI updates immediately
        // This ensures free products show at the top without needing pull-to-refresh
        try {
          await restoreCouponTrackingFromCart();
          debugPrint('[BannerController] ✅ Coupon tracking restored after applying coupon with products');
        } catch (e) {
          debugPrint('[BannerController] Could not restore coupon tracking: $e');
        }
        
        return {
          'success': true,
          'message': hasProducts 
              ? 'Coupon products added and coupon applied successfully'
              : 'Coupon applied successfully',
          'addedProducts': addResult?['addedProducts'] ?? [],
          'couponApplied': true,
          'orderTotal': couponResult['orderTotal'],
        };
      } else {
        debugPrint('[BannerController] ❌ Failed to apply coupon: $couponCode');
        debugPrint('[BannerController] ❌ Coupon error: ${couponResult['message']}');
        debugPrint('[BannerController] ❌ Coupon error type: ${couponResult['error']}');

        // ROLLBACK: Remove the products that were added since coupon application failed
        final hasProducts = hasCouponProducts(couponCode);
        if (hasProducts && addResult != null && addResult['success'] == true) {
          debugPrint('[BannerController] 🔄 Rolling back: Removing added products due to coupon application failure...');
          final rollbackResult = await _rollbackAddedProducts(couponCode);

          if (rollbackResult['success']) {
            debugPrint('[BannerController] ✅ Successfully rolled back added products');
          } else {
            debugPrint('[BannerController] ❌ Failed to rollback added products: ${rollbackResult['message']}');
          }
        }

        final errorMessage = hasProducts && addResult != null && addResult['success'] == true
            ? 'Failed to apply coupon: ${couponResult['message']}. Added products have been removed.'
            : couponResult['message'] as String? ?? 'Failed to apply coupon code';
        
        ErrorDialog.showWarning(
          message: errorMessage,
        );

        _refreshCartAfterCouponError();

        return {
          'success': false,
          'message': errorMessage,
          'addedProducts': addResult?['addedProducts'] ?? [],
          'couponApplied': false,
          'couponError': couponResult['error'],
          'rollbackPerformed': hasProducts && addResult != null && addResult['success'] == true,
        };
      }
    } catch (e) {
      debugPrint('[BannerController] ❌ Exception applying coupon with products: $couponCode');
      debugPrint('[BannerController] ❌ Error: $e');
      debugPrint('[BannerController] ❌ Error type: ${e.runtimeType}');
      debugPrint('[BannerController] ❌ Stack trace: ${StackTrace.current}');

      // ROLLBACK: If there's an exception, try to remove any products that might have been added
      debugPrint('[BannerController] 🔄 Exception occurred, attempting rollback...');
      try {
        await _rollbackAddedProducts(couponCode);
        debugPrint('[BannerController] ✅ Rollback completed');
        _refreshCartAfterCouponError();
      } catch (rollbackError) {
        debugPrint('[BannerController] ❌ Rollback failed with error: $rollbackError');
        _refreshCartAfterCouponError();
      }

      return {
        'success': false,
        'message': 'Error applying coupon: $e. Any added products have been removed.',
        'error': 'APPLY_COUPON_WITH_PRODUCTS_ERROR',
        'rollbackPerformed': true,
      };
    }
  }

  /// Rollback added products when coupon application fails
  Future<Map<String, dynamic>> _rollbackAddedProducts(String couponCode) async {
    try {
debugPrint('[BannerController] ===== ROLLING BACK ADDED PRODUCTS =====');
debugPrint('[BannerController] Coupon code: $couponCode');

      // Check if we have tracked products for this coupon
      if (!couponAddedProducts.containsKey(couponCode)) {
debugPrint(  '[BannerController] No products tracked for coupon: $couponCode - nothing to rollback');
        return {
          'success': true,
          'message': 'No products to rollback',
          'removedCount': 0
        };
      }

      final productsToRemove = couponAddedProducts[couponCode]!;
debugPrint(  '[BannerController] Rolling back ${productsToRemove.length} products for coupon: $couponCode');
debugPrint(  '[BannerController] Products to remove: $productsToRemove');

      // Get current cart to find order line IDs for these products
      final cartController = Get.find<CartController>();
      final cart = cartController.cart.value;
      if (cart == null) {
debugPrint(  '[BannerController] No active cart found - cannot rollback products');
        return {
          'success': false,
          'message': 'No active cart found',
          'removedCount': 0
        };
      }

      final cartLines = cart.lines;
debugPrint(  '[BannerController] Current cart has ${cartLines.length} order lines');

      int removedCount = 0;
      final failedRemovals = <String>[];

      for (final entry in productsToRemove.entries) {
        final variantId = entry.key;
        final quantityToRemove = entry.value;
debugPrint(  '[BannerController] Processing variant $variantId, quantity to remove: $quantityToRemove for rollback');
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineId = line.id;
          final currentQuantity = line.quantity;
          final variantIdFromCart = line.productVariant.id;

debugPrint(  '[BannerController] Checking order line $lineId: variant=$variantIdFromCart, currentQty=$currentQuantity for rollback');
          if (variantIdFromCart == variantId) {
            found = true;
debugPrint(  '[BannerController] ✓ Found matching order line $lineId for variant $variantId - processing rollback');
            
            // Calculate new quantity after removing coupon-added quantity
            final newQuantity = currentQuantity - quantityToRemove;
            
            if (newQuantity <= 0) {
              // Remove the entire line if quantity becomes 0 or negative
              // This happens when: currentQuantity <= quantityToRemove
debugPrint(  '[BannerController] Removing entire order line $lineId during rollback (currentQty=$currentQuantity, couponQty=$quantityToRemove, would be $newQuantity)');
              final success = await _removeOrderLineById(lineId);
              if (success) {
                removedCount++;
debugPrint(  '[BannerController] ✓ Successfully removed order line $lineId during rollback');
                
                // Update controllers after removal
                try {
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] OrderController updated after rollback removal');
                } catch (e) {
debugPrint('[BannerController] Could not update OrderController: $e');
                }
              } else {
debugPrint(  '[BannerController] ✗ Failed to remove order line $lineId during rollback');
                failedRemovals.add('Line $lineId for variant $variantId');
              }
            } else {
              // Decrease quantity instead of removing the line
              // This happens when: currentQuantity > quantityToRemove
debugPrint(  '[BannerController] Decreasing quantity from $currentQuantity to $newQuantity for order line $lineId during rollback (removing coupon-added quantity: $quantityToRemove)');
              final success = await cartController.adjustOrderLine(
                orderLineId: lineId,
                quantity: newQuantity,
              );
              if (success) {
                removedCount++;
debugPrint(  '[BannerController] ✓ Successfully decreased quantity for order line $lineId during rollback');
                
                // Update controllers after quantity adjustment
                try {
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] OrderController updated after rollback quantity decrease');
                } catch (e) {
debugPrint('[BannerController] Could not update OrderController: $e');
                }
              } else {
debugPrint(  '[BannerController] ✗ Failed to decrease quantity for order line $lineId during rollback');
                failedRemovals.add('Line $lineId for variant $variantId');
              }
            }
            break; // Process only one instance per variant ID
          }
        }

        if (!found) {
debugPrint(  '[BannerController] ⚠ Variant ID $variantId not found in current cart during rollback');
        }
      }

debugPrint(  '[BannerController] Rollback completed: Processed $removedCount out of ${productsToRemove.length} products');

      // Clear the tracked products for this coupon
      couponAddedProducts.remove(couponCode);
debugPrint(  '[BannerController] ✓ Cleared tracked products for coupon: $couponCode after rollback');
debugPrint('[BannerController] ===== ROLLBACK COMPLETE =====');

      return {
        'success': removedCount > 0 || failedRemovals.isEmpty,
        'message': removedCount > 0
            ? 'Successfully rolled back $removedCount products'
            : 'No products were removed during rollback',
        'removedCount': removedCount,
        'failedRemovals': failedRemovals,
        'totalExpected': productsToRemove.length
      };
    } catch (e) {
debugPrint('[BannerController] ✗ Error during rollback: $e');
      return {
        'success': false,
        'message': 'Error during rollback: $e',
        'removedCount': 0
      };
    }
  }

  /// Fetch app update information - now delegated to InAppUpdateService
  Future<void> getAppUpdateInfo() async {
    try {
debugPrint(  '[BannerController] Delegating update check to InAppUpdateService...');

      // Simply call the service method
      final updateService = InAppUpdateService();
      await updateService.checkForUpdatesAndDetermineType();

debugPrint(  '[BannerController] Update check completed by InAppUpdateService');
    } catch (e) {
debugPrint('[BannerController] Update check error: $e');
    }
  }

  // ============================================================================
  // PRODUCT DETAIL FUNCTIONALITY
  // ============================================================================
  final Rx<Map<String, dynamic>?> productDetail =
      Rx<Map<String, dynamic>?>(null);

  /// Get product detail by ID
  Future<Map<String, dynamic>?> getProductDetail(
      {required String productId}) async {
    try {
      utilityController.setLoadingState(true);
debugPrint(  '[BannerController] Fetching product detail for ID: $productId');

      // Query string for product detail
      const String query = '''
        fragment Asset on Asset {
          id
          width
          height
          name
          preview
          focalPoint {
            x
            y
            __typename
          }
          __typename
        }
        
        fragment Options on ProductOption {
          id
          code
          name
          __typename
        }
        
        query GetProductDetail(\$id: ID!) {
          product(id: \$id) {
            id
            name
            description
            variants {
              id
              name
              stockLevel
              options {
                ...Options
              }
              featuredAsset {
                ...Asset
              }
              price
              priceWithTax
              currencyCode
              languageCode
              assets {
                name
                preview
              }
              sku
              customFields {
                shadowPrice
                __typename
              }
              __typename
            }
            featuredAsset {
              ...Asset
              __typename
            }
            assets {
              ...Asset
              __typename
            }
            collections {
              id
              slug
              breadcrumbs {
                id
                name
                slug
                __typename
              }
              __typename
            }
            __typename
          }
        }
      ''';

      final result = await GraphqlService.client.value.query(
        graphql.QueryOptions(
          document: gql(query),
          variables: {'id': productId},
          fetchPolicy: graphql.FetchPolicy.networkOnly,
          errorPolicy: graphql.ErrorPolicy.all,
        ),
      );

      if (result.hasException) {
debugPrint(  '[BannerController] GetProductDetail Exception: ${result.exception}');
        utilityController.setLoadingState(false);
        return null;
      }

      final productData = result.data?['product'];
      if (productData != null) {
        productDetail.value = productData as Map<String, dynamic>;
debugPrint(  '[BannerController] Product detail fetched successfully: ${productData['name']}');
        utilityController.setLoadingState(false);
        return productData;
      } else {
debugPrint('[BannerController] No product data found');
        utilityController.setLoadingState(false);
        return null;
      }
    } catch (e) {
debugPrint('[BannerController] Get product detail error: $e');
      utilityController.setLoadingState(false);
      return null;
    }
  }

  /// Handle customer data not found - clear cache and logout (fallback method)
  Future<void> _handleCustomerDataNotFound() async {
    try {
      debugPrint('[BannerController] Handling customer data not found - clearing cache and logging out...');

      // Clear authentication tokens
      await GraphqlService.clearToken('auth');
      await GraphqlService.clearToken('channel');

      // Show message to user
      ErrorDialog.show(
        title: 'Session Expired',
        message: 'No customer data found. Please login again.',
      );

      // Navigate to login page
      Get.offAllNamed('/login');

      debugPrint('[BannerController] User logged out due to customer data not found');
    } catch (e) {
      debugPrint('[BannerController] Error handling customer data not found: $e');
      // Still navigate to login even if cleanup fails
      Get.offAllNamed('/login');
    }
  }
}
