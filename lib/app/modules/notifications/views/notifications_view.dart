import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
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
        title: Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp)),
        centerTitle: true,
      ),
      body: Obx(() {
        // যদি কোনো নোটিফিকেশন না থাকে, তবে খালি অবস্থার UI দেখান
        if (controller.savedNotifications.isEmpty) {
          return _buildEmptyState();
        }
        // যদি নোটিফিকেশন থাকে, তবে লিস্ট দেখান
        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          itemCount: controller.savedNotifications.length,
          itemBuilder: (context, index) {
            final notification = controller.savedNotifications[index];
            return _buildNotificationItem(notification);
          },
          separatorBuilder: (context, index) => Divider(
            height: 25.h,
            color: Colors.grey[200],
          ),
        );
      }),
    );
  }

  // খালি অবস্থার UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 80.sp, color: Colors.grey[400]),
          SizedBox(height: 20.h),
          Text(
            "You haven't gotten any\nnotifications yet!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            "We'll alert you when something\ncool happens.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // প্রতিটি নোটিফিকেশন আইটেমের UI
  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // বাম দিকের আইকন
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: _getNotificationIcon(notification['iconType'] as String),
        ),
        SizedBox(width: 15.w),
        // ডান দিকের টেক্সট
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['title'] as String,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.h),
              Text(
                notification['subtitle'] as String,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // iconType অনুযায়ী সঠিক আইকন রিটার্ন করার হেল্পার মেথড
  Icon _getNotificationIcon(String iconType) {
    switch (iconType) {
      case 'discount':
        return Icon(Icons.sell_outlined, color: Colors.black, size: 24.sp);
      case 'wallet':
        return Icon(Icons.account_balance_wallet_outlined, color: Colors.black, size: 24.sp);
      case 'location':
        return Icon(Icons.location_on_outlined, color: Colors.black, size: 24.sp);
      case 'card':
        return Icon(Icons.credit_card_outlined, color: Colors.black, size: 24.sp);
      case 'account':
        return Icon(Icons.person_outline, color: Colors.black, size: 24.sp);
      default:
        return Icon(Icons.notifications_none_outlined, color: Colors.black, size: 24.sp);
    }
  }
}