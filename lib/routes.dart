import 'package:get/get.dart';
import 'package:unified_ecomapp/pages/cart_page.dart';
import 'package:unified_ecomapp/pages/checkout_page.dart';
import 'package:unified_ecomapp/pages/favourites.dart';
import 'package:unified_ecomapp/pages/account_page.dart';
import 'package:unified_ecomapp/pages/order_confirmation_page.dart';
import 'components/searchbarcomponent.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/homepage.dart';
import 'pages/intro_page.dart';
import 'pages/auth_wrapper.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String intro = '/intro';
  static const String favourite = '/favourite';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String account = '/account';
  static const String orderConfirmation = '/order-confirmation';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const AuthWrapper(),
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
          // call your search function here
          print("Searching for: $query");
          // example: productsController.searchForProducts(query);
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
      name: orderConfirmation,
      page: () => OrderConfirmationPage(
        orderId: Get.arguments as String,
      ),
      transition: Transition.fadeIn,
    ),
  ];
}