import 'dart:async';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart'
    show Context, HttpLinkHeaders, gql;
import '../../graphql/banner.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../../services/channel_service.dart';
import '../../services/analytics_service.dart';
import '../utilitycontroller/utilitycontroller.dart';
import '../base_controller.dart';
import '../cart/Cartcontroller.dart';
import '../customer/customer_controller.dart';
import '../../utils/logger.dart';
import '../../routes.dart';
import '../../utils/navigation_helper.dart';

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
    if (GraphqlService.authToken.isEmpty) {
      NavigationHelper.showLoginRequiredDialog(
        title: 'Login required',
        message: 'Kindly login to like products.',
        intendedRoute: AppRoutes.favourite,
      );
      return false;
    }
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
        // Customer not logged in or no customer in response (e.g. guest) - just clear favorites, do NOT logout
        favoritesList.clear();
        favoritesTotalItems.value = 0;
        favoriteProductIds.clear();
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
  // COUPON CODE - Moved to CouponController (lib/controllers/coupon/coupon_controller.dart)
  // ============================================================================

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
                group {
                  name
                }
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
            optionGroups {
              id
              name
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

}
