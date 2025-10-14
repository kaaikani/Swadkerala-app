import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controllers/utilitycontroller/utilitycontroller.dart';

import '../../graphql/collections.graphql.dart';
import '../../services/graphql_client.dart';
import 'Collectionmodel.dart';

class CollectionsController extends GetxController {
  RxList<Collection> allCollections = <Collection>[].obs;
  RxBool isLoading = false.obs;

  Future<bool> fetchAllCollections() async {
    debugPrint('[Collection] Starting fetchAllCollections...');

    isLoading.value = true;

    try {
      final response = await GraphqlService.client.value.query$Collections(
        Options$Query$Collections(
          // variables: Variables$Query$Collections(options: options), // remove this if undefined
        ),
      );

      if (response.hasException) {
        debugPrint('[Collection] GraphQL Exception: ${response.exception.toString()}');
        return false;
      }

      final itemsJson = response.parsedData?.collections?.items;
      if (itemsJson != null) {
        allCollections.value = itemsJson
            .map((e) => Collection.fromJson(e.toJson()))
            .toList();
        debugPrint('[Collection] Loaded ${allCollections.length} collections');
      } else {
        debugPrint('[Collection] No collections found');
      }

      return true;
    } catch (e, stacktrace) {
      debugPrint('[Collection] Exception fetching collections: $e');
      debugPrint('[Collection] Stacktrace: $stacktrace');
      return false;
    } finally {
      isLoading.value = false;
      debugPrint('[Collection] fetchAllCollections finished.');
    }
  }
}

