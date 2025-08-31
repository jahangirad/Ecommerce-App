// widget/order_item_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderItemCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isOngoing;
  final VoidCallback onActionPressed;
  final bool hasProductReview; // <--- NEW: To indicate if the product has been reviewed

  const OrderItemCard({
    super.key,
    required this.order,
    required this.isOngoing,
    required this.onActionPressed,
    this.hasProductReview = false, // <--- Set a default value
  });

  @override
  Widget build(BuildContext context) {
    String buttonText;
    Color buttonColor;
    if (isOngoing) {
      buttonText = 'Track Order';
      buttonColor = Colors.blue.shade600;
    } else {
      // For completed orders, check if the product has been reviewed
      if (hasProductReview) { // <--- Using the new parameter
        buttonText = 'View Review';
        buttonColor = Colors.grey.shade600; // Indicate it's already reviewed
      } else {
        buttonText = 'Leave Review';
        buttonColor = Colors.green.shade600; // Prompt to leave a review
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    order['imageUrl'] ?? 'https://via.placeholder.com/150',
                    width: 70.w,
                    height: 70.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['name'] ?? 'N/A',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Size: ${order['size'] ?? 'N/A'}',
                        style: TextStyle(
                            fontSize: 13.sp, color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '৳${order['price']?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 25.h, color: Colors.grey.shade200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      order['status']?.toUpperCase() ?? 'N/A',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isOngoing ? Colors.orange.shade700 : Colors.green.shade700
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onActionPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}