import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/transaction_model.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/add_transaction_page/add_transaction_view.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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

  final List<String> _ids = [];
  List<String> get ids => _ids;

  final List<String> _searchedIds = [];
  List<String> get searchedIds => _searchedIds;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  final FocusNode _searchNode = FocusNode();
  FocusNode get searchNode => _searchNode;

  bool _searchActive = false;
  bool get searchActive => _searchActive;

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

  @override
  void onInit() {
    super.onInit();
    setListener();

    _userModel = Get.find<GloableAuthController>().userModel;
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

  // delete a transaction
  void deleteTransaction(
      {required TransactionModel model, required String id}) async {
    String transId = id;
    Get.back();
    for (var i = 1; i < 4; i++) {
      print(
          '$i index is => ${(_container[i]!['transactions'] as List<TransactionModel>).indexOf(model)}');
      print('$i ids ${(_container[i]!['ids'] as List<String>).length}');
      print(
          '$i transactions ${(_container[i]!['transactions'] as List<TransactionModel>).length}');
      // if (_pointer == i) {
      //   (_container[_pointer]!['transactions'] as List<TransactionModel>)
      //       .remove(model);

      //   (_container[_pointer]!['ids'] as List<String>).remove(transId);
      // } else {
      //   if ((_container[i]!['ids'] as List<String>).contains(transId)) {
      //     (_container[i]!['transactions'] as List<TransactionModel>)
      //         .remove(model);

      //     (_container[i]!['ids'] as List<String>).remove(transId);
      //     // print('removed from $i');
      //   }
      //}
      print('$i ids ${(_container[i]!['ids'] as List<String>).length}');
      print(
          '$i transactions ${(_container[i]!['transactions'] as List<TransactionModel>).length}');
    }

    // update();
    // _firebaseService.deleteRecord(
    //   path: FirebasePaths.transactions.name,
    //   recId: transId,
    //   userId: _userModel.userId,
    // );
  }
}
