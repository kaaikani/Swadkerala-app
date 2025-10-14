import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controllers/collection%20controller/collectioncontroller.dart';

import '../controllers/collection controller/Collectionmodel.dart';
import '../widgets/card.dart' show AppCard;


class CollectionGrid extends StatelessWidget {
  final Function(Collection) onCollectionTap;
  final CollectionsController collectionsController = Get.put(CollectionsController());

  CollectionGrid({Key? key, required this.onCollectionTap}) : super(key: key) {
    // Fetch all collections after widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionsController.fetchAllCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (collectionsController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (collectionsController.allCollections.isEmpty) {
        return Center(child: Text('No collections found'));
      }

      return GridView.builder(
        physics: NeverScrollableScrollPhysics(), // ⚡ disable GridView scrolling
        shrinkWrap: true,                       // ⚡ make it fit content
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: collectionsController.allCollections.length,
        itemBuilder: (context, index) {
          final collection = collectionsController.allCollections[index];
          return GestureDetector(
            onTap: () => onCollectionTap(collection),
            child: CollectionCard(collection: collection),
          );
        },
      );
    });
  }
}


class CollectionCard extends StatelessWidget {
  final Collection collection;

  const CollectionCard({Key? key, required this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: 2, // optional, you can skip it if you want default
      child: Column(
        children: [
          // Collection Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: collection.featuredAsset != null
                    ? DecorationImage(
                  image: NetworkImage(collection.featuredAsset!.preview),
                  fit: BoxFit.contain,
                )
                    : null,
                color: Colors.grey[200],
              ),
              child: collection.featuredAsset == null
                  ? Icon(Icons.category, size: 40, color: Colors.grey[400])
                  : null,
            ),
          ),

          // Collection Info
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      collection.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
