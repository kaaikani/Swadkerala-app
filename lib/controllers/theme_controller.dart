import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();
  final RxBool _isDarkMode = false.obs;
  
  bool get isDarkMode => _isDarkMode.value;
  
  @override
  void onInit() {
    super.onInit();
    // Load saved theme preference
    _isDarkMode.value = _storage.read('isDarkMode') ?? false;
  }
  
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.write('isDarkMode', _isDarkMode.value);
    // Force rebuild to update theme
    update();
  }
  
  void setDarkMode(bool value) {
    _isDarkMode.value = value;
    _storage.write('isDarkMode', value);
    // Force rebuild to update theme
    update();
  }
}

