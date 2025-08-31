import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/review_controller.dart';


class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ReviewController controller = Get.put(ReviewController());

    final Map<String, dynamic> product = Get.arguments as Map<String, dynamic>;
    final String productName = product['name'] as String? ?? 'Product Reviews';
    final String productId = product['id'] as String? ?? '';

    if (controller.reviews.isEmpty && !controller.isLoadingReviews.value && productId.isNotEmpty) {
      controller.fetchReviewsForProduct(productId);
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Reviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar("Notification", "Notifications will arrive soon!", snackPosition: SnackPosition.TOP);
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoadingReviews.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reviewErrorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.reviewErrorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            ),
          );
        }

        if (controller.reviews.isEmpty) {
          return const Center(
            child: Text("No reviews found for this product!"),
          );
        }

        // মোট রেটিং গণনা
        double totalRatingSum = 0;
        int fiveStarCount = 0;
        int fourStarCount = 0;
        int threeStarCount = 0;
        int twoStarCount = 0;
        int oneStarCount = 0;

        for (var review in controller.reviews) {
          final int rating = review['rating'] as int? ?? 0;
          totalRatingSum += rating;
          if (rating == 5) fiveStarCount++;
          if (rating == 4) fourStarCount++;
          if (rating == 3) threeStarCount++;
          if (rating == 2) twoStarCount++;
          if (rating == 1) oneStarCount++;
        }

        final double averageRating = controller.reviews.isEmpty ? 0.0 : totalRatingSum / controller.reviews.length;
        final int totalRatings = controller.reviews.length;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Rating Section (Image এর মতো)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    averageRating.toStringAsFixed(1), // 4.0
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStarRating(averageRating), // স্টার রেটিং
                      Text(
                        '$totalRatings Ratings',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Rating Distribution Bars (Image এর মতো)
              _buildRatingBar(5, fiveStarCount, totalRatings),
              _buildRatingBar(4, fourStarCount, totalRatings),
              _buildRatingBar(3, threeStarCount, totalRatings),
              _buildRatingBar(2, twoStarCount, totalRatings),
              _buildRatingBar(1, oneStarCount, totalRatings),
              SizedBox(height: 30.h),

              // Individual Reviews Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.reviews.length} Reviews',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: 'Most Relevant', // আপাতত ডিফল্ট, আপনি এটি কন্ট্রোলারে ম্যানেজ করতে পারেন
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    underline: Container(height: 0),
                    onChanged: (String? newValue) {
                      // এখানে সর্টিং লজিক যোগ করুন (যদি ProductDetailsController এ থাকে)
                      Get.snackbar("Sorting", "Sorting options will be available soon!", snackPosition: SnackPosition.BOTTOM);
                    },
                    items: <String>['Most Relevant', 'Newest', 'Highest Rating', 'Lowest Rating']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // List of Reviews
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Nested scroll issue এড়ানোর জন্য
                itemCount: controller.reviews.length,
                itemBuilder: (context, index) {
                  final review = controller.reviews[index];
                  return _buildReviewCard(review);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  // স্টার রেটিং উইজেট (যেমন 4.5 স্টার)
  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < rating.floor()) {
        stars.add(Icon(Icons.star, color: Colors.amber, size: 20.sp));
      } else if (i < rating) {
        stars.add(Icon(Icons.star_half, color: Colors.amber, size: 20.sp));
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.grey.shade400, size: 20.sp));
      }
    }
    return Row(children: stars);
  }

  // রেটিং বারের জন্য উইজেট (যেমন 5-স্টার, 4-স্টার ইত্যাদি)
  Widget _buildRatingBar(int star, int count, int total) {
    final double percentage = total == 0 ? 0 : count / total;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text('$star', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(width: 8.w),
          Icon(Icons.star, color: Colors.grey.shade600, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade300,
                color: Colors.amber,
                minHeight: 8.h,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text('$count', style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // প্রতিটি রিভিউ কার্ডের জন্য উইজেট
  Widget _buildReviewCard(Map<String, dynamic> review) {
    final int rating = review['rating'] as int? ?? 0;
    final String userName = review['user_name'] as String? ?? 'Anonymous';
    final String reviewText = review['review_text'] as String? ?? 'No review text provided.';
    final DateTime? createdAt = (review['created_at'] != null)
        ? DateTime.parse(review['created_at']).toLocal()
        : null;

    String timeAgo = '';
    if (createdAt != null) {
      final Duration diff = DateTime.now().difference(createdAt);
      if (diff.inDays > 7) {
        timeAgo = '${(diff.inDays / 7).floor()} weeks ago';
      } else if (diff.inDays > 0) {
        timeAgo = '${diff.inDays} days ago';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours} hours ago';
      } else if (diff.inMinutes > 0) {
        timeAgo = '${diff.inMinutes} minutes ago';
      } else {
        timeAgo = 'just now';
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStarRating(rating.toDouble()), // প্রতিটি রিভিউ এর জন্য স্টার
          SizedBox(height: 8.h),
          Text(
            reviewText,
            style: TextStyle(fontSize: 15.sp, color: Colors.black87, height: 1.4),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(width: 5.w),
              Icon(Icons.circle, size: 5.w, color: Colors.grey),
              SizedBox(width: 5.w),
              Text(
                timeAgo,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}