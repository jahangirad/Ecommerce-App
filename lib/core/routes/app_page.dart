import 'package:get/get.dart';
import '../../view/address_screen.dart';
import '../../view/dashboard_screen.dart';
import '../../view/forgot_password_screen.dart';
import '../../view/help_center_screen.dart';
import '../../view/login_screen.dart';
import '../../view/my_details_screen.dart';
import '../../view/my_orders_screen.dart';
import '../../view/notification_screen.dart';
import '../../view/promo_code_screen.dart';
import '../../view/reset_password_screen.dart';
import '../../view/signup_screen.dart';
import '../../view/splash_screen.dart';
import 'app_route.dart';


class AppPage {
  static final routes = [
    GetPage(
      name: AppRoute.splashscreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoute.signupscreen,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: AppRoute.loginscreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoute.forgotscreen,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoute.resetscreen,
      page: () => ResetPasswordScreen(),
    ),
    GetPage(
      name: AppRoute.dashboardscreen,
      page: () => DashboardScreen(),
    ),
    GetPage(
      name: AppRoute.myorderscreen,
      page: () => MyOrdersScreen(),
    ),
    GetPage(
      name: AppRoute.mydetailsscreen,
      page: () => MyDetailsScreen(),
    ),
    GetPage(
      name: AppRoute.addressscreen,
      page: () => AddressScreen(),
    ),
    GetPage(
      name: AppRoute.promocodescreen,
      page: () => PromoCodeScreen(),
    ),
    GetPage(
      name: AppRoute.notificationscreen,
      page: () => NotificationScreen(),
    ),
    GetPage(
      name: AppRoute.helpcenterscreen,
      page: () => HelpCenterScreen(),
    ),
  ];
}