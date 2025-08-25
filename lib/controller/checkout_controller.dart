import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../view/address_screen.dart';
import '../view/payment_method_screen.dart';

class CheckoutController extends GetxController {
  final _box = GetStorage();

  // Observable variables
  final Rx<Map<String, dynamic>> selectedAddress = Rx<Map<String, dynamic>>({});
  final Rx<Map<String, dynamic>> selectedPaymentCard = Rx<Map<String, dynamic>>({});

  final subTotal = 0.0.obs;
  final shippingFee = 0.0.obs;
  final vat = 0.0.obs;
  final total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDefaultAddress();
    _loadDefaultCard();
    _loadOrderSummary();
  }

  // GetStorage থেকে ডিফল্ট ঠিকানা লোড করে
  void _loadDefaultAddress() {
    final List<dynamic>? addresses = _box.read<List<dynamic>>('saved_addresses');
    if (addresses != null && addresses.isNotEmpty) {
      final defaultAddress = addresses.firstWhere(
            (addr) => addr['isDefault'] == true,
        orElse: () => addresses.first, // কোনো ডিফল্ট না থাকলে প্রথমটি দেখাবে
      );
      selectedAddress.value = Map<String, dynamic>.from(defaultAddress);
    }
  }

  // GetStorage থেকে ডিফল্ট কার্ড লোড করে
  void _loadDefaultCard() {
    final List<dynamic>? cards = _box.read<List<dynamic>>('saved_cards');
    if (cards != null && cards.isNotEmpty) {
      final defaultCard = cards.firstWhere(
            (card) => card['isDefault'] == true,
        orElse: () => cards.first,
      );
      selectedPaymentCard.value = Map<String, dynamic>.from(defaultCard);
    }
  }

  // CartScreen থেকে পাঠানো আর্গুমেন্ট থেকে অর্ডারের তথ্য লোড করে
  void _loadOrderSummary() {
    if (Get.arguments != null) {
      subTotal.value = Get.arguments['subTotal'] ?? 0.0;
      shippingFee.value = Get.arguments['shippingFee'] ?? 0.0;
      vat.value = Get.arguments['vat'] ?? 0.0;
      total.value = Get.arguments['total'] ?? 0.0;
    }
  }

  // AddressScreen-এ নেভিগেট করে এবং ফলাফল হ্যান্ডেল করে
  void changeAddress() async {
    final result = await Get.to(() => const AddressScreen());
    if (result != null && result is Map<String, dynamic>) {
      selectedAddress.value = result;
    }
  }

  // PaymentMethodScreen-এ নেভিগেট করে এবং ফলাফল হ্যান্ডেল করে
  void changePaymentCard() async {
    final result = await Get.to(() => const PaymentMethodScreen());
    if (result != null && result is Map<String, dynamic>) {
      selectedPaymentCard.value = result;
    }
  }
}