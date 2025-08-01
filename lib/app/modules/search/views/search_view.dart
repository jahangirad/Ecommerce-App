import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back()),
        title: Text('Search', style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: Colors.black, size: 24.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (!controller.isSearching.value) {
                return _buildRecentSearches();
              } else if (controller.noResultsFound.value) {
                return _buildNoResultsFound();
              } else {
                return _buildSearchResults();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    // ... আগের কোড, কোনো পরিবর্তন নেই ...
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: controller.textEditingController,
        onChanged: controller.onSearchChanged,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search for clothes...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.mic_none),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ...
        Expanded(
          child: Obx(()=> ListView.builder(
            itemCount: controller.recentSearches.length,
            itemBuilder: (context, index) {
              final term = controller.recentSearches[index];
              return ListTile(
                // ---- এই onTap ফাংশনটি যোগ করা হয়েছে ----
                onTap: () => controller.performSearch(term),
                title: Text(term),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.removeRecentSearch(term),
                ),
              );
            },
          )),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Obx(()=> ListView.builder(
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final productData = controller.searchResults[index];
        final name = productData['name'] ?? 'No Name';
        final price = productData['price'] ?? 0.0;

        return ListTile(
          leading: Container(
            width: 50.w,
            height: 50.h,
            color: Colors.grey[200],
            child: Image.network(productData['image_url']), // Supabase থেকে URL পেলে
          ),
          title: Text(name),
          subtitle: Text('\$ ${price.toStringAsFixed(0)}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        );
      },
    ));
  }

  Widget _buildNoResultsFound() {
    // ... আগের কোড, কোনো পরিবর্তন নেই ...
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80.sp, color: Colors.grey),
          SizedBox(height: 20.h),
          Text('No Results Found!', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text(
            'Try a similar word or something\nmore general.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
