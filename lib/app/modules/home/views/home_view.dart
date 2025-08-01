import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBarAndFilter(),
            _buildCategoryTabs(),
            _buildProductsGrid(),
          ],
        ),
      ),
    );
  }

  // ... _buildAppBar, _buildSearchBarAndFilter, _buildCategoryTabs অপরিবর্তিত ...

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Discover', style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, size: 28.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBarAndFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.SEARCH),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 10.w),
                    Text('Search for clothes...', style: TextStyle(color: Colors.grey[600], fontSize: 16.sp)),
                    const Spacer(),
                    Icon(Icons.mic_none, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          IconButton(
            onPressed: controller.showFilterBottomSheet,
            style: IconButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
            icon: Icon(Icons.filter_list, color: Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => controller.changeCategory(category),
                backgroundColor: Colors.grey[100],
                selectedColor: Colors.black,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 14.sp),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                side: BorderSide.none,
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    return Expanded(
      child: Obx(
            () => GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.displayedProducts.length,
          itemBuilder: (context, index) {
            final productData = controller.displayedProducts[index];
            return _ProductCard(productData: productData); // এখানে Map পাস করা হচ্ছে
          },
        ),
      ),
    );
  }
}


class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> productData;
  const _ProductCard({required this.productData});

  @override
  Widget build(BuildContext context) {
    // Supabase থেকে পাওয়া ডেটা null হতে পারে, তাই null check যোগ করা ভালো
    final name = productData['name'] ?? 'No Name';
    final price = productData['price'] ?? 0.0;
    final originalPrice = productData['original_price'];
    final isFavorite = productData['is_favorite'] ?? false;
    final imageUrl = productData['image_url'] ?? ''; // fallback image

    // --- পরিবর্তন এখানে ---
    // সম্পূর্ণ কার্ডটিকে GestureDetector দিয়ে মুড়ে দেওয়া হয়েছে
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS, arguments: productData),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
                // নেটওয়ার্ক থেকে ছবি লোড করার জন্য NetworkImage ব্যবহার করা হয়েছে
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              alignment: Alignment.topRight,
              // যদি ছবি লোড না হয়, তাহলে একটি আইকন দেখানো যেতে পারে
              child: imageUrl.isEmpty
                  ? const Center(child: Icon(Icons.image_not_supported, color: Colors.grey))
                  : IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  // এখানে ফেভারিট টগল করার লজিক যুক্ত করতে পারেন
                  // যেমন: controller.toggleFavorite(productData['id']);
                },
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text('\$ ${price.toStringAsFixed(0)}', style: TextStyle(fontSize: 14.sp)),
              if (originalPrice != null) ...[
                SizedBox(width: 8.w),
                Text(
                  '\$ ${originalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }
}


// FiltersBottomSheet উইজেটে কোনো পরিবর্তন নেই, কারণ এটি শুধু কন্ট্রোলারের ভেরিয়েবল ব্যবহার করে
class FiltersBottomSheet extends GetView<HomeController> {
  // ... আগের কোড এখানে পেস্ট করুন, কোনো পরিবর্তন লাগবে না ...
  const FiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
            ],
          ),
          SizedBox(height: 24.h),
          Text('Sort By', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _buildSortByChips(),
          SizedBox(height: 24.h),
          Text('Price', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          _buildPriceSlider(),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: controller.applyFilters,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Apply Filters', style: TextStyle(fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildSortByChips() {
    final options = ['Relevance', 'Price: Low - High', 'Price: High - Low'];
    return Obx(() => Wrap(
      spacing: 8.w,
      children: options.map((option) {
        final isSelected = controller.selectedSortBy.value == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => controller.selectedSortBy.value = option,
          backgroundColor: Colors.grey[100],
          selectedColor: Colors.black,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 14.sp),
          side: BorderSide.none,
        );
      }).toList(),
    ));
  }

  Widget _buildPriceSlider() {
    return Obx(() => RangeSlider(
      values: controller.priceRange.value,
      min: 0,
      max: 5000,
      divisions: 10,
      labels: RangeLabels(
        '\$${controller.priceRange.value.start.round()}',
        '\$${controller.priceRange.value.end.round()}',
      ),
      onChanged: (values) {
        controller.priceRange.value = values;
      },
      activeColor: Colors.black,
      inactiveColor: Colors.grey[300],
    ));
  }
}