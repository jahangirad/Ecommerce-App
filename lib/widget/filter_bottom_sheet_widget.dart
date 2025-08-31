import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';


class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController()); // Use Get.find to ensure the same instance

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
            ],
          ),
          const Divider(),
          SizedBox(height: 16.h),
          Text('Sort By', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 10.h),
          Obx(() => Wrap(
            spacing: 10.w,
            children: controller.sortOptions.map((label) {
              final isSelected = controller.sortBy.value == label;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) controller.updateSortBy(label);
                },
                backgroundColor: Colors.grey.shade200,
                selectedColor: Colors.black,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
              );
            }).toList(),
          )),
          SizedBox(height: 24.h),
          Text('Price', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          Obx(() => RangeSlider(
            values: controller.priceRange.value,
            min: 0,
            max: controller.maxPrice,
            divisions: (controller.maxPrice / 10).round(), // Adjust divisions for smoother steps
            activeColor: Colors.black,
            inactiveColor: Colors.grey.shade300,
            labels: RangeLabels(
              '\$${controller.priceRange.value.start.round()}',
              '\$${controller.priceRange.value.end.round()}',
            ),
            onChanged: (RangeValues values) {
              // Directly update the range in the controller. No need for a local state
              controller.updatePriceRange(values);
            },
          )),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: controller.applyFiltersFromSheet, // Call the method to apply and close
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            ),
          ),
        ],
      ),
    );
  }
}