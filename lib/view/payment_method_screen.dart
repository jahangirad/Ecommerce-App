import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../widget/button_widget.dart';
import '../widget/dialog_status.dart';


// ============== Payment Method Screen ==============
class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _box = GetStorage();
  final String _cardListKey = 'saved_cards';

  List<Map<String, dynamic>> _savedCards = [];
  int _selectedCardIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    final List<dynamic>? cardData = _box.read<List<dynamic>>(_cardListKey);
    if (cardData != null) {
      setState(() {
        _savedCards = List<Map<String, dynamic>>.from(cardData);
        _selectedCardIndex =
            _savedCards.indexWhere((card) => card['isDefault'] == true);
      });
    }
  }

  Future<void> _saveCards() async {
    await _box.write(_cardListKey, _savedCards);
  }

  void _showAddNewCardSheet() {
    showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddNewCardBottomSheet(),
    ).then((newCard) {
      if (newCard != null) {
        _showCongratulationsDialog().then((_) {
          setState(() {
            if (_savedCards.isEmpty) {
              newCard['isDefault'] = true;
              _selectedCardIndex = 0;
            }
            _savedCards.add(newCard);
            _saveCards();
          });
        });
      }
    });
  }

  void _setDefaultCard(int newIndex) {
    if (_selectedCardIndex == newIndex) return;

    setState(() {
      if (_selectedCardIndex != -1 && _selectedCardIndex < _savedCards.length) {
        _savedCards[_selectedCardIndex]['isDefault'] = false;
      }
      _savedCards[newIndex]['isDefault'] = true;
      _selectedCardIndex = newIndex;
      _saveCards();
    });
  }

  Future<void> _showCongratulationsDialog() {
    return showDialog(
      context: context,
      builder: (_) => StatusDialog(title: 'Congratulations!', message: 'Your new card has been added.', onButtonPressed: () {Navigator.pop(context);},),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
        title: const Text('Payment Method'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text('Saved Cards', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            Expanded(
              child: _savedCards.isEmpty
                  ? Center(child: Text('No saved cards.', style: TextStyle(fontSize: 16.sp, color: Colors.grey)))
                  : ListView.builder(
                itemCount: _savedCards.length,
                itemBuilder: (context, index) {
                  final card = _savedCards[index];
                  return CardListItem(
                    card: card,
                    isSelected: _selectedCardIndex == index,
                    onSelected: () => _setDefaultCard(index),
                  );
                },
              ),
            ),
            OutlinedButton.icon(
              onPressed: _showAddNewCardSheet,
              icon: const Icon(Icons.add, color: Colors.black),
              label: Text(
                'Add New Card',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 52.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 20.h),
        child: PrimaryButton(
          text: 'Apply',
          onPressed: () {
            if (_selectedCardIndex != -1) {
              Get.back(result: _savedCards[_selectedCardIndex]);
            } else {
              Get.back();
            }
          },
        ),
      ),
    );
  }
}

// ============== Add New Card Bottom Sheet ==============
class AddNewCardBottomSheet extends StatefulWidget {
  const AddNewCardBottomSheet({super.key});

  @override
  State<AddNewCardBottomSheet> createState() => _AddNewCardBottomSheetState();
}

class _AddNewCardBottomSheetState extends State<AddNewCardBottomSheet> {
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _securityCodeController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_validateInput);
    _expiryDateController.addListener(_validateInput);
    _securityCodeController.addListener(_validateInput);
  }

  void _validateInput() {
    final isValid = _cardNumberController.text.length >= 19 &&
        _expiryDateController.text.length >= 5 &&
        _securityCodeController.text.length >= 3;
    if (isValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  void _onAddCardPressed() {
    if (!_isButtonEnabled) return;

    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    String cardType = 'UNKNOWN';
    if (cardNumber.startsWith('4')) {
      cardType = 'VISA';
    } else if (cardNumber.startsWith('5')) {
      cardType = 'MASTERCARD';
    }

    final newCard = {
      'cardType': cardType,
      'lastFourDigits': cardNumber.substring(cardNumber.length - 4),
      'isDefault': false,
    };

    Navigator.pop(context, newCard);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add New Card', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            SizedBox(height: 24.h),
            Text('Card number', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 8.h),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CardNumberInputFormatter(),
              ],
              decoration: InputDecoration(
                hintText: '**** **** **** ****',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expiry Date', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: _expiryDateController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          CardMonthInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: 'MM/YY',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Security Code', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: _securityCodeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: InputDecoration(
                          hintText: 'CVC',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                          suffixIcon: Icon(Icons.help_outline, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            PrimaryButton(text: 'Add Card', onPressed: _onAddCardPressed, isEnabled: _isButtonEnabled),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

// ============== Shared Widgets ==============
class CardListItem extends StatelessWidget {
  final Map<String, dynamic> card;
  final bool isSelected;
  final VoidCallback onSelected;

  const CardListItem({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onSelected,
  });

  Widget _getCardIcon(String cardType) {
    String? imagePath;
    double width = 45.w;

    if (cardType == 'VISA') {
      imagePath = 'assets/icon/visacard.png';
    } else if (cardType == 'MASTERCARD') {
      imagePath = 'assets/icon/mastercard.png';
    }

    if (imagePath != null) {
      return Image.asset(
        imagePath,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(width: width);
        },
      );
    }
    return SizedBox(width: width);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF1F2937) : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _getCardIcon(card['cardType'] ?? 'UNKNOWN'),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                '**** **** **** ${card['lastFourDigits'] ?? ''}',
                style: TextStyle(fontSize: 16.sp, letterSpacing: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (card['isDefault'] == true)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                margin: EdgeInsets.only(left: 8.w),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.r)),
                child: Text('Default',
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700)),
              ),
            SizedBox(width: 8.w),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (bool? value) => onSelected(),
              activeColor: const Color(0xFF1F2937),
            ),
          ],
        ),
      ),
    );
  }
}


class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}