import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/checkout_controller.dart';
import '../widget/button_widget.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // 0: Card, 1: Cash, 2: Pay
  int _selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার ইনিশিয়ালাইজ করুন
    final CheckoutController controller = Get.put(CheckoutController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            _buildSectionHeader('Delivery Address', onChange: controller.changeAddress),
            SizedBox(height: 16.h),
            Obx(() {
              if (controller.selectedAddress.value.isEmpty) {
                return const Text('No address selected.');
              }
              return _buildAddressInfo(
                title: controller.selectedAddress.value['nickname'] ?? 'N/A',
                address: controller.selectedAddress.value['fullAddress'] ?? '',
              );
            }),
            const Divider(height: 32),

            // Payment Method Section
            _buildSectionHeader('Payment Method'),
            SizedBox(height: 16.h),
            _buildPaymentMethodToggle(),
            SizedBox(height: 16.h),
            Obx(() {
              if (controller.selectedPaymentCard.value.isEmpty) {
                return const Text('No payment card selected.');
              }
              // শুধুমাত্র 'Card' সিলেক্ট করা থাকলেই কার্ডের তথ্য দেখাবে
              return Visibility(
                visible: _selectedPaymentMethod == 0,
                child: _buildCardInfo(
                  cardType: controller.selectedPaymentCard.value['cardType'] ?? 'VISA',
                  lastFourDigits: controller.selectedPaymentCard.value['lastFourDigits'] ?? '',
                  onChange: controller.changePaymentCard,
                ),
              );
            }),
            const Divider(height: 32),

            // Order Summary Section
            _buildSectionHeader('Order Summary'),
            SizedBox(height: 16.h),
            Obx(() => _buildOrderSummary(controller)),
            const Divider(height: 32),

            // Promo Code Section
            _buildPromoCodeField(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: PrimaryButton(
          text: 'Place Order',
          onPressed: () {
            // অর্ডার প্লেস করার লজিক এখানে লিখুন
          },
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionHeader(String title, {VoidCallback? onChange}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        if (onChange != null)
          TextButton(
            onPressed: onChange,
            child: Text('Change', style: TextStyle(fontSize: 15.sp)),
          ),
      ],
    );
  }

  Widget _buildAddressInfo({required String title, required String address}) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: Colors.grey.shade600),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 4.h),
              Text(address, style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodToggle() {
    return Row(
      children: [
        _buildPaymentOption(
          icon: Icons.credit_card,
          label: 'Card',
          isSelected: _selectedPaymentMethod == 0,
          onTap: () => setState(() => _selectedPaymentMethod = 0),
        ),
        SizedBox(width: 12.w),
        _buildPaymentOption(
          icon: Icons.money,
          label: 'Cash',
          isSelected: _selectedPaymentMethod == 1,
          onTap: () => setState(() => _selectedPaymentMethod = 1),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black, size: 20.sp),
              SizedBox(width: 8.w),
              Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInfo({
    required String cardType,
    required String lastFourDigits,
    required VoidCallback onChange,
  }) {
    return InkWell(
      onTap: onChange,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Text(cardType, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                '**** **** **** $lastFourDigits',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700, letterSpacing: 1.5),
              ),
            ),
            Icon(Icons.edit_outlined, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CheckoutController controller) {
    return Column(
      children: [
        _buildSummaryRow('Sub-total', '\$${controller.subTotal.value.toStringAsFixed(0)}'),
        SizedBox(height: 12.h),
        _buildSummaryRow('VAT (%)', '\$${controller.vat.value.toStringAsFixed(0)}'),
        SizedBox(height: 12.h),
        _buildSummaryRow('Shipping fee', '\$${controller.shippingFee.value.toStringAsFixed(0)}'),
        const Divider(height: 30, thickness: 1),
        _buildSummaryRow('Total', '\$${controller.total.value.toStringAsFixed(0)}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600)),
        Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPromoCodeField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter promo code',
              prefixIcon: Icon(Icons.local_offer_outlined, color: Colors.grey.shade500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: Size(80.w, 55.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}