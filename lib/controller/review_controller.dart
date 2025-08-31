import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_controller.dart';


class ReviewController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingReviews = false.obs;
  final RxString reviewErrorMessage = ''.obs;

  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final OrderController orderController = Get.put(OrderController()); // Get instance of OrderController

  // New method to check if the current user has reviewed a specific product
  Future<bool> hasUserReviewedProduct(String productId) async {
    final String? userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      return false; // Not logged in, so no review
    }
    try {
      final response = await supabase
          .from('reviews')
          .select('id') // Just need to know if it exists
          .eq('product_id', productId)
          .eq('user_id', userId)
          .limit(1);

      return response != null && response.isNotEmpty;
    } catch (e) {
      print("Error checking existing review: $e");
      return false;
    }
  }


  Future<void> fetchReviewsForProduct(String productId) async {
    isLoadingReviews.value = true;
    reviewErrorMessage.value = '';
    try {
      final response = await supabase
          .from('reviews')
          .select('*') // সব রিভিউ ডেটা সিলেক্ট করুন
          .eq('product_id', productId)
          .order('created_at', ascending: false); // নতুন রিভিউগুলো আগে দেখান

      if (response != null && response is List) {
        reviews.assignAll(List<Map<String, dynamic>>.from(response));
        print("Fetched ${reviews.length} reviews for product $productId");
      } else {
        reviews.assignAll([]);
      }
    } catch (e) {
      reviewErrorMessage.value = 'Failed to load reviews: ${e.toString()}';
      print("Error fetching reviews: $e");
    } finally {
      isLoadingReviews.value = false;
    }
  }

  // এখানে নতুন রিভিউ যোগ করার মেথডও যোগ করতে পারেন
  Future<void> submitProductReview({
    required String productId,
    required double rating,
    required String reviewText,
    String? userId,
    String? userName,
  }) async {
    try {
      userId ??= _supabaseClient.auth.currentUser?.id;
      userName ??= _supabaseClient.auth.currentUser?.userMetadata?['full_name'] as String?;

      if (userId == null) {
        Get.snackbar("Error", "You must be logged in to submit a review.", snackPosition: SnackPosition.BOTTOM);
        print("Review Submission Error: User not logged in."); // Added print
        return;
      }

      final hasReviewed = await hasUserReviewedProduct(productId);
      if (hasReviewed) {
        Get.snackbar("Info", "You have already reviewed this product.", snackPosition: SnackPosition.BOTTOM);
        print("Review Submission Info: User already reviewed product $productId."); // Added print
        return;
      }

      // --- Add these print statements ---
      print("Attempting to submit review with data:");
      print("  product_id: $productId (Type: ${productId.runtimeType})");
      print("  user_id: $userId (Type: ${userId.runtimeType})");
      print("  user_name: $userName (Type: ${userName.runtimeType})");
      print("  rating: $rating (Type: ${rating.runtimeType})");
      print("  review_text: $reviewText (Type: ${reviewText.runtimeType})");
      // ---------------------------------

      await _supabaseClient.from('reviews').insert({
        'product_id': productId,
        'user_id': userId,
        'user_name': userName,
        'rating': rating.round(), // <-- Use .round(), .toInt(), or .floor()/.ceil()
        'review_text': reviewText,
      });

      Get.snackbar("Success", "Your product review has been submitted!", snackPosition: SnackPosition.BOTTOM);
      print("Review Submission Success for product $productId!"); // Added print
      await fetchReviewsForProduct(productId);
      await orderController.fetchOrders();
    } on PostgrestException catch (e) {
      Get.snackbar("Error", "Failed to submit review: ${e.message}", snackPosition: SnackPosition.BOTTOM);
      print("Supabase PostgrestException submitting product review: ${e.message}");
      print("Detail: ${e.details}, Hint: ${e.hint}"); // More detailed PostgrestException logging
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
      print("General error submitting product review: $e");
    }
  }
}