import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/models/filter_model.dart';
import 'package:cashify/models/month_setting_model.dart';
import 'package:cashify/models/transaction_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/models/wallet_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transaction_view.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_body.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_view.dart';
import 'package:cashify/pages/settings_page/settings_controller.dart';
import 'package:cashify/pages/settings_page/settings_view.dart';
import 'package:cashify/services/currency_exchange_service.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  final FirebaseService _firebaseService = FirebaseService();

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  final Map<String, MonthSettingModel> _monhtMap = {};
  Map<String, MonthSettingModel> get monhtMap => _monhtMap;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  bool _loading = false;
  bool get loading => _loading;

  bool _pieChart = true;
  bool get pieChart => _pieChart;

  bool _showIncome = true;
  bool get showIncome => _showIncome;

  late DateTime _startTime;
  DateTime get startTime => _startTime;
  late DateTime _endTime;
  DateTime get endTime => _endTime;

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

  double _chartHigh = 0.0;
  double get chartHigh => _chartHigh;

  double _chartLow = 0.0;
  double get chartLow => _chartLow;

  double _expense = 0.0;
  double get expense => _expense;

  Map<String, double> _vals = {};
  Map<String, double> get vals => _vals;

  Map<String, double> _valsUp = {};
  Map<String, double> get valsUp => _valsUp;

  Map<String, double> _valsDown = {};
  Map<String, double> get valsDown => _valsDown;

  Map<String, List<DateTime>> _dates = {};
  Map<String, List<DateTime>> get dates => _dates;

  final ValueNotifier<int> _modalIndex = ValueNotifier<int>(0);
  ValueNotifier<int> get modalIndex => _modalIndex;

  DateTime _transactionAddTime = DateTime.now();
  DateTime get transactionAddTime => _transactionAddTime;

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

  TransactionType _transactionType = TransactionType.moneyOut;
  TransactionType get transactionType => _transactionType;

  String _transactionCurrency = '';
  String get transactionCurrency => _transactionCurrency;

  String _chosenCategory = '';
  String get chosenCategory => _chosenCategory;

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

  @override
  void onInit() {
    _userModel = Get.find<GloableAuthController>().userModel;
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _transactionCurrency = _userModel.defaultCurrency;
    initAll();
    super.onInit();
  }

  @override
  void onClose() {
    _loadingController.dispose();
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
    loadinganimation(load: true);
    await getMonthSetting(date: _currentTime).then((_) async {
      await moneyNow().then((value) async {
        await setTime().then((value) async {
          await calculate(start: value.start, end: value.end).then((value) {
            loadinganimation(load: false);
          });
        }).onError((error, stackTrace) {
          print('===er $error');
        });
      }).onError((error, stackTrace) {
        print('=== $error');
      });
    });
  }

  // calculate total of wallets aka money now
  Future<void> moneyNow() async {
    if (_monhtMap[_currentTime] != null) {
      _moneyTotal = 0.0;
      for (var i = 0; i < _monhtMap[_currentTime]!.walletInfo.length; i++) {
        if (_monhtMap[_currentTime]!.walletInfo[i].currency ==
            _userModel.defaultCurrency) {
          _moneyTotal = double.parse((_moneyTotal +
                  (_monhtMap[_currentTime]!.walletInfo[i].start +
                      _monhtMap[_currentTime]!.walletInfo[i].opSum))
              .toStringAsFixed(2));
        } else {
          await currencySwapp(
            base: _monhtMap[_currentTime]!.walletInfo[i].currency,
            exTo: _userModel.defaultCurrency,
            amount: (_monhtMap[_currentTime]!.walletInfo[i].start +
                _monhtMap[_currentTime]!.walletInfo[i].opSum),
          ).then(
            (value) {
              if (value != '') {
                _moneyTotal = double.parse(
                    (_moneyTotal + double.parse(value)).toStringAsFixed(2));
              }
            },
          );
        }
      }
    }
  }

  // get the month dara
  Future<void> getMonthSetting({required String date}) async {
    if (_monhtMap[date] == null) {
      await _firebaseService
          .getRecordDocu(
              userId: _userModel.userId,
              path: FirebasePaths.monthSetting.name,
              docId: date)
          .then((value) async {
        if (value.exists) {
          _monhtMap[date] =
              MonthSettingModel.fromMap(value.data() as Map<String, dynamic>);
        }
      });
    }
  }

  //modal leadig button
  void modalLeadingButtonAction({required BuildContext context}) {
    if (_modalIndex.value == 0) {
      Navigator.of(context).pop();
      modalClosed();
    } else {
      modalPageChange(page: 0, context: context);
    }
  }

  // dismiss keyboard
  void dismissKeyboard(context) {
    FocusScope.of(context).unfocus();
    _transactionAddNode.unfocus();
    _commentNodee.unfocus();
  }

  void modalPageChange({required int page, required BuildContext context}) {
    if (_modalIndex.value != page) {
      dismissKeyboard(context);
      _modalIndex.value = page;
      update();
    }
  }

  // switch charts
  void chartSwitch({required bool pie}) {
    if (_pieChart != pie) {
      _pieChart = pie;
      update();
    }
  }

  // set start and end times
  Future<({DateTime start, DateTime end})> setTime(
      {Times? time, BuildContext? context}) async {
    switch (time) {
      case null:
      case Times.thisMonth:
        var controll = DateTime.now();
        _startTime = DateTime(controll.year, controll.month, 1);
        _endTime = controll.month < 12
            ? DateTime(controll.year, controll.month + 1, 0)
            : DateTime(controll.year + 1, 1, 0);

        return (start: _startTime, end: _endTime);

      case Times.lastMonth:
        var controll = DateTime.now();

        _startTime = DateTime(
            controll.month == 1 ? controll.year - 1 : controll.year,
            controll.month == 1 ? 12 : controll.month - 1,
            1);
        _endTime = controll.month < 12
            ? DateTime(controll.year, controll.month, 0)
            : DateTime(controll.year + 1, 1, 0);
        return (start: _startTime, end: _endTime);

      case Times.thisYear:
        var controll = DateTime.now();

        _startTime = DateTime(controll.year, 1, 1);
        _endTime = DateTime(controll.year + 1, 1, 0);
        return (start: _startTime, end: _endTime);

      case Times.custom:
        await showCalendarDatePicker2Dialog(
          context: context as BuildContext,
          config: CalendarDatePicker2WithActionButtonsConfig(
              calendarType: CalendarDatePicker2Type.range),
          dialogSize: const Size(325, 400),
          value: [],
          borderRadius: BorderRadius.circular(15),
        ).then(
          (value) {
            if (value != null && value.length == 2) {
              _startTime = value[0] as DateTime;
              _endTime = value[1] as DateTime;
              _chosenTime =
                  '${_startTime.year}/${_startTime.month}/${_startTime.day}  -  ${_endTime.year}/${_endTime.month}/${_endTime.day}';
            } else {
              _startTime = DateTime(1, 0, 0);
              _endTime = DateTime(1, 0, 0);
            }
          },
        );

        return (start: _startTime, end: _endTime);
    }
  }

  // show income or expence in chart
  void chartFlip({required bool income}) {
    if (_showIncome != income) {
      _showIncome = income;
      update();
    }
  }

  // loading animation
  void loadinganimation({required bool load}) {
    _loading = load;
    load ? _loadingController.repeat() : _loadingController.stop();
    update();
  }

  // calculate and gather the catagories
  Future<void> calculate(
      {required DateTime start, required DateTime end, bool? refresh}) async {
    int tracker = 0;
    _chartHigh = 0;
    _chartLow = 0;
    _catList = [];
    _income = 0;
    _expense = 0;
    _vals = {};
    _valsUp = {};
    _valsDown = {};
    _dates = {};

    await _firebaseService
        .filteredTransactions(
      filter: FilterModel(
        userId: _userModel.userId,
        path: FirebasePaths.transactions.name,
        timeStart: Timestamp.fromDate(start),
        timeEnd: Timestamp.fromDate(end),
      ),
    )
        .then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var i = 0; i < value.docs.length; i++) {
            TransactionModel transaction = TransactionModel.fromMap(
                value.docs[i].data() as Map<String, dynamic>);

            _dates[transaction.catagory] != null
                ? _dates[transaction.catagory]!.add(transaction.date)
                : _dates[transaction.catagory] = [transaction.date];

            // add to the map to display from

            if (transaction.currency == _userModel.defaultCurrency) {
              _vals[transaction.catagory] =
                  (_vals[transaction.catagory] ?? 0) + transaction.amount;
            } else {
              await currencySwapp(
                      base: transaction.currency,
                      exTo: _userModel.defaultCurrency,
                      amount: transaction.amount)
                  .then((value) {
                _vals[transaction.catagory] =
                    (_vals[transaction.catagory] ?? 0) + double.parse(value);
              });
            }

            // calculate money in vs out
            if (transaction.type == TransactionType.moneyIn) {
              if (transaction.amount > _chartHigh) {
                _chartHigh = transaction.amount;
              }
              _income = _income + transaction.amount;
              if (_valsUp.containsKey(transaction.catagory)) {
                _valsUp[transaction.catagory] =
                    _valsUp[transaction.catagory]! + transaction.amount;
              } else {
                _valsUp[transaction.catagory] = transaction.amount;
              }
            } else if (transaction.type == TransactionType.moneyOut) {
              if ((transaction.amount * -1) < _chartLow) {
                _chartLow = (transaction.amount * -1);
              }
              _expense = _expense + transaction.amount;
              if (_valsDown.containsKey(transaction.catagory)) {
                _valsDown[transaction.catagory] =
                    _valsDown[transaction.catagory]! + transaction.amount;
              } else {
                _valsDown[transaction.catagory] = transaction.amount;
              }
            }

            if (_catList.isEmpty) {
              _catList.add(
                Catagory(
                  name: transaction.catagory,
                  subCatagories: [transaction.subCatagory],
                  icon: _userModel.catagories
                      .firstWhere(
                          (element) => element.name == transaction.catagory)
                      .icon,
                  color: _userModel.catagories
                      .firstWhere(
                          (element) => element.name == transaction.catagory)
                      .color,
                  transactions: [transaction],
                ),
              );
            } else {
              tracker = 0;
              for (var i = 0; i < _catList.length; i++) {
                if (_catList[i].name == transaction.catagory) {
                  _catList[i].transactions != null
                      ? _catList[i].transactions!.add(transaction)
                      : _catList[i].transactions = [transaction];
                  tracker = 1;
                }
              }
              if (tracker == 0) {
                _catList.add(
                  Catagory(
                    name: transaction.catagory,
                    subCatagories: [transaction.subCatagory],
                    icon: _userModel.catagories
                        .firstWhere(
                            (element) => element.name == transaction.catagory)
                        .icon,
                    color: _userModel.catagories
                        .firstWhere(
                            (element) => element.name == transaction.catagory)
                        .color,
                    transactions: [transaction],
                  ),
                );
              }
            }
          }
          if (refresh == true) {
            update();
          }
        }
      },
    ).onError((error, stackTrace) {
      print('= erroring $error');
    });
  }

  // calculate subcategories of main catagories
  void calculateSubcategories({required List<TransactionModel> transactions}) {
    _mainSub.clear();
    for (var i = 0; i < transactions.length; i++) {
      String title = transactions[i].subCatagory == ''
          ? 'No SubCatagory'
          : transactions[i].subCatagory;
      if (_mainSub[title] != null) {
        _mainSub[title] = (
          amount: _mainSub[title]!.amount + transactions[i].amount,
          cat: transactions[i].catagory
        );
      } else {
        _mainSub[title] =
            (amount: transactions[i].amount, cat: transactions[i].catagory);
      }
    }
  }

  // flip main subCatagory view
  void mainSubFlip({required bool all}) {
    _mainSubAll = all;
    update();
  }

  // calculate average of spending per day
  double aveCalc({required double amount}) {
    double ave = 0.0;

    DateTime ending =
        _trackNum == 0 || _trackNum == 2 ? DateTime.now() : _endTime;
    int days = ending.difference(_startTime).inDays + 1;
    ave = days == 0 ? 0.0 : amount / days;

    return ave;
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

  // currency exchange
  Future<String> currencySwapp(
      {required String base,
      required String exTo,
      required double amount}) async {
    String res = '';
    await MoneyExchange()
        .changeCurrency(base: base, exchange: exTo, amount: amount)
        .then(
          (value) => res = value.status == 'success' ? value.result : '',
        );
    return res;
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
      return amount.toStringAsFixed(2);
    }
  }

  // change the tracking of the chosen time period
  void changeTimePeriod(
      {required String time, required BuildContext context}) async {
    loadinganimation(load: true);
    _trackNum = _track[time] as int;
    _chosenTime = time;
    await setTime(
            time: _trackNum == 0
                ? Times.thisMonth
                : _trackNum == 1
                    ? Times.lastMonth
                    : _trackNum == 2
                        ? Times.thisYear
                        : Times.custom,
            context: context)
        .then((value) async {
      loadinganimation(load: true);

      if (value.start.year != 0) {
        await calculate(start: value.start, end: value.end).then((_) {
          loadinganimation(load: false);
        });
      } else {
        loadinganimation(load: false);
      }
    });
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

  // modal dissmessed
  void modalClosed() {
    Get.back();
    _transactionAddTime = DateTime.now();
    _transactionType = TransactionType.moneyOut;
    _transactionAddController.clear();
    _chosenCategory = '';
    _commentController.clear();
    _modalIndex.value != 0 ? _modalIndex.value = 0 : null;
  }

  void currencyExchange({
    required String base,
    required String to,
    required double amount,
  }) async {
    await MoneyExchange()
        .changeCurrency(base: base, exchange: to, amount: amount)
        .then(
      (value) {
        if (value.status == 'success') {
          _moneyTrans = double.parse(value.result);
          _totalchanged = true;
          update();
        }
      },
    );
  }

  // open dialog for currency swap
  void openDialog({required Widget widget}) {
    _moneyTrans = 0.0;
    _totalchanged = false;
    update();
    dialogShowing(widget: widget);
  }

  // update when adding transaction
  void addTransactionUpdate(
      {required TransactionModel transaction, required double amount}) {
    if (transaction.date.isBefore(_endTime.add(const Duration(seconds: 1))) &&
        transaction.date
            .isAfter(_startTime.subtract(const Duration(seconds: 1)))) {
      int index = _catList
          .indexWhere((element) => element.name == transaction.catagory);
      if (index != -1) {
        _catList[index].transactions!.add(transaction);
      } else {
        IconData icon = _userModel.catagories
            .firstWhere((element) => element.name == transaction.catagory)
            .icon;
        Color color = _userModel.catagories
            .firstWhere((element) => element.name == transaction.catagory)
            .color;
        _catList.add(
          Catagory(
            transactions: [transaction],
            name: transaction.catagory,
            subCatagories: [transaction.subCatagory],
            icon: icon,
            color: color,
          ),
        );
      }
      _vals[transaction.catagory] = (_vals[transaction.catagory] ?? 0) + amount;
      _dates[transaction.catagory] = [transaction.date];
    }
  }

  // transaction operations
  void addTransaction({required TransactionModel transaction}) async {
    TransactionModel model = amountEdit(transaction: transaction);

    final String time = '${model.date.year}-${model.date.month}';

    if (model.type == TransactionType.transfer) {
      final String fromWalletCurrency = _userModel.wallets
          .firstWhere((element) => element.name == model.fromWallet)
          .currency;
      final String toWlletCurrency = _userModel.wallets
          .firstWhere((element) => element.name == model.toWallet)
          .currency;
      double fromAmount = fromWalletCurrency == model.currency
          ? (model.amount * -1)
          : double.parse(
                await currencySwapp(
                    base: model.currency,
                    exTo: fromWalletCurrency,
                    amount: model.amount),
              ) *
              -1;

      double toAmount = toWlletCurrency == model.currency
          ? (model.amount)
          : double.parse(
              await currencySwapp(
                  base: model.currency,
                  exTo: toWlletCurrency,
                  amount: model.amount),
            );

      print(
        'take $fromAmount $fromWalletCurrency from ${model.fromWallet} and put $toAmount $toWlletCurrency in ${model.toWallet}',
      );
      await updateMonthsetting(
        date: model.date,
        wallet: model.fromWallet,
        amount: fromAmount,
      ).then((value) async {
        await updateMonthsetting(
          date: model.date,
          wallet: model.toWallet,
          amount: toAmount,
        ).then((value) async {
          update();
          await _firebaseService.addRecord(
            docPath: time,
            path: FirebasePaths.monthSetting.name,
            userId: _userModel.userId,
            map: _monhtMap[time]!.toMap(),
          );
        });
      });
    } else {
      final String walletCurrency = _userModel.wallets
          .firstWhere((element) => element.name == model.wallet)
          .currency;

      final bool transactionAndWallet = model.currency != walletCurrency;
      final bool transactionAndDefault =
          model.currency != _userModel.defaultCurrency;

      final double tranWallet = transactionAndWallet
          ? double.parse(await currencySwapp(
              base: model.currency, exTo: walletCurrency, amount: model.amount))
          : model.amount;
      final double tranDefault = transactionAndDefault
          ? double.parse(
              await currencySwapp(
                base: model.currency,
                exTo: _userModel.defaultCurrency,
                amount: model.amount,
              ),
            )
          : transaction.amount;
      await updateMonthsetting(
        date: model.date,
        wallet: model.wallet,
        amount: tranWallet,
      ).then((_) {
        if (model.type == TransactionType.moneyIn) {
          _income += tranDefault;
          _valsUp[model.catagory] =
              (_valsUp[model.catagory] ?? 0) + tranDefault;
        }
        if (model.type == TransactionType.moneyOut) {
          _expense += tranDefault;
          _valsDown[model.catagory] =
              (_valsDown[model.catagory] ?? 0) + tranDefault;
        }
        _moneyTotal += tranDefault;
        addTransactionUpdate(transaction: model, amount: tranDefault);
      });
    }
    if (Get.isRegistered<AllTransactionsController>()) {
      Get.find<AllTransactionsController>().transactionAdd(
          model: TransactionModel.fromMap(model.toMap()), id: '');
    }
    update();

    await _firebaseService
        .addRecord(
      docPath: time,
      path: FirebasePaths.monthSetting.name,
      userId: _userModel.userId,
      map: _monhtMap[time]!.toMap(),
    )
        .then((value) async {
      // break the note into a list of words to help with searching

      Map<String, dynamic> map = model.toMap();
      map['notes'] = model.note.split(' ');
      await _firebaseService.addRecord(
        path: FirebasePaths.transactions.name,
        userId: _userModel.userId,
        map: map,
      );
    });
  }

  TransactionModel amountEdit({required TransactionModel transaction}) {
    TransactionModel model = transaction;
    if (model.type == TransactionType.moneyOut && model.amount > 0) {
      model.amount = model.amount * -1;
    }
    if (model.type == TransactionType.moneyIn && model.amount < 0) {
      model.amount = model.amount * -1;
    }

    return model;
  }

  // update monthsetting
  Future<void> updateMonthsetting({
    required DateTime date,
    required double amount,
    required String wallet,
  }) async {
    String time = '${date.year}-${date.month}';
    await getMonthSetting(date: time).then((_) async {
      if (_monhtMap[time] != null) {
        int index = _monhtMap[time]!.walletInfo.indexWhere(
              (element) => element.wallet == wallet,
            );
        if (index != -1) {
          _monhtMap[time]!.walletInfo[index].opSum += amount;
        } else {
          WalletInfo walet = WalletInfo(
            wallet: wallet,
            start: 0,
            currency: _userModel.wallets
                .firstWhere((element) => element.name == wallet)
                .currency,
            end: 0,
            opSum: amount,
          );
          _monhtMap[time]!.walletInfo.add(walet);
        }
      } else {
        WalletInfo walet = WalletInfo(
            wallet: wallet,
            start: 0,
            currency: _userModel.wallets
                .firstWhere((element) => element.name == wallet)
                .currency,
            end: 0,
            opSum: amount);
        MonthSettingModel model = MonthSettingModel(
          walletInfo: [walet],
          budgetCat: [],
          budgetVal: [],
          year: date.year,
          month: date.month,
          catagory: [],
        );
        _monhtMap[time] = model;
      }
    });
  }
}
