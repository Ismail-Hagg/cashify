import 'package:cashify/pages/add_transaction_page/add_transaction_controller.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddWallet extends StatelessWidget {
  final double width;
  const AddWallet({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTransactionController>(
      init: Get.find<AddTransactionController>(),
      builder: (controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InputWidget(
              height: width * 0.15,
              width: width,
              active: controller.walletNameActive,
              controller: controller.walletNameController,
              node: controller.walletNameNode,
              hint: 'walletname'.tr,
              action: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InputWidget(
                  formatter: [
                    // Allow Decimal Number With Precision of 2 Only
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  type: const TextInputType.numberWithOptions(decimal: true),
                  height: width * 0.14,
                  width: (width - 24) * 0.7,
                  active: controller.walletAmountActive,
                  hint: 'amount'.tr,
                  node: controller.walletAmountNode,
                  controller: controller.walletAmountController,
                  enable: false,
                ),
                CountryPickerDropdown(
                  initialValue: CountryPickerUtils.getCountryByCurrencyCode(
                    controller.walletCurrency,
                  ).isoCode,
                  itemBuilder: (Country country) => SizedBox(
                    height: width * 0.14,
                    width: (width - 24) * 0.2,
                    child: FittedBox(
                      child: Row(
                        children: <Widget>[
                          CountryPickerUtils.getDefaultFlagImage(country),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(country.currencyCode.toString()),
                        ],
                      ),
                    ),
                  ),
                  onValuePicked: (Country? country) =>
                      controller.setWalletCurrency(
                    currency: country != null ? country.currencyCode ?? '' : '',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
