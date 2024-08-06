import 'package:cashify/data_models/export.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/countries.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/avatar_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/loading_widget.dart';
import 'package:cashify/widgets/new_expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

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
                                              controller.haveMonthSetting(
                                                  key:
                                                      controller.currentTime) &&
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
                                              controller.walletLoading
                                                  ? 10
                                                  : controller.haveMonthSetting(
                                                              key: controller
                                                                  .currentTime) &&
                                                          controller
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
                                                String amount = controller.walletLoading
                                                    ? ''
                                                    : zerosConvert(
                                                        val: controller.haveMonthSetting(
                                                                    key: controller
                                                                        .currentTime) &&
                                                                controller
                                                                    .monthSettingMap[controller
                                                                        .currentTime]!
                                                                    .walletInfo
                                                                    .isNotEmpty
                                                            ? (controller
                                                                    .monthSettingMap[controller
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
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0,
                                                      vertical: 12),
                                                  child: controller
                                                          .walletLoading
                                                      ? LoadingWidget(
                                                          width: width * 0.25,
                                                          height: width * 0.1,
                                                          loading: controller
                                                              .walletLoading)
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    mainColor,
                                                                width: 0.5),
                                                            color: mainColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                    vertical:
                                                                        10),
                                                            child: CustomText(
                                                              color: whiteColor,
                                                              text: controller
                                                                      .walletLoading
                                                                  ? 'loading data'
                                                                  : controller.haveMonthSetting(key: controller.currentTime) &&
                                                                          controller
                                                                              .monthSettingMap[controller.currentTime]!
                                                                              .walletInfo
                                                                              .isNotEmpty
                                                                      ? '${controller.monthSettingMap[controller.currentTime]!.walletInfo[index].wallet} $amount ${controller.monthSettingMap[controller.currentTime]!.walletInfo[index].currency}'
                                                                      : '${controller.userModel.wallets[index].name} $amount ${controller.userModel.wallets[index].currency}',
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
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: controller.totalLoading
                                                ? LoadingWidget(
                                                    width: width * 0.5,
                                                    height: 30,
                                                    loading:
                                                        controller.totalLoading)
                                                : Row(
                                                    children: [
                                                      CustomText(
                                                        text:
                                                            '${controller.moneyFormat(amount: controller.totalchanged ? controller.moneyTrans : controller.moneyTotal)} ${countries[codes[codes.indexWhere((element) => element == controller.transactionCurrency)]]!['symbolNative']}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Avatar(
                                    borderColor: oilColor,
                                    type: controller.userModel.localImage
                                        ? controller.imageExists(
                                            link:
                                                controller.userModel.localPath,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Container(
                                  height: width * 0.1,
                                  width: width * 0.1,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: whiteColor.withOpacity(0.5),
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.bell,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              )
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
                              GestureDetector(
                                onTap: () => controller.isCurved(),
                                child: CustomText(
                                  text: 'anal'.tr,
                                  size: 16,
                                  weight: FontWeight.bold,
                                ),
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
                                SingleChildScrollView(
                                  // physics: const BouncingScrollPhysics(),
                                  // scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    // make dynamic
                                    width: width,
                                    height: width * 0.58,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: mainColor.withOpacity(0.2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: LineChart(
                                          curve: Curves.ease,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          LineChartData(
                                            gridData:
                                                const FlGridData(show: true),
                                            titlesData: FlTitlesData(
                                              bottomTitles: AxisTitles(
                                                axisNameSize: width * 0.05,
                                                axisNameWidget: SizedBox(
                                                  width: width,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: List.generate(3,
                                                        (index) {
                                                      List<String> title = [
                                                        'income'.tr,
                                                        'expence'.tr,
                                                        'total'.tr
                                                      ];
                                                      List<double> values = [
                                                        controller.income,
                                                        controller.expense == 0
                                                            ? controller.expense
                                                            : controller
                                                                    .expense *
                                                                -1,
                                                        controller.income +
                                                            controller.expense
                                                      ];

                                                      return controller.loading
                                                          ? LoadingWidget(
                                                              width:
                                                                  width * 0.2,
                                                              height: height,
                                                              loading:
                                                                  controller
                                                                      .loading)
                                                          : CustomText(
                                                              text:
                                                                  '${title[index]} : ${controller.humanFormat(values[index])}');
                                                    }),
                                                  ),
                                                ),
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 32,
                                                  interval: controller
                                                          .chartDataErrorl()
                                                      ? 1
                                                      : controller.interval(
                                                          fallback: 10,
                                                          amount: controller
                                                              .dateTitle(),
                                                          max: (controller
                                                                      .chartData[controller
                                                                          .chosenCat
                                                                          .name]!
                                                                      .end
                                                                      .millisecondsSinceEpoch /
                                                                  1000000)
                                                              .toDouble(),
                                                          min: (controller
                                                                      .chartData[controller
                                                                          .chosenCat
                                                                          .name]!
                                                                      .start
                                                                      .millisecondsSinceEpoch /
                                                                  1000000)
                                                              .toDouble()),
                                                  getTitlesWidget:
                                                      (double value,
                                                          TitleMeta meta) {
                                                    DateTime time = controller
                                                            .chartDataErrorl()
                                                        ? DateTime.now()
                                                        : DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                BigInt.from(value *
                                                                        1000000)
                                                                    .toInt());

                                                    return GestureDetector(
                                                      onTap: () => controller
                                                          .rotateXAxis(),
                                                      child: RotationTransition(
                                                        turns: AlwaysStoppedAnimation(
                                                            controller
                                                                    .rotation /
                                                                360),
                                                        child: CustomText(
                                                          size: 10,
                                                          text:
                                                              '${time.year == DateTime.now().year ? '' : '${time.year}/'}${time.month}/${time.day}',
                                                          align:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              rightTitles: const AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              topTitles: const AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  reservedSize: 32,
                                                  getTitlesWidget:
                                                      (double value,
                                                          TitleMeta meta) {
                                                    String text = value
                                                        .toStringAsFixed(0);

                                                    return CustomText(
                                                      text: text,
                                                      size: 12,
                                                    );
                                                  },
                                                  showTitles: true,
                                                  interval: controller
                                                          .chartDataErrorl()
                                                      ? 1
                                                      : controller.interval(
                                                          fallback: 10,
                                                          amount: 6,
                                                          max: controller
                                                              .chartData[
                                                                  controller
                                                                      .chosenCat
                                                                      .name]!
                                                              .high,
                                                          min: controller
                                                              .chartData[
                                                                  controller
                                                                      .chosenCat
                                                                      .name]!
                                                              .low),
                                                ),
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            lineBarsData: [
                                              LineChartBarData(
                                                isCurved: controller.isCuved,
                                                color:
                                                    mainColor.withOpacity(0.75),
                                                barWidth: 4,
                                                isStrokeCapRound: true,
                                                dotData: const FlDotData(
                                                    show: false),
                                                belowBarData:
                                                    BarAreaData(show: false),
                                                spots:
                                                    controller.chartDataErrorl()
                                                        ? []
                                                        : List.generate(
                                                            controller
                                                                .chartData[
                                                                    controller
                                                                        .chosenCat
                                                                        .name]!
                                                                .data
                                                                .length,
                                                            (index) {
                                                              DateTime dataTime = controller
                                                                  .chartData[
                                                                      controller
                                                                          .chosenCat
                                                                          .name]!
                                                                  .data
                                                                  .entries
                                                                  .elementAt(
                                                                      index)
                                                                  .key;
                                                              double dataValue = controller
                                                                  .chartData[
                                                                      controller
                                                                          .chosenCat
                                                                          .name]!
                                                                  .data
                                                                  .entries
                                                                  .elementAt(
                                                                      index)
                                                                  .value;

                                                              return FlSpot(
                                                                  (dataTime.millisecondsSinceEpoch /
                                                                          1000000)
                                                                      .toDouble(),
                                                                  dataValue);
                                                            },
                                                          ),
                                              )
                                            ],
                                            maxX: controller.chartDataErrorl()
                                                ? 1
                                                : (controller
                                                            .chartData[
                                                                controller
                                                                    .chosenCat
                                                                    .name]!
                                                            .end
                                                            .millisecondsSinceEpoch /
                                                        1000000)
                                                    .toDouble(),
                                            minX: controller.chartDataErrorl()
                                                ? 0
                                                : (controller
                                                            .chartData[
                                                                controller
                                                                    .chosenCat
                                                                    .name]!
                                                            .start
                                                            .millisecondsSinceEpoch /
                                                        1000000)
                                                    .toDouble(),
                                            maxY: controller.chartDataErrorl()
                                                ? 1
                                                : controller
                                                    .chartData[controller
                                                        .chosenCat.name]!
                                                    .high,
                                            minY: controller.chartDataErrorl()
                                                ? 0
                                                : controller
                                                    .chartData[controller
                                                        .chosenCat.name]!
                                                    .low,
                                          ),
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
                              height: width * 0.12,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: controller.loading
                                    ? LoadingWidget(
                                        width: width,
                                        height: 30,
                                        loading: controller.loading)
                                    : Row(
                                        children: List.generate(
                                          controller.catList.length,
                                          (index) {
                                            int chosenIndex = controller.catList
                                                .indexWhere((element) =>
                                                    element.name ==
                                                    controller.chosenCat.name);

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: GestureDetector(
                                                onTap: () => controller
                                                    .changeChosenCategory(
                                                        model: controller
                                                            .catList[index]),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: index == chosenIndex
                                                        ? mainColor
                                                        : Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: CustomText(
                                                      text: controller
                                                          .catList[index].name,
                                                      color:
                                                          index == chosenIndex
                                                              ? whiteColor
                                                              : Colors.black,
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
                          Column(
                            children: List.generate(
                              controller.loading
                                  ? 10
                                  : controller.catList.length,
                              (index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.calculateSubcategories(
                                          transactions: controller
                                                  .catList[index]
                                                  .transactions ??
                                              []);
                                      showModal(
                                        xFunction: () {},
                                        context: context,
                                        title: controller.catList[index].name,
                                        child: GetBuilder<HomeController>(
                                          init: Get.find<HomeController>(),
                                          builder: (controller) => Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: SizedBox(
                                                  width: width,
                                                  height: width * 0.135,
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => controller
                                                            .mainSubFlip(
                                                                all: false),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  (width / 2) -
                                                                      12,
                                                              height: (width *
                                                                      0.135) *
                                                                  0.95,
                                                              child: Center(
                                                                child:
                                                                    CustomText(
                                                                  text: 'calced'
                                                                      .tr,
                                                                  color: controller
                                                                          .mainSubAll
                                                                      ? mainColor
                                                                          .withOpacity(
                                                                              0.5)
                                                                      : mainColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width:
                                                                  (width / 2) -
                                                                      12,
                                                              height: (width *
                                                                      0.135) *
                                                                  0.05,
                                                              color: controller
                                                                      .mainSubAll
                                                                  ? mainColor
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : mainColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () => controller
                                                            .mainSubFlip(
                                                                all: true),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  (width / 2) -
                                                                      12,
                                                              height: (width *
                                                                      0.135) *
                                                                  0.95,
                                                              child: Center(
                                                                child:
                                                                    CustomText(
                                                                  text: 'totals'
                                                                      .tr,
                                                                  color: controller
                                                                          .mainSubAll
                                                                      ? mainColor
                                                                      : mainColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width:
                                                                  (width / 2) -
                                                                      12,
                                                              height: (width *
                                                                      0.135) *
                                                                  0.05,
                                                              color: controller
                                                                      .mainSubAll
                                                                  ? mainColor
                                                                  : mainColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Column(
                                                  children: List.generate(
                                                    controller.mainSubAll
                                                        ? controller
                                                            .catList[index]
                                                            .transactions!
                                                            .length
                                                        : controller
                                                            .mainSub.length,
                                                    (i) {
                                                      String cat = controller
                                                              .mainSubAll
                                                          ? controller
                                                              .catList[index]
                                                              .transactions![i]
                                                              .catagory
                                                          : controller
                                                              .mainSub[controller
                                                                  .mainSub.keys
                                                                  .elementAt(
                                                                      i)]!
                                                              .cat;

                                                      Color transColor = colorConvert(
                                                          code: controller
                                                              .userModel
                                                              .catagories
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .name ==
                                                                      cat)
                                                              .color);

                                                      IconData iconDat = iconConvert(
                                                          code: controller
                                                              .userModel
                                                              .catagories
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .name ==
                                                                      cat)
                                                              .icon);
                                                      TransactionDataModel
                                                          chosenTransaction =
                                                          controller.mainSubAll
                                                              ? controller
                                                                  .catList[
                                                                      index]
                                                                  .transactions![i]
                                                              : TransactionDataModel(
                                                                  id: '',
                                                                  catagory:
                                                                      'catagory',
                                                                  subCatagory:
                                                                      'subCatagory',
                                                                  currency:
                                                                      currency,
                                                                  amount: 0,
                                                                  note: 'note',
                                                                  date: DateTime
                                                                      .now(),
                                                                  wallet:
                                                                      'wallet',
                                                                  fromWallet:
                                                                      'fromWallet',
                                                                  toWallet:
                                                                      'toWallet',
                                                                  type: TransactionType
                                                                      .transfer,
                                                                );
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ExpenceTileNew(
                                                          sign: controller
                                                                  .mainSubAll
                                                              ? (countries[codes[codes.indexWhere((element) =>
                                                                      element ==
                                                                      chosenTransaction
                                                                          .currency)]]!['symbolNative']) ??
                                                                  ''
                                                              : '',
                                                          type: ExpenseTile
                                                              .expense,
                                                          width: width,
                                                          color: transColor,
                                                          title: controller
                                                                  .mainSubAll
                                                              ? chosenTransaction
                                                                  .catagory
                                                              : controller
                                                                  .mainSub.keys
                                                                  .elementAt(i),
                                                          date: controller
                                                                  .mainSubAll
                                                              ? chosenTransaction
                                                                  .date
                                                              : null,
                                                          amount:
                                                              controller
                                                                      .mainSubAll
                                                                  ? chosenTransaction
                                                                      .amount
                                                                  : controller
                                                                      .mainSub
                                                                      .values
                                                                      .elementAt(
                                                                          i)
                                                                      .amount,
                                                          budget: false,
                                                          icon: iconDat,
                                                          reason: controller
                                                                  .mainSubAll
                                                              ? chosenTransaction
                                                                          .subCatagory ==
                                                                      ''
                                                                  ? 'noavailable'
                                                                      .tr
                                                                  : chosenTransaction
                                                                      .subCatagory
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        button: Container(),
                                      );
                                    },
                                    child: ExpenceTileNew(
                                      type: controller.loading
                                          ? ExpenseTile.loading
                                          : ExpenseTile.category,
                                      sign: '',
                                      ave: controller.average(
                                        amount: controller.loading
                                            ? 0.0
                                            : controller.vals[controller
                                                .catList[index].name] as double,
                                      ),
                                      count: controller.loading
                                          ? 0
                                          : controller.catList[index]
                                              .transactions!.length,
                                      budget: controller.loading ||
                                              controller.catList.isEmpty
                                          ? false
                                          : controller.budgetShow(
                                              category: controller
                                                  .catList[index].name),
                                      budgetNum: controller.loading ||
                                              controller.catList.isEmpty
                                          ? 0
                                          : controller.budgetAmount(
                                              category: controller
                                                  .catList[index].name),
                                      width: width,
                                      title: controller.loading
                                          ? 'Loading...'
                                          : controller.catList[index].name,
                                      date: DateTime.now(),
                                      amount: controller.loading ||
                                              controller.catList.isEmpty
                                          ? 0.0
                                          : controller.vals[controller
                                              .catList[index].name] as double,
                                      color: controller.loading
                                          ? Colors.transparent
                                          : colorConvert(
                                              code: controller
                                                  .catList[index].color),
                                      icon: controller.loading
                                          ? Icons.add
                                          : iconConvert(
                                              code: controller
                                                  .catList[index].icon,
                                            ),
                                    ),
                                  ),
                                );
                              },
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
