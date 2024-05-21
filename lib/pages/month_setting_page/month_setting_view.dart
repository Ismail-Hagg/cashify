import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/expense_tile_widget.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MonthSettingView extends StatelessWidget {
  const MonthSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MonthSettingController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return GetBuilder<MonthSettingController>(
            init: Get.find<MonthSettingController>(),
            builder: (controller) => SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: width * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtonWidget(
                          isIos: controller.isIos,
                          textSize: 16,
                          type: ButtonType.text,
                          onClick: () =>
                              controller.changeMonth(context: context),
                          text:
                              '${controller.date.year}/${controller.date.month} - ${DateFormat.LLL().format(controller.date)}',
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownMenu(
                          inputDecorationTheme: InputDecorationTheme(
                            isDense: false,
                            constraints: BoxConstraints.tight(
                                Size.fromHeight(width * 0.13)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width: width * 0.35,
                          menuHeight: width,
                          onSelected: (val) {},
                          hintText: 'wallet'.tr,
                          controller: controller.catController,
                          dropdownMenuEntries: List.generate(
                            controller.userModel.wallets.length,
                            (index) => DropdownMenuEntry(
                              label: controller.userModel.wallets[index].name,
                              value: controller.userModel.wallets[index].name,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: InputWidget(
                                height: width * 0.13,
                                width: width * 0.25,
                                active: controller.startActive,
                                controller: controller.startController,
                                node: controller.startNode,
                                hint: 'start'.tr,
                                maxLines: 1,
                                formatter: [
                                  // Allow Decimal Number With Precision of 2 Only
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                type: const TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: InputWidget(
                                height: width * 0.13,
                                width: width * 0.25,
                                active: controller.endActive,
                                controller: controller.endController,
                                node: controller.endNode,
                                hint: 'end'.tr,
                                maxLines: 1,
                                type: const TextInputType.numberWithOptions(
                                    decimal: true),
                                formatter: [
                                  // Allow Decimal Number With Precision of 2 Only
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'budget'.tr,
                          size: 16,
                        ),
                        IconButtonPlatform(
                          isIos: controller.isIos,
                          icon: FontAwesomeIcons.plus,
                          color: mainColor,
                          click: () => controller.addOrUpdateMonthSetting(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(
                            controller.loading
                                ? 10
                                : controller.model != null
                                    ? controller.model!.budgetCat.length
                                    : 0,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Skeletonizer(
                                enabled: controller.loading,
                                child: ExpenceTile(
                                  width: width,
                                  color: controller.loading
                                      ? Colors.transparent
                                      : controller.model != null
                                          ? controller
                                              .model!.catagory[index].color
                                          : Colors.transparent,
                                  title: controller.loading
                                      ? 'a;lkdf;kladjfl;a;dkljfaldjf;'
                                      : controller.model != null
                                          ? controller.model!.budgetCat[index]
                                          : '',
                                  subtitle: '',
                                  amount: controller.loading
                                      ? 'djf;'
                                      : controller.model != null
                                          ? controller.model!.budgetVal[index]
                                              .toString()
                                          : '',
                                  budget: false,
                                  icon: controller.loading
                                      ? FontAwesomeIcons.a
                                      : controller.model != null
                                          ? controller
                                              .model!.catagory[index].icon
                                          : FontAwesomeIcons.a,
                                  padding: const EdgeInsets.all(0),
                                  loading: controller.loading,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
