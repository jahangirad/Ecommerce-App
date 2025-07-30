import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controller
  final emailController = TextEditingController();

  // Observable variable to control button state
  final isEmailValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listener to controller to validate email on change
    emailController.addListener(_validateEmail);
  }

  @override
  void onClose() {
    // Dispose controller to free up resources
    emailController.dispose();
    super.onClose();
  }

  // Email validation logic
  void _validateEmail() {
    isEmailValid.value = GetUtils.isEmail(emailController.text);
  }

  // Logic for sending the verification code
  void sendCode() {
    if (isEmailValid.value) {
      // Perform send code logic here
      // For now, let's just show a snackbar
      Get.snackbar(
        'Link Sent',
        'A link has been sent to ${emailController.text}',
        snackPosition: SnackPosition.BOTTOM,
      );
      // You can navigate to the OTP screen from here
      // Get.toNamed(Routes.OTP_VERIFICATION);
    }
  }
}
