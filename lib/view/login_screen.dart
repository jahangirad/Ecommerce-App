import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// আপনার প্রোজেক্টের সঠিক পাথ অনুযায়ী import করুন
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
  // 1. Get.find() ব্যবহার করে কন্ট্রোলার খুঁজে নেওয়া হচ্ছে।
  // (ধরে নেওয়া হচ্ছে main.dart-এ Get.put(AuthController()) করা আছে)
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
    // কন্ট্রোলারগুলোতে লিসেনার যোগ করা হচ্ছে
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onFieldChanged);
    _passwordController.removeListener(_onFieldChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // যেকোনো ফিল্ড পরিবর্তনের সাথে সাথে ভ্যালিডেশন চেক হবে
  void _onFieldChanged() {
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);
    _checkFormValidity();
  }

  // 2. ফর্মের ভ্যালিডিটি চেক করার জন্য একটি হেল্পার ফাংশন
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
    InputState newState;
    if (email.isEmpty) {
      newState = InputState.normal;
      _emailErrorMessage = null;
    } else {
      final bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
      if (isValid) {
        newState = InputState.success;
        _emailErrorMessage = null;
      } else {
        newState = InputState.error;
        _emailErrorMessage = "Please enter a valid email address";
      }
    }
    if(newState != _emailState) setState(() => _emailState = newState);
  }

  void _validatePassword(String password) {
    InputState newPasswordState;
    if (password.isEmpty) {
      newPasswordState = InputState.normal;
    } else if (password.length >= 8) {
      newPasswordState = InputState.success;
    } else {
      // 3. পাসওয়ার্ড ছোট হলে এরর স্টেট সেট করা হচ্ছে
      newPasswordState = InputState.error;
    }
    if (newPasswordState != _passwordState) setState(() => _passwordState = newPasswordState);
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
                  // ... Forgot Password Link ...
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
                  // ... Divider ...
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