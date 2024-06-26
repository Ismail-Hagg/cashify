import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/data_models/filter_model.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection(FirebasePaths.users.name);

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // add user data to firebase
  Future<void> addUsers({required UserDataModel model}) async {
    await _ref.doc(model.userId).set(model.toMap());
  }

  // update user data to firebase
  Future<void> updateUsers({required UserDataModel model}) async {
    await _ref.doc(model.userId).update(model.toMap());
  }

  // add records
  Future<void> addRecord(
      {required String path,
      required String userId,
      String? docPath,
      required Map<String, dynamic> map}) async {
    await _ref.doc(userId).collection(path).doc(docPath).set(map);
  }

  // update records
  Future<void> updateRecord(
      {required String path,
      required String recId,
      required String userId,
      required Map<String, dynamic> map}) async {
    await _ref.doc(userId).collection(path).doc(recId).update(map);
  }

  // delete records
  Future<void> deleteRecord({
    required String path,
    required String recId,
    required String userId,
  }) async {
    await _ref.doc(userId).collection(path).doc(recId).delete();
  }

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }

  // get records for manin page
  Future<QuerySnapshot> getRecords(
      {required String userId, required String path}) async {
    return await _ref.doc(userId).collection(path).get();
  }

  // get records for manin page
  Future<DocumentSnapshot> getRecordDocu(
      {required String userId,
      required String path,
      required String docId}) async {
    return await _ref.doc(userId).collection(path).doc(docId).get();
  }

  // get transactions with filters
  Future<QuerySnapshot> filteredTransactions(
      {required FilterModel filter}) async {
    return await _ref
        .doc(filter.userId)
        .collection(filter.path)
        .where('date', isGreaterThanOrEqualTo: filter.timeStart)
        .where('date', isLessThanOrEqualTo: filter.timeEnd)
        .where('currency', isEqualTo: filter.cuurency)
        .where('amount', isGreaterThanOrEqualTo: filter.eqbig)
        .where('amount', isLessThanOrEqualTo: filter.small)
        .where('catagory', isEqualTo: filter.category)
        .where('subCatagory', isEqualTo: filter.subCat)
        .get();
  }

  // get transactions for all transactions page
  Future<QuerySnapshot> getTransactions(
      {required String userId,
      required String order,
      required bool descending,
      DocumentSnapshot? lastDocu}) async {
    QuerySnapshot snap = lastDocu != null
        ? await _ref
            .doc(userId)
            .collection(FirebasePaths.transactions.name)
            .orderBy(order, descending: descending)
            .startAfterDocument(lastDocu)
            .limit(10)
            .get()
        : await _ref
            .doc(userId)
            .collection(FirebasePaths.transactions.name)
            .orderBy(order, descending: descending)
            .limit(10)
            .get();
    return snap;
  }

  // search through records
  Future<QuerySnapshot> searchTransactions(
      {required List<String> query,
      required String userId,
      required String path,
      required bool descending,
      required String order,
      required String field}) async {
    return await _ref
        .doc(userId)
        .collection(path)
        .where(field, arrayContainsAny: query)
        .get();
  }

  // // cloud funciton to change the isSynced field to falsd
  Future<bool> cloudSync({required String userId, required bool val}) async {
    HttpsCallable callable = _functions.httpsCallable('syncOut');
    try {
      final response =
          await callable.call(<String, dynamic>{'userId': userId, 'val': val});

      return response.data == null ? false : true;
    } catch (e) {
      return false;
    }
  }
}
