import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxList<String> recentSearches = <String>['Tshirts', 'Jeans', 'Shoes', 'Pants'].obs;

  final List<Map<String, dynamic>> _allProducts = [
    {'id': 1, 'name': 'Regular Fit Slogan', 'image_url': 'https://cdn.pixabay.com/photo/2024/04/17/18/40/ai-generated-8702726_640.jpg', 'category': 'Tshirts', 'price': 1190.0, 'is_favorite': false},
    {'id': 2, 'name': 'Regular Fit Polo', 'image_url': 'https://cdn.pixabay.com/photo/2024/05/09/13/35/ai-generated-8751039_640.png', 'category': 'Tshirts', 'price': 1100.0, 'original_price': 2200.0, 'is_favorite': true},
    {'id': 3, 'name': 'Regular Fit Black', 'image_url': 'https://th.bing.com/th/id/OIP.8wGHmkXKQIFCMpROF-A4YgHaLH?w=127&h=191&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Tshirts', 'price': 1690.0, 'is_favorite': false},
    {'id': 4, 'name': 'Regular Fit V-Neck', 'image_url': 'https://cdn.pixabay.com/photo/2023/05/06/01/33/t-shirt-7973394_640.jpg', 'category': 'Tshirts', 'price': 1290.0, 'is_favorite': false},
    {'id': 5, 'name': 'Classic Blue Jeans', 'image_url': 'https://th.bing.com/th/id/OIP.ahY4KHYD2ngsoU5N6rnDxQAAAA?w=250&h=196&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Jeans', 'price': 2500.0, 'is_favorite': false},
    {'id': 6, 'name': 'Running Shoes', 'image_url': 'https://th.bing.com/th?id=OIF.2U89sEhb1Y0%2f73ZRitwnUQ&w=194&h=194&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Shoes', 'price': 3200.0, 'is_favorite': false},
  ];

  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool noResultsFound = false.obs;

  // ---- এই নতুন মেথডটি যোগ করা হয়েছে ----
  void performSearch(String query) {
    textEditingController.text = query; // সার্চ বারে লেখাটি সেট করুন
    onSearchChanged(query); // সার্চ শুরু করুন
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      noResultsFound.value = false;
      return;
    }

    isSearching.value = true;
    final results = _allProducts
        .where((product) => (product['name'] as String).toLowerCase().contains(query.toLowerCase()))
        .toList();

    searchResults.assignAll(results);
    noResultsFound.value = results.isEmpty;
  }

  void clearRecentSearches() => recentSearches.clear();
  void removeRecentSearch(String term) => recentSearches.remove(term);
}
