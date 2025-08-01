import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/home_view.dart';

class HomeController extends GetxController {
  final List<Map<String, dynamic>> _allProducts = [
    {'id': 1, 'name': 'Regular Fit Slogan', 'image_url': 'https://cdn.pixabay.com/photo/2024/04/17/18/40/ai-generated-8702726_640.jpg', 'category': 'Tshirts', 'price': 1190.0, 'is_favorite': false},
    {'id': 2, 'name': 'Regular Fit Polo', 'image_url': 'https://cdn.pixabay.com/photo/2024/05/09/13/35/ai-generated-8751039_640.png', 'category': 'Tshirts', 'price': 1100.0, 'original_price': 2200.0, 'is_favorite': true},
    {'id': 3, 'name': 'Regular Fit Black', 'image_url': 'https://th.bing.com/th/id/OIP.8wGHmkXKQIFCMpROF-A4YgHaLH?w=127&h=191&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Tshirts', 'price': 1690.0, 'is_favorite': false},
    {'id': 4, 'name': 'Regular Fit V-Neck', 'image_url': 'https://cdn.pixabay.com/photo/2023/05/06/01/33/t-shirt-7973394_640.jpg', 'category': 'Tshirts', 'price': 1290.0, 'is_favorite': false},
    {'id': 5, 'name': 'Classic Blue Jeans', 'image_url': 'https://th.bing.com/th/id/OIP.ahY4KHYD2ngsoU5N6rnDxQAAAA?w=250&h=196&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Jeans', 'price': 2500.0, 'is_favorite': false},
    {'id': 6, 'name': 'Running Shoes', 'image_url': 'https://th.bing.com/th?id=OIF.2U89sEhb1Y0%2f73ZRitwnUQ&w=194&h=194&c=7&r=0&o=7&pid=1.7&rm=3', 'category': 'Shoes', 'price': 3200.0, 'is_favorite': false},
  ];

  final RxList<Map<String, dynamic>> displayedProducts = <Map<String, dynamic>>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final categories = ['All', 'Tshirts', 'Jeans', 'Shoes', 'Pants'];

  final RxString selectedSortBy = 'Relevance'.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 5000).obs;
  final Rxn<String> selectedSize = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    changeCategory('All');
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    applyFilters(); // ক্যাটাগরি পরিবর্তনের সাথে সাথে ফিল্টারও প্রয়োগ হবে
  }

  // ---- এই মেথডটি আপডেট করা হয়েছে ----
  void applyFilters() {
    // প্রথমে বর্তমান ক্যাটাগরির প্রোডাক্টগুলো নিন
    List<Map<String, dynamic>> filteredList;
    if (selectedCategory.value == 'All') {
      filteredList = List.from(_allProducts);
    } else {
      filteredList = _allProducts.where((p) => p['category'] == selectedCategory.value).toList();
    }

    // প্রাইস রেঞ্জ অনুযায়ী ফিল্টার করুন
    filteredList = filteredList.where((p) {
      final price = p['price'] as double;
      return price >= priceRange.value.start && price <= priceRange.value.end;
    }).toList();

    // সর্টিং প্রয়োগ করুন
    if (selectedSortBy.value == 'Price: Low - High') {
      filteredList.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (selectedSortBy.value == 'Price: High - Low') {
      filteredList.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
    }
    // 'Relevance'-এর জন্য কোনো সর্টিং প্রয়োজন নেই, কারণ ডেটাবেস থেকে এভাবেই আসে

    displayedProducts.assignAll(filteredList);

    // বটম শিট খোলা থাকলে বন্ধ করুন
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }

  void showFilterBottomSheet() {
    Get.bottomSheet(
      const FiltersBottomSheet(),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
