import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AccountController extends GetxController {
  void performLogout() {
    // এখানে আপনার লগআউট লজিক যোগ করুন, যেমন:
    // 1. ব্যবহারকারীর সেশন বা টোকেন ক্লিয়ার করা
    // 2. GetStorage থেকে ডেটা মুছে ফেলা

    // সব পেজ সরিয়ে দিয়ে লগইন পেজে নেভিগেট করুন
    Get.offAllNamed(Routes.LOGIN); // ধরে নিচ্ছি আপনার একটি LOGIN রুট আছে
  }

  // লগআউট কনফার্মেশন ডায়ালগ দেখানোর মেথড
  void showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // উপরের লাল আইকন
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2.5),
                ),
                child: Icon(Icons.priority_high_rounded, color: Colors.red, size: 30.sp),
              ),
              SizedBox(height: 20.h),
              // টাইটেল
              Text(
                'Logout?',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              // সাবটাইটেল
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 25.h),
              // "Yes, Logout" বাটন
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // ডায়ালগ বন্ধ করুন এবং লগআউট করুন
                    Get.back();
                    performLogout();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text('Yes, Logout', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 10.h),
              // "No, Cancel" বাটন
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(), // শুধু ডায়ালগ বন্ধ করুন
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text('No, Cancel', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
