import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled2/controllers/banner/bannercontroller.dart';
import 'package:untitled2/controllers/collection%20controller/collectioncontroller.dart';
import '../components/bannercomponent.dart';
import '../components/bottomnavigationbar.dart';
import '../components/collectioncomponent.dart';
import '../components/searchbarcomponent.dart';
import '../widgets/appbar.dart';
import 'Collectionprodcutpage.dart';


class MyHomePage extends StatelessWidget {
  // Removed const constructor
  MyHomePage({Key? key}) : super(key: key);
  final box = GetStorage(); // Can’t be const
  final BannerController bannerController = Get.put(BannerController());
  final CollectionsController collectioncontroller = Get.put(CollectionsController());



  @override
  Widget build(BuildContext context) {
    final cityName = box.read('channel_code') ?? 'Default City'; // runtime value
    Get.put(BannerController());
    return Scaffold(
      appBar: AppBarWidget(
        title: cityName,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/search');

            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed('/favourite');

            },
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed('/account');
            },
            icon: const Icon(Icons.person),
          ),
        ],

      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            SearchComponent(
              onSearch: (String query) {
                debugPrint("Searching for: $query");
                bannerController.searchProducts({'term': query});
              },
            ),
            BannerComponent(),

             CollectionGrid(
                  onCollectionTap: (collection) {
                    debugPrint('Collection clicked: ${collection.name}, ID: ${collection.id}');
                    Get.to(() => CollectionProductsPage(
                      collectionId: collection.id,
                      collectionName: collection.name,
                    ));
                  },

              ),

          ],
        ),
      ),
    bottomNavigationBar: BottomNavComponent(),
    );
  }
}



