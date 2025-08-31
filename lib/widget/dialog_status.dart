import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'button_widget.dart'; // Make sure this path is correct

class StatusDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onButtonPressed;

  const StatusDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Okay', // ডিফল্ট বাটন টেক্সট
    this.icon = Icons.check, // ডিফল্ট আইকন
    this.iconColor = Colors.green, // ডিফল্ট রঙ
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // আইকন
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: 3),
              ),
              child: Icon(icon, color: iconColor, size: 40),
            ),
            SizedBox(height: 24.h),

            // টাইটেল
            Text(
              title,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),

            // মেসেজ
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 32.h),

            // বাটন
            PrimaryButton(
              text: buttonText,
              onPressed: onButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}