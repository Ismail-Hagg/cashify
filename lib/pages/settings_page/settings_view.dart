import 'package:cashify/pages/settings_page/settings_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GetBuilder<SettingsController>(
        init: Get.find<SettingsController>(),
        builder: (controller) => Center(
          child: GestureDetector(
              onTap: () => controller.logout(),
              child: CustomText(
                  text: 'Settings Page ${controller.userModel.email}')),
        ),
      ),
    );
  }
}
