import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class MyOrdersController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  // Supabase থেকে আসা ডেটার মতো করে ডেমো ডেটা লিস্ট (Map ব্যবহার করে)
  final RxList<Map<String, dynamic>> ongoingOrders = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> completedOrders = <Map<String, dynamic>>[].obs;

  // রিভিউ বটমশীটের জন্য রেটিং স্টেট
  final RxDouble currentRating = 3.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // ডেমো ডেটা লোড করুন
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // ডেটাবেস থেকে ডেটা আনার সিমুলেশন
  void fetchOrders() {
    // Ongoing Orders ডেমো ডেটা
    ongoingOrders.assignAll([
      {
        'imageUrl': 'https://cdn.pixabay.com/photo/2024/04/17/18/40/ai-generated-8702726_640.jpg',
        'name': 'Regular Fit Slogan',
        'size': 'Size M',
        'price': '\$ 1,190',
        'status': 'In Transit',
      },
      {
        'imageUrl': 'https://cdn.pixabay.com/photo/2024/05/09/13/35/ai-generated-8751039_640.png',
        'name': 'Regular Fit Polo',
        'size': 'Size L',
        'price': '\$ 1,100',
        'status': 'Picked',
      },
      {
        'imageUrl': 'https://th.bing.com/th/id/OIP.8wGHmkXKQIFCMpROF-A4YgHaLH?w=127&h=191&c=7&r=0&o=7&pid=1.7&rm=3',
        'name': 'Regular Fit V-Neck',
        'size': 'Size S',
        'price': '\$ 1,290',
        'status': 'Packing',
      },
    ]);

    // Completed Orders ডেমো ডেটা
    completedOrders.assignAll([
      {
        'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/06/01/33/t-shirt-7973394_640.jpg',
        'name': 'Regular Fit Slogan',
        'size': 'Size M',
        'price': '\$ 1,190',
        'status': 'Completed',
      },
      {
        'imageUrl': 'https://th.bing.com/th/id/OIP.ahY4KHYD2ngsoU5N6rnDxQAAAA?w=250&h=196&c=7&r=0&o=7&pid=1.7&rm=3',
        'name': 'Regular Fit Polo',
        'size': 'Size L',
        'price': '\$ 1,100',
        'status': 'Completed',
      },
      {
        'imageUrl': 'https://th.bing.com/th?id=OIF.2U89sEhb1Y0%2f73ZRitwnUQ&w=194&h=194&c=7&r=0&o=7&pid=1.7&rm=3',
        'name': 'Regular Fit Black',
        'size': 'Size L',
        'price': '\$ 1,690',
        'status': 'Completed',
      },
    ]);
  }

  void navigateToTrackOrder(Map<String, dynamic> order) {
    Get.toNamed(
      Routes.TRACK_ORDER,
      arguments: order,
    );
  }

  // রিভিউ দেওয়ার জন্য বটমশীট দেখানোর মেথড
  void showReviewBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Leave a Review',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                'How was your order?',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                'Please give your rating and also your review.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 20.h),
              Center(
                child: RatingBar.builder(
                  initialRating: currentRating.value,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    currentRating.value = rating;
                  },
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // এখানে রিভিউ সাবমিট করার লজিক যোগ হবে
                    Get.back(); // বটমশীট বন্ধ করুন
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
