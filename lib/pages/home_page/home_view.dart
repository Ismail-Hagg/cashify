import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: () => controller.signOut(),
            child: CustomText(
                text: 'Home View ${controller.userModel.email} ${'test'.tr}')),
      ),
    );
  }
}
