import 'package:cashify/data_models/filter_model.dart';
import 'package:cashify/data_models/monthsetting_data_model.dart';
import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/local_storage/local_storage.dart';
import 'package:cashify/services/currency_exchange_service.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {
  final LocalStorage _localStorage = LocalStorage();
  final FirebaseService _firebaseService = FirebaseService();

  // get local uset data
  Future<UserDataModel> getUserData() async {
    return await _localStorage.getUserData();
  }

  // get local trransactions
  Future<List<dynamic>> getTransactions() async {
    return await _localStorage.getTransactionList();
  }

  // get local month setting data
  Future<Map<String, MonthSettingDataModel>> getMonthSetting() async {
    return await _localStorage.getMonthSettingList();
  }

  // get recoeds
  Future<QuerySnapshot> getRecords(
      {required String userId, required String path}) async {
    return _firebaseService.getRecords(userId: userId, path: path);
  }

  // get transactions filtered
  Future<QuerySnapshot> getTransactionsOnline(
      {required FilterModel model}) async {
    return _firebaseService.filteredTransactions(filter: model);
  }

  // currency swap
  Future<String> getCurrencySwap(
      {required String from,
      required String to,
      required double amount}) async {
    var res = await MoneyExchange()
        .changeCurrency(base: from, exchange: to, amount: amount);

    return res.result;
  }

  // add record
  Future<void> addRecord(
      {required Map<String, dynamic> data,
      required String path,
      required String userId,
      String? docPath}) async {
    await _firebaseService.addRecord(
        path: path, userId: userId, map: data, docPath: docPath);
  }

  // set isSynced to true
  Future<void> setIsSynced({required String userId, required bool val}) async {
    await _firebaseService.cloudSync(userId: userId, val: val);
  }

  // update user data locally
  Future<void> updateUserLocally({required UserDataModel user}) async {
    await _localStorage.saveUser(model: user);
  }

  // update user in backend
  Future<void> udpateUser({required UserDataModel user}) async {
    await _firebaseService.updateUsers(model: user);
  }

  // save data locally abc then in backend
  Future<void> saveAllData({required UserDataModel user}) async {
    await updateUserLocally(user: user).then((value) async {
      await udpateUser(user: user);
    });
  }

  // save transactions locally
  Future<void> saveTransactions({required List<dynamic> list}) async {
    await _localStorage.saveTransaction(list: list);
  }

  // save month setting locally
  Future<void> saveMonthSetting(
      {required Map<String, MonthSettingDataModel> model}) async {
    await _localStorage.saveMonthSetting(list: model);
  }

  // delete recoed
  Future<void> deleteRec(
      {required String path,
      required String userId,
      required String docId}) async {
    await _firebaseService.deleteRecord(
        path: path, userId: userId, recId: docId);
  }

  // check if record exists
  Future<bool> checkRecordExists(
      {required String path,
      required String userId,
      required String docId}) async {
    var docu = await _firebaseService.getRecordDocu(
        userId: userId, path: path, docId: docId);
    return docu.exists;
  }

  // get document data
  Future<Map<String, dynamic>> getDocuData(
      {required String path,
      required String userId,
      required String docId}) async {
    var docu = await _firebaseService.getRecordDocu(
        userId: userId, path: path, docId: docId);
    return docu.data() as Map<String, dynamic>;
  }
}
