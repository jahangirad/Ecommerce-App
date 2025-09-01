import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../widget/button_widget.dart';
import '../widget/text_form_field_widget.dart';
import 'login_screen.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  InputState _passwordState = InputState.normal;
  InputState _confirmPasswordState = InputState.normal;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordState = InputState.normal;
      } else {
        _passwordState = password.length >= 8 ? InputState.success : InputState.error;
      }
      _validateConfirmPassword(_confirmPasswordController.text);
    });
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordState = InputState.normal;
      } else {
        _confirmPasswordState =
        _passwordController.text == confirmPassword && _passwordState == InputState.success
            ? InputState.success
            : InputState.error;
      }
    });
  }

  void _showPasswordChangedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 40.sp),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Password Changed!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your can now use your new password to login to your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 32.h),
                PrimaryButton(
                  text: 'Login',
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = _passwordState == InputState.success &&
        _confirmPasswordState == InputState.success;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
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
              'Reset Password',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Set the new password for your account so you can login and access all the features.',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),
            CustomTextField(
              labelText: 'Password',
              hintText: '**********',
              controller: _passwordController,
              onChanged: _validatePassword,
              inputState: _passwordState,
              errorMessage: 'Password must be at least 8 characters.',
              isPassword: true,
              isPasswordVisible: _isPasswordVisible,
              onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            SizedBox(height: 24.h),
            CustomTextField(
              labelText: 'Confirm Password',
              hintText: '**********',
              controller: _confirmPasswordController,
              onChanged: _validateConfirmPassword,
              inputState: _confirmPasswordState,
              errorMessage: 'Passwords do not match.',
              isPassword: true,
              isPasswordVisible: _isConfirmPasswordVisible,
              onToggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
            ),
            SizedBox(height: 40.h),
            Obx(() => PrimaryButton(
              text: _authController.isLoading.value ? 'Updating...' : 'Continue',
              isEnabled: isButtonEnabled && !_authController.isLoading.value,
              onPressed: () async {
                if (isButtonEnabled) {
                  await _authController.updatePassword(_passwordController.text.trim());
                  // The dialog will be shown after a successful update and navigation in AuthController
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}