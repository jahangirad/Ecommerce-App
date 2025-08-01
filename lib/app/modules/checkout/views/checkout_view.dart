import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});
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
        title: Text('Checkout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryAddress(),
            SizedBox(height: 25.h),
            _buildPaymentMethod(),
            SizedBox(height: 25.h),
            _buildOrderSummary(),
            SizedBox(height: 25.h),
            _buildPromoCodeSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderButton(),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onChange}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        if (onChange != null)
          TextButton(
            onPressed: onChange,
            child: Text('Change', style: TextStyle(color: Colors.black, fontSize: 14.sp)),
          ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Delivery Address', onChange: controller.goToChangeAddress),
        SizedBox(height: 10.h),
        if (controller.selectedAddress.value.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 24.sp),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.selectedAddress.value['title'] as String, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Text(
                      controller.selectedAddress.value['address'] as String,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text('Please select a delivery address.', style: TextStyle(color: Colors.grey[600])),
          ),
        SizedBox(height: 15.h),
        const Divider(),
      ],
    ));
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Payment Method'),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPaymentTypeChip('Card', FontAwesomeIcons.creditCard, 'Card'),
            _buildPaymentTypeChip('Cash', FontAwesomeIcons.moneyBill, 'Cash'),
          ],
        ),
        SizedBox(height: 15.h),
        Obx(() {
          if (controller.selectedPaymentType.value == 'Card') {
            if (controller.selectedCard.value.isNotEmpty) {
              return _buildSelectedCard();
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text('Please select a payment card.', style: TextStyle(color: Colors.grey[600])),
              );
            }
          }
          return const SizedBox.shrink();
        }),
        SizedBox(height: 15.h),
        const Divider(),
      ],
    );
  }

  Widget _buildPaymentTypeChip(String label, IconData icon, String type) {
    return Obx(() => Expanded(
      child: GestureDetector(
        onTap: () => controller.changePaymentType(type),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: controller.selectedPaymentType.value == type ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: controller.selectedPaymentType.value == type ? Colors.black : Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20.sp, color: controller.selectedPaymentType.value == type ? Colors.white : Colors.black),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: controller.selectedPaymentType.value == type ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSelectedCard() {
    String maskedNumber = '**** **** **** ${controller.selectedCard.value['last4Digits']}';
    String cardType = controller.selectedCard.value['type'] ?? 'Other';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          if(cardType == 'VISA')
            Image.asset('assets/img/visacard.png', height: 25.h)
          else if(cardType == 'Mastercard')
            Image.asset('assets/img/mastercard.png', height: 25.h)
          else
            Icon(Icons.credit_card, size: 28.sp),
          SizedBox(width: 15.w),
          Expanded(child: Text(maskedNumber, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500))),
          IconButton(
            onPressed: controller.goToChangePaymentMethod,
            icon: const Icon(Icons.edit_outlined),
          )
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Order Summary'),
        SizedBox(height: 15.h),
        _buildSummaryRow('Sub-total', '\$${controller.subTotal.toStringAsFixed(2)}'),
        _buildSummaryRow('VAT (%)', '\$${controller.vat.toStringAsFixed(2)}'),
        _buildSummaryRow('Shipping fee', '\$${controller.shippingFee.toStringAsFixed(2)}'),
        const Divider(),
        _buildSummaryRow('Total', '\$${controller.total.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])),
          Text(amount, style: TextStyle(fontSize: 16.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter promo code',
              prefixIcon: Icon(Icons.sell_outlined, color: Colors.grey[400]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Colors.black)),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: Text('Add', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        )
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: ElevatedButton(
        onPressed: controller.placeOrder,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
      ),
    );
  }
}