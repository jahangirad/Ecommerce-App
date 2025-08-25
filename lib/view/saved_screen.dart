import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/product_card_widget.dart';
import '../widget/empty_state_widget.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final List<Map<String, dynamic>> _allProducts = [
    // ... আপনার ডেটা এখানে থাকবে ...
    {
      'id': '1', 'name': 'Regular Fit Slogan', 'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979850_640.jpg', 'price': 1590.0, 'isFavorite': true,
    },
    {
      'id': '2', 'name': 'Stylish Blue Jeans', 'imageUrl': 'https://cdn.pixabay.com/photo/2017/12/30/22/07/jeans-3051102_640.jpg', 'price': 1100.0, 'isFavorite': true,
    },
    {
      'id': '3', 'name': 'Regular Fit Black', 'imageUrl': 'https://cdn.pixabay.com/photo/2023/05/08/21/59/woman-7979848_640.jpg', 'price': 1690.0, 'isFavorite': true,
    },
    {
      'id': '4', 'name': 'Classic Running Shoes', 'imageUrl': 'https://cdn.pixabay.com/photo/2020/10/11/05/36/nike-5644799_640.jpg', 'price': 3290.0, 'isFavorite': true, // একটি আইটেমকে false করে খালি অবস্থা পরীক্ষা করতে পারেন
    },
  ];

  void _toggleFavorite(String productId) {
    setState(() {
      final productIndex = _allProducts.indexWhere((p) => p['id'] == productId);
      if (productIndex != -1) {
        _allProducts[productIndex]['isFavorite'] = !_allProducts[productIndex]['isFavorite'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> savedItems = _allProducts.where((product) => product['isFavorite'] == true).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Saved Items',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: savedItems.isEmpty
          ? const EmptyStateWidget(  // *** এখানে নতুন উইজেটটি ব্যবহার করা হয়েছে ***
        icon: Icons.favorite_border,
        title: 'No Saved Items!',
        subtitle: 'You don\'t have any saved items.\nGo to home and add some.',
      )
          : _buildSavedItemsGrid(savedItems),
    );
  }

  // _buildEmptyState মেথডটি এখন আর এখানে নেই

  Widget _buildSavedItemsGrid(List<Map<String, dynamic>> savedItems) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.7,
      ),
      itemCount: savedItems.length,
      itemBuilder: (context, index) {
        final product = savedItems[index];
        return ProductCard(
          product: product,
          onFavoriteToggle: () => _toggleFavorite(product['id']),
        );
      },
    );
  }
}