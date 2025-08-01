import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/payment_method_controller.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});
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
        title: Text('Payment Method', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text('Saved Cards', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.h),
            Expanded(
              child: Obx(() {
                if (controller.savedCards.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved cards yet.\nClick "Add" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.savedCards.length,
                  itemBuilder: (context, index) {
                    final card = controller.savedCards[index];
                    return _buildCardWidget(card);
                  },
                );
              }),
            ),
            SizedBox(height: 10.h),
            // AddressView এর মতো Add New Card বাটনটি এখানেও রাখা ভালো
            _buildAddNewCardButton(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildApplyButton(),
    );
  }

  Widget _buildCardWidget(Map<String, dynamic> card) {
    String cardType = card['type'] as String;
    String last4Digits = card['last4Digits'] as String;
    String maskedNumber = '**** **** **** $last4Digits';

    return Obx(() => GestureDetector(
      onTap: () => controller.selectCard(card),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: controller.selectedCard.value['last4Digits'] == last4Digits
                ? Colors.black
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // কার্ডের লোগো
            if (cardType == 'VISA')
              Image.asset('assets/img/visacard.png', height: 25.h)
            else if (cardType == 'Mastercard')
              Image.asset('assets/img/mastercard.png', height: 25.h)
            else
              Icon(Icons.credit_card, size: 28.sp),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(maskedNumber, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            ),
            Radio<String>(
              value: last4Digits,
              groupValue: controller.selectedCard.value['last4Digits'] as String?,
              onChanged: (value) => controller.selectCard(card),
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAddNewCardButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.showAddCardBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add New Card'),
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