import 'package:cashify/firebase_options.dart';
import 'package:cashify/pages/login_page/login_view.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/translation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Translation(),
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'cashify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: false,
      ),
      home: const LoginView(),
    );
  }
}
