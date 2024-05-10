import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTransactionsView extends StatelessWidget {
  const AllTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AllTransactionsController());
    return GetBuilder<AllTransactionsController>(
      init: Get.find<AllTransactionsController>(),
      builder: (controller) => Scaffold(
        backgroundColor: backgroundColor,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InputWidget(
                          height: width * 0.15,
                          width: width * 0.8,
                          active: true,
                          controller: TextEditingController())
                    ],
                  ),
                ))
              ]),
            );
          },
        ),
      ),
    );
  }
}
