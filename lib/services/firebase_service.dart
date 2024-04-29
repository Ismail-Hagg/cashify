import 'package:cashify/models/user_model.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection(FirebasePaths.users.name);

  // add user data to firebase
  Future<void> addUsers({required UserModel model}) async {
    await _ref.doc(model.userId).set(model.toMap());
  }

  // update user data to firebase
  Future<void> updateUsers({required UserModel model}) async {
    await _ref.doc(model.userId).update(model.toMap());
  }

  // add records
  Future<void> addRecord(
      {required String path,
      required String userId,
      required Map<String, dynamic> map}) async {
    await _ref.doc(userId).collection(path).doc().set(map);
  }

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }
}
