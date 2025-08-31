import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../core/routes/app_route.dart';
import '../widget/button_widget.dart';
import '../widget/social_login_button_widget.dart';
import '../widget/text_form_field_widget.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFormValid = false;

  InputState _emailState = InputState.normal;
  InputState _passwordState = InputState.normal;
  String? _emailErrorMessage;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }
  void _checkFormValidity() {
    final bool isValid = _emailState == InputState.success &&
        _passwordState == InputState.success;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _validateEmail(String email) {
    setState(() {
      if (email.isEmpty) {
        _emailState = InputState.normal;
        _emailErrorMessage = null;
      } else {
        final bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
        if (isValid) {
          _emailState = InputState.success;
          _emailErrorMessage = null;
        } else {
          _emailState = InputState.error;
          _emailErrorMessage = "Please enter valid email address";
        }
      }
    });
    _checkFormValidity(); // প্রতিবার ভ্যালিডেশনের পর ফর্ম চেক করা হচ্ছে
  }

  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordState = InputState.normal;
      } else if (password.length >= 8) {
        _passwordState = InputState.success;
      } else {
        _passwordState = InputState.error; // ছোট পাসওয়ার্ডের জন্য error স্টেট
      }
    });
    _checkFormValidity(); // প্রতিবার ভ্যালিডেশনের পর ফর্ম চেক করা হচ্ছে
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx((){
              if (authController.isLoading.value) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Text('Login to your account', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
                  SizedBox(height: 8.h),
                  Text("It's great to see you again.", style: TextStyle(fontSize: 16.sp, color: const Color(0xFF6B7280))),
                  SizedBox(height: 32.h),
                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    controller: _emailController,
                    onChanged: _validateEmail, // 1. এই লাইনটি যোগ করা হয়েছে
                    inputState: _emailState,
                    errorMessage: _emailErrorMessage,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    onChanged: _validatePassword, // 2. এই লাইনটি যোগ করা হয়েছে
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onToggleVisibility: _togglePasswordVisibility,
                    inputState: _passwordState,
                    errorMessage: 'Password must be at least 8 characters',
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: 'Forgot your password? ',
                        style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                        children: [
                          TextSpan(
                            text: 'Reset your password',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 14.sp,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {Get.toNamed(AppRoute.forgotscreen);},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  PrimaryButton(
                    text: 'Login',
                    isEnabled: _isFormValid,
                    onPressed: () {
                      if (_isFormValid) {
                        authController.signInWithEmailPassword(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text('Or', style: TextStyle(color: const Color(0xFF6B7280), fontSize: 14.sp)),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  SocialSignInButton(
                    text: 'Continue with Google',
                    iconPath: 'assets/icon/icons-google.png',
                    backgroundColor: Colors.white,
                    onPressed: () => authController.googleSignIn(),
                  ),
                  SizedBox(height: 16.h),
                  SocialSignInButton(
                    text: 'Continue with Facebook',
                    iconPath: 'assets/icon/icons-facebook.png',
                    backgroundColor: const Color(0xFF1877F2),
                    textColor: Colors.white,
                    onPressed: () => authController.signInWithFacebook(),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                        children: [
                          TextSpan(
                            text: 'Join',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.sp),
                            recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoute.signupscreen),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}