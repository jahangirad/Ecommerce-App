import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 52.h),
                Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 8.h),
                Text(
                  'It\'s great to see you again.',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 40.h),

                // -- Email Field --
                TextFormField(
                  controller: controller.emailController,
                  validator: controller.validateEmail,
                  decoration: _buildInputDecoration(
                    label: 'Email',
                    isValid: controller.validateEmail(controller.emailController.text) == null && controller.emailController.text.isNotEmpty,
                    errorText: controller.emailController.text.isNotEmpty && controller.validateEmail(controller.emailController.text) != null
                        ? 'Please enter valid email address'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24.h),

                // -- Password Field --
                Obx(() => TextFormField(
                  controller: controller.passwordController,
                  validator: controller.validatePassword,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: _buildInputDecoration(
                    label: 'Password',
                    isValid: controller.validatePassword(controller.passwordController.text) == null && controller.passwordController.text.isNotEmpty,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),
                SizedBox(height: 16.h),

                // -- Forgot Password --
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: 'Forgot your password? ',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: 'Reset your password',
                          style: const TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.FORGOT),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // -- Login Button --
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isFormValid.value ? controller.login : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: controller.isFormValid.value ? Colors.black : Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: controller.isFormValid.value ? Colors.white : Colors.grey[500]),
                    ),
                  ),
                )),
                SizedBox(height: 32.h),

                // -- Divider --
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

                // -- Social Login Buttons --
                _buildSocialButton('assets/icons/icons-google.png', 'Login with Google'),
                SizedBox(height: 16.h),
                _buildSocialButton('assets/icons/icons-facebook.png', 'Login with Facebook', isFacebook: true),
                SizedBox(height: 80.h),

                // -- Join Link --
                // Join (Create Account) লিঙ্কে নেভিগেট করার কোড
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Join',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed(Routes.SIGNUP); // Login পেজ থেকে Create Account পেজে যাবে
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

  InputDecoration _buildInputDecoration({required String label, required bool isValid, String? errorText}) {
    Icon? suffixIcon;
    if (label != 'Password' && controller.emailController.text.isNotEmpty) {
      suffixIcon = isValid
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.error, color: Colors.red);
    }

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      errorText: errorText,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: isValid ? Colors.green : (errorText != null ? Colors.red : Get.theme.primaryColor)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildSocialButton(String iconPath, String text, {bool isFacebook = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
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
