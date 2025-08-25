import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // লগআউট বাটনের জন্য ট্রেইলিং আইকন থাকবে না
    final bool isLogout = text == 'Logout';

    return ListTile(
      onTap: onTap,
      leading: FaIcon(
        icon,
        size: 20.sp,
        color: color ?? Colors.black, // ডিফল্ট রঙ কালো
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black, // ডিফল্ট রঙ কালো
        ),
      ),
      trailing: isLogout
          ? null // লগআউট হলে কোনো ট্রেইলিং আইকন থাকবে না
          : Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: Colors.grey.shade400,
      ),
    );
  }
}