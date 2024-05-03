import 'package:cashify/pages/add_transaction_page/add_transaction_controller.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class AddCategory extends StatelessWidget {
  final bool isNew;
  final double width;
  const AddCategory({super.key, required this.isNew, required this.width});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTransactionController>(
      init: Get.find<AddTransactionController>(),
      builder: (controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InputWidget(
              height: width * 0.15,
              width: width,
              active: controller.catNameActive,
              controller: controller.catAddController,
              node: controller.catAddNode,
              hint: 'category'.tr,
              action: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InputWidget(
              height: width * 0.15,
              width: width,
              active: controller.subCatActive,
              controller: controller.subCatAddController,
              node: controller.subCatNode,
              hint: 'subcat'.tr,
              maxLines: 1,
              onSub: (str) => controller.subCategorySubmit(
                sub: str,
                isNew: isNew,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                isNew
                    ? controller.subcats.length
                    : controller.catagory!.subCatagories.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Chip(
                    onDeleted: () => controller.subDelete(
                      index: index,
                      isNew: isNew,
                    ),
                    label: CustomText(
                      text: isNew
                          ? controller.subcats[index]
                          : controller.catagory!.subCatagories[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ButtonWidget(
                  isIos: controller.isIos,
                  textSize: 16,
                  type: ButtonType.text,
                  onClick: () =>
                      controller.pickIcon(context: context, isNew: isNew),
                  text: '${'icon'.tr} : ',
                ),
                isNew
                    ? controller.catIcon != null
                        ? Icon(controller.catIcon, size: 30)
                        : Container()
                    : Icon(
                        controller.catagory!.icon,
                        size: 30,
                      )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ButtonWidget(
                  isIos: controller.isIos,
                  textSize: 16,
                  type: ButtonType.text,
                  onClick: () => controller.pickColor(
                    widget: AlertDialog(
                      title: Text('catcolor'.tr),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: Colors.red,
                          onColorChanged: (col) =>
                              controller.changeColor(color: col, isNew: isNew),
                        ),
                      ),
                      actions: <Widget>[
                        ButtonWidget(
                          type: ButtonType.text,
                          textSize: 12,
                          isIos: controller.isIos,
                          text: 'ok'.tr,
                          onClick: () => controller.closeColorPicker(),
                        ),
                      ],
                    ),
                  ),
                  text: '${'color'.tr} : ',
                ),
                Container(
                  height: width * 0.1,
                  width: width * 0.1,
                  decoration: BoxDecoration(
                    color: isNew
                        ? controller.catColor
                        : controller.catagory!.color,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
