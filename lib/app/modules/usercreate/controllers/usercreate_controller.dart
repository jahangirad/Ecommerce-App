import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UsercreateController extends GetxController {
  // Text Editing Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();

  // Observable for Gender Dropdown
  final Rxn<String> selectedGender = Rxn<String>();
  final genderOptions = ['Male', 'Female', 'Other'];



  // Date Picker ফাংশন
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 7, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // তারিখ ফরম্যাট করে কন্ট্রোলারে সেট করা
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // জেন্ডার পরিবর্তনের ফাংশন
  void onGenderChanged(String? newValue) {
    if (newValue != null) {
      selectedGender.value = newValue;
    }
  }

  // সাবমিট ফাংশন
  void submitDetails() {
    // এখানে ডেটা সাবমিট করার জন্য API কল করা হবে
    Get.snackbar(
      'Success',
      'Details updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
