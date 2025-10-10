import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../components/bottomnavigationbar.dart';
import '../components/product.dart';
import '../context/context.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import '../theme/sizes.dart';
import '../widgets/appbar.dart';


class MyHomePage extends StatelessWidget {
  // Removed const constructor
  MyHomePage({Key? key}) : super(key: key);

  final box = GetStorage(); // Can’t be const

  void _handleLogout(BuildContext context) async {
    final authController = Get.find<AuthController>();
    await authController.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final cityName = box.read('channel_code') ?? 'Default City'; // runtime value

    return Scaffold(
      appBar: AppBarWidget(
        title: cityName, // dynamic title
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Favorite pressed')),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            child: const Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultMargin),
        child: GridView.builder(
          itemCount: AppContent.productImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSizes.defaultMargin,
            crossAxisSpacing: AppSizes.defaultMargin,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return ProductComponent(
              imageUrl: AppContent.productImages[index],
              title: "Product ${index + 1}",
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavComponent(),
    );
  }
}

