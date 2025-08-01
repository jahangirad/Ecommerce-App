import 'package:get/get.dart';


class TrackOrderController extends GetxController {
  final RxMap<String, dynamic> orderDetails = <String, dynamic>{}.obs;

  // এটি UI-তে স্ট্যাটাসের টাইমলাইন দেখানোর জন্য একটি স্ট্যাটিক লিস্ট
  final List<Map<String, String>> statusTimeline = [
    {'title': 'Packing', 'address': '2336 Jack Warren Rd, Delta Junction, Alaska...'},
    {'title': 'Picked', 'address': '2417 Tongass Ave #111, Ketchikan, Alaska...'},
    {'title': 'In Transit', 'address': '16 Rr 2, Ketchikan, Alaska, USA'},
    {'title': 'Delivered', 'address': '925 S Chugach St #APT 10, Alaska 99645'},
  ];

  @override
  void onInit() {
    super.onInit();
    // MyOrdersView থেকে পাঠানো arguments (অর্ডারের ম্যাপ) গ্রহণ করুন
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      orderDetails.value = Get.arguments;
    }
  }

  // অর্ডারের স্ট্যাটাস স্ট্রিং সরাসরি orderDetails ম্যাপ থেকে নেওয়া হচ্ছে
  String get currentStatusString => orderDetails['status'] ?? 'Packing';

  // স্ট্যাটাস স্ট্রিং-এর উপর ভিত্তি করে Lottie ফাইল দেখানো হচ্ছে
  String get currentLottieFile {
    switch (currentStatusString) {
      case 'Packing':
        return 'assets/animation/packing.json'; // আপনার Lottie ফাইলের পাথ
      case 'Picked':
        return 'assets/animation/picked.json';
      case 'In Transit':
        return 'assets/animation/transit.json';
      case 'Delivered':
        return 'assets/animation/delivered.json';
      default:
        return 'assets/animation/delivered.json'; // কোনো স্ট্যাটাস না মিললে ডিফল্ট
    }
  }
}
