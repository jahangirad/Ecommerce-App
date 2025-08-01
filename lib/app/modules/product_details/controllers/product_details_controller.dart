import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final Rx<Map<String, dynamic>> productData = Rx<Map<String, dynamic>>({});

  // স্ক্রিনের স্টেট পরিচালনা করার জন্য observable ভেরিয়েবল
  final RxString selectedSize = 'M'.obs;
  final RxBool isFavorite = false.obs;

  final List<String> availableSizes = ['S', 'M', 'L'];

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      productData.value = arguments;
      // প্রাথমিক ফেভারিট স্ট্যাটাস সেট করা হচ্ছে
      isFavorite.value = productData.value['is_favorite'] ?? false;
    } else {
      // যদি কোনো ডেটা না পাওয়া যায়, একটি ডিফল্ট ডেটা সেট করুন অথবা এরর দেখান
      productData.value = {
        'name': 'Product Not Found',
        'price': 0.0,
        'image_url': '',
        'description': 'The product details could not be loaded.',
        'rating': 0.0,
        'reviews': 0,
        'is_favorite': false,
      };
    }
  }

  // সাইজ পরিবর্তনের জন্য ফাংশন
  void selectSize(String size) {
    selectedSize.value = size;
  }

  // ফেভারিট স্ট্যাটাস পরিবর্তনের জন্য ফাংশন
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // এখানে ডেটাবেসে ফেভারিট স্ট্যাটাস আপডেট করার জন্য API কল করা যেতে পারে
  }

  // কার্টে যোগ করার জন্য ফাংশন
  void addToCart() {
    // এখানে প্রোডাক্টকে কার্টে যোগ করার লজিক থাকবে
    Get.snackbar(
      'Added to Cart',
      '${productData.value['name']} (${selectedSize.value}) has been added to your cart.',
      snackPosition: SnackPosition.TOP,
    );
  }
}
