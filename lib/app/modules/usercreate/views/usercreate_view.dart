import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../routes/app_pages.dart';
import '../controllers/usercreate_controller.dart';

class UsercreateView extends GetView<UsercreateController> {
  const UsercreateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Details',
          style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLabel('Full Name'),
            _buildTextField(texthin: 'Name', controller: controller.nameController),
            SizedBox(height: 24.h),

            _buildLabel('Email Address'),
            _buildTextField(texthin: 'Email', controller: controller.emailController, keyboardType: TextInputType.emailAddress),
            SizedBox(height: 24.h),

            _buildLabel('Date of Birth'),
            GestureDetector(
              onTap: () => controller.selectDate(context),
              child: AbsorbPointer( // এটি সরাসরি টেক্সট ফিল্ডে টাইপ করা বন্ধ করে
                child: _buildTextField(
                  texthin: 'Select Date',
                  controller: controller.dobController,
                  suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            _buildLabel('Gender'),
            _buildGenderDropdown(),
            SizedBox(height: 24.h),

            _buildLabel('Phone Number'),
            _buildPhoneField(),
            SizedBox(height: 48.h),

            ElevatedButton(
              onPressed: (){
                Get.offNamed(Routes.DASHBOARD);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextField({required TextEditingController controller, TextInputType? keyboardType, Widget? suffixIcon, required String texthin}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: texthin,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      // পরিবর্তন এখানে: value এখন null হতে পারে
      value: controller.selectedGender.value,

      // এই hint এখন সঠিকভাবে দেখা যাবে যখন value null থাকবে
      hint: const Text('Select Gender'),

      items: controller.genderOptions.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: controller.onGenderChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    ));
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      controller: controller.phoneController,
      initialCountryCode: 'US', // ছবির মতো ডিফল্ট দেশ
      decoration: InputDecoration(
        hintText: '00000000',
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}