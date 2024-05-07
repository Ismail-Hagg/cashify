import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/catagory_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class AddTransactionController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  DateTime _transactionAddTime = DateTime.now();
  DateTime get transactionAddTime => _transactionAddTime;

  TransactionType _transactionType = TransactionType.moneyOut;
  TransactionType get transactionType => _transactionType;

  final Map<String, String> _operations = {
    TransactionType.moneyIn.name: 'inc'.tr,
    TransactionType.moneyOut.name: 'exx'.tr,
    TransactionType.transfer.name: 'transfer'.tr
  };

  Map<String, String> get operators => _operations;

  bool _isActive = false;
  bool get isActive => _isActive;

  String _chosenCategory = '';
  String get chosenCategory => _chosenCategory;

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

  bool _commentActive = false;
  bool get commentActive => _commentActive;

  bool _catNameActive = false;
  bool get catNameActive => _catNameActive;

  bool _subCatActive = false;
  bool get subCatActive => _subCatActive;

  String _transactionCurrency = '';
  String get transactionCurrency => _transactionCurrency;

  List<dynamic> _subcats = [];
  List<dynamic> get subcats => _subcats;

  IconData? _catIcon;
  IconData? get catIcon => _catIcon;

  Color _catColor = backgroundColor;
  Color get catColor => _catColor;

  bool _catDelete = false;
  bool get catDelete => _catDelete;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<GloableAuthController>().userModel;
    setListeners();
  }

  @override
  void onClose() {
    super.onClose();
    dosposeResource();
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
    if (_catDelete) {
      deleteCategory(index: index);
    } else {
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
  }

  // delete category
  void deleteCategory({required int index}) async {
    Get.back();
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
    _catDelete = false;
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
  }

  // pick time for transaction
  void transactionTime({required BuildContext context}) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.single),
      dialogSize: const Size(325, 400),
      value: [],
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

  // set chosen category
  void setChosenCategory({required String category}) {
    _chosenCategory = category;
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
  }

  // set transaction currencey
  void setTransactionCurrencey({required String currencey}) {
    if (currencey != '') {
      _transactionCurrency = currencey;
    }
  }
}
