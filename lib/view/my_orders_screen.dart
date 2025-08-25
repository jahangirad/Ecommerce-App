import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widget/empty_state_widget.dart';
import '../widget/order_item_card.dart';
import '../widget/review_bottom_sheet.dart';


class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool _isOngoingSelected = true;

  // ডামি ডেটা
  final List<Map<String, dynamic>> _ongoingOrders = [
    {'id': 'o1', 'name': 'Regular Fit Slogan', 'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979850_640.jpg', 'price': 1190, 'size': 'M', 'status': 'In Transit'},
    {'id': 'o2', 'name': 'Regular Fit Polo', 'imageUrl': 'https://cdn.pixabay.com/photo/2017/12/30/22/07/jeans-3051102_640.jpg', 'price': 1100, 'size': 'L', 'status': 'Picked'},
    {'id': 'o3', 'name': 'Regular Fit Black', 'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979848_640.jpg', 'price': 1690, 'size': 'L', 'status': 'In Transit'},
    {'id': 'o4', 'name': 'Regular Fit V-Neck', 'imageUrl': 'https://cdn.pixabay.com/photo/2020/10/11/05/36/nike-5644799_640.jpg', 'price': 1290, 'size': 'S', 'status': 'Packing'},
  ];

  final List<Map<String, dynamic>> _completedOrders = [
    {'id': 'c1', 'name': 'Regular Fit Slogan', 'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979850_640.jpg', 'price': 1190, 'size': 'M', 'status': 'Completed', 'isReviewed': false},
    {'id': 'c2', 'name': 'Regular Fit Polo', 'imageUrl': 'https://cdn.pixabay.com/photo/2017/12/30/22/07/jeans-3051102_640.jpg', 'price': 1100, 'size': 'L', 'status': 'Completed', 'isReviewed': true, 'rating': 4.5},
  ];

  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const ReviewBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _isOngoingSelected ? _ongoingOrders : _completedOrders;

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
            child: currentList.isEmpty
                ? const EmptyStateWidget(
              icon: Icons.local_mall_outlined,
              title: 'No Ongoing Orders!',
              subtitle: 'You don\'t have any ongoing orders\nat this time.',
            )
                : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: currentList.length,
              itemBuilder: (context, index) {
                return OrderItemCard(
                  order: currentList[index],
                  isOngoing: _isOngoingSelected,
                  onActionPressed: () {
                    if (!_isOngoingSelected && currentList[index]['isReviewed'] == false) {
                      _showReviewBottomSheet();
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
            ),
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