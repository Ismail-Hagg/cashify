import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final bool ios;
  final Widget? content;
  final Function() action;
  final bool? kill;
  const DialogWidget(
      {super.key,
      required this.title,
      this.content,
      required this.ios,
      required this.action,
      this.kill});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(
        text: title,
      ),
      content: content,
      actions: kill == true
          ? null
          : [
              ButtonWidget(
                isIos: ios,
                textSize: 12,
                type: ButtonType.text,
                onClick: () => Get.back(),
                text: 'cancel'.tr,
              ),
              ButtonWidget(
                isIos: ios,
                textSize: 12,
                type: ButtonType.text,
                onClick: action,
                text: 'ok'.tr,
              ),
            ],
    );
  }
}
