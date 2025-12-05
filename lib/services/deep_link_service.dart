import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
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

  /// Check if user is authenticated
  bool _isUserAuthenticated() {
    // Primary check: tokens in GraphqlService (most reliable)
    final authToken = GraphqlService.authToken;
    final channelToken = GraphqlService.channelToken;
    final hasValidTokens = authToken.isNotEmpty && channelToken.isNotEmpty;

    if (hasValidTokens) {
debugPrint('[DeepLink] Auth status - authToken: ${authToken.isNotEmpty}, channelToken: ${channelToken.isNotEmpty} (via GraphqlService)');
      return true;
    }

    // Fallback: check AuthController if tokens are not immediately available
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      final isLoggedIn = authController.isLoggedIn;
debugPrint('[DeepLink] Auth status - isLoggedIn: $isLoggedIn (via AuthController)');
      return isLoggedIn;
    }

debugPrint('[DeepLink] Auth status - Not authenticated (no tokens, no AuthController)');
    return false;
  }

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
      // Wait longer to ensure GetX and the app are fully initialized
      // The InitialRouteWrapper might be showing, so we need to wait for it to finish
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
debugPrint('[DeepLink] Initial link received: $initialLink');
        // Mark this as an initial link so we can use offAllNamed
        _handleLink(initialLink, isInitialLink: true);
      } else {
debugPrint('[DeepLink] No initial link found');
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
        _handleLink(uri, isInitialLink: false);
      },
      onError: (err) {
debugPrint('[DeepLink] Link stream error: $err');
      },
    );
  }

  /// Handle the deep link and navigate accordingly
  void _handleLink(Uri uri, {bool isInitialLink = false}) {
    try {
debugPrint('[DeepLink] Processing link: $uri (isInitialLink: $isInitialLink)');
debugPrint('[DeepLink] Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');

      // Handle development/testing URLs (ngrok, demo server, etc.)
      // These should be treated as deep links, not HTTP requests
      if (uri.host.contains('ngrok') || 
          uri.host == 'demo.htagbilling.com' ||
          uri.host == '63f4005bb018.ngrok-free.app') {
debugPrint('[DeepLink] Development/Testing URL detected - treating as deep link');
      }

      // Handle custom schemes (kaaikani://, testapp://)
      if (uri.scheme == 'kaaikani' || uri.scheme == 'testapp') {
debugPrint('[DeepLink] Custom scheme detected: ${uri.scheme}://');
      }

      String path = uri.path;
      final queryParams = uri.queryParameters;

      // Handle custom schemes where the "host" is actually the path
      if (uri.scheme == 'kaaikani' || uri.scheme == 'testapp') {
        // For custom schemes like testapp://cart, the host becomes the path
        path = '/${uri.host}';
debugPrint('[DeepLink] Custom scheme - using host as path: $path');
      }

debugPrint('[DeepLink] Extracted path: $path, Query params: $queryParams');

      // Wait for navigation to be ready - longer delay for initial links
      final delay = isInitialLink ? 2000 : 500;
      Future.delayed(Duration(milliseconds: delay), () async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _navigateFromLink(path, queryParams, isInitialLink: isInitialLink);
        });
      });
    } catch (e) {
debugPrint('[DeepLink] Error handling link: $e');
    }
  }

  /// Navigate based on the deep link path
  Future<void> _navigateFromLink(String path, Map<String, String> queryParams, {bool isInitialLink = false}) async {
    try {
      // Remove leading slash if present and convert to lowercase for case-insensitive matching
      final cleanPath = (path.startsWith('/') ? path.substring(1) : path).toLowerCase();

debugPrint('[DeepLink] 🔍 Original path: "$path"');
debugPrint('[DeepLink] 🔍 Clean path: "$cleanPath"');
debugPrint('[DeepLink] 🔍 Navigating to: $cleanPath with params: $queryParams (isInitialLink: $isInitialLink)');

      // Check for query parameter navigation first
      if (queryParams.containsKey('page')) {
        final page = queryParams['page']?.toLowerCase();
debugPrint('[DeepLink] 📋 Found page parameter: $page');
        
        switch (page) {
          case 'cart':
debugPrint('[DeepLink] 🛒 QUERY PARAM CART - Navigating to cart page');
            // Check authentication before navigating to protected cart page
            if (!_isUserAuthenticated()) {
debugPrint('[DeepLink] 🚫 User not authenticated, redirecting to login for cart');
              if (isInitialLink) {
                Get.offAllNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.cart,
                  'intendedArguments': null,
                });
              } else {
                Get.toNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.cart,
                  'intendedArguments': null,
                });
              }
debugPrint('[DeepLink] Redirected to login with cart as intended route');
              return;
            }
            
            try {
              await NavigationHelper.navigateToCart(isInitialLink: isInitialLink);
debugPrint('[DeepLink] Successfully navigated to cart via query param');
              return;
            } catch (e) {
debugPrint('[DeepLink] Error navigating to cart via query param: $e');
            }
            break;
          case 'checkout':
