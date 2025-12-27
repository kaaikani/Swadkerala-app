import 'package:get/get.dart';
import '../../controllers/utilitycontroller/utilitycontroller.dart';

/// Mixin for handling loading states across controllers
mixin LoadingMixin {
  /// Get the utility controller for loading state management
  UtilityController get utilityController => Get.find<UtilityController>();

  /// Set loading state
  void setLoading(bool isLoading) {
    utilityController.setLoadingState(isLoading);
  }

  /// Execute an action with loading state management
  /// Automatically sets loading to true before action and false after
  Future<T> withLoading<T>(Future<T> Function() action) async {
    try {
      setLoading(true);
      return await action();
    } finally {
      setLoading(false);
    }
  }

  /// Check if currently loading
  bool get isLoading => utilityController.isLoadingRx.value;
}










