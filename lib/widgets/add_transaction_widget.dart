import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatelessWidget {
  final double width;
  const AddTransaction({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: Get.find<HomeController>(),
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonWidget(
                  isIos: controller.isIos,
                  textSize: 16,
                  type: ButtonType.text,
                  onClick: () {},
                  text: DateFormat.yMd().format(
                    controller.transactionChosenTime,
                  ),
                ),
                Row(
                  children: [
                    IconButtonPlatform(
                      isIos: controller.isIos,
                      icon: FontAwesomeIcons.camera,
                      color: mainColor,
                      click: () {},
                    ),
                    SizedBox(
                      width: width * 0.025,
                    ),
                    IconButtonPlatform(
                      isIos: controller.isIos,
                      icon: FontAwesomeIcons.commentSms,
                      color: mainColor,
                      click: () {},
                    ),
                  ],
                ),
                Row()
              ],
            )
          ],
        ),
      ),
    );
  }
}
