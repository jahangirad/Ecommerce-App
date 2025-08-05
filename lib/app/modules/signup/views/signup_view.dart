import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 52.h),
                Text('Create an account', style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.h),
                Text('Let\'s create your account.', style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])),
                SizedBox(height: 40.h),

                Obx(() => TextFormField(
                  controller: controller.nameController,
                  focusNode: controller.nameFocusNode,
                  validator: controller.validateName,
                  decoration: _buildInputDecoration(
                    label: 'Full Name',
                    isDirty: controller.isNameDirty.value,
                    isValid: controller.validateName(controller.nameController.text) == null,
                  ),
                )),
                SizedBox(height: 24.h),

                Obx(() => TextFormField(
                  controller: controller.emailController,
                  focusNode: controller.emailFocusNode,
                  validator: controller.validateEmail,
                  decoration: _buildInputDecoration(
                    label: 'Email',
                    isDirty: controller.isEmailDirty.value,
                    isValid: controller.validateEmail(controller.emailController.text) == null,
                    errorText: controller.isEmailDirty.value && controller.validateEmail(controller.emailController.text) != null
                        ? 'Please enter valid email address'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                )),
                SizedBox(height: 24.h),

                Obx(() => TextFormField(
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocusNode,
                  validator: controller.validatePassword,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: _buildInputDecoration(
                    label: 'Password',
                    isDirty: controller.isPasswordDirty.value,
                    isValid: controller.validatePassword(controller.passwordController.text) == null,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),
                SizedBox(height: 24.h),

                Text.rich(
                  TextSpan(
                    text: 'By signing up you agree to our ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    children: const [
                      TextSpan(text: 'Terms', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontWeight: FontWeight.bold)),
                      TextSpan(text: ', '),
                      TextSpan(text: 'Privacy Policy', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontWeight: FontWeight.bold)),
                      TextSpan(text: ', and '),
                      TextSpan(text: 'Cookie Use', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value || !controller.isFormValid.value
                        ? null // লোড বা ফর্ম ইনভ্যালিড হলে বাটন ডিজেবল
                        : controller.createAccountWithEmail, // নতুন ফাংশন কল
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: controller.isFormValid.value ? Colors.black : Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0))
                        : Text(
                      'Create an Account',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: controller.isFormValid.value ? Colors.white : Colors.grey[500]),
                    ),
                  ),
                )),
                SizedBox(height: 32.h),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text('Or', style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 32.h),

                Obx(() => _buildSocialButton(
                  'assets/icons/icons-google.png',
                  'Sign Up with Google',
                  onPressed: controller.isLoading.value ? null : controller.nativeGoogleSignIn,
                )),
                SizedBox(height: 40.h),

                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed(Routes.LOGIN);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required bool isDirty,
    required bool isValid,
    String? errorText,
  }) {
    Icon? suffixIcon;
    if (isDirty && label != 'Password') {
      suffixIcon = isValid
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.error, color: Colors.red);
    }
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      errorText: isDirty ? errorText : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: isDirty && !isValid ? Colors.red : Get.theme.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildSocialButton(String iconPath, String text, {bool isFacebook = false, VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed, // এখানে onPressed ব্যবহার করুন
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: isFacebook ? const Color(0xFF1877F2) : Colors.white,
          foregroundColor: isFacebook ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: isFacebook ? Colors.transparent : Colors.grey[300]!),
          ),
          elevation: 0,
        ),
        icon: Image.asset(iconPath, height: 24.h, width: 24.w),
        label: Text(text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }
}