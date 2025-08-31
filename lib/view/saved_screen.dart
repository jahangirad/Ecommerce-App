import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/saved_controller.dart';
import '../widget/product_card_widget.dart';
import '../widget/empty_state_widget.dart';
import 'product_details_screen.dart';


class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SavedController controller = Get.put(SavedController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Saved Items',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar("Notification", "Notifications will arrive soon!", snackPosition: SnackPosition.TOP);
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50.w),
                SizedBox(height: 10.h),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchFavoriteProducts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Try again later"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                    textStyle: TextStyle(fontSize: 16.sp),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.favoriteProducts.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.favorite_border,
            title: 'No saved items!',
            subtitle: 'You have no saved items.\nGo to the home page and add some.',
          );
        } else {
          return _buildSavedItemsGrid(controller.favoriteProducts, controller);
        }
      }),
    );
  }

  Widget _buildSavedItemsGrid(
      List<Map<String, dynamic>> savedItems, SavedController controller) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.7,
      ),
      itemCount: savedItems.length,
      itemBuilder: (context, index) {
        final product = savedItems[index];
        return ProductCard(
          product: product,
          onFavoriteToggle: () => controller.toggleFavorite(product['id'] as String),
          onTap: () { // এখানে আপনার নেভিগেশন লজিক
            Get.to(() => const ProductDetailsScreen(), arguments: product);
          },
        );
      },
    );
  }
}