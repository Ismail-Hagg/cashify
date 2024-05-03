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

  Catagory? _catagory;
  Catagory? get catagory => _catagory;

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

  final List<Catagory> _catList = [
    Catagory(
      name: 'thing',
      subCatagories: ['subCatagories'],
      icon: Icons.add,
      color: Colors.red,
    ),
    Catagory(
      name: 'other thing',
      subCatagories: ['kool', 'dj lhalid'],
      icon: Icons.golf_course,
      color: Colors.green,
    )
  ];
  List<Catagory> get catList => _catList;

  List<String> _subcats = [];
  List<String> get subcats => _subcats;

  IconData? _catIcon;
  IconData? get catIcon => _catIcon;

  Color _catColor = backgroundColor;
  Color get catColor => _catColor;

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
    Catagory newCat = Catagory(
        name: cat.name,
        subCatagories: cat.subCatagories,
        icon: cat.icon,
        color: cat.color);
    _catagory = newCat;
    _catAddController.text = cat.name;
  }

  // pick icon
  void pickIcon({required BuildContext context, required bool isNew}) async {
    showIconPicker(context).then(
      (value) {
        if (value != null) {
          isNew ? _catIcon = value : _catagory!.icon = value;
          update();
        }
      },
    );
  }

  // add catagory button
  void addCatagoryButton({required BuildContext context}) async {
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
  void updateCategory({required int index}) async {
    print(_catagory!.toMap());
    print(_userModel.catagories[index].toMap());
    // if (_catagory!.toMap() == _userModel.catagories[index].toMap()) {
    //   print('samseeeees');
    // } else {
    //   print('boooooooo');
    // }
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
    _catagory = null;
    _catAddController.clear();
    _subCatAddController.clear();
    _subcats = [];
    _catIcon = null;
    _catColor = backgroundColor;
  }

  // delete subcategories
  void subDelete({required int index, required bool isNew}) {
    isNew ? _subcats.removeAt(index) : _catagory!.subCatagories.removeAt(index);
    update();
  }

  // pick color
  void pickColor({required Widget widget}) async {
    Get.dialog(widget);
  }

  // sub catagory submitt
  void subCategorySubmit({required String sub, required bool isNew}) {
    if (sub.trim() != '') {
      isNew ? _subcats.add(sub.trim()) : _catagory!.subCatagories.add(sub);
      _subCatAddController.clear();
      _subCatNode.requestFocus();
      update();
    }
  }

  // change color
  void changeColor({required Color color, required bool isNew}) {
    if (color != _catColor) {
      isNew ? _catColor = color : _catagory!.color = color;
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
