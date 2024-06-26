import 'package:cashify/pages/settings_page/settings_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        return SizedBox(
          width: width,
          child: GetBuilder<SettingsController>(
            init: Get.find<SettingsController>(),
            builder: (controller) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonWidget(
                    isIos: controller.isIos,
                    textSize: 16,
                    type: ButtonType.raised,
                    onClick: () => controller.logout(),
                    text: 'machine'),
                Center(
                    child: CustomText(
                  text: controller.newMod == null
                      ? 'the thing is null'
                      : controller.newMod!.toMap().toString(),
                ))
                // Column(
                //   children: List.generate(
                //       controller.lst!.length,
                //       (index) => CustomText(
                //           text: controller.lst![index].value.toString())),
                // )
              ],
            ),
          ),
        );
      }),
    );
  }
}
