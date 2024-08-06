import 'dart:io';
import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/pages/settings_page/repository.dart';
import 'package:cashify/services/currency_exchange_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsController extends GetxController {
  final SettingRepository _repo = SettingRepository();

  final UserDataModel _userModel = Get.find<HomeController>().userModel;
  UserDataModel get userModel => _userModel;

  final _homeController = Get.find<HomeController>();

  final bool _isIos = Get.find<HomeController>().isIos;
  bool get isIos => _isIos;

  final GloableAuthController _authControlleer = Get.find();

  late Box<UserDataModel> box;

  UserDataModel? newMod;

  int _calls = 0;
  int get calls => _calls;

  bool _callsLoading = false;
  bool get callsLoading => _callsLoading;

  final TextEditingController _editingController = TextEditingController();
  TextEditingController get editingController => _editingController;

  @override
  void onInit() {
    super.onInit();
    getApiCount();
  }

  // get remaining api calls count
  void getApiCount() async {
    _callsLoading = true;
    update();
    await MoneyExchange().getCalls().then((value) {
      _calls = value;
      _callsLoading = false;
      update();
    });
  }

  // change username
  void changeUsername() async {
    String newUser = _editingController.text.trim();
    if (newUser == '' || newUser == _userModel.username) {
      Get.back();
      return;
    }

    Get.back();
    _userModel.username = newUser;
    update();
    _homeController.userModel.username = newUser;

    await saveUserData();
  }

  // change cuerrancy
  void changeCuerrancy({required String code}) async {
    Get.back();

    if (_calls > 0) {
      _userModel.defaultCurrency = code;
      _homeController.userModel.defaultCurrency = code;
      update();
      _homeController.reload();
      await saveUserData();
    }
  }

  // change language
  void changeLanguage() async {
    String lanOne = _userModel.language.substring(0, 2) == 'en' ? 'ar' : 'en';
    String lanTwo = lanOne == 'en' ? 'US' : 'SA';
    Get.updateLocale(Locale(lanOne, lanTwo)).then((value) async {
      _userModel.language = '${lanOne}_$lanTwo';
      _homeController.userModel.language = '${lanOne}_$lanTwo';

      await saveUserData();
    });
  }

  // save user data locally and in backend
  Future<void> saveUserData() async {
    await _repo.changeUserDataLocally(model: _userModel).then(
          (value) async => await _repo.changeUserDataBack(user: _userModel),
        );
  }

  // show dialog
  void showDialog({required Widget child}) {
    Get.dialog(child);
  }

  // logout
  void logout() async {
    String userId = _userModel.userId;
    await _repo.signOut();
    Get.delete<HomeController>();
    Get.delete<AllTransactionsController>();
    Get.delete<MonthSettingController>();
    _authControlleer.reload();
    await _repo.wipeAllData().then((value) => null);
    await syncOut(userId: userId);
    Get.delete<SettingsController>();
  }

  // logout from dialog
  void dialogOut() {
    Get.back();
    logout();
  }

  // set user isSync field to false when user logs out fo that when he login again data is downloaded and saved
  Future<void> syncOut({required String userId}) async {
    await _repo.changeUserData(userId: userId);
  }

  // check if image exists locally
  bool imageExists({required String link}) {
    return File(link).existsSync();
  }
}
