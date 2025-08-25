import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/routes/app_page.dart';
import 'core/routes/app_route.dart';



void main() async{
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Ecommerce App',
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fade,
          transitionDuration: Duration(milliseconds: 300),
          initialRoute: AppRoute.dashboardscreen,
          getPages: AppPage.routes,
        );
      },
    );
  }
}
