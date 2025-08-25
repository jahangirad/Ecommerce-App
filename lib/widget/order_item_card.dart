import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderItemCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isOngoing;
  final VoidCallback onActionPressed;

  const OrderItemCard({
    super.key,
    required this.order,
    required this.isOngoing,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              order['imageUrl'],
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
                Text(order['name'], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text('Size ${order['size']}', style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
                SizedBox(height: 8.h),
                Text('\$${(order['price'] as num).toStringAsFixed(0)}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusBadge(),
              SizedBox(height: 20.h),
              _buildActionButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    bool isCompleted = order['status'] == 'Completed';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        order['status'],
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isCompleted ? Colors.green.shade700 : Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (isOngoing) {
      return _buildSmallButton('Track Order');
    } else {
      if (order['isReviewed'] == true) {
        return Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 18.sp),
            SizedBox(width: 4.w),
            Text(
              '${order['rating']}/5',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ],
        );
      } else {
        return _buildSmallButton('Leave Review');
      }
    }
  }

  Widget _buildSmallButton(String text) {
    return SizedBox(
      height: 35.h,
      child: ElevatedButton(
        onPressed: onActionPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Text(text, style: TextStyle(fontSize: 12.sp, color: Colors.white)),
      ),
    );
  }
}