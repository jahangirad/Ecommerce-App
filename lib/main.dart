import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controller/deeplink_controller.dart';
import 'core/routes/app_page.dart';
import 'core/routes/app_route.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['supabase_url']!,
    anonKey: dotenv.env['supabase_key']!,
  );
  Stripe.publishableKey = dotenv.env['stripe_publishable_key']!;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DeepLinkController().deepLink();
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
          initialRoute: AppRoute.splashscreen,
          getPages: AppPage.routes,
        );
      },
    );
  }
}
