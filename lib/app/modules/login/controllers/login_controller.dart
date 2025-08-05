import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  // Supabase ক্লায়েন্ট ইনিশিয়ালাইজ করুন
  final supabase = Supabase.instance.client;

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables for state management
  final isPasswordVisible = false.obs;
  final isFormValid = false.obs;
  final isLoading = false.obs; // লোডিং স্টেট ম্যানেজ করার জন্য

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

  /// ✅ Supabase দিয়ে ইমেইল ও পাসওয়ার্ড ব্যবহার করে লগইন
  Future<void> loginWithEmail() async {
    // প্রথমে ফর্ম ভ্যালিড কিনা চেক করুন
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        // লগইন সফল হলে ড্যাশবোর্ডে পাঠান
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } on AuthException catch (e) {
      // কোনো সমস্যা হলে ব্যবহারকারীকে জানান
      Get.snackbar(
        'Login Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'An Unexpected Error Occurred',
        'Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Supabase OAuth দিয়ে Google ব্যবহার করে লগইন
  Future<void> signInWithGoogle() async {
    final webClientId = dotenv.env['webClientID'];
    final iosClientId = dotenv.env['iosClientID'];

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      clientId: iosClientId,
    );

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // user cancelled

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Missing Google token';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      Get.snackbar('Native Google Sign-In Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
