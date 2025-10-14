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

  final GraphqlService graphqlService = GraphqlService();

  // Inject UtilityController
  final UtilityController utilityController = Get.find<UtilityController>();

  // Fetch banners
  Future<void> getBannersForChannel() async {
    try {
      utilityController.setLoadingState(true); // ✅ Set shared loading state

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
}

