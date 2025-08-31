import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  RxList<Map<String, dynamic>> ongoingOrders = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> completedOrders = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final String? userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        errorMessage.value = 'User not logged in. Please log in to view your orders.';
        isLoading.value = false;
        return;
      }

      // Fetch ongoing orders
      final List<dynamic> ongoingData = await _supabaseClient
          .from('orders')
          .select('*, order_items(*, products(*))')
          .eq('user_id', userId)
          .inFilter('status', ['packing', 'picked', 'transit'])
          .order('created_at', ascending: false);

      final List<dynamic> completedData = await _supabaseClient
          .from('orders')
          .select('*, order_items(*, products(*))') // <--- Changed here! Removed order_reviews
          .eq('user_id', userId)
          .eq('status', 'complete')
          .order('created_at', ascending: false);

      ongoingOrders.assignAll(ongoingData.map((order) => _mapSupabaseOrderToAppOrder(order, isOngoing: true)).toList());

      completedOrders.assignAll(completedData.map((order) => _mapSupabaseOrderToAppOrder(order, isOngoing: false)).toList());

    } on PostgrestException catch (e) {
      errorMessage.value = 'Database error: ${e.message}';
      print('Supabase PostgrestException: ${e.message}');
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      print('Supabase general error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper function to map Supabase data to your app's required format
  Map<String, dynamic> _mapSupabaseOrderToAppOrder(Map<String, dynamic> supabaseOrder, {required bool isOngoing}) {
    List<Map<String, dynamic>> items = [];
    if (supabaseOrder['order_items'] != null) {
      items = (supabaseOrder['order_items'] as List<dynamic>).map((item) {
        final product = item['products'] as Map<String, dynamic>?;
        return {
          'id': item['product_id'],
          'name': product?['name'] ?? 'Unknown Product',
          'imageUrl': product?['image_url'] ?? 'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_640.jpg',
          'price': item['price'],
          'size': item['size'],
          'quantity': item['quantity'],
        };
      }).toList();
    }

    Map<String, dynamic> firstItem = items.isNotEmpty ? items.first : {};
    bool hasOrderReview = false; // Default to false
    double? orderRating;
    String? orderReviewText;

    return {
      'id': supabaseOrder['id'],
      'name': firstItem['name'] ?? 'Order #${supabaseOrder['id']?.substring(0, 8) ?? 'N/A'}',
      'imageUrl': firstItem['imageUrl'] ?? 'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_640.jpg',
      'price': supabaseOrder['total_amount'],
      'size': firstItem['size'] ?? 'N/A',
      'status': supabaseOrder['status'],
      'hasOrderReview': hasOrderReview,
      'orderRating': orderRating,
      'orderReviewText': orderReviewText,
      'delivery_address': supabaseOrder['delivery_address'],
      'order_items_details': items,
    };
  }
}