import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // FocusNodes to track focus state
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // Observable variables
  final isPasswordVisible = false.obs;
  final isFormValid = false.obs;

  // Dirty flags to track if a field has been touched
  final isNameDirty = false.obs;
  final isEmailDirty = false.obs;
  final isPasswordDirty = false.obs;


  @override
  void onInit() {
    super.onInit();
    // Add listeners to validate form on text change
    nameController.addListener(validateForm);
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);

    // Add focus listeners to set dirty flags
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        isNameDirty.value = true;
        formKey.currentState?.validate(); // Re-validate on losing focus
      }
    });
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        isEmailDirty.value = true;
        formKey.currentState?.validate();
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        isPasswordDirty.value = true;
        formKey.currentState?.validate();
      }
    });
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void validateForm() {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  void createAccount() {
    // Set all fields to dirty to show errors if form is submitted empty
    isNameDirty.value = true;
    isEmailDirty.value = true;
    isPasswordDirty.value = true;

    if (formKey.currentState!.validate()) {
      Get.snackbar(
        'Success', 'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
