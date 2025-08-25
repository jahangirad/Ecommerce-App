import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/help_center_item.dart';



class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});


  final List<Map<String, dynamic>> helpItems = const [
    {
      'icon': Icons.chat_bubble_outline, // WhatsApp আইকনের বিকল্প
      'title': 'Whatsapp',
    },
    {
      'icon': Icons.language_outlined,
      'title': 'Website',
    },
    {
      'icon': Icons.facebook_outlined,
      'title': 'Facebook',
    },
    {
      'icon': Icons.alternate_email_sharp, // Twitter আইকনের বিকল্প
      'title': 'Twitter',
    },
    {
      'icon': Icons.camera_alt_outlined, // Instagram আইকনের বিকল্প
      'title': 'Instagram',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ), // কাস্টম AppBar
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        itemCount: helpItems.length,
        itemBuilder: (context, index) {
          final item = helpItems[index];
          return HelpCenterItem(
            icon: item['icon'],
            title: item['title'],
            onTap: () {
              // এখানে প্রতিটি আইটেমে ট্যাপ করার কার্যকারিতা যোগ করতে পারেন
              print('${item['title']} tapped!');
            },
          );
        },
        // দুটি আইটেমের মধ্যে স্পেস দেওয়ার জন্য
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      ),
    );
  }
}