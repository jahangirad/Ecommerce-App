import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HelpCenterController extends GetxController {
  final List<Map<String, dynamic>> helpOptions = [
    {
      'title': 'Whatsapp',
      'icon': FontAwesomeIcons.whatsapp,
      'onTap': () {},
    },
    {
      'title': 'Website',
      'icon': FontAwesomeIcons.globe,
      'onTap': () {},
    },
    {
      'title': 'Facebook',
      'icon': FontAwesomeIcons.facebook,
      'onTap': () {},
    },
    {
      'title': 'Twitter',
      'icon': FontAwesomeIcons.twitter,
      'onTap': () {},
    },
    {
      'title': 'Instagram',
      'icon': FontAwesomeIcons.instagram,
      'onTap': () {},
    },
  ];
}
