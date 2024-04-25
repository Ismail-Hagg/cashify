import 'dart:math';

import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_chart/flutter_circle_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:mrx_charts/mrx_charts.dart';

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
                                controller.test.length,
                                (index) {
                                  final key =
                                      controller.test.keys.toList()[index];
                                  final value = controller.test[key];
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // print(value!.truncate());
                                      },
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
                                                '$key : ${value![0]}  ${value[1]}',
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
                      horizontal: 12,
                    ),
                    child: Container(
                      height: width,
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
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  color: mainColor,
                                  size: 14,
                                  text: '2024/12/01 - 2024/12/15',
                                ),
                                PopupMenuButton<String>(
                                  icon: FaIcon(
                                    FontAwesomeIcons.ellipsisVertical,
                                    color: mainColor,
                                  ),
                                  onSelected: (val) {},
                                  itemBuilder: (BuildContext context) {
                                    return ['one', 'two', 'another', 'love']
                                        .map(
                                      (String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      },
                                    ).toList();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: List.generate(
                          CircleChartType.values.length,
                          (index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${CircleChartType.values[index]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CircleChart(
                                chartType: CircleChartType.values[index],
                                items: List.generate(
                                  3,
                                  (index) => CircleChartItemData(
                                    color: randomColor(),
                                    value: 100 +
                                        Random.secure().nextDouble() * 1000,
                                    name: 'Lorem Ipsum $index',
                                    description:
                                        'Lorem Ipsum $index không phải chỉ là một đoạn văn bản ngẫu nhiên.',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color randomColor() {
    var g = math.Random.secure().nextInt(255);
    var b = math.Random.secure().nextInt(255);
    var r = math.Random.secure().nextInt(255);
    return Color.fromARGB(255, r, g, b);
  }
}
