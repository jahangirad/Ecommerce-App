import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controller/cart_controller.dart';
import '../controller/checkout_controller.dart';
import '../controller/payment_controller.dart';
import '../core/routes/app_route.dart';
import '../widget/button_widget.dart';
import '../widget/dialog_status.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  // Initialize controllers
  late final CheckoutController checkoutController;
  late final PaymentController paymentController;

  @override
  void initState() {
    super.initState();
    // Use Get.find() if already registered, or Get.put() if first time
    checkoutController = Get.put(CheckoutController());
    paymentController = Get.put(PaymentController());
  }

  @override
  Widget build(BuildContext context) {
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
            _buildSectionHeader('Delivery Address', onChange: checkoutController.changeAddress),
            SizedBox(height: 16.h),
            Obx(() {
              if (checkoutController.selectedAddress.value.isEmpty) {
                return const Text('No address selected. Please add one.');
              }
              return _buildAddressInfo(
                title: checkoutController.selectedAddress.value['nickname'] ?? 'Home',
                address: checkoutController.selectedAddress.value['fullAddress'] ?? 'No address details available',
              );
            }),
            const Divider(height: 32),

            // Payment Method Section
            _buildSectionHeader('Payment Method'),
            SizedBox(height: 16.h),
            _buildPaymentMethodToggle(),
            SizedBox(height: 16.h),
            const Divider(height: 32),

            // Order Summary Section
            _buildSectionHeader('Order Summary'),
            SizedBox(height: 16.h),
            Obx(() => _buildOrderSummary(checkoutController)),
            const Divider(height: 32),

            // Promo Code Section
            _buildPromoCodeField(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Obx(
              () => PrimaryButton(
            text: paymentController.isProcessing.value ? 'Processing...' : 'Place Order',
            onPressed: paymentController.isProcessing.value ? null : () => _placeOrder(checkoutController, paymentController),
          ),
        ),
      ),
    );
  }

  // Helper Widgets (unchanged from previous response)
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
    return Obx(() => Row(
      children: [
        _buildPaymentOption(
          icon: Icons.credit_card,
          label: 'Card',
          isSelected: checkoutController.selectedPaymentMethod.value == 0,
          onTap: () => checkoutController.selectedPaymentMethod.value = 0,
        ),
        SizedBox(width: 12.w),
        _buildPaymentOption(
          icon: Icons.money,
          label: 'Cash',
          isSelected: checkoutController.selectedPaymentMethod.value == 1,
          onTap: () => checkoutController.selectedPaymentMethod.value = 1,
        ),
      ],
    ));
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

  Widget _buildOrderSummary(CheckoutController controller) {
    return Column(
      children: [
        _buildSummaryRow('Sub-total', '\$${controller.subTotal.value.toStringAsFixed(2)}'),
        SizedBox(height: 12.h),
        _buildSummaryRow('VAT (%)', '\$${controller.vat.value.toStringAsFixed(2)}'),
        SizedBox(height: 12.h),
        _buildSummaryRow('Shipping fee', '\$${controller.shippingFee.value.toStringAsFixed(2)}'),
        Obx(() {
          if (controller.discountAmount.value > 0) {
            return Column(
              children: [
                SizedBox(height: 12.h),
                _buildSummaryRow('Discount', '-\$${controller.discountAmount.value.toStringAsFixed(2)}'),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
        const Divider(height: 30, thickness: 1),
        _buildSummaryRow('Total', '\$${controller.total.value.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600)),
        Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: isTotal ? Colors.black : null)),
      ],
    );
  }

  Widget _buildPromoCodeField() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: checkoutController.promoCodeController,
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
              onPressed: () => checkoutController.applyPromoCode(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: Size(80.w, 55.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
        Obx(() {
          if (checkoutController.promoCodeError.value.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  checkoutController.promoCodeError.value,
                  style: TextStyle(color: Colors.red, fontSize: 13.sp),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // MARK: - Order Placement Logic

  Future<void> _placeOrder(CheckoutController checkoutController, PaymentController paymentController) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      _showErrorDialog('Authentication Required', 'Please log in to place an order.');
      return;
    }

    // Validate if an address is selected
    if (checkoutController.selectedAddress.value.isEmpty) {
      _showErrorDialog('Address Missing', 'Please select a delivery address to proceed.');
      return;
    }

    // Validate if cart is empty
    if (checkoutController.cartItems.isEmpty) {
      _showErrorDialog('Empty Cart', 'Your cart is empty. Please add items before placing an order.');
      return;
    }

    // Ensure paymentMethod is correctly set to 'card' or 'cash' string
    String paymentMethod = checkoutController.selectedPaymentMethod.value == 0 ? 'card' : 'cash';

    // !!! CORRECTED: Use 'packing' as the initial status for both scenarios !!!
    String orderStatus = 'packing';

    paymentController.isProcessing.value = true; // Start processing indicator

    try {
      if (paymentMethod == 'card') { // Use lowercase 'card' to match the string
        // --- Card Payment Flow (Stripe PaymentSheet) ---
        // Call Stripe payment process
        final bool paymentSuccess = await paymentController.makePayment(
          amount: checkoutController.total.value.toStringAsFixed(2), // Pass total amount to PaymentController
        );

        if (!paymentSuccess) {
          // If Stripe payment fails or is canceled
          _showErrorDialog("Payment Failed", "Your card payment could not be processed. Please try again or choose another payment method.");
          return; // Stop the order process here
        }
        // If payment is successful, orderStatus remains 'packing' (as set above)
      }
      // If paymentMethod is 'cash', orderStatus remains 'packing' (as set above)


      // --- Add Order to Supabase (for both cash and successful card payments) ---
      await _addOrderToSupabase(
        checkoutController,
        user.id,
        paymentMethod,
        orderStatus, // Use the determined orderStatus
      );

      _showSuccessDialog("Order Placed!", "Your order has been placed successfully. You can track its status now.");
      // Optionally clear the cart after successful order placement
      Get.put(CartController()).cartItems.clear();


    } on PostgrestException catch (e) {
      _showErrorDialog("Order Failed", "Supabase error: ${e.message}");
    } catch (e) {
      _showErrorDialog("Order Failed", "There was an unexpected error placing your order: ${e.toString()}");
    } finally {
      paymentController.isProcessing.value = false; // Stop processing indicator
    }
  }


  Future<void> _addOrderToSupabase(
      CheckoutController checkoutController,
      String userId,
      String paymentMethod,
      String status,
      {String? promoCodeId,
        double discountAmount = 0.0}) async {
    try {
      // Supabase will automatically generate the 'id' for the 'orders' table
      final List<Map<String, dynamic>> response = await supabase
          .from('orders')
          .insert({
        'user_id': userId,
        'total_amount': checkoutController.total.value,
        'payment_method': paymentMethod,
        'status': status,
        'delivery_address': checkoutController.selectedAddress.value['fullAddress'] ?? '',
        'discount_amount': checkoutController.discountAmount.value, // Use actual discount
        'promo_code_id': checkoutController.appliedPromoCodeId.value.isEmpty ? null : checkoutController.appliedPromoCodeId.value, // Pass promo ID
      })
          .select('id'); // Select the ID that Supabase just generated

      if (response.isEmpty || response.first['id'] == null) {
        throw Exception('Failed to get order ID from Supabase after insertion.');
      }
      final String orderId = response.first['id'] as String;

      // Add order items if cartItems are available
      if (checkoutController.cartItems.isNotEmpty) {
        final List<Map<String, dynamic>> orderItemsToInsert = checkoutController.cartItems.map((item) {
          return {
            'order_id': orderId,
            'product_id': item['product_id'], // <-- Corrected key: item['product_id']
            'quantity': item['quantity'],
            'price': (item['price'] as num?)?.toDouble() ?? 0.0,
            'size': item['size'], // Optional, handle null if not always present
          };
        }).toList();

        await supabase.from('order_items').insert(orderItemsToInsert);
      } else {
        print('Warning: No items in cart to add to order_items for order ID: $orderId.');
        // This case should ideally be caught earlier by the cart empty validation
      }

    } on PostgrestException catch (e) {
      print('Supabase PostgrestException adding order: ${e.message}');
      rethrow; // Re-throw to be caught by the outer try-catch
    } catch (e) {
      print('Error adding order to Supabase: $e');
      rethrow; // Re-throw to be caught by the outer try-catch
    }
  }

  void _showSuccessDialog(String title, String message) {
    Get.dialog(
      StatusDialog(
        title: title,
        message: message,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        buttonText: 'Track Now',
        onButtonPressed: () {
          Get.back(); // Close dialog
          Get.toNamed(AppRoute.myorderscreen); // Navigate to order tracking screen
        },
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(
      StatusDialog(
        title: title,
        message: message,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        buttonText: 'Try Again',
        onButtonPressed: () {
          Get.back(); // Close dialog
          // Optionally allow re-attempt or go back to checkout
        },
      ),
    );
  }
}