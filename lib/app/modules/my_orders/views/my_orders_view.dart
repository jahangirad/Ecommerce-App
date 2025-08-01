import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child: Obx(() {
              // নির্বাচিত ট্যাব অনুযায়ী লিস্ট দেখানো হচ্ছে
              if (controller.selectedTabIndex.value == 0) {
                return _buildOngoingOrdersList();
              } else {
                return _buildCompletedOrdersList();
              }
            }),
          ),
        ],
      ),
    );
  }

  // Ongoing এবং Completed ট্যাব সিলেক্টর উইজেট
  Widget _buildTabSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Obx(
              () => Row(
            children: [
              _buildTabItem('Ongoing', 0),
              _buildTabItem('Completed', 1),
            ],
          ),
        ),
      ),
    );
  }

  // একটি পুনঃব্যবহারযোগ্য ট্যাব আইটেম
  Widget _buildTabItem(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          decoration: BoxDecoration(
            color: controller.selectedTabIndex.value == index
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: controller.selectedTabIndex.value == index
                  ? Colors.black
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  // Ongoing অর্ডার লিস্ট
  Widget _buildOngoingOrdersList() {
    return Obx(() {
      if (controller.ongoingOrders.isEmpty) {
        return _buildEmptyState();
      }
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.ongoingOrders.length,
        itemBuilder: (context, index) {
          final order = controller.ongoingOrders[index];
          return _buildOrderCard(order);
        },
      );
    });
  }

  // Completed অর্ডার লিস্ট
  Widget _buildCompletedOrdersList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: controller.completedOrders.length,
      itemBuilder: (context, index) {
        final order = controller.completedOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  // কোনো অর্ডার না থাকলে দেখানোর জন্য উইজেট
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80.sp, color: Colors.grey[400]),
          SizedBox(height: 20.h),
          Text(
            'No Ongoing Orders!',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            'You don\'t have any ongoing orders\nat this time.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // প্রতিটি অর্ডারের জন্য কার্ড উইজেট
  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              order['imageUrl'],
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                SizedBox(height: 4.h),
                Text(order['size'], style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                SizedBox(height: 8.h),
                Text(order['price'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusBadge(order['status']),
              SizedBox(height: 15.h),
              _buildActionButton(order),
            ],
          )
        ],
      ),
    );
  }

  // স্ট্যাটাস অনুযায়ী ব্যাজ
  Widget _buildStatusBadge(String status) {
    Color bgColor = Colors.grey.withOpacity(0.1);
    Color textColor = Colors.grey;

    if (status == 'Completed') {
      bgColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
    } else if (status == 'In Transit') {
      bgColor = Colors.blue.withOpacity(0.1);
      textColor = Colors.blue;
    } else if (status == 'Picked') {
      bgColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange;
    } else if (status == 'Packing') {
      bgColor = Colors.purple.withOpacity(0.1);
      textColor = Colors.purple;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(status, style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 12.sp)),
    );
  }

  // স্ট্যাটাস অনুযায়ী অ্যাকশন বাটন
  Widget _buildActionButton(Map<String, dynamic> order) {
    final bool isCompleted = order['status'] == 'Completed';

    return SizedBox(
      height: 35.h,
      child: ElevatedButton(
        onPressed: isCompleted ? () => controller.showReviewBottomSheet() : () { /* Track Order Logic */ },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        child: Text(
          isCompleted ? 'Leave Review' : 'Track Order',
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }
}