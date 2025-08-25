import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = product['isFavorite'] ?? false;
    final num? originalPrice = product['originalPrice'];

    // মূল কন্টেন্টকে একটি Column-এ রাখা হয়েছে
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                product['imageUrl'],
                fit: BoxFit.cover,
                height: 180.h,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Container(
                  padding: EdgeInsets.all(6.sp),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          product['name'],
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        if (originalPrice != null)
          Row(
            children: [
              Text(
                '\$${(product['price'] as num).toStringAsFixed(0)}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${originalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          )
        else
          Text(
            '\$${(product['price'] as num).toStringAsFixed(0)}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
      ],
    );
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // কার্ডের ভেতরে স্ক্রল বন্ধ রাখতে
      child: cardContent,
    );
  }
}