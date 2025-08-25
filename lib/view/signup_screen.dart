import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/routes/app_route.dart';
import '../widget/button_widget.dart';
import '../widget/social_login_button_widget.dart';
import '../widget/text_form_field_widget.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  InputState _nameState = InputState.normal;
  InputState _emailState = InputState.normal;
  InputState _passwordState = InputState.normal;

  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isEmpty) {
        _nameState = InputState.normal;
      } else if (_nameController.text.length > 2) {
        _nameState = InputState.success;
      } else {
        _nameState = InputState.error;
      }
      _checkFormValidity();
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    final bool isEmailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    setState(() {
      if (email.isEmpty) {
        _emailState = InputState.normal;
      } else if (isEmailValid) {
        _emailState = InputState.success;
      } else {
        _emailState = InputState.error;
      }
      _checkFormValidity();
    });
  }

  void _validatePassword() {
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordState = InputState.normal;
      } else if (_passwordController.text.length >= 8) {
        _passwordState = InputState.success;
      } else {
        _passwordState = InputState.error;
      }
      _checkFormValidity();
    });
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _nameState == InputState.success &&
          _emailState == InputState.success &&
          _passwordState == InputState.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Text('Create an account', style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Text("Let's create your account.", style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600)),
              SizedBox(height: 30.h),
              CustomTextField(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                controller: _nameController,
                onChanged: (_) => _validateName(), // onChanged এ ফাংশন কল করা প্রয়োজন
                inputState: _nameState,
                errorMessage: 'Name must be more than 2 characters.',
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Email',
                hintText: 'Enter your email address',
                controller: _emailController,
                onChanged: (_) => _validateEmail(), // onChanged এ ফাংশন কল করা প্রয়োজন
                inputState: _emailState,
                errorMessage: 'Please enter a valid email address',
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                onChanged: (_) => _validatePassword(), // onChanged এ ফাংশন কল করা প্রয়োজন
                isPassword: true,
                inputState: _passwordState,
                isPasswordVisible: _isPasswordVisible,
                onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                errorMessage: "Password must be at least 8 characters",
              ),
              SizedBox(height: 25.h),
              buildTermsAndConditions(),
              SizedBox(height: 30.h),
              PrimaryButton(
                text: 'Create an Account',
                isEnabled: _isFormValid,
                onPressed: () {
                  Get.toNamed(AppRoute.dashboardscreen);
                },
              ),
              SizedBox(height: 30.h),

              // Divider
              buildDivider(),
              SizedBox(height: 30.h),

              // Social Sign-in Buttons
              SocialSignInButton(text: 'Sign Up with Google', iconPath: 'assets/icon/icons-google.png', backgroundColor: Colors.white, onPressed: () {}),
              SizedBox(height: 15.h),
              SocialSignInButton(text: 'Sign Up with Facebook', iconPath: 'assets/icon/icons-facebook.png', backgroundColor: const Color(0xFF1877F2), textColor: Colors.white, onPressed: () {}),
              SizedBox(height: 40.h),

              // Login Link
              buildLoginLink(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget buildTermsAndConditions() {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
        children: [
          const TextSpan(text: 'By signing up you agree to our '),
          TextSpan(text: 'Terms', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), recognizer: TapGestureRecognizer()..onTap = () {}),
          const TextSpan(text: ', '),
          TextSpan(text: 'Privacy Policy', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), recognizer: TapGestureRecognizer()..onTap = () {}),
          const TextSpan(text: ', and '),
          TextSpan(text: 'Cookie Use', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), recognizer: TapGestureRecognizer()..onTap = () {}),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text('Or', style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp)),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget buildLoginLink() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
          children: [
            const TextSpan(text: 'Already have an account? '),
            TextSpan(text: 'Log In', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), recognizer: TapGestureRecognizer()..onTap = () {Get.toNamed(AppRoute.loginscreen);}),
          ],
        ),
      ),
    );
  }
}