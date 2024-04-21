import 'package:cashify/firebase_options.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/gloable_controllers/controller_view.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/login_page/login_view.dart';
import 'package:cashify/services/user_data_service.dart';
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
  await UserData().getUserData().then(
    (user) {
      runApp(
        MyApp(
          model: user,
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final UserModel model;
  const MyApp({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    GloableAuthController controller = Get.put(GloableAuthController(model));
    return GetMaterialApp(
      translations: Translation(),
      locale: Locale(controller.userModel.language.substring(0, 2),
          controller.userModel.language.substring(3, 5)),
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
