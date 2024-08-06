import 'package:cashify/services/currency_exchange_service.dart';
import 'package:cashify/services/firebase_service.dart';

class MonthSeettingRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // currency swap
  Future<String> getCurrencySwap(
      {required String from,
      required String to,
      required double amount}) async {
    var res = await MoneyExchange()
        .changeCurrency(base: from, exchange: to, amount: amount);

    return res.result;
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