debugPrint('[DeepLink] 💳 QUERY PARAM CHECKOUT - Navigating to checkout page');
            // Check authentication before navigating to protected checkout page
            if (!_isUserAuthenticated()) {
debugPrint('[DeepLink] 🚫 User not authenticated, redirecting to login for checkout');
              if (isInitialLink) {
                Get.offAllNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.checkout,
                  'intendedArguments': null,
                });
              } else {
                Get.toNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.checkout,
                  'intendedArguments': null,
                });
              }
debugPrint('[DeepLink] Redirected to login with checkout as intended route');
              return;
            }
            
            try {
              await NavigationHelper.navigateToCheckout(isInitialLink: isInitialLink);
debugPrint('[DeepLink] Successfully navigated to checkout via query param');
              return;
            } catch (e) {
debugPrint('[DeepLink] Error navigating to checkout via query param: $e');
            }
            break;
          case 'account':
debugPrint('[DeepLink] 👤 QUERY PARAM ACCOUNT - Navigating to account page');
            // Check authentication before navigating to protected account page
            if (!_isUserAuthenticated()) {
debugPrint('[DeepLink] 🚫 User not authenticated, redirecting to login for account');
              if (isInitialLink) {
                Get.offAllNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.account,
                  'intendedArguments': null,
                });
              } else {
                Get.toNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.account,
                  'intendedArguments': null,
                });
              }
debugPrint('[DeepLink] Redirected to login with account as intended route');
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
debugPrint('[DeepLink] 📍 QUERY PARAM ADDRESSES - Navigating to addresses page');
            // Check authentication before navigating to protected addresses page
            if (!_isUserAuthenticated()) {
debugPrint('[DeepLink] 🚫 User not authenticated, redirecting to login for addresses');
              if (isInitialLink) {
                Get.offAllNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.addresses,
                  'intendedArguments': null,
                });
              } else {
                Get.toNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.addresses,
                  'intendedArguments': null,
                });
              }
debugPrint('[DeepLink] Redirected to login with addresses as intended route');
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
debugPrint('[DeepLink] 📦 QUERY PARAM ORDERS - Navigating to orders page');
            // Check authentication before navigating to protected orders page
            if (!_isUserAuthenticated()) {
debugPrint('[DeepLink] 🚫 User not authenticated, redirecting to login for orders');
              if (isInitialLink) {
                Get.offAllNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.orders,
                  'intendedArguments': null,
                });
              } else {
                Get.toNamed(AppRoutes.login, arguments: {
                  'intendedRoute': AppRoutes.orders,
                  'intendedArguments': null,
                });
              }
debugPrint('[DeepLink] Redirected to login with orders as intended route');
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
debugPrint('[DeepLink] 🏷️ QUERY PARAM CATEGORY - Navigating to category page');
            final categoryId = queryParams['categoryId'] ?? queryParams['id'];
            final categoryName = queryParams['categoryName'] ?? queryParams['name'];
            final categorySlug = queryParams['categorySlug'] ?? queryParams['slug'];
            
            if (categoryId != null && categoryId.isNotEmpty) {
debugPrint('[DeepLink] Category ID: $categoryId, Name: $categoryName, Slug: $categorySlug');
              
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
              
debugPrint('[DeepLink] Final arguments: $arguments');
              
              if (isInitialLink) {
                // For initial links, first navigate to home, then push the collection page
                await Get.offAllNamed(AppRoutes.home);
                Get.toNamed(AppRoutes.collectionProducts, arguments: arguments);
              } else {
                Get.toNamed(AppRoutes.collectionProducts, arguments: arguments);
              }
            } else {
debugPrint('[DeepLink] ⚠️ Category ID missing, navigating to home');
              Get.offAllNamed(AppRoutes.initial);
            }
            return;
          case 'product':
