import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cashify/data_models/export.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/data_models/filter_model.dart';
import 'package:cashify/pages/add_transaction_page/add_transaction_view.dart';
import 'package:cashify/pages/all_transactions_page/repository.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class AllTransactionsController extends GetxController {
  final AllTransactionsRepository _repo = AllTransactionsRepository();
  final FirebaseService _firebaseService = FirebaseService();

  late UserDataModel _userModel;
  UserDataModel get userModel => _userModel;

  final bool _isIos = Get.find<GloableAuthController>().isIos;
  bool get isIos => _isIos;

  bool _descending = true;
  bool get descending => _descending;

  final List<TransactionDataModel> _transactionList = [];
  List<TransactionDataModel> get transactionList => _transactionList;

  final List<TransactionDataModel> _searchRes = [];
  List<TransactionDataModel> get searchRes => _searchRes;

  String _order = 'date';
  String get order => _order;

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
      'transactions': <TransactionDataModel>[],
      'loading': false
    },
    2: {
      'ids': <String>[],
      'transactions': <TransactionDataModel>[],
      'loading': false
    },
    3: {
      'ids': <String>[],
      'transactions': <TransactionDataModel>[],
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
      (_container[_pointer]!['transactions'] as List<TransactionDataModel>)
          .clear();
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
    await _repo
        .getAllTransactions(
            userId: _userModel.userId,
            order: _order,
            descending: _descending,
            lastDocu: _lastDocument)
        .then((value) {
      if (value.docs.isNotEmpty) {
        _lastDocument = value.docs.last;
        for (var i = 0; i < value.docs.length; i++) {
          TransactionDataModel model = TransactionDataModel.fromMap(
              value.docs[i].data() as Map<String, dynamic>);
          (_container[_pointer]!['transactions'] as List<TransactionDataModel>)
              .add(model);
          (_container[_pointer]!['ids'] as List<String>).add(value.docs[i].id);
        }
      }
      _container[_pointer]!['loading'] = false;
      update();
    });
  }

  // search in notes
  void searchNotes({required String query}) async {
    if (query.trim() != '') {
      _pointer = 2;
      _container[_pointer]!['loading'] = true;
      (_container[_pointer]!['transactions'] as List<TransactionDataModel>)
          .clear();
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
              TransactionDataModel model = TransactionDataModel.fromMap(
                  value.docs[i].data() as Map<String, dynamic>);
              (_container[_pointer]!['transactions']
                      as List<TransactionDataModel>)
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

  // edit a transaction
  void queryTransaction({required TransactionDataModel model}) {
    Get.to(
      () => const AddTransactionView(),
      arguments: {
        'model': model,
      },
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
  void transactionAdd(
      {required TransactionDataModel model, required String id}) {
    (_container[1]!['ids'] as List<String>).insert(0, id);
    (_container[1]!['transactions'] as List<TransactionDataModel>)
        .insert(0, model);
    update();
  }

  // update transaction
  void updateTransaction({
    required TransactionDataModel model,
  }) {
    Get.back();
    for (var i = 1; i < 4; i++) {
      int index = (_container[i]!['ids'] as List<String>).indexOf(model.id);

      if (index != -1) {
        (_container[i]!['transactions'] as List<TransactionDataModel>)
          ..removeAt(index)
          ..insert(index, model);
        update();
      }
    }
  }

  // delete a transaction
  Future<void> transDelete(
      {required TransactionDataModel transaction,
      required BuildContext context}) async {
    for (var i = 1; i < 4; i++) {
      int index =
          (_container[i]!['ids'] as List<String>).indexOf(transaction.id);
      if (index != -1) {
        (_container[i]!['transactions'] as List<TransactionDataModel>)
            .removeAt(index);
        (_container[i]!['ids'] as List<String>).removeAt(index);
        update();
        Get.back();
      }
    }
    await Get.find<HomeController>()
        .transactionOperation(
            transaction: transaction, type: OperationTyoe.delete)
        .onError(
          (error, stackTrace) => showToast(
            title: CustomText(
              text: 'error'.tr,
            ),
            description: CustomText(text: error.toString()),
            context: context,
            type: ToastificationType.error,
            isEng: _userModel.language == 'en_US',
          ),
        );
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
        (_container[_pointer]!['transactions'] as List<TransactionDataModel>)
            .clear();
        (_container[_pointer]!['ids'] as List<String>).clear();
        update();
        _firebaseService
            .filteredTransactions(
          filter: _filterModel,
        )
            .then(
          (value) {
            for (var i = 0; i < value.docs.length; i++) {
              TransactionDataModel model = TransactionDataModel.fromMap(
                  value.docs[i].data() as Map<String, dynamic>);
              (_container[_pointer]!['transactions']
                      as List<TransactionDataModel>)
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
