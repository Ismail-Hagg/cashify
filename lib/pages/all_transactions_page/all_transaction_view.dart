import 'package:cashify/models/transaction_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/expense_tile_widget.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          InputWidget(
                            maxLines: 1,
                            onSub: (query) =>
                                controller.searchNotes(query: query),
                            hint: 'search'.tr,
                            color: Colors.grey.shade300,
                            height: width * 0.125,
                            width: width * 0.6,
                            active: controller.searchActive,
                            node: controller.searchNode,
                            controller: controller.searchController,
                          ),
                          SizedBox(
                            height: width * 0.125,
                            width: (width * 0.13) - 8,
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: controller.pointer == 2
                                  ? FontAwesomeIcons.solidCircleXmark
                                  : FontAwesomeIcons.circleXmark,
                              color: mainColor,
                              click: () => controller.closeSearchMode(),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () => controller.deleteDialog(
                              dilog: AlertDialog(
                                title: CustomText(
                                  text: 'order'.tr,
                                ),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => controller.orderChange(
                                            method: 'date'),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: controller.order == 'date'
                                                ? Border.all(
                                                    color: mainColor, width: 1)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomText(
                                              text: 'date'.tr,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => controller.orderChange(
                                            method: 'amount'),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: controller.order == 'amount'
                                                ? Border.all(
                                                    color: mainColor, width: 1)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomText(
                                              text: 'count'.tr,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: SizedBox(
                              height: width * 0.125,
                              width: (width * 0.13) - 8,
                              child: IconButtonPlatform(
                                isIos: controller.isIos,
                                icon: controller.descending
                                    ? FontAwesomeIcons.arrowDown
                                    : FontAwesomeIcons.arrowUp,
                                color: mainColor,
                                click: () => controller.changeAscending(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: width * 0.125,
                            width: (width * 0.13) - 8,
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.filter,
                              color: mainColor,
                              click: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        controller.container[controller.pointer]['loading'] ==
                                    true &&
                                (controller.container[controller.pointer]
                                            ['transactions']
                                        as List<TransactionModel>)
                                    .isEmpty
                            ? 10
                            : (controller.container[controller.pointer]
                                    ['transactions'] as List<TransactionModel>)
                                .length,
                        (index) {
                          if (controller.container[controller.pointer]
                                      ['loading'] ==
                                  true &&
                              (controller.container[controller.pointer]
                                          ['transactions']
                                      as List<TransactionModel>)
                                  .isEmpty) {
                            return Skeletonizer(
                              enabled: true,
                              child: ExpenceTile(
                                width: width,
                                color: Colors.grey.shade300,
                                title:
                                    ' slkdjflkjsd f sdlf jlsdkjf lksdjflksj ',
                                subtitle: ';aoijdf kdj f;lk ',
                                amount: '',
                                budget: false,
                                icon: Icons.add,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                loading: true,
                              ),
                            );
                          } else {
                            TransactionModel transaction =
                                (controller.container[controller.pointer]
                                        ['transactions']
                                    as List<TransactionModel>)[index];
                            String tranId =
                                (controller.container[controller.pointer]['ids']
                                    as List<String>)[index];
                            bool isTransfer =
                                transaction.type == TransactionType.transfer;

                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  IconButtonPlatform(
                                    isIos: controller.isIos,
                                    icon: FontAwesomeIcons.trash,
                                    color: mainColor,
                                    click: () => controller.deleteDialog(
                                      dilog: AlertDialog(
                                        title: CustomText(
                                          text: 'deletetrans'.tr,
                                        ),
                                        actions: [
                                          ButtonWidget(
                                              isIos: controller.isIos,
                                              textSize: 12,
                                              type: ButtonType.text,
                                              onClick: () =>
                                                  controller.deleteTransaction(
                                                      id: tranId,
                                                      model: transaction),
                                              text: 'yes'.tr)
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButtonPlatform(
                                    isIos: controller.isIos,
                                    icon: FontAwesomeIcons.penToSquare,
                                    color: mainColor,
                                    click: () => controller.queryTransaction(
                                        id: tranId, model: transaction),
                                  ),
                                  IconButtonPlatform(
                                    isIos: controller.isIos,
                                    icon: FontAwesomeIcons.comment,
                                    color: transaction.note != ''
                                        ? mainColor
                                        : Colors.grey,
                                    click: () => controller.deleteDialog(
                                      dilog: AlertDialog(
                                        content: CustomText(
                                          text: transaction.note,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              enabled: true,
                              child: GestureDetector(
                                onTap: () {
                                  print(tranId);
                                },
                                child: ExpenceTile(
                                  aveFit: false,
                                  ave: isTransfer
                                      ? null
                                      : transaction.subCatagory == ''
                                          ? 'noavailable'.tr
                                          : transaction.subCatagory,
                                  width: width,
                                  color: isTransfer
                                      ? Colors.red.shade500
                                      : controller.getColor(
                                          category: transaction.catagory,
                                        ),
                                  title: isTransfer
                                      ? transaction.type.name
                                      : transaction.catagory,
                                  subtitle: DateFormat.yMd()
                                      .format(transaction.date)
                                      .toString(),
                                  amount: controller
                                      .ammount(model: transaction, real: false)
                                      .toString(),
                                  budget: isTransfer ? true : false,
                                  icon: isTransfer
                                      ? FontAwesomeIcons.arrowsRotate
                                      : controller.getIcon(
                                          category: transaction.catagory,
                                        ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  loading: false,
                                  transferInfo: CustomText(
                                    color: Colors.grey.shade500,
                                    isFit: true,
                                    text:
                                        'From ${transaction.fromWallet} To ${transaction.toWallet} ',
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      )
                          .animate(interval: 80.ms)
                          .moveX(duration: 250.ms)
                          .fadeIn(duration: 250.ms),
                    ),
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
