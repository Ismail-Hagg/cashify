import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/firebase_options.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/gloable_controllers/controller_view.dart';
import 'package:cashify/local_storage/local_storage.dart';
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
  await LocalStorage().hiveInit();
  final UserDataModel userModel = await LocalStorage().getUserData();
  Get.put(GloableAuthController(userModel));
  runApp(
    MyApp(
      language: userModel.language,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String language;
  const MyApp({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Translation(),
      locale: Locale(language.substring(0, 2), language.substring(3, 5)),
      debugShowCheckedModeBanner: false,
      title: 'cashify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: false,
      ),
      home: const GloableViewController(),
    );
  }
}
