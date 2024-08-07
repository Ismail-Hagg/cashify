import 'package:cashify/pages/add_transaction_page/add_transaction_view.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return PopScope(
      canPop: false,
      onPopInvoked: (val) => controller.backButton(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: GetBuilder<HomeController>(
            init: controller,
            builder: (control) => controller.pages[controller.pageIndex]),
        bottomNavigationBar: GetBuilder<HomeController>(
          init: Get.find<HomeController>(),
          builder: (controller) => StylishBottomBar(
            notchStyle: NotchStyle.circle,
            backgroundColor: whiteColor,
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
            backgroundColor: mainColor,
            onPressed: () {
              Get.to(() => const AddTransactionView(),
                  transition: Transition.native);
            },
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
