import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PaymentMethodController extends GetxController {
  final box = GetStorage();

  final RxList<Map<String, dynamic>> savedCards = <Map<String, dynamic>>[].obs;
  // নির্বাচিত কার্ডের জন্য এখন পুরো ম্যাপটি রাখব
  final Rx<Map<String, dynamic>> selectedCard = Rx<Map<String, dynamic>>({});

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCards();
    cardNumberController.addListener(_validateForm);
    expiryDateController.addListener(_validateForm);
    cvcController.addListener(_validateForm);
  }

  // GetStorage থেকে ডেটা লোড করার মেথড (পরিবর্তিত)
  void _loadCards() {
    List<dynamic>? storedCards = box.read<List<dynamic>>('cards');
    if (storedCards != null && storedCards.isNotEmpty) {
      savedCards.value = List<Map<String, dynamic>>.from(storedCards);

      Map<String, dynamic>? lastSelected = box.read<Map<String, dynamic>>('selected_card');
      if (lastSelected != null && savedCards.any((card) => card['last4Digits'] == lastSelected['last4Digits'])) {
        selectedCard.value = lastSelected;
      } else {
        selectedCard.value = savedCards.first;
      }
    }
  }

  Future<void> _saveCardsToStorage() async {
    await box.write('cards', savedCards.toList());
  }

  Future<void> _saveSelectedCard(Map<String, dynamic> card) async {
    await box.write('selected_card', card);
  }

  // কার্ড নির্বাচন করার মেথড (পরিবর্তিত)
  void selectCard(Map<String, dynamic> card) {
    selectedCard.value = card;
    _saveSelectedCard(card);
  }

  void _validateForm() {
    isFormValid.value = cardNumberController.text.length >= 12 &&
        expiryDateController.text.isNotEmpty &&
        cvcController.text.length >= 3;
  }

  String _getCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'VISA';
    if (cardNumber.startsWith('5')) return 'Mastercard';
    return 'Other';
  }

  // নতুন কার্ড যোগ করার মেথড (পরিবর্তিত)
  void addCard() {
    if (!isFormValid.value) return;

    final String fullCardNumber = cardNumberController.text;
    final newCard = {
      'type': _getCardType(fullCardNumber),
      'last4Digits': fullCardNumber.substring(fullCardNumber.length - 4),
    };

    savedCards.add(newCard);
    selectCard(newCard); // নতুন যোগ করা কার্ডটি নির্বাচন করুন
    _saveCardsToStorage();

    Get.back();
    _resetForm();
    showCongratulationsDialog();
  }

  void _resetForm() {
    cardNumberController.clear();
    expiryDateController.clear();
    cvcController.clear();
    isFormValid.value = false;
  }

  void showAddCardBottomSheet() {
    _resetForm();
    Get.bottomSheet(
      _buildAddCardBottomSheet(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      isScrollControlled: true,
    );
  }

  void showCongratulationsDialog() {
    Get.dialog(
      _buildCongratulationsDialog(),
      barrierDismissible: false,
    );
  }
}


// কন্ট্রোলারের বাইরের উইজেট বিল্ডার মেথডগুলো
Widget _buildAddCardBottomSheet() {
  final PaymentMethodController controller = Get.find();

  return Padding(
    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Debit or Credit Card', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 25.h),
        Text('Card number', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller.cardNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter your card number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expiry Date', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.expiryDateController,
                    decoration: InputDecoration(
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Security Code', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.cvcController,
                    decoration: InputDecoration(
                      hintText: 'CVC',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      suffixIcon: Icon(Icons.help_outline, color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: double.infinity,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isFormValid.value ? controller.addCard : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              backgroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Add Card', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          )),
        ),
      ],
    ),
  );
}

Widget _buildCongratulationsDialog() {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    child: Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 3),
            ),
            child: Icon(Icons.check, color: Colors.green, size: 40.sp),
          ),
          SizedBox(height: 20.h),
          Text('Congratulations!', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text(
            'Your new card has been added.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 25.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Thanks', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            ),
          ),
        ],
      ),
    ),
  );
}
