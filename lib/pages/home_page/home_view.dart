import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/add_category_widget.dart';
import 'package:cashify/widgets/add_transaction_widget.dart';
import 'package:cashify/widgets/modal_widget.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return PopScope(
      canPop: false,
      onPopInvoked: (val) => controller.backButton(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: GetBuilder<HomeController>(
            init: controller,
            builder: (control) => controller.pages[controller.pageIndex]),
        bottomNavigationBar: GetBuilder<HomeController>(
          init: Get.find<HomeController>(),
          builder: (controller) => StylishBottomBar(
            notchStyle: NotchStyle.circle,
            backgroundColor: forgroundColor,
            option: AnimatedBarOptions(
              iconSize: 18,
              barAnimation: BarAnimation.fade,
              iconStyle: IconStyle.animated,
              opacity: 0.3,
            ),
            items: [
              BottomBarItem(
                icon: const FaIcon(
                  FontAwesomeIcons.house,
                ),
                title: CustomText(
                  text: 'home'.tr,
                  size: 12,
                ),
                selectedColor: mainColor,
                selectedIcon: FaIcon(
                  FontAwesomeIcons.house,
                  color: mainColor,
                ),
              ),
              BottomBarItem(
                icon: const FaIcon(FontAwesomeIcons.moneyBills),
                title: CustomText(
                  isFit: true,
                  text: 'trans'.tr,
                  size: 12,
                ),
                selectedColor: mainColor,
                selectedIcon: FaIcon(
                  FontAwesomeIcons.moneyBills,
                  color: mainColor,
                ),
              ),
              BottomBarItem(
                icon: const FaIcon(FontAwesomeIcons.calendar),
                title: CustomText(
                  isFit: true,
                  text: 'mnthset'.tr,
                  size: 12,
                ),
                selectedColor: mainColor,
                selectedIcon: FaIcon(
                  FontAwesomeIcons.calendar,
                  color: mainColor,
                ),
              ),
              BottomBarItem(
                icon: const FaIcon(FontAwesomeIcons.gear),
                title: CustomText(
                  text: 'settings'.tr,
                  size: 12,
                ),
                selectedColor: mainColor,
                selectedIcon: FaIcon(
                  FontAwesomeIcons.gear,
                  color: mainColor,
                ),
              ),
            ],
            fabLocation: StylishBarFabLocation.center,
            hasNotch: true,
            currentIndex: controller.pageIndex,
            onTap: (index) => controller.setPageIndex(pageIndex: index),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: MediaQuery.of(context).size.width * 0.159,
          width: MediaQuery.of(context).size.width * 0.159,
          child: FloatingActionButton(
            backgroundColor: forgroundColor,
            onPressed: () {
              WoltModalSheet.show(
                onModalDismissedWithBarrierTap: () => controller.modalClosed(),
                onModalDismissedWithDrag: () => controller.modalClosed(),
                context: context,
                pageIndexNotifier: controller.modalIndex,
                modalTypeBuilder: (context) => WoltModalType.bottomSheet,
                pageListBuilder: (modalSheetContext) {
                  return [
                    modalPage(
                      icon: const FaIcon(FontAwesomeIcons.xmark),
                      leadingButtonFunction: () => controller
                          .modalLeadingButtonAction(context: modalSheetContext),
                      context: modalSheetContext,
                      title: 'transadd'.tr,
                      child: GestureDetector(
                        onTap: () =>
                            controller.dismissKeyboard(modalSheetContext),
                        child: AddTransaction(
                          width: MediaQuery.of(modalSheetContext).size.width,
                        ),
                      ),
                      button: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ButtonWidget(
                          isIos: controller.isIos,
                          textSize: 16,
                          type: ButtonType.raised,
                          onClick: () => controller.modalPageChange(
                              page: 1, context: modalSheetContext),
                          color: mainColor,
                          height: MediaQuery.of(modalSheetContext).size.width *
                              0.125,
                          width: MediaQuery.of(modalSheetContext).size.width,
                          text: 'add'.tr,
                        ),
                      ),
                    ),
                    modalPage(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                      leadingButtonFunction: () => controller
                          .modalLeadingButtonAction(context: modalSheetContext),
                      context: modalSheetContext,
                      title: 'addcat'.tr,
                      child: AddCategory(
                        width: MediaQuery.of(modalSheetContext).size.width,
                      ),
                      button: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ButtonWidget(
                          isIos: controller.isIos,
                          textSize: 16,
                          type: ButtonType.raised,
                          onClick: () => controller.modalPageChange(
                              page: 0, context: modalSheetContext),
                          color: mainColor,
                          height: MediaQuery.of(modalSheetContext).size.width *
                              0.125,
                          width: MediaQuery.of(modalSheetContext).size.width,
                          text: 'another one',
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: mainColor,
            ),
          ),
        ),
      ),
    );
  }
}
