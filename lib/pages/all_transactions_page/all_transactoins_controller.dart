import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/filter_model.dart';
import 'package:cashify/models/transaction_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/add_transaction_page/add_transaction_view.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class AllTransactionsController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  bool _descending = true;
  bool get descending => _descending;

  final List<TransactionModel> _transactionList = [];
  List<TransactionModel> get transactionList => _transactionList;

  final List<TransactionModel> _searchRes = [];
  List<TransactionModel> get searchRes => _searchRes;

  String _order = 'date';
  String get order => _order;

  String _exchangeVal = '';
  String get exchangeVal => _exchangeVal;

  final List<String> _ids = [];
  List<String> get ids => _ids;

  final List<String> _searchedIds = [];
  List<String> get searchedIds => _searchedIds;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  final FocusNode _searchNode = FocusNode();
  FocusNode get searchNode => _searchNode;

  final TextEditingController _rangeStartController = TextEditingController();
  TextEditingController get rangeStartController => _rangeStartController;

  final FocusNode _rangeStartNode = FocusNode();
  FocusNode get rangeStartNode => _rangeStartNode;

  final TextEditingController _rangeEndController = TextEditingController();
  TextEditingController get rangeEndController => _rangeEndController;

  final FocusNode _rangeEndNode = FocusNode();
  FocusNode get rangeEndNode => _rangeEndNode;

  bool _searchActive = false;
  bool get searchActive => _searchActive;

  bool _exchangeActive = false;
  bool get exchangeActive => _exchangeActive;

  bool _rangeStartActive = false;
  bool get rangeStartActive => _rangeStartActive;

  bool _rangeEndActive = false;
  bool get rangeEndActive => _rangeEndActive;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  int _pointer = 1;
  int get pointer => _pointer;

  final Map<int, Map<String, dynamic>> _container = {
    1: {
      'ids': <String>[],
      'transactions': <TransactionModel>[],
      'loading': false
    },
    2: {
      'ids': <String>[],
      'transactions': <TransactionModel>[],
      'loading': false
    },
    3: {
      'ids': <String>[],
      'transactions': <TransactionModel>[],
      'loading': false
    }
  };
  Map<int, dynamic> get container => _container;

  DocumentSnapshot? _lastDocument;

  late FilterModel _filterModel;
  FilterModel get filterModel => _filterModel;

  @override
  void onInit() {
    super.onInit();
    setListener();

    _userModel = Get.find<GloableAuthController>().userModel;
    _filterModel = FilterModel(
        path: FirebasePaths.transactions.name, userId: _userModel.userId);
    getAllTransactions();
  }

  @override
  void onClose() {
    super.onClose();
    _searchNode.removeListener(_setNode);
    _searchNode.dispose();
    _searchController.dispose();
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    _rangeStartController.dispose();
    _rangeEndController.dispose();
    _rangeStartNode.dispose();
    _rangeEndNode.dispose();
    _rangeStartNode.removeListener(_rangeStartNodes);
    _rangeEndNode.removeListener(_rangeEndNodes);
  }

  void _rangeStartNodes() {
    _rangeStartActive = _rangeStartNode.hasFocus;
    update();
  }

  void _rangeEndNodes() {
    _rangeEndActive = _rangeEndNode.hasFocus;
    update();
  }

  // change the ordering method of the firstore query
  void orderChange({required String method}) {
    Get.back();
    _order = method;
  }

  // change ascending to descending
  void changeAscending() {
    if (_container[_pointer]!['loading'] == false && _pointer == 1) {
      _descending = !_descending;
      (_container[_pointer]!['transactions'] as List<TransactionModel>).clear();
      _lastDocument = null;
      getAllTransactions();
    }
  }

  // delete dialog
  void deleteDialog({required Widget dilog}) {
    Get.dialog(dilog);
  }

  // set listener
  void setListener() {
    _searchNode.addListener(_setNode);
    _scrollController.addListener(_loadMore);
    _rangeStartNode.addListener(_rangeStartNodes);
    _rangeEndNode.addListener(_rangeEndNodes);
  }

  // search node set
  void _setNode() {
    _searchActive = _searchNode.hasFocus;
    update();
  }

  // get all transactions
  void getAllTransactions() async {
    _container[_pointer]!['loading'] = true;
    update();
    await _firebaseService
        .getTransactions(
      userId: _userModel.userId,
      order: _order,
      descending: _descending,
      lastDocu: _lastDocument,
    )
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          _lastDocument = value.docs.last;
          for (var i = 0; i < value.docs.length; i++) {
            TransactionModel model = TransactionModel.fromMap(
                value.docs[i].data() as Map<String, dynamic>);
            (_container[_pointer]!['transactions'] as List<TransactionModel>)
                .add(model);
            (_container[_pointer]!['ids'] as List<String>)
                .add(value.docs[i].id);
          }
          _container[_pointer]!['loading'] = false;
          update();
        }
      },
    );
  }

  // search in notes
  void searchNotes({required String query}) async {
    if (query.trim() != '') {
      _pointer = 2;
      _container[_pointer]!['loading'] = true;
      (_container[_pointer]!['transactions'] as List<TransactionModel>).clear();
      (_container[_pointer]!['ids'] as List<String>).clear();
      update();
      String q = query.trim();
      List<String> notes = q.split(' ');
      await _firebaseService
          .searchTransactions(
        query: notes,
        userId: _userModel.userId,
        path: FirebasePaths.transactions.name,
        descending: _descending,
        order: 'date',
        field: 'notes',
      )
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
            for (var i = 0; i < value.docs.length; i++) {
              TransactionModel model = TransactionModel.fromMap(
                  value.docs[i].data() as Map<String, dynamic>);
              (_container[_pointer]!['transactions'] as List<TransactionModel>)
                  .add(model);
              (_container[_pointer]!['ids'] as List<String>)
                  .add(value.docs[i].id);
            }
          }
          _container[_pointer]!['loading'] = false;
          update();
        },
      );
    }
  }

  // close search mode
  void closeSearchMode() {
    _pointer = 1;
    _searchController.clear();
    update();
  }

  // get icon
  IconData getIcon({required String category}) {
    return _userModel.catagories
        .firstWhere((element) => element.name == category)
        .icon;
  }

  // get color
  Color getColor({required String category}) {
    return _userModel.catagories
        .firstWhere((element) => element.name == category)
        .color;
  }

  // format amount
  String ammount({required TransactionModel model, required bool real}) {
    return real
        ? Get.find<HomeController>().walletAmount(amount: model.amount)
        : Get.find<HomeController>().humanFormat(model.amount);
  }

  String moneyFormat({required double amount}) {
    return Get.find<HomeController>().moneyFormat(amount: amount);
  }

  // show dialog
  void dialogShow({
    required Widget widget,
    required BuildContext context,
  }) {
    _exchangeActive = false;
    _exchangeVal = '';
    dialogShowing(widget: widget);
  }

  // currency exchange
  void currencyExchange(
      {required String base,
      required String to,
      required double amount}) async {
    if (to != '') {
      await Get.find<HomeController>()
          .currencySwapp(base: base, exTo: to, amount: amount)
          .then(
        (value) {
          if (value != '') {
            _exchangeActive = true;
            _exchangeVal = value;
            update();
          }
        },
      );
    }
  }

  // edit a transaction
  void queryTransaction({required TransactionModel model, required String id}) {
    Get.to(
      () => const AddTRansactionView(),
      arguments: {'model': model, 'id': id},
    );
  }

  // load more transactions
  void _loadMore() {
    if (_pointer == 1 && _container[_pointer]!['loading'] == false) {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          null;
        } else {
          // load more
          getAllTransactions();
        }
      }
    }
  }

  // add a transaction
  void transactionAdd({required TransactionModel model, required String id}) {
    (_container[1]!['ids'] as List<String>).insert(0, id);
    (_container[1]!['transactions'] as List<TransactionModel>).insert(0, model);
    update();
  }

  // update or delete transaction locally
  void updateTransaction(
      {required TransactionModel model,
      required String id,
      required bool change}) {
    Get.back();
    for (var i = 1; i < 4; i++) {
      if ((_container[i]!['ids'] as List<String>).contains(id)) {
        int index = (_container[i]!['ids'] as List<String>).indexOf(id);
        if (change) {
          (_container[i]!['transactions'] as List<TransactionModel>)[index] =
              model;
          update();
        } else {
          (_container[i]!['transactions'] as List<TransactionModel>)
              .removeAt(index);
          (_container[i]!['ids'] as List<String>).removeAt(index);
          update();
          _firebaseService.deleteRecord(
            path: FirebasePaths.transactions.name,
            recId: id,
            userId: _userModel.userId,
          );
        }
      }
    }
  }

  // filter
  void filterRes({required BuildContext context}) async {
    if (_container[_pointer]!['loading'] == false) {
      Get.back();
      try {
        _filterModel.eqbig = rangeStartController.text.trim() != ''
            ? double.parse(_rangeStartController.text.trim())
            : null;
        _filterModel.small = _rangeEndController.text.trim() != ''
            ? double.parse(_rangeEndController.text.trim())
            : null;
        _pointer = 3;
        _container[_pointer]!['loading'] = true;
        (_container[_pointer]!['transactions'] as List<TransactionModel>)
            .clear();
        (_container[_pointer]!['ids'] as List<String>).clear();
        update();
        _firebaseService
            .filteredTransactions(
          filter: _filterModel,
        )
            .then(
          (value) {
            print(value.docs.length);
            for (var i = 0; i < value.docs.length; i++) {
              TransactionModel model = TransactionModel.fromMap(
                  value.docs[i].data() as Map<String, dynamic>);
              (_container[_pointer]!['transactions'] as List<TransactionModel>)
                  .add(model);
              (_container[_pointer]!['ids'] as List<String>)
                  .add(value.docs[i].id);
            }
            _container[_pointer]!['loading'] = false;
            update();
          },
        );
      } catch (e) {
        showToast(
            title: CustomText(text: e.toString()),
            context: context,
            type: ToastificationType.error,
            isEng: _userModel.language == 'en_US');
      }
    }
  }

  // reset filters
  void resetFilter({required bool cancel}) {
    cancel ? _pointer = 1 : null;
    Get.back();
    _filterModel = FilterModel(
        userId: _userModel.userId, path: FirebasePaths.transactions.name);
    _rangeStartController.clear();
    _rangeEndController.clear();
    update();
  }

  // chose times for the filter
  void filterTime({required bool start, required BuildContext context}) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.single),
      dialogSize: const Size(325, 400),
      value: [],
      borderRadius: BorderRadius.circular(15),
    ).then(
      (value) {
        if (value != null) {
          start
              ? _filterModel.timeStart =
                  Timestamp.fromDate(value[0] as DateTime)
              : _filterModel.timeEnd = Timestamp.fromDate(value[0] as DateTime);
          update();
        }
      },
    );
  }

  (List<String> cats, List<String> subCats) lsts() {
    List<String> one = [];
    List<String> two = [];
    for (var i = 0; i < _userModel.catagories.length; i++) {
      one.add(_userModel.catagories[i].name);
      for (var x = 0; x < userModel.catagories[i].subCatagories.length; x++) {
        two.add(userModel.catagories[i].subCatagories[x]);
      }
    }
    return (one, two);
  }

  // chose catagory or subcatagory for filter
  void catsFilter({required String cat, required String val}) {
    switch (cat) {
      case 'cat':
        _filterModel.category = val;
        break;

      case 'sub':
        _filterModel.subCat = val;
        break;
      case 'curr':
        _filterModel.cuurency = val;
        break;
    }
    update();
  }
}
