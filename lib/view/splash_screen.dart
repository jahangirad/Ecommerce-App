import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // Background Wavy Lines
          Positioned.fill(
            child: CustomPaint(
              painter: WavyLinesPainter(),
            ),
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                // Custom Logo
                CustomPaint(
                  size: Size(100.w, 100.w), // .w ব্যবহার করে রেসপন্সিভ প্রস্থ
                  painter: PlusLogoPainter(),
                ),
                const Spacer(flex: 2),
                // Loading Indicator
                SizedBox(
                  width: 35.w,
                  height: 35.w,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3.0,
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Painter for background wavy lines
class WavyLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // responsive path তৈরি করতে ScreenUtil ব্যবহার
    final path1 = Path()
      ..moveTo(size.width * -0.1, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.1, size.width * 1.1, size.height * 0.25);
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(size.width * -0.1, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.15, size.width * 1.1, size.height * 0.3);
    canvas.drawPath(path2, paint);

    final path3 = Path()
      ..moveTo(size.width * -0.1, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width * 1.1, size.height * 0.35);
    canvas.drawPath(path3, paint);

    final path4 = Path()
      ..moveTo(size.width * -0.1, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.25, size.width * 1.1, size.height * 0.4);
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Painter for the custom plus logo
class PlusLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    // .r ব্যবহার করে রেসপন্সিভ রেডিয়াস
    final cornerRadius = 20.r;
    final inset = 10.r;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..arcToPoint(Offset(size.width / 2 + inset, inset), radius: Radius.circular(inset), clockwise: false)
      ..lineTo(size.width - cornerRadius, inset)
      ..arcToPoint(Offset(size.width, cornerRadius), radius: Radius.circular(cornerRadius))
      ..lineTo(size.width, size.height / 2 - inset)
      ..arcToPoint(Offset(size.width - inset, size.height / 2), radius: Radius.circular(inset), clockwise: false)
      ..lineTo(size.width / 2 + cornerRadius, size.height / 2)
      ..arcToPoint(Offset(size.width / 2, size.height / 2 + cornerRadius), radius: Radius.circular(cornerRadius))
      ..lineTo(size.width / 2, size.height - inset)
      ..arcToPoint(Offset(size.width / 2 - inset, size.height), radius: Radius.circular(inset), clockwise: false)
      ..lineTo(size.width / 2 - cornerRadius, size.height)
      ..arcToPoint(Offset(0, size.height / 2 + cornerRadius), radius: Radius.circular(cornerRadius))
      ..lineTo(0, size.height / 2 + inset)
      ..arcToPoint(Offset(inset, size.height / 2), radius: Radius.circular(inset), clockwise: false)
      ..lineTo(size.width / 2 - cornerRadius, size.height / 2)
      ..arcToPoint(Offset(size.width / 2, size.height / 2 - cornerRadius), radius: Radius.circular(cornerRadius))
      ..lineTo(size.width / 2, inset)
      ..arcToPoint(Offset(size.width / 2, 0), radius: Radius.circular(inset), clockwise: false) // custom shape a bit tricky
      ..close();


    // A simpler path for the logo shape as seen in the image.
    final simplePath = Path();
    double armWidth = size.width * 0.4;
    double corner = size.width * 0.25;

    simplePath.moveTo(size.width/2 - armWidth/2, 0);
    simplePath.lineTo(size.width/2 + armWidth/2, 0);
    simplePath.arcToPoint(Offset(size.width, size.height/2 - armWidth/2), radius: Radius.circular(corner), clockwise: false);
    simplePath.lineTo(size.width, size.height/2 + armWidth/2);
    simplePath.arcToPoint(Offset(size.width/2 + armWidth/2, size.height), radius: Radius.circular(corner), clockwise: false);
    simplePath.lineTo(size.width/2 - armWidth/2, size.height);
    simplePath.arcToPoint(Offset(0, size.height/2 + armWidth/2), radius: Radius.circular(corner), clockwise: false);
    simplePath.lineTo(0, size.height/2 - armWidth/2);
    simplePath.arcToPoint(Offset(size.width/2 - armWidth/2, 0), radius: Radius.circular(corner), clockwise: false);
    simplePath.close();

    canvas.drawPath(simplePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
