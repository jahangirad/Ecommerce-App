import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widget/button_widget.dart';
import '../widget/empty_state_widget.dart';
import 'checkout_screen.dart';



class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Regular Fit Slogan',
      'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979850_640.jpg',
      'price': 1190.0,
      'size': 'L',
    },
    {
      'id': '2',
      'name': 'Regular Fit Polo',
      'imageUrl': 'https://cdn.pixabay.com/photo/2017/12/30/22/07/jeans-3051102_640.jpg',
      'price': 1100.0,
      'size': 'M',
    },
    {
      'id': '3',
      'name': 'Regular Fit Black',
      'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979848_640.jpg',
      'price': 1290.0,
      'size': 'L',
    },
  ];

  @override
  void initState() {
    super.initState();
    for (var item in _cartItems) {
      item.putIfAbsent('quantity', () => 1);
    }
  }

  void _incrementQuantity(String id) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item['id'] == id);
      item['quantity']++;
    });
  }

  void _decrementQuantity(String id) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item['id'] == id);
      if (item['quantity'] > 1) {
        item['quantity']--;
      }
    });
  }

  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    double subTotal = _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
    double shippingFee = _cartItems.isEmpty ? 0 : 80;
    double vat = 0.0;
    double total = subTotal + shippingFee + vat;

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
      body: _cartItems.isEmpty
          ? const EmptyStateWidget(
        icon: Icons.shopping_cart_outlined,
        title: 'Your Cart Is Empty!',
        subtitle: 'When you add products, they\'ll\nappear here.',
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(_cartItems[index]);
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
            ),
            SizedBox(height: 30.h),
            _buildOrderSummary(subTotal, shippingFee, vat, total),
          ],
        ),
      ),

      // *** এখানে PrimaryButton ব্যবহার করা হয়েছে ***
      bottomNavigationBar: _cartItems.isEmpty
          ? null
          : Padding(
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
                'total': total,
              },
            );
          },
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }

  // বাকি উইজেট ও ফাংশনগুলো অপরিবর্তিত থাকবে...

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
              item['imageUrl'],
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
                  item['name'],
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Size ${item['size']}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$${(item['price'] as num).toStringAsFixed(0)}',
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
                onPressed: () => _removeItem(item['id']),
                icon: Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  _buildQuantityButton(Icons.remove, () => _decrementQuantity(item['id'])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      item['quantity'].toString(),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildQuantityButton(Icons.add, () => _incrementQuantity(item['id'])),
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