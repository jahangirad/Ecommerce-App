import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(
                () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(),
                SizedBox(height: 24.h),
                Text(
                  controller.productData.value['name'] ?? 'No Name',
                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                _buildRating(),
                SizedBox(height: 16.h),
                Text(
                  controller.productData.value['description'] ?? 'No description available.',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[700], height: 1.5),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Choose size',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                _buildSizeSelector(),
                SizedBox(height: 100.h), // নিচের বারের জন্য জায়গা
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text('Details', style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_outlined, color: Colors.black, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    final imageUrl = controller.productData.value['image_url'] ?? '';
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.r),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: imageUrl.isEmpty ? const Center(child: Icon(Icons.error)) : null,
          ),
          Positioned(
            top: 16.h,
            right: 16.w,
            child: Obx(
                  () => FloatingActionButton(
                onPressed: controller.toggleFavorite,
                mini: true,
                backgroundColor: Colors.white,
                child: Icon(
                  controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                  color: controller.isFavorite.value ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    final rating = controller.productData.value['rating'] ?? 0.0;
    final reviews = controller.productData.value['reviews'] ?? 0;
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 22.sp),
        SizedBox(width: 8.w),
        Text(
          '${rating.toStringAsFixed(1)}/5',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.w),
        Text(
          '($reviews reviews)',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        )
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Obx(
          () => Row(
        children: controller.availableSizes.map((size) {
          final isSelected = controller.selectedSize.value == size;
          return GestureDetector(
            onTap: () => controller.selectSize(size),
            child: Container(
              width: 60.w,
              height: 60.h,
              margin: EdgeInsets.only(right: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Text(
                  size,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h).copyWith(bottom: 24.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price', style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
              SizedBox(height: 4.h),
              Obx(
                    () => Text(
                  '\$ ${controller.productData.value['price']?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: controller.addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            label: Text('Add to Cart', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          )
        ],
      ),
    );
  }
}