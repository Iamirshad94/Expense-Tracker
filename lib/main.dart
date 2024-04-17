// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msa_app/config/getx_bindings_config.dart';
import 'config/app_theme.dart';
import 'domain/notification_services.dart';
import 'presentation/main_page.dart'; // Import your theme class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService.showPeriodicNotification(
      title: 'Did you forgot to add Expenses',
      body:
          'Keep an eye on your daily expenses just by adding expenses in our app',
      payload: 'Payload');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme,
      initialBinding: AppBindings(),
      // Apply your theme
      home: const MainPage(), // Replace with your app's home page
    );
  }
}
