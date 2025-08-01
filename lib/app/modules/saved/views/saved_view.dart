import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton( ... ) // ড্যাশবোর্ডের অংশ হলে এটি 필요 নাও হতে পারে
        title: Text('Saved Items', style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: Colors.black, size: 24.sp),
          ),
        ],
      ),
      // Obx এখন লোডিং, খালি এবং ডেটা সহ - এই তিনটি অবস্থা পরিচালনা করবে
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (controller.savedItems.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildSavedItemsGrid();
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 24.h),
          Text('No Saved Items!', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          Text(
            'You don\'t have any saved items.\nGo to home and add some.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedItemsGrid() {
    return RefreshIndicator(
      onRefresh: controller.fetchSavedItems, // পুল-টু-রিফ্রেশ কার্যকারিতা
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.savedItems.length,
        itemBuilder: (context, index) {
          final savedItem = controller.savedItems[index];
          // Supabase join করে ডেটা আনলে product ডেটা এভাবে অ্যাক্সেস করতে হবে
          final productData = savedItem['products'] ?? savedItem;

          return _SavedProductCard(
            productData: productData,
            onUnsave: () => controller.removeSavedItem(savedItem['id'], productData['id']),
          );
        },
      ),
    );
  }
}


// --- এই উইজেটটি আগের মতোই থাকবে ---
class _SavedProductCard extends StatelessWidget {
  final Map<String, dynamic> productData;
  final VoidCallback onUnsave;

  const _SavedProductCard({required this.productData, required this.onUnsave});

  @override
  Widget build(BuildContext context) {
    final name = productData['name'] ?? 'No Name';
    final price = productData['price'] ?? 0.0;
    final imageUrl = productData['image_url'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                      : null,
                ),
                child: imageUrl.isEmpty ? const Center(child: Icon(Icons.error)) : null,
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: onUnsave,
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite, color: Colors.red, size: 18.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        SizedBox(height: 4.h),
        Text('\$ ${price.toStringAsFixed(0)}', style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }
}