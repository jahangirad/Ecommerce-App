import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/product_details_screen.dart'; // নিশ্চিত করুন পাথটি সঠিক আছে

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> displayedProducts = <Map<String, dynamic>>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'Relevance'.obs;
  final double maxPrice = 5000.0;
  late Rx<RangeValues> priceRange;

  final List<String> categories = ['All', 'Tshirts', 'Jeans', 'Shoes'];
  final List<String> sortOptions = ['Relevance', 'Price: Low - High', 'Price: High - Low'];

  final List<Map<String, dynamic>> _dummyData = [
    {
      'id': '1', 'name': 'Regular Fit Slogan', 'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979850_640.jpg', 'price': 1590.0, 'category': 'Tshirts', 'tags': ['tshirt', 'shirt', 'slogan tee', 'top', 'clothing', 'women fashion'], 'isFavorite': true, 'description': 'A comfortable regular fit t-shirt...'
    },
    {
      'id': '2', 'name': 'Stylish Blue Jeans', 'imageUrl': 'https://cdn.pixabay.com/photo/2017/12/30/22/07/jeans-3051102_640.jpg', 'price': 1100.0, 'originalPrice': 2200.0, 'category': 'Jeans', 'tags': ['jeans', 'pants', 'pan', 'denim', 'bottoms', 'clothing'], 'isFavorite': false, 'description': 'A classic pair of blue jeans...'
    },
    {
      'id': '3', 'name': 'Regular Fit Black', 'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979848_640.jpg', 'price': 1690.0, 'category': 'Tshirts', 'tags': ['tshirt', 'black shirt', 'top', 'women fashion', 'clothing'], 'isFavorite': false, 'description': 'An essential black sleeveless shirt...'
    },
    {
      'id': '4', 'name': 'Classic Running Shoes', 'imageUrl': 'https://cdn.pixabay.com/photo/2020/10/11/05/36/nike-5644799_640.jpg', 'price': 3290.0, 'category': 'Shoes', 'tags': ['shoes', 'sneakers', 'footwear', 'sports', 'running'], 'isFavorite': false, 'description': 'A stylish pair of running shoes...'
    },
  ];

  @override
  void onInit() {
    super.onInit();
    priceRange = Rx<RangeValues>(RangeValues(0, maxPrice));
    _loadProducts();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _applyFiltersAndSearch();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadProducts() {
    allProducts.assignAll(_dummyData);
    _applyFiltersAndSearch();
  }

  // --- مرکزی منطق: সমস্ত ফিল্টারিং এখানে ঘটবে (সঠিক করা হয়েছে) ---
  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> tempProducts = List.from(allProducts);

    // ধাপ ১: সার্চের উপর ভিত্তি করে ফিল্টার (সর্বোচ্চ অগ্রাধিকার)
    if (searchQuery.value.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        final List<dynamic> tags = product['tags'] ?? [];
        return tags.any((tag) => tag.toLowerCase().contains(searchQuery.value.toLowerCase()));
      }).toList();
    }
    // যদি সার্চ বারে কিছু লেখা না থাকে, তবেই ক্যাটেগরি বাটনের ফিল্টার কাজ করবে
    else if (selectedCategory.value != 'All') {
      tempProducts = tempProducts.where((p) => p['category'] == selectedCategory.value).toList();
    }

    // ধাপ ২: দামের ফিল্টার (আগের ফিল্টার করা লিস্টের উপর)
    tempProducts = tempProducts.where((p) =>
    p['price'] >= priceRange.value.start && p['price'] <= priceRange.value.end).toList();

    // ধাপ ৩: সর্টিং
    if (sortBy.value == 'Price: Low - High') {
      tempProducts.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (sortBy.value == 'Price: High - Low') {
      tempProducts.sort((a, b) => b['price'].compareTo(a['price']));
    }

    displayedProducts.assignAll(tempProducts);
  }

  // --- UI থেকে কল করার জন্য ফাংশন ---

  // ক্যাটেগরি বাটনে ক্লিক করলে সার্চ বারটি পরিষ্কার হয়ে যাবে
  void filterByCategory(String category) {
    selectedCategory.value = category;
    // ব্যবহারকারীর সুবিধার জন্য, ক্যাটেগরি পরিবর্তন করলে সার্চ টেক্সট মুছে ফেলা হচ্ছে
    if (searchController.text.isNotEmpty) {
      searchController.clear();
    }
    _applyFiltersAndSearch();
  }

  void updateSortBy(String newSortBy) {
    sortBy.value = newSortBy;
  }

  void updatePriceRange(RangeValues newRange) {
    priceRange.value = newRange;
  }

  void applyFiltersFromSheet() {
    _applyFiltersAndSearch();
    Get.back();
  }

  void toggleFavorite(String productId) {
    final productIndex = allProducts.indexWhere((p) => p['id'] == productId);
    if (productIndex != -1) {
      allProducts[productIndex]['isFavorite'] = !(allProducts[productIndex]['isFavorite'] as bool);
      allProducts.refresh();
      _applyFiltersAndSearch();
    }
  }

  void goToProductDetails(Map<String, dynamic> product) {
    Get.to(() => const ProductDetailsScreen(), arguments: product);
  }
}