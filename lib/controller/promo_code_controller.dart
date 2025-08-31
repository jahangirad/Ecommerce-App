import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

class PromoCodeController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var promoCodes = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchPromoCodes();
  }

  Future<void> fetchPromoCodes() async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await supabase
          .from('promo_codes')
          .select('*')
          .order('id', ascending: true);

      promoCodes.value = List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = "Unexpected error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Copy to clipboard & show GetX snackbar
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Copied!",
      "Code '$text' copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: const Color(0xFF333333),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 2),
    );
  }
}
