import 'dart:convert';
import 'dart:math';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/animeted_icon_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/expense_tile_widget.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:mrx_charts/mrx_charts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:string_2_icon/string_2_icon.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GetBuilder<HomeController>(
        init: Get.find<HomeController>(),
        builder: (controller) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 14,
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 0.88,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                controller.userModel.wallets.length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 12),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  mainColor.withOpacity(0.5)),
                                          color: Colors.grey.shade300,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText(
                                            text:
                                                '${controller.userModel.wallets[index].name} : ${controller.walletAmount(amount: controller.userModel.wallets[index].amount)}  ${controller.userModel.wallets[index].currency}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.12,
                          height: width * 0.12,
                          child: Center(
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.plus,
                              color: mainColor,
                              click: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            offset: const Offset(0, 0),
                            blurRadius: 5,
                          )
                        ],
                        color: forgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  color: mainColor,
                                  size: 14,
                                  text: controller.chosenTime,
                                ),
                                PopupMenuButton<String>(
                                  splashRadius: 10,
                                  icon: FaIcon(
                                    FontAwesomeIcons.ellipsisVertical,
                                    color: mainColor,
                                  ),
                                  onSelected: (val) =>
                                      controller.changeTimePeriod(time: val),
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      'thismnth'.tr,
                                      'lastmnth'.tr,
                                      'thisyear'.tr,
                                      'custom'.tr
                                    ].map(
                                      (String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                color: mainColor,
                                                text: choice,
                                                size: 14,
                                              ),
                                              if (controller.track[choice] ==
                                                  controller.trackNum) ...[
                                                FaIcon(
                                                  FontAwesomeIcons.check,
                                                  size: 18,
                                                  color: mainColor,
                                                )
                                              ]
                                            ],
                                          ),
                                        );
                                      },
                                    ).toList();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: width * 0.45,
                              width: width * 0.45,
                              child: controller.loading
                                  ? IconAnimated(
                                      name: Icons8.circles_menu_1_iOS,
                                      controller: controller.loadingController,
                                      color: mainColor)
                                  : Stack(
                                      children: [
                                        Chart(
                                          layers: [
                                            ChartGroupPieLayer(
                                              items: [
                                                List.generate(
                                                  1,
                                                  (index) =>
                                                      ChartGroupPieDataItem(
                                                          amount: Random()
                                                                  .nextInt(
                                                                      300) *
                                                              Random()
                                                                  .nextDouble(),
                                                          color: Colors.red,
                                                          label: [
                                                            'Life',
                                                            'Work',
                                                            'Medicine',
                                                            'Bills',
                                                            'Hobby',
                                                            'Holiday',
                                                          ][Random()
                                                              .nextInt(6)]),
                                                ),
                                              ],
                                              settings:
                                                  const ChartGroupPieSettings(),
                                            ),
                                          ],
                                        ),
                                        Center(
                                          child: ButtonWidget(
                                            isIos: controller.isIos,
                                            textSize: 16,
                                            type: ButtonType.text,
                                            onClick: () {
                                              print(
                                                  controller.humanFormat(3540));
                                            },
                                            text:
                                                controller.humanFormat(300.76),
                                          ),
                                        )
                                      ],
                                    )),
                        ],
                      ),
                    ),
                  ),
                  // Column(
                  //   children: List.generate(
                  //     controller.loading
                  //         ? 10
                  //         : controller.userModel.catagories.length,
                  //     (index) => Skeletonizer(
                  //       enabled: controller.loading,
                  //       child: ExpenceTile(
                  //         loading: controller.loading,
                  //         budgetPercent: 0.5,
                  //         width: width,
                  //         color: Colors.green,
                  //         title: 'food',
                  //         subtitle: '3 transactions',
                  //         amount: '1500',
                  //         ave: '${'ave'.tr} 10',
                  //         budget: true,
                  //         icon: FontAwesomeIcons.drumstickBite,
                  //         padding: const EdgeInsets.only(
                  //           right: 12,
                  //           left: 12,
                  //           bottom: 16,
                  //         ),
                  //         budgetKeeping: '50/100',
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
