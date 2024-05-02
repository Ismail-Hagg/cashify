import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AddCategory extends StatelessWidget {
  final double width;
  const AddCategory({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: Get.find<HomeController>(),
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InputWidget(
                enable: true,
                hint: 'catname'.tr,
                //autoFocus: true,
                height: width * 0.135,
                width: width,
                active: true,
                controller: controller.catAddController,
                node: controller.catAddNode,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: InputWidget(
            //     onSub: (thing) {
            //       print(thing);
            //     },
            //     hint: 'subcat'.tr,
            //     //autoFocus: true,
            //     height: width * 0.135,
            //     width: width,
            //     active: controller.subCatActive,
            //     controller: controller.subCatAddController,
            //     // node: controller.subCatNode,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
