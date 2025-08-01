import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Cart', style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {Get.toNamed(Routes.NOTIFICATIONS);}, icon: Icon(Icons.notifications_outlined, color: Colors.black, size: 24.sp)),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value, textAlign: TextAlign.center));
        } else if (controller.cartItems.isEmpty) {
          return _buildEmptyState();
        } else {
          return _buildCartContent();
        }
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 24.h),
          Text('Your Cart Is Empty!', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          Text('When you add products, they\'ll\nappear here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.fetchCartItems,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];
                return _CartItemCard(item: item, index: index);
              },
            ),
          ),
        ),
        Obx(() => _buildPriceDetails()),
      ],
    );
  }

  Widget _buildPriceDetails() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Column(
        children: [
          _priceRow('Sub-total', '\$${controller.subTotal.toStringAsFixed(0)}'),
          SizedBox(height: 12.h),
          _priceRow('VAT (%)', '\$${controller.vat.toStringAsFixed(0)}'),
          SizedBox(height: 12.h),
          _priceRow('Shipping fee', '\$${controller.shippingFee.toStringAsFixed(0)}'),
          const Divider(height: 32, thickness: 1),
          _priceRow('Total', '\$${controller.total.toStringAsFixed(0)}', isTotal: true),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.CHECKOUT);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Go To Checkout', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 8.w),
                const Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _priceRow(String title, String amount, {bool isTotal = false}) {
    final style = TextStyle(fontSize: isTotal ? 20.sp : 16.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style.copyWith(color: isTotal ? Colors.black : Colors.grey[700])),
        Text(amount, style: style),
      ],
    );
  }
}

class _CartItemCard extends GetView<CartController> {
  final Map<String, dynamic> item;
  final int index;

  const _CartItemCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final product = item['products'] ?? {};
    final imageUrl = product['image_url'] ?? '';

    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            width: 80.w, height: 80.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
              image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
            ),
            child: imageUrl.isEmpty ? const Center(child: Icon(Icons.error)) : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product['name'] ?? 'No Name', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text('Size ${item['size'] ?? 'N/A'}', style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 8.h),
                Text('\$${product['price']?.toStringAsFixed(0) ?? '0'}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(onPressed: () => controller.removeItemFromCart(item['id']), icon: const Icon(Icons.delete_outline, color: Colors.red)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _quantityButton(icon: Icons.remove, onTap: () => controller.decrementQuantity(index)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(item['quantity'].toString(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                  _quantityButton(icon: Icons.add, onTap: () => controller.incrementQuantity(index)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _quantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4.r)),
        child: Icon(icon, size: 16.sp),
      ),
    );
  }
}