import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/month_setting_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final FocusNode _startNode = FocusNode();
  FocusNode get startNode => _startNode;

  final FocusNode _endNode = FocusNode();
  FocusNode get endNode => _endNode;

  bool _startActive = false;
  bool get startActive => _startActive;

  bool _endActive = false;
  bool get endActive => _endActive;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<GloableAuthController>().userModel;
    _startNode.addListener(_startListen);
    _endNode.addListener(_endListen);
    getData();
  }

  @override
  void onClose() {
    super.onClose();
    _startNode.removeListener(_startListen);
    _endNode.removeListener(_endListen);

    _startNode.dispose();
    _endNode.dispose();
  }

  // set listeners
  void _startListen() {
    _startActive = _startNode.hasFocus;
    update();
  }

  void _endListen() {
    _endActive = _endNode.hasFocus;
    update();
  }

  // get month setting data
  void getData() async {
    _loading = true;
    _model = null;
    update();
    _firebaseService
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
        }
        _loading = false;
        update();
      },
    );
  }

  // add or update month setting
  void addOrUpdateMonthSetting() async {
    if (_model != null) {
      await _firebaseService.addRecord(
        docPath: '${_date.year}-${_date.month}',
        path: FirebasePaths.monthSetting.name,
        userId: _userModel.userId,
        map: _model!.toMap(),
      );
    }
  }

  // after changing start end values
  void valsChanges({required bool start}) {
    TextEditingController controll = start ? _startController : _endController;
    if (controll.text.trim() != '' && _catController.text.trim() != '') {
      if (_model == null) {
        _model = MonthSettingModel(
          walletInfo: [
            WalletInfo(
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
            wallet: _catController.text.trim(),
            start: start ? double.parse(controll.text.trim()) : 0,
            end: start == false ? double.parse(controll.text.trim()) : 0,
          );
        } else {
          _model!.walletInfo.add(
            WalletInfo(
              wallet: _catController.text.trim(),
              start: start ? double.parse(controll.text.trim()) : 0,
              end: start == false ? double.parse(controll.text.trim()) : 0,
            ),
          );
        }
      }
    }
  }

  // change month
  void changeMonth({required BuildContext context}) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          //calendarViewMode: DatePickerMode.year,
          currentDate: _date,
          calendarType: CalendarDatePicker2Type.single),
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
