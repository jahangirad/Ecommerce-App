import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/routes/app_route.dart';

class SplashController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Get.toNamed(AppRoute.dashboardscreen);
    } else {
      Get.toNamed(AppRoute.signupscreen);
    }
  }
}