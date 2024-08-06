import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/data_models/export.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/add_transaction_page/repository.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
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
import 'package:uuid/uuid.dart';

class AddTransactionController extends GetxController {
  final AddTransactionRepository _repo = AddTransactionRepository();

  late UserDataModel _userModel;
  UserDataModel get userModel => _userModel;

  late TransactionDataModel? _transaction;
  TransactionDataModel? get transaction => _transaction;

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

  int? oldIndex;
  bool? spacial;

  @override
  void onInit() {
    super.onInit();
    _transaction = Get.arguments == null ? null : Get.arguments['model'];
    oldIndex = Get.arguments == null ? null : Get.arguments['indexs'];
    spacial = Get.arguments == null ? null : Get.arguments['spacial'];
    _userModel = Get.find<HomeController>().userModel;
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
    required BuildContext context,
  }) async {
    bool transferError = _transactionType == TransactionType.transfer &&
        (_transactionAddController.text.trim() == '' ||
            _fromWalletTransaction.text.trim() == '' ||
            _toWalletTransaction.text.trim() == '');

    bool regError = _transactionType != TransactionType.transfer &&
        (_transactionAddController.text.trim() == '' ||
            _catController.text.trim() == '' ||
            _chosenWallet.text.trim() == '');

    bool walletError = _transactionType == TransactionType.transfer &&
        (_fromWalletTransaction.text.trim() ==
            _toWalletTransaction.text.trim());

    int noCat = _userModel.catagories
        .indexWhere((element) => element.name == _catController.text.trim());

    if (transferError || regError || walletError || noCat == -1) {
      showToast(
        title: CustomText(
            text: (transferError && walletError)
                ? 'otherwallet'.tr
                : 'infoadd'.tr),
        context: context,
        type: ToastificationType.error,
        isEng: _userModel.language == 'en_US',
      );
    } else {
      TransactionDataModel model = TransactionDataModel(
        id: _newTransaction || spacial != null
            ? const Uuid().v4()
            : _transaction!.id,
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
      Get.back();
      if (model.type == TransactionType.transfer) {
        Get.find<HomeController>().transferBetweenWallets(model: model);
      } else {
        if (_newTransaction == false && spacial == null) {
          Get.find<AllTransactionsController>().updateTransaction(model: model);
        }

        await Get.find<HomeController>()
            .transactionOperation(
                old: _transaction,
                transaction: model,
                type: _newTransaction || spacial != null
                    ? OperationTyoe.add
                    : OperationTyoe.update)
            .onError((error, stackTrace) {});
      }
    }
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

//   // add a wallet
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
      WalletModel wallet = WalletModel(
          name: _walletNameController.text.trim(),
          amount: double.parse(_walletAmountController.text.trim()),
          currency: _walletCurrency);
      _userModel.wallets.add(wallet);
      resetWalletModel(back: true);
      update();
      Get.find<HomeController>()
        ..userModel.wallets = _userModel.wallets
        ..update();
      await _repo.saveAllData(user: _userModel);
    }
  }

  // delete wallet
  void deleteWallet(
      {required WalletModel wallet, required BuildContext context}) async {
    if (wallet.amount != 0.0) {
      showToast(
        title: CustomText(text: 'wallmpt'.tr),
        context: context,
        type: ToastificationType.error,
        isEng: _userModel.language == 'en_US',
      );
      return;
    }

    _userModel.wallets.remove(wallet);
    update();
    Get.find<HomeController>()
      ..userModel.wallets = _userModel.wallets
      ..update();
    await _repo.saveAllData(user: _userModel);
  }

//   // set wallet ccurrency
  void setWalletCurrency({required String currency}) {
    if (currency.trim() != '') {
      _walletCurrency = currency.trim();
    }
  }

//   // wallet modal reset
  void resetWalletModel({bool? back}) {
    back != null ? Get.back() : null;
    _walletNameController.clear();
    _walletAmountController.text = '0';
    _walletCurrency = _userModel.defaultCurrency;
  }

  // set catagory
  void setCatagory({required CatagoryModel cat}) {
    for (var i = 0; i < cat.subCatagories.length; i++) {
      _subcats.add(cat.subCatagories[i]);
    }
    _catIcon = iconConvert(code: cat.icon);
    _catColor = colorConvert(code: cat.color);
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
    required bool isUpdate,
    required int index,
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
      CatagoryModel newCat = CatagoryModel(
        name: _catAddController.text.trim(),
        subCatagories: _subcats,
        icon: '${_catIcon!.codePoint}-${_catIcon!.fontFamily}',
        color: _catColor.value,
      );
      if (isUpdate) {
        _userModel.catagories[index] = newCat;
        Get.find<HomeController>()
            .updateCategory(model: newCat, user: _userModel);
      } else {
        _userModel.catagories.add(newCat);
      }

      update();
      resetModal(back: true);

      await _repo.saveAllData(user: _userModel);
    }
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

//   // set transaction type
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
