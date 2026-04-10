import 'app_image_cache_manager.dart';

/// Pre-downloads critical images to disk cache in the background
/// so they load instantly when the user sees them.
class ImageWarmupService {
  static Future<void> warmup(List<String> urls) async {
    final manager = AppImageCacheManager.instance;
    final futures = urls.take(20).map((url) async {
      try {
        await manager.getSingleFile(url);
      } catch (_) {
        // Silently ignore individual failures
      }
    });
    await Future.wait(futures);
  }
}
