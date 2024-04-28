import 'dart:math';

import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/models/fake_data.dart';
import 'package:cashify/models/transaction_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transaction_view.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_body.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_view.dart';
import 'package:cashify/pages/settings_page/settings_controller.dart';
import 'package:cashify/pages/settings_page/settings_view.dart';
import 'package:cashify/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  bool _loading = false;
  bool get loading => _loading;

  late AnimationController _loadingController;
  AnimationController get loadingController => _loadingController;

  final List<Widget> _pages = const [
    HomeBody(),
    AllTransactionsView(),
    MonthSettingView(),
    SettingsView()
  ];
  List<Widget> get pages => _pages;

  int _trackNum = 0;
  int get trackNum => _trackNum;

  final Map<String, int> _track = {
    'thismnth'.tr: 0,
    'lastmnth'.tr: 1,
    'thisyear'.tr: 2,
    'custom'.tr: 3
  };
  Map<String, int> get track => _track;

  String _chosenTime = 'thismnth'.tr;
  String get chosenTime => _chosenTime;

  List<Catagory> _catList = [];
  List<Catagory> get catList => _catList;

  double _income = 0.0;
  double get income => _income;

  double _expense = 0.0;
  double get expense => _expense;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<GloableAuthController>().userModel;
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void onClose() {
    super.onClose();
    _loadingController.dispose();
  }

  // loading animation
  void loadinganimation() {
    _loading = !_loading;
    if (_loading) {
      _loadingController.repeat();
    } else {
      _loadingController.stop();
    }
    update();
  }

  void calculate() {
    loadinganimation();
    _catList = [];
    for (var i = 0; i < fakeData.length; i++) {
      Transaction transaction = Transaction.fromMap(fakeData[i]);
      if (_catList.isEmpty || _catList[i].name == transaction.catagory) {
        _catList.add(Catagory(
            name: transaction.catagory,
            subCatagories: [transaction.subCatagory],
            icon: 'car',
            color: generateRandomColor(),
            transactions: [transaction]));
      } else {
        for (var i = 0; i < _catList.length; i++) {
          if (_catList[i].name == transaction.catagory) {
            _catList[i].transactions != null
                ? print('up and runnung')
                : print('thie thing is null');
            //     ? _catList[i].transactions!.add(transaction)
            //     : _catList[i].transactions = [transaction];
          } else {
            print(_catList[i].name);
            print(transaction.catagory);
            // _catList.add(Catagory(
            //     name: transaction.catagory,
            //     subCatagories: [transaction.subCatagory],
            //     icon: 'car',
            //     color: generateRandomColor(),
            //     transactions: [transaction]));
          }
        }
      }
    }
    print(_catList.length);
    loadinganimation();
  }

  // generate random color
  Color generateRandomColor() {
    final random = math.Random();
    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);
    final a = 255.0; // Set alpha to fully opaque
    return Color.fromRGBO(r, g, b, a);
  }

  // format the amount
  String humanFormat(double number) {
    final formatter = NumberFormat.compact(
        locale: _userModel.language); // US locale for common abbreviations
    return formatter.format(number);
  }

  // remove zeros from double when showing amounts of wallets
  String walletAmount({required dynamic amount}) {
    int post = amount.runtimeType == double
        ? int.parse(amount.toString().split('.')[1])
        : 0;
    int pre = amount.runtimeType == double
        ? int.parse(amount.toString().split('.')[0])
        : amount;
    if (post == 0) {
      return pre.toString();
    } else {
      return amount.toString();
    }
  }

  // change the tracking of the chosen time period
  void changeTimePeriod({required String time}) {
    if (_trackNum != _track[time] as int) {
      _trackNum = _track[time] as int;
      _chosenTime = time;
      update();
    }
  }

  // check if the local image works
  void imageCheck() {}

  // chcange page index
  void setPageIndex({required int pageIndex}) {
    if (_pageIndex != pageIndex) {
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
  }

  // back button only kill app when on main login view
  void backButton() {
    if (_pageIndex == 0) {
      SystemNavigator.pop();
    } else {
      setPageIndex(pageIndex: 0);
    }
  }
}
