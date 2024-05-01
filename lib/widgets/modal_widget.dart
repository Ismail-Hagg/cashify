import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage modalPage(
    {required BuildContext context,
    required String title,
    required Widget child,
    required Widget icon,
    required Function() leadingButtonFunction,
    required Widget button}) {
  double width = MediaQuery.of(context).size.width;
  return WoltModalSheetPage(
    forceMaxHeight: true,
    stickyActionBar: button,
    leadingNavBarWidget: GestureDetector(
      onTap: leadingButtonFunction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: width * 0.07,
          width: width * 0.07,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            ),
          ),
        ),
      ),
    ),
    isTopBarLayerAlwaysVisible: true,
    hasTopBarLayer: true,
    topBarTitle: CustomText(
      text: title,
    ),
    child: child,
  );
}
