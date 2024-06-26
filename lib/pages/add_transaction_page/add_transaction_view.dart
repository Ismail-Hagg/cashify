import 'package:cashify/data_models/category_data_model.dart';
import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/pages/add_transaction_page/add_transaction_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
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
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddTransactionController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.5,
        centerTitle: true,
        title: CustomText(
          text: Get.find<AddTransactionController>().newTransaction
              ? 'transadd'.tr
              : 'edittransaction'.tr,
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
                        if (controller.newTransaction) ...[
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
                        ]
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
                                type: TransactionType.values[index],
                              ),
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
                                        controller.transactionCurrency)
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
                                    CustomText(
                                      text: country.currencyCode.toString(),
                                    ),
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
                          onSelected: (val) => controller.reload(),
                          trailingIcon: FittedBox(
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.plus,
                              color: Colors.grey.shade600,
                              click: () => showModal(
                                dissBarr: () =>
                                    controller.resetModal(back: true),
                                dissDrag: () => controller.resetModal(),
                                xFunction: () =>
                                    controller.resetModal(back: true),
                                context: context,
                                title: 'addcat'.tr,
                                // add category modal
                                child: GetBuilder<AddTransactionController>(
                                  init: Get.find<AddTransactionController>(),
                                  builder: (controller) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: InputWidget(
                                          height: width * 0.15,
                                          width: width,
                                          active: controller.catNameActive,
                                          controller:
                                              controller.catAddController,
                                          node: controller.catAddNode,
                                          hint: 'category'.tr,
                                          action: TextInputAction.next,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: InputWidget(
                                          height: width * 0.15,
                                          width: width,
                                          active: controller.subCatActive,
                                          controller:
                                              controller.subCatAddController,
                                          node: controller.subCatNode,
                                          hint: 'subcat'.tr,
                                          maxLines: 1,
                                          onSub: (str) => controller
                                              .subCategorySubmit(sub: str),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: List.generate(
                                            controller.subcats.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Chip(
                                                onDeleted: () => controller
                                                    .subDelete(index: index),
                                                label: CustomText(
                                                    text: controller
                                                        .subcats[index]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            ButtonWidget(
                                              isIos: controller.isIos,
                                              textSize: 16,
                                              type: ButtonType.text,
                                              onClick: () => controller
                                                  .pickIcon(context: context),
                                              text: '${'icon'.tr} : ',
                                            ),
                                            controller.catIcon != null
                                                ? Icon(controller.catIcon,
                                                    size: 30)
                                                : Container()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            ButtonWidget(
                                              isIos: controller.isIos,
                                              textSize: 16,
                                              type: ButtonType.text,
                                              onClick: () =>
                                                  controller.pickColor(
                                                widget: AlertDialog(
                                                  title: Text('catcolor'.tr),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ColorPicker(
                                                      pickerColor: Colors.red,
                                                      onColorChanged: (col) =>
                                                          controller
                                                              .changeColor(
                                                                  color: col),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    ButtonWidget(
                                                      type: ButtonType.text,
                                                      textSize: 12,
                                                      isIos: controller.isIos,
                                                      text: 'ok'.tr,
                                                      onClick: () => controller
                                                          .closeColorPicker(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              text: '${'color'.tr} : ',
                                            ),
                                            Container(
                                              height: width * 0.1,
                                              width: width * 0.1,
                                              decoration: BoxDecoration(
                                                color: controller.catColor,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                button: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ButtonWidget(
                                    isIos: controller.isIos,
                                    textSize: 16,
                                    type: ButtonType.raised,
                                    onClick: () => controller.addCatagoryButton(
                                        isUpdate: false,
                                        index: 0,
                                        context: context),
                                    color: mainColor,
                                    height: width * 0.125,
                                    width: width,
                                    text: 'addcat'.tr,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          menuHeight: width * 0.75,
                          hintText: 'category'.tr,
                          expandedInsets: const EdgeInsets.all(0),
                          controller: controller.catController,
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

                                      showModal(
                                        dissBarr: () =>
                                            controller.resetModal(back: true),
                                        dissDrag: () => controller.resetModal(),
                                        xFunction: () =>
                                            controller.resetModal(back: true),
                                        context: context,
                                        title: 'addcat'.tr,
                                        // add category modal
                                        child: GetBuilder<
                                            AddTransactionController>(
                                          init: Get.find<
                                              AddTransactionController>(),
                                          builder: (controller) => Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: InputWidget(
                                                  height: width * 0.15,
                                                  width: width,
                                                  active:
                                                      controller.catNameActive,
                                                  controller: controller
                                                      .catAddController,
                                                  node: controller.catAddNode,
                                                  hint: 'category'.tr,
                                                  action: TextInputAction.next,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: InputWidget(
                                                  height: width * 0.15,
                                                  width: width,
                                                  active:
                                                      controller.subCatActive,
                                                  controller: controller
                                                      .subCatAddController,
                                                  node: controller.subCatNode,
                                                  hint: 'subcat'.tr,
                                                  maxLines: 1,
                                                  onSub: (str) => controller
                                                      .subCategorySubmit(
                                                          sub: str),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: List.generate(
                                                    controller.subcats.length,
                                                    (index) => Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0),
                                                      child: Chip(
                                                        onDeleted: () =>
                                                            controller
                                                                .subDelete(
                                                                    index:
                                                                        index),
                                                        label: CustomText(
                                                            text: controller
                                                                    .subcats[
                                                                index]),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    ButtonWidget(
                                                      isIos: controller.isIos,
                                                      textSize: 16,
                                                      type: ButtonType.text,
                                                      onClick: () =>
                                                          controller.pickIcon(
                                                              context: context),
                                                      text: '${'icon'.tr} : ',
                                                    ),
                                                    controller.catIcon != null
                                                        ? Icon(
                                                            controller.catIcon,
                                                            size: 30)
                                                        : Container()
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    ButtonWidget(
                                                      isIos: controller.isIos,
                                                      textSize: 16,
                                                      type: ButtonType.text,
                                                      onClick: () =>
                                                          controller.pickColor(
                                                        widget: AlertDialog(
                                                          title: Text(
                                                              'catcolor'.tr),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: ColorPicker(
                                                              pickerColor:
                                                                  Colors.red,
                                                              onColorChanged:
                                                                  (col) => controller
                                                                      .changeColor(
                                                                          color:
                                                                              col),
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            ButtonWidget(
                                                              type: ButtonType
                                                                  .text,
                                                              textSize: 12,
                                                              isIos: controller
                                                                  .isIos,
                                                              text: 'ok'.tr,
                                                              onClick: () =>
                                                                  controller
                                                                      .closeColorPicker(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      text: '${'color'.tr} : ',
                                                    ),
                                                    Container(
                                                      height: width * 0.1,
                                                      width: width * 0.1,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            controller.catColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        button: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: ButtonWidget(
                                            isIos: controller.isIos,
                                            textSize: 16,
                                            type: ButtonType.raised,
                                            onClick: () =>
                                                controller.addCatagoryButton(
                                                    isUpdate: true,
                                                    index: index,
                                                    context: context),
                                            color: mainColor,
                                            height: width * 0.125,
                                            width: width,
                                            text: 'editcat'.tr,
                                          ),
                                        ),
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
                          menuHeight: width * 0.75,
                          enabled: controller.catController.text != '',
                          controller: controller.subcatController,
                          hintText: 'subcat'.tr,
                          expandedInsets: const EdgeInsets.all(0),
                          dropdownMenuEntries: List.generate(
                            controller.catController.text != ''
                                ? controller.userModel.catagories
                                    .firstWhere(
                                      (element) =>
                                          element.name ==
                                          controller.catController.text,
                                      orElse: () => CatagoryModel(
                                          name:
                                              '${controller.catController.text} - ${'notsaved'.tr}',
                                          subCatagories: [],
                                          icon:
                                              '${Icons.add.codePoint}-${Icons.add.fontFamily}',
                                          color: Colors.transparent.value),
                                    )
                                    .subCatagories
                                    .length
                                : 0,
                            (index) {
                              CatagoryModel? catagory = controller
                                          .catController.text ==
                                      ''
                                  ? null
                                  : controller.userModel.catagories.firstWhere(
                                      (element) =>
                                          element.name ==
                                          controller.catController.text,
                                      orElse: () => CatagoryModel(
                                          name:
                                              '${controller.catController.text} - ${'notsaved'.tr}',
                                          subCatagories: [],
                                          icon:
                                              '${Icons.add.codePoint}-${Icons.add.fontFamily}',
                                          color: Colors.transparent.value),
                                    );
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
                          controller: controller.chosenWallet,
                          trailingIcon: FittedBox(
                            child: IconButtonPlatform(
                              isIos: controller.isIos,
                              icon: FontAwesomeIcons.plus,
                              color: Colors.grey.shade600,
                              click: () {
                                showModal(
                                  xFunction: () =>
                                      controller.resetWalletModel(back: true),
                                  dissBarr: () =>
                                      controller.resetWalletModel(back: true),
                                  dissDrag: () =>
                                      controller.resetWalletModel(back: true),
                                  context: context,
                                  title: 'addwallet'.tr,
                                  child: GetBuilder<AddTransactionController>(
                                    init: Get.find<AddTransactionController>(),
                                    builder: (controller) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: InputWidget(
                                            height: width * 0.15,
                                            width: width,
                                            active: controller.walletNameActive,
                                            controller:
                                                controller.walletNameController,
                                            node: controller.walletNameNode,
                                            hint: 'walletname'.tr,
                                            action: TextInputAction.next,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InputWidget(
                                                formatter: [
                                                  // Allow Decimal Number With Precision of 2 Only
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(r'^\d*\.?\d{0,2}'),
                                                  ),
                                                ],
                                                type: const TextInputType
                                                    .numberWithOptions(
                                                    decimal: true),
                                                height: width * 0.14,
                                                width: (width - 24) * 0.7,
                                                active: controller
                                                    .walletAmountActive,
                                                hint: 'amount'.tr,
                                                node:
                                                    controller.walletAmountNode,
                                                controller: controller
                                                    .walletAmountController,
                                                enable: false,
                                              ),
                                              CountryPickerDropdown(
                                                initialValue: CountryPickerUtils
                                                    .getCountryByCurrencyCode(
                                                  controller.walletCurrency,
                                                ).isoCode,
                                                itemBuilder:
                                                    (Country country) =>
                                                        SizedBox(
                                                  height: width * 0.14,
                                                  width: (width - 24) * 0.2,
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
                                                onValuePicked:
                                                    (Country? country) =>
                                                        controller
                                                            .setWalletCurrency(
                                                  currency: country != null
                                                      ? country.currencyCode ??
                                                          ''
                                                      : '',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  button: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ButtonWidget(
                                      isIos: controller.isIos,
                                      textSize: 16,
                                      type: ButtonType.raised,
                                      onClick: () => controller.addWallet(
                                          context: context),
                                      color: mainColor,
                                      height: width * 0.125,
                                      width: width,
                                      text: 'addwallet'.tr,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          hintText: 'wallet'.tr,
                          menuHeight: width * 0.75,
                          expandedInsets: const EdgeInsets.all(0),
                          dropdownMenuEntries: List.generate(
                            controller.userModel.wallets.length,
                            (index) {
                              return DropdownMenuEntry(
                                label: controller.userModel.wallets[index].name,
                                value: controller.userModel.wallets[index].name,
                                trailingIcon: IconButtonPlatform(
                                  isIos: controller.isIos,
                                  icon: FontAwesomeIcons.trashCan,
                                  size: 16,
                                  color: mainColor,
                                  click: () => controller.deleteWallet(
                                      wallet:
                                          controller.userModel.wallets[index],
                                      context: context),
                                ),
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
                          controller: controller.fromWalletTransaction,
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
                          controller: controller.toWalletTransaction,
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
                        text: controller.newTransaction
                            ? 'transadd'.tr
                            : 'edittransaction'.tr,
                        textSize: 16,
                        type: ButtonType.raised,
                        onClick: () => controller.transactionOperation(
                            update: !controller.newTransaction,
                            context: context),
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
