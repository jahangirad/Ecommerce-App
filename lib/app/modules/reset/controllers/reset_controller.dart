import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ResetController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void validateForm() {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void resetPassword() {
    if (formKey.currentState!.validate()) {
      // এখানে পাসওয়ার্ড রিসেট করার এপিআই কল করার লজিক থাকবে
      // সফল হলে ডায়ালগ দেখানো হবে
      showSuccessDialog();
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      const PasswordChangedDialog(),
      barrierDismissible: false, // বাইরে ক্লিক করে ডায়ালগ বন্ধ করা যাবে না
    );
  }

  void navigateToLogin() {
    // ডায়ালগ বন্ধ করে লগইন পেজে যাবে এবং আগের সব পেজ রুট থেকে সরিয়ে দেবে
    Get.offAllNamed(Routes.LOGIN);
  }
}

// এই ক্লাসের কোডটি কন্ট্রোলার ফাইলের নিচেই রাখতে পারেন
class PasswordChangedDialog extends StatelessWidget {
  const PasswordChangedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            CircleAvatar(
              radius: 36.r,
              backgroundColor: Colors.green.withOpacity(0.1),
              child: Icon(Icons.check, color: Colors.green, size: 40.sp),
            ),
            SizedBox(height: 24.h),
            Text(
              'Password Changed!',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Text(
              'Your can now use your new password to login to your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.navigateToLogin,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('Login', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
