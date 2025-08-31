// No significant changes needed for TrackOrderScreen itself
// as it already accepts a Map<String, dynamic> orderDetails.
// Ensure your _mapSupabaseOrderToAppOrder in OrderController provides
// all the data TrackOrderScreen expects, such as 'delivery_address'.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TrackOrderScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  const TrackOrderScreen({super.key, required this.orderDetails});

  String? _getLottieAnimationPath(String status) {
    switch (status) {
      case 'packing': // Use lowercase status from Supabase
        return 'assets/animation/packing.json';
      case 'picked': // Use lowercase status from Supabase
        return 'assets/animation/picked.json';
      case 'in transit': // Use lowercase status from Supabase
        return 'assets/animation/transit.json';
      case 'delivered': // Use lowercase status from Supabase
        return 'assets/animation/delivered.json';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the status from the orderDetails is converted to lowercase
    String currentStatus = (orderDetails['status'] as String? ?? 'packing').toLowerCase();
    String? lottiePath = _getLottieAnimationPath(currentStatus);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Track Order',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined, size: 26.sp),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (lottiePath != null)
            Container(
              height: 200.h,
              color: Colors.grey.shade100,
              child: Center(
                child: Lottie.asset(
                  lottiePath,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Status',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 24.w),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildStatusStepper(currentStatus),
                  SizedBox(height: 20.h),
                  _buildDeliveryPersonCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStepper(String currentStatus) {
    List<Map<String, dynamic>> statuses = [
      {
        'status': 'packing',
        'address': '2336 Jack Warren Rd, Delta Junction, Alaska 9...',
        'isCompleted': false
      },
      {
        'status': 'picked',
        'address': '2417 Tongass Ave #111, Ketchikan, Alaska 99901...',
        'isCompleted': false
      },
      {
        'status': 'in transit',
        'address': '16 Rr 2, Ketchikan, Alaska 99901, USA',
        'isCompleted': false
      },
      {
        'status': 'delivered',
        'address': '925 S Chugach St #APT 10, Alaska 99645',
        'isCompleted': false
      },
    ];

    int currentStatusIndex =
    statuses.indexWhere((element) => element['status'] == currentStatus);

    for (int i = 0; i <= currentStatusIndex; i++) {
      statuses[i]['isCompleted'] = true;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: statuses.map((statusData) {
          bool isCompleted = statusData['isCompleted'];
          bool isCurrent = statusData['status'] == currentStatus;
          return IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 18.w,
                      height: 18.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? Colors.blue.shade600 : Colors.grey,
                        border: Border.all(
                            color: isCompleted
                                ? Colors.blue.shade600
                                : Colors.grey,
                            width: 2.w),
                      ),
                      child: isCompleted
                          ? Icon(Icons.check, color: Colors.white, size: 12.w)
                          : Container(),
                    ),
                    if (statusData != statuses.last)
                      Expanded(
                        child: Container(
                          width: 2.w,
                          color: isCompleted ? Colors.blue.shade600 : Colors.grey,
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusData['status'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent ? Colors.black : Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // You might want to use orderDetails['delivery_address'] here if available
                        Text(
                          statusData['address'], // This is hardcoded for now, consider using orderDetails['delivery_address']
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeliveryPersonCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: const NetworkImage(
                'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_640.jpg'),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jacob Jones',
                  style:
                  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Delivery Guy',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.call, color: Colors.blue.shade600, size: 24.w),
          ),
        ],
      ),
    );
  }
}