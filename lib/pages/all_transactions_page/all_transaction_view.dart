import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTransactionsView extends StatelessWidget {
  const AllTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AllTransactionsController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: const Center(
        child: CustomText(text: 'all transactions Page'),
      ),
    );
  }
}
