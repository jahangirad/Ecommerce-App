import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../view/address_screen.dart';
import 'promo_code_controller.dart';

class CheckoutController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client; // Supabase instance
  final _box = GetStorage();
  final PromoCodeController promoCodeControllerInstance = Get.put(PromoCodeController());

  // Observable variables
  final Rx<Map<String, dynamic>> selectedAddress = Rx<Map<String, dynamic>>({});
  // Removed selectedPaymentCard as it's not used for Stripe PaymentSheet

  final subTotal = 0.0.obs;
  final shippingFee = 0.0.obs;
  final vat = 0.0.obs;

  // RxDouble for total, to be recalculated when discount changes
  final total = 0.0.obs;

  // Payment Method: 0: Card, 1: Cash
  final RxInt selectedPaymentMethod = 0.obs;

  // Promo Code related variables
  final TextEditingController promoCodeController = TextEditingController();
  final RxDouble discountAmount = 0.0.obs;
  final RxString appliedPromoCodeId = ''.obs; // To store the ID if applied successfully from DB
  final RxString promoCodeError = ''.obs; // To show error messages for promo code

  // Placeholder for cart items. This is crucial for _addOrderToSupabase to insert order_items.
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDefaultAddress();
    _loadOrderSummary();
    _loadCartItems();

    // Recalculate total whenever subTotal, shippingFee, vat, or discountAmount changes
    ever(subTotal, (_) => _calculateTotalWithDiscount());
    ever(shippingFee, (_) => _calculateTotalWithDiscount());
    ever(vat, (_) => _calculateTotalWithDiscount());
    ever(discountAmount, (_) => _calculateTotalWithDiscount());

    _calculateTotalWithDiscount(); // Initial calculation
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
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

  // CartScreen থেকে পাঠানো আর্গুমেন্ট থেকে অর্ডারের তথ্য লোড করে
  void _loadOrderSummary() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      subTotal.value = (args['subTotal'] as num?)?.toDouble() ?? 0.0;
      shippingFee.value = (args['shippingFee'] as num?)?.toDouble() ?? 0.0;
      vat.value = (args['vat'] as num?)?.toDouble() ?? 0.0;
      // Total will be calculated based on subTotal, shippingFee, vat and discountAmount
    }
  }

  // CartScreen থেকে পাঠানো আর্গুমেন্ট থেকে কার্ট আইটেম লোড করে
  void _loadCartItems() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      final List<dynamic>? items = args['cartItems'];
      if (items != null) {
        cartItems.value = items.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    }
  }

  // AddressScreen-এ নেভিগেট করে এবং ফলাফল হ্যান্ডেল করে
  void changeAddress() async {
    final result = await Get.to(() => const AddressScreen());
    if (result != null && result is Map<String, dynamic>) {
      selectedAddress.value = result;
    }
  }

  // Recalculates total amount based on sub-total, fees, and discount
  void _calculateTotalWithDiscount() {
    double currentTotal = (subTotal.value + shippingFee.value + vat.value) - discountAmount.value;
    if (currentTotal < 0) {
      currentTotal = 0.0; // Ensure total doesn't go negative
    }
    total.value = currentTotal;
  }

  // Updated method to apply promo code, now fetching from PromoCodeController (Supabase)
  Future<void> applyPromoCode() async {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      promoCodeError.value = 'Please enter a promo code.';
      discountAmount.value = 0.0; // Reset discount if field is empty
      appliedPromoCodeId.value = '';
      _calculateTotalWithDiscount();
      return;
    }

    promoCodeError.value = ''; // Clear previous errors

    try {
      await promoCodeControllerInstance.fetchPromoCodes(); // Ensure latest codes are fetched
      final promoCodes = promoCodeControllerInstance.promoCodes;

      final appliedCode = promoCodes.firstWhereOrNull(
            (pc) => pc['code'] == code && (pc['expiration_date'] == null || DateTime.parse(pc['expiration_date']).isAfter(DateTime.now())),
      );

      if (appliedCode != null) {
        final String discountType = appliedCode['discount_type'];
        final double discountValue = (appliedCode['discount_value'] as num).toDouble();

        double baseForDiscount = subTotal.value + shippingFee.value + vat.value;
        double calculatedDiscount = 0.0;

        if (discountType == 'percentage') {
          calculatedDiscount = baseForDiscount * (discountValue / 100); // Assuming value is 10 for 10%
        } else if (discountType == 'fixed') {
          calculatedDiscount = discountValue;
        } else {
          // Handle unknown discount type if necessary
          Get.snackbar('Error', 'Unknown discount type for this promo code.', snackPosition: SnackPosition.BOTTOM);
          discountAmount.value = 0.0;
          appliedPromoCodeId.value = '';
          _calculateTotalWithDiscount();
          return;
        }

        // Apply discount, ensuring it doesn't make total negative
        discountAmount.value = calculatedDiscount;
        appliedPromoCodeId.value = appliedCode['id']; // Store actual ID from DB
        Get.snackbar('Success', 'Promo code "$code" applied successfully!', snackPosition: SnackPosition.BOTTOM);
      } else {
        promoCodeError.value = 'Invalid or expired promo code.';
        discountAmount.value = 0.0;
        appliedPromoCodeId.value = '';
        Get.snackbar('Error', promoCodeError.value, snackPosition: SnackPosition.BOTTOM);
      }
      _calculateTotalWithDiscount(); // Recalculate total after applying discount

    } on PostgrestException catch (e) {
      promoCodeError.value = 'Error fetching promo code: ${e.message}';
      discountAmount.value = 0.0;
      appliedPromoCodeId.value = '';
      Get.snackbar('Error', promoCodeError.value, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      promoCodeError.value = 'Error applying promo code: ${e.toString()}';
      discountAmount.value = 0.0;
      appliedPromoCodeId.value = '';
      Get.snackbar('Error', promoCodeError.value, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
