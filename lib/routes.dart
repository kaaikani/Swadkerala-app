import 'package:get/get.dart';
import 'package:recipe.app/pages/Collectionprodcutpage.dart';
import 'package:recipe.app/pages/account_page.dart';
import 'package:recipe.app/pages/addresses_page.dart';
import 'package:recipe.app/pages/cart_page.dart';
import 'package:recipe.app/pages/checkout_page.dart';
import 'package:recipe.app/pages/favourites.dart';
import 'package:recipe.app/pages/order_confirmation_page.dart';
import 'package:recipe.app/pages/order_detail_page.dart';
import 'package:recipe.app/pages/orders_page.dart';
import 'package:recipe.app/pages/product_detail_page.dart';

import 'components/searchbarcomponent.dart';
import 'controllers/banner/bannercontroller.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/homepage.dart';
import 'pages/intro_page.dart';
import 'pages/splash_screen.dart';
import 'pages/initial_route_wrapper.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash';
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

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const InitialRouteWrapper(),
    ),
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
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
    ),
    GetPage(
      name: account,
      page: () => const AccountPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: addresses,
      page: () => const AddressesPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: orders,
      page: () => const OrdersPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: orderConfirmation,
      page: () => OrderConfirmationPage(
        orderId: Get.arguments as String,
      ),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: orderDetail,
      page: () => OrderDetailPage(
        orderCode: Get.arguments as String,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: collectionProducts,
      page: () => CollectionProductsPage(
        collectionId: (Get.arguments as Map<String, dynamic>)['collectionId'] as String,
        collectionName: (Get.arguments as Map<String, dynamic>)['collectionName'] as String,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: productDetail,
      page: () => ProductDetailPage(
        productId: (Get.arguments as Map<String, dynamic>)['productId'] as String,
        productName: (Get.arguments as Map<String, dynamic>?)?['productName'] as String?,
      ),
      transition: Transition.rightToLeft,
    ),
  ];
}