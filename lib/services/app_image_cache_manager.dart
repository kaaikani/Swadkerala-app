import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Custom cache manager for app images with higher limits than the default.
/// Ensures images persist on disk across app restarts.
class AppImageCacheManager {
  static const _key = 'swadKeralaCachedImageData';

  static final instance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: _key),
      fileService: HttpFileService(),
    ),
  );

  /// Strips query parameters from a URL to normalize the cache key.
  /// This ensures the same image at different sizes shares one disk entry.
  static String normalizedCacheKey(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.replace(query: '').toString();
    } catch (_) {
      return url;
    }
  }
}
