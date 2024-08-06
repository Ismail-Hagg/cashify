import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/data_models/export.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/pages/month_setting_page/repository.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class MonthSettingController extends GetxController {
  final MonthSeettingRepository _repo = MonthSeettingRepository();
  late UserDataModel _userModel;
  UserDataModel get userModel => _userModel;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  DateTime _date = DateTime.now();
  DateTime get date => _date;

  Map<String, MonthSettingDataModel> _monthSettingMap = {};
  Map<String, MonthSettingDataModel> get monthSettingMap => _monthSettingMap;

  final bool _loading = false;
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

  CatagoryModel? _chosenCategory;
  CatagoryModel? get chosenCategory => _chosenCategory;

  bool _calcLoader = false;
  bool get calcLoader => _calcLoader;

  @override
  void onInit() {
    super.onInit();
    _monthSettingMap = Get.find<HomeController>().monthSettingMap;
    _userModel = Get.find<GloableAuthController>().userModel;
    _startNode.addListener(_startListen);
    _endNode.addListener(_endListen);
    _budgetNode.addListener(_budgetListen);
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
      changeVals(start: true);
    }
  }

  void _endListen() {
    _endActive = _endNode.hasFocus;
    update();
    if (_startActive == false) {
      changeVals(start: false);
    }
  }

  void _budgetListen() {
    _budgetActive = _budgetNode.hasFocus;
    update();
  }

  String dateKey() {
    return '${date.year}-${date.month}';
  }

  // add budget item
  void budgetAdd({required BuildContext context}) async {
    if (_chosenCategory == null || _budgetAmount.text.trim() == '') {
      showToast(
        title: CustomText(text: 'infoadd'.tr),
        context: context,
        type: ToastificationType.error,
        isEng: _userModel.language == 'en_US',
      );
      return;
    }
    if (_monthSettingMap[dateKey()] != null) {
      if (_monthSettingMap[dateKey()]!
          .budgetCat
          .contains(_chosenCategory!.name)) {
        showToast(
          title: CustomText(text: 'infoadd'.tr),
          context: context,
          type: ToastificationType.error,
          isEng: _userModel.language == 'en_US',
        );
        return;
      }
      _monthSettingMap[dateKey()]!.budgetCat.add(_chosenCategory!.name);
      _monthSettingMap[dateKey()]!
          .budgetVal
          .add(double.parse(_budgetAmount.text.trim()));
      _monthSettingMap[dateKey()]!
          .catagory
          .add(_chosenCategory as CatagoryModel);
    } else {
      _monthSettingMap[dateKey()] = MonthSettingDataModel(
        walletInfo: [],
        budgetCat: [_chosenCategory!.name],
        budgetVal: [double.parse(_budgetAmount.text.trim())],
        year: _date.year,
        month: _date.month,
        catagory: [_chosenCategory as CatagoryModel],
      );
    }

    update();
    Get.back();

    await Get.find<HomeController>()
        .saveMonthSetting(map: _monthSettingMap, dateKey: dateKey());
  }

  // delete budget item
  void budgetDeleteItem({required int index}) async {
    _monthSettingMap[dateKey()]!.budgetCat.removeAt(index);
    _monthSettingMap[dateKey()]!.budgetVal.removeAt(index);
    _monthSettingMap[dateKey()]!.catagory.removeAt(index);
    update();
    await Get.find<HomeController>()
        .saveMonthSetting(map: _monthSettingMap, dateKey: dateKey());
  }

  // chose catagory
  void choseCategory({required String cat}) {
    if (cat != '') {
      int index =
          _userModel.catagories.indexWhere((element) => element.name == cat);
      _chosenCategory = _userModel.catagories[index];
      update();
    }
  }

  // wallet change
  void walletChange({required String wallet}) {
    if (wallet == '') {
      return;
    }

    if (_monthSettingMap[dateKey()] != null) {
      MonthSettingDataModel model =
          _monthSettingMap[dateKey()] as MonthSettingDataModel;
      int index = model.walletInfo.indexWhere(
        (element) => element.wallet == wallet,
      );

      if (index != -1) {
        _startController.text =
            zerosConvert(val: model.walletInfo[index].start);
        _endController.text = zerosConvert(val: model.walletInfo[index].end);
      } else {
        _startController.clear();
        _endController.clear();
      }
    }
    update();
  }

  // change start or end values
  void changeVals({required bool start}) async {
    TextEditingController controll = start ? _startController : _endController;
    if (controll.text.trim() == '' || _catController.text.trim() == '') {
      return;
    }
    String curr = _userModel.wallets
        .firstWhere((element) => element.name == _catController.text.trim())
        .currency;
    if (_monthSettingMap[dateKey()] == null) {
      _monthSettingMap[dateKey()] = MonthSettingDataModel(
          walletInfo: [
            WalletInfoModel(
                wallet: _catController.text.trim(),
                start: start ? double.parse(controll.text.trim()) : 0,
                currency: curr,
                end: start == false ? double.parse(controll.text.trim()) : 0,
                opSum: 0)
          ],
          budgetCat: [],
          budgetVal: [],
          year: _date.year,
          month: _date.month,
          catagory: []);
    } else {
      int index = _monthSettingMap[dateKey()]!.walletInfo.indexWhere(
          (element) => element.wallet == _catController.text.trim());

      if (index != -1) {
        _monthSettingMap[dateKey()]!.walletInfo[index] = WalletInfoModel(
          currency: curr,
          opSum: _monthSettingMap[dateKey()]!.walletInfo[index].opSum,
          wallet: _monthSettingMap[dateKey()]!.walletInfo[index].wallet,
          start: start
              ? double.parse(controll.text.trim())
              : _monthSettingMap[dateKey()]!.walletInfo[index].start,
          end: start == false
              ? double.parse(controll.text.trim())
              : _monthSettingMap[dateKey()]!.walletInfo[index].end,
        );
      } else {
        _monthSettingMap[dateKey()]!.walletInfo.add(
              WalletInfoModel(
                currency: curr,
                opSum: 0,
                wallet: _catController.text.trim(),
                start: start ? double.parse(controll.text.trim()) : 0,
                end: start == false ? double.parse(controll.text.trim()) : 0,
              ),
            );
      }
    }

    await Get.find<HomeController>()
        .saveMonthSetting(map: _monthSettingMap, dateKey: dateKey());
  }

  // change month
  void changeMonth({required BuildContext context}) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          firstDate: DateTime(2015, 1, 1),
          lastDate: DateTime(2500, 12, 31),
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
          update();
        }
      },
    );
  }

  // start claculate inventory
  void inventoryCalc() async {
    if (_calcLoader == false) {
      _calcLoader = true;
      update();
      await endTrigger().then((value) {
        _calcLoader = false;
        update();
      });
    }
  }

  // claculate inventory when value of end changes
  Future<void> endTrigger() async {
    if (_catController.text.trim() == '') {
      return;
    }
    bool exist = await _repo.checkRecordExists(
        path: FirebasePaths.transactions.name,
        userId: _userModel.userId,
        docId: '${dateKey()}-${_catController.text.trim()}');
    if (exist) {
      TransactionDataModel oldModel = TransactionDataModel.fromMap(
        await _repo.getDocuData(
          path: FirebasePaths.transactions.name,
          userId: _userModel.userId,
          docId: '${dateKey()}-${_catController.text.trim()}',
        ),
      );
      if (oldModel.id == '${dateKey()}-${_catController.text.trim()}') {
        await Get.find<HomeController>().transactionOperation(
            excuse: true, transaction: oldModel, type: OperationTyoe.delete);
      }
    }
    double realEnd = double.parse(_endController.text.trim());
    var model = _monthSettingMap[dateKey()]!;
    int index = model.walletInfo
        .indexWhere((element) => element.wallet == _catController.text.trim());
    double summ = realEnd -
        (model.walletInfo[index].start + model.walletInfo[index].opSum);
    if (summ != 0) {
      TransactionDataModel transaction = TransactionDataModel(
        catagory: 'inventory',
        subCatagory: model.walletInfo[index].wallet,
        currency: model.walletInfo[index].currency,
        amount: summ,
        note: '',
        date: DateTime(_date.year, _date.month + 1, 0),
        wallet: model.walletInfo[index].wallet,
        fromWallet: '',
        toWallet: '',
        id: '${dateKey()}-${model.walletInfo[index].wallet}',
        type: summ > 0 ? TransactionType.moneyIn : TransactionType.moneyOut,
      );
      await Get.find<HomeController>().transactionOperation(
          transaction: transaction, type: OperationTyoe.add);
    }
  }
}
