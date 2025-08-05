import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  final supabase = Supabase.instance.client;
  final storage = GetStorage();
  final formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Focus nodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // UI state
  final isPasswordVisible = false.obs;
  final isFormValid = false.obs;
  final isLoading = false.obs;

  // Dirty check
  final isNameDirty = false.obs;
  final isEmailDirty = false.obs;
  final isPasswordDirty = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(validateForm);
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);

    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        isNameDirty.value = true;
        formKey.currentState?.validate();
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
    if (value == null || value.isEmpty) return 'Please enter your full name';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email address';
    if (!GetUtils.isEmail(value)) return 'Please enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  /// ✅ Email/password sign up
  Future<void> createAccountWithEmail() async {
    isNameDirty.value = true;
    isEmailDirty.value = true;
    isPasswordDirty.value = true;
    validateForm();
    if (!isFormValid.value) return;

    isLoading.value = true;
    try {
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {'full_name': nameController.text.trim()},
      );
      if (response.user != null) {
        Get.snackbar('Success', 'Account created! Please check your email.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        Get.offNamed(Routes.LOGIN);
        storage.write('isNewUser', false);
      }
    } on AuthException catch (e) {
      Get.snackbar('Sign Up Failed', e.message,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Native Google Sign-In (if you're not using Supabase OAuth redirect)
  Future<void> nativeGoogleSignIn() async {
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
