import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes.dart';

/// Service to handle deep links and app links
/// Supports both custom URL schemes and universal links
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<Uri>? _initialLinkSubscription;

  bool _isInitialized = false;

  /// Initialize deep link service
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('[DeepLink] Service already initialized');
      return;
    }

    try {
      _appLinks = AppLinks();
      _isInitialized = true;
      debugPrint('[DeepLink] Service initialized');

      // Handle initial link (when app is opened from a link)
      _handleInitialLink();

      // Listen for incoming links while app is running
      _listenToIncomingLinks();
    } catch (e) {
      debugPrint('[DeepLink] Initialization error: $e');
    }
  }

  /// Handle initial link when app is opened from a deep link
  Future<void> _handleInitialLink() async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        debugPrint('[DeepLink] Initial link received: $initialLink');
        _handleLink(initialLink);
      }
    } catch (e) {
      debugPrint('[DeepLink] Error getting initial link: $e');
    }
  }

  /// Listen for incoming links while app is running
  void _listenToIncomingLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        debugPrint('[DeepLink] Incoming link: $uri');
        _handleLink(uri);
      },
      onError: (err) {
        debugPrint('[DeepLink] Link stream error: $err');
      },
    );
  }

  /// Handle the deep link and navigate accordingly
  void _handleLink(Uri uri) {
    try {
      debugPrint('[DeepLink] Processing link: $uri');
      debugPrint('[DeepLink] Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');

      final path = uri.path;
      final queryParams = uri.queryParameters;

      // Wait for navigation to be ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateFromLink(path, queryParams);
      });
    } catch (e) {
      debugPrint('[DeepLink] Error handling link: $e');
    }
  }

  /// Navigate based on the deep link path
  void _navigateFromLink(String path, Map<String, String> queryParams) {
    try {
      // Remove leading slash if present
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;

      debugPrint('[DeepLink] Navigating to: $cleanPath with params: $queryParams');

      // Route mapping
      switch (cleanPath) {
        case 'product':
        case 'products':
          final productId = queryParams['id'] ?? queryParams['productId'];
          if (productId != null) {
            Get.toNamed(AppRoutes.productDetail, arguments: {'productId': productId});
          }
          break;

        case 'collection':
        case 'collections':
        case 'category':
        case 'categories':
          final collectionId = queryParams['id'] ?? queryParams['collectionId'];
          final collectionSlug = queryParams['slug'] ?? queryParams['collectionSlug'];
          if (collectionId != null || collectionSlug != null) {
            Get.toNamed(AppRoutes.collectionProducts, arguments: {
              'collectionId': collectionId,
              'collectionSlug': collectionSlug,
            });
          }
          break;

        case 'order':
        case 'orders':
          final orderId = queryParams['id'] ?? queryParams['orderId'];
          final orderCode = queryParams['code'] ?? queryParams['orderCode'];
          if (orderId != null || orderCode != null) {
            Get.toNamed(AppRoutes.orderDetail, arguments: {
              'orderId': orderId,
              'orderCode': orderCode,
            });
          } else {
            Get.toNamed(AppRoutes.orders);
          }
          break;

        case 'cart':
          Get.toNamed(AppRoutes.cart);
          break;

        case 'checkout':
          Get.toNamed(AppRoutes.checkout);
          break;

        case 'account':
        case 'profile':
          Get.toNamed(AppRoutes.account);
          break;

        case 'login':
          Get.toNamed(AppRoutes.login);
          break;

        case 'signup':
        case 'register':
          Get.toNamed(AppRoutes.signup);
          break;

        case 'home':
          Get.offAllNamed(AppRoutes.home);
          break;

        default:
          // If path is empty or just '/', go to home
          if (cleanPath.isEmpty || cleanPath == '/') {
            Get.offAllNamed(AppRoutes.home);
          } else {
            debugPrint('[DeepLink] Unknown path: $cleanPath');
            // Try to navigate to home as fallback
            Get.offAllNamed(AppRoutes.home);
          }
          break;
      }
    } catch (e) {
      debugPrint('[DeepLink] Navigation error: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    _initialLinkSubscription?.cancel();
    _isInitialized = false;
    debugPrint('[DeepLink] Service disposed');
  }
}

