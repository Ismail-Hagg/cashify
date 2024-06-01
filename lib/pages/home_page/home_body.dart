import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/animeted_icon_widget.dart';
import 'package:cashify/widgets/caragory_indicator_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/expense_tile_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
                  SizedBox(
                    height: width * 0.06,
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Skeletonizer(
                              enabled: controller.loading,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Row(
                                  children: List.generate(
                                    controller.loading
                                        ? 10
                                        : controller.monhtMap[
                                                    controller.currentTime] ==
                                                null
                                            ? controller
                                                .userModel.wallets.length
                                            : controller
                                                .monhtMap[
                                                    controller.currentTime]!
                                                .walletInfo
                                                .length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: controller.loading
                                                  ? backgroundColor
                                                  : mainColor.withOpacity(0.5),
                                            ),
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomText(
                                                // make better
                                                text: controller.loading
                                                    ? 'Loading    '
                                                    : controller.monhtMap[controller
                                                                .currentTime] ==
                                                            null
                                                        ? '${controller.userModel.wallets[index].name} : ${controller.walletAmount(amount: controller.userModel.wallets[index].amount)} ${controller.userModel.wallets[index].currency}'
                                                        : '${controller.monhtMap[controller.currentTime]!.walletInfo[index].wallet} : ${controller.walletAmount(amount: controller.monhtMap[controller.currentTime]!.walletInfo[index].start + controller.monhtMap[controller.currentTime]!.walletInfo[index].opSum)} ${controller.monhtMap[controller.currentTime]!.walletInfo[index].currency}'),
                                          ),
                                        ),
                                      );
                                    },
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 12,
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
                            child: Skeletonizer(
                              enabled: controller.loading,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    color: mainColor,
                                    size: 14,
                                    text: controller.chosenTime,
                                  ),
                                  Row(
                                    children: [
                                      AnimatedContainer(
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                        height: controller.pieChart
                                            ? width * 0.065
                                            : width * 0.04,
                                        width: controller.pieChart
                                            ? width * 0.065
                                            : width * 0.04,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: FittedBox(
                                          child: GestureDetector(
                                            onTap: () => controller.chartSwitch(
                                                pie: true),
                                            child: FaIcon(
                                              FontAwesomeIcons.chartPie,
                                              color: controller.pieChart
                                                  ? mainColor
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.05,
                                      ),
                                      AnimatedContainer(
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                        height: !controller.pieChart
                                            ? width * 0.065
                                            : width * 0.04,
                                        width: !controller.pieChart
                                            ? width * 0.065
                                            : width * 0.04,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: FittedBox(
                                          child: GestureDetector(
                                            onTap: () => controller.chartSwitch(
                                                pie: false),
                                            child: FaIcon(
                                              FontAwesomeIcons.chartLine,
                                              color: controller.pieChart
                                                  ? Colors.grey.shade300
                                                  : mainColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    splashRadius: 10,
                                    icon: FaIcon(
                                      FontAwesomeIcons.ellipsisVertical,
                                      color: mainColor,
                                    ),
                                    onSelected: (val) =>
                                        controller.changeTimePeriod(
                                            context: context, time: val),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                          ),
                          if (controller.pieChart) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: width * 0.45,
                                  width: width * 0.45,
                                  child: controller.loading
                                      ? IconAnimated(
                                          name: Icons8.circles_menu_1_iOS,
                                          controller:
                                              controller.loadingController,
                                          color: mainColor,
                                        )
                                      : Stack(
                                          children: [
                                            Chart(
                                              layers: [
                                                ChartGroupPieLayer(
                                                  items: [
                                                    List.generate(
                                                      controller.showIncome
                                                          ? controller
                                                              .valsUp.length
                                                          : controller
                                                              .valsDown.length,
                                                      (index) => ChartGroupPieDataItem(
                                                          amount: controller
                                                                  .showIncome
                                                              ? controller
                                                                  .valsUp.values
                                                                  .elementAt(
                                                                      index)
                                                              : controller
                                                                  .valsDown
                                                                  .values
                                                                  .elementAt(
                                                                      index),
                                                          color: controller
                                                              .catList
                                                              .firstWhere((catagory) => controller
                                                                      .showIncome
                                                                  ? catagory.name ==
                                                                      controller
                                                                          .valsUp
                                                                          .keys
                                                                          .elementAt(index)
                                                                  : catagory.name == controller.valsDown.keys.elementAt(index))
                                                              .color,
                                                          label: 'thing'),
                                                    ),
                                                  ],
                                                  settings:
                                                      const ChartGroupPieSettings(),
                                                ),
                                              ],
                                            ),
                                            Center(
                                              child: Skeletonizer(
                                                enabled: controller.loading,
                                                child: ButtonWidget(
                                                  isIos: controller.isIos,
                                                  textSize: 16,
                                                  type: ButtonType.text,
                                                  onClick: () =>
                                                      controller.openDialog(
                                                    widget: GetBuilder<
                                                        HomeController>(
                                                      init: Get.find<
                                                          HomeController>(),
                                                      builder: (controller) =>
                                                          AlertDialog(
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CustomText(
                                                              text: controller
                                                                  .walletAmount(
                                                                amount: controller.totalchanged
                                                                    ? controller
                                                                        .moneyTrans
                                                                    : controller
                                                                        .moneyTotal,
                                                              ),
                                                            ),
                                                            CountryPickerDropdown(
                                                              initialValue:
                                                                  CountryPickerUtils
                                                                      .getCountryByCurrencyCode(
                                                                controller
                                                                    .userModel
                                                                    .defaultCurrency,
                                                              ).isoCode,
                                                              itemBuilder: (Country
                                                                      country) =>
                                                                  SizedBox(
                                                                height: width *
                                                                    0.14,
                                                                width: (width -
                                                                        24) *
                                                                    0.2,
                                                                child:
                                                                    FittedBox(
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      CountryPickerUtils
                                                                          .getDefaultFlagImage(
                                                                              country),
                                                                      const SizedBox(
                                                                        width:
                                                                            8.0,
                                                                      ),
                                                                      Text(
                                                                        country
                                                                            .currencyCode
                                                                            .toString(),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              onValuePicked: (Country? country) => controller.currencyExchange(
                                                                  base: controller
                                                                      .userModel
                                                                      .defaultCurrency,
                                                                  to: country !=
                                                                          null
                                                                      ? country
                                                                              .currencyCode ??
                                                                          ''
                                                                      : '',
                                                                  amount: controller
                                                                      .moneyTotal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  text: controller.humanFormat(
                                                      controller.moneyTotal),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                if (controller.loading == false) ...[
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            controller.chartFlip(income: true),
                                        child: Container(
                                          height: width * 0.1,
                                          width: width * 0.1,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              color: controller.showIncome
                                                  ? Colors.green
                                                  : forgroundColor),
                                          child: Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.arrowUp,
                                              color: controller.showIncome
                                                  ? forgroundColor
                                                  : Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: width * 0.05,
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            controller.chartFlip(income: false),
                                        child: Container(
                                          height: width * 0.1,
                                          width: width * 0.1,
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.red),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              color: !controller.showIncome
                                                  ? Colors.red
                                                  : forgroundColor),
                                          child: Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.arrowDown,
                                              color: !controller.showIncome
                                                  ? forgroundColor
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ]
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: List.generate(
                                      controller.loading
                                          ? 5
                                          : controller.showIncome
                                              ? controller.valsUp.length
                                              : controller.valsDown.length,
                                      (index) {
                                    return Skeletonizer(
                                      enabled: controller.loading,
                                      child: CatagoryIndicator(
                                          scrolable: true,
                                          loading: false,
                                          width: width,
                                          color: controller.loading
                                              ? Colors.grey.shade300
                                              : controller.catList
                                                  .firstWhere((catagory) =>
                                                      controller.showIncome
                                                          ? catagory.name ==
                                                              controller
                                                                  .valsUp.keys
                                                                  .elementAt(
                                                                      index)
                                                          : catagory.name ==
                                                              controller
                                                                  .valsDown.keys
                                                                  .elementAt(
                                                                      index))
                                                  .color,
                                          catagory: controller.loading
                                              ? 'Loading'
                                              : controller.showIncome
                                                  ? controller.valsUp.keys
                                                      .elementAt(index)
                                                  : controller.valsDown.keys
                                                      .elementAt(index)),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                color: mainColor,
                                height: 3,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Skeletonizer(
                                    enabled: controller.loading,
                                    child: CatagoryIndicator(
                                      scrolable: controller.loading,
                                      loading: false,
                                      adjustedWidth: width * 0.25,
                                      width: width,
                                      color: controller.loading
                                          ? Colors.grey.shade300
                                          : Colors.green.withOpacity(0.75),
                                      catagory:
                                          '${'income'.tr} : ${controller.humanFormat(controller.income)}',
                                    ),
                                  ),
                                  Skeletonizer(
                                    enabled: controller.loading,
                                    child: CatagoryIndicator(
                                        scrolable: false,
                                        adjustedWidth: width * 0.25,
                                        loading: false,
                                        width: width,
                                        color: controller.loading
                                            ? Colors.grey.shade300
                                            : Colors.red.withOpacity(0.75),
                                        catagory:
                                            '${'expence'.tr} : ${controller.humanFormat(controller.expense == 0 ? controller.expense : controller.expense * -1)}'),
                                  ),
                                  Skeletonizer(
                                    enabled: controller.loading,
                                    child: CatagoryIndicator(
                                        scrolable: false,
                                        adjustedWidth: width * 0.25,
                                        loading: false,
                                        width: width,
                                        color: controller.loading
                                            ? Colors.grey.shade300
                                            : Colors.blue.withOpacity(0.75),
                                        catagory:
                                            '${'total'.tr} : ${controller.humanFormat(controller.income + controller.expense)}'),
                                  )
                                ],
                              ),
                            ),
                          ],
                          // if (!controller.pieChart) ...[
                          //   Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 12.0),
                          //     child: SizedBox(
                          //       height: width * 0.45,
                          //       width: width,
                          //       child: Chart(
                          //         layers: [
                          //           ChartAxisLayer(
                          //             settings: ChartAxisSettings(
                          //               x: ChartAxisSettingsAxis(
                          //                 frequency: (controller.endTime
                          //                             .millisecondsSinceEpoch -
                          //                         controller.startTime
                          //                             .millisecondsSinceEpoch) /
                          //                     5.0,
                          //                 max: controller
                          //                     .endTime.millisecondsSinceEpoch
                          //                     .toDouble(),
                          //                 min: controller
                          //                     .startTime.millisecondsSinceEpoch
                          //                     .toDouble(),
                          //                 textStyle: TextStyle(
                          //                   color:
                          //                       Colors.green.withOpacity(0.6),
                          //                   fontSize: 10.0,
                          //                 ),
                          //               ),
                          //               y: ChartAxisSettingsAxis(
                          //                 frequency: 100.0,
                          //                 max: controller.chartHigh,
                          //                 min: controller.chartLow,
                          //                 textStyle: TextStyle(
                          //                   color: Colors.red.withOpacity(0.6),
                          //                   fontSize: 10.0,
                          //                 ),
                          //               ),
                          //             ),
                          //             labelX: (value) => DateFormat.d().format(
                          //                 DateTime.fromMillisecondsSinceEpoch(
                          //                     value.toInt())),
                          //             labelY: (value) =>
                          //                 value.toInt().toString(),
                          //           ),
                          //           ChartLineLayer(
                          //             items: List.generate(
                          //               controller.vals.length,
                          //               (index) => ChartLineDataItem(
                          //                 x: (index *
                          //                         (controller.endTime
                          //                                 .millisecondsSinceEpoch -
                          //                             controller.startTime
                          //                                 .millisecondsSinceEpoch) /
                          //                         3.0) +
                          //                     controller.startTime
                          //                         .millisecondsSinceEpoch,
                          //                 value: controller.vals.values
                          //                     .elementAt(index),
                          //               ),
                          //             ),
                          //             settings: ChartLineSettings(
                          //               color: mainColor,
                          //               thickness: 3.0,
                          //             ),
                          //           )
                          //         ],
                          //         padding: const EdgeInsets.symmetric(
                          //                 horizontal: 30.0)
                          //             .copyWith(
                          //           bottom: 12.0,
                          //         ),
                          //       ),
                          //     ),
                          //   )
                          // ]
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      controller.loading ? 10 : controller.catList.length,
                      (index) => Skeletonizer(
                        enabled: controller.loading,
                        child: ExpenceTile(
                          loading: false,
                          budgetPercent: 0.5,
                          width: width,
                          color: controller.loading
                              ? Colors.grey.shade300
                              : controller.catList[index].color,
                          title: controller.loading
                              ? ''
                              : controller.catList[index].name,
                          subtitle: controller.loading
                              ? ''
                              : '${controller.catList[index].transactions!.length} transactions',
                          amount: controller.loading
                              ? '0'
                              : controller.humanFormat(controller
                                      .vals[controller.catList[index].name]
                                  as double),
                          ave: controller.loading
                              ? '0'
                              : '${'ave'.tr} ${(controller.aveCalc(amount: controller.vals[controller.catList[index].name] as double, dates: controller.dates[controller.catList[index].name] as List<DateTime>)).toStringAsFixed(2)}',
                          budget: false,
                          icon: controller.loading
                              ? Icons.add
                              : controller.catList[index].icon,
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                            bottom: 16,
                          ),
                          budgetKeeping: '50/100',
                        ),
                      ),
                    )
                        .animate(interval: 250.ms)
                        .moveX(duration: 250.ms)
                        .fadeIn(duration: 250.ms),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
