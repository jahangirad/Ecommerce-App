import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  // ট্যাব পরিবর্তনের জন্য সহজ ফাংশন
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
