import 'dart:io';
import 'dart:math';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/data_models/chart_data_model.dart';
import 'package:cashify/data_models/export.dart';
import 'package:cashify/data_models/filter_model.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/all_transactions_page/all_transaction_view.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_body.dart';
import 'package:cashify/pages/home_page/repository.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_view.dart';
import 'package:cashify/pages/settings_page/settings_controller.dart';
import 'package:cashify/pages/settings_page/settings_view.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final HomeRepository _repo = HomeRepository();

  UserDataModel _userModel = UserDataModel(
      username: '',
      email: '',
      userId: '',
      localImage: false,
      localPath: '',
      onlinePath: '',
      language: '',
      defaultCurrency: '',
      messagingToken: '',
      errorMessage: '',
      phoneNumber: '',
      wallets: [],
      isError: true,
      catagories: [],
      isSynced: false);
  UserDataModel get userModel => _userModel;

  ({DateTime start, DateTime end}) _chosenTimePeriod =
      (start: DateTime.now(), end: DateTime.now());
  ({DateTime start, DateTime end}) get chosenTimePeriod => _chosenTimePeriod;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  Map<String, MonthSettingDataModel> _monthSettingMap = {};
  Map<String, MonthSettingDataModel> get monthSettingMap => _monthSettingMap;

  List<dynamic> _transactionList = [];
  List<dynamic> get transactionList => _transactionList;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  bool _loading = false;
  bool get loading => _loading;

  bool _walletLoading = false;
  bool get walletLoading => _walletLoading;

  bool _totalLoading = false;
  bool get totalLoading => _totalLoading;

  late DateTime _startTime;
  DateTime get startTime => _startTime;
  late DateTime _endTime;
  DateTime get endTime => _endTime;

  final List<Widget> _pages = const [
    HomeBody(),
    AllTransactionsView(),
    MonthSettingView(),
    SettingsView()
  ];
  List<Widget> get pages => _pages;

  final Map<String, int> _track = {
    'thismnth'.tr: 0,
    'lastmnth'.tr: 1,
    'thisyear'.tr: 2,
    'custom'.tr: 3
  };
  Map<String, int> get track => _track;

  String _chosenTime = 'thismnth'.tr;
  String get chosenTime => _chosenTime;

  final List<String> _timesToChose = [
    'thismnth'.tr,
    'lastmnth'.tr,
    'thisyear'.tr,
    'custom'.tr
  ];
  List<String> get timesToChose => _timesToChose;

  List<Times> timesList = [
    Times.thisMonth,
    Times.lastMonth,
    Times.thisYear,
    Times.custom
  ];
  List<Times> get timesList1 => timesList;

  List<CatagoryModel> _catList = [];
  List<CatagoryModel> get catList => _catList;

  CatagoryModel _chosenCat = CatagoryModel(
      name: 'name',
      subCatagories: [],
      icon: 'icon',
      color: 0,
      transactions: []);
  CatagoryModel get chosenCat => _chosenCat;

  double _income = 0.0;
  double get income => _income;

  double _expense = 0.0;
  double get expense => _expense;

  Map<String, double> _vals = {};
  Map<String, double> get vals => _vals;

  final ValueNotifier<int> _modalIndex = ValueNotifier<int>(0);
  ValueNotifier<int> get modalIndex => _modalIndex;

  final TextEditingController _transactionAddController =
      TextEditingController();
  TextEditingController get transactionAddController =>
      _transactionAddController;

  final TextEditingController _commentController = TextEditingController();
  TextEditingController get commentController => _commentController;

  final TextEditingController _catAddController = TextEditingController();
  TextEditingController get catAddController => _catAddController;

  final FocusNode _catAddNode = FocusNode();
  FocusNode get catAddNode => _catAddNode;

  final TextEditingController _subCatAddController = TextEditingController();
  TextEditingController get subCatAddController => _subCatAddController;

  final FocusNode _subCatNode = FocusNode();
  FocusNode get subCatNode => _subCatNode;

  final FocusNode _transactionAddNode = FocusNode();
  FocusNode get transactionAddNode => _transactionAddNode;

  final FocusNode _commentNodee = FocusNode();
  FocusNode get commentNodee => _commentNodee;

  String _transactionCurrency = 'SAR';
  String get transactionCurrency => _transactionCurrency;

  final String _currentTime = '${DateTime.now().year}-${DateTime.now().month}';
  String get currentTime => _currentTime;

  double _moneyTotal = 0.0;
  double get moneyTotal => _moneyTotal;

  double _moneyTrans = 0.0;
  double get moneyTrans => _moneyTrans;

  bool _totalchanged = false;
  bool get totalchanged => _totalchanged;

  final Map<String, ({String cat, double amount})> _mainSub = {};
  Map<String, ({String cat, double amount})> get mainSub => _mainSub;

  bool _mainSubAll = false;
  bool get mainSubAll => _mainSubAll;

  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  Times _chosenTimeType = Times.thisMonth;
  Times get chosenTimeType => _chosenTimeType;

  Map<String, ChartDataModel> _chartData = {};
  Map<String, ChartDataModel> get chartData => _chartData;

  bool _isCuved = true;
  bool get isCuved => _isCuved;

  int _rotation = 0;
  int get rotation => _rotation;
  @override
  void onInit() async {
    initAll();
    super.onInit();
  }

  @override
  void onClose() {
    _pageController.dispose();
    _transactionAddController.dispose();
    _transactionAddNode.dispose();
    _commentController.dispose();
    _commentNodee.dispose();
    _catAddController.dispose();
    _catAddNode.dispose();
    _subCatAddController.dispose();
    _subCatNode.dispose();
    super.onClose();
  }

  // initial function
  void initAll() async {
    loadinganimation(load: true, total: true);
    _userModel = await _repo.getUserData();
    langChange();
    _monthSettingMap = await _repo.getMonthSetting();
    _transactionList = await _repo.getTransactions();
    _chosenTimePeriod = await setTime();
    _transactionCurrency = _userModel.defaultCurrency;

    await getDataOnline().then((_) async {
      _moneyTotal = await currentBalance();
      await calcLocal().then((_) => loadinganimation(load: false, total: true));
    });
  }

  // change language
  void langChange() {
    if (Get.deviceLocale.toString().substring(0, 2) !=
        _userModel.language.substring(0, 2)) {
      Get.updateLocale(Locale(_userModel.language.substring(0, 2),
          _userModel.language.substring(3, 5)));
    }
  }

  // simple updating function
  void reload() {
    update();
  }

  // calculate current balance
  Future<double> currentBalance() async {
    double balance = 0.0;
    if (_monthSettingMap[_currentTime] == null ||
        _monthSettingMap[_currentTime]!.walletInfo.isEmpty) {
      return balance;
    }

    for (var i = 0;
        i < _monthSettingMap[_currentTime]!.walletInfo.length;
        i++) {
      bool match = _monthSettingMap[_currentTime]!.walletInfo[i].currency ==
          _userModel.defaultCurrency;
      double val = _monthSettingMap[_currentTime]!.walletInfo[i].start +
          _monthSettingMap[_currentTime]!.walletInfo[i].opSum;

      balance += match
          ? val
          : val != 0
              ? double.parse(
                  await _repo.getCurrencySwap(
                    from:
                        _monthSettingMap[_currentTime]!.walletInfo[i].currency,
                    to: _userModel.defaultCurrency,
                    amount: val,
                  ),
                )
              : 0;
    }

    return balance;
  }

  // do i have month setting
  bool haveMonthSetting({required String key}) {
    return _monthSettingMap[key] != null;
  }

  // change is curveed
  void isCurved() {
    _isCuved = !_isCuved;
    update();
  }

  // return number of date titles
  double dateTitle() {
    double count =
        chosenTimePeriodDays() <= 92 ? 6 : chosenTimePeriodDays() / 30;
    return count.floorToDouble();
  }

  // chosen time period in days
  int chosenTimePeriodDays() {
    return _chosenTimePeriod.end.difference(_chosenTimePeriod.start).inDays;
  }

  // change currancy
  void changeCurrancy({required String currency}) async {
    _moneyTrans = 0.0;
    _totalchanged = false;
    if (currency != '' && currency != _transactionCurrency) {
      _transactionCurrency = currency;
      if (currency != _userModel.defaultCurrency) {
        _totalLoading = true;
        update();
        await _repo
            .getCurrencySwap(
                from: _userModel.defaultCurrency,
                to: currency,
                amount: _moneyTotal)
            .then(
          (value) {
            _totalchanged = true;
            _moneyTrans = double.parse(value);
            _totalLoading = false;
            update();
          },
        );
      } else {
        _moneyTrans = 0.0;
        _totalchanged = false;
      }
    }
    update();
  }

  // stage one calculation
  Future<void> calcBackend() async {
    _chartData = {};
    _income = 0;
    _expense = 0;
    _catList = [];
    _vals = {};
    await _repo
        .getTransactionsOnline(
      model: FilterModel(
        userId: _userModel.userId,
        path: FirebasePaths.transactions.name,
        timeStart: Timestamp.fromDate(_chosenTimePeriod.start),
        timeEnd: Timestamp.fromDate(
          _chosenTimePeriod.end
              .add(const Duration(hours: 23, minutes: 59, seconds: 59)),
        ),
      ),
    )
        .then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var i = 0; i < value.docs.length; i++) {
            TransactionDataModel transaction = TransactionDataModel.fromMap(
              value.docs[i].data() as Map<String, dynamic>,
            );
            await postCalc(transaction: transaction).then((_) {
              if (_catList.isNotEmpty) {
                _chosenCat = _catList[0];
              }
            });
          }
        }
      },
    );
  }

  Future<void> calcLocal() async {
    _chartData = {};
    _income = 0;
    _expense = 0;
    _catList = [];
    _vals = {};
    for (var i = 0; i < _transactionList.length; i++) {
      TransactionDataModel model = _transactionList[i];

      if (isTimeInPeriod(
          start: _chosenTimePeriod.start,
          end: getEndingDate(),
          time: model.date)) {
        await postCalc(transaction: model);
      } else {
        _transactionList.removeAt(i);
        await _repo.saveTransactions(list: _transactionList);
      }
    }

    if (_catList.isNotEmpty) {
      _chosenCat = _catList[0];
    }
  }

  // change chosen category
  void changeChosenCategory({required CatagoryModel model}) {
    if (model.name != _chosenCat.name) {
      _chosenCat = model;
      update();
    }
  }

  Future<void> postCalc({required TransactionDataModel transaction}) async {
    CatagoryModel backup = CatagoryModel(
      name: 'name',
      subCatagories: [],
      icon: '57415-MaterialIcons',
      color: 4278190080,
    );

    double amount = transaction.currency == _userModel.defaultCurrency
        ? transaction.amount
        : double.parse(
            await _repo.getCurrencySwap(
              from: transaction.currency,
              to: _userModel.defaultCurrency,
              amount: transaction.amount,
            ),
          );

    switch (transaction.type) {
      case TransactionType.moneyIn:
        _income += amount;
        _vals[transaction.catagory] =
            (_vals[transaction.catagory] ?? 0) + amount;
        await setChartData(model: transaction);
        addToCatList(
            model: CatagoryModel(
              name: transaction.catagory,
              subCatagories: [transaction.subCatagory],
              icon: _userModel.catagories
                  .firstWhere((element) => element.name == transaction.catagory,
                      orElse: () => backup)
                  .icon,
              color: _userModel.catagories
                  .firstWhere((element) => element.name == transaction.catagory,
                      orElse: () => backup)
                  .color,
              transactions: [transaction],
            ),
            transaction: transaction);

        break;
      case TransactionType.moneyOut:
        _expense += amount;
        _vals[transaction.catagory] =
            (_vals[transaction.catagory] ?? 0) + amount;
        await setChartData(model: transaction);
        addToCatList(
            model: CatagoryModel(
              name: transaction.catagory,
              subCatagories: [transaction.subCatagory],
              icon: _userModel.catagories
                  .firstWhere((element) => element.name == transaction.catagory,
                      orElse: () => backup)
                  .icon,
              color: _userModel.catagories
                  .firstWhere((element) => element.name == transaction.catagory,
                      orElse: () => backup)
                  .color,
              transactions: [transaction],
            ),
            transaction: transaction);

        break;
      case TransactionType.transfer:
        break;
    }
  }

  //add to catList
  void addToCatList(
      {required CatagoryModel model,
      required TransactionDataModel transaction}) {
    if (_catList.isEmpty) {
      _catList.add(model);
    } else {
      int tracker = 0;
      for (var i = 0; i < _catList.length; i++) {
        if (_catList[i].name == transaction.catagory) {
          _catList[i].transactions != null
              ? _catList[i].transactions!.add(transaction)
              : _catList[i].transactions = [transaction];
          tracker = 1;
        }
      }
      if (tracker == 0) {
        _catList.add(model);
      }
    }
  }

  bool chartDataErrorl() {
    return _loading || _chartData == {} || _chartData[_chosenCat.name] == null;
  }

  // set chart data
  Future<void> setChartData({required TransactionDataModel model}) async {
    DateTime simpleTime =
        DateTime(model.date.year, model.date.month, model.date.day);

    double amount = model.currency == _userModel.defaultCurrency
        ? model.amount
        : double.parse(
            await _repo.getCurrencySwap(
              from: model.currency,
              to: _userModel.defaultCurrency,
              amount: model.amount,
            ),
          );

    ChartDataModel chartDataModel = _chartData[model.catagory] ??
        ChartDataModel(
            high: 0,
            low: 0,
            data: {},
            name: model.catagory,
            start: simpleTime,
            end: simpleTime);
    double newAmount = (chartDataModel.data[simpleTime] ?? 0.0) + amount;

    chartDataModel.high = max(chartDataModel.high, newAmount);
    chartDataModel.low = min(chartDataModel.low, newAmount);
    chartDataModel.end = chartDataModel.end.isBefore(simpleTime)
        ? simpleTime
        : chartDataModel.end;
    chartDataModel.start = chartDataModel.start.isAfter(simpleTime)
        ? simpleTime
        : chartDataModel.start;
    chartDataModel.data[simpleTime] =
        (chartDataModel.data[simpleTime] ?? 0.0) + amount;

    _chartData[model.catagory] = chartDataModel;
  }

  // change the tracking of the chosen time period
  void timeChange(
      {required String? time,
      required BuildContext context,
      required Times times}) async {
    if (_chosenTime != time || _chosenTime == 'custom'.tr) {
      _chosenTime = time.toString();
      _chosenTimeType = times;

      await setTime(time: _chosenTimeType, context: context)
          .then((value) async {
        _chosenTimePeriod = value;
        loadinganimation(load: true, total: false);
        _chosenTimeType == Times.thisMonth
            ? await calcLocal()
            // put in isolate
            : await calcBackend();
        loadinganimation(load: false, total: false);
      });
      update();
    }
  }

  // set start and end times
  Future<({DateTime start, DateTime end})> setTime(
      {Times? time, BuildContext? context}) async {
    var controll = DateTime.now();
    switch (time) {
      case null:
      case Times.thisMonth:
        _startTime = DateTime(controll.year, controll.month, 1);
        _endTime = DateTime(controll.year, controll.month, controll.day);
        _chosenTimeType = Times.thisMonth;

        return (start: _startTime, end: _endTime);

      case Times.lastMonth:
        _startTime = DateTime(
            controll.month == 1 ? controll.year - 1 : controll.year,
            controll.month == 1 ? 12 : controll.month - 1,
            1);
        _endTime = controll.month < 12
            ? DateTime(controll.year, controll.month, 0)
            : DateTime(controll.year + 1, 1, 0);
        _chosenTimeType = Times.lastMonth;
        return (start: _startTime, end: _endTime);

      case Times.thisYear:
        var controll = DateTime.now();

        _startTime = DateTime(controll.year, 1, 1);
        _endTime = DateTime(controll.year, controll.month, controll.day);
        _chosenTimeType = Times.thisYear;
        return (start: _startTime, end: _endTime);

      case Times.custom:
        await showCalendarDatePicker2Dialog(
          context: context as BuildContext,
          config: CalendarDatePicker2WithActionButtonsConfig(
              firstDate: DateTime(2015, 1, 1),
              lastDate: DateTime(2500, 12, 31),
              calendarType: CalendarDatePicker2Type.range),
          dialogSize: const Size(325, 400),
          value: [],
          borderRadius: BorderRadius.circular(15),
        ).then(
          (value) {
            if (value != null && value.length == 2) {
              _startTime = value[0] as DateTime;
              _endTime = value[1] as DateTime;
              _chosenTimeType = Times.custom;
            } else {
              _startTime = DateTime(controll.year, controll.month, 1);
              _endTime = DateTime(controll.year, controll.month, controll.day);
              _chosenTimeType = Times.thisMonth;
            }
          },
        );

        return (start: _startTime, end: _endTime);
    }
  }

  // calculate averages
  double average({required double amount}) {
    int days =
        _chosenTimePeriod.end.difference(_chosenTimePeriod.start).inDays + 1;
    return amount == 0 ? 0.0 : double.parse((amount / days).toStringAsFixed(2));
  }

  // loading animation
  void loadinganimation({required bool load, required bool total}) {
    _loading = load;
    if (total) {
      _walletLoading = load;
      _totalLoading = load;
    }
    update();
  }

  // calculate subcategories of main catagories
  void calculateSubcategories(
      {required List<TransactionDataModel> transactions}) async {
    _mainSub.clear();
    for (var i = 0; i < transactions.length; i++) {
      String title = transactions[i].subCatagory == ''
          ? 'No SubCatagory'
          : transactions[i].subCatagory;

      double newAmount = transactions[i].currency == _userModel.defaultCurrency
          ? transactions[i].amount
          : double.parse(await _repo.getCurrencySwap(
              from: transactions[i].currency,
              to: _userModel.defaultCurrency,
              amount: transactions[i].amount));
      if (_mainSub[title] != null) {
        _mainSub[title] = (
          amount: _mainSub[title]!.amount + newAmount,
          cat: transactions[i].catagory
        );
      } else {
        _mainSub[title] = (amount: newAmount, cat: transactions[i].catagory);
      }
    }
    update();
  }

  // flip main subCatagory view
  void mainSubFlip({required bool all}) {
    _mainSubAll = all;
    update();
  }

  // format the amount
  String humanFormat(double number) {
    final formatter = NumberFormat.compact(
        locale: _userModel.language); // US locale for common abbreviations
    return formatter.format(number);
  }

  String moneyFormat({required double amount}) {
    var formatter = NumberFormat();
    return formatter.format(amount);
  }

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

  // transaction operations
  Future<void> transactionOperation({
    bool? excuse,
    TransactionDataModel? old,
    required TransactionDataModel transaction,
    required OperationTyoe type,
  }) async {
    TransactionDataModel model = amountEdit(transaction: transaction);

    switch (type) {
      case OperationTyoe.add:
        await transactionAdd(transaction: model);
        break;
      case OperationTyoe.update:
        await transactionUpdate(transaction: model, old: old!);
        break;
      case OperationTyoe.delete:
        await transactionDelete(transaction: model, excuse: excuse);
        break;
    }
  }

  // add transaction
  Future<void> transactionAdd(
      {required TransactionDataModel transaction, bool? prevent}) async {
    String time = '${transaction.date.year}-${transaction.date.month}';
    String tranPath = FirebasePaths.transactions.name;
    String monthPath = FirebasePaths.monthSetting.name;
    String userId = _userModel.userId;
    DateTime endingDate = getEndingDate();

    if (isTimeInPeriod(
        start: _chosenTimePeriod.start,
        end: endingDate,
        time: transaction.date)) {
      await editVals(transaction: transaction).then((_) async {
        await setChartData(model: transaction).then((_) => update());
      });
    }
    if (isTimeInPeriod(
        start: DateTime(DateTime.now().year, DateTime.now().month, 1),
        end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
        time: transaction.date)) {
      _transactionList.add(transaction);
      await _repo.saveTransactions(list: _transactionList);
    }
    await editMonthSetting(transaction: transaction).then((_) async {
      _moneyTotal = await currentBalance();
      update();
      Map<String, dynamic> map = transaction.toMap();
      map['notes'] = transaction.note.split(' ');
      await Future.wait([
        _repo.saveMonthSetting(
          model: _monthSettingMap,
        ),
        _repo.addRecord(
            data: _monthSettingMap[time]!.toMap(),
            path: monthPath,
            userId: userId,
            docPath: time),
        _repo.addRecord(
            data: map, path: tranPath, userId: userId, docPath: transaction.id)
      ]);
    });

    // if all transactions controller is registered add the transaction to the list there
    if (Get.isRegistered<AllTransactionsController>() && prevent == null) {
      Get.find<AllTransactionsController>()
          .transactionAdd(model: transaction, id: transaction.id);
    }
  }

  // get ending date
  DateTime getEndingDate() {
    return _chosenTimeType == Times.thisMonth
        ? DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
        : _chosenTimeType == Times.thisYear
            ? DateTime(DateTime.now().year, 12, 31)
            : _chosenTimePeriod.end;
  }

  // update transaction
  Future<void> transactionUpdate(
      {required TransactionDataModel transaction,
      required TransactionDataModel old}) async {
    await transactionDelete(transaction: old).then(
      (_) async =>
          await transactionAdd(transaction: transaction, prevent: true).then(
        (value) => update(),
      ),
    );
  }

  // delete transaction
  Future<void> transactionDelete(
      {required TransactionDataModel transaction, bool? excuse}) async {
    String time = '${transaction.date.year}-${transaction.date.month}';
    double newAmount =
        transaction.currency == _userModel.defaultCurrency || excuse == true
            ? transaction.amount
            : double.parse(
                await _repo.getCurrencySwap(
                    from: transaction.currency,
                    to: _userModel.defaultCurrency,
                    amount: transaction.amount),
              );

    int index =
        _transactionList.indexWhere((element) => element.id == transaction.id);
    if (isTimeInPeriod(
        start: _chosenTimePeriod.start,
        end: getEndingDate(),
        time: transaction.date)) {
      _vals.update(transaction.catagory, (value) => value - newAmount);
      int catIndex = _catList
          .indexWhere((element) => element.name == transaction.catagory);
      int deepIndex = _catList[catIndex]
          .transactions!
          .indexWhere((element) => element.id == transaction.id);
      _catList[catIndex].transactions!.removeAt(deepIndex);
      switch (transaction.type) {
        case TransactionType.moneyIn:
          _income = _income - newAmount;
          break;
        case TransactionType.moneyOut:
          _expense = _expense - newAmount;
        default:
          null;
      }
      if (_chartData[transaction.catagory] != null &&
          _chartData[transaction.catagory]!.data[DateTime(transaction.date.year,
                  transaction.date.month, transaction.date.day)] !=
              null) {
        double valOld = _chartData[transaction.catagory]!.data[DateTime(
            transaction.date.year,
            transaction.date.month,
            transaction.date.day)]!;
        double valNew = valOld - newAmount;
        _chartData[transaction.catagory]!.data[DateTime(transaction.date.year,
            transaction.date.month, transaction.date.day)] = valNew;
      }
    }
    if (index != -1) {
      _transactionList.removeAt(index);
      await _repo.saveTransactions(list: _transactionList);
    }
    double oldVal = _monthSettingMap[time]!
        .walletInfo
        .firstWhere((element) => element.wallet == transaction.wallet)
        .opSum;
    double newVal = oldVal - newAmount;
    _monthSettingMap[time]!
        .walletInfo
        .firstWhere((element) => element.wallet == transaction.wallet)
        .opSum = newVal;
    _moneyTotal = await currentBalance();
    update();
    await Future.wait(
      [
        _repo.saveMonthSetting(model: _monthSettingMap),
        _repo.addRecord(
            docPath: time,
            data: _monthSettingMap[time]!.toMap(),
            path: FirebasePaths.monthSetting.name,
            userId: _userModel.userId),
        _repo.deleteRec(
            path: FirebasePaths.transactions.name,
            userId: _userModel.userId,
            docId: transaction.id)
      ],
    );
  }

  // edit vals to reflict on the main list
  Future<void> editVals({required TransactionDataModel transaction}) async {
    double amount = transaction.currency == _userModel.defaultCurrency
        ? transaction.amount
        : double.parse(
            await _repo.getCurrencySwap(
              from: transaction.currency,
              to: _userModel.defaultCurrency,
              amount: transaction.amount,
            ),
          );

    _vals.update(transaction.catagory, (value) => value + amount,
        ifAbsent: () => amount);

    int index =
        _catList.indexWhere((element) => element.name == transaction.catagory);
    if (index == -1) {
      final cat = _userModel.catagories
          .firstWhere((element) => element.name == transaction.catagory);
      _catList.add(CatagoryModel(
        name: transaction.catagory,
        subCatagories: [transaction.subCatagory],
        icon: cat.icon,
        color: cat.color,
        transactions: [transaction],
      ));
    } else {
      _catList[index].transactions!.add(transaction);
      _catList[index].subCatagories.add(transaction.subCatagory);
    }

    transaction.type == TransactionType.moneyIn
        ? _income += amount
        : transaction.type == TransactionType.moneyOut
            ? _expense += amount
            : null;
  }

  // edit month setting
  Future<void> editMonthSetting(
      {required TransactionDataModel transaction}) async {
    String time = '${transaction.date.year}-${transaction.date.month}';
    _monthSettingMap[time] ??= MonthSettingDataModel(
      walletInfo: [],
      budgetCat: [],
      budgetVal: [],
      year: transaction.date.year,
      month: transaction.date.month,
      catagory: [],
    );
    int index = _monthSettingMap[time]!.walletInfo.indexWhere(
          (element) => element.wallet == transaction.wallet,
        );
    String defaultCurrency = _monthSettingMap[time]!.walletInfo[index].currency;
    double amount = transaction.currency == defaultCurrency
        ? transaction.amount
        : double.parse(
            await _repo.getCurrencySwap(
              from: transaction.currency,
              to: defaultCurrency,
              amount: transaction.amount,
            ),
          );
    if (index != -1) {
      _monthSettingMap[time]!.walletInfo[index].opSum += amount;
    } else {
      _monthSettingMap[time]!.walletInfo.add(
            WalletInfoModel(
              wallet: transaction.wallet,
              start: 0,
              currency: _userModel.wallets
                  .firstWhere((element) => element.name == transaction.wallet)
                  .currency,
              end: 0,
              opSum: amount,
            ),
          );
    }
  }

  TransactionDataModel amountEdit({required TransactionDataModel transaction}) {
    TransactionDataModel model = transaction;
    if (model.type == TransactionType.moneyOut && model.amount > 0) {
      model.amount = model.amount * -1;
    }
    if (model.type == TransactionType.moneyIn && model.amount < 0) {
      model.amount = model.amount * -1;
    }

    return model;
  }

  // get transactions and monthsetting data if not available locally
  Future<void> getDataOnline() async {
    if (_userModel.isSynced == false) {
      await _repo
          .getRecords(
              userId: _userModel.userId, path: FirebasePaths.monthSetting.name)
          .then(
        (value) async {
          if (value.docs.isNotEmpty) {
            for (var i = 0; i < value.docs.length; i++) {
              _monthSettingMap[value.docs[i].id] =
                  MonthSettingDataModel.fromMap(
                      value.docs[i].data() as Map<String, dynamic>);
            }
            await _repo.saveMonthSetting(model: _monthSettingMap);
          }
        },
      );

      await _repo
          .getTransactionsOnline(
        model: FilterModel(
          userId: _userModel.userId,
          path: FirebasePaths.transactions.name,
          timeStart: Timestamp.fromDate(_chosenTimePeriod.start),
          timeEnd: Timestamp.fromDate(
            _chosenTimePeriod.end.add(
              const Duration(hours: 23, minutes: 59, seconds: 59),
            ),
          ),
        ),
      )
          .then(
        (value) async {
          if (value.docs.isNotEmpty) {
            for (var i = 0; i < value.docs.length; i++) {
              TransactionDataModel object = TransactionDataModel.fromMap(
                value.docs[i].data() as Map<String, dynamic>,
              );
              _transactionList.add(object);
            }
            await _repo.saveTransactions(list: _transactionList);
          }
        },
      );
      await _repo
          .setIsSynced(userId: _userModel.userId, val: true)
          .then((value) async {
        _userModel.isSynced = true;
        await _repo.updateUserLocally(user: _userModel);
      });
    }
  }

  // check if image exists locally
  bool imageExists({required String link}) {
    return File(link).existsSync();
  }

  // update category
  void updateCategory(
      {required CatagoryModel model, required UserDataModel user}) {
    int index = _catList.indexWhere((element) => element.name == model.name);
    if (index != -1) {
      _catList[index].color = model.color;
      _catList[index].icon = model.icon;
      _catList[index].name = model.name;
      _catList[index].subCatagories = model.subCatagories;
      _userModel = user;
      update();
    }
  }

  // dynamic time key
  String budgetTime() {
    return chosenTimeType == Times.thisMonth
        ? _currentTime
        : '${_chosenTimePeriod.start.year}-${_chosenTimePeriod.start.month}';
  }

  // decide if budget is shown
  bool budgetShow({required String category}) {
    return (chosenTimeType == Times.thisMonth ||
            chosenTimeType == Times.lastMonth) &&
        haveMonthSetting(key: budgetTime()) &&
        _monthSettingMap[budgetTime()]!.budgetCat.isNotEmpty &&
        _monthSettingMap[budgetTime()]!.budgetCat.contains(category);
  }

  // get budget amount
  double budgetAmount({required String category}) {
    int index = _monthSettingMap[budgetTime()] != null
        ? _monthSettingMap[budgetTime()]!.budgetCat.indexOf(category)
        : -1;
    return index == -1 ? 0 : _monthSettingMap[budgetTime()]!.budgetVal[index];
  }

  // calculate interval
  double interval(
      {required double max,
      required double min,
      required double amount,
      required int fallback}) {
    double range = max - min;
    double interval = (range == 0 ? fallback : range) / (amount - 1);
    return interval;
  }

  // save month setting locally and in backend
  Future<void> saveMonthSetting(
      {required Map<String, MonthSettingDataModel> map,
      required String dateKey}) async {
    _monthSettingMap = map;
    _moneyTotal = await currentBalance();
    update();
    await _repo.saveMonthSetting(model: _monthSettingMap).then(
          (_) async => await _repo.addRecord(
              data: map[dateKey]!.toMap(),
              path: FirebasePaths.monthSetting.name,
              userId: _userModel.userId,
              docPath: dateKey),
        );
  }

  // rotate chart x axis titles
  void rotateXAxis() {
    _rotation = _rotation == 340 ? 0 : _rotation + 20;
    update();
  }

  // transfer between wallets
  void transferBetweenWallets({required TransactionDataModel model}) async {
    DateTime control = DateTime.now();
    DateTime start = DateTime(control.year, control.month, 1);
    DateTime end = DateTime(control.year, control.month + 1, 0);
    String time = '${control.year}-${control.month}';

    if (!isTimeInPeriod(start: start, end: end, time: model.date)) {
      return;
    }

    String fromCurr = _userModel.wallets
        .firstWhere((element) => element.name == model.fromWallet)
        .currency;
    String toCurr = _userModel.wallets
        .firstWhere((element) => element.name == model.toWallet)
        .currency;
    double amountFrom = model.currency == fromCurr
        ? model.amount
        : double.parse(await _repo.getCurrencySwap(
            from: model.currency, to: fromCurr, amount: model.amount));
    double amountTo = model.currency == toCurr
        ? model.amount
        : double.parse(await _repo.getCurrencySwap(
            from: model.currency, to: toCurr, amount: model.amount));

    int fromIndex = _monthSettingMap[time]!
        .walletInfo
        .indexWhere((element) => element.wallet == model.fromWallet);
    int toIndex = _monthSettingMap[time]!
        .walletInfo
        .indexWhere((element) => element.wallet == model.toWallet);

    double oldFrom = _monthSettingMap[time]!.walletInfo[fromIndex].opSum;
    double oldTo = _monthSettingMap[time]!.walletInfo[toIndex].opSum;

    double newFrom = oldFrom - amountFrom;
    double newTo = oldTo + amountTo;

    _monthSettingMap[time]!.walletInfo[fromIndex].opSum = newFrom;
    _monthSettingMap[time]!.walletInfo[toIndex].opSum = newTo;
    update();

    await _repo.saveMonthSetting(model: _monthSettingMap).then((value) async {
      await _repo.addRecord(
          data: _monthSettingMap[time]!.toMap(),
          path: FirebasePaths.monthSetting.name,
          userId: _userModel.userId,
          docPath: time);
    });
  }
}
