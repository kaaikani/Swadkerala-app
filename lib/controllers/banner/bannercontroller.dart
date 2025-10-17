import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphql/banner.graphql.dart';
import '../../graphql/schema.graphql.dart';
import '../../services/graphql_client.dart';
import '../utilitycontroller/utilitycontroller.dart';
import 'bannermodels.dart';


class BannerController extends GetxController {
  final RxList<BannerModel> bannerList = <BannerModel>[].obs;
  final RxList<SearchItemModel> searchResults = <SearchItemModel>[].obs;
  final RxInt totalItems = 0.obs;
  
  // Favorites
  final RxList<FavoriteItemModel> favoritesList = <FavoriteItemModel>[].obs;
  final RxSet<String> favoriteProductIds = <String>{}.obs;
  final RxInt favoritesTotalItems = 0.obs;

  final GraphqlService graphqlService = GraphqlService();

  // Inject UtilityController
  final UtilityController utilityController = Get.find<UtilityController>();

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

      if (res.hasException) {
        utilityController.setLoadingState(false);
        return;
      }

      if (res.data != null) {
        List<dynamic> jsonList = res.data!["customBanners"];
        List<BannerModel> fetchedBanners = jsonList
            .map((json) => BannerModel.fromJson(json))
            .toList();

        bannerList.assignAll(fetchedBanners);
      } else {
      }

      utilityController.setLoadingState(false);
    } catch (e) {
      utilityController.setLoadingState(false);
    }
  }







  Future<void> searchProducts(Map<String, dynamic> input) async {
    final term = (input['term'] ?? '').trim();

    // If search term is empty, clear results and return
    if (term.isEmpty) {
      searchResults.clear();
      totalItems.value = 0;
      return;
    }

    try {
      utilityController.setLoadingState(true);

      final inputObj = Input$SearchInput(term: term);
      final variables = Variables$Query$Search(input: inputObj);


      final res = await GraphqlService.client.value.query$Search(
        Options$Query$Search(variables: variables),
      );

      if (res.hasException) {
        searchResults.clear();
        totalItems.value = 0;
        utilityController.setLoadingState(false);
        return;
      }

      final items = res.data?['search']['items'] as List<dynamic>? ?? [];
      final total = res.data?['search']['totalItems'] as int? ?? 0;


      final fetchedItems = items.map((e) => SearchItemModel.fromJson(e)).toList();

      searchResults.assignAll(fetchedItems);
      totalItems.value = total;

      utilityController.setLoadingState(false);

    } catch (e) {
      searchResults.clear();
      totalItems.value = 0;
      utilityController.setLoadingState(false);
    }
  }

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

      if (res.hasException) {
        debugPrint('[BannerController] ToggleFavorite Exception: ${res.exception}');
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
        
        debugPrint('[BannerController] Toggle favorite success. Total favorites: ${result.totalItems}');
        utilityController.setLoadingState(false);
        return true;
      }

      utilityController.setLoadingState(false);
      return false;
    } catch (e) {
      debugPrint('[BannerController] Toggle favorite error: $e');
      utilityController.setLoadingState(false);
      return false;
    }
  }

  /// Get customer favorites
  Future<void> getCustomerFavorites() async {
    try {
      utilityController.setLoadingState(false);

      final res = await GraphqlService.client.value.query$GetCustomerFavorites(
        Options$Query$GetCustomerFavorites(),
      );

      if (res.hasException) {
        debugPrint('[BannerController] GetCustomerFavorites Exception: ${res.exception}');
        utilityController.setLoadingState(false);
        return;
      }

      final activeCustomer = res.data?['activeCustomer'];
      
      if (activeCustomer != null && activeCustomer['__typename'] == 'Customer') {
        final favoritesData = activeCustomer['favorites'];
        
        if (favoritesData != null) {
          final favorites = FavoritesModel.fromJson(favoritesData);
          favoritesList.assignAll(favorites.items);
          favoritesTotalItems.value = favorites.totalItems;
          
          // Update favorite product IDs set
          favoriteProductIds.clear();
          favoriteProductIds.addAll(favorites.items.map((item) => item.product.id));
          
          debugPrint('[BannerController] Fetched ${favorites.totalItems} favorites');
          
          // Debug: Log image URLs
          for (var item in favorites.items) {
            final imageUrl = item.product.featuredAsset?.preview;
            debugPrint('[BannerController] Product: ${item.product.name}, Image: ${imageUrl ?? "NO IMAGE"}');
          }
        }
      }

      utilityController.setLoadingState(false);
    } catch (e) {
      debugPrint('[BannerController] Get favorites error: $e');
      utilityController.setLoadingState(false);
    }
  }

  /// Check if a product is in favorites
  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }
}

