import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/reviews_controller.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Reviews', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }
        return _buildReviewsContent();
      }),
    );
  }

  Widget _buildReviewsContent() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      children: [
        _buildRatingSummary(),
        SizedBox(height: 25.h),
        const Divider(),
        SizedBox(height: 15.h),
        _buildReviewsHeader(),
        SizedBox(height: 15.h),
        _buildReviewsList(),
      ],
    );
  }

  Widget _buildRatingSummary() {
    final summary = controller.ratingSummary.value;
    final double averageRating = summary['average'] ?? 0.0;
    final int totalCount = summary['totalCount'] ?? 0;
    final List<double> breakdown = List<double>.from(summary['breakdown'] ?? [0,0,0,0,0]);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(averageRating.toStringAsFixed(1), style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold)),
            _buildStarRating(averageRating),
            SizedBox(height: 4.h),
            Text('$totalCount Ratings', style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
          ],
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              int star = 5 - index;
              return _buildRatingBreakdownBar(star, breakdown[index]);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBreakdownBar(int star, double percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16.sp),
          SizedBox(width: 4.w),
          Text('$star', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                color: Colors.black,
                minHeight: 8.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${controller.reviewsList.length} Reviews',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        DropdownButtonHideUnderline(
          child: Obx(() => DropdownButton<String>(
            value: controller.selectedFilter.value,
            icon: Icon(Icons.keyboard_arrow_down, size: 20.sp),
            items: controller.filterOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
              );
            }).toList(),
            onChanged: controller.changeFilter,
          )),
        ),
      ],
    );
  }

  Widget _buildReviewsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.reviewsList.length,
      itemBuilder: (context, index) {
        final review = controller.reviewsList[index];
        return _buildReviewItem(review);
      },
      separatorBuilder: (context, index) => Divider(height: 30.h, color: Colors.grey[200]),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStarRating(review['rating'] as double),
        SizedBox(height: 8.h),
        Text(
          review['comment'] as String,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Text(
              review['name'] as String,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Icon(Icons.circle, size: 4.sp, color: Colors.grey[400]),
            ),
            Text(
              review['timeAgo'] as String,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStarRating(double rating, {double size = 18}) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: size.sp,
      ignoreGestures: true,
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) {},
    );
  }
}