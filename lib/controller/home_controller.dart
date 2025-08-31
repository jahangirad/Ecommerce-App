import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../view/product_details_screen.dart';
import 'product_fetch_controller.dart';
import 'saved_controller.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;
  final productController = Get.put(ProductFetchController());

  late final SavedController savedController;

  // Using Map<String, dynamic> for product data
  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> displayedProducts = <Map<String, dynamic>>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'Relevance'.obs;
  final double maxPrice = 5000.0;
  late Rx<RangeValues> priceRange;

  final RxList<String> categories = <String>[].obs;
  final RxList<String> sortOptions = [
    'Relevance',
    'Price: Low - High',
    'Price: High - Low'
  ].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.isRegistered<SavedController>()) {
      savedController = Get.find<SavedController>();
    } else {
      savedController = Get.put(SavedController());
    }

    priceRange = Rx<RangeValues>(const RangeValues(0, 5000));
    fetchAndDisplayProducts();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _applyFiltersAndSearch();
    });

    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.signedOut) {
        print("Home: Auth state changed. Re-checking favorite status...");
        _checkAllProductsFavoriteStatus();
        savedController.fetchFavoriteProducts();
      }
    });
  }

  Future<void> fetchAndDisplayProducts() async {
    if (productController.allProducts.isEmpty) {
      await productController.fetchProducts();
    }

    // Assign raw fetched data directly
    allProducts.assignAll(productController.allProducts);

    Set<String> uniqueCategories = {'All'};
    for (var product in allProducts) {
      // Ensure 'category' key exists before accessing
      uniqueCategories.add(product['category'] as String? ?? 'Uncategorized');
    }
    categories.assignAll(uniqueCategories.toList());

    await _checkAllProductsFavoriteStatus();
    _applyFiltersAndSearch();
  }

  Future<void> _checkAllProductsFavoriteStatus() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      for (var product in allProducts) {
        product['isFavorite'] = false; // Set key directly in map
      }
      return;
    }

    try {
      final response = await supabase
          .from('favorite')
          .select('product_id')
          .eq('user_id', userId);

      final favoriteProductIds =
      (response as List).map((e) => e['product_id'] as String).toSet();

      for (var product in allProducts) {
        // Ensure 'id' key exists before accessing
        final productId = product['id'] as String? ?? '';
        product['isFavorite'] = favoriteProductIds.contains(productId); // Set key directly in map
      }
      _applyFiltersAndSearch();
    } catch (e) {
      print("Error checking favorite status in Home: $e");
      for (var product in allProducts) {
        product['isFavorite'] = false;
      }
    }
  }

  void toggleFavorite(String productId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      Get.snackbar("ত্রুটি", "ফেভারিট করতে লগইন করুন।", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final productIndex = allProducts.indexWhere((product) => product['id'] == productId);
      if (productIndex == -1) return;

      final product = allProducts[productIndex];

      if (product['isFavorite'] == true) { // Check value directly
        await supabase
            .from('favorite')
            .delete()
            .eq('user_id', userId)
            .eq('product_id', productId);
        product['isFavorite'] = false; // Update key directly
        Get.snackbar("সফল", "${product['name']} ফেভারিট থেকে মুছে ফেলা হয়েছে!", snackPosition: SnackPosition.BOTTOM);
      } else {
        await supabase.from('favorite').insert({
          'user_id': userId,
          'product_id': productId,
        });
        product['isFavorite'] = true; // Update key directly
        Get.snackbar("সফল", "${product['name']} ফেভারিটে যোগ করা হয়েছে!", snackPosition: SnackPosition.BOTTOM);
      }
      savedController.fetchFavoriteProducts();
      _applyFiltersAndSearch();
    } catch (e) {
      Get.snackbar("ত্রুটি", "ফেভারিট আপডেট করতে ব্যর্থ হয়েছে।: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
      print("Favorite toggle error in Home: $e");
    }
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> temp = List.from(allProducts);

    if (searchQuery.value.isNotEmpty) {
      temp = temp.where((p) {
        final tags = List<String>.from(p['tags'] ?? []);
        return tags.any((t) => t.toLowerCase().contains(searchQuery.value.toLowerCase())) ||
            (p['name'] as String? ?? '').toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    } else if (selectedCategory.value != 'All') {
      temp = temp.where((p) => (p['category'] as String? ?? '') == selectedCategory.value).toList();
    }

    temp = temp
        .where((p) =>
    (p['price'] as num? ?? 0.0) >= priceRange.value.start &&
        (p['price'] as num? ?? 0.0) <= priceRange.value.end)
        .toList();

    if (sortBy.value == 'Price: Low - High') {
      temp.sort((a, b) => (a['price'] as num? ?? 0.0).compareTo(b['price'] as num? ?? 0.0));
    } else if (sortBy.value == 'Price: High - Low') {
      temp.sort((a, b) => (b['price'] as num? ?? 0.0).compareTo(a['price'] as num? ?? 0.0));
    } else {
      temp.sort((a, b) => (a['name'] as String? ?? '').compareTo(b['name'] as String? ?? ''));
    }

    displayedProducts.assignAll(temp);
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (searchController.text.isNotEmpty) {
      searchController.clear();
    }
    _applyFiltersAndSearch();
  }

  void updateSortBy(String newSortBy) {
    sortBy.value = newSortBy;
    _applyFiltersAndSearch();
  }

  void updatePriceRange(RangeValues newRange) {
    priceRange.value = newRange;
    _applyFiltersAndSearch();
  }

  void applyFiltersFromSheet() {
    _applyFiltersAndSearch();
    Get.back();
  }

  void goToProductDetails(Map<String, dynamic> product) {
    Get.to(() => const ProductDetailsScreen(), arguments: product); // Pass the Map
  }
}