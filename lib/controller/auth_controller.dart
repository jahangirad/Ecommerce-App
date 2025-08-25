import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/routes/app_route.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();


  Future<void> signUpWithEmailPassword(String fullName, String email, String password) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        // এখানে data property ব্যবহার করে অতিরিক্ত তথ্য যেমন নাম পাঠানো যায়
        data: {'full_name': fullName},
      );

      // সাইন-আপ সফল হলে
      if (res.user != null) {
        Get.snackbar(
          'Success',
          'Confirmation email sent! Please check your inbox to verify.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // ব্যবহারকারীকে লগইন পেজে পাঠানো হলো যাতে ভেরিফাই করার পর লগইন করতে পারে
        Get.toNamed(AppRoute.loginscreen);
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Error', errorMessage.value ?? 'An unknown error occurred.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      Get.snackbar('Error', errorMessage.value!,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        // সফলভাবে লগইন হলে ড্যাশবোর্ডে নেভিগেট করা হবে
        Get.offAllNamed(AppRoute.dashboardscreen);
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Login Failed', errorMessage.value ?? 'An unknown error occurred.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      Get.snackbar('Error', errorMessage.value!,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      /// TODO: Reemplaza con tus propios Web e iOS client ID.
      final webClientId = dotenv.env['webClientId'];
      final iosClientId = dotenv.env['iosClientId'];

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // El usuario canceló el inicio de sesión
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'An unknown error occurred.';
      }
      if (idToken == null) {
        throw 'An unknown error occurred.';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Navegar a la pantalla de dashboard si el inicio de sesión es exitoso
      Get.toNamed(AppRoute.dashboardscreen);

    } catch (e) {
      errorMessage.value = 'An unknown error occurred: $e';
      Get.snackbar('Error', errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithFacebook() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'ecommerce://facebook-loging', // Opcional: para deep linking
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      // Supabase maneja la redirección. La navegación se puede manejar
      // a través de un listener del estado de autenticación en la UI.

    } catch (e) {
      errorMessage.value = 'An unknown error occurred: $e';
      Get.snackbar('Error', errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await supabase.auth.signOut();

      Get.toNamed(AppRoute.loginscreen);

    } on AuthException catch (e) {
      Get.snackbar(
        'Logout Failed',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'An Error Occurred',
        'Could not log out. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
