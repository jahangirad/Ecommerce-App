import 'package:get/get.dart';

import '../controllers/usercreate_controller.dart';

class UsercreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsercreateController>(
      () => UsercreateController(),
    );
  }
}