debugPrint('[DeepLink] 📦 QUERY PARAM PRODUCT - Navigating to product detail page');
            final productId = queryParams['productId'] ?? queryParams['id'];
            final productName = queryParams['productName'] ?? queryParams['name'];
            
            if (productId != null && productId.isNotEmpty) {
debugPrint('[DeepLink] Product ID: $productId, Name: $productName');
              
              // Check authentication before navigating to protected product detail page
              if (!_isUserAuthenticated()) {
debugPrint('[DeepLink] 🚫 User not authenticated, redirecting to login for product detail');
                // Store the intended route and arguments for post-login redirection
                if (isInitialLink) {
                  Get.offAllNamed(AppRoutes.login, arguments: {
                    'intendedRoute': AppRoutes.productDetail,
                    'intendedArguments': {
                      'productId': productId,
                      'productName': productName,
                    },
                  });
                } else {
                  Get.toNamed(AppRoutes.login, arguments: {
                    'intendedRoute': AppRoutes.productDetail,
                    'intendedArguments': {
                      'productId': productId,
                      'productName': productName,
                    },
                  });
                }
debugPrint('[DeepLink] Redirected to login with product detail as intended route');
                return;
              }
              
              try {
                await NavigationHelper.navigateToProductDetail(
                  productId: productId,
                  productName: productName,
                  isInitialLink: isInitialLink,
                );
debugPrint('[DeepLink] Successfully navigated to product detail via query param');
              } catch (e) {
debugPrint('[DeepLink] Error navigating to product detail via query param: $e');
                Get.offAllNamed(AppRoutes.initial);
              }
            } else {
debugPrint('[DeepLink] ⚠️ Product ID missing for query param, navigating to initial route');
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
debugPrint('[DeepLink] Navigating to product detail: $productId');
            await NavigationHelper.navigateToProductDetail(
              productId: productId,
              productName: queryParams['name'] ?? queryParams['productName'],
              isInitialLink: isInitialLink,
            );
          } else {
debugPrint('[DeepLink] Product ID missing, navigating to initial route');
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
debugPrint('[DeepLink] Navigating to collection: $collectionId / $collectionName / $collectionSlug');
            
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
debugPrint('[DeepLink] Collection ID/Slug missing, navigating to initial route');
            Get.offAllNamed(AppRoutes.initial);
          }
          break;

        case 'order':
        case 'orders':
          final orderId = queryParams['id'] ?? queryParams['orderId'];
          final orderCode = queryParams['code'] ?? queryParams['orderCode'];
          if (orderId != null || orderCode != null) {
debugPrint('[DeepLink] Navigating to order detail: $orderId / $orderCode');
            if (isInitialLink) {
              Get.offAllNamed(AppRoutes.orderDetail, arguments: orderCode ?? orderId ?? '');
            } else {
              Get.toNamed(AppRoutes.orderDetail, arguments: orderCode ?? orderId ?? '');
            }
          } else {
debugPrint('[DeepLink] Navigating to orders list');
            if (isInitialLink) {
              Get.offAllNamed(AppRoutes.orders);
            } else {
              Get.toNamed(AppRoutes.orders);
            }
          }
          break;

        case 'cart':
debugPrint('[DeepLink] 🛒 MATCHED CART CASE - Navigating to cart page from deep link');
          try {
            await NavigationHelper.navigateToCart(isInitialLink: isInitialLink);
debugPrint('[DeepLink] Successfully navigated to cart');
          } catch (e) {
debugPrint('[DeepLink] Error navigating to cart: $e');
            // Fallback: try to go to initial route
            Get.offAllNamed(AppRoutes.initial);
          }
          break;

        case 'checkout':
debugPrint('[DeepLink] 💳 MATCHED CHECKOUT CASE - Navigating to checkout page from deep link');
          try {
            await NavigationHelper.navigateToCheckout(isInitialLink: isInitialLink);
debugPrint('[DeepLink] Successfully navigated to checkout');
          } catch (e) {
debugPrint('[DeepLink] Error navigating to checkout: $e');
            // Fallback: try to go to cart first, then user can proceed
            await NavigationHelper.navigateToCart(isInitialLink: isInitialLink);
          }
          break;

        case 'account':
        case 'profile':
debugPrint('[DeepLink] Navigating to account page');
          if (isInitialLink) {
            Get.offAllNamed(AppRoutes.account);
          } else {
            Get.toNamed(AppRoutes.account);
          }
          break;

        case 'admin':
          // Admin path - navigate to account page or home as fallback
          // You can change this to navigate to a specific admin page if you have one
debugPrint('[DeepLink] Navigating to account page (admin)');
          if (isInitialLink) {
            Get.offAllNamed(AppRoutes.account);
          } else {
            Get.toNamed(AppRoutes.account);
          }
          break;

        case 'login':
debugPrint('[DeepLink] Navigating to login page');
          if (isInitialLink) {
            Get.offAllNamed(AppRoutes.login);
          } else {
            Get.toNamed(AppRoutes.login);
          }
          break;

        case 'signup':
        case 'register':
debugPrint('[DeepLink] Navigating to signup page');
          if (isInitialLink) {
            Get.offAllNamed(AppRoutes.signup);
          } else {
            Get.toNamed(AppRoutes.signup);
          }
          break;

        case 'home':
debugPrint('[DeepLink] Navigating to home page');
          Get.offAllNamed(AppRoutes.initial);
          break;

        default:
          // If path is empty or just '/', go to initial route (respects AuthWrapper)
          if (cleanPath.isEmpty || cleanPath == '/') {
debugPrint('[DeepLink] ⚠️ DEFAULT CASE - Empty path, navigating to initial route');
            Get.offAllNamed(AppRoutes.initial);
          } else {
debugPrint('[DeepLink] ⚠️ DEFAULT CASE - Unknown path: "$cleanPath", navigating to initial route as fallback');
            // Try to navigate to initial route as fallback (respects AuthWrapper)
            Get.offAllNamed(AppRoutes.initial);
          }
          break;
      }
    } catch (e) {
debugPrint('[DeepLink] Navigation error: $e');
      // Fallback to initial route on any error
      try {
        Get.offAllNamed(AppRoutes.initial);
      } catch (fallbackError) {
debugPrint('[DeepLink] Fallback navigation also failed: $fallbackError');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    _initialLinkSubscription?.cancel();
    _isInitialized = false;
debugPrint('[DeepLink] Service disposed');
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



