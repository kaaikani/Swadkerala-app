import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe.app/pages/Collectionprodcutpage.dart';
import 'package:recipe.app/pages/account_page.dart';
import 'package:recipe.app/pages/addresses_page.dart';
import 'package:recipe.app/pages/cart_page.dart';
import 'package:recipe.app/pages/checkout_page.dart';
import 'package:recipe.app/pages/favourites.dart';
import 'package:recipe.app/pages/frequently_ordered_page.dart';
import 'package:recipe.app/pages/order_confirmation_page.dart';
import 'package:recipe.app/pages/order_detail_page.dart';
import 'package:recipe.app/pages/orders_page.dart';
import 'package:recipe.app/pages/product_detail_page.dart';
import 'package:recipe.app/pages/loyalty_points_transaction_page.dart';
import 'package:recipe.app/pages/connect_with_us_page.dart';
import 'package:recipe.app/pages/help_support_page.dart';
import 'package:recipe.app/pages/privacy_policy_page.dart';
import 'package:recipe.app/pages/terms_conditions_page.dart';

import 'components/searchbarcomponent.dart';
import 'controllers/banner/bannercontroller.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/homepage.dart';
import 'pages/intro_page.dart';
import 'pages/initial_route_wrapper.dart';
import 'pages/update_screen.dart';
import 'middleware/auth_guard.dart';

class AppRoutes {
  static const String initial = '/';
  static const String update = '/update';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String intro = '/intro';
  static const String favourite = '/favourite';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String account = '/account';
  static const String addresses = '/addresses';
  static const String orders = '/orders';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderDetail = '/order-detail';
  static const String collectionProducts = '/collection-products';
  static const String productDetail = '/product-detail';
  static const String loyaltyPointsTransactions = '/loyalty-points-transactions';
  static const String frequentlyOrdered = '/frequently-ordered';
  static const String connectWithUs = '/connect-with-us';
  static const String helpSupport = '/help-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const InitialRouteWrapper(),
    ),
    GetPage(
      name: update,
      page: () => UpdateScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => const SignupPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () =>  MyHomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: intro,
      page: () => const IntroPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: favourite,
      page: () => const FavoritesPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: search,
      page: () => FullScreenSearchPage(
        onSearch: (query) {
          final bannerController = Get.find<BannerController>();
          bannerController.searchProducts({'term': query});
        },
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cart,
      page: () => const CartPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: checkout,
      page: () => const CheckoutPage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: account,
      page: () => const AccountPage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: addresses,
      page: () => const AddressesPage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: orders,
      page: () => OrdersPage(
        initialFilter: Get.arguments is OrderFilter 
            ? Get.arguments as OrderFilter 
            : null,
      ),
      transition: Transition.rightToLeft,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: orderConfirmation,
      page: () {
        final orderId = Get.arguments is String ? Get.arguments as String : (Get.arguments?.toString() ?? '');
        return OrderConfirmationPage(orderId: orderId);
      },
      transition: Transition.fadeIn,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: orderDetail,
      page: () => OrderDetailPage(
        orderCode: Get.arguments as String,
      ),
      transition: Transition.rightToLeft,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: collectionProducts,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final collectionId = args['collectionId']?.toString().trim() ?? '';
        final collectionName = args['collectionName']?.toString().trim() ?? 'Collection';
        final slug = args['slug']?.toString().trim() ?? args['collectionSlug']?.toString().trim();
        if (collectionId.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Get.offAllNamed(AppRoutes.home));
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return CollectionProductsPage(
          collectionId: collectionId,
          collectionName: collectionName,
          slug: slug != null && slug.isNotEmpty ? slug : null,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: productDetail,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>?;
        final productId = arguments?['productId'] as String?;
        
        // If productId is null or empty, redirect to home
        if (productId == null || productId.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(AppRoutes.home);
          });
          // Return a temporary loading widget
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        return ProductDetailPage(
          productId: productId,
          productName: arguments?['productName'] as String?,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: loyaltyPointsTransactions,
      page: () => const LoyaltyPointsTransactionPage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: frequentlyOrdered,
      page: () => const FrequentlyOrderedPage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: connectWithUs,
      page: () => const ConnectWithUsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: helpSupport,
      page: () => const HelpSupportPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: privacyPolicy,
      page: () => const PrivacyPolicyPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: termsConditions,
      page: () => const TermsConditionsPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}