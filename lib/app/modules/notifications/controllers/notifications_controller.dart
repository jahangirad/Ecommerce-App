import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final RxList<Map<String, dynamic>> savedNotifications = <Map<String, dynamic>>[].obs;

  // একটি RxBool যা দিয়ে আমরা নোটিফিকেশন আছে কি নেই তা সহজে নিয়ন্ত্রণ করতে পারি
  final RxBool hasNotifications = true.obs;

  @override
  void onInit() {
    super.onInit();
    // প্রাথমিকভাবে নোটিফিকেশন লোড করুন
    loadNotifications();
  }

  // নোটিফিকেশন লোড করার মেথড
  void loadNotifications() {
    // hasNotifications এর মানের উপর ভিত্তি করে লিস্ট লোড হবে
    if (hasNotifications.value) {
      // কিছু ডেমো ডেটা যোগ করা হলো
      savedNotifications.assignAll([
        {
          'iconType': 'discount',
          'title': '30% Special Discount!',
          'subtitle': 'Special promotion only valid today.',
        },
        {
          'iconType': 'wallet',
          'title': 'Top Up E-wallet Successfully!',
          'subtitle': 'You have top up your e-wallet.',
        },
        {
          'iconType': 'location',
          'title': 'New Service Available!',
          'subtitle': 'Now you can track order in real-time.',
        },
        {
          'iconType': 'card',
          'title': 'Credit Card Connected!',
          'subtitle': 'Credit card has been linked.',
        },
        {
          'iconType': 'account',
          'title': 'Account Setup Successfully!',
          'subtitle': 'Your account has been created.',
        },
      ]);
    } else {
      // যদি কোনো নোটিফিকেশন না থাকে, তবে লিস্ট খালি রাখুন
      savedNotifications.clear();
    }
  }

  // UI থেকে নোটিফিকেশন আছে বা নেই, এই অবস্থা পরিবর্তনের জন্য একটি টগল মেথড
  // (এটি পরীক্ষার জন্য, 실제 অ্যাপে এর প্রয়োজন নাও হতে পারে)
  void toggleNotificationsState() {
    hasNotifications.value = !hasNotifications.value;
    loadNotifications();
  }
}
