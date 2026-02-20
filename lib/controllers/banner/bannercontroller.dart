import 'dart:async';
// import 'package:flutter/material.dart'; // Unused import removed
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart'
    show Context, HttpLinkHeaders, QueryResult, gql;
// import 'package:flutter/foundation.dart'; // Unused import removed
import '../../graphql/banner.graphql.dart';
import '../../graphql/cart.graphql.dart' as cart_graphql;
import '../../graphql/order.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../../services/channel_service.dart';
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
import '../../utils/logger.dart';

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

  // Flag to prevent multiple simultaneous banner fetches
  bool _isFetchingBanners = false;

  // Fetch banners
  Future<void> getBannersForChannel() async {
    // Prevent multiple simultaneous fetches
    if (_isFetchingBanners) {
      return;
    }

    Logger.logFunction(functionName: 'getBannersForChannel', queryName: 'customBanners');
    
    _isFetchingBanners = true;
    
    try {
      utilityController.setLoadingState(false); // ✅ Set shared loading state

      // Use GraphQL token; fallback to ChannelService (e.g. right after channel switch)
      String channelToken = GraphqlService.channelToken;
      if (channelToken.isEmpty) {
        channelToken = ChannelService.getChannelToken()?.toString() ?? '';
      }

      if (channelToken.isEmpty) {
        utilityController.setLoadingState(false);
        _isFetchingBanners = false;
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
    } finally {
      _isFetchingBanners = false;
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

      // Filter out disabled products: fetch enabled product IDs and keep only those
      List<Query$Search$search$items> listAfterEnabledFilter = uniqueProductList;
      final productIds = uniqueProductList.map((e) => e.productId).toSet().toList();
      if (productIds.isNotEmpty) {
        final enabledIds = await _fetchEnabledProductIds(productIds);
        if (enabledIds != null && enabledIds.isNotEmpty) {
          listAfterEnabledFilter = uniqueProductList
              .where((item) => enabledIds.contains(item.productId))
              .toList();
        }
      }

      // Don't show products whose name ends with "free" in search UI
      final filteredList = listAfterEnabledFilter.where((item) {
        final name = item.productName.trim().toLowerCase();
        return !name.endsWith('free');
      }).toList();

      searchResults.assignAll(filteredList);
      totalItems.value = filteredList.length;

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

  /// Fetches product IDs that are enabled. Returns null on error (caller may skip filtering).
  Future<Set<String>?> _fetchEnabledProductIds(List<String> productIds) async {
    if (productIds.isEmpty) return <String>{};
    try {
      const query = r'''
        query GetEnabledProductIds($options: ProductListOptions) {
          products(options: $options) {
            items { id }
          }
        }
      ''';
      final result = await GraphqlService.client.value.query(
        graphql.QueryOptions(
          document: gql(query),
          variables: {
            'options': {
              'filter': {
                'id': {'in': productIds},
                'enabled': {'eq': true},
              },
              'take': productIds.length + 50,
            },
          },
          fetchPolicy: graphql.FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException || result.data == null) return null;
      final items = result.data!['products']?['items'] as List<dynamic>?;
      if (items == null) return null;
      return items
          .map((e) => (e as Map<String, dynamic>)['id']?.toString())
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet();
    } catch (_) {
      return null;
    }
  }

  // ============================================================================
  // FAVORITES METHODS
  // ============================================================================
  /// Toggle favorite for a product
  Future<bool> toggleFavorite({required String productId}) async {
    try {
      
          Logger.logFunction(functionName: 'toggleFavorite');
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

      // Check if mutation was successful
      final toggleResult = res.data?['toggleFavorite'];
      if (toggleResult != null) {
        // ignore: unused_local_variable
        final _totalItems = toggleResult['totalItems'] as int? ?? 0;
      }

      // Refresh customer favorites to ensure UI is up to date
      // Don't try to convert mutation result to query result format because
      // they have different fields (mutation doesn't include 'enabled' field)
      await getCustomerFavorites();
      utilityController.setLoadingState(false);
      return true;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to update favorite');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Get customer favorites
  Future<void> getCustomerFavorites() async {
    try {
          Logger.logFunction(functionName: 'getCustomerFavorites');
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
        } else if (isNetworkError) {
          // Network error - don't logout, just log and return
          utilityController.setLoadingState(false);
          return; // Exit early, don't process data or logout
        } else {
          // For other exceptions, log but still try to process data if available
        }
      }

      // Process data if available (even with cache miss exceptions)
      final activeCustomer = res.data?['activeCustomer'];

      if (activeCustomer != null &&
          activeCustomer['__typename'] == 'Customer') {
        final favoritesData = activeCustomer['favorites'];

        if (favoritesData != null) {
          final favorites = Query$GetCustomerFavorites$activeCustomer$favorites.fromJson(favoritesData as Map<String, dynamic>);
          // Exclude products whose name ends with "free" (case insensitive) from UI
          final filteredItems = favorites.items
              .where((item) => !((item.product?.name ?? '').trim().toLowerCase().endsWith('free')))
              .toList();
          favoritesList.assignAll(filteredItems);
          favoritesTotalItems.value = filteredItems.length;

          // Update favorite product IDs set
          favoriteProductIds.clear();
          final productIds = filteredItems.map((item) => item.product?.id ?? '').where((id) => id.isNotEmpty).toList();
          favoriteProductIds.addAll(productIds);
          // Debug: Log each favorite item
          for (int i = 0; i < filteredItems.length; i++) {
            final item = filteredItems[i];
            final product = item.product;
            if (product?.featuredAsset != null) {
            }
          }
        } else {
          // No favorites data, clear the list
          favoritesList.clear();
          favoritesTotalItems.value = 0;
          favoriteProductIds.clear();
        }
      } else {
        // Customer not logged in or not a Customer type, clear favorites
        favoritesList.clear();
        favoritesTotalItems.value = 0;
        favoriteProductIds.clear();
        
        // Only logout if it's NOT a network error
        // Network errors should not trigger logout as they're temporary connection issues
        if (!isNetworkError) {
          // Clear cache and logout when customer data is null (only if not a network error)
          try {
            final customerController = Get.find<CustomerController>();
            await customerController.handleCustomerDataNotFound();
          } catch (e) {
            // If CustomerController is not found, handle logout directly
            await _handleCustomerDataNotFound();
          }
        } else {
        }
      }

      utilityController.setLoadingState(false);
    } catch (e) {
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
          Logger.logFunction(functionName: 'getFrequentlyOrderedProducts');
    utilityController.setLoadingState(false);

      final res =
          await GraphqlService.client.value.query$GetFrequentlyOrderedProducts(
        Options$Query$GetFrequentlyOrderedProducts(),
      );
      if (res.hasException) {
        if (res.exception?.linkException != null) {
        }
        if (res.exception?.graphqlErrors != null) {
        }
      }

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load frequently ordered products')) {
        utilityController.setLoadingState(false);
        return;
      }

      final products = res.parsedData?.frequentlyOrderedProducts ?? [];
      // Exclude products whose name ends with "free" (case insensitive) from UI
      final filteredProducts = products
          .where((item) =>
              !(item.product.name.trim().toLowerCase().endsWith('free')))
          .toList();
      if (filteredProducts.isNotEmpty) {
        for (int i = 0; i < filteredProducts.length; i++) {
          final item = filteredProducts[i];
          final product = item.product;
          if (product.variants.isNotEmpty) {
            // ignore: unused_local_variable
            final _firstVariant = product.variants.first;
          }
          if (product.featuredAsset != null) {
          }
        }
      } else {
      }
      
      frequentlyOrderedProducts.assignAll(filteredProducts);
      utilityController.setLoadingState(false);
    } catch (e) {
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
          Logger.logFunction(functionName: 'applyLoyaltyPoints');
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
        } catch (e) {
        }
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
      handleException(e, customErrorMessage: 'Failed to apply loyalty points');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Remove loyalty points from active order
  Future<bool> removeLoyaltyPoints() async {
    try {
          Logger.logFunction(functionName: 'removeLoyaltyPoints');
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
        } catch (e) {
        }
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
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
          Logger.logFunction(functionName: 'fetchLoyaltyPointsConfig', queryName: 'LoyaltyPointsConfig');
    utilityController.setLoadingState(false);
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
      } else {
      }

      utilityController.setLoadingState(false);
    } catch (e) {
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
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toUpperCase() == couponCode.toUpperCase(),
        );
      } catch (e) {
        return [];
      }

      // Coupon found, continue processing

      // Extract products from coupon actions and conditions
      final products = <Map<String, dynamic>>[];

      // Check actions for product information (actions are what the coupon DOES)
      for (final action in coupon.actions) {
        if (action.code == 'add_products' ||
            action.code == 'contains_products' ||
            action.code == 'free_shipping') {
          for (final arg in action.args) {
            if (arg.name == 'productVariantIds' && arg.value is List) {
              final variantIds = arg.value as List<dynamic>;
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
        if (condition.code == 'contains_products') {
          for (final arg in condition.args) {

            // Check for different possible argument names
            if (arg.name == 'productVariantIds') {
              List<dynamic> variantIds = [];

              if (arg.value is List) {
                variantIds = arg.value as List<dynamic>;
              } else {
                final stringValue = arg.value;
                // Try to parse string representation of list like "[542]" or "542,543"
                if (stringValue.startsWith('[') && stringValue.endsWith(']')) {
                  // Remove brackets and split by comma
                  final cleanString =
                      stringValue.substring(1, stringValue.length - 1);
                  variantIds =
                      cleanString.split(',').map((e) => e.trim()).toList();
                } else if (stringValue.contains(',')) {
                  // Split by comma
                  variantIds =
                      stringValue.split(',').map((e) => e.trim()).toList();
                } else {
                  // Single value
                  variantIds = [stringValue.trim()];
                }
              }

              if (variantIds.isNotEmpty) {
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
      if (products.isNotEmpty) {
        for (int i = 0; i < products.length; i++) {
        }
      } else {
      }
      return products;
    } catch (e) {
      return [];
    }
  }

  /// Check if a coupon has associated products
  bool hasCouponProducts(String couponCode) {
    final products = getCouponProducts(couponCode);
    if (products.isNotEmpty) {
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
      utilityController.setLoadingState(false);
      // Check if we have authentication token
      final authToken = GraphqlService.authToken;
      final channelToken = GraphqlService.channelToken;
      if (authToken.isNotEmpty) {
      } else {
      }
      if (channelToken.isNotEmpty) {
      } else {
      }
      // Try the query with retry logic
      QueryResult<Query$GetCouponCodeList>? res;
      int retryCount = 0;
      const maxRetries = 3;

      while (retryCount < maxRetries) {
        try {
          res = await Future.any([
            GraphqlService.client.value.query$GetCouponCodeList(
              Options$Query$GetCouponCodeList(),
            ),
            Future.delayed(Duration(seconds: 15)).then((_) =>
                throw TimeoutException(
                    'Query timeout after 15 seconds', Duration(seconds: 15))),
          ]);
          break; // Success, exit retry loop
        } catch (e) {
          retryCount++;

          if (retryCount >= maxRetries) {
            rethrow;
          }

          // Wait before retrying
          await Future.delayed(Duration(seconds: 2));
        }
      }

      if (res == null) {
        throw Exception(
            'Failed to get coupon codes after $maxRetries attempts');
      }
      if (res.hasException) {
      }

      if (checkResponseForErrors(res,
          customErrorMessage: 'Failed to load coupon codes')) {
        utilityController.setLoadingState(false);
        return;
      }
      if (res.data != null) {
      } else {
      }

      final couponData = res.parsedData?.getCouponCodeList;
      if (couponData != null) {
        final items = couponData.items;
        if (items.isNotEmpty) {

          // Check if items are properly structured
        } else {
        }

        try {
          final fetchedCoupons = items.map((item) {
            final json = item.toJson();
            return Query$GetCouponCodeList$getCouponCodeList$items.fromJson(json);
          }).toList();
          availableCouponCodes.assignAll(fetchedCoupons);
          couponCodesLoaded.value = true;
          // Debug print each coupon details
          for (int i = 0; i < fetchedCoupons.length; i++) {
            // ignore: unused_local_variable
            final _coupon = fetchedCoupons[i];
            // final sanitizedDescription = HtmlUtils.stripHtmlTags(coupon.description); // Unused variable
            // Products are extracted from coupon actions/conditions, not directly from coupon
            // This debug section removed as products field doesn't exist in generated type
          }
        } catch (conversionError) {
        }
      } else {
      }
      utilityController.setLoadingState(false);
    } catch (e) {
      utilityController.setLoadingState(false);
    }
  }

  /// Validate coupon code before applying
  Future<Map<String, dynamic>> validateCouponCode(String couponCode) async {
    try {
      // First check if coupon code exists in available list
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
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
        final endDate = coupon.endsAt!;
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
        final startDate = coupon.startsAt!;
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
      return {
        'valid': false,
        'message': 'Error validating coupon code',
        'error': 'VALIDATION_ERROR'
      };
    }
  }

  /// Validate minimum order amount for coupon (checked against cart subtotal, not total)
  Future<Map<String, dynamic>> _validateMinimumOrderAmount(
      Query$GetCouponCodeList$getCouponCodeList$items coupon) async {
    try {
      // Get current cart subtotal from active order (subtotal = line items, not total with shipping)
      final orderController = Get.find<OrderController>();
      
      // Try to get from already-loaded order first
      double? cartSubTotal = orderController.currentOrder.value?.subTotalWithTax;
      
      // If not available, load active order
      if (cartSubTotal == null) {
        final loaded = await orderController.getActiveOrder(skipLoading: true);
        if (loaded) {
          cartSubTotal = orderController.currentOrder.value?.subTotalWithTax;
        }
      }

      if (cartSubTotal == null) {
        return {
          'valid': false,
          'message': 'Unable to get cart subtotal',
          'error': 'CART_TOTAL_ERROR'
        };
      }
      // Check coupon conditions for minimum order amount (against subtotal)
      for (final condition in coupon.conditions) {
        if (condition.code == 'minimum_order_amount') {
          for (final arg in condition.args) {
            if (arg.name == 'amount') {
              // arg.value is always String, so parse it directly
              final requiredAmount = double.tryParse(arg.value) ?? 0.0;
              if (cartSubTotal < requiredAmount) {
                return {
                  'valid': false,
                  'message':
                      'Minimum order amount of ${_formatPrice(requiredAmount.toInt())} required. Current cart subtotal is ${_formatPrice(cartSubTotal.toInt())}.',
                  'error': 'MINIMUM_ORDER_AMOUNT_NOT_MET',
                  'requiredAmount': requiredAmount,
                  'currentAmount': cartSubTotal
                };
              }
            }
          }
        }
      }
      return {'valid': true, 'message': 'Minimum order amount requirement met'};
    } catch (e) {
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
      final minimumAmountValidation = await _validateMinimumOrderAmount(coupon);
      
      if (!minimumAmountValidation['valid']) {
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
      // Step 3: Now apply the coupon (minimum is already validated)
      return await _applyCouponCodeWithoutMinimumCheck(couponCode);
    } catch (e) {
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
    Logger.logFunction(functionName: '_applyCouponCodeWithoutMinimumCheck', mutationName: 'ApplyCouponCode');
    
    try {
      utilityController.setLoadingState(true);

      // Validate other coupon conditions (enabled, expired, etc.) - but skip minimum check
      
      // Find the coupon
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
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
        // Update controllers with full order data from response
        try {
          final cartController = Get.find<CartController>();
          final orderController = Get.find<OrderController>();
          final resultJson = result.toJson();
          final hasLines = resultJson['lines'] != null && 
                         (resultJson['lines'] as List).isNotEmpty;
          
          if (hasLines) {
            // Update cart controller directly from response
            cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
            // Refresh order controller to get updated data
            await orderController.getActiveOrder(skipLoading: true);
            // Restore coupon tracking from cart to ensure UI shows free products correctly
            try {
              await restoreCouponTrackingFromCart();
            } catch (e) {
            }
          } else {
            // If no lines in response, refresh both controllers
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
            
            // Restore coupon tracking after refresh
            try {
              await restoreCouponTrackingFromCart();
            } catch (e) {
            }
          }
        } catch (e) {
          // Fallback: refresh both controllers from server
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
            
            // Restore coupon tracking after fallback refresh
            try {
              await restoreCouponTrackingFromCart();
            } catch (restoreError) {
            }
          } catch (refreshError) {
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

      // Handle API error types (CouponCodeInvalidError, CouponCodeExpiredError, CouponCodeLimitError) – show their message
      utilityController.setLoadingState(false);
      _refreshCartAfterCouponError();
      String apiMessage = 'Failed to apply coupon code';
      if (result != null) {
        if (result is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeInvalidError) {
          apiMessage = result.message;
        } else if (result is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeExpiredError) {
          apiMessage = result.message;
        } else if (result is Mutation$ApplyCouponCode$applyCouponCode$$CouponCodeLimitError) {
          apiMessage = result.message;
        }
      }
      return {
        'success': false,
        'message': apiMessage,
        'error': 'APPLICATION_ERROR'
      };
    } catch (e) {
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
      final cartController = Get.find<CartController>();
      final orderController = Get.find<OrderController>();
      
      // Refresh both controllers to ensure state is synchronized
      await Future.wait([
        cartController.getActiveOrder(),
        orderController.getActiveOrder(skipLoading: true),
      ], eagerError: false);
    } catch (e) {
      // Don't throw - this is a best-effort refresh
    }
  }

  /// Remove products added by a specific coupon
  Future<bool> removeCouponProducts(String couponCode) async {
    try {
      if (!couponAddedProducts.containsKey(couponCode)) {
        return true; // No products to remove
      }

      final productsToRemove = couponAddedProducts[couponCode]!;
      // Get current cart to find order line IDs for these products
      final cartController = Get.find<CartController>();
      final cart = cartController.cart.value;
      if (cart == null) {
        return false;
      }

      final cartLines = cart.lines;
      int removedCount = 0;
      
      for (final entry in productsToRemove.entries) {
        final variantId = entry.key;
        final quantityToRemove = entry.value;
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineId = line.id;
          final currentQuantity = line.quantity;
          final variantIdFromCart = line.productVariant.id;
          if (variantIdFromCart == variantId) {
            found = true;
            // Calculate new quantity after removing coupon-added quantity
            final newQuantity = currentQuantity - quantityToRemove;
            
            if (newQuantity <= 0) {
              // Remove the entire line if quantity becomes 0 or negative
              // This happens when: currentQuantity <= quantityToRemove
              // Example: currentQuantity=1, quantityToRemove=1 → newQuantity=0 → remove
              final success = await _removeOrderLineById(lineId);
              if (success) {
                removedCount++;
                // Refresh cart after removal to get updated state
                try {
                  await cartController.getActiveOrder();
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
                } catch (e) {
                }
              } else {
              }
            } else {
              // Decrease quantity instead of removing the line
              // This happens when: currentQuantity > quantityToRemove
              // Example: currentQuantity=2, quantityToRemove=1 → newQuantity=1 → decrease
              final success = await cartController.adjustOrderLine(
                orderLineId: lineId,
                quantity: newQuantity,
              );
              if (success) {
                removedCount++;
                // Cart is already updated by adjustOrderLine, just update OrderController
                try {
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
                } catch (e) {
                }
              } else {
              }
            }
            break; // Process only one instance per variant ID
          }
        }

        if (!found) {
        }
      }
      // Verify removal by checking cart again
      if (removedCount > 0) {
        final updatedCart = cartController.cart.value;
        if (updatedCart != null) {
        }
      }

      // Clear the tracked products and original quantities for this coupon
      couponAddedProducts.remove(couponCode);
      originalCartQuantities.remove(couponCode);
      return removedCount > 0;
    } catch (e) {
          Logger.logFunction(functionName: '_removeOrderLineById', mutationName: 'RemoveOrderLine');
    return false;
    }
  }

  /// Get current cart

  /// Remove order line by ID
  Future<bool> _removeOrderLineById(String orderLineId) async {
    try {
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
          // Update both controllers after removal
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            final resultJson = result.toJson();
            
            // Update CartController
            cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
            // Update OrderController
            // Note: result is from data, need to parse it properly
            // For now, refresh the order instead
            await orderController.getActiveOrder(skipLoading: true);
          } catch (e) {
            // Fallback: refresh controllers
            try {
              final cartController = Get.find<CartController>();
              final orderController = Get.find<OrderController>();
              await cartController.getActiveOrder();
              await orderController.getActiveOrder(skipLoading: true);
            } catch (refreshError) {
            }
          }
          
          return true;
        } else {
          // Handle error cases - this is not an Order, so it's likely an error
          // Try to extract message if available
          try {
            final resultJson = result.toJson();
            final message = resultJson['message'] as String?;
            if (message != null) {
            }
          } catch (e) {
          }
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
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
      // If coupon has products, remove them from cart first
      if (hasProducts) {
        final productsRemoved = await removeCouponProducts(couponCode);
        
        // If removing products fails, don't remove coupon
        if (!productsRemoved) {
          utilityController.setLoadingState(false);
          return false;
        }
      } else {
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
        // Clear tracked products and original quantities for this coupon
        couponAddedProducts.remove(couponCode);
        originalCartQuantities.remove(couponCode);
        // Update both cart and order controllers directly from the response
        try {
          final cartController = Get.find<CartController>();
          final orderController = Get.find<OrderController>();
          // Result is Fragment$Cart which contains full order data
          final resultJson = result.toJson();
          if (resultJson.containsKey('id')) {
            // Update CartController
            cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
            // Update OrderController
            orderController.currentOrder.value = result;
          } else {
            // Fallback: refresh both controllers
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
          }
        } catch (e) {
          // Fallback: refresh both controllers
          try {
            final cartController = Get.find<CartController>();
            final orderController = Get.find<OrderController>();
            await cartController.getActiveOrder();
            await orderController.getActiveOrder(skipLoading: true);
          } catch (refreshError) {
          }
        }
        
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
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
  }

  /// Restore coupon tracking state from cart
  /// This is called when cart is loaded to reconstruct couponAddedProducts and originalCartQuantities
  Future<void> restoreCouponTrackingFromCart() async {
    try {
      // Get current cart
      final orderController = Get.find<OrderController>();
      final currentOrder = orderController.currentOrder.value;
      if (currentOrder == null) {
        return;
      }

      // Get applied coupon codes from cart
      final cartCouponCodes = currentOrder.couponCodes.map((e) => e.toString()).toList();
      if (cartCouponCodes.isEmpty) {
        appliedCouponCodes.clear();
        couponAddedProducts.clear();
        originalCartQuantities.clear();
        return;
      }

      // Update appliedCouponCodes to match cart
      appliedCouponCodes.value = cartCouponCodes;

      // Get current cart lines
      final cartController = Get.find<CartController>();
      final cart = cartController.cart.value;
      if (cart == null) {
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
        // Find the coupon in available coupons
        // ignore: unused_local_variable
        Query$GetCouponCodeList$getCouponCodeList$items? coupon;
        try {
          coupon = availableCouponCodes.firstWhere(
            (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
          );
        } catch (e) {
          continue;
        }

        // Get products that should be added by this coupon
        // Note: getCouponProducts will also find the coupon, but we already found it above for early validation
        final couponProducts = getCouponProducts(couponCode);
        if (couponProducts.isEmpty) {
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
          } else if (currentQty > 0) {
            // Product exists but with less quantity than expected (maybe user removed some)
            // Assume all current quantity is from coupon
            addedQuantities[variantId] = currentQty;
            originalQuantities[variantId] = 0;
          }
        }

        if (addedQuantities.isNotEmpty) {
          couponAddedProducts[couponCode] = addedQuantities;
          originalCartQuantities[couponCode] = originalQuantities;
        } else {
        }
      }
    } catch (e) {
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
          await restoreCouponTrackingFromCart();
        } else if (appliedCouponCodes.isNotEmpty && cartCouponCodes.isEmpty) {
          // Cart has no coupons but we have applied coupons - clear them
          resetCouponCodes();
        }
      }

      // If no coupons applied, nothing to check
      if (appliedCouponCodes.isEmpty) {
        return;
      }

      // Get current cart subtotal from active order (subtotal = line items, not total with shipping)
      // Try to get from already-loaded order first
      double? cartSubTotal = orderController.currentOrder.value?.subTotalWithTax;
      
      // If not available, load active order
      if (cartSubTotal == null) {
        final loaded = await orderController.getActiveOrder(skipLoading: true);
        if (loaded) {
          cartSubTotal = orderController.currentOrder.value?.subTotalWithTax;
        }
      }
      
      if (cartSubTotal == null) {
        return;
      }
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
          // Remove it from applied list if not found
          couponsToRemove.add(couponCode);
          continue;
        }

        // Get minimum amount for this coupon
        final minimumAmount = _getCouponMinimumAmount(coupon);
        if (minimumAmount == null) {
          // No minimum requirement, skip
          continue;
        }

        // Check if cart subtotal is below minimum
        if (cartSubTotal < minimumAmount) {
          couponsToRemove.add(couponCode);
        } else {
        }
      }

      // Remove coupons that don't meet minimum requirements
      if (couponsToRemove.isNotEmpty) {
        for (final couponCode in couponsToRemove) {
          await removeCouponCode(couponCode);
        }
      } else {
      }
    } catch (e) {
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
      return false;
    }
  }

  /// Add coupon products to cart
  Future<Map<String, dynamic>> addCouponProductsToCart(
      String couponCode) async {
    try {
      // Prevent duplicate calls - if already adding items, return early
      if (_isAddingItems) {
        return {
          'success': false,
          'message': 'Items are already being added to cart',
          'error': 'ALREADY_ADDING_ITEMS'
        };
      }

      // Set flag to prevent duplicate calls
      _isAddingItems = true;
      // Get products from the actual coupon data
      final couponProducts = getCouponProducts(couponCode);

      if (couponProducts.isEmpty) {
        return {
          'success': false,
          'message': 'No products found for this coupon',
          'error': 'NO_PRODUCTS_DEFINED'
        };
      }
      for (int i = 0; i < couponProducts.length; i++) {
        // final product = couponProducts[i]; // Unused variable
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


          final res = await GraphqlService.client.value.mutate$AddToCart(
            cart_graphql.Options$Mutation$AddToCart(
              variables: cart_graphql.Variables$Mutation$AddToCart(
                variantId: productVariantId,
                qty: quantity,
              ),
            ),
          );

          if (res.hasException) {
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
            if (result is cart_graphql.Mutation$AddToCart$addItemToOrder$$Order) {
              // Update both controllers immediately after each product is added
              // This prevents the "cart is empty" UI issue
              try {
                final cartController = Get.find<CartController>();
                final orderController = Get.find<OrderController>();
                final resultJson = result.toJson();
                
                // Update CartController
                cartController.cart.value = cart_graphql.Fragment$Cart.fromJson(resultJson);
                // Update OrderController - refresh to get proper Fragment$Cart type
                await orderController.getActiveOrder(skipLoading: true);
              } catch (e) {
              }
              
              addedProducts.add({
                'product': productName,
                'quantity': quantity,
                'price': priceWithTax,
                'productVariantId': productVariantId,
              });
            } else if (result
                is cart_graphql.Mutation$AddToCart$addItemToOrder$$InsufficientStockError) {
              failedProducts
                  .add({'product': productName, 'error': 'Insufficient stock'});
            } else {
              failedProducts
                  .add({'product': productName, 'error': 'Unknown error'});
            }
          } else {
            failedProducts.add({
              'product': productName,
              'error': 'No result returned from server'
            });
          }
        } catch (e) {
          handleException(e,
              customErrorMessage: 'Failed to add product to cart');
          failedProducts.add({
            'product': product['name'],
            'error': 'Error adding product: $e'
          });
        }
      }

      utilityController.setLoadingState(false);
      if (addedProducts.isNotEmpty) {
        final addedProductIds = <String>[];
        for (final product in addedProducts) {
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
              } else {
          }
        }
          }
        }

        // Store the actual quantities added by this coupon (difference, not absolute)
        couponAddedProducts[couponCode] = actualAddedQuantities;
      }

      if (failedProducts.isNotEmpty) {
        for (final _ in failedProducts) {
          // Logging is commented out, so variable is unused
        }
      }

      // If ANY product failed, rollback all added products and return failure
      if (failedProducts.isNotEmpty) {
        // Rollback: Remove all successfully added products
        for (final addedProduct in addedProducts) {
          try {
            final productVariantId = addedProduct['productVariantId'] as String;
            
            // Find the order line for this product variant
            final cartController = Get.find<CartController>();
            final cart = cartController.cart.value;
            if (cart != null) {
              final cartLines = cart.lines;
              for (final line in cartLines) {
                final lineId = line.id;
                final variantIdFromCart = line.productVariant.id;
                
                if (variantIdFromCart == productVariantId) {
                  final success = await _removeOrderLineById(lineId);
                  if (success) {
                  } else {
                  }
                  break;
                }
              }
            }
          } catch (e) {
          }
        }
        
        // Clear tracked products for this coupon
        couponAddedProducts.remove(couponCode);
        return {
          'success': false,
          'message': 'Failed to add all coupon products. Added products have been removed.',
          'addedProducts': [],
          'failedProducts': failedProducts,
          'totalAdded': 0,
          'totalFailed': failedProducts.length,
          'rollbackPerformed': true,
          'suppressSnackbar': true,
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
        if (!allProductsAdded) 'suppressSnackbar': true,
      };
    } catch (e) {
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
    }
  }

  /// Apply coupon code with products: apply coupon first, then add products.
  /// If coupon apply fails, return error (nothing to rollback).
  /// If products add fails, remove the applied coupon and return error.
  Future<Map<String, dynamic>> applyCouponCodeWithProducts(
      String couponCode) async {
    Logger.logFunction(functionName: 'applyCouponCodeWithProducts', mutationName: 'ApplyCouponCode');
    
    try {
      // Step 1: Find the coupon
      Query$GetCouponCodeList$getCouponCodeList$items? coupon;
      try {
        coupon = availableCouponCodes.firstWhere(
          (c) => (c.couponCode ?? '').toLowerCase() == couponCode.toLowerCase(),
        );
      } catch (e) {
        return {
          'success': false,
          'message': 'Coupon code not found',
          'error': 'COUPON_NOT_FOUND'
        };
      }

      // Step 2: Check minimum order amount FIRST
      final minimumAmountValidation = await _validateMinimumOrderAmount(coupon);
      
      Map<String, dynamic>? addResult;
      
      // Step 2: If minimum not met, show dialog and return (don't apply coupon or add products)
      if (!minimumAmountValidation['valid']) {
        ErrorDialog.showWarning(
          message: minimumAmountValidation['message'] as String,
        );
        return {
          'success': false,
          'message': minimumAmountValidation['message'],
          'error': 'MINIMUM_ORDER_AMOUNT_NOT_MET',
          'requiredAmount': minimumAmountValidation['requiredAmount'],
          'currentAmount': minimumAmountValidation['currentAmount'],
          'dialogShown': true,
        };
      }

      // Step 3: Apply coupon code FIRST (before adding products)
      final couponResult = await _applyCouponCodeWithoutMinimumCheck(couponCode);

      if (!couponResult['success']) {
        // Coupon apply failed - nothing to rollback (no products added yet)
        final errorMessage = couponResult['message'] as String? ?? 'Failed to apply coupon code';
        ErrorDialog.showWarning(message: errorMessage);
        await _refreshCartAfterCouponError();
        return {
          'success': false,
          'message': errorMessage,
          'couponApplied': false,
          'couponError': couponResult['error'],
          'dialogShown': true,
        };
      }

      // Step 4: Coupon applied successfully - now add coupon products (if any)
      final hasProducts = hasCouponProducts(couponCode);
      if (hasProducts) {
        addResult = await addCouponProductsToCart(couponCode);
        if (!addResult['success']) {
          // Adding products failed - remove the coupon we just applied
          await removeCouponCode(couponCode);
          _refreshCartAfterCouponError();
          String errorMsg = addResult['message'] as String? ?? 'Failed to add coupon products to cart.';
          final failedProducts = addResult['failedProducts'] as List<dynamic>? ?? [];
          if (failedProducts.isNotEmpty) {
            final details = failedProducts.map((f) {
              final p = f as Map<String, dynamic>?;
              final name = p?['product'] ?? 'Product';
              final err = p?['error'] ?? 'Unknown error';
              return '$name: $err';
            }).join('\n');
            if (details.isNotEmpty) errorMsg = '$errorMsg\n\n$details';
          }
          ErrorDialog.showWarning(
            message: '$errorMsg\n\nCoupon has been removed.',
          );
          return {
            'success': false,
            'message': errorMsg,
            'error': 'PRODUCT_ADDITION_FAILED',
            'addResult': addResult,
            'couponRemoved': true,
            'dialogShown': true,
          };
        }
      }

      // Success: coupon applied and products added (if any)
      try {
        final cartController = Get.find<CartController>();
        await cartController.getActiveOrder();
      } catch (e) {
      }
      try {
        await restoreCouponTrackingFromCart();
      } catch (e) {
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
    } catch (e) {
      // On error: remove coupon if applied, and any coupon-added products
      bool rollbackPerformed = false;
      try {
        await removeCouponCode(couponCode);
        if (couponAddedProducts.containsKey(couponCode)) {
          rollbackPerformed = await removeCouponProducts(couponCode);
        }
        originalCartQuantities.remove(couponCode);
        await _refreshCartAfterCouponError();
      } catch (_) {
        await _refreshCartAfterCouponError();
      }
      return {
        'success': false,
        'message': 'Error applying coupon. Please try again.',
        'error': 'APPLY_COUPON_WITH_PRODUCTS_ERROR',
        'rollbackPerformed': rollbackPerformed,
      };
    }
  }

  /// Rollback added products when coupon application fails (kept for optional use; currently we do not remove products on apply failure).
  // ignore: unused_element
  Future<Map<String, dynamic>> _rollbackAddedProducts(String couponCode) async {
    try {
      // Check if we have tracked products for this coupon
      if (!couponAddedProducts.containsKey(couponCode)) {
        return {
          'success': true,
          'message': 'No products to rollback',
          'removedCount': 0
        };
      }

      final productsToRemove = couponAddedProducts[couponCode]!;
      // Get current cart to find order line IDs for these products
      final cartController = Get.find<CartController>();
      final cart = cartController.cart.value;
      if (cart == null) {
        return {
          'success': false,
          'message': 'No active cart found',
          'removedCount': 0
        };
      }

      final cartLines = cart.lines;
      int removedCount = 0;
      final failedRemovals = <String>[];

      for (final entry in productsToRemove.entries) {
        final variantId = entry.key;
        final quantityToRemove = entry.value;
        bool found = false;

        // Find order lines that match this variant ID
        for (final line in cartLines) {
          final lineId = line.id;
          final currentQuantity = line.quantity;
          final variantIdFromCart = line.productVariant.id;
          if (variantIdFromCart == variantId) {
            found = true;
            // Calculate new quantity after removing coupon-added quantity
            final newQuantity = currentQuantity - quantityToRemove;
            
            if (newQuantity <= 0) {
              // Remove the entire line if quantity becomes 0 or negative
              // This happens when: currentQuantity <= quantityToRemove
              final success = await _removeOrderLineById(lineId);
              if (success) {
                removedCount++;
                // Update controllers after removal
                try {
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
                } catch (e) {
                }
              } else {
                failedRemovals.add('Line $lineId for variant $variantId');
              }
            } else {
              // Decrease quantity instead of removing the line
              // This happens when: currentQuantity > quantityToRemove
              final success = await cartController.adjustOrderLine(
                orderLineId: lineId,
                quantity: newQuantity,
              );
              if (success) {
                removedCount++;
                // Update controllers after quantity adjustment
                try {
                  final orderController = Get.find<OrderController>();
                  await orderController.getActiveOrder(skipLoading: true);
                } catch (e) {
                }
              } else {
                failedRemovals.add('Line $lineId for variant $variantId');
              }
            }
            break; // Process only one instance per variant ID
          }
        }

        if (!found) {
        }
      }
      // Clear the tracked products for this coupon
      couponAddedProducts.remove(couponCode);
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
      // Simply call the service method
      final updateService = InAppUpdateService();
      await updateService.checkForUpdatesAndDetermineType();
    } catch (e) {
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
        utilityController.setLoadingState(false);
        return null;
      }

      final productData = result.data?['product'];
      if (productData != null) {
        productDetail.value = productData as Map<String, dynamic>;
        utilityController.setLoadingState(false);
        return productData;
      } else {
        utilityController.setLoadingState(false);
        return null;
      }
    } catch (e) {
      utilityController.setLoadingState(false);
      return null;
    }
  }

  /// Handle customer data not found - clear cache and logout (fallback method)
  Future<void> _handleCustomerDataNotFound() async {
    try {
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
    } catch (e) {
      // Still navigate to login even if cleanup fails
      Get.offAllNamed('/login');
    }
  }
}
