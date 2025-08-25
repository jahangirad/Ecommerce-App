import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


enum InputState { normal, error, success }

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final Function(String) onChanged;
  final InputState inputState;
  final String? errorMessage;
  final VoidCallback? onToggleVisibility;
  final bool isPasswordVisible;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.isPassword = false,
    this.inputState = InputState.normal,
    this.errorMessage,
    this.onToggleVisibility,
    this.isPasswordVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon;
    Color borderColor;

    switch (inputState) {
      case InputState.error:
        suffixIcon = Icon(Icons.error_outline, color: Colors.red, size: 24.sp);
        borderColor = Colors.red;
        break;
      case InputState.success:
        suffixIcon = Icon(Icons.check_circle, color: Colors.green, size: 24.sp);
        borderColor = Colors.green;
        break;
      case InputState.normal:
      default:
        suffixIcon = null;
        borderColor = Colors.grey.shade300;
        break;
    }

    if (isPassword) {
      suffixIcon = IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: Colors.grey,
        ),
        onPressed: onToggleVisibility,
      );
    }

    // Success state এ পাসওয়ার্ড ফিল্ডে টিক চিহ্ন দেখানোর জন্য
    if (isPassword && inputState == InputState.success) {
      suffixIcon = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
          IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey,
            ),
            onPressed: onToggleVisibility,
          ),
        ],
      );
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
            contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: borderColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
        if (inputState == InputState.error && errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 5.w),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }
}