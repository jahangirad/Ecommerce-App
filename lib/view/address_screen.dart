import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widget/button_widget.dart';
import '../widget/dialog_status.dart';


class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _box = GetStorage();
  final String _addressListKey = 'saved_addresses';

  List<Map<String, dynamic>> _savedAddresses = [];
  int _selectedAddressIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    final List<dynamic>? addressData = _box.read<List<dynamic>>(_addressListKey);
    if (addressData != null) {
      setState(() {
        _savedAddresses = List<Map<String, dynamic>>.from(addressData);
        _selectedAddressIndex =
            _savedAddresses.indexWhere((addr) => addr['isDefault'] == true);
      });
    }
  }

  Future<void> _saveAddresses() async {
    await _box.write(_addressListKey, _savedAddresses);
  }

  void _showAddNewAddressSheet() {
    showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddNewAddressBottomSheet(),
    ).then((newAddress) {
      if (newAddress != null) {
        _showCongratulationsDialog().then((_) {
          setState(() {
            // যদি এটি প্রথম ঠিকানা হয়, তবে এটিকে ডিফল্ট করা হবে
            if (_savedAddresses.isEmpty) {
              newAddress['isDefault'] = true;
              _selectedAddressIndex = 0;
            } else {
              // যদি নতুন ঠিকানা যোগ করার সময় সেটিকে ডিফল্ট করতে চান
              // তাহলে এখানে লজিক যোগ করতে হবে, আপাতত false রাখা হলো
              newAddress['isDefault'] = false;
            }
            _savedAddresses.add(newAddress);
            _saveAddresses();
          });
        });
      }
    });
  }

  Future<void> _showCongratulationsDialog() {
    return showDialog(
      context: context,
      builder: (_) => StatusDialog(title: 'Congratulations!', message: 'Your new address has been added.', onButtonPressed: () {Navigator.pop(context);},),
    );
  }

  // ===== মূল পরিবর্তনটি এখানে করা হয়েছে =====
  void _setDefaultAddress(int newIndex) {
    // যদি একই আইটেম আবার সিলেক্ট করা হয়, তাহলে কিছু করার দরকার নেই
    if (_selectedAddressIndex == newIndex) return;

    setState(() {
      // ১. আগের ডিফল্ট ঠিকানা খুঁজে বের করে তার 'isDefault' false করা হচ্ছে
      if (_selectedAddressIndex != -1 && _selectedAddressIndex < _savedAddresses.length) {
        _savedAddresses[_selectedAddressIndex]['isDefault'] = false;
      }

      // ২. নতুন সিলেক্ট করা ঠিকানার 'isDefault' true করা হচ্ছে
      _savedAddresses[newIndex]['isDefault'] = true;

      // ৩. সিলেক্ট করা ইনডেক্স আপডেট করা হচ্ছে
      _selectedAddressIndex = newIndex;

      // ৪. পরিবর্তনগুলো GetStorage-এ সেভ করা হচ্ছে
      _saveAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back),),
        title: const Text('Address'),
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
            Text(
              'Saved Address',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: _savedAddresses.isEmpty
                  ? Center(
                child: Text(
                  'No saved addresses found.\nAdd one to get started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.sp, color: Colors.grey.shade600),
                ),
              )
                  : ListView.builder(
                itemCount: _savedAddresses.length,
                itemBuilder: (context, index) {
                  final address = _savedAddresses[index];
                  return AddressListItem(
                    address: address,
                    isSelected: _selectedAddressIndex == index,
                    // এখন onSelected নতুন _setDefaultAddress ফাংশনটিকে কল করবে
                    onSelected: () {
                      _setDefaultAddress(index);
                    },
                  );
                },
              ),
            ),
            OutlinedButton.icon(
              onPressed: _showAddNewAddressSheet,
              icon: const Icon(Icons.add, color: Colors.black),
              label: Text(
                'Add New Address',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: PrimaryButton(
          text: 'Apply',
          onPressed: () {
            // নির্বাচিত ঠিকানা result হিসেবে পাঠান
            if (_selectedAddressIndex != -1) {
              Get.back(result: _savedAddresses[_selectedAddressIndex]);
            } else {
              Get.back(); // কোনো কিছু সিলেক্ট না হলে 그냥 ফিরে যাবে
            }
          },
        ),
      ),
    );
  }
}

// ঠিকানা তালিকার আইটেম উইজেট (কোনো পরিবর্তন নেই)
class AddressListItem extends StatelessWidget {
  final Map<String, dynamic> address;
  final bool isSelected;
  final VoidCallback onSelected;

  const AddressListItem({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: EdgeInsets.all(16.w),
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
            Icon(Icons.location_on_outlined, color: Colors.grey.shade600),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address['nickname'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (address['isDefault'] == true) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address['fullAddress'] ?? '',
                    style:
                    TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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

// BottomSheet এবং অন্যান্য উইজেটগুলো আগের মতোই থাকবে
// ... (AddNewAddressBottomSheet, CongratulationsDialog, PrimaryButton)

// নিচের উইজেটগুলো আপনার অন্য ফাইল থেকে আসবে, এখানে শুধু দেখানোর জন্য রাখা হলো

class AddNewAddressBottomSheet extends StatefulWidget {
  const AddNewAddressBottomSheet({super.key});
  @override
  State<AddNewAddressBottomSheet> createState() => _AddNewAddressBottomSheetState();
}
class _AddNewAddressBottomSheetState extends State<AddNewAddressBottomSheet> {
  final _addressController = TextEditingController();
  String? _selectedNickname;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_validateInput);
  }

  void _validateInput() {
    final isInputValid =
        _addressController.text.isNotEmpty && _selectedNickname != null;
    if (isInputValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isInputValid;
      });
    }
  }

  void _onAddPressed() {
    if (_isButtonEnabled) {
      final newAddressMap = {
        'nickname': _selectedNickname!,
        'fullAddress': _addressController.text,
        'isDefault': false,
      };
      Navigator.pop(context, newAddressMap);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                Text('Address',
                    style:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text('Address Nickname',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              hint: const Text('Choose one'),
              value: _selectedNickname,
              items: ['Home', 'Office', 'Apartment', "Parent's House"]
                  .map((label) =>
                  DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedNickname = value;
                  _validateInput();
                });
              },
              decoration: InputDecoration(
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(height: 24.h),
            Text('Full Address',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 8.h),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter your full address...',
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(height: 32.h),
            PrimaryButton(
              text: 'Add',
              onPressed: _onAddPressed,
              isEnabled: _isButtonEnabled,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}