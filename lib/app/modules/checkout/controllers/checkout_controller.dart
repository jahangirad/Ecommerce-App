import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  final box = GetStorage();
  // CartController অবশ্যই CheckoutController এর আগে বাইন্ড করতে হবে
  final CartController cartController = Get.find();

  final Rx<Map<String, dynamic>> selectedAddress = Rx<Map<String, dynamic>>({});
  final Rx<Map<String, dynamic>> selectedCard = Rx<Map<String, dynamic>>({});
  final RxString selectedPaymentType = 'Card'.obs;

  double get subTotal => cartController.subTotal;
  double get vat => cartController.vat;
  double get shippingFee => cartController.shippingFee;
  double get total => cartController.total;

  @override
  void onInit() {
    super.onInit();
    loadSelectedData();
  }

  void loadSelectedData() {
    Map<String, dynamic>? address = box.read<Map<String, dynamic>>('selected_address');
    if (address != null) {
      selectedAddress.value = address;
    }
    Map<String, dynamic>? card = box.read<Map<String, dynamic>>('selected_card');
    if (card != null) {
      selectedCard.value = card;
    }
  }

  void changePaymentType(String type) {
    selectedPaymentType.value = type;
  }

  Future<void> goToChangeAddress() async {
    await Get.toNamed(Routes.ADDRESS);
    loadSelectedData();
  }

  Future<void> goToChangePaymentMethod() async {
    await Get.toNamed(Routes.PAYMENT_METHOD);
    loadSelectedData();
  }

  void placeOrder() {
    // এখানে অর্ডার প্লেস করার লজিক যোগ হবে
    Get.snackbar('Success', 'Order placed successfully!');
  }
}
