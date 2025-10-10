import 'package:get/get.dart';

class UtilityController extends GetxController {
  final RxBool _isLoading = false.obs;

  // Public reactive stream
  RxBool get isLoadingRx => _isLoading;

  bool get isLoading => _isLoading.value;

  void setLoadingState(bool value) {
    _isLoading.value = value;
  }
}
