import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/notification_list_item.dart';



class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 0; // Bottom Navigation Bar এর জন্য

  // নোটিফিকেশনের ডেটা লিস্ট
  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.discount_outlined,
      'title': '30% Special Discount!',
      'subtitle': 'Special promotion only valid today.',
    },
    {
      'icon': Icons.wallet_outlined,
      'title': 'Top Up E-wallet Successfully!',
      'subtitle': 'You have top up your e-wallet.',
    },
    {
      'icon': Icons.location_on_outlined,
      'title': 'New Service Available!',
      'subtitle': 'Now you can track order in real-time.',
    },
    {
      'icon': Icons.credit_card_outlined,
      'title': 'Credit Card Connected!',
      'subtitle': 'Credit card has been linked.',
    },
    {
      'icon': Icons.person_outline,
      'title': 'Account Setup Successfully!',
      'subtitle': 'Your account has been created.',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
      ), // কাস্টম AppBar
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationListItem(
            icon: notification['icon'],
            title: notification['title'],
            subtitle: notification['subtitle'],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 24.h),
      ),
    );
  }
}