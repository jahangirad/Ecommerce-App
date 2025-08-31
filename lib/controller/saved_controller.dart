import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controller/home_controller.dart';

class SavedController extends GetxController {
  final supabase = Supabase.instance.client;

  // Saved products as Map<String, dynamic>
  final RxList<Map<String, dynamic>> favoriteProducts = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch favorite products when the controller is initialized
    if (supabase.auth.currentUser != null) {
      fetchFavoriteProducts();
    }

    // Listen for auth state changes to refresh favorites
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.signedOut) {
        print("Saved: Auth state changed. Re-fetching favorite products...");
        fetchFavoriteProducts();
      }
    });
  }

  Future<void> fetchFavoriteProducts() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      favoriteProducts.clear();
      errorMessage.value = "Not logged in. Please log in to view favorite items.";
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 1. Fetch favorite product IDs for the current user
      final favoriteResponse = await supabase
          .from('favorite')
          .select('product_id')
          .eq('user_id', userId);

      if (favoriteResponse == null || favoriteResponse.isEmpty) {
        favoriteProducts.clear();
        isLoading.value = false;
        return;
      }

      final List<String> productIds = (favoriteResponse as List)
          .map((e) => e['product_id'] as String)
          .toList();

      if (productIds.isEmpty) {
        favoriteProducts.clear();
        isLoading.value = false;
        return;
      }

      // 2. Fetch full product details for these IDs from the 'products' table
      final productFetchController = Get.find<HomeController>().productController;
      if (productFetchController.allProducts.isEmpty) {
        await productFetchController.fetchProducts(); // Ensure products are fetched
      }

      final List<Map<String, dynamic>> allAvailableProducts = productFetchController.allProducts;

      // Filter and add 'isFavorite' status
      final List<Map<String, dynamic>> fetchedFavorites = [];
      for (var pId in productIds) {
        final productData = allAvailableProducts.firstWhereOrNull((p) => p['id'] == pId);
        if (productData != null) {
          final Map<String, dynamic> favProduct = Map<String, dynamic>.from(productData);
          favProduct['isFavorite'] = true; // Mark as favorite
          fetchedFavorites.add(favProduct);
        }
      }
      favoriteProducts.assignAll(fetchedFavorites);

    } on PostgrestException catch (e) {
      errorMessage.value = "Failed to fetch data: ${e.message}";
      print("Supabase error fetching favorites: ${e.message}");
    } catch (e) {
      errorMessage.value = "Failed to fetch favorite items: ${e.toString()}";
      print("Error fetching favorite products in SavedController: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      Get.snackbar("Error", "Please log in to update favorites.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final bool isCurrentlyFavorite = favoriteProducts.any((p) => p['id'] == productId);

      if (isCurrentlyFavorite) {
        // Remove from favorite table
        await supabase
            .from('favorite')
            .delete()
            .eq('user_id', userId)
            .eq('product_id', productId);

        // Update local list
        favoriteProducts.removeWhere((p) => p['id'] == productId);
        Get.snackbar("Success", "Item has been removed from saved!", snackPosition: SnackPosition.BOTTOM);
      } else {
        await supabase.from('favorite').insert({
          'user_id': userId,
          'product_id': productId,
        });
        Get.snackbar("Success", "Item has been added to saved!", snackPosition: SnackPosition.BOTTOM);
        await fetchFavoriteProducts(); // Re-fetch to update list
      }

      final homeController = Get.find<HomeController>();
      homeController.toggleFavorite(productId);

    } on PostgrestException catch (e) {
      Get.snackbar("Error", "Failed to update favorite: ${e.message}", snackPosition: SnackPosition.BOTTOM);
      print("Supabase error toggling favorite: ${e.message}");
    } catch (e) {
      Get.snackbar("Error", "Failed to update favorite: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
      print("Error toggling favorite in SavedController: $e");
    }
  }
}
