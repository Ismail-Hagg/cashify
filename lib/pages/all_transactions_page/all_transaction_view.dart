import 'package:cashify/data_models/category_data_model.dart';
import 'package:cashify/data_models/transaction_data_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/countries.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:cashify/widgets/modal_widget.dart';
import 'package:cashify/widgets/new_expense.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
                              click: () => WoltModalSheet.show(
                                onModalDismissedWithBarrierTap: () =>
                                    controller.resetFilter(cancel: false),
                                onModalDismissedWithDrag: () =>
                                    controller.resetFilter(cancel: false),
                                context: context,
                                modalTypeBuilder: (context) =>
                                    WoltModalType.bottomSheet,
                                pageListBuilder: (modalSheetContext) {
                                  return [
                                    modalPage(
                                      icon:
                                          const FaIcon(FontAwesomeIcons.xmark),
                                      leadingButtonFunction: () =>
                                          controller.resetFilter(cancel: true),
                                      context: modalSheetContext,
                                      title: 'filter'.tr,
                                      child:
                                          GetBuilder<AllTransactionsController>(
                                        init: Get.find<
                                            AllTransactionsController>(),
                                        builder: (controller) => Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                      text: 'timefilter'.tr),
                                                  Row(
                                                    children: [
                                                      ButtonWidget(
                                                        isIos: controller.isIos,
                                                        textSize: 14,
                                                        type: ButtonType.text,
                                                        onClick: () =>
                                                            controller
                                                                .filterTime(
                                                                    context:
                                                                        context,
                                                                    start:
                                                                        true),
                                                        text: controller
                                                                    .filterModel
                                                                    .timeStart !=
                                                                null
                                                            ? DateFormat.yMd()
                                                                .format(controller
                                                                    .filterModel
                                                                    .timeStart!
                                                                    .toDate())
                                                            : 'timestart'.tr,
                                                      ),
                                                      const CustomText(
                                                          text: '  -  '),
                                                      ButtonWidget(
                                                        isIos: controller.isIos,
                                                        textSize: 14,
                                                        type: ButtonType.text,
                                                        onClick: () =>
                                                            controller
                                                                .filterTime(
                                                                    context:
                                                                        context,
                                                                    start:
                                                                        false),
                                                        text: controller
                                                                    .filterModel
                                                                    .timeEnd !=
                                                                null
                                                            ? DateFormat.yMd()
                                                                .format(controller
                                                                    .filterModel
                                                                    .timeEnd!
                                                                    .toDate())
                                                            : 'timeend'.tr,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0),
                                                child: SizedBox(
                                                  width: width,
                                                  height: width * 0.125,
                                                  child: DropdownMenu(
                                                    onSelected: (val) =>
                                                        controller.catsFilter(
                                                            cat: 'cat',
                                                            val: val as String),
                                                    hintText: 'catfilter'.tr,
                                                    expandedInsets:
                                                        const EdgeInsets.all(0),
                                                    dropdownMenuEntries:
                                                        List.generate(
                                                      controller
                                                          .lsts()
                                                          .$1
                                                          .length,
                                                      (index) =>
                                                          DropdownMenuEntry(
                                                        label: controller
                                                            .lsts()
                                                            .$1[index],
                                                        value: controller
                                                            .lsts()
                                                            .$1[index],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0),
                                                child: SizedBox(
                                                  width: width,
                                                  height: width * 0.125,
                                                  child: DropdownMenu(
                                                    onSelected: (val) =>
                                                        controller.catsFilter(
                                                            cat: 'sub',
                                                            val: val as String),
                                                    hintText: 'subcatfilter'.tr,
                                                    expandedInsets:
                                                        const EdgeInsets.all(0),
                                                    dropdownMenuEntries:
                                                        List.generate(
                                                      controller
                                                          .lsts()
                                                          .$2
                                                          .length,
                                                      (index) =>
                                                          DropdownMenuEntry(
                                                        label: controller
                                                            .lsts()
                                                            .$2[index],
                                                        value: controller
                                                            .lsts()
                                                            .$2[index],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InputWidget(
                                                          hint: 'more'.tr,
                                                          height: width * 0.125,
                                                          width: width * 0.28,
                                                          active: controller
                                                              .rangeStartActive,
                                                          controller: controller
                                                              .rangeStartController,
                                                          node: controller
                                                              .rangeStartNode,
                                                          formatter: [
                                                            // Allow Decimal Number With Precision of 2 Only
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^\d*\.?\d{0,2}')),
                                                          ],
                                                          type: const TextInputType
                                                              .numberWithOptions(
                                                              signed: true,
                                                              decimal: true),
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.02,
                                                        ),
                                                        InputWidget(
                                                          hint: 'less'.tr,
                                                          height: width * 0.125,
                                                          width: width * 0.28,
                                                          active: controller
                                                              .rangeEndActive,
                                                          controller: controller
                                                              .rangeEndController,
                                                          node: controller
                                                              .rangeEndNode,
                                                          formatter: [
                                                            // Allow Decimal Number With Precision of 2 Only
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^\d*\.?\d{0,2}')),
                                                          ],
                                                          type: const TextInputType
                                                              .numberWithOptions(
                                                              decimal: true),
                                                        ),
                                                      ],
                                                    ),
                                                    CountryPickerDropdown(
                                                      initialValue: CountryPickerUtils
                                                              .getCountryByCurrencyCode(
                                                                  controller
                                                                      .userModel
                                                                      .defaultCurrency)
                                                          .isoCode,
                                                      itemBuilder:
                                                          (Country country) =>
                                                              SizedBox(
                                                        height: width * 0.14,
                                                        width:
                                                            (width - 24) * 0.2,
                                                        child: FittedBox(
                                                          child: Row(
                                                            children: <Widget>[
                                                              CountryPickerUtils
                                                                  .getDefaultFlagImage(
                                                                      country),
                                                              const SizedBox(
                                                                width: 8.0,
                                                              ),
                                                              Text(country
                                                                  .currencyCode
                                                                  .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      onValuePicked: (Country?
                                                              country) =>
                                                          country != null
                                                              ? controller.catsFilter(
                                                                  cat: 'curr',
                                                                  val: country
                                                                          .currencyCode ??
                                                                      '')
                                                              : null,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      button: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ButtonWidget(
                                          isIos: controller.isIos,
                                          textSize: 16,
                                          type: ButtonType.raised,
                                          onClick: () => controller.filterRes(
                                              context: context),
                                          color: mainColor,
                                          height:
                                              MediaQuery.of(modalSheetContext)
                                                      .size
                                                      .width *
                                                  0.125,
                                          width:
                                              MediaQuery.of(modalSheetContext)
                                                  .size
                                                  .width,
                                          text: 'filter'.tr,
                                        ),
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: List.generate(
                      controller.container[controller.pointer]['loading'] ==
                                  true &&
                              (controller.container[controller.pointer]
                                          ['transactions']
                                      as List<TransactionDataModel>)
                                  .isEmpty
                          ? 10
                          : (controller.container[controller.pointer]
                                      ['transactions']
                                  as List<TransactionDataModel>)
                              .length,
                      (index) {
                        bool loading = controller.container[controller.pointer]
                                    ['loading'] ==
                                true &&
                            (controller.container[controller.pointer]
                                        ['transactions']
                                    as List<TransactionDataModel>)
                                .isEmpty;

                        TransactionDataModel? transaction = loading
                            ? null
                            : (controller.container[controller.pointer]
                                    ['transactions']
                                as List<TransactionDataModel>)[index];

                        CatagoryModel? category = loading
                            ? null
                            : controller.userModel.catagories.firstWhere(
                                (element) =>
                                    element.name == transaction!.catagory,
                                orElse: () => CatagoryModel(
                                    name: 'thingyy',
                                    subCatagories: [],
                                    icon:
                                        '${Icons.add.codePoint}-${Icons.add.fontFamily}',
                                    color: 4283471689));

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 10),
                          child: Slidable(
                            enabled: loading == false,
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
                                          onClick: () => controller.transDelete(
                                            context: context,
                                            transaction: transaction!,
                                          ),
                                          text: 'yes'.tr,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                IconButtonPlatform(
                                  isIos: controller.isIos,
                                  icon: FontAwesomeIcons.penToSquare,
                                  color: mainColor,
                                  click: () => controller.queryTransaction(
                                      model: transaction!),
                                ),
                                IconButtonPlatform(
                                  isIos: controller.isIos,
                                  icon: FontAwesomeIcons.comment,
                                  color: loading
                                      ? mainColor
                                      : transaction!.note != ''
                                          ? mainColor
                                          : Colors.grey,
                                  click: () => controller.deleteDialog(
                                    dilog: AlertDialog(
                                      content: CustomText(
                                        text: transaction!.note,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: ExpenceTileNew(
                                type: loading
                                    ? ExpenseTile.loading
                                    : ExpenseTile.expense,
                                width: width,
                                title: loading
                                    ? 'loading ...'
                                    : transaction!.catagory,
                                amount: loading ? 0 : transaction!.amount,
                                date: loading
                                    ? DateTime.now()
                                    : transaction!.date,
                                reason: loading
                                    ? null
                                    : transaction!.subCatagory == ''
                                        ? null
                                        : transaction.subCatagory,
                                color: loading
                                    ? Colors.red
                                    : colorConvert(code: category!.color),
                                icon: loading
                                    ? Icons.add
                                    : iconConvert(code: category!.icon),
                                sign: loading ||
                                        transaction!.currency ==
                                            controller.userModel.defaultCurrency
                                    ? ''
                                    : '${countries[codes[codes.indexWhere((element) => element == transaction.currency)]]!['symbolNative']}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
