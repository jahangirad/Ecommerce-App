import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntent;
  final isProcessing = false.obs;

  // ✅ পেমেন্ট প্রসেস ফাংশন (dynamic amount ব্যবহার করে)
  Future<bool> makePayment({required String amount, String currency = "USD"}) async {
    try {
      paymentIntent = await createPaymentIntent(amount, currency);
      if (paymentIntent == null) {
        log("❌ PaymentIntent creation failed.");
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: true, // Use customFlow if you want to control the confirmation
          merchantDisplayName: 'Body By Doctor',
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            currencyCode: 'USD',
            testEnv: true, // Set to false for production
          ),
        ),
      );

      final result = await displayPaymentSheet();
      return result;
    } on StripeException catch (e) {
      log("❌ Stripe Error in makePayment: ${e.error.message ?? 'Unknown Stripe error'}");
      return false;
    } catch (e) {
      log("❌ General Error in makePayment: ${e.toString()}");
      return false;
    }
  }

  // ✅ Stripe PaymentIntent তৈরি করা (amount ও currency dynamic)
  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      // Convert amount from string to double, then to cents (integer)
      final int amountInCents = (double.parse(amount) * 100).toInt();

      Map<String, dynamic> body = {
        'currency': currency,
        'amount': amountInCents.toString(), // Stripe expects amount in cents as a string
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['stripe_secret_key']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log("❌ Failed to create PaymentIntent. Status: ${response.statusCode}, Body: ${response.body}");
        return null;
      }
    } catch (e) {
      log("❌ Error creating payment intent: ${e.toString()}");
      return null;
    }
  }

  // ✅ পেমেন্ট শিট দেখানো এবং পেমেন্ট কনফার্ম করা
  Future<bool> displayPaymentSheet() async {
    try {
      // 1. Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      await Stripe.instance.confirmPaymentSheetPayment();


      // Optional: Fetch updated payment intent details after confirmation
      if (paymentIntent != null && paymentIntent!['id'] != null) {
        var paymentIntentData = await fetchPaymentIntentDetails(paymentIntent!['id']);
        if (paymentIntentData.isNotEmpty) {
          log("✅ Transaction ID: ${paymentIntentData['id']}");
          log("💰 Amount Received: ${(paymentIntentData['amount_received'] / 100).toStringAsFixed(2)} USD");
          paymentIntent = paymentIntentData; // Update with latest status
        }
      }

      return true; // Payment was successful
    } on StripeException catch (e) {
      if (e.error.code == 'Canceled') {
        log("❌ Payment Canceled by User: ${e.error.message}");
      } else {
        log("❌ Stripe Error displaying/confirming payment sheet: ${e.error.message ?? 'Unknown Stripe error'}");
      }
      return false; // Payment failed or was canceled
    } catch (e) {
      log("❌ General Error displaying/confirming payment sheet: ${e.toString()}");
      return false; // Payment failed
    }
  }

  // ✅ পেমেন্টIntent বিস্তারিত আনা
  Future<Map<String, dynamic>> fetchPaymentIntentDetails(String paymentIntentId) async {
    try {
      var response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['stripe_secret_key']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log("❌ Failed to fetch PaymentIntent details. Status: ${response.statusCode}, Body: ${response.body}");
        return {};
      }
    } catch (e) {
      log("❌ Error fetching payment intent details: ${e.toString()}");
      return {};
    }
  }
}