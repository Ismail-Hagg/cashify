import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/models/month_setting_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class MonthSettingController extends GetxController {
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  DateTime _date = DateTime.now();
  DateTime get date => _date;

  MonthSettingModel? _model;
  MonthSettingModel? get model => _model;

  final FirebaseService _firebaseService = FirebaseService();

  bool _loading = false;
  bool get loading => _loading;

  final TextEditingController _catController = TextEditingController();
  TextEditingController get catController => _catController;

  final TextEditingController _startController = TextEditingController();
  TextEditingController get startController => _startController;

  final TextEditingController _endController = TextEditingController();
  TextEditingController get endController => _endController;

  final TextEditingController _budgetController = TextEditingController();
  TextEditingController get budgetController => _budgetController;

  final TextEditingController _budgetAmount = TextEditingController();
  TextEditingController get budgetAmount => _budgetAmount;

  final TextEditingController _chosenCategoryController =
      TextEditingController();
  TextEditingController get chosenCategoryController =>
      _chosenCategoryController;

  final FocusNode _startNode = FocusNode();
  FocusNode get startNode => _startNode;

  final FocusNode _endNode = FocusNode();
  FocusNode get endNode => _endNode;

  final FocusNode _budgetNode = FocusNode();
  FocusNode get budgetNode => _budgetNode;

  bool _startActive = false;
  bool get startActive => _startActive;

  bool _endActive = false;
  bool get endActive => _endActive;

  bool _budgetActive = false;
  bool get budgetActive => _budgetActive;

  Catagory? _chodenCat;
  Catagory? get chodenCat => _chodenCat;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<GloableAuthController>().userModel;
    _startNode.addListener(_startListen);
    _endNode.addListener(_endListen);
    _budgetNode.addListener(_budgetListen);
    getData();
  }

  @override
  void onClose() {
    super.onClose();
    _startNode.removeListener(_startListen);
    _endNode.removeListener(_endListen);
    _budgetNode.removeListener(_budgetListen);
    _budgetNode.dispose();
    _budgetController.dispose();
    _startNode.dispose();
    _endNode.dispose();
    _startController.dispose();
    _endController.dispose();
    _chosenCategoryController.dispose();
    _budgetAmount.dispose();
  }

  // set listeners
  void _startListen() {
    _startActive = _startNode.hasFocus;
    update();
    if (_startActive == false) {
      valsChanges(start: true);
    }
  }

  void _endListen() {
    _endActive = _endNode.hasFocus;
    update();
    if (_startActive == false) {
      valsChanges(start: false);
    }
  }

  void _budgetListen() {
    _budgetActive = _budgetNode.hasFocus;
    update();
  }

  // add budget item
  // apply yoda method instead of nested if statments
  void addBudget({required BuildContext context}) {
    if (_chodenCat != null && _budgetAmount.text.trim() != '') {
      if (_model != null) {
        if (_model!.budgetCat.contains(_chodenCat!.name)) {
          showToast(
            title: CustomText(text: 'infoadd'.tr),
            context: context,
            type: ToastificationType.error,
            isEng: _userModel.language == 'en_US',
          );
          return;
        } else {
          _model!.budgetCat.add(_chodenCat!.name);
          _model!.budgetVal.add(double.parse(_budgetAmount.text.trim()));
          _model!.catagory.add(_chodenCat as Catagory);
        }
      } else {
        _model = MonthSettingModel(
          walletInfo: [],
          budgetCat: [_chodenCat!.name],
          budgetVal: [double.parse(_budgetAmount.text.trim())],
          year: _date.year,
          month: _date.month,
          catagory: [_chodenCat as Catagory],
        );
      }
      Get.back();
      update();
      addOrUpdateMonthSetting();
    } else {
      showToast(
        title: CustomText(text: 'infoadd'.tr),
        context: context,
        type: ToastificationType.error,
        isEng: _userModel.language == 'en_US',
      );
    }
  }

  // delete budget item
  void budgetDeleteItem({required int index}) {
    _model!.budgetCat.removeAt(index);
    _model!.budgetVal.removeAt(index);
    _model!.catagory.removeAt(index);
    update();
    addOrUpdateMonthSetting();
  }

  // chose catagory
  void choseCategory({required String cat}) {
    if (cat != '') {
      int index =
          _userModel.catagories.indexWhere((element) => element.name == cat);
      _chodenCat = _userModel.catagories[index];
      update();
    }
  }

  // get month setting data
  void getData() async {
    _loading = true;
    _model = null;
    _startController.clear();
    _endController.clear();
    update();
    if (Get.find<HomeController>().monhtMap['${_date.year}-${_date.month}'] ==
        null) {
      await _firebaseService
          .getRecordDocu(
              userId: _userModel.userId,
              path: FirebasePaths.monthSetting.name,
              docId: '${_date.year}-${_date.month}')
          .then(
        (value) {
          if (value.exists) {
            MonthSettingModel item =
                MonthSettingModel.fromMap(value.data() as Map<String, dynamic>);
            _model = item;

            if (_catController.text.trim() != '') {
              changeWallet(wallet: _catController.text.trim());
            }
          }
          _loading = false;
          update();
        },
      );
    } else {
      _model =
          Get.find<HomeController>().monhtMap['${_date.year}-${_date.month}'];
      _loading = false;
      update();
    }
  }

  // add or update month setting
  void addOrUpdateMonthSetting() async {
    if (_model != null) {
      Get.find<HomeController>().monhtMap['${_date.year}-${_date.month}'] =
          _model!;
      await _firebaseService.addRecord(
        docPath: '${_date.year}-${_date.month}',
        path: FirebasePaths.monthSetting.name,
        userId: _userModel.userId,
        map: _model!.toMap(),
      );
      await Get.find<HomeController>().moneyNow().then(
            (value) => Get.find<HomeController>().update(),
          );
    }
  }

  // change wallet
  void changeWallet({required String wallet}) {
    if (_model != null) {
      int index = _model!.walletInfo.indexWhere(
        (element) => element.wallet == wallet,
      );

      if (index != -1) {
        _startController.text = Get.find<HomeController>()
            .walletAmount(amount: _model!.walletInfo[index].start);
        _endController.text = Get.find<HomeController>()
            .walletAmount(amount: _model!.walletInfo[index].end);
      } else {
        _startController.clear();
        _endController.clear();
      }
    }
    update();
  }

  // after changing start end values
  void valsChanges({required bool start}) {
    TextEditingController controll = start ? _startController : _endController;
    if (controll.text.trim() != '' && _catController.text.trim() != '') {
      String curr = _userModel.wallets
          .firstWhere((element) => element.name == _catController.text.trim())
          .currency;
      if (_model == null) {
        _model = MonthSettingModel(
          walletInfo: [
            WalletInfo(
                currency: curr,
                opSum: 0,
                wallet: _catController.text.trim(),
                start: start ? double.parse(controll.text.trim()) : 0,
                end: start == false ? double.parse(controll.text.trim()) : 0)
          ],
          budgetCat: [],
          budgetVal: [],
          year: _date.year,
          month: _date.month,
          catagory: [],
        );
      } else {
        int index = _model!.walletInfo.indexWhere(
            (element) => element.wallet == _catController.text.trim());

        if (index != -1) {
          _model!.walletInfo[index] = WalletInfo(
            currency: curr,
            opSum: _model!.walletInfo[index].opSum,
            wallet: _catController.text.trim(),
            start: start
                ? double.parse(controll.text.trim())
                : _model!.walletInfo[index].start,
            end: start == false
                ? double.parse(controll.text.trim())
                : _model!.walletInfo[index].start,
          );
        } else {
          _model!.walletInfo.add(
            WalletInfo(
              currency: curr,
              opSum: 0,
              wallet: _catController.text.trim(),
              start: start ? double.parse(controll.text.trim()) : 0,
              end: start == false ? double.parse(controll.text.trim()) : 0,
            ),
          );
        }
      }
      addOrUpdateMonthSetting();
    }
  }

  // change month
  void changeMonth({required BuildContext context}) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          currentDate: _date, calendarType: CalendarDatePicker2Type.single),
      dialogSize: const Size(325, 400),
      value: [_date],
      borderRadius: BorderRadius.circular(15),
    ).then(
      (value) {
        if (value != null &&
            value.isNotEmpty &&
            value[0] != null &&
            (value[0]!.year != _date.year || value[0]!.month != _date.month)) {
          _date = value[0] as DateTime;
          getData();
        }
      },
    );
  }
}
