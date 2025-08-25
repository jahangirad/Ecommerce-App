import 'package:app_links/app_links.dart';
import 'package:ecommerce_app/core/routes/app_route.dart';
import 'package:get/get.dart';

class DeepLinkController extends GetxController{
  void deepLink(){
    final appLink = AppLinks();
    appLink.uriLinkStream.listen((url){
      if(url.host == 'facebook-loging'){
        Get.toNamed(AppRoute.dashboardscreen);
      }
      else if(url.host == 'reset-pass'){
        Get.toNamed(AppRoute.resetscreen);
      }
    });
  }
}