import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'account_screen.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'saved_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // PageController শুরু করা হচ্ছে
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    // মেমোরি লিক এড়ানোর জন্য PageController dispose করা হচ্ছে
    _pageController.dispose();
    super.dispose();
  }

  // ন্যাভিগেশন বারে ট্যাপ করলে এই ফাংশনটি কল হবে
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // PageView-তে অ্যানিমেশনসহ পেইজ পরিবর্তন হবে
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // পেইজগুলোর তালিকা
  final List<Widget> _pages = [
    const HomeScreen(),
    const SavedScreen(),
    const CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // কোনো AppBar নেই
      body: PageView(
        controller: _pageController,
        children: _pages,
        // যখন ব্যবহারকারী সোয়াইপ করে পেইজ পরিবর্তন করবে
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cartShopping),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}