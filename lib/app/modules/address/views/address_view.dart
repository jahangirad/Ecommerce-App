import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Address', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text('Saved Address', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.h),
            Expanded(
              child: Obx(() {
                if (controller.savedAddresses.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved addresses yet.\nClick below to add one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.savedAddresses.length,
                  itemBuilder: (context, index) {
                    final address = controller.savedAddresses[index];
                    return _buildAddressCard(address);
                  },
                );
              }),
            ),
            SizedBox(height: 10.h),
            _buildAddNewAddressButton(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildApplyButton(),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address) {
    return Obx(() => GestureDetector(
      onTap: () => controller.selectAddress(address),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: controller.selectedAddress.value['title'] == address['title']
                ? Colors.black
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 28.sp),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address['title'] as String, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  Text(
                    address['address'] as String,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: address['title'] as String,
              groupValue: controller.selectedAddress.value['title'] as String?,
              onChanged: (value) => controller.selectAddress(address),
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAddNewAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.showAddAddressBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add New Address'),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: Text('Apply', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
      ),
    );
  }
}