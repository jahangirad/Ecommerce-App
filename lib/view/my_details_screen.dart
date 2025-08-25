import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../widget/button_widget.dart';
import '../widget/text_form_field_widget.dart';

class MyDetailsScreen extends StatefulWidget {
  const MyDetailsScreen({super.key});

  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  // Controllers for the text fields
  final _nameController = TextEditingController();
  final _emailController =
  TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedGender = 'Male';
  int _bottomNavIndex = 4; // To highlight 'Account' tab

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back),),
        title: Text(
          'My Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined,
                color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Name
            CustomTextField(
              labelText: 'Full Name',
              hintText: 'Full Name',
              controller: _nameController,
              onChanged: (value) {},
            ),
            SizedBox(height: 24.h),
            // Email Address
            CustomTextField(
              labelText: 'Email Address',
              hintText: 'example@gmail.com',
              controller: _emailController,
              onChanged: (value) {},
            ),
            SizedBox(height: 24.h),
            // Date of Birth
            DateTextField(
              controller: _dobController,
              labelText: 'Date of Birth',
              hintText: '11/22/3333',
            ),
            SizedBox(height: 24.h),
            // Gender
            GenderDropdown(
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
            SizedBox(height: 24.h),
            // Phone Number using intl_phone_field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                IntlPhoneField(
                  controller: _phoneController,
                  initialCountryCode: 'US',
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            // Submit Button
            PrimaryButton(
              text: 'Submit',
              onPressed: () {
                // Handle submit action
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1F2937),
        unselectedItemColor: const Color(0xFF9CA3AF),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Saved'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Account'),
        ],
      ),
    );
  }
}


// Custom widget for Date of Birth - Updated with intl package
class DateTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  const DateTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
            contentPadding:
            EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey.shade600,
            ),
          ),
          onTap: () async {
            // Show date picker
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              // Format date using the intl package
              String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
              controller.text = formattedDate;
            }
          },
        ),
      ],
    );
  }
}

// Custom widget for Gender dropdown
class GenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const GenderDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: ['Male', 'Female', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}