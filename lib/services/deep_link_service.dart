import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../routes.dart';
import '../utils/navigation_helper.dart';
import '../controllers/authentication/authenticationcontroller.dart';
import 'graphql_client.dart';

/// Service to handle deep links and app links
/// Supports both custom URL schemes and universal links
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<Uri>? _initialLinkSubscription;

  /// Navigate to login page.
  Future<void> _navigateToLoginPage({Map<String, dynamic>? arguments, bool replace = false}) async {
    if (replace) {
      Get.offAllNamed(AppRoutes.login, arguments: arguments);
    } else {
      Get.toNamed(AppRoutes.login, arguments: arguments);
    }
  }

  /// Check if user is authenticated
  bool _isUserAuthenticated() {
    // Primary check: tokens in GraphqlService (most reliable)
    final authToken = GraphqlService.authToken;
    final channelToken = GraphqlService.channelToken;
    final hasValidTokens = authToken.isNotEmpty && channelToken.isNotEmpty;

    if (hasValidTokens) {
      return true;
    }

    // Fallback: check AuthController if tokens are not immediately available
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      final isLoggedIn = authController.isLoggedIn;
      return isLoggedIn;
    }

    return false;
  }

  bool _isInitialized = false;

  /// Initialize deep link service
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      _appLinks = AppLinks();
      _isInitialized = true;

      // Handle initial link (when app is opened from a link)
      _handleInitialLink();

      // Listen for incoming links while app is running
      _listenToIncomingLinks();
    } catch (e) {
      // Handle MissingPluginException for app_links
      if (e is MissingPluginException) {
        if (kDebugMode) {
          debugPrint('ERROR: app_links plugin not available - MissingPluginException');
          debugPrint('Error: ${e.message}');
          debugPrint('Deep linking will not work. App will continue normally.');
        }
        _isInitialized = false; // Mark as not initialized so we don't try again
      } else {
        // Other errors - log but don't crash
        if (kDebugMode) {
          debugPrint('ERROR: DeepLinkService initialization failed: $e');
        }
      }
    }
  }

  /// Handle initial link when app is opened from a deep link
  Future<void> _handleInitialLink() async {
    try {
      // Wait longer to ensure GetX and the app are fully initialized
      // The InitialRouteWrapper might be showing, so we need to wait for it to finish
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        // Mark this as an initial link so we can use offAllNamed
        _handleLink(initialLink, isInitialLink: true);
      }
    } catch (e) {
      // Handle MissingPluginException
      if (e is MissingPluginException) {
        if (kDebugMode) {
          debugPrint('ERROR: app_links plugin not available - cannot get initial link');
          debugPrint('Error: ${e.message}');
        }
      } else {
        if (kDebugMode) {
          debugPrint('ERROR: Failed to get initial deep link: $e');
        }
      }
    }
  }

  /// Listen for incoming links while app is running
  void _listenToIncomingLinks() {
    try {
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          _handleLink(uri, isInitialLink: false);
        },
        onError: (err) {
          if (kDebugMode) {
            debugPrint('ERROR: Deep link stream error: $err');
          }
        },
      );
    } catch (e) {
      // Handle MissingPluginException when trying to listen to stream
      if (e is MissingPluginException) {
        if (kDebugMode) {
          debugPrint('ERROR: app_links plugin not available - cannot listen to deep links');
          debugPrint('Error: ${e.message}');
          debugPrint('Deep linking will not work. App will continue normally.');
        }
      } else {
        if (kDebugMode) {
          debugPrint('ERROR: Failed to listen to deep link stream: $e');
        }
      }
    }
  }

  /// Handle the deep link and navigate accordingly
  void _handleLink(Uri uri, {bool isInitialLink = false}) {
    try {

      // Handle development/testing URLs (ngrok, demo server, etc.)
      // These should be treated as deep links, not HTTP requests
      if (uri.host.contains('ngrok') || 
          uri.host == 'demo.htagbilling.com' ||
          uri.host == '63f4005bb018.ngrok-free.app') {
      }

      // Handle custom schemes (kaaikani://, testapp://)
      if (uri.scheme == 'kaaikani' || uri.scheme == 'testapp') {
      }

      String path = uri.path;
      final queryParams = uri.queryParameters;

      // Handle custom schemes where the "host" is actually the path
      if (uri.scheme == 'kaaikani' || uri.scheme == 'testapp') {
        // For custom schemes like testapp://cart, the host becomes the path
        path = '/${uri.host}';
      }


      // Wait for navigation to be ready - longer delay for initial links
      final delay = isInitialLink ? 2000 : 500;
      Future.delayed(Duration(milliseconds: delay), () async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _navigateFromLink(path, queryParams, isInitialLink: isInitialLink);
        });
      });
    } catch (e) {
    }
  }

  /// Navigate based on the deep link path
  Future<void> _navigateFromLink(String path, Map<String, String> queryParams, {bool isInitialLink = false}) async {
    try {
      // Remove leading slash if present and convert to lowercase for case-insensitive matching
      final cleanPath = (path.startsWith('/') ? path.substring(1) : path).toLowerCase();


      // Check for query parameter navigation first
      if (queryParams.containsKey('page')) {
        final page = queryParams['page']?.toLowerCase();
        
        switch (page) {
          case 'cart':
            // Cart is open to guests (login required only at checkout)
            try {
              await NavigationHelper.navigateToCart(isInitialLink: isInitialLink);
              return;
            } catch (e) {
            }
            break;
          case 'checkout':
            // Check authentication before navigating to protected checkout page
            if (!_isUserAuthenticated()) {
              await _navigateToLoginPage(
                arguments: {'intendedRoute': AppRoutes.checkout, 'intendedArguments': null},
                replace: isInitialLink,
              );
              return;
            }
            
            try {
              await NavigationHelper.navigateToCheckout(isInitialLink: isInitialLink);
              return;
            } catch (e) {
            }
            break;
          case 'account':
            // Check authentication before navigating to protected account page
            if (!_isUserAuthenticated()) {
              await _navigateToLoginPage(
                arguments: {'intendedRoute': AppRoutes.account, 'intendedArguments': null},
                replace: isInitialLink,
              );
              return;
            }
            
            if (isInitialLink) {
              // For initial links, first navigate to home, then push the account page
              await Get.offAllNamed(AppRoutes.home);
              Get.toNamed(AppRoutes.account);
            } else {
              Get.toNamed(AppRoutes.account);
            }
            return;
          case 'addresses':
            // Check authentication before navigating to protected addresses page
            if (!_isUserAuthenticated()) {
              await _navigateToLoginPage(
                arguments: {'intendedRoute': AppRoutes.addresses, 'intendedArguments': null},
                replace: isInitialLink,
              );
              return;
            }
            
            if (isInitialLink) {
              // For initial links, first navigate to home, then push the addresses page
              await Get.offAllNamed(AppRoutes.home);
              Get.toNamed(AppRoutes.addresses);
            } else {
              Get.toNamed(AppRoutes.addresses);
            }
            return;
          case 'orders':
            // Check authentication before navigating to protected orders page
            if (!_isUserAuthenticated()) {
              await _navigateToLoginPage(
                arguments: {'intendedRoute': AppRoutes.orders, 'intendedArguments': null},
                replace: isInitialLink,
              );
              return;
            }
            
            if (isInitialLink) {
              // For initial links, first navigate to home, then push the orders page
              await Get.offAllNamed(AppRoutes.home);
              Get.toNamed(AppRoutes.orders);
            } else {
              Get.toNamed(AppRoutes.orders);
            }
            return;
          case 'category':
            final categoryId = queryParams['categoryId'] ?? queryParams['id'];
            final categoryName = queryParams['categoryName'] ?? queryParams['name'];
            final categorySlug = queryParams['categorySlug'] ?? queryParams['slug'];
            
            if (categoryId != null && categoryId.isNotEmpty) {
              
              // Determine the slug and display name
              String slug;
              String displayName;
              
              if (categorySlug != null && categorySlug.isNotEmpty) {
                slug = categorySlug;
                displayName = categoryName ?? categorySlug.replaceAll('-', ' ').toUpperCase();
              } else if (categoryName != null && categoryName.isNotEmpty) {
                slug = _convertNameToSlug(categoryName);
                displayName = categoryName;
              } else {
                slug = 'category-$categoryId';
                displayName = 'Category $categoryId';
              }
              
              final arguments = <String, dynamic>{
                'collectionId': categoryId,
                'collectionName': displayName,
                'slug': slug,
              };
              
              
              if (isInitialLink) {
                // For initial links, first navigate to home, then push the collection page
                await Get.offAllNamed(AppRoutes.home);
                Get.toNamed(AppRoutes.collectionProducts, arguments: arguments);
              } else {
                Get.toNamed(AppRoutes.collectionProducts, arguments: arguments);
              }
            } else {
              Get.offAllNamed(AppRoutes.initial);
            }
            return;
          case 'product':
            final productId = queryParams['productId'] ?? queryParams['id'];
            final productName = queryParams['productName'] ?? queryParams['name'];
            
            if (productId != null && productId.isNotEmpty) {
              
              // Check authentication before navigating to protected product detail page
              if (!_isUserAuthenticated()) {
                // Store the intended route and arguments for post-login redirection
                await _navigateToLoginPage(
                  arguments: {
                    'intendedRoute': AppRoutes.productDetail,
                    'intendedArguments': {
                      'productId': productId,
                      'productName': productName,
                    },
                  },
                  replace: isInitialLink,
                );
                return;
              }
              
              try {
                await NavigationHelper.navigateToProductDetail(
                  productId: productId,
                  productName: productName,
                  isInitialLink: isInitialLink,
                );
              } catch (e) {
                Get.offAllNamed(AppRoutes.initial);
              }
            } else {
              Get.offAllNamed(AppRoutes.initial);
            }
            return;
        }
      }

      // Route mapping (case-insensitive) - fallback to path-based routing
      switch (cleanPath) {
        case 'product':
        case 'products':
          final productId = queryParams['id'] ?? queryParams['productId'];
          if (productId != null) {
            await NavigationHelper.navigateToProductDetail(
              productId: productId,
              productName: queryParams['name'] ?? queryParams['productName'],
              isInitialLink: isInitialLink,
            );
          } else {
            Get.offAllNamed(AppRoutes.initial);
          }
          break;

        case 'collection':
        case 'collections':
        case 'category':
        case 'categories':
          final collectionId = queryParams['id'] ?? queryParams['collectionId'];
          final collectionName = queryParams['name'] ?? queryParams['collectionName'] ?? queryParams['categoryName'];
          final collectionSlug = queryParams['slug'] ?? queryParams['collectionSlug'] ?? queryParams['categorySlug'];
          
          if (collectionId != null) {
            
            final slug = collectionSlug ?? (collectionName != null ? _convertNameToSlug(collectionName) : 'collection-$collectionId');
            final displayName = collectionName ?? 'Collection $collectionId';
            
            if (isInitialLink) {
              // For initial links, first navigate to home, then push the collection page
              await Get.offAllNamed(AppRoutes.home);
              Get.toNamed(AppRoutes.collectionProducts, arguments: {
                'collectionId': collectionId,
                'collectionName': displayName,
                'slug': slug,
              });
            } else {
              Get.toNamed(AppRoutes.collectionProducts, arguments: {
                'collectionId': collectionId,
                'collectionName': displayName,
                'slug': slug,
              });
            }
          } else {
            Get.offAllNamed(AppRoutes.initial);
          }
          break;

        case 'order':
        case 'orders':
          final orderId = queryParams['id'] ?? queryParams['orderId'];
          final orderCode = queryParams['code'] ?? queryParams['orderCode'];
          if (orderId != null || orderCode != null) {
            if (isInitialLink) {
              Get.offAllNamed(AppRoutes.orderDetail, arguments: orderCode ?? orderId ?? '');
            } else {
              Get.toNamed(AppRoutes.orderDetail, arguments: orderCode ?? orderId ?? '');
            }
          } else {
            if (isInitialLink) {
              Get.offAllNamed(AppRoutes.orders);
            } else {
              Get.toNamed(AppRoutes.orders);
            }
          }
          break;

        case 'cart':
          try {
            await NavigationHelper.navigateToCart(isInitialLink: isInitialLink);
          } catch (e) {
            // Fallback: try to go to initial route
            Get.offAllNamed(AppRoutes.initial);
          }
          break;

        case 'checkout':
          try {
            await NavigationHelper.navigateToCheckout(isInitialLink: isInitialLink);
          } catch (e) {
            // Fallback: try to go to cart first, then user can proceed
            await NavigationHelper.navigateToCart(isInitialLink: isInitialLink);
          }
          break;

        case 'account':
        case 'profile':
          if (isInitialLink) {
            Get.offAllNamed(AppRoutes.account);
          } else {
            Get.toNamed(AppRoutes.account);
          }
          break;

        case 'admin':
          // Admin path - navigate to account page or home as fallback
          // You can change this to navigate to a specific admin page if you have one
          if (isInitialLink) {
            Get.offAllNamed(AppRoutes.account);
          } else {
            Get.toNamed(AppRoutes.account);
          }
          break;

        case 'login':
          await _navigateToLoginPage(replace: isInitialLink);
          break;

        case 'signup':
        case 'register':
          if (isInitialLink) {
            Get.offAllNamed(AppRoutes.signup);
          } else {
            Get.toNamed(AppRoutes.signup);
          }
          break;

        case 'home':
          Get.offAllNamed(AppRoutes.initial);
          break;

        default:
          // If path is empty or just '/', go to initial route (respects AuthWrapper)
          if (cleanPath.isEmpty || cleanPath == '/') {
            Get.offAllNamed(AppRoutes.initial);
          } else {
            // Try to navigate to initial route as fallback (respects AuthWrapper)
            Get.offAllNamed(AppRoutes.initial);
          }
          break;
      }
    } catch (e) {
      // Fallback to initial route on any error
      try {
        Get.offAllNamed(AppRoutes.initial);
      } catch (fallbackError) {
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    _initialLinkSubscription?.cancel();
    _isInitialized = false;
  }

  /// Convert category name to slug format
  /// Example: "Special Offer" -> "special-offer"
  String _convertNameToSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with hyphens
        .replaceAll(RegExp(r'-+'), '-') // Replace multiple hyphens with single
        .replaceAll(RegExp(r'^-|-$'), ''); // Remove leading/trailing hyphens
  }

}



