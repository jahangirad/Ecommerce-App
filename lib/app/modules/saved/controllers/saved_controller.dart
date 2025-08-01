import 'package:get/get.dart';

class SavedController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> savedItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedItems();
  }

  // Supabase থেকে সেভ করা আইটেমগুলো আনার ফাংশন
  Future<void> fetchSavedItems() async {
    try {
      isLoading.value = true;

      // --- আপনার Supabase কোড এখানে থাকবে ---
      // final response = await Supabase.instance.client
      //     .from('saved_items') // আপনার টেবিলের নাম
      //     .select('*, products(*)'); // products টেবিলের সাথে join করে ডেটা আনা হচ্ছে

      // -- আপাতত আমরা Mock ডেটা ব্যবহার করছি --
      await Future.delayed(const Duration(seconds: 1)); // নেটওয়ার্ক ডিলে সিমুলেট করার জন্য
      final List<Map<String, dynamic>> mockData = [
        {'id': 1, 'name': 'Regular Fit Slogan', 'image_url': 'https://cdn.pixabay.com/photo/2024/04/17/18/40/ai-generated-8702726_640.jpg', 'category': 'Tshirts', 'price': 1190.0, 'is_favorite': false},
        {'id': 2, 'name': 'Regular Fit Polo', 'image_url': 'https://cdn.pixabay.com/photo/2024/05/09/13/35/ai-generated-8751039_640.png', 'category': 'Tshirts', 'price': 1100.0, 'original_price': 2200.0, 'is_favorite': true},
        {'id': 3, 'name': 'Regular Fit Black', 'image_url': 'https://th.bing.com/th/id/OIP.8wGHmkXKQIFCMpROF-A4YgHaLH?w=127&h=191&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Tshirts', 'price': 1690.0, 'is_favorite': false},
        {'id': 4, 'name': 'Regular Fit V-Neck', 'image_url': 'https://cdn.pixabay.com/photo/2023/05/06/01/33/t-shirt-7973394_640.jpg', 'category': 'Tshirts', 'price': 1290.0, 'is_favorite': false},
        {'id': 5, 'name': 'Classic Blue Jeans', 'image_url': 'https://th.bing.com/th/id/OIP.ahY4KHYD2ngsoU5N6rnDxQAAAA?w=250&h=196&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Jeans', 'price': 2500.0, 'is_favorite': false},
        {'id': 6, 'name': 'Running Shoes', 'image_url': 'https://th.bing.com/th?id=OIF.2U89sEhb1Y0%2f73ZRitwnUQ&w=194&h=194&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Shoes', 'price': 3200.0, 'is_favorite': false},
        // ... আরও ডেটা
      ];
      // mockData.clear(); // খালি অবস্থা চেক করার জন্য

      // if (response != null) {
      //   savedItems.assignAll(List<Map<String, dynamic>>.from(response));
      // }

      savedItems.assignAll(mockData);

    } catch (e) {
      Get.snackbar('Error', 'Could not fetch saved items.');
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // একটি আইটেম আন-সেভ করার ফাংশন
  Future<void> removeSavedItem(int savedItemId, int productId) async {
    try {
      // UI থেকে সাথে সাথে আইটেমটি সরিয়ে দিন
      savedItems.removeWhere((item) => item['id'] == savedItemId);

      // --- আপনার Supabase কোড এখানে থাকবে ---
      // await Supabase.instance.client
      //     .from('saved_items')
      //     .delete()
      //     .match({'id': savedItemId});

      // আপনি চাইলে products টেবিলেও is_favorite স্ট্যাটাস আপডেট করতে পারেন
      // await Supabase.instance.client
      //     .from('products')
      //     .update({'is_favorite': false})
      //     .match({'id': productId});

      Get.snackbar('Removed', 'Item has been removed from your saved list.');

    } catch (e) {
      Get.snackbar('Error', 'Could not remove the item.');
      // যদি এরর হয়, তাহলে fetchSavedItems() আবার কল করে লিস্ট রিফ্রেশ করতে পারেন
      fetchSavedItems();
    }
  }
}
