import 'package:cashify/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllTransactionsRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // ge transactions
  Future<QuerySnapshot> getAllTransactions(
      {required String userId,
      required String order,
      required bool descending,
      required DocumentSnapshot? lastDocu}) async {
    return await _firebaseService.getTransactions(
      userId: userId,
      order: order,
      descending: descending,
      lastDocu: lastDocu,
    );
  }
}
