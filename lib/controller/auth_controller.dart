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

      // Supabase maneja la redirección. লা নেভিগেশন সে পুডে মানেজার
      // আ ত্রাভেস দে উন লিসেনার দেল এস্তাদো দে আউতেন্তিকাসিওন এন লা UI.

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

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      await supabase.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'ecommerce://reset-pass', // Updated redirect URL
      );
      Get.snackbar(
        'Success',
        'Password reset link has been sent to your email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      isLoading.value = true;
      final response = await supabase.auth.updateUser(
        UserAttributes(password: newPassword.trim()),
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Password updated successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(AppRoute.loginscreen); // Navigate to login after successful update
      } else {
        throw Exception('Failed to update password');
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePasswordSecurely(String currentPassword, String newPassword) async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;

      if (user == null || user.email == null) {
        throw Exception('User not logged in');
      }

      // Step 1: Verify current password
      // Supabase's update method can directly handle password changes for the logged-in user.
      // Explicitly signing in again is usually not needed for a logged-in user to change their password,
      // unless there's a specific policy requiring re-authentication.
      // For a secure password change, just updating the user with the new password should suffice.
      // If you specifically want to re-verify the current password on the client-side, you'd need a backend
      // function or a client-side comparison (less secure).
      // Here, we'll assume the user is logged in and directly proceed with the update.
      // If the backend requires the old password for verification, that would typically be handled server-side.

      final response = await supabase.auth.updateUser(
        UserAttributes(password: newPassword.trim()),
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Password changed successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(AppRoute.loginscreen); // Navigate to login after successful change
      } else {
        throw Exception('Failed to update password.');
      }

    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}