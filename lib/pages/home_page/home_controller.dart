import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transaction_view.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_body.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_view.dart';
import 'package:cashify/pages/settings_page/settings_controller.dart';
import 'package:cashify/pages/settings_page/settings_view.dart';
import 'package:cashify/services/user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeController extends GetxController {
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  final List<Widget> _pages = const [
    HomeBody(),
    AllTransactionsView(),
    MonthSettingView(),
    SettingsView()
  ];
  List<Widget> get pages => _pages;

  final Map<String, List<String>> _test = {
    'cash': ['40', 'SAR'],
    'ur pay': [
      '4.50',
      'SAR',
    ],
    'stc pay': [
      '102.45',
      'USD',
    ],
    'al-rajhi bank': [
      '300',
      'EUR',
    ],
    'some other bank': ['40000', 'SAR']
  };
  Map<String, List<String>> get test => _test;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<GloableAuthController>().userModel;
  }

  // chcange page index
  void setPageIndex({required int pageIndex}) {
    _pageIndex = pageIndex;
    update();
    switch (pageIndex) {
      case 0:
        Get.delete<AllTransactionsController>();
        Get.delete<MonthSettingController>();
        Get.delete<SettingsController>();
        break;

      case 1:
        Get.delete<MonthSettingController>();
        Get.delete<SettingsController>();
        break;

      case 2:
        Get.delete<AllTransactionsController>();
        Get.delete<SettingsController>();
        break;

      case 3:
        Get.delete<AllTransactionsController>();
        Get.delete<MonthSettingController>();
        break;
      default:
    }
  }

  void checkContro() {
    print(
        'all transactions => ${Get.isRegistered<AllTransactionsController>()} ');
    print('month setting => ${Get.isRegistered<MonthSettingController>()} ');
    print('settings => ${Get.isRegistered<SettingsController>()} ');
  }

  // back button only kill app when on main login view
  void backButton() {
    if (_pageIndex == 0) {
      SystemNavigator.pop();
    } else {
      setPageIndex(pageIndex: 0);
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await UserData().deleteUser();
    Get.find<GloableAuthController>().update();
    Get.delete<HomeController>();
  }
}
