import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/pages/add_transaction_page/add_transaction_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/add_category_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/icon_button.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:cashify/widgets/modal_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddTRansactionView extends StatelessWidget {
  const AddTRansactionView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddTransactionController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.5,
        centerTitle: true,
        title: CustomText(
          text: 'transadd'.tr,
          color: mainColor,
        ),
        iconTheme: IconThemeData(color: mainColor),
      ),
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return GetBuilder<AddTransactionController>(
            init: Get.find<AddTransactionController>(),
            builder: (controller) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          isIos: controller.isIos,
                          textSize: 16,
                          type: ButtonType.text,
                          onClick: () =>
                              controller.transactionTime(context: context),
                          text: DateFormat.yMd().format(
                            controller.transactionAddTime,
                          ),
                        ),
                        Row(
                          children: [
                            IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.camera,
                              color: mainColor,
                              click: () {},
                            ),
                            SizedBox(
                              width: width * 0.025,
                            ),
                            IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.commentSms,
                              color: mainColor,
                              click: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        TransactionType.values.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () => controller.setTransactionType(
                                  type: TransactionType.values[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.transactionType ==
                                          TransactionType.values[index]
                                      ? mainColor
                                      : Colors.grey.shade300,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CustomText(
                                    color: controller.transactionType ==
                                            TransactionType.values[index]
                                        ? backgroundColor
                                        : null,
                                    size: width * 0.045,
                                    text: controller.operators[TransactionType
                                        .values[index].name] as String,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InputWidget(
                            formatter: [
                              // Allow Decimal Number With Precision of 2 Only
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            type: const TextInputType.numberWithOptions(
                                decimal: true),
                            height: width * 0.14,
                            width: (width - 24) * 0.7,
                            active: controller.isActive,
                            hint: 'amount'.tr,
                            node: controller.transactionAddNode,
                            controller: controller.transactionAddController,
                          ),
                          CountryPickerDropdown(
                            initialValue:
                                CountryPickerUtils.getCountryByCurrencyCode(
                                        controller.userModel.defaultCurrency)
                                    .isoCode,
                            itemBuilder: (Country country) => SizedBox(
                              height: width * 0.14,
                              width: (width - 24) * 0.2,
                              child: FittedBox(
                                child: Row(
                                  children: <Widget>[
                                    CountryPickerUtils.getDefaultFlagImage(
                                        country),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(country.currencyCode.toString()),
                                  ],
                                ),
                              ),
                            ),
                            onValuePicked: (Country? country) =>
                                controller.setTransactionCurrencey(
                                    currencey: country != null
                                        ? country.currencyCode ?? ''
                                        : ''),
                          ),
                        ],
                      ),
                    ),
                    if (controller.transactionType !=
                        TransactionType.transfer) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: DropdownMenu(
                          trailingIcon: FittedBox(
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.plus,
                              color: Colors.grey.shade600,
                              click: () {
                                WoltModalSheet.show(
                                  onModalDismissedWithBarrierTap: () =>
                                      controller.resetModal(back: true),
                                  onModalDismissedWithDrag: () =>
                                      controller.resetModal(),
                                  context: context,
                                  modalTypeBuilder: (context) =>
                                      WoltModalType.bottomSheet,
                                  pageListBuilder: (modalSheetContext) {
                                    return [
                                      modalPage(
                                        icon: const FaIcon(
                                            FontAwesomeIcons.xmark),
                                        leadingButtonFunction: () =>
                                            controller.resetModal(back: true),
                                        context: modalSheetContext,
                                        title: 'addcat'.tr,
                                        child: AddCategory(
                                          width: width,
                                          isNew: true,
                                        ),
                                        button: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: ButtonWidget(
                                            isIos: controller.isIos,
                                            textSize: 16,
                                            type: ButtonType.raised,
                                            onClick: () =>
                                                controller.addCatagoryButton(
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
                                            text: 'addcat'.tr,
                                          ),
                                        ),
                                      ),
                                    ];
                                  },
                                );
                              },
                            ),
                          ),
                          hintText: 'category'.tr,
                          expandedInsets: const EdgeInsets.all(0),
                          onSelected: (cat) =>
                              controller.setChosenCategory(category: cat ?? ''),
                          dropdownMenuEntries: List.generate(
                            controller.userModel.catagories.length,
                            (index) {
                              return DropdownMenuEntry(
                                trailingIcon: FittedBox(
                                  child: IconButtonPlatform(
                                    isIos: controller.isIos,
                                    icon: FontAwesomeIcons.penToSquare,
                                    color: Colors.grey.shade400,
                                    click: () {
                                      controller.setCatagory(
                                          cat: controller
                                              .userModel.catagories[index]);

                                      WoltModalSheet.show(
                                        onModalDismissedWithBarrierTap: () =>
                                            controller.resetModal(back: true),
                                        onModalDismissedWithDrag: () =>
                                            controller.resetModal(),
                                        context: context,
                                        modalTypeBuilder: (context) =>
                                            WoltModalType.bottomSheet,
                                        pageListBuilder: (modalSheetContext) {
                                          return [
                                            modalPage(
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.xmark),
                                              leadingButtonFunction: () =>
                                                  controller.resetModal(
                                                      back: true),
                                              context: modalSheetContext,
                                              title: 'editcat'.tr,
                                              child: AddCategory(
                                                width: width,
                                                isNew: false,
                                              ),
                                              button: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: ButtonWidget(
                                                  isIos: controller.isIos,
                                                  textSize: 16,
                                                  type: ButtonType.raised,
                                                  onClick: () =>
                                                      controller.updateCategory(
                                                          index: index),
                                                  color: mainColor,
                                                  height: MediaQuery.of(
                                                              modalSheetContext)
                                                          .size
                                                          .width *
                                                      0.125,
                                                  width: MediaQuery.of(
                                                          modalSheetContext)
                                                      .size
                                                      .width,
                                                  text: 'editcat'.tr,
                                                ),
                                              ),
                                            ),
                                          ];
                                        },
                                      );
                                    },
                                  ),
                                ),
                                label:
                                    controller.userModel.catagories[index].name,
                                value:
                                    controller.userModel.catagories[index].name,
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: DropdownMenu(
                          enabled: controller.chosenCategory != '',
                          hintText: 'subcat'.tr,
                          expandedInsets: const EdgeInsets.all(0),
                          dropdownMenuEntries: List.generate(
                            controller.chosenCategory != ''
                                ? controller.userModel.catagories
                                    .where((element) =>
                                        element.name ==
                                        controller.chosenCategory)
                                    .firstWhere((element) =>
                                        element.name ==
                                        controller.chosenCategory)
                                    .subCatagories
                                    .length
                                : 0,
                            (index) {
                              Catagory? catagory =
                                  controller.chosenCategory == ''
                                      ? null
                                      : controller.userModel.catagories
                                          .where((element) =>
                                              element.name ==
                                              controller.chosenCategory)
                                          .firstWhere((element) =>
                                              element.name ==
                                              controller.chosenCategory);
                              return DropdownMenuEntry(
                                label: catagory!.subCatagories[index],
                                value: catagory.subCatagories[index],
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: DropdownMenu(
                          trailingIcon: FittedBox(
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.plus,
                              color: Colors.grey.shade600,
                              click: () {},
                            ),
                          ),
                          hintText: 'wallet'.tr,
                          expandedInsets: const EdgeInsets.all(0),
                          dropdownMenuEntries: List.generate(
                            controller.userModel.wallets.length,
                            (index) {
                              return DropdownMenuEntry(
                                trailingIcon: FittedBox(
                                  child: IconButtonPlatform(
                                    isIos: controller.isIos,
                                    icon: FontAwesomeIcons.penToSquare,
                                    color: Colors.grey.shade400,
                                    click: () {},
                                  ),
                                ),
                                label: controller.userModel.wallets[index].name,
                                value: controller.userModel.wallets[index].name,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    if (controller.transactionType ==
                        TransactionType.transfer) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: DropdownMenu(
                          trailingIcon: FittedBox(
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.plus,
                              color: Colors.grey.shade600,
                              click: () {},
                            ),
                          ),
                          hintText: 'fromwallet'.tr,
                          expandedInsets: const EdgeInsets.all(0),
                          dropdownMenuEntries: List.generate(
                            controller.userModel.wallets.length,
                            (index) {
                              return DropdownMenuEntry(
                                label: controller.userModel.wallets[index].name,
                                value: controller.userModel.wallets[index].name,
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: DropdownMenu(
                          trailingIcon: FittedBox(
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.plus,
                              color: Colors.grey.shade600,
                              click: () {},
                            ),
                          ),
                          hintText: 'towallet'.tr,
                          expandedInsets: const EdgeInsets.all(0),
                          dropdownMenuEntries: List.generate(
                            controller.userModel.wallets.length,
                            (index) {
                              return DropdownMenuEntry(
                                label: controller.userModel.wallets[index].name,
                                value: controller.userModel.wallets[index].name,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: InputWidget(
                        hint: 'note'.tr,
                        maxLines: 5,
                        height: width * 0.25,
                        width: width,
                        active: controller.commentActive,
                        controller: controller.commentController,
                        node: controller.commentNodee,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: ButtonWidget(
                        width: width,
                        height: width * 0.125,
                        isIos: false,
                        text: 'thing',
                        textSize: 16,
                        type: ButtonType.raised,
                        onClick: () {},
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
