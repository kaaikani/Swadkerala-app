import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/collection controller/collectioncontroller.dart';
import '../widgets/appbar.dart';

class CollectionProductsPage extends StatelessWidget {
  final String collectionId;
  final String collectionName;
  final CollectionsController controller = Get.find();

  CollectionProductsPage({
    Key? key,
    required this.collectionId,
    required this.collectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: collectionName,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Optional search action
            },
          ),
        ],
      ),
    );
  }
}