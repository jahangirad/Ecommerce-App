import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables for state management
  final isPasswordVisible = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to controllers to validate form on change
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  @override
  void onClose() {
    // Dispose controllers to free up resources
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Form validation logic
  void validateForm() {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }

  // Validator for Email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validator for Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null; // Login screens usually don't have password length validation
  }

  // Logic for logging in
  void login() {
    if (formKey.currentState!.validate()) {
      // Perform login logic here
      Get.snackbar(
        'Success',
        'Logged in successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
