import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();
  final RxBool _isDarkMode = false.obs;
  
  bool get isDarkMode => _isDarkMode.value;
  
  // Initialize theme synchronously before onInit
  ThemeController() {
    // Try to load saved theme preference immediately
    try {
      final savedTheme = _storage.read('isDarkMode');
      if (savedTheme != null) {
        _isDarkMode.value = savedTheme as bool;
      } else {
        _isDarkMode.value = false;
      }
    } catch (e) {
      // Storage might not be ready yet, default to light mode
      _isDarkMode.value = false;
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    // Reload theme from storage once storage is ready
    _loadThemeFromStorage();
    
    // Also reload after a short delay in case storage wasn't ready
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadThemeFromStorage();
    });
  }
  
  void _loadThemeFromStorage() {
    try {
      if (_storage.hasData('isDarkMode')) {
        final savedTheme = _storage.read('isDarkMode') as bool?;
        if (savedTheme != null && _isDarkMode.value != savedTheme) {
          _isDarkMode.value = savedTheme;
        }
      }
    } catch (e) {
      // Storage not ready yet, keep current value
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

