// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:recipe.app/controllers/theme_controller.dart';

class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider() {
    _documentsDir = Directory.systemTemp.createTempSync('kaaikani_test_docs');
  }

  late final Directory _documentsDir;

  @override
  Future<String?> getApplicationDocumentsPath() async => _documentsDir.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Get.testMode = true;
    PathProviderPlatform.instance = _TestPathProvider();
    await GetStorage.init();
  });

  testWidgets('ThemeController toggles between light and dark mode',
      (WidgetTester tester) async {
    final themeController = Get.put(ThemeController());

    await tester.pumpWidget(
      Obx(
        () => GetMaterialApp(
          themeMode:
              themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            body: Text(themeController.isDarkMode ? 'Dark' : 'Light'),
          ),
        ),
      ),
    );

    expect(find.text('Light'), findsOneWidget);

    themeController.toggleTheme();
    await tester.pump();

    expect(find.text('Dark'), findsOneWidget);
  });
}
