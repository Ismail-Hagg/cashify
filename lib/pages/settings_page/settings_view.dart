import 'package:cashify/pages/settings_page/settings_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/countries.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/avatar_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/dialog_widget.dart';
import 'package:cashify/widgets/setting_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: CustomText(
          text: 'settings'.tr,
          color: mainColor,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return GetBuilder<SettingsController>(
            init: Get.find<SettingsController>(),
            builder: (controller) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16),
                    child: Container(
                      width: width,
                      height: width * 0.3,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade400, blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: width * 0.3,
                            width: (width - 24) * 0.3,
                            child: Center(
                              child: Avatar(
                                borderColor: oilColor,
                                type: controller.userModel.localImage
                                    ? controller.imageExists(
                                        link: controller.userModel.localPath,
                                      )
                                        ? AvatarType.local
                                        : AvatarType.none
                                    : controller.userModel.onlinePath == ''
                                        ? AvatarType.none
                                        : AvatarType.online,
                                height: width * 0.25,
                                width: (width - 24) * 0.25,
                                link: controller.userModel.localImage
                                    ? controller.userModel.localPath
                                    : controller.userModel.onlinePath,
                                border: true,
                                shadow: false,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: width * 0.3,
                            width: (width - 24) * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: controller.userModel.username,
                                  color: mainColor,
                                  size: 18,
                                  weight: FontWeight.w600,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomText(
                                  text: controller.userModel.email != ''
                                      ? controller.userModel.email
                                      : controller.userModel.phoneNumber != ''
                                          ? controller.userModel.phoneNumber
                                          : '',
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      width: width,
                      height: width * 1.2,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade400, blurRadius: 5)
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SettingList(
                              backColor: backgroundColor,
                              color: mainColor,
                              action: () => controller.showDialog(
                                child: DialogWidget(
                                  title: 'userchange'.tr,
                                  content: TextField(
                                    autofocus: true,
                                    controller: controller.editingController,
                                  ),
                                  ios: controller.isIos,
                                  action: () => controller.changeUsername(),
                                ),
                              ),
                              icon: FontAwesomeIcons.user,
                              loading: controller.callsLoading,
                              trailing: controller.userModel.username,
                              title: 'userchange'.tr,
                            ),
                            SettingList(
                              backColor: backgroundColor,
                              color: mainColor,
                              action: () => controller.showDialog(
                                child: DialogWidget(
                                  kill: true,
                                  title: 'currchange'.tr,
                                  ios: controller.isIos,
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children:
                                          List.generate(codes.length, (index) {
                                        String name =
                                            countries[codes[index]]!['name']
                                                .toString();

                                        String sign =
                                            countries[codes[index]]!['symbol']
                                                .toString();

                                        String code =
                                            countries[codes[index]]!['code']
                                                .toString();
                                        bool chosen = code ==
                                            controller
                                                .userModel.defaultCurrency;
                                        return ListTile(
                                          enabled: chosen == false,
                                          title: CustomText(
                                            text: name,
                                            color: chosen ? mainColor : null,
                                          ),
                                          trailing: CustomText(
                                            text: sign,
                                            color: chosen ? mainColor : null,
                                          ),
                                          onTap: () => controller
                                              .changeCuerrancy(code: code),
                                        );
                                      }),
                                    ),
                                  ),
                                  action: () {},
                                ),
                              ),
                              icon: FontAwesomeIcons.moneyBill,
                              loading: controller.callsLoading,
                              trailing: controller.userModel.defaultCurrency,
                              title: 'currchange'.tr,
                            ),
                            SettingList(
                              backColor: backgroundColor,
                              color: mainColor,
                              action: () => controller.changeLanguage(),
                              icon: FontAwesomeIcons.language,
                              loading: controller.callsLoading,
                              trailing:
                                  controller.userModel.language.substring(0, 2),
                              title: 'langchange'.tr,
                            ),
                            SettingList(
                              loadingPossible: true,
                              backColor: backgroundColor,
                              color: mainColor,
                              action: () => controller.getApiCount(),
                              icon: FontAwesomeIcons.wifi,
                              loading: controller.callsLoading,
                              trailing: controller.calls.toString(),
                              title: 'remaincall'.tr,
                            ),
                            SettingList(
                              backColor: backgroundColor,
                              color: mainColor,
                              action: () {},
                              icon: FontAwesomeIcons.info,
                              loading: controller.callsLoading,
                              trailing: '',
                              title: 'about'.tr,
                            ),
                            SettingList(
                              backColor: backgroundColor,
                              color: mainColor,
                              action: () => controller.showDialog(
                                child: DialogWidget(
                                  title: 'logout'.tr,
                                  ios: controller.isIos,
                                  action: () => controller.dialogOut(),
                                ),
                              ),
                              icon: FontAwesomeIcons.arrowRightFromBracket,
                              loading: controller.callsLoading,
                              trailing: '',
                              title: 'logout'.tr,
                            ),
                          ],
                        ),
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
