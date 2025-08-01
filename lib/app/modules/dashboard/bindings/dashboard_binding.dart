import 'package:ecommerce_app/app/modules/account/controllers/account_controller.dart';
import 'package:ecommerce_app/app/modules/cart/controllers/cart_controller.dart';
import 'package:ecommerce_app/app/modules/saved/controllers/saved_controller.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SavedController>(() => SavedController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
