import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthSettingView extends StatelessWidget {
  const MonthSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    MonthSettingController controller = Get.put(MonthSettingController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: const Center(
        child: CustomText(text: 'Month Setting Page'),
      ),
    );
  }
}
