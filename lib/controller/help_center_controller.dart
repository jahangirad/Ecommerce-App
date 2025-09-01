import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterController extends GetxController {
  void launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch $url',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void handleItemTap(String title) {
    String url = '';
    switch (title) {
      case 'Whatsapp':
        url = 'https://wa.me/+8801796196500';
        break;
      case 'Website':
        url = 'https://app--appnixor-it-ltd-official-website-c-c7bc6889.base44.app/';
        break;
      case 'Facebook':
        url = 'https://web.facebook.com/AppnixorITLtd';
        break;
      case 'Twitter':
        url = 'https://twitter.com/';
        break;
      case 'Instagram':
        url = 'https://www.instagram.com/';
        break;
      default:
        return;
    }
    launchURL(url);
  }
}