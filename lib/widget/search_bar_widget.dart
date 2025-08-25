import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onFilterTap;
  final TextEditingController searchController;

  const SearchBarWidget({
    super.key,
    required this.onFilterTap,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for clothes...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  ),
                ),
                const Icon(Icons.mic, color: Colors.grey),
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 50.h,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ),
      ],
    );
  }
}