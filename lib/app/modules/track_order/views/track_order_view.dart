import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/track_order_controller.dart';

class TrackOrderView extends GetView<TrackOrderController> {
  const TrackOrderView({super.key});
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
          'Track Order',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
      ),
      // Stack এর পরিবর্তে Column ব্যবহার করা হয়েছে
      body: Column(
        children: [
          // উপরের অংশ: Lottie অ্যানিমেশন
          // Expanded নিশ্চিত করে যে এই অংশটি নিচের প্যানেল বাদে বাকি সব জায়গা নেবে
          Expanded(
            child: Container(
              color: const Color(0xFFF2F2F2), // ম্যাপের মতো হালকা ধূসর রঙ
              width: double.infinity,
              child: Obx(
                    () => Lottie.asset(
                  controller.currentLottieFile,
                  // উচ্চতা নির্দিষ্ট না করলেও Expanded এর কারণে এটি জায়গা নিয়ে নেবে
                  width: 300.w,
                ),
              ),
            ),
          ),

          // নিচের অংশ: অর্ডার স্ট্যাটাস প্যানেল
          // DraggableScrollableSheet এর পরিবর্তে একটি সাধারণ Container ব্যবহার করা হয়েছে
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              // উপরের দিকে গোলাকার বর্ডার দেওয়া হয়েছে
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
              // প্যানেলটিকে ভাসমান দেখানোর জন্য শ্যাডো দেওয়া হয়েছে
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5), // শ্যাডো উপরের দিকে
                ),
              ],
            ),
            // ListView ব্যবহার করা হয়েছে যাতে কনটেন্ট বেশি হলে স্ক্রল করা যায়
            child: ListView(
              shrinkWrap: true, // কনটেন্ট অনুযায়ী উচ্চতা নিতে সাহায্য করে
              padding: EdgeInsets.zero, // ডিফল্ট প্যাডিং বাদ দেওয়া হয়েছে
              children: [
                // হ্যান্ডেল বার
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                // "Order Status" টাইটেল
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Status',
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                _buildStatusTimeline(), // স্ট্যাটাস টাইমলাইন
                SizedBox(height: 10.h),
                const Divider(),
                SizedBox(height: 10.h),
                _buildDeliveryGuyInfo(), // ডেলিভারি গাই এর তথ্য
                SizedBox(height: 20.h), // নিচের দিকে অতিরিক্ত জায়গা
              ],
            ),
          ),
        ],
      ),
    );
  }

  // স্ট্যাটাস টাইমলাইন উইজেট
  Widget _buildStatusTimeline() {
    // স্ট্যাটাসের সঠিক ক্রম এখানে ডিফাইন করুন
    const statusOrder = ['Packing', 'Picked', 'In Transit', 'Delivered'];

    return Obx(() {
      final String currentStatus = controller.currentStatusString;
      final int currentStatusIndex = statusOrder.indexOf(currentStatus);

      return Column(
        children: List.generate(controller.statusTimeline.length, (index) {
          final statusInfo = controller.statusTimeline[index];
          final bool isCompleted = index < currentStatusIndex;
          final bool isCurrent = index == currentStatusIndex;

          return _buildStatusRow(
            title: statusInfo['title']!,
            subtitle: statusInfo['address']!,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isLast: index == controller.statusTimeline.length - 1,
          );
        }),
      );
    });
  }

  // প্রতিটি স্ট্যাটাস আইটেমের জন্য UI
  Widget _buildStatusRow({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // বাম দিকের ডট এবং লাইন
          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isCurrent ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isCompleted || isCurrent ? Colors.black : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : (isCurrent
                    ? Center(
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
                    : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? Colors.black : Colors.grey[300],
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                ),
            ],
          ),
          SizedBox(width: 15.w),
          // ডান দিকের টেক্সট
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: (isCompleted || isCurrent) ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ডেলিভারি গাই-এর তথ্য উইজেট (আপনার কোড থেকে বাদ দেওয়া হয়েছিল, আমি যোগ করে দিলাম)
  Widget _buildDeliveryGuyInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundImage: const NetworkImage('https://cdn.pixabay.com/photo/2019/09/10/01/31/fisherman-4465032_640.jpg'),
        ),
        SizedBox(width: 15.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jacob Jones',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              'Delivery Guy',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
        const Spacer(),
        FloatingActionButton(
          onPressed: () { /* কল করার লজিক এখানে যোগ হবে */ },
          backgroundColor: Colors.grey[200],
          elevation: 0,
          mini: true,
          child: const Icon(Icons.phone, color: Colors.black),
        )
      ],
    );
  }
}