import 'package:ecommerce_app/core/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../widget/profile_menu_item.dart';



class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined, size: 26.sp),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        children: [
          // প্রথম গ্রুপ
          ProfileMenuItem(icon: FontAwesomeIcons.box, text: 'My Orders', onTap: () {Get.toNamed(AppRoute.myorderscreen);}),
          ProfileMenuItem(icon: FontAwesomeIcons.userPen, text: 'My Details', onTap: () {Get.toNamed(AppRoute.mydetailsscreen);}),
          ProfileMenuItem(icon: FontAwesomeIcons.addressBook, text: 'Address Book', onTap: () {Get.toNamed(AppRoute.addressscreen);}),
          ProfileMenuItem(icon: FontAwesomeIcons.creditCard, text: 'Payment Methods', onTap: () {Get.toNamed(AppRoute.paymentscreen);}),
          ProfileMenuItem(icon: FontAwesomeIcons.solidBell, text: 'Notifications', onTap: () {Get.toNamed(AppRoute.notificationscreen);}),
          _buildDivider(),
          ProfileMenuItem(icon: FontAwesomeIcons.headset, text: 'Help Center', onTap: () {Get.toNamed(AppRoute.helpcenterscreen);}),
          _buildDivider(),

          // তৃতীয় গ্রুপ (লগআউট)
          ProfileMenuItem(
            icon: FontAwesomeIcons.rightFromBracket,
            text: 'Logout',
            onTap: () {
              // লগআউট করার কোড এখানে লিখুন
            },
            color: Colors.red, // লগআউট বাটনকে লাল রঙ দেওয়া হলো
          ),
        ],
      ),
    );
  }

  // গ্রুপ সেপারেট করার জন্য কাস্টম বিভাজক
  Widget _buildDivider() {
    return Container(
      height: 10.h, // উচ্চতা
      color: Colors.grey.shade100, // হালকা ধূসর রঙ
      margin: EdgeInsets.symmetric(vertical: 12.h), // উপরে ও নিচে ফাঁকা জায়গা
    );
  }
}