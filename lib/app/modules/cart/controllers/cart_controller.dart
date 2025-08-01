import 'package:get/get.dart';

class CartController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // কার্টে থাকা আইটেমগুলো (এগুলো এখন Supabase থেকে আসবে)
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  final double shippingFee = 80.0;

  // গেটারগুলো অপরিবর্তিত থাকবে
  double get subTotal => cartItems.fold(0, (sum, item) => sum + ((item['products']?['price'] ?? 0) * item['quantity']));
  double get vat => 0.0;
  double get total => subTotal + vat + shippingFee;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // --- Supabase থেকে কার্টের আইটেম আনার ফাংশন ---
  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // --- আপনার Supabase কোড এখানে ---
      // final userId = Supabase.instance.client.auth.currentUser!.id;
      // final response = await Supabase.instance.client
      //     .from('cart_items') // আপনার কার্ট টেবিলের নাম
      //     .select('*, products(*)') // products টেবিলের সাথে join
      //     .eq('user_id', userId);

      // --- Mock ডেটা এবং ডিলে ---
      await Future.delayed(const Duration(seconds: 1));
      final List<Map<String, dynamic>> mockData = [
        {
          'id': 101, 'user_id': 'user123', 'product_id': 1, 'quantity': 2, 'size': 'L',
          'products': {'id': 1, 'name': 'Regular Fit Slogan', 'image_url': 'https://cdn.pixabay.com/photo/2024/04/17/18/40/ai-generated-8702726_640.jpg', 'price': 1190.0}
        },
        {
          'id': 102, 'user_id': 'user123', 'product_id': 2, 'quantity': 1, 'size': 'M',
          'products': {'id': 2, 'name': 'Regular Fit Polo', 'image_url': 'https://cdn.pixabay.com/photo/2024/05/09/13/35/ai-generated-8751039_640.png', 'price': 1100.0}
        },
      ];

      // if (response != null) {
      //   cartItems.assignAll(List<Map<String, dynamic>>.from(response));
      // }
      cartItems.assignAll(mockData);

    } catch (e) {
      errorMessage.value = 'Failed to load cart items. Please try again.';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Supabase-এ নতুন আইটেম যোগ করার ফাংশন ---
  Future<void> addItemToCart(Map<String, dynamic> product, String size) async {
    try {
      final index = cartItems.indexWhere((item) => item['product_id'] == product['id'] && item['size'] == size);

      if (index != -1) {
        // যদি আইটেমটি আগে থেকেই থাকে, তাহলে পরিমাণ আপডেট করুন
        incrementQuantity(index);
      } else {
        // UI-তে অপটিমিস্টিক আপডেট
        final newItem = {
          'id': DateTime.now().millisecondsSinceEpoch, // geçici id
          'product_id': product['id'],
          'quantity': 1,
          'size': size,
          'products': product,
        };
        cartItems.add(newItem);

        // --- Supabase-এ ডেটা পাঠান ---
        // final userId = Supabase.instance.client.auth.currentUser!.id;
        // await Supabase.instance.client.from('cart_items').insert({
        //   'user_id': userId,
        //   'product_id': product['id'],
        //   'quantity': 1,
        //   'size': size,
        // });

        // সফলভাবে যোগ করার পর লিস্ট রিফ্রেশ করতে পারেন
        // fetchCartItems();
      }
      Get.snackbar('Success', '${product['name']} added to cart.');
    } catch (e) {
      Get.snackbar('Error', 'Could not add item to cart.');
      // এরর হলে UI থেকে যোগ করা আইটেমটি সরিয়ে দিন
      cartItems.removeWhere((item) => item['product_id'] == product['id'] && item['size'] == size);
    }
  }

  // --- Supabase থেকে আইটেম ডিলিট করার ফাংশন ---
  Future<void> removeItemFromCart(int cartItemId) async {
    try {
      final removedItem = cartItems.firstWhere((item) => item['id'] == cartItemId);
      cartItems.remove(removedItem);

      // --- Supabase কোড ---
      // await Supabase.instance.client.from('cart_items').delete().match({'id': cartItemId});
      Get.snackbar('Success', 'Item removed from cart.');
    } catch (e) {
      Get.snackbar('Error', 'Could not remove item.');
      fetchCartItems(); // লিস্ট রিফ্রেশ করুন
    }
  }

  // --- Supabase-এ পরিমাণ আপডেট করার ফাংশন ---
  Future<void> _updateQuantity(int index, int newQuantity) async {
    try {
      final cartItem = cartItems[index];
      cartItems[index]['quantity'] = newQuantity;
      cartItems.refresh();

      // --- Supabase কোড ---
      // await Supabase.instance.client
      //     .from('cart_items')
      //     .update({'quantity': newQuantity})
      //     .match({'id': cartItem['id']});
    } catch (e) {
      Get.snackbar('Error', 'Could not update quantity.');
      fetchCartItems(); // লিস্ট রিফ্রেশ করুন
    }
  }

  void incrementQuantity(int index) {
    _updateQuantity(index, cartItems[index]['quantity'] + 1);
  }

  void decrementQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      _updateQuantity(index, cartItems[index]['quantity'] - 1);
    } else {
      removeItemFromCart(cartItems[index]['id']);
    }
  }
}
