import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductFetchController extends GetxController {
  final supabase = Supabase.instance.client;

  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;

  Future<void> fetchProducts() async {
    try {
      // Supabase RPC (Remote Procedure Call) ব্যবহার করে SQL ফাংশন কল করুন
      final response = await supabase.rpc('get_products_with_avg_rating_and_count');

      if (response != null && response is List) {
        // নিশ্চিত করুন যে আপনি Map<String, dynamic> টাইপে কাস্ট করছেন
        allProducts.assignAll(List<Map<String, dynamic>>.from(response));
        print("Fetched products with ratings: ${allProducts.length} items"); // ডিবাগিং এর জন্য
      } else {
        allProducts.assignAll([]); // Handle empty or unexpected response
        print("No products fetched or unexpected response type.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch products: ${e.toString()}");
      print("Error fetching products with reviews: $e"); // For debugging
    }
  }
}