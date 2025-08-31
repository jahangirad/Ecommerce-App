import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;


  var cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems(); // কন্ট্রোলার ইনিশিয়ালাইজ হওয়ার সময় কার্ট আইটেম ফেচ
  }

  // কার্টে পণ্য যোগ করার ফাংশন
  Future<void> addToCart({
    required String productId,
    String? size,
  }) async {
    try {
      final String? userId = _supabaseClient.auth.currentUser?.id;

      if (userId == null) {
        Get.snackbar("Error", "Not logged in. Please log in.", snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // পণ্যটি ইতিমধ্যে কার্টে আছে কিনা
      final existingItem = cartItems.firstWhereOrNull(
            (item) => item['product_id'] == productId && item['size'] == size,
      );

      if (existingItem != null) {
        // যদি থাকে, তাহলে পরিমাণ আপডেট
        await _supabaseClient
            .from('cart')
            .update({'quantity': (existingItem['quantity'] as int) + 1})
            .eq('id', existingItem['id']);
        Get.snackbar("Success", "product quantity has been updated!", snackPosition: SnackPosition.BOTTOM);
      } else {
        // যদি না থাকে, তাহলে নতুন করে যোগ
        await _supabaseClient.from('cart').insert({
          'user_id': userId,
          'product_id': productId,
          'size': size,
          'quantity': 1, // নতুন আইটেমের জন্য ডিফল্ট পরিমাণ 1
        });
        Get.snackbar("Success", "product has been added to the cart!", snackPosition: SnackPosition.BOTTOM);
      }

      fetchCartItems(); // কার্ট আপডেট হওয়ার পর ডেটা রিফ্রেশ

    } on PostgrestException catch (e) {
      if (e.code == '23505') { // Unique constraint violation (যদি quantity যোগ না করে সরাসরি insert করে)
        Get.snackbar("Info", "this product is already in your cart.", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "there was a problem adding/updating the product in the cart: ${e.message}", snackPosition: SnackPosition.BOTTOM);
        print("Error adding to cart: ${e.message}");
      }
    } catch (e) {
      Get.snackbar("Error", "there was a problem adding/updating the product in the cart: $e", snackPosition: SnackPosition.BOTTOM);
      print("Error adding to cart: $e");
    }
  }


  // Supabase থেকে কার্ট আইটেমগুলি ফেচ করার ফাংশন
  Future<void> fetchCartItems() async {
    try {
      final String? userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        cartItems.clear();
        return;
      }

      final List<dynamic> data = await _supabaseClient
          .from('cart')
          .select('*, products(*)')
          .eq('user_id', userId);

      // প্রাপ্ত ডেটা থেকে cartItems তালিকা তৈরি
      cartItems.value = data.map((item) {
        final product = item['products'];
        return {
          'id': item['id'],
          'product_id': item['product_id'],
          'name': product['name'],
          'imageUrl': product['image_url'],
          'price': product['price'],
          'size': item['size'],
          'quantity': item['quantity'] ?? 1,
        };
      }).toList();

    } catch (e) {
      Get.snackbar("Error", "there was a problem fetching the cart items: $e", snackPosition: SnackPosition.BOTTOM);
      print("Error fetching cart items: $e");
    }
  }

  // পণ্যের পরিমাণ বৃদ্ধি করার ফাংশন
  Future<void> incrementQuantity(String cartItemId) async {
    try {
      final itemIndex = cartItems.indexWhere((item) => item['id'] == cartItemId);
      if (itemIndex != -1) {
        int currentQuantity = cartItems[itemIndex]['quantity'] as int;
        int newQuantity = currentQuantity + 1;

        await _supabaseClient
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('id', cartItemId);

        cartItems[itemIndex]['quantity'] = newQuantity;
        cartItems.refresh(); // UI আপডেট করার জন্য
      }
    } catch (e) {
      Get.snackbar("Error", "there was a problem increasing the quantity: $e", snackPosition: SnackPosition.BOTTOM);
      print("Error incrementing quantity: $e");
    }
  }


  Future<void> decrementQuantity(String cartItemId) async {
    try {
      final itemIndex = cartItems.indexWhere((item) => item['id'] == cartItemId);
      if (itemIndex != -1) {
        int currentQuantity = cartItems[itemIndex]['quantity'] as int;
        if (currentQuantity > 1) {
          int newQuantity = currentQuantity - 1;

          await _supabaseClient
              .from('cart')
              .update({'quantity': newQuantity})
              .eq('id', cartItemId);

          cartItems[itemIndex]['quantity'] = newQuantity;
          cartItems.refresh(); // UI আপডেট করার জন্য
        } else {
          await removeItem(cartItemId);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "there was a problem decreasing the quantity: $e", snackPosition: SnackPosition.BOTTOM);
      print("Error decrementing quantity: $e");
    }
  }

  // কার্ট থেকে পণ্য সরিয়ে ফেলার ফাংশন
  Future<void> removeItem(String cartItemId) async {
    try {
      await _supabaseClient
          .from('cart')
          .delete()
          .eq('id', cartItemId);

      cartItems.removeWhere((item) => item['id'] == cartItemId);
      cartItems.refresh(); // UI আপডেট করার জন্য
      Get.snackbar("Success", "product has been removed from the cart!", snackPosition: SnackPosition.BOTTOM);

    } catch (e) {
      Get.snackbar("Error", "there was a problem removing the product from the cart: $e", snackPosition: SnackPosition.BOTTOM);
      print("Error removing item from cart: $e");
    }
  }
}