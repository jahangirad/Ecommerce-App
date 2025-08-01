import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/help_center_controller.dart';

class HelpCenterView extends GetView<HelpCenterController> {
  const HelpCenterView({super.key});
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
        title: Text('Help Center', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        itemCount: controller.helpOptions.length,
        itemBuilder: (context, index) {
          final option = controller.helpOptions[index];
          return _buildHelpOptionItem(
            title: option['title'] as String,
            icon: option['icon'] as IconData,
            onTap: option['onTap'] as VoidCallback,
          );
        },
      ),
    );
  }

  // প্রতিটি হেল্প অপশনের জন্য একটি পুনঃব্যবহারযোগ্য উইজেট
  Widget _buildHelpOptionItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black, size: 24.sp),
              SizedBox(width: 15.w),
              Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}