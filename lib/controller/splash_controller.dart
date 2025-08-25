import 'dart:async';
import 'package:ecommerce_app/core/routes/app_route.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 3), () {
      Get.toNamed(AppRoute.signupscreen);
    });
  }
}