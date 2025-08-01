import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddressController extends GetxController {
  final box = GetStorage();

  final RxList<Map<String, dynamic>> savedAddresses = <Map<String, dynamic>>[].obs;
  final Rx<Map<String, dynamic>> selectedAddress = Rx<Map<String, dynamic>>({});

  final TextEditingController fullAddressController = TextEditingController();
  final Rx<String?> selectedNickname = Rx<String?>(null);
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAddresses();
    fullAddressController.addListener(_validateForm);
  }

  void _loadAddresses() {
    List<dynamic>? storedAddresses = box.read<List<dynamic>>('addresses');
    if (storedAddresses != null && storedAddresses.isNotEmpty) {
      savedAddresses.value = List<Map<String, dynamic>>.from(storedAddresses);

      Map<String, dynamic>? lastSelected = box.read<Map<String, dynamic>>('selected_address');
      if (lastSelected != null && savedAddresses.any((addr) => addr['title'] == lastSelected['title'])) {
        selectedAddress.value = lastSelected;
      } else {
        selectedAddress.value = savedAddresses.first;
      }
    }
  }

  Future<void> _saveAddressesToStorage() async {
    await box.write('addresses', savedAddresses.toList());
  }

  Future<void> _saveSelectedAddress(Map<String, dynamic> address) async {
    await box.write('selected_address', address);
  }

  void selectAddress(Map<String, dynamic> address) {
    selectedAddress.value = address;
    _saveSelectedAddress(address);
  }

  void _validateForm() {
    isFormValid.value = fullAddressController.text.isNotEmpty && selectedNickname.value != null;
  }

  void addAddress() {
    if (!isFormValid.value) return;

    final newAddress = {
      'title': selectedNickname.value!,
      'address': fullAddressController.text,
    };

    savedAddresses.add(newAddress);
    selectAddress(newAddress);
    _saveAddressesToStorage();

    Get.back();
    _resetForm();
    showCongratulationsDialog();
  }

  void _resetForm() {
    fullAddressController.clear();
    selectedNickname.value = null;
    isFormValid.value = false;
  }

  void showAddAddressBottomSheet() {
    _resetForm();
    Get.bottomSheet(
      _buildAddAddressBottomSheet(),
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

// এই উইজেটগুলো কন্ট্রোলার ফাইলের মধ্যেই রাখা হলো

Widget _buildAddAddressBottomSheet() {
  final AddressController controller = Get.find();
  final List<String> nicknames = ['Home', 'Office', 'Apartment', "Parent's House", 'Other'];

  return Padding(
    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Address', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
          ],
        ),
        SizedBox(height: 20.h),
        Text('Address Nickname', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedNickname.value,
          hint: const Text('Choose one'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          items: nicknames.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            controller.selectedNickname.value = newValue;
            controller._validateForm();
          },
        )),
        SizedBox(height: 20.h),
        Text('Full Address', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller.fullAddressController,
          decoration: InputDecoration(
            hintText: 'Enter your full address...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
        SizedBox(height: 20.h),
        // --- এখানে পরিবর্তন করা হয়েছে ---
        // "Make this as a default address" চেকবক্সটি সরানো হয়েছে
        // Obx(() => CheckboxListTile(...)), <-- এই অংশটি সরানো হয়েছে

        SizedBox(
          width: double.infinity,
          child: Obx(() => ElevatedButton(
            onPressed: controller.isFormValid.value ? controller.addAddress : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              backgroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Add', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
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
          Text(
            'Congratulations!',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            'Your new address has been added.',
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
