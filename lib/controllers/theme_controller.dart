import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();
  final RxBool _isDarkMode = false.obs;
  
  bool get isDarkMode => _isDarkMode.value;
  
  // Initialize theme synchronously before onInit
  ThemeController() {
    // Load saved theme preference immediately
    _isDarkMode.value = _storage.read('isDarkMode') ?? false;
  }
  
  @override
  void onInit() {
    super.onInit();
    // Ensure theme is loaded (in case storage wasn't ready in constructor)
    if (!_storage.hasData('isDarkMode')) {
      _isDarkMode.value = false;
    } else {
    _isDarkMode.value = _storage.read('isDarkMode') ?? false;
    }
  }
  
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    // Write to storage synchronously to ensure persistence
    _storage.write('isDarkMode', _isDarkMode.value);
    // Wait for storage write to complete
    _storage.save();
    // Force rebuild - the Obx in main.dart will rebuild GetMaterialApp
    // No need to call update() as we're using reactive variables
  }
  
  void setDarkMode(bool value) {
    if (_isDarkMode.value == value) return; // Avoid unnecessary updates
    
    _isDarkMode.value = value;
    // Write to storage synchronously to ensure persistence
    _storage.write('isDarkMode', value);
    // Wait for storage write to complete
    _storage.save();
    // Force rebuild - the Obx in main.dart will rebuild GetMaterialApp
    // No need to call update() as we're using reactive variables
  }
}

