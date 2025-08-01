import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../routes/app_pages.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
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
          'Account',
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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        children: [
          _buildAccountOption(
            icon: Icons.inventory_2_outlined,
            title: 'My Orders',
            onTap: () {
              Get.toNamed(Routes.MY_ORDERS);
            },
          ),
          _buildAccountOption(
            icon: Icons.person_outline,
            title: 'My Details',
            onTap: () {
              Get.toNamed(Routes.USERCREATE);
            },
          ),
          _buildAccountOption(
            icon: Icons.home_outlined,
            title: 'Address Book',
            onTap: () {},
          ),
          _buildAccountOption(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            onTap: () {},
          ),
          _buildAccountOption(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: const Divider(color: Color(0xFFE0E0E0)),
          ),
          _buildAccountOption(
            icon: Icons.help_outline,
            title: 'FAQs',
            onTap: () {},
          ),
          _buildAccountOption(
            icon: Icons.headset_mic_outlined,
            title: 'Help Center',
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: const Divider(color: Color(0xFFE0E0E0)),
          ),
          _buildAccountOption(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {},
            isLogout: true,
          ),
        ],
      ),
      // Bottom Navigation Bar এখান থেকে সরানো হয়েছে।
    );
  }

  // Account অপশনগুলোর জন্য একটি পুনঃব্যবহারযোগ্য উইজেট।
  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.black,
        size: 26.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isLogout
          ? null
          : Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
        size: 18.sp,
      ),
    );
  }
}