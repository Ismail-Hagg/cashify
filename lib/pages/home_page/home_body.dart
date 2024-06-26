import 'dart:math';

import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/countries.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/avatar_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/new_expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return GetBuilder<HomeController>(
            init: Get.find<HomeController>(),
            builder: (controller) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: height * 0.38,
                        color: mainColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: width,
                              child: ShapeOfView(
                                elevation: 0,
                                height: (height * 0.35) * 0.38,
                                width: width,
                                shape: RoundRectShape(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          child: Container(
                            width: width * 0.95,
                            height: height * 0.23,
                            decoration: BoxDecoration(
                              color: oilColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 5,
                                  offset: const Offset(1, 1),
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 80,
                                  left: -50,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 15,
                                          spreadRadius: 8,
                                          color: mainColor.withOpacity(0.2),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -40,
                                  right: -40,
                                  child: Container(
                                    height: 160,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 15,
                                            spreadRadius: 8,
                                            color: mainColor.withOpacity(0.2),
                                          )
                                        ]),
                                  ),
                                ),
                                Positioned(
                                  bottom: -50,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 15,
                                            spreadRadius: 8,
                                            color: whiteColor.withOpacity(0.2),
                                          )
                                        ]),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.95,
                                      height: controller.loading == false &&
                                              controller
                                                  .monthSettingMap[
                                                      controller.currentTime]!
                                                  .walletInfo
                                                  .isEmpty &&
                                              controller
                                                  .userModel.wallets.isEmpty
                                          ? width * 0.15
                                          : null,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: List.generate(
                                              controller.loading
                                                  ? 10
                                                  : controller
                                                          .monthSettingMap[
                                                              controller
                                                                  .currentTime]!
                                                          .walletInfo
                                                          .isNotEmpty
                                                      ? controller
                                                          .monthSettingMap[
                                                              controller
                                                                  .currentTime]!
                                                          .walletInfo
                                                          .length
                                                      : controller.userModel
                                                          .wallets.length,
                                              (index) {
                                                String amount = controller
                                                        .loading
                                                    ? ''
                                                    : zerosConvert(
                                                        val: controller
                                                                .monthSettingMap[
                                                                    controller
                                                                        .currentTime]!
                                                                .walletInfo
                                                                .isNotEmpty
                                                            ? (controller
                                                                    .monthSettingMap[
                                                                        controller
                                                                            .currentTime]!
                                                                    .walletInfo[
                                                                        index]
                                                                    .start +
                                                                controller
                                                                    .monthSettingMap[
                                                                        controller
                                                                            .currentTime]!
                                                                    .walletInfo[
                                                                        index]
                                                                    .opSum)
                                                            : controller
                                                                .userModel
                                                                .wallets[index]
                                                                .amount);
                                                return Skeletonizer(
                                                  enabled: controller.loading,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 12),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: mainColor,
                                                            width: 0.5),
                                                        color: whiteColor
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 10),
                                                        child: CustomText(
                                                          text: controller
                                                                  .loading
                                                              ? 'loading data'
                                                              : controller
                                                                      .monthSettingMap[
                                                                          controller
                                                                              .currentTime]!
                                                                      .walletInfo
                                                                      .isNotEmpty
                                                                  ? '${controller.monthSettingMap[controller.currentTime]!.walletInfo[index].wallet} $amount ${controller.monthSettingMap[controller.currentTime]!.walletInfo[index].currency}'
                                                                  : '${controller.userModel.wallets[index].name} $amount ${controller.userModel.wallets[index].currency}',
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: 'balance'.tr,
                                                  color: whiteColor
                                                      .withOpacity(0.8),
                                                  size: 14,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: DropdownButton(
                                                    menuMaxHeight: height * 0.8,
                                                    value: controller.loading
                                                        ? 'SAR'
                                                        : controller
                                                            .transactionCurrency,
                                                    items: List.generate(
                                                      codes.length,
                                                      (index) {
                                                        String name = countries[
                                                                    codes[
                                                                        index]]![
                                                                'name']
                                                            .toString();
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: codes[index],
                                                          child: CustomText(
                                                            text: name,
                                                            color: mainColor,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    underline: Container(),
                                                    icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .chevronDown,
                                                      color: mainColor,
                                                      size: 14,
                                                    ),
                                                    onChanged: (thing) =>
                                                        controller
                                                            .changeCurrancy(
                                                                currency:
                                                                    thing ??
                                                                        ''),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Skeletonizer(
                                            enabled: controller.loading,
                                            child: Row(
                                              children: [
                                                CustomText(
                                                  text:
                                                      '234,233,234 ${countries[codes[codes.indexWhere((element) => element == controller.transactionCurrency)]]!['symbolNative']}',
                                                  maxline: 1,
                                                  color: whiteColor,
                                                  size: 24,
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Avatar(
                                borderColor: oilColor,
                                type: controller.userModel.localImage
                                    ? controller.imageExists(
                                        link: controller.userModel.localPath,
                                      )
                                        ? AvatarType.local
                                        : AvatarType.none
                                    : controller.userModel.onlinePath == ''
                                        ? AvatarType.none
                                        : AvatarType.online,
                                height: width * 0.135,
                                width: width * 0.135,
                                link: controller.userModel.localImage
                                    ? controller.userModel.localPath
                                    : controller.userModel.onlinePath,
                                border: true,
                                shadow: false,
                              ),
                              SizedBox(
                                height: width * 0.12,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomText(
                                        text: 'welcome'.tr,
                                        color: whiteColor.withOpacity(0.7),
                                      ),
                                      CustomText(
                                        text: controller.userModel.username,
                                        color: whiteColor,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 26,
                        right: 16,
                        left: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: 'Analytics',
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                              DropdownButton<String>(
                                selectedItemBuilder: (context) {
                                  Times time = controller.chosenTimeType;
                                  String display = time == Times.thisMonth ||
                                          time == Times.lastMonth
                                      ? '${controller.chosenTimePeriod.start.year}/${controller.chosenTimePeriod.start.month}'
                                      : '${controller.chosenTimePeriod.start.year}/${controller.chosenTimePeriod.start.month}/${controller.chosenTimePeriod.start.day} - ${controller.chosenTimePeriod.end.year}/${controller.chosenTimePeriod.end.month}/${controller.chosenTimePeriod.end.day}';
                                  return List.generate(
                                    controller.timesToChose.length,
                                    (index) => Container(
                                      decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 0),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              text: display,
                                              color: mainColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: FaIcon(
                                                FontAwesomeIcons.chevronDown,
                                                color: mainColor,
                                                size: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                isExpanded: false,
                                value: controller.chosenTime,
                                items: List.generate(
                                  controller.timesToChose.length,
                                  (index) => DropdownMenuItem<String>(
                                    value: controller.timesToChose[index],
                                    child: CustomText(
                                      text: controller.timesToChose[index],
                                      color: mainColor,
                                    ),
                                  ),
                                ),
                                underline: Container(),
                                icon: Container(),
                                onChanged: (thing) => controller.timeChange(
                                  time: thing,
                                  context: context,
                                  times: controller.timesList[
                                      controller.timesToChose.indexOf(
                                    thing.toString(),
                                  )],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: width,
                                  height: width * 0.55,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: mainColor.withOpacity(0.08),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: LineChart(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        LineChartData(
                                          lineTouchData: LineTouchData(
                                            handleBuiltInTouches: true,
                                            touchTooltipData:
                                                LineTouchTooltipData(
                                              getTooltipColor: (touchedSpot) =>
                                                  mainColor.withOpacity(0.7),
                                            ),
                                          ),
                                          gridData:
                                              const FlGridData(show: false),
                                          titlesData: FlTitlesData(
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 32,
                                                interval: 5,
                                                getTitlesWidget: (double value,
                                                    TitleMeta meta) {
                                                  const style = TextStyle(
                                                    fontSize: 12,
                                                  );
                                                  String text =
                                                      value.toStringAsFixed(0);
                                                  return Text(text,
                                                      style: style,
                                                      textAlign:
                                                          TextAlign.start);
                                                },
                                              ),
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                reservedSize: 32,
                                                getTitlesWidget: (double value,
                                                    TitleMeta meta) {
                                                  String text =
                                                      value.toStringAsFixed(0);

                                                  return CustomText(
                                                    text: text,
                                                    size: 12,
                                                  );
                                                },
                                                showTitles: true,
                                                interval: 10,
                                              ),
                                            ),
                                          ),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          lineBarsData: [
                                            LineChartBarData(
                                              isCurved: true,
                                              color:
                                                  mainColor.withOpacity(0.75),
                                              barWidth: 4,
                                              isStrokeCapRound: true,
                                              dotData:
                                                  const FlDotData(show: false),
                                              belowBarData:
                                                  BarAreaData(show: false),
                                              spots: const [
                                                FlSpot(-30, 10),
                                                FlSpot(-10, -10),
                                                FlSpot(5, 23),
                                                // FlSpot(7, 3.4),
                                                // FlSpot(10, 2),
                                                FlSpot(12, 45),
                                                FlSpot(13, -20),
                                              ],
                                            )
                                          ],
                                          minX: -30,
                                          maxX: 20,
                                          maxY: 50,
                                          minY: -20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: width,
                              height: width * 0.1,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    controller.userModel.catagories.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: index == 0
                                              ? mainColor
                                              : Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: CustomText(
                                            text: controller.userModel
                                                .catagories[index].name,
                                            color: index == 0
                                                ? whiteColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: List.generate(
                              controller.loading
                                  ? 10
                                  : controller.catList.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: GestureDetector(
                                  child: ExpenceTileNew(
                                      type: controller.loading
                                          ? ExpenseTile.loading
                                          : ExpenseTile.category,
                                      sign: '\$',
                                      ave: -6.9,
                                      count: controller.loading
                                          ? 0
                                          : controller.catList[index]
                                              .transactions!.length,
                                      budget: false,
                                      budgetNum: index * 22,
                                      width: width,
                                      title: controller.loading
                                          ? 'Loading...'
                                          : controller.catList[index].name,
                                      date: DateTime.now(),
                                      amount: controller.loading
                                          ? 0.0
                                          : controller.vals[controller
                                              .catList[index].name] as double,
                                      color: controller.loading
                                          ? Colors.transparent
                                          : colorConvert(
                                              code: controller
                                                  .catList[index].color),
                                      //  [
                                      //   Colors.red,
                                      //   Colors.green,
                                      //   Colors.blue,
                                      //   Colors.yellowAccent,
                                      //   Colors.pink,
                                      //   Colors.deepOrange,
                                      //   Colors.tealAccent
                                      // ][index],
                                      icon: controller.loading
                                          ? Icons.add
                                          : iconConvert(
                                              code: controller
                                                  .catList[index].icon)
                                      //  [
                                      //   FontAwesomeIcons.airbnb,
                                      //   FontAwesomeIcons.userTag,
                                      //   FontAwesomeIcons.algolia,
                                      //   FontAwesomeIcons.arrowRightLong,
                                      //   FontAwesomeIcons.audioDescription,
                                      //   FontAwesomeIcons.arrowRightArrowLeft,
                                      //   FontAwesomeIcons.broom
                                      // ][index],
                                      ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
