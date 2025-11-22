import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart'
    show Context, HttpLinkHeaders, QueryResult, gql;

import '../../graphql/banner.graphql.dart';
import '../../graphql/cart.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../../utils/html_utils.dart';
import '../../utils/price_formatter.dart';
import '../../services/in_app_update_service.dart';
import '../../services/analytics_service.dart';
import '../../widgets/error_dialog.dart';
import 'bannermodels.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';

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

  // Track products added by each coupon
  final RxMap<String, List<String>> couponAddedProducts =
      <String, List<String>>{}.obs;

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

    print('🔍 [DEBUG] Starting product search...');
    print('📥 Input term: "$term"');

    // If search term is empty, clear results and return
    if (term.isEmpty) {
      print('⚠️ [DEBUG] Empty search term — clearing results.');
      searchResults.clear();
      totalItems.value = 0;
      return;
    }

    try {
      utilityController.setLoadingState(true);
      print('⏳ [DEBUG] Loading state set to true.');

      final inputObj = Input$SearchInput(term: term);
      final variables = Variables$Query$Search(input: inputObj);
      print('🧩 [DEBUG] Created GraphQL variables: $variables');

      final res = await GraphqlService.client.value.query$Search(
        Options$Query$Search(variables: variables),
      );

      print('🛰️ [DEBUG] GraphQL query executed.');

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to search products')) {
        searchResults.clear();
        totalItems.value = 0;
        utilityController.setLoadingState(false);
        return;
      }

      final items = res.data?['search']['items'] as List<dynamic>? ?? [];
      final total = res.data?['search']['totalItems'] as int? ?? 0;

      print('📊 [DEBUG] Total items fetched: $total');
      print('🧾 [DEBUG] Raw items length: ${items.length}');

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
      print('✅ [DEBUG] Unique products: ${uniqueProductList.length} (from ${fetchedItems.length} variants)');

      searchResults.assignAll(uniqueProductList);
      totalItems.value = uniqueProductList.length;

      // Track search event
      if (term.isNotEmpty) {
        AnalyticsService().logSearch(searchTerm: term);
      }

      print('✅ [DEBUG] Search results updated successfully.');
      utilityController.setLoadingState(false);
      print('🏁 [DEBUG] Loading state set to false.');
    } catch (e, stack) {
      print('💥 [DEBUG] Exception caught during search: $e');
      print('🪜 [DEBUG] Stack trace: $stack');
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

        debugPrint(
            '[BannerController] Toggle favorite success. Total favorites: ${result.totalItems}');
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
          debugPrint(
              '[BannerController] Cache miss detected (non-fatal) - proceeding with data processing');
        } else {
          // For other exceptions, log but still try to process data if available
          debugPrint(
              '[BannerController] GetCustomerFavorites Exception: ${res.exception}');
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

          debugPrint(
              '[BannerController] Fetched ${favorites.totalItems} favorites');

          // Debug: Log image URLs
          for (var item in favorites.items) {
            final imageUrl = item.product.featuredAsset?.preview;
            debugPrint(
                '[BannerController] Product: ${item.product.name}, Image: ${imageUrl ?? "NO IMAGE"}');
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
        debugPrint(
            '[BannerController] Active customer is null or not a Customer type');
      }

      utilityController.setLoadingState(false);
    } catch (e, stackTrace) {
      debugPrint('[BannerController] Get favorites error: $e');
      debugPrint('[BannerController] Stack trace: $stackTrace');
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

      debugPrint(
          '[BannerController] Fetched ${products.length} frequently ordered products');
      utilityController.setLoadingState(false);
    } catch (e) {
      debugPrint(
          '[BannerController] Get frequently ordered products error: $e');
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

        debugPrint(
            '[BannerController] Loyalty points applied successfully: ${loyaltyPointsUsed.value}');
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
        debugPrint(
            '[BannerController] Loyalty points config loaded successfully');
        debugPrint(
            '[BannerController] Rupees per point: ${loyaltyPointsConfig.value?.rupeesPerPoint}');
        debugPrint(
            '[BannerController] Points per rupee: ${loyaltyPointsConfig.value?.pointsPerRupee}');
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
        debugPrint('[BannerController] Coupon not found: $couponCode');
        return [];
      }

      // Extract products from coupon actions and conditions
      final products = <Map<String, dynamic>>[];

      // Check actions for product information
      for (final action in coupon.actions) {
        debugPrint('[BannerController] Action code: ${action.code}');
        if (action.code == 'add_products' ||
            action.code == 'contains_products') {
          for (final arg in action.args) {
            if (arg.name == 'productVariantIds' && arg.value is List) {
              final variantIds = arg.value as List<dynamic>;
              debugPrint(
                  '[BannerController] Found product variant IDs in action: $variantIds');

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
        debugPrint(
            '[BannerController] Condition args count: ${condition.args.length}');

        if (condition.code == 'contains_products') {
          debugPrint(
              '[BannerController] Processing contains_products condition');
          for (final arg in condition.args) {
            debugPrint(
                '[BannerController] Condition arg: ${arg.name} = ${arg.value} (type: ${arg.value.runtimeType})');

            // Check for different possible argument names
            if (arg.name == 'productVariantIds') {
              List<dynamic> variantIds = [];

              if (arg.value is List) {
                variantIds = arg.value as List<dynamic>;
                debugPrint(
                    '[BannerController] Found product variant IDs as List: $variantIds');
              } else if (arg.value is String) {
                final stringValue = arg.value as String;
                debugPrint(
                    '[BannerController] Found product variant IDs as String: $stringValue');

                // Try to parse string representation of list like "[542]" or "542,543"
                if (stringValue.startsWith('[') && stringValue.endsWith(']')) {
                  // Remove brackets and split by comma
                  final cleanString =
                      stringValue.substring(1, stringValue.length - 1);
                  variantIds =
                      cleanString.split(',').map((e) => e.trim()).toList();
                  debugPrint(
                      '[BannerController] Parsed variant IDs from brackets: $variantIds');
                } else if (stringValue.contains(',')) {
                  // Split by comma
                  variantIds =
                      stringValue.split(',').map((e) => e.trim()).toList();
                  debugPrint(
                      '[BannerController] Parsed variant IDs from comma-separated: $variantIds');
                } else {
                  // Single value
                  variantIds = [stringValue.trim()];
                  debugPrint(
                      '[BannerController] Parsed single variant ID: $variantIds');
                }
              }

              if (variantIds.isNotEmpty) {
                debugPrint(
                    '[BannerController] Processing ${variantIds.length} variant IDs');
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
              debugPrint(
                  '[BannerController] Found product IDs in condition: $productIds');

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
              debugPrint(
                  '[BannerController] Found products list in condition: $productsList');

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

      debugPrint(
          '[BannerController] Extracted ${products.length} products for coupon: $couponCode');
      return products;
    } catch (e) {
      debugPrint('[BannerController] Error getting coupon products: $e');
      return [];
    }
  }

  /// Check if a coupon has associated products
  bool hasCouponProducts(String couponCode) {
    final products = getCouponProducts(couponCode);
    return products.isNotEmpty;
  }

  /// Get available coupon codes
  Future<void> getCouponCodeList() async {
    try {
      debugPrint('[BannerController] ===== STARTING COUPON CODE LOADING =====');
      debugPrint('[BannerController] Setting loading state to true');
      utilityController.setLoadingState(false);

      debugPrint('[BannerController] GraphQL client status: Available');
      debugPrint(
          '[BannerController] GraphQL client value: ${GraphqlService.client.value}');
      debugPrint('[BannerController] Making GraphQL query: GetCouponCodeList');

      // Check if we have authentication token
      final authToken = GraphqlService.authToken;
      final channelToken = GraphqlService.channelToken;
      debugPrint(
          '[BannerController] Auth token available: ${authToken.isNotEmpty}');
      debugPrint(
          '[BannerController] Channel token available: ${channelToken.isNotEmpty}');
      if (authToken.isNotEmpty) {
        debugPrint('[BannerController] Auth token length: ${authToken.length}');
      } else {
        debugPrint(
            '[BannerController] ⚠️ No auth token available - this might cause GraphQL query to fail');
      }
      if (channelToken.isNotEmpty) {
        debugPrint(
            '[BannerController] Channel token length: ${channelToken.length}');
      } else {
        debugPrint(
            '[BannerController] ⚠️ No channel token available - this might cause GraphQL query to fail');
      }

      debugPrint('[BannerController] Executing GraphQL query...');

      // Try the query with retry logic
      QueryResult<Query$GetCouponCodeList>? res;
      int retryCount = 0;
      const maxRetries = 3;

      while (retryCount < maxRetries) {
        try {
          debugPrint(
              '[BannerController] Attempt ${retryCount + 1} of $maxRetries');

          res = await Future.any([
            GraphqlService.client.value.query$GetCouponCodeList(
              Options$Query$GetCouponCodeList(),
            ),
            Future.delayed(Duration(seconds: 15)).then((_) =>
                throw TimeoutException(
                    'Query timeout after 15 seconds', Duration(seconds: 15))),
          ]);

          debugPrint(
              '[BannerController] Query completed successfully on attempt ${retryCount + 1}');
          break; // Success, exit retry loop
        } catch (e) {
          retryCount++;
          debugPrint('[BannerController] Attempt ${retryCount} failed: $e');

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
        debugPrint(
            '[BannerController] Exception graphqlErrors: ${res.exception?.graphqlErrors}');
        debugPrint(
            '[BannerController] Exception linkException: ${res.exception?.linkException}');
      }

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load coupon codes')) {
        utilityController.setLoadingState(false);
        return;
      }

      debugPrint('[BannerController] ✅ No GraphQL exceptions');

      if (res.data != null) {
        debugPrint(
            '[BannerController] Raw response data keys: ${res.data!.keys.toList()}');
        debugPrint('[BannerController] Full response data: ${res.data}');
      } else {
        debugPrint('[BannerController] ❌ Response data is NULL');
      }

      final couponData = res.parsedData?.getCouponCodeList;
      debugPrint(
          '[BannerController] Parsed coupon data: ${couponData != null ? 'Available' : 'NULL'}');

      if (couponData != null) {
        final items = couponData.items;
        debugPrint('[BannerController] Coupon items count: ${items.length}');
        debugPrint(
            '[BannerController] Coupon items type: ${items.runtimeType}');

        if (items.isNotEmpty) {
          debugPrint('[BannerController] First coupon raw data:');
          debugPrint('[BannerController] ${items.first.toJson()}');

          // Check if items are properly structured
          debugPrint(
              '[BannerController] First item type: ${items.first.runtimeType}');
          debugPrint(
              '[BannerController] First item properties: ${items.first.toString()}');
        } else {
          debugPrint('[BannerController] ❌ No coupon items found in response');
        }

        try {
          final fetchedCoupons = items.map((item) {
            debugPrint(
                '[BannerController] Converting item to CouponCodeModel: ${item.runtimeType}');
            final json = item.toJson();
            debugPrint('[BannerController] Item JSON: $json');
            return CouponCodeModel.fromJson(json);
          }).toList();

          debugPrint(
              '[BannerController] ✅ Successfully converted ${fetchedCoupons.length} coupons');

          availableCouponCodes.assignAll(fetchedCoupons);
          couponCodesLoaded.value = true;

          debugPrint(
              '[BannerController] ✅ Updated availableCouponCodes list with ${availableCouponCodes.length} items');
          debugPrint('[BannerController] ✅ Set couponCodesLoaded to true');

          // Debug print each coupon details
          for (int i = 0; i < fetchedCoupons.length; i++) {
            final coupon = fetchedCoupons[i];
            debugPrint(
                '[BannerController] Coupon $i: ${coupon.name} (Code: ${coupon.couponCode})');
            debugPrint('[BannerController] - ID: ${coupon.id}');
            debugPrint('[BannerController] - Enabled: ${coupon.enabled}');
            final sanitizedDescription =
                HtmlUtils.stripHtmlTags(coupon.description);
            debugPrint(
                '[BannerController] - Description: $sanitizedDescription');
            debugPrint('[BannerController] - Starts At: ${coupon.startsAt}');
            debugPrint('[BannerController] - Ends At: ${coupon.endsAt}');
            debugPrint(
                '[BannerController] - Actions count: ${coupon.actions.length}');
            debugPrint(
                '[BannerController] - Conditions count: ${coupon.conditions.length}');
            // debugPrint('[BannerController] - Custom Fields: ${coupon.customFields}');

            if (coupon.products != null) {
              debugPrint(
                  '[BannerController] - Products count: ${coupon.products!.length}');
              for (int j = 0; j < coupon.products!.length; j++) {
                final product = coupon.products![j];
                debugPrint(
                    '[BannerController] - Product $j: ${product.name} (Variant: ${product.productVariantId}, Qty: ${product.quantity})');
              }
            } else {
              debugPrint('[BannerController] - No products field found');
            }
          }
        } catch (conversionError) {
          debugPrint(
              '[BannerController] ❌ Error converting items to CouponCodeModel: $conversionError');
          debugPrint('[BannerController] Stack trace: ${StackTrace.current}');
        }
      } else {
        debugPrint('[BannerController] ❌ Parsed coupon data is NULL');
        debugPrint(
            '[BannerController] Available coupon codes count: ${availableCouponCodes.length}');
        debugPrint(
            '[BannerController] Coupon codes loaded: ${couponCodesLoaded.value}');
      }

      debugPrint('[BannerController] Setting loading state to false');
      utilityController.setLoadingState(false);
      debugPrint(
          '[BannerController] ===== COUPON CODE LOADING COMPLETED =====');
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
      debugPrint(
          '[BannerController] Validating minimum order amount for coupon: ${coupon.couponCode}');

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
            debugPrint(
                '[BannerController] Condition arg: ${arg.name} = ${arg.value}');

            if (arg.name == 'amount') {
              // Handle both string and numeric values for amount
              double requiredAmount;
              if (arg.value is String) {
                requiredAmount = double.tryParse(arg.value as String) ?? 0.0;
              } else if (arg.value is num) {
                requiredAmount = (arg.value as num).toDouble();
              } else {
                debugPrint(
                    '[BannerController] Invalid amount type: ${arg.value.runtimeType}');
                continue;
              }

              debugPrint(
                  '[BannerController] Required minimum amount: $requiredAmount');

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
      debugPrint(
          '[BannerController] Error validating minimum order amount: $e');
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
        debugPrint(
            '[BannerController] Error getting cart total: ${res.exception}');
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

          debugPrint(
              '[BannerController] Coupon code applied successfully: $couponCode');
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
        debugPrint(
            '[BannerController] No products tracked for coupon: $couponCode');
        debugPrint(
            '[BannerController] Available tracked coupons: ${couponAddedProducts.keys.toList()}');
        return true; // No products to remove
      }

      final productVariantIds = couponAddedProducts[couponCode]!;
      debugPrint(
          '[BannerController] Found ${productVariantIds.length} products to remove for coupon: $couponCode');
      debugPrint(
          '[BannerController] Product variant IDs to remove: $productVariantIds');

      // Get current cart to find order line IDs for these products
      final cart = await _getCurrentCart();
      if (cart == null) {
        debugPrint(
            '[BannerController] No active cart found - cannot remove products');
        return false;
      }

      final cartLines = cart['lines'] as List<dynamic>? ?? [];
      debugPrint(
          '[BannerController] Current cart has ${cartLines.length} order lines');

      int removedCount = 0;
      for (final variantId in productVariantIds) {
        debugPrint(
            '[BannerController] Looking for variant ID: $variantId in cart');
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineData = line as Map<String, dynamic>;
          final lineId = lineData['id'] as String;
          final productVariant =
              lineData['productVariant'] as Map<String, dynamic>;
          final variantIdFromCart = productVariant['id'] as String;

          debugPrint(
              '[BannerController] Checking order line $lineId with variant $variantIdFromCart');
          if (variantIdFromCart == variantId) {
            found = true;
            debugPrint(
                '[BannerController] ✓ Found matching order line $lineId for variant $variantId');
            debugPrint(
                '[BannerController] Removing order line $lineId for variant $variantId');

            final success = await _removeOrderLineById(lineId);
            if (success) {
              removedCount++;
              debugPrint(
                  '[BannerController] ✓ Successfully removed order line $lineId');
            } else {
              debugPrint(
                  '[BannerController] ✗ Failed to remove order line $lineId');
            }
            break; // Remove only one instance per variant ID
          }
        }

        if (!found) {
          debugPrint(
              '[BannerController] ⚠ Variant ID $variantId not found in current cart');
        }
      }

      debugPrint(
          '[BannerController] Removed $removedCount out of ${productVariantIds.length} products');

      // Verify removal by checking cart again
      if (removedCount > 0) {
        debugPrint('[BannerController] Verifying product removal...');
        final updatedCart = await _getCurrentCart();
        if (updatedCart != null) {
          final updatedLines = updatedCart['lines'] as List<dynamic>? ?? [];
          debugPrint(
              '[BannerController] Cart after removal has ${updatedLines.length} lines');
        }
      }

      // Clear the tracked products for this coupon
      couponAddedProducts.remove(couponCode);
      debugPrint(
          '[BannerController] ✓ Cleared tracked products for coupon: $couponCode');
      debugPrint(
          '[BannerController] ===== COUPON PRODUCT REMOVAL COMPLETE =====');

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
        debugPrint(
            '[BannerController] Error getting current cart: ${res.exception}');
        return null;
      }

      final activeOrder = res.data?['activeOrder'];
      if (activeOrder != null) {
        debugPrint(
            '[BannerController] ✓ Found active order: ${activeOrder['id']}');
        debugPrint(
            '[BannerController] Order has ${activeOrder['lines']?.length ?? 0} lines');

        // Debug each line
        if (activeOrder['lines'] != null) {
          for (int i = 0; i < activeOrder['lines'].length; i++) {
            final line = activeOrder['lines'][i];
            debugPrint(
                '[BannerController] Line $i: ID=${line['id']}, Variant=${line['productVariant']['id']}, Name=${line['productVariant']['name']}, Qty=${line['quantity']}');
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
      debugPrint(
          '[BannerController] Attempting to remove order line: $orderLineId');

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
          debugPrint(
              '[BannerController] ✓ Successfully removed order line $orderLineId');
          debugPrint('[BannerController] Updated order ID: ${result['id']}');
          return true;
        } else {
          debugPrint(
              '[BannerController] ✗ Failed to remove order line $orderLineId: ${result['message']}');
          return false;
        }
      } else {
        debugPrint(
            '[BannerController] ✗ No result from removeOrderLine mutation for $orderLineId');
        return false;
      }
    } catch (e) {
      debugPrint(
          '[BannerController] ✗ Exception removing order line $orderLineId: $e');
      handleException(e, customErrorMessage: 'Failed to remove item from cart');
      return false;
    }
  }

  /// Remove coupon code from active order
  Future<bool> removeCouponCode(String couponCode) async {
    try {
      utilityController.setLoadingState(true);

      // First remove products that were added by this coupon
      debugPrint(
          '[BannerController] Removing products added by coupon: $couponCode');
      final productsRemoved = await removeCouponProducts(couponCode);
      if (!productsRemoved) {
        debugPrint(
            '[BannerController] Warning: Failed to remove some products for coupon $couponCode');
      }

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

        debugPrint(
            '[BannerController] Coupon code removed successfully: $couponCode');
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
      debugPrint(
          '[BannerController] ===== ADDING COUPON PRODUCTS TO CART =====');
      debugPrint('[BannerController] Coupon code: $couponCode');

      // Get products from the actual coupon data
      final couponProducts = getCouponProducts(couponCode);

      if (couponProducts.isEmpty) {
        debugPrint(
            '[BannerController] ✗ No products found for coupon: $couponCode');
        return {
          'success': false,
          'message': 'No products found for this coupon',
          'error': 'NO_PRODUCTS_DEFINED'
        };
      }

      debugPrint(
          '[BannerController] ✓ Found ${couponProducts.length} products for coupon: $couponCode');
      for (int i = 0; i < couponProducts.length; i++) {
        final product = couponProducts[i];
        debugPrint(
            '[BannerController] Product $i: ${product['name']} (Variant ID: ${product['productVariantId']}, Qty: ${product['quantity']})');
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

          debugPrint(
              '[BannerController] Adding product to cart: $productName (Variant ID: $productVariantId, Qty: $quantity)');

          final res = await GraphqlService.client.value.mutate$AddToCart(
            Options$Mutation$AddToCart(
              variables: Variables$Mutation$AddToCart(
                variantId: productVariantId,
                qty: quantity,
              ),
            ),
          );

          if (res.hasException) {
            debugPrint(
                '[BannerController] - Product from $productName: Network error: ${res.exception}');

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
            debugPrint(
                '[BannerController] Add to cart result for $productName: ${result.runtimeType}');
            if (result is Mutation$AddToCart$addItemToOrder$$Order) {
              debugPrint(
                  '[BannerController] Successfully added $productName to cart');
              addedProducts.add({
                'product': productName,
                'quantity': quantity,
                'price': priceWithTax,
                'productVariantId': productVariantId,
              });
            } else if (result
                is Mutation$AddToCart$addItemToOrder$$InsufficientStockError) {
              debugPrint(
                  '[BannerController] Failed to add $productName: Insufficient stock');
              failedProducts
                  .add({'product': productName, 'error': 'Insufficient stock'});
            } else {
              debugPrint(
                  '[BannerController] Failed to add $productName: Unknown error');
              failedProducts
                  .add({'product': productName, 'error': 'Unknown error'});
            }
          } else {
            debugPrint(
                '[BannerController] No result returned for adding $productName');
            failedProducts.add({
              'product': productName,
              'error': 'No result returned from server'
            });
          }
        } catch (e) {
          debugPrint(
              '[BannerController] Exception adding product ${product['name']}: $e');
          handleException(e,
              customErrorMessage: 'Failed to add product to cart');
          failedProducts.add({
            'product': product['name'],
            'error': 'Error adding product: $e'
          });
        }
      }

      utilityController.setLoadingState(false);

      debugPrint(
          '[BannerController] Coupon products addition completed for $couponCode');
      debugPrint(
          '[BannerController] Successfully added: ${addedProducts.length} products');
      debugPrint(
          '[BannerController] Failed to add: ${failedProducts.length} products');

      if (addedProducts.isNotEmpty) {
        debugPrint('[BannerController] Added products:');
        final addedProductIds = <String>[];
        for (final product in addedProducts) {
          debugPrint(
              '[BannerController] - ${product['product']} (Qty: ${product['quantity']}, Price: ${product['price']})');
          // Track the product variant ID for removal later
          if (product['productVariantId'] != null) {
            addedProductIds.add(product['productVariantId'].toString());
          }
        }

        // Store the products added by this coupon
        couponAddedProducts[couponCode] = addedProductIds;
        debugPrint(
            '[BannerController] Tracked ${addedProductIds.length} products for coupon $couponCode: $addedProductIds');
      }

      if (failedProducts.isNotEmpty) {
        debugPrint('[BannerController] Failed products:');
        for (final product in failedProducts) {
          debugPrint(
              '[BannerController] - ${product['product']}: ${product['error']}');
        }
      }

      return {
        'success': addedProducts.isNotEmpty,
        'message': 'Added ${addedProducts.length} products to cart',
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
    }
  }

  /// Apply coupon code with products (add products first, then apply coupon)
  Future<Map<String, dynamic>> applyCouponCodeWithProducts(
      String couponCode) async {
    try {
      debugPrint(
          '[BannerController] Starting applyCouponCodeWithProducts for: $couponCode');

      // First add coupon products to cart
      debugPrint(
          '[BannerController] Step 1: Adding coupon products to cart...');
      final addResult = await addCouponProductsToCart(couponCode);

      if (!addResult['success']) {
        debugPrint(
            '[BannerController] Failed to add products to cart: ${addResult['message']}');
        return addResult;
      }

      debugPrint('[BannerController] Step 2: Applying coupon code...');
      // Then apply the coupon code
      final couponResult = await applyCouponCode(couponCode);

      if (couponResult['success']) {
        debugPrint(
            '[BannerController] Successfully applied coupon with products for: $couponCode');
        return {
          'success': true,
          'message': 'Coupon products added and coupon applied successfully',
          'addedProducts': addResult['addedProducts'],
          'couponApplied': true,
          'affectedProducts': couponResult['affectedProducts'],
          'orderTotal': couponResult['orderTotal'],
        };
      } else {
        debugPrint(
            '[BannerController] Products added but failed to apply coupon: ${couponResult['message']}');

        // ROLLBACK: Remove the products that were added since coupon application failed
        debugPrint(
            '[BannerController] Rolling back: Removing added products due to coupon application failure...');
        final rollbackResult = await _rollbackAddedProducts(couponCode);

        if (rollbackResult['success']) {
          debugPrint(
              '[BannerController] Successfully rolled back added products');
        } else {
          debugPrint(
              '[BannerController] Failed to rollback added products: ${rollbackResult['message']}');
        }

        return {
          'success': false,
          'message':
              'Failed to apply coupon: ${couponResult['message']}. Added products have been removed.',
          'addedProducts': addResult['addedProducts'],
          'couponApplied': false,
          'couponError': couponResult['message'],
          'rollbackPerformed': true,
          'rollbackResult': rollbackResult,
        };
      }
    } catch (e) {
      debugPrint('[BannerController] Apply coupon with products error: $e');

      // ROLLBACK: If there's an exception, try to remove any products that might have been added
      debugPrint(
          '[BannerController] Exception occurred, attempting rollback...');
      try {
        final rollbackResult = await _rollbackAddedProducts(couponCode);
        debugPrint(
            '[BannerController] Rollback result: ${rollbackResult['success']}');
      } catch (rollbackError) {
        debugPrint(
            '[BannerController] Rollback failed with error: $rollbackError');
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
        debugPrint(
            '[BannerController] No products tracked for coupon: $couponCode - nothing to rollback');
        return {
          'success': true,
          'message': 'No products to rollback',
          'removedCount': 0
        };
      }

      final productVariantIds = couponAddedProducts[couponCode]!;
      debugPrint(
          '[BannerController] Rolling back ${productVariantIds.length} products for coupon: $couponCode');
      debugPrint(
          '[BannerController] Product variant IDs to remove: $productVariantIds');

      // Get current cart to find order line IDs for these products
      final cart = await _getCurrentCart();
      if (cart == null) {
        debugPrint(
            '[BannerController] No active cart found - cannot rollback products');
        return {
          'success': false,
          'message': 'No active cart found',
          'removedCount': 0
        };
      }

      final cartLines = cart['lines'] as List<dynamic>? ?? [];
      debugPrint(
          '[BannerController] Current cart has ${cartLines.length} order lines');

      int removedCount = 0;
      final failedRemovals = <String>[];

      for (final variantId in productVariantIds) {
        debugPrint(
            '[BannerController] Looking for variant ID: $variantId in cart for rollback');
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineData = line as Map<String, dynamic>;
          final lineId = lineData['id'] as String;
          final productVariant =
              lineData['productVariant'] as Map<String, dynamic>;
          final variantIdFromCart = productVariant['id'] as String;

          debugPrint(
              '[BannerController] Checking order line $lineId with variant $variantIdFromCart for rollback');
          if (variantIdFromCart == variantId) {
            found = true;
            debugPrint(
                '[BannerController] ✓ Found matching order line $lineId for variant $variantId - removing for rollback');

            final success = await _removeOrderLineById(lineId);
            if (success) {
              removedCount++;
              debugPrint(
                  '[BannerController] ✓ Successfully removed order line $lineId during rollback');
            } else {
              debugPrint(
                  '[BannerController] ✗ Failed to remove order line $lineId during rollback');
              failedRemovals.add('Line $lineId for variant $variantId');
            }
            break; // Remove only one instance per variant ID
          }
        }

        if (!found) {
          debugPrint(
              '[BannerController] ⚠ Variant ID $variantId not found in current cart during rollback');
        }
      }

      debugPrint(
          '[BannerController] Rollback completed: Removed $removedCount out of ${productVariantIds.length} products');

      // Clear the tracked products for this coupon
      couponAddedProducts.remove(couponCode);
      debugPrint(
          '[BannerController] ✓ Cleared tracked products for coupon: $couponCode after rollback');
      debugPrint('[BannerController] ===== ROLLBACK COMPLETE =====');

      return {
        'success': removedCount > 0 || failedRemovals.isEmpty,
        'message': removedCount > 0
            ? 'Successfully rolled back $removedCount products'
            : 'No products were removed during rollback',
        'removedCount': removedCount,
        'failedRemovals': failedRemovals,
        'totalExpected': productVariantIds.length
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
      debugPrint(
          '[BannerController] Delegating update check to InAppUpdateService...');

      // Simply call the service method
      final updateService = InAppUpdateService();
      await updateService.checkForUpdatesAndDetermineType();

      debugPrint(
          '[BannerController] Update check completed by InAppUpdateService');
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
      debugPrint(
          '[BannerController] Fetching product detail for ID: $productId');

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
        debugPrint(
            '[BannerController] GetProductDetail Exception: ${result.exception}');
        utilityController.setLoadingState(false);
        return null;
      }

      final productData = result.data?['product'];
      if (productData != null) {
        productDetail.value = productData as Map<String, dynamic>;
        debugPrint(
            '[BannerController] Product detail fetched successfully: ${productData['name']}');
        utilityController.setLoadingState(false);
        return productData;
      } else {
        debugPrint('[BannerController] No product data found');
        utilityController.setLoadingState(false);
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('[BannerController] Get product detail error: $e');
      debugPrint('[BannerController] Stack trace: $stackTrace');
      utilityController.setLoadingState(false);
      return null;
    }
  }
}
