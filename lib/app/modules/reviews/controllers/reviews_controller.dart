import 'dart:math';

import 'package:get/get.dart';

class ReviewsController extends GetxController {
  final RxBool isLoading = true.obs;

  final Rx<Map<String, dynamic>> ratingSummary = Rx<Map<String, dynamic>>({});

  // এই লিস্টটিতে মূল ডেটা থাকবে, যা পরিবর্তন হবে না
  final RxList<Map<String, dynamic>> _originalReviewsList = <Map<String, dynamic>>[].obs;
  // এই লিস্টটি UI-তে দেখানো হবে এবং সর্টিংয়ের পর আপডেট হবে
  final RxList<Map<String, dynamic>> reviewsList = <Map<String, dynamic>>[].obs;

  final RxString selectedFilter = 'Most Relevant'.obs;
  final List<String> filterOptions = ['Most Relevant', 'Most Recent', 'Highest Rating', 'Lowest Rating'];

  @override
  void onInit() {
    super.onInit();
    fetchProductReviews();
  }

  Future<void> fetchProductReviews() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      ratingSummary.value = {
        'average': 4.0,
        'totalCount': 1034,
        'breakdown': [0.75, 0.55, 0.30, 0.15, 0.05],
      };

      // ডেমো ডেটায় timestamp যোগ করা হলো, যা সর্টিংয়ের জন্য প্রয়োজন
      _originalReviewsList.assignAll([
        {
          'name': 'Wade Warren',
          'timestamp': DateTime.now().subtract(const Duration(days: 6)),
          'timeAgo': '6 days ago',
          'rating': 5.0,
          'comment': 'The item is very good, my son likes it very much and plays every day.',
        },
        {
          'name': 'Guy Hawkins',
          'timestamp': DateTime.now().subtract(const Duration(days: 7)),
          'timeAgo': '1 week ago',
          'rating': 4.0,
          'comment': 'The seller is very fast in sending packet, I just bought it and the item arrived in just 1 day!',
        },
        {
          'name': 'Robert Fox',
          'timestamp': DateTime.now().subtract(const Duration(days: 14)),
          'timeAgo': '2 weeks ago',
          'rating': 4.0,
          'comment': 'I just bought it and the stuff is really good! I highly recommend it!',
        },
        {
          'name': 'Jane Cooper',
          'timestamp': DateTime.now().subtract(const Duration(days: 21)),
          'timeAgo': '3 weeks ago',
          'rating': 3.0,
          'comment': 'It\'s okay for the price, but could be better quality.',
        },
      ]);

      // প্রাথমিকভাবে UI লিস্টটি মূল লিস্টের একটি কপি হিসেবে থাকবে
      reviewsList.assignAll(_originalReviewsList);
      // প্রাথমিকভাবে "Most Relevant" অনুযায়ী সর্ট করুন (যদি কোনো বিশেষ লজিক থাকে)
      _sortReviews();

    } finally {
      isLoading.value = false;
    }
  }

  // ফিল্টার পরিবর্তনের মেথড (আপডেটেড)
  void changeFilter(String? newValue) {
    if (newValue != null && selectedFilter.value != newValue) {
      selectedFilter.value = newValue;
      // নতুন ফিল্টার অনুযায়ী লিস্ট সর্ট করুন
      _sortReviews();
    }
  }

  // রিভিউ সর্ট করার মূল লজিক
  void _sortReviews() {
    // সর্টিংয়ের আগে UI লিস্টটিকে মূল লিস্ট দিয়ে রিসেট করুন
    List<Map<String, dynamic>> tempList = List.from(_originalReviewsList);

    switch (selectedFilter.value) {
      case 'Most Recent':
      // নতুন রিভিউগুলো আগে আসবে (descending order)
        tempList.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
        break;
      case 'Highest Rating':
      // বেশি রেটিংয়ের রিভিউগুলো আগে আসবে
        tempList.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'Lowest Rating':
      // কম রেটিংয়ের রিভিউগুলো আগে আসবে
        tempList.sort((a, b) => (a['rating'] as double).compareTo(b['rating'] as double));
        break;
      case 'Most Relevant':
      // ডিফল্ট বা "Most Relevant" এর জন্য আপনি কোনো বিশেষ লজিক যোগ করতে পারেন
      // যেমন: কমেন্টের দৈর্ঘ্য বা লাইকের সংখ্যার উপর ভিত্তি করে (এখানে শুধু এলোমেলো করা হলো)
        tempList.shuffle(Random());
        break;
    }
    // সর্ট করা লিস্টটি UI-তে দেখানোর জন্য আপডেট করুন
    reviewsList.assignAll(tempList);
  }
}
