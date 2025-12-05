import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart'
    show Context, HttpLinkHeaders, QueryResult, gql;
import 'package:flutter/foundation.dart';
import '../../graphql/banner.graphql.dart';
import '../../graphql/cart.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
// import '../../utils/html_utils.dart'; // Unused import
import '../../utils/price_formatter.dart';
import '../../services/in_app_update_service.dart';
import '../../services/analytics_service.dart';
import '../../widgets/error_dialog.dart';
import 'bannermodels.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';
import '../cart/Cartcontroller.dart';
import '../cart/cartmodels.dart';
import '../order/ordercontroller.dart';
import '../order/ordermodels.dart';
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
  final RxList<BannerModel> bannerList = <BannerModel>[].obs;

  // ============================================================================
  // SEARCH FUNCTIONALITY
  // ============================================================================
  final RxList<SearchItemModel> searchResults = <SearchItemModel>[].obs;
  final RxInt totalItems = 0.obs;


  // ============================================================================
  // FAVORITES FUNCTIONALITY
  // ============================================================================
  final RxList<FavoriteItemModel> favoritesList = <FavoriteItemModel>[].obs;
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
  final Rx<LoyaltyPointsConfigModel?> loyaltyPointsConfig =
      Rx<LoyaltyPointsConfigModel?>(null);
  final Rx<AppUpdateModel?> appUpdateInfo = Rx<AppUpdateModel?>(null);

  // ============================================================================
  // COUPON CODE FUNCTIONALITY
  // ============================================================================
  final RxList<CouponCodeModel> availableCouponCodes = <CouponCodeModel>[].obs;
  final RxList<String> appliedCouponCodes = <String>[].obs;
  final RxBool couponCodesLoaded = false.obs;

  // Track products added by each coupon: Map<couponCode, Map<variantId, quantity>>
  final RxMap<String, Map<String, int>> couponAddedProducts =
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
        List<BannerModel> fetchedBanners =
            jsonList.map((json) => BannerModel.fromJson(json)).toList();

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
          items.map((e) => SearchItemModel.fromJson(e)).toList();

      // Filter to show only unique products (not variants)
      // Group by productId and keep only the first variant for each product
      final Map<String, SearchItemModel> uniqueProducts = {};
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
      utilityController.setLoadingState(false);

      final res = await GraphqlService.client.value.mutate$ToggleFavorite(
        Options$Mutation$ToggleFavorite(
          variables: Variables$Mutation$ToggleFavorite(
            productId: productId,
          ),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to update favorite')) {
        utilityController.setLoadingState(false);
        return false;
      }

      final toggleResult = res.data?['toggleFavorite'];

      if (toggleResult != null) {
        final result = ToggleFavoriteResult.fromJson(toggleResult);
        favoritesList.assignAll(result.items);
        favoritesTotalItems.value = result.totalItems;

        // Update favorite product IDs set
        favoriteProductIds.clear();
        favoriteProductIds.addAll(result.items.map((item) => item.product.id));

debugPrint(            '[BannerController] Toggle favorite success. Total favorites: ${result.totalItems}');
        
        // Refresh customer favorites to ensure UI is up to date
        await getCustomerFavorites();
        
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
debugPrint('[BannerController] Toggle favorite error: $e');
      handleException(e, customErrorMessage: 'Failed to update favorite');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Get customer favorites
  Future<void> getCustomerFavorites() async {
    try {
      utilityController.setLoadingState(false);

      final res = await GraphqlService.client.value.query$GetCustomerFavorites(
        Options$Query$GetCustomerFavorites(
          fetchPolicy: graphql.FetchPolicy.noCache, // Don't use cache at all
          errorPolicy: graphql.ErrorPolicy
              .ignore, // Ignore errors and try to process data anyway
        ),
      );

      // Check if this is just a cache miss exception (non-fatal)
      bool isCacheMissException = false;
      if (res.hasException) {
        final exception = res.exception;
        final exceptionString = exception?.toString() ?? '';

        isCacheMissException = exceptionString.contains('CacheMissException') ||
            exceptionString.contains('cache.readQuery') ||
            exceptionString.contains('Round trip cache re-read failed');

        if (isCacheMissException) {
          // Cache miss is expected and non-fatal - proceed to process data
debugPrint( '[BannerController] Cache miss detected (non-fatal) - proceeding with data processing');
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
          final favorites = FavoritesModel.fromJson(favoritesData);
          favoritesList.assignAll(favorites.items);
          favoritesTotalItems.value = favorites.totalItems;

          // Update favorite product IDs set
          favoriteProductIds.clear();
          favoriteProductIds
              .addAll(favorites.items.map((item) => item.product.id));

debugPrint('[BannerController] Fetched ${favorites.totalItems} favorites');

          // Debug: Log image URLs
          for (var _ in favorites.items) {
            // Logging is commented out, so variable is unused
          }
        } else {
          // No favorites data, clear the list
          favoritesList.clear();
          favoritesTotalItems.value = 0;
          favoriteProductIds.clear();
debugPrint('[BannerController] No favorites data found');
        }
      } else {
        // Customer not logged in or not a Customer type, clear favorites
        favoritesList.clear();
        favoritesTotalItems.value = 0;
        favoriteProductIds.clear();
debugPrint(  '[BannerController] Active customer is null or not a Customer type');
        
        // Clear cache and logout when customer data is null
        try {
          final customerController = Get.find<CustomerController>();
          await customerController.handleCustomerDataNotFound();
        } catch (e) {
          // If CustomerController is not found, handle logout directly
          debugPrint('[BannerController] CustomerController not found, handling logout directly: $e');
          await _handleCustomerDataNotFound();
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
      utilityController.setLoadingState(false);

      final res =
          await GraphqlService.client.value.query$GetFrequentlyOrderedProducts(
        Options$Query$GetFrequentlyOrderedProducts(),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load frequently ordered products')) {
        utilityController.setLoadingState(false);
        return;
      }

      final products = res.parsedData?.frequentlyOrderedProducts ?? [];
      frequentlyOrderedProducts.assignAll(products);

debugPrint( '[BannerController] Fetched ${products.length} frequently ordered products');
      utilityController.setLoadingState(false);
    } catch (e) {
debugPrint(  '[BannerController] Get frequently ordered products error: $e');
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
            LoyaltyPointsConfigModel.fromJson(configData);
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
      final coupon = availableCouponCodes.firstWhere(
        (c) => c.couponCode.toUpperCase() == couponCode.toUpperCase(),
        orElse: () => CouponCodeModel(
          id: '',
          name: '',
          couponCode: '',
          enabled: false,
          createdAt: '',
          updatedAt: '',
          description: '',
          startsAt: '',
          endsAt: '',
          perCustomerUsageLimit: 0,
          usageLimit: 0,
          actions: [],
          conditions: [],
        ),
      );

      if (coupon.id.isEmpty) {
debugPrint('[BannerController] ❌ Coupon not found: $couponCode');
debugPrint('[BannerController] Available coupons: ${availableCouponCodes.map((c) => c.couponCode).toList()}');
        return [];
      }

debugPrint('[BannerController] ✅ Found coupon: ${coupon.name} (${coupon.couponCode})');
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
              } else if (arg.value is String) {
                final stringValue = arg.value as String;
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
            return CouponCodeModel.fromJson(json);
          }).toList();

debugPrint(  '[BannerController] ✅ Successfully converted ${fetchedCoupons.length} coupons');

          availableCouponCodes.assignAll(fetchedCoupons);
          couponCodesLoaded.value = true;

debugPrint(  '[BannerController] ✅ Updated availableCouponCodes list with ${availableCouponCodes.length} items');
debugPrint('[BannerController] ✅ Set couponCodesLoaded to true');

          // Debug print each coupon details
          for (int i = 0; i < fetchedCoupons.length; i++) {
            final coupon = fetchedCoupons[i];
debugPrint(  '[BannerController] Coupon $i: ${coupon.name} (Code: ${coupon.couponCode})');
debugPrint('[BannerController] - ID: ${coupon.id}');
debugPrint('[BannerController] - Enabled: ${coupon.enabled}');
            // final sanitizedDescription = HtmlUtils.stripHtmlTags(coupon.description); // Unused variable
debugPrint('[BannerController] - Starts At: ${coupon.startsAt}');
debugPrint('[BannerController] - Ends At: ${coupon.endsAt}');
debugPrint(  '[BannerController] - Actions count: ${coupon.actions.length}');
debugPrint(  '[BannerController] - Conditions count: ${coupon.conditions.length}');

            if (coupon.products != null) {
debugPrint
  (
                  '[BannerController] - Products count: ${coupon.products!.length}');
              for (int j = 0; j < coupon.products!.length; j++) {
                // final product = coupon.products![j]; // Unused variable
debugPrint(  '[BannerController] - Product $j: ${coupon.products![j].name} (Variant: ${coupon.products![j].productVariantId}, Qty: ${coupon.products![j].quantity})');
              }
            } else {
debugPrint('[BannerController] - No products field found');
            }
          }
        } catch (conversionError) {
debugPrint(  '[BannerController] ❌ Error converting items to CouponCodeModel: $conversionError');
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
      // First check if coupon code exists in available list
      final coupon = availableCouponCodes.firstWhere(
        (c) => c.couponCode.toLowerCase() == couponCode.toLowerCase(),
        orElse: () => CouponCodeModel(
          id: '',
          name: '',
          couponCode: '',
          enabled: false,
          createdAt: '',
          updatedAt: '',
          actions: [],
          conditions: [],
        ),
      );

      if (coupon.id.isEmpty) {
        return {
          'valid': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }

      // Check if coupon is enabled
      if (!coupon.enabled) {
        return {
          'valid': false,
          'message': 'Coupon code is disabled',
          'error': 'COUPON_DISABLED'
        };
      }

      // Check if coupon has expired
      if (coupon.endsAt != null) {
        final endDate = DateTime.parse(coupon.endsAt!);
        if (DateTime.now().isAfter(endDate)) {
          return {
            'valid': false,
            'message': 'Coupon code has expired',
            'error': 'COUPON_EXPIRED'
          };
        }
      }

      // Check if coupon has started
      if (coupon.startsAt != null) {
        final startDate = DateTime.parse(coupon.startsAt!);
        if (DateTime.now().isBefore(startDate)) {
          return {
            'valid': false,
            'message': 'Coupon code is not yet active',
            'error': 'COUPON_NOT_ACTIVE'
          };
        }
      }

      // Check if already applied
      if (appliedCouponCodes.contains(couponCode)) {
        return {
          'valid': false,
          'message': 'Coupon code already applied',
          'error': 'COUPON_ALREADY_APPLIED'
        };
      }

      // Check if another coupon is already applied (one coupon per order policy)
      if (appliedCouponCodes.isNotEmpty) {
        return {
          'valid': false,
          'message':
              'Only one coupon code can be applied per order. Please remove the current coupon first.',
          'error': 'ANOTHER_COUPON_APPLIED',
          'appliedCoupons': appliedCouponCodes.toList()
        };
      }

      // Check minimum order amount conditions
      final minimumAmountValidation = await _validateMinimumOrderAmount(coupon);
      if (!minimumAmountValidation['valid']) {
        return {
          'valid': false,
          'message': minimumAmountValidation['message'],
          'error': 'MINIMUM_ORDER_AMOUNT_NOT_MET',
          'requiredAmount': minimumAmountValidation['requiredAmount'],
          'currentAmount': minimumAmountValidation['currentAmount']
        };
      }

      return {
        'valid': true,
        'message': 'Coupon code is valid',
        'coupon': coupon
      };
    } catch (e) {
debugPrint('[BannerController] Validate coupon code error: $e');
      return {
        'valid': false,
        'message': 'Error validating coupon code',
        'error': 'VALIDATION_ERROR'
      };
    }
  }

  /// Validate minimum order amount for coupon
  Future<Map<String, dynamic>> _validateMinimumOrderAmount(
      CouponCodeModel coupon) async {
    try {
debugPrint(  '[BannerController] Validating minimum order amount for coupon: ${coupon.couponCode}');

      // Get current cart total
      final cartTotal = await _getCurrentCartTotal();
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
              // Handle both string and numeric values for amount
              double requiredAmount;
              if (arg.value is String) {
                requiredAmount = double.tryParse(arg.value as String) ?? 0.0;
              } else if (arg.value is num) {
                requiredAmount = (arg.value as num).toDouble();
              } else {
debugPrint(  '[BannerController] Invalid amount type: ${arg.value.runtimeType}');
                continue;
              }

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

  /// Get current cart total
  Future<double?> _getCurrentCartTotal() async {
    try {
      const query = '''
        query GetActiveOrder {
          activeOrder {
            id
            totalWithTax
            subTotalWithTax
          }
        }
      ''';

      final res = await GraphqlService.client.value.query(
        graphql.QueryOptions(
          document: graphql.gql(query),
        ),
      );

      if (res.hasException) {
debugPrint(  '[BannerController] Error getting cart total: ${res.exception}');
        return null;
      }

      final activeOrder = res.data?['activeOrder'];
      if (activeOrder != null) {
        final totalWithTax = (activeOrder['totalWithTax'] as num?)?.toDouble();
debugPrint('[BannerController] Cart total with tax: $totalWithTax');
        return totalWithTax;
      }

      return null;
    } catch (e) {
debugPrint('[BannerController] Exception getting cart total: $e');
      return null;
    }
  }

  /// Format price for display
  String _formatPrice(int priceInCents) {
    return PriceFormatter.formatPrice(priceInCents);
  }

  /// Get minimum order amount from coupon conditions
  int? _getCouponMinimumAmount(CouponCodeModel coupon) {
    try {
      for (final condition in coupon.conditions) {
        if (condition.code == 'minimum_order_amount') {
          for (final arg in condition.args) {
            if (arg.name == 'amount') {
              final value = arg.value;
              if (value is num) {
                return value.toInt();
              } else if (value is String) {
                return int.tryParse(value);
              }
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
  List<CouponCodeModel> getEligibleCoupons(int subTotalInPaise) {
    final eligibleCoupons = <CouponCodeModel>[];
    
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
  int getRequiredAmount(CouponCodeModel coupon) {
    final minimumAmount = _getCouponMinimumAmount(coupon);
    return minimumAmount ?? 0;
  }

  /// Apply coupon code to active order with proper validation
  Future<Map<String, dynamic>> applyCouponCode(String couponCode) async {
    try {
      utilityController.setLoadingState(true);

      // First validate the coupon code
      final validation = await validateCouponCode(couponCode);
      if (!validation['valid']) {
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': validation['message'],
          'error': validation['error']
        };
      }

      final res = await GraphqlService.client.value.mutate$ApplyCouponCode(
        Options$Mutation$ApplyCouponCode(
          variables: Variables$Mutation$ApplyCouponCode(input: couponCode),
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to apply coupon code')) {
        utilityController.setLoadingState(false);
        return {
          'success': false,
          'message': 'Network error occurred',
          'error': 'NETWORK_ERROR'
        };
      }

      final result = res.parsedData?.applyCouponCode;

      if (result != null) {
        // Check for various error types using pattern matching
        if (result
            is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeInvalidError) {
          utilityController.setLoadingState(false);
          return {
            'success': false,
            'message': 'Invalid coupon code',
            'error': 'INVALID_COUPON'
          };
        }

        if (result
            is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeExpiredError) {
          utilityController.setLoadingState(false);
          return {
            'success': false,
            'message': 'Coupon code has expired',
            'error': 'COUPON_EXPIRED'
          };
        }

        if (result
            is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeLimitError) {
          utilityController.setLoadingState(false);
          return {
            'success': false,
            'message': 'Coupon usage limit reached',
            'error': 'COUPON_LIMIT'
          };
        }

        // Success - coupon applied
        if (result is Mutation$ApplyCouponCode$applyCouponCode$$Order) {
          // Ensure only one coupon is applied (one coupon per order policy)
          appliedCouponCodes.clear(); // Remove any existing coupons
          appliedCouponCodes.add(couponCode); // Add the new coupon

debugPrint(  '[BannerController] Coupon code applied successfully: $couponCode');
          
          // Update both cart and order controllers directly from the response
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            final resultJson = result.toJson();
            
            // Validate that the result has order lines before updating
            final hasLines = resultJson['lines'] != null && 
                           (resultJson['lines'] as List).isNotEmpty;
            
            if (hasLines) {
              // Update CartController
              cartController.cart.value = Order.fromJson(resultJson);
debugPrint('[BannerController] CartController updated directly from coupon response');
              
              // Update OrderController
              orderController.currentOrder.value = OrderModel.fromJson(resultJson);
debugPrint('[BannerController] OrderController updated directly from coupon response');
            } else {
debugPrint('[BannerController] Warning: Coupon response has no order lines, preserving current cart');
              // Don't update if response has no lines - preserve current cart
              // This prevents clearing the cart when server returns incomplete data
            }
          } catch (e) {
debugPrint('[BannerController] Could not update controllers directly: $e');
            // Fallback: refresh both controllers while preserving cart state
            try {
              final cartController = Get.find<CartController>();
              final orderController = Get.find<OrderController>();
              
              // Preserve previous cart state before refresh to prevent empty UI
              final previousCart = cartController.cart.value;
              
              // Add a small delay to ensure server has processed the coupon
              await Future.delayed(Duration(milliseconds: 300));
              
              // Refresh controllers
              final refreshSuccess = await cartController.getActiveOrder();
              await orderController.getActiveOrder(skipLoading: true);
              
              // If cart became null or empty after refresh and we had a previous cart, restore it
              // This prevents showing empty cart during the brief moment of refresh
              final currentCart = cartController.cart.value;
              final cartIsEmpty = currentCart == null || 
                                 currentCart.lines.isEmpty ||
                                 currentCart.totalQuantity == 0;
              
              if ((!refreshSuccess || cartIsEmpty) && previousCart != null) {
                // Only restore if previous cart had items
                if (previousCart.lines.isNotEmpty && previousCart.totalQuantity > 0) {
                  cartController.cart.value = previousCart;
debugPrint('[BannerController] Restored previous cart to prevent empty UI');
                  // Try one more time to get the updated cart after a delay
                  await Future.delayed(Duration(milliseconds: 500));
                  await cartController.getActiveOrder();
                }
              }
              
debugPrint('[BannerController] Controllers refreshed via getActiveOrder');
            } catch (refreshError) {
debugPrint('[BannerController] Failed to refresh controllers: $refreshError');
              // If refresh failed, try to restore cart state
              try {
                final cartController = Get.find<CartController>();
                final previousCart = cartController.cart.value;
                // Try to get the cart one more time
                await cartController.getActiveOrder();
                // If still empty, restore previous cart
                if (cartController.cart.value == null && previousCart != null) {
                  cartController.cart.value = previousCart;
                }
              } catch (e) {
                // Ignore errors during recovery
              }
            }
          }
          
          utilityController.setLoadingState(false);
          return {
            'success': true,
            'message': 'Coupon code applied successfully',
            'couponCode': couponCode,
            'orderTotal': result.total
          };
        }
      }

      utilityController.setLoadingState(false);
      return {
        'success': false,
        'message': 'Unknown error occurred',
        'error': 'UNKNOWN_ERROR'
      };
    } catch (e) {
debugPrint('[BannerController] Apply coupon code error: $e');
      handleException(e, customErrorMessage: 'Failed to apply coupon code');
      utilityController.setLoadingState(false);
      return {
        'success': false,
        'message': 'Error applying coupon code: $e',
        'error': 'APPLICATION_ERROR'
      };
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
      final cart = await _getCurrentCart();
      if (cart == null) {
debugPrint(  '[BannerController] No active cart found - cannot remove products');
        return false;
      }

      final cartLines = cart['lines'] as List<dynamic>? ?? [];
debugPrint(  '[BannerController] Current cart has ${cartLines.length} order lines');

      int removedCount = 0;
      final cartController = Get.find<CartController>();
      
      for (final entry in productsToRemove.entries) {
        final variantId = entry.key;
        final quantityToRemove = entry.value;
debugPrint(  '[BannerController] Processing variant $variantId, quantity to remove: $quantityToRemove');
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineData = line as Map<String, dynamic>;
          final lineId = lineData['id'] as String;
          final currentQuantity = lineData['quantity'] as int? ?? 0;
          final productVariant =
              lineData['productVariant'] as Map<String, dynamic>;
          final variantIdFromCart = productVariant['id'] as String;

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
                
                // Update controllers after removal
                try {
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
debugPrint('[BannerController] OrderController updated after removing line');
                } catch (e) {
debugPrint('[BannerController] Could not update OrderController: $e');
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
                
                // Update controllers after quantity adjustment
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
        final updatedCart = await _getCurrentCart();
        if (updatedCart != null) {
          // final updatedLines = updatedCart['lines'] as List<dynamic>? ?? []; // Unused variable
debugPrint(  '[BannerController] Cart after removal has ${(updatedCart['lines'] as List<dynamic>? ?? []).length} lines');
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
  Future<dynamic> _getCurrentCart() async {
    try {
debugPrint('[BannerController] Fetching current cart...');

      const query = '''
        query GetActiveOrder {
          activeOrder {
            id
            lines {
              id
              productVariant {
                id
                name
              }
              quantity
            }
          }
        }
      ''';

      final res = await GraphqlService.client.value.query(
        graphql.QueryOptions(
          document: graphql.gql(query),
        ),
      );

      if (res.hasException) {
debugPrint(  '[BannerController] Error getting current cart: ${res.exception}');
        return null;
      }

      final activeOrder = res.data?['activeOrder'];
      if (activeOrder != null) {
debugPrint(  '[BannerController] ✓ Found active order: ${activeOrder['id']}');
debugPrint(  '[BannerController] Order has ${activeOrder['lines']?.length ?? 0} lines');

        // Debug each line
        if (activeOrder['lines'] != null) {
          for (int i = 0; i < activeOrder['lines'].length; i++) {
            // ignore: unused_local_variable
            final lineData = activeOrder['lines'][i];
debugPrint(  '[BannerController] Line $i: ID=${lineData['id']}, Variant=${lineData['productVariant']['id']}, Name=${lineData['productVariant']['name']}, Qty=${lineData['quantity']}');
          }
        }
      } else {
debugPrint('[BannerController] ⚠ No active order found');
      }

      return activeOrder;
    } catch (e) {
debugPrint('[BannerController] Exception getting current cart: $e');
      return null;
    }
  }

  /// Remove order line by ID
  Future<bool> _removeOrderLineById(String orderLineId) async {
    try {
debugPrint(  '[BannerController] Attempting to remove order line: $orderLineId');

      const mutation = '''
        mutation RemoveOrderLine(\$orderLineId: ID!) {
          removeOrderLine(orderLineId: \$orderLineId) {
            __typename
            ... on Order {
              id
            }
            ... on ErrorResult {
              message
            }
          }
        }
      ''';

      final res = await GraphqlService.client.value.mutate(
        graphql.MutationOptions(
          document: graphql.gql(mutation),
          variables: {'orderLineId': orderLineId},
        ),
      );

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to remove item from cart')) {
        return false;
      }

      final result = res.data?['removeOrderLine'];
      if (result != null) {
        if (result['__typename'] == 'Order') {
debugPrint(  '[BannerController] ✓ Successfully removed order line $orderLineId');
debugPrint('[BannerController] Updated order ID: ${result['id']}');
          
          // Update both controllers after removal
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            final resultJson = result as Map<String, dynamic>;
            
            // Update CartController
            cartController.cart.value = Order.fromJson(resultJson);
debugPrint('[BannerController] CartController updated after removing line');
            
            // Update OrderController
            orderController.currentOrder.value = OrderModel.fromJson(resultJson);
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
debugPrint(  '[BannerController] ✗ Failed to remove order line $orderLineId: ${result['message']}');
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
        utilityController.setLoadingState(false);
        return false;
      }

      final result = res.parsedData?.removeCouponCode;

      if (result != null) {
        appliedCouponCodes.remove(couponCode);

debugPrint(  '[BannerController] Coupon code removed successfully: $couponCode');
        
        // Update both cart and order controllers directly from the response
        try {
          final cartController = Get.find<CartController>();
          final orderController = Get.find<OrderController>();
          // Result is Fragment$Cart which contains full order data
          final resultJson = result.toJson();
          if (resultJson.containsKey('id')) {
            // Update CartController
            cartController.cart.value = Order.fromJson(resultJson);
debugPrint('[BannerController] CartController updated directly from removeCouponCode response');
            
            // Update OrderController
            orderController.currentOrder.value = OrderModel.fromJson(resultJson);
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
            Options$Mutation$AddToCart(
              variables: Variables$Mutation$AddToCart(
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
            if (result is Mutation$AddToCart$addItemToOrder$$Order) {
debugPrint(  '[BannerController] Successfully added $productName to cart');
              
              // Update both controllers immediately after each product is added
              // This prevents the "cart is empty" UI issue
              try {
                final cartController = Get.find<CartController>();
                final orderController = Get.find<OrderController>();
                final resultJson = result.toJson();
                
                // Update CartController
                cartController.cart.value = Order.fromJson(resultJson);
debugPrint('[BannerController] CartController updated after adding $productName');
                
                // Update OrderController
                orderController.currentOrder.value = OrderModel.fromJson(resultJson);
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
                is Mutation$AddToCart$addItemToOrder$$InsufficientStockError) {
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

        // Store the products added by this coupon with quantities
        final productsMap = <String, int>{};
        for (final product in addedProducts) {
          final variantId = product['productVariantId']?.toString();
          final quantity = product['quantity'] as int? ?? 1;
          if (variantId != null) {
            productsMap[variantId] = quantity;
          }
        }
        couponAddedProducts[couponCode] = productsMap;
debugPrint(  '[BannerController] Tracked ${productsMap.length} products for coupon $couponCode: $productsMap');
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
            final cart = await _getCurrentCart();
            if (cart != null) {
              final cartLines = cart['lines'] as List<dynamic>? ?? [];
              for (final line in cartLines) {
                final lineData = line as Map<String, dynamic>;
                final lineId = lineData['id'] as String;
                final productVariant = lineData['productVariant'] as Map<String, dynamic>;
                final variantIdFromCart = productVariant['id'] as String;
                
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

  /// Apply coupon code with products (add products first, then apply coupon)
  Future<Map<String, dynamic>> applyCouponCodeWithProducts(
      String couponCode) async {
    try {
debugPrint(  '[BannerController] Starting applyCouponCodeWithProducts for: $couponCode');

      // Check if coupon has products
      final hasProducts = hasCouponProducts(couponCode);
debugPrint(  '[BannerController] Coupon $couponCode has products: $hasProducts');

      Map<String, dynamic>? addResult;
      
      // If coupon has products, add them to cart first
      if (hasProducts) {
debugPrint(  '[BannerController] Step 1: Adding coupon products to cart...');
        addResult = await addCouponProductsToCart(couponCode);

        // If adding products fails OR if ANY product failed, don't apply coupon
        // addResult['success'] will be false if any product failed (due to rollback)
        if (!addResult['success']) {
debugPrint(  '[BannerController] ❌ Failed to add products to cart: ${addResult['message']}');
debugPrint(  '[BannerController] ❌ Not applying coupon code due to product addition failure');
          
          // Check if rollback was performed
          final rollbackPerformed = addResult['rollbackPerformed'] == true;
          final failedCount = addResult['totalFailed'] ?? 0;
          final addedCount = addResult['totalAdded'] ?? 0;
          
          String errorMessage = 'Failed to add coupon products to cart. Coupon not applied.';
          if (rollbackPerformed && addedCount > 0) {
            errorMessage = 'Some coupon products could not be added. Added products have been removed. Coupon not applied.';
          } else if (failedCount > 0) {
            errorMessage = 'Failed to add all coupon products. Coupon not applied.';
          }
          
          return {
            'success': false,
            'message': errorMessage,
            'error': 'PRODUCT_ADDITION_FAILED',
            'addResult': addResult,
            'rollbackPerformed': rollbackPerformed,
          };
        }
debugPrint(  '[BannerController] ✅ Successfully added coupon products to cart');
      } else {
debugPrint(  '[BannerController] Coupon has no products, skipping product addition');
        addResult = {
          'success': true,
          'addedProducts': [],
          'message': 'No products to add',
        };
      }

debugPrint('[BannerController] Step 2: Applying coupon code...');
      // Then apply the coupon code
      final couponResult = await applyCouponCode(couponCode);

      if (couponResult['success']) {
debugPrint(  '[BannerController] Successfully applied coupon with products for: $couponCode');
        
        // Both controllers are already updated by applyCouponCode
        // No need to call getActiveOrder() which might fetch stale data
        // The direct updates in applyCouponCode are sufficient
        
        return {
          'success': true,
          'message': hasProducts 
              ? 'Coupon products added and coupon applied successfully'
              : 'Coupon applied successfully',
          'addedProducts': addResult['addedProducts'] ?? [],
          'couponApplied': true,
          'affectedProducts': couponResult['affectedProducts'],
          'orderTotal': couponResult['orderTotal'],
        };
      } else {
debugPrint(  '[BannerController] Products added but failed to apply coupon: ${couponResult['message']}');

        // ROLLBACK: Remove the products that were added since coupon application failed
        if (hasProducts) {
debugPrint(  '[BannerController] Rolling back: Removing added products due to coupon application failure...');
          final rollbackResult = await _rollbackAddedProducts(couponCode);

          if (rollbackResult['success']) {
debugPrint(  '[BannerController] Successfully rolled back added products');
          } else {
debugPrint(  '[BannerController] Failed to rollback added products: ${rollbackResult['message']}');
          }
        }

        return {
          'success': false,
          'message':
              'Failed to apply coupon: ${couponResult['message']}.${hasProducts ? ' Added products have been removed.' : ''}',
          'addedProducts': addResult['addedProducts'] ?? [],
          'couponApplied': false,
          'couponError': couponResult['message'],
          'rollbackPerformed': hasProducts,
        };
      }
    } catch (e) {
debugPrint('[BannerController] Apply coupon with products error: $e');

      // ROLLBACK: If there's an exception, try to remove any products that might have been added
debugPrint(  '[BannerController] Exception occurred, attempting rollback...');
      try {
        await _rollbackAddedProducts(couponCode);
debugPrint(  '[BannerController] Rollback completed');
      } catch (rollbackError) {
debugPrint(  '[BannerController] Rollback failed with error: $rollbackError');
      }

      return {
        'success': false,
        'message':
            'Error applying coupon with products: $e. Any added products have been removed.',
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
      final cart = await _getCurrentCart();
      if (cart == null) {
debugPrint(  '[BannerController] No active cart found - cannot rollback products');
        return {
          'success': false,
          'message': 'No active cart found',
          'removedCount': 0
        };
      }

      final cartLines = cart['lines'] as List<dynamic>? ?? [];
debugPrint(  '[BannerController] Current cart has ${cartLines.length} order lines');

      int removedCount = 0;
      final failedRemovals = <String>[];
      final cartController = Get.find<CartController>();

      for (final entry in productsToRemove.entries) {
        final variantId = entry.key;
        final quantityToRemove = entry.value;
debugPrint(  '[BannerController] Processing variant $variantId, quantity to remove: $quantityToRemove for rollback');
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineData = line as Map<String, dynamic>;
          final lineId = lineData['id'] as String;
          final currentQuantity = lineData['quantity'] as int? ?? 0;
          final productVariant =
              lineData['productVariant'] as Map<String, dynamic>;
          final variantIdFromCart = productVariant['id'] as String;

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
