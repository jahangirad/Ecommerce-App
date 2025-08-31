import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';
import '../controller/review_controller.dart';
import '../widget/empty_state_widget.dart';
import '../widget/order_item_card.dart';
import '../widget/review_bottom_sheet.dart';
import 'track_order_screen.dart';


class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrderController orderController = Get.put(OrderController());
  final ReviewController reviewController = Get.put(ReviewController());
  bool _isOngoingSelected = true;

  // এই মেথডটি এখন শুধুমাত্র productId গ্রহণ করবে
  void _showReviewBottomSheet(String productId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ReviewBottomSheet(
          onReviewSubmitted: (rating, reviewText) async {
            await reviewController.submitProductReview(
              productId: productId,
              rating: rating,
              reviewText: reviewText,
            );
            Get.back(); // Close bottom sheet after submission
            // After submitting review, refresh orders to update the UI
            orderController.fetchOrders(); // This will trigger a rebuild and re-check review status
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isOngoingSelected ? Colors.white : Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp)),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none_outlined, size: 26.sp))],
        backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildToggleBar(),
          Expanded(
            child: Obx(() {
              if (orderController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (orderController.errorMessage.isNotEmpty) {
                return Center(child: Text('Error: ${orderController.errorMessage.value}'));
              }

              final currentList = _isOngoingSelected
                  ? orderController.ongoingOrders
                  : orderController.completedOrders;

              if (currentList.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.local_mall_outlined,
                  title: _isOngoingSelected ? 'No Ongoing Orders!' : 'No Completed Orders!',
                  subtitle: _isOngoingSelected
                      ? 'You don\'t have any ongoing orders\nat this time.'
                      : 'You haven\'t completed any orders yet.',
                );
              } else {
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    final order = currentList[index];

                    // Get the productId for the first item in the order
                    String? productId;
                    if (order['order_items_details'] != null && (order['order_items_details'] as List).isNotEmpty) {
                      productId = order['order_items_details'][0]['id'];
                    }

                    if (!_isOngoingSelected && productId != null) {
                      // For completed orders, we need to check review status for the product
                      return FutureBuilder<bool>(
                        future: reviewController.hasUserReviewedProduct(productId),
                        builder: (context, snapshot) {
                          bool hasReviewed = snapshot.data ?? false; // Default to false while loading

                          return OrderItemCard(
                            order: order,
                            isOngoing: _isOngoingSelected,
                            hasProductReview: hasReviewed, // Pass the review status
                            onActionPressed: () {
                              if (hasReviewed) {
                                // TODO: Implement navigation to view review details
                                Get.snackbar("Info", "Viewing review details for product ID: $productId (Not implemented yet).", snackPosition: SnackPosition.BOTTOM);
                              } else {
                                _showReviewBottomSheet(productId!);
                              }
                            },
                          );
                        },
                      );
                    } else {
                      // For ongoing orders or if productId is null for completed (shouldn't happen with proper data)
                      return OrderItemCard(
                        order: order,
                        isOngoing: _isOngoingSelected,
                        hasProductReview: false, // Not applicable or not checked for ongoing
                        onActionPressed: () {
                          if (!_isOngoingSelected) { // This block handles completed if productId was null
                            if (productId == null) {
                              Get.snackbar("Error", "Product ID not found for review.", snackPosition: SnackPosition.BOTTOM);
                            }
                          } else { // Ongoing orders logic
                            Get.to(() => TrackOrderScreen(orderDetails: order));
                          }
                        },
                      );
                    }
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.all(4.sp),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildToggleButton('Ongoing', _isOngoingSelected),
          _buildToggleButton('Completed', !_isOngoingSelected),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isOngoingSelected = text == 'Ongoing';
          });
          orderController.fetchOrders(); // Refresh orders when toggling
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}