import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widget/button_widget.dart';




class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  String? _selectedSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> product = Get.arguments as Map<String, dynamic>;
    final List<String> sizes = product['sizes'] is List ? List<String>.from(product['sizes']) : ['S', 'M', 'L', 'XL', 'XXL'];

    if (_selectedSize == null && sizes.isNotEmpty) {
      _selectedSize = sizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.arguments ব্যবহার করে ডেটা গ্রহণ
    final Map<String, dynamic> product = Get.arguments as Map<String, dynamic>;

    // ডেটা থেকে সাইজের তালিকা
    final List<String> sizes = product['sizes'] is List ? List<String>.from(product['sizes']) : ['S', 'M', 'L', 'XL', 'XXL'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // প্রোডাক্টের ছবি ও পছন্দের আইকন (অপরিবর্তিত)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    product['imageUrl'] ?? 'https://via.placeholder.com/400',
                    height: 400.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                      iconSize: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // প্রোডাক্টের নাম, রেটিং এবং বর্ণনা (অপরিবর্তিত)
            Text(
              product['name'] ?? 'Product Name',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4.w),
                Text(
                  '${product['rating'] ?? '0.0'}/5',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '(${product['reviewCount'] ?? 0} reviews)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              product['description'] ?? 'No description available.',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),

            // সাইজ নির্বাচন
            Text(
              'Choose size',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),

            // *** মূল পরিবর্তন এখানে ***
            Row(
              children: sizes.map((size) {
                // _selectedSize ভ্যারিয়েবলের সাথে তুলনা করে বাটন সিলেক্টেড কিনা তা নির্ধারণ করা হচ্ছে
                bool isSelected = _selectedSize == size;

                return GestureDetector(
                  onTap: () {
                    // ট্যাপ করলে setState() কল করে UI আপডেট করা হচ্ছে
                    setState(() {
                      _selectedSize = size;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      // নিচের অংশ (অপরিবর্তিত)
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$ ${(product['price'] as num? ?? 0).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            PrimaryButton(
              text: 'Add to Cart',
              onPressed: () {
                // এখানে আপনি সিলেক্টেড সাইজ (_selectedSize) ব্যবহার করতে পারেন
                print('Selected Size: $_selectedSize');
              },
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}