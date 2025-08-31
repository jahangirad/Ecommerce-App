import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/review_controller.dart';
import '../controller/cart_controller.dart'; // নতুন: CartController ইম্পোর্ট করুন
import '../widget/button_widget.dart';
import '../controller/home_controller.dart';
import 'reviews_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedSize;
  late Map<String, dynamic> _product;
  late ReviewController _reviewController;
  late CartController _cartController;

  @override
  void initState() {
    super.initState();
    _reviewController = Get.put(ReviewController()); // কন্ট্রোলার ইনিশিয়ালাইজ
    _cartController = Get.put(CartController()); // নতুন: CartController ইনিশিয়ালাইজ
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _product = Get.arguments as Map<String, dynamic>;

    // Get sizes safely
    final List<String> sizes = _product['sizes'] is List
        ? List<String>.from(_product['sizes'])
        : ['S', 'M', 'L', 'XL', 'XXL'];

    if (_selectedSize == null && sizes.isNotEmpty) {
      _selectedSize = sizes.first;
    }

    // (৮) প্রোডাক্টের ID ব্যবহার করে রিভিউ ফেচ করুন
    if (_product['id'] != null) {
      _reviewController.fetchReviewsForProduct(_product['id'] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> sizes = _product['sizes'] is List
        ? List<String>.from(_product['sizes'])
        : ['S', 'M', 'L', 'XL', 'XXL'];

    final double averageRating = (_product['average_rating'] as num? ?? 0.0).toDouble();
    final int reviewCount = (_product['review_count'] as int? ?? 0);

    final HomeController? homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;


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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    _product['image_url'] ?? 'https://cdn.pixabay.com/photo/2015/11/03/09/03/see-1019991_640.jpg',
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
                      onPressed: () {
                        // ফেভারিট টগল লজিক
                        if (homeController != null && _product['id'] != null) {
                          homeController.toggleFavorite(_product['id'] as String);
                          // UI immediately update করার জন্য
                          setState(() {
                            _product['isFavorite'] = !(_product['isFavorite'] == true);
                          });
                        } else {
                          Get.snackbar("Error", "Failed to update favorite.", snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      icon: Icon(
                        (_product['isFavorite'] == true) ? Icons.favorite : Icons.favorite_border,
                        color: (_product['isFavorite'] == true) ? Colors.red : null,
                      ),
                      iconSize: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            Text(
              _product['name'] ?? 'Product Name',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: (){
                Get.to(() => const ReviewsScreen(), arguments: _product);
              },
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 4.w),
                  Text(
                    '${averageRating.toStringAsFixed(1)}/5', // গড় রেটিং দেখান
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '($reviewCount reviews)', // মোট রিভিউ সংখ্যা দেখান
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _product['description'] ?? 'No description available.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),

            Text(
              'Choose size',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),

            Row(
              children: sizes.map((size) {
                bool isSelected = _selectedSize == size;

                return GestureDetector(
                  onTap: () {
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
            SizedBox(height: 24.h),
          ],
        ),
      ),
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
                  '\$ ${(_product['price'] as num? ?? 0.0).toStringAsFixed(2)}',
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
                // এখানে CartController এর addToCart মেথড কল করুন
                if (_product['id'] != null) {
                  _cartController.addToCart(
                    productId: _product['id'] as String,
                    size: _selectedSize,
                  );
                } else {
                  Get.snackbar("Error", "Product ID not found.", snackPosition: SnackPosition.BOTTOM);
                }
              },
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}