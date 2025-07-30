import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/reset_controller.dart';

class ResetView extends GetView<ResetController> {
  const ResetView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Reset Password',
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              Text(
                'Set the new password for your account so you can login and access all the features.',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600], height: 1.5),
              ),
              SizedBox(height: 48.h),
              Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.h),
                    Obx(() => TextFormField(
                      controller: controller.newPasswordController,
                      validator: controller.validatePassword,
                      obscureText: !controller.isNewPasswordVisible.value,
                      decoration: _buildPasswordInputDecoration().copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(controller.isNewPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          onPressed: controller.toggleNewPasswordVisibility,
                        ),
                      ),
                    )),
                    SizedBox(height: 24.h),
                    Text('Password', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.h),
                    Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      validator: controller.validateConfirmPassword,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: _buildPasswordInputDecoration().copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(controller.isConfirmPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              const Spacer(),
              Obx(() => ElevatedButton(
                onPressed: controller.isFormValid.value ? controller.resetPassword : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: controller.isFormValid.value ? Colors.black : Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: controller.isFormValid.value ? Colors.white : Colors.grey[500]),
                ),
              )),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildPasswordInputDecoration() {
    return InputDecoration(
      hintText: '**********',
      hintStyle: const TextStyle(letterSpacing: 2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Get.theme.primaryColor),
      ),
    );
  }
}