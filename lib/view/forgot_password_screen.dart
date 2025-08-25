import 'package:ecommerce_app/core/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widget/button_widget.dart';
import '../widget/text_form_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  InputState _emailState = InputState.normal;

  void _validateEmail(String email) {
    setState(() {
      if (email.isEmpty) {
        _emailState = InputState.normal;
      } else {
        final bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
        _emailState = isValid ? InputState.success : InputState.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = _emailState == InputState.success;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Forgot password',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Enter your email for the verification process. We will send 4 digits code to your email.',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),
            CustomTextField(
              labelText: 'Email',
              hintText: 'example@gmail.com',
              controller: _emailController,
              onChanged: _validateEmail,
              inputState: _emailState,
              errorMessage: 'Please enter a valid email.',
            ),
            SizedBox(height: 40.h),
            PrimaryButton(
              text: 'Send Code',
              isEnabled: isButtonEnabled,
              onPressed: () {
                Get.toNamed(AppRoute.resetscreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}