import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../widget/category_selector_widget.dart';
import '../widget/filter_bottom_sheet_widget.dart';
import '../widget/product_card_widget.dart';
import '../widget/search_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    void showFilterModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const FilterBottomSheet(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discover', style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
                  const Icon(Icons.notifications_none, size: 28),
                ],
              ),
              SizedBox(height: 20.h),
              SearchBarWidget(
                onFilterTap: showFilterModal,
                searchController: controller.searchController,
              ),
              SizedBox(height: 20.h),
              Obx(() => CategorySelector(
                categories: controller.categories.toList(),
                selectedCategory: controller.selectedCategory.value,
                onCategorySelected: controller.filterByCategory,
              )),
              SizedBox(height: 20.h),
              Expanded(
                child: Obx(() => controller.displayedProducts.isEmpty
                    ? const Center(child: Text("No products found!"))
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: controller.displayedProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.displayedProducts[index];
                    return GestureDetector(
                      onTap: () => controller.goToProductDetails(product),
                      child: ProductCard(
                        product: product, // Pass Map<String, dynamic>
                        onFavoriteToggle: () => controller.toggleFavorite(product['id'] as String),
                      ),
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}