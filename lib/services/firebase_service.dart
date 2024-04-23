import 'package:cashify/models/user_model.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection(FirebasePaths.users.name);

  // add user data to firebase
  Future<void> addUsers({required UserModel model}) async {
    return await _ref.doc(model.userId).set(model.toMap());
  }

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }
}
