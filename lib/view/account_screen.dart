import 'package:ecommerce_app/core/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../widget/profile_menu_item.dart';



class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final AuthController authController = Get.put(AuthController());

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
          ProfileMenuItem(icon: FontAwesomeIcons.creditCard, text: 'Promo Code', onTap: () {Get.toNamed(AppRoute.promocodescreen);}),
          ProfileMenuItem(icon: FontAwesomeIcons.solidBell, text: 'Notifications', onTap: () {Get.toNamed(AppRoute.notificationscreen);}),
          _buildDivider(),
          ProfileMenuItem(icon: FontAwesomeIcons.headset, text: 'Help Center', onTap: () {Get.toNamed(AppRoute.helpcenterscreen);}),
          _buildDivider(),

          // তৃতীয় গ্রুপ (লগআউট)
          ProfileMenuItem(
            icon: FontAwesomeIcons.rightFromBracket,
            text: 'Logout',
            color: Colors.red,
            onTap: () {
              // 3. onTap-এ ডায়ালগ দেখানোর কোড
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    // "No" বাটন
                    TextButton(
                      onPressed: () {
                        Get.back(); // ডায়ালগটি বন্ধ করবে
                      },
                      child: const Text('No'),
                    ),
                    // "Yes" বাটন
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // বাটনকে লাল রঙ দেওয়া হলো
                      ),
                      onPressed: () {
                        // ডায়ালগ বন্ধ করে এবং লগআউট ফাংশন কল করে
                        authController.signOut();
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
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