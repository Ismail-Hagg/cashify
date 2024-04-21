import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/home_page/home_view.dart';
import 'package:cashify/pages/login_page/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GloableViewController extends StatelessWidget {
  const GloableViewController({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GloableAuthController>(
      init: Get.find<GloableAuthController>(),
      builder: (controller) =>
          controller.user == null ? const LoginView() : const HomeView(),
    );
  }
}
