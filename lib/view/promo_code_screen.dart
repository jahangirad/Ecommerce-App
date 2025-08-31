import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/promo_code_controller.dart';

class PromoCodeScreen extends StatelessWidget {
  const PromoCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PromoCodeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Promo Codes',
          style: TextStyle(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 24.w),
            onPressed: controller.fetchPromoCodes,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${controller.error.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: controller.fetchPromoCodes,
                    child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.promoCodes.isEmpty) {
          return Center(
            child: Text(
              'No promo codes available.',
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(10.w),
          itemCount: controller.promoCodes.length,
          itemBuilder: (context, index) {
            final promo = controller.promoCodes[index];
            final code = promo['code'] ?? 'N/A';
            final discountType = promo['discount_type'] ?? 'N/A';
            final discountValue = promo['discount_value'] ?? 0;
            final maxUsers = promo['max_users'] ?? 0;
            final usedCount = promo['used_count'] ?? 0;

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Code: $code',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, size: 22.w),
                          color: Colors.grey[600],
                          onPressed: () => controller.copyToClipboard(code),
                          tooltip: 'Copy Code',
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text('Discount Type: $discountType', style: TextStyle(fontSize: 14.sp)),
                    SizedBox(height: 4.h),
                    Text('Discount Value: $discountValue', style: TextStyle(fontSize: 14.sp)),
                    SizedBox(height: 4.h),
                    Text('Max Users: $maxUsers', style: TextStyle(fontSize: 14.sp)),
                    SizedBox(height: 4.h),
                    Text('Used Count: $usedCount', style: TextStyle(fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: maxUsers > 0 ? usedCount / maxUsers : 0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        usedCount / maxUsers > 0.8 ? Colors.red : Colors.green,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${(maxUsers > 0 ? (usedCount / maxUsers * 100) : 0).toStringAsFixed(0)}% Used',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
