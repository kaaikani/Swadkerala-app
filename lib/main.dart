import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled2/services/graphql_client.dart';
import 'routes.dart';
import 'controllers/utilitycontroller/utilitycontroller.dart';
import 'controllers/authentication/authenticationcontroller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage

  await GetStorage.init();
  await dotenv.load(fileName: ".env"); // <-- load dotenv first
  await GraphqlService.initialize();
  
  // Initialize controllers
  Get.put(UtilityController());
  Get.put<AuthController>(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
    );
  }
}

