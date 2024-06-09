import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/models/month_setting_model.dart';
import 'package:cashify/models/transaction_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/models/wallet_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class AddTransactionController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  late TransactionModel? _transaction;
  TransactionModel? get transaction => _transaction;

  late String? _transactionId;
  String? get transactionId => _transactionId;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  late DateTime _transactionAddTime;
  DateTime get transactionAddTime => _transactionAddTime;

  late TransactionType _transactionType;
  TransactionType get transactionType => _transactionType;

  final Map<String, String> _operations = {
    TransactionType.moneyIn.name: 'inc'.tr,
    TransactionType.moneyOut.name: 'exx'.tr,
    TransactionType.transfer.name: 'transfer'.tr
  };

  Map<String, String> get operators => _operations;

  bool _isActive = false;
  bool get isActive => _isActive;

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

  final TextEditingController _walletNameController = TextEditingController();
  TextEditingController get walletNameController => _walletNameController;

  final TextEditingController _walletAmountController = TextEditingController();
  TextEditingController get walletAmountController => _walletAmountController;

  final FocusNode _subCatNode = FocusNode();
  FocusNode get subCatNode => _subCatNode;

  final FocusNode _transactionAddNode = FocusNode();
  FocusNode get transactionAddNode => _transactionAddNode;

  final FocusNode _commentNodee = FocusNode();
  FocusNode get commentNodee => _commentNodee;

  final FocusNode _walletNameNode = FocusNode();
  FocusNode get walletNameNode => _walletNameNode;

  final FocusNode _walletAmountNode = FocusNode();
  FocusNode get walletAmountNode => _walletAmountNode;

  bool _commentActive = false;
  bool get commentActive => _commentActive;

  bool _catNameActive = false;
  bool get catNameActive => _catNameActive;

  bool _subCatActive = false;
  bool get subCatActive => _subCatActive;

  bool _walletNameActive = false;
  bool get walletNameActive => _walletNameActive;

  bool _walletAmountActive = false;
  bool get walletAmountActive => _walletAmountActive;

  late String _transactionCurrency;
  String get transactionCurrency => _transactionCurrency;

  List<dynamic> _subcats = [];
  List<dynamic> get subcats => _subcats;

  IconData? _catIcon;
  IconData? get catIcon => _catIcon;

  Color _catColor = backgroundColor;
  Color get catColor => _catColor;

  String _walletCurrency = '';
  String get walletCurrency => _walletCurrency;

  final TextEditingController _chosenWallet = TextEditingController();
  TextEditingController get chosenWallet => _chosenWallet;

  final TextEditingController _fromWalletTransaction = TextEditingController();
  TextEditingController get fromWalletTransaction => _fromWalletTransaction;

  final TextEditingController _toWalletTransaction = TextEditingController();
  TextEditingController get toWalletTransaction => _toWalletTransaction;

  final TextEditingController _catController = TextEditingController();
  TextEditingController get catController => _catController;

  final TextEditingController _subcatController = TextEditingController();
  TextEditingController get subcatController => _subcatController;

  late bool _newTransaction;
  bool get newTransaction => _newTransaction;

  @override
  void onInit() {
    super.onInit();
    _transaction = Get.arguments == null ? null : Get.arguments['model'];
    _transactionId = Get.arguments == null ? null : Get.arguments['id'];
    _userModel = Get.find<GloableAuthController>().userModel;
    _walletCurrency = _userModel.defaultCurrency;

    initTransaction();
    setListeners();
  }

  @override
  void onClose() {
    super.onClose();
    dosposeResource();
  }

  // before adding or updating transaction
  void transactionOperation({
    required bool update,
    required BuildContext context,
  }) {
    if (_transactionType != TransactionType.transfer) {
      if (_transactionAddController.text.trim() == '' ||
          _catController.text.trim() == '' ||
          _chosenWallet.text.trim() == '') {
        showToast(
          title: CustomText(text: 'infoadd'.tr),
          context: context,
          type: ToastificationType.error,
          isEng: _userModel.language == 'en_US',
        );
      } else {
        TransactionModel model = TransactionModel(
          catagory: _catController.text.trim(),
          subCatagory: _subcatController.text.trim(),
          currency: _transactionCurrency,
          amount: double.parse(_transactionAddController.text.trim()),
          note: _commentController.text.trim(),
          date: _transactionAddTime,
          wallet: _chosenWallet.text.trim(),
          fromWallet: _fromWalletTransaction.text.trim(),
          toWallet: _toWalletTransaction.text.trim(),
          type: _transactionType,
        );
        update
            ? updateTransactioin(
                transaction: model, recId: _transactionId ?? '')
            : addTransactioin(transaction: model);
        Get.back();
      }
    } else {
      if (_transactionAddController.text.trim() == '' ||
          _fromWalletTransaction.text.trim() == '' ||
          _toWalletTransaction.text.trim() == '') {
        showToast(
          title: CustomText(text: 'infoadd'.tr),
          context: context,
          type: ToastificationType.error,
          isEng: _userModel.language == 'en_US',
        );
      } else if (_fromWalletTransaction.text.trim() ==
          _toWalletTransaction.text.trim()) {
        showToast(
          title: CustomText(text: 'otherwallet'.tr),
          context: context,
          type: ToastificationType.error,
          isEng: _userModel.language == 'en_US',
        );
      } else {
        TransactionModel model = TransactionModel(
            catagory: _catController.text.trim(),
            subCatagory: _subcatController.text.trim(),
            currency: _transactionCurrency,
            amount: double.parse(_transactionAddController.text.trim()),
            note: _commentController.text.trim(),
            date: _transactionAddTime,
            wallet: _chosenWallet.text.trim(),
            fromWallet: _fromWalletTransaction.text.trim(),
            toWallet: _toWalletTransaction.text.trim(),
            type: _transactionType);
        update
            ? updateTransactioin(
                transaction: model, recId: _transactionId ?? '')
            : addTransactioin(transaction: model);
        Get.back();
      }
    }
  }

  // wallet operations
  void walletOperations(
      {required bool transfer,
      required String wallet,
      String? toWallet,
      required BuildContext context,
      required double amuont}) async {
    int walletMain =
        _userModel.wallets.indexWhere((element) => element.name == wallet);
    int? walletTo = toWallet != null
        ? _userModel.wallets.indexWhere((element) => element.name == toWallet)
        : null;
    if (transfer) {
      double newAmountFrom = _userModel.wallets[walletMain].amount - amuont;
      double newAmountTo = _userModel.wallets[walletTo as int].amount + amuont;
      _userModel.wallets[walletMain].amount = newAmountFrom;
      _userModel.wallets[walletTo].amount = newAmountTo;
    } else {
      _userModel.wallets[walletMain].amount =
          _userModel.wallets[walletMain].amount + amuont;
    }
    await updateUser(model: _userModel).then(
      (value) async {
        await updateUserFire(model: _userModel);
      },
    );
  }

  // adding transaction
  void addTransactioin({required TransactionModel transaction}) async {
    if (transaction.type == TransactionType.moneyOut &&
        transaction.amount > 0) {
      transaction.amount = transaction.amount * -1;
    }
    if (transaction.type == TransactionType.moneyIn && transaction.amount < 0) {
      transaction.amount = transaction.amount * -1;
    }

    // break the note into a list of words to help with searching
    Map<String, dynamic> map = transaction.toMap();
    map['notes'] = transaction.note.split(' ');

    if (Get.isRegistered<AllTransactionsController>()) {
      Get.find<AllTransactionsController>()
          .transactionAdd(model: TransactionModel.fromMap(map), id: '');
    }
    await updateMonthSettingAdding(
            transaction: transaction,
            time: '${transaction.date.year}-${transaction.date.month}')
        .then((value) async {
      await _firebaseService.addRecord(
        path: FirebasePaths.transactions.name,
        userId: _userModel.userId,
        map: map,
      );
    });
  }

  // update month setting on adding transaction
  Future<void> updateMonthSettingAdding(
      {required String time, required TransactionModel transaction}) async {
    await Get.find<HomeController>()
        .getMonthSetting(date: time, calc: false)
        .then(
      (_) async {
        Map<String, MonthSettingModel> monthSetting =
            Get.find<HomeController>().monhtMap;
        if (monthSetting[time] != null) {
          int index = monthSetting[time]!.walletInfo.indexWhere(
                (element) => element.wallet == transaction.wallet,
              );
          if (index != -1) {
            monthSetting[time]!.walletInfo[index].opSum += transaction.amount;
          } else {
            WalletInfo walet = WalletInfo(
              wallet: transaction.wallet,
              start: 0,
              currency: _userModel.wallets
                  .firstWhere((element) => element.name == transaction.wallet)
                  .currency,
              end: 0,
              opSum: transaction.amount,
            );
            monthSetting[time]!.walletInfo.add(walet);
          }
        } else {
          WalletInfo walet = WalletInfo(
              wallet: transaction.wallet,
              start: 0,
              currency: transaction.currency,
              end: 0,
              opSum: transaction.amount);
          MonthSettingModel model = MonthSettingModel(
            walletInfo: [walet],
            budgetCat: [],
            budgetVal: [],
            year: transaction.date.year,
            month: transaction.date.month,
            catagory: [],
          );
          monthSetting[time] = model;
        }
        await postMonthSetting(
            time: time, model: monthSetting[time]!, transaction: transaction);
      },
    );
  }

  // post monthsetting update
  Future<void> postMonthSetting(
      {required String time,
      required MonthSettingModel model,
      required TransactionModel transaction}) async {
    Get.find<HomeController>().monhtMap[time] = model;
    await Get.find<HomeController>().moneyNow().then(
      (_) async {
        Get.find<HomeController>()
            .addTransactionUpdate(transaction: transaction);
        await _firebaseService.addRecord(
          docPath: time,
          path: FirebasePaths.monthSetting.name,
          userId: _userModel.userId,
          map: model.toMap(),
        );
      },
    );
  }

  // update transaction
  void updateTransactioin(
      {required TransactionModel transaction, required String recId}) async {
    if (transaction.type == TransactionType.moneyOut &&
        transaction.amount > 0) {
      transaction.amount = transaction.amount * -1;
    }
    if (transaction.type == TransactionType.moneyIn && transaction.amount < 0) {
      transaction.amount = transaction.amount * -1;
    }
    Map<String, dynamic> map = transaction.toMap();
    map['notes'] = transaction.note.split(' ');
    if (Get.isRegistered<AllTransactionsController>()) {
      Get.find<AllTransactionsController>().updateTransaction(
          model: TransactionModel.fromMap(map), id: recId, change: true);
    }
    await _firebaseService.updateRecord(
      path: FirebasePaths.transactions.name,
      recId: recId,
      userId: _userModel.userId,
      map: map,
    );
  }

  // decide if new transaction or editing existing transaction
  void initTransaction() {
    _newTransaction = _transaction == null;
    _walletAmountController.text = '0';
    if (_newTransaction) {
      _transactionAddTime = DateTime.now();
      _transactionType = TransactionType.moneyOut;
      _transactionCurrency = _userModel.defaultCurrency;
    } else {
      _transactionAddTime = _transaction!.date;
      _transactionType = _transaction!.type;
      _transactionAddController.text = _transaction!.amount.toString();
      _transactionCurrency = _transaction!.currency;
      _chosenWallet.text = _transaction!.wallet;
      _fromWalletTransaction.text = _transaction!.fromWallet;
      _toWalletTransaction.text = _transaction!.toWallet;
      _commentController.text = _transaction!.note;
      _catController.text = _transaction!.catagory;
      _subcatController.text = _transaction!.subCatagory;
    }
  }

  // add a wallet
  void addWallet({required BuildContext context}) async {
    if (_walletNameController.text.trim() == '' ||
        _walletAmountController.text.trim() == '') {
      showToast(
        title: CustomText(text: 'infoadd'.tr),
        context: context,
        type: ToastificationType.error,
        isEng: _userModel.language == 'en_US',
      );
    } else {
      Wallet wallet = Wallet(
          name: _walletNameController.text.trim(),
          amount: double.parse(_walletAmountController.text.trim()),
          currency: _walletCurrency);
      _userModel.wallets.add(wallet);
      resetWalletModel(back: true);
      Get.find<HomeController>().update();
      // update user data locally
      await updateUser(model: _userModel).then(
        (value) async {
          if (value) {
            // update user data in backend
            await updateUserFire(model: _userModel);
          }
        },
      );
    }
  }

  // set wallet ccurrency
  void setWalletCurrency({required String currency}) {
    if (currency.trim() != '') {
      _walletCurrency = currency.trim();
    }
  }

  // wallet modal reset
  void resetWalletModel({bool? back}) {
    back != null ? Get.back() : null;
    _walletNameController.clear();
    _walletAmountController.text = '0';
    _walletCurrency = _userModel.defaultCurrency;
  }

  // set catagory
  void setCatagory({required Catagory cat}) {
    for (var i = 0; i < cat.subCatagories.length; i++) {
      _subcats.add(cat.subCatagories[i]);
    }
    _catIcon = cat.icon;
    _catColor = cat.color;
    _catAddController.text = cat.name;
    update();
  }

  // pick icon
  void pickIcon({required BuildContext context}) async {
    showIconPicker(context).then(
      (value) {
        if (value != null) {
          _catIcon = value;
          update();
        }
      },
    );
  }

  // add catagory button
  void addCatagoryButton({
    required BuildContext context,
  }) async {
    if (_catAddController.text.trim() == '' ||
        _catIcon == null ||
        _catColor == backgroundColor) {
      showToast(
          title: CustomText(text: 'infoadd'.tr),
          context: context,
          type: ToastificationType.error,
          isEng: _userModel.language == 'en_US');
    } else {
      Catagory newCat = Catagory(
        name: _catAddController.text.trim(),
        subCatagories: _subcats,
        icon: _catIcon as IconData,
        color: _catColor,
      );
      _userModel.catagories.add(newCat);

      resetModal(back: true);
      update();

      // update user data locally
      await updateUser(model: _userModel).then(
        (value) async {
          if (value) {
            // update user data in backend
            await updateUserFire(model: _userModel);
          }
        },
      );
    }
  }

  // update catagory
  // apply dry principle later
  void updateCategory(
      {required BuildContext context, required int index}) async {
    if (_catAddController.text.trim() == '' ||
        _catIcon == null ||
        _catColor == backgroundColor) {
      showToast(
          title: CustomText(text: 'infoadd'.tr),
          context: context,
          type: ToastificationType.error,
          isEng: _userModel.language == 'en_US');
    } else {
      Catagory newCat = Catagory(
          name: _catAddController.text.trim(),
          subCatagories: _subcats,
          icon: _catIcon as IconData,
          color: _catColor);
      _userModel.catagories[index] = newCat;

      resetModal(back: true);
      update();

      // update user data locally
      await updateUser(model: _userModel).then(
        (value) async {
          if (value) {
            // update user data in backend
            await updateUserFire(model: _userModel);
          }
        },
      );
    }
  }

  // delete category
  void deleteCategory({required int index, required String catNAme}) async {
    Get.back();
    if (_catController.text.trim() == catNAme) {
      _catController.text = '';
    }
    _userModel.catagories.removeAt(index);
    resetModal(back: true);
    update();

    // update user data locally
    await updateUser(model: _userModel).then(
      (value) async {
        if (value) {
          // update user data in backend
          await updateUserFire(model: _userModel);
        }
      },
    );
  }

  // catagory delete check
  void catagoryDeleteCheck({required Widget widget}) {
    Get.dialog(widget);
  }

  // update user locally
  Future<bool> updateUser({required UserModel model}) {
    return Get.find<GloableAuthController>().userChange(model: model);
  }

  // update user in backend
  Future<void> updateUserFire({required UserModel model}) {
    return _firebaseService.updateUsers(model: model);
  }

  // reset modal
  void resetModal({bool? back}) {
    back != null ? Get.back() : null;

    _catAddController.clear();
    _subCatAddController.clear();
    _subcats = [];
    _catIcon = null;
    _catColor = backgroundColor;
  }

  // delete subcategories
  void subDelete({required int index}) {
    _subcats.removeAt(index);
    update();
  }

  // pick color
  void pickColor({required Widget widget}) async {
    Get.dialog(widget);
  }

  // sub catagory submitt
  void subCategorySubmit({required String sub}) {
    if (sub.trim() != '') {
      _subcats.add(sub.trim());
      _subCatAddController.clear();
      _subCatNode.requestFocus();

      update();
    }
  }

  // change color
  void changeColor({required Color color}) {
    if (color != _catColor) {
      _catColor = color;
    }
  }

  // close color picker
  void closeColorPicker() {
    Get.back();
    update();
  }

  // dispose
  void dosposeResource() {
    _transactionAddController.dispose();
    _transactionAddNode.dispose();
    _commentController.dispose();
    _commentNodee.dispose();
    _catAddController.dispose();
    _catAddNode.dispose();
    _subCatAddController.dispose();
    _subCatNode.dispose();
    _walletNameNode.dispose();
    _walletNameController.dispose();
    _walletAmountController.dispose();
    _walletAmountNode.dispose();
    _chosenWallet.dispose();
    _toWalletTransaction.dispose();
    _fromWalletTransaction.dispose();
    _catController.dispose();
    _subcatController.dispose();
  }

  // pick time for transaction
  void transactionTime({required BuildContext context}) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          currentDate: _transactionAddTime,
          calendarType: CalendarDatePicker2Type.single),
      dialogSize: const Size(325, 400),
      value: [_transactionAddTime],
      borderRadius: BorderRadius.circular(15),
    ).then(
      (value) {
        if (value != null && value.isNotEmpty) {
          _transactionAddTime = value[0] as DateTime;
          update();
        }
      },
    );
  }

  // set transaction type
  void setTransactionType({required TransactionType type}) {
    if (type != _transactionType) {
      _transactionType = type;
      update();
    }
  }

  // update
  void reload() {
    update();
  }

  // set listeners
  void setListeners() {
    _transactionAddNode.addListener(() {
      _isActive = _transactionAddNode.hasFocus;
      update();
    });

    _commentNodee.addListener(() {
      _commentActive = _commentNodee.hasFocus;
      update();
    });

    _catAddNode.addListener(() {
      _catNameActive = _catAddNode.hasFocus;
      update();
    });
    _subCatNode.addListener(() {
      _subCatActive = _subCatNode.hasFocus;
      update();
    });

    _walletAmountNode.addListener(() {
      _walletAmountActive = _walletAmountNode.hasFocus;
      update();
    });

    _walletNameNode.addListener(() {
      _walletNameActive = _walletNameNode.hasFocus;
      update();
    });
  }

  // set transaction currencey
  void setTransactionCurrencey({required String currencey}) {
    if (currencey != '') {
      _transactionCurrency = currencey;
    }
  }
}
