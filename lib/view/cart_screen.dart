import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../widget/button_widget.dart';
import '../widget/empty_state_widget.dart';
import 'checkout_screen.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = Get.put(CartController()); // CartController ইনস্ট্যান্স

  @override
  void initState() {
    super.initState();
    // initState এ কার্ট আইটেম ফেচ করার দরকার নেই, কারণ CartController.onInit() এটি করে
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() { // Obx ব্যবহার করুন যাতে cartItems পরিবর্তন হলে UI আপডেট হয়
        if (_cartController.cartItems.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.shopping_cart_outlined,
            title: 'Your Cart Is Empty!',
            subtitle: 'When you add products, they\'ll\nappear here.',
          );
        }

        double subTotal = _cartController.cartItems.fold(0.0, (sum, item) => sum + ((item['price'] as num? ?? 0.0) * (item['quantity'] as int? ?? 1)));
        double shippingFee = 80.0; // আপনার লজিক অনুযায়ী
        double vat = 0.0; // আপনার লজিক অনুযায়ী
        // total calculate in CheckoutController based on subTotal, shippingFee, vat, and discount
        // double total = subTotal + shippingFee + vat; // No need to pass 'total' as it's recalculated

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _cartController.cartItems.length,
                itemBuilder: (context, index) {
                  return _buildCartItem(_cartController.cartItems[index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
              ),
              SizedBox(height: 30.h),
              // Pass calculated values to _buildOrderSummary
              _buildOrderSummary(subTotal, shippingFee, vat, subTotal + shippingFee + vat), // Display current total without discount
            ],
          ),
        );
      }),

      bottomNavigationBar: Obx(() {
        if (_cartController.cartItems.isEmpty) {
          return const SizedBox.shrink(); // কার্ট খালি থাকলে বাটন দেখাবে না
        }
        double subTotal = _cartController.cartItems.fold(0.0, (sum, item) => sum + ((item['price'] as num? ?? 0.0) * (item['quantity'] as int? ?? 1)));
        double shippingFee = 80.0;
        double vat = 0.0;
        // double total = subTotal + shippingFee + vat; // Recalculated in CheckoutController

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: PrimaryButton(
            text: 'Go To Checkout',
            onPressed: () {
              // চেকআউট স্ক্রিনে নেভিগেট করুন এবং ডেটা পাঠান
              Get.to(
                    () => const CheckoutScreen(),
                arguments: {
                  'subTotal': subTotal,
                  'shippingFee': shippingFee,
                  'vat': vat,
                  'cartItems': _cartController.cartItems.toList(), // <-- ✨ THIS IS THE FIX ✨
                  // 'total': total, // 'total' is now calculated in CheckoutController
                },
              );
            },
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        );
      }),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item['imageUrl'] ?? 'https://cdn.pixabay.com/photo/2015/11/03/09/03/see-1019991_640.jpg', // ফলব্যাক ইমেজ
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Unknown Product',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Size ${item['size'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$${(item['price'] as num? ?? 0.0).toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _cartController.removeItem(item['id']), // CartController ব্যবহার করুন
                icon: Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  _buildQuantityButton(Icons.remove, () => _cartController.decrementQuantity(item['id'])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      (item['quantity'] as int? ?? 1).toString(),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildQuantityButton(Icons.add, () => _cartController.incrementQuantity(item['id'])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(4.sp),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon, size: 16.sp),
      ),
    );
  }

  Widget _buildOrderSummary(double subTotal, double shippingFee, double vat, double total) {
    return Column(
      children: [
        _buildSummaryRow('Sub-total', '\$${subTotal.toStringAsFixed(0)}'),
        SizedBox(height: 12.h),
        _buildSummaryRow('VAT (%)', '\$${vat.toStringAsFixed(0)}'),
        SizedBox(height: 12.h),
        _buildSummaryRow('Shipping fee', '\$${shippingFee.toStringAsFixed(0)}'),
        const Divider(height: 30, thickness: 1),
        _buildSummaryRow('Total', '\$${total.toStringAsFixed(0)}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.grey.shade600,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}