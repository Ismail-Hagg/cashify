import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/local_storage/local_storage.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalStorage _localStorage = LocalStorage();
  final FirebaseService _firebaseService = FirebaseService();

  // signout
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // wipe local data
  Future<void> wipeLocalData() async {
    await _localStorage.deleteUser();
  }

  // change user data in backend
  Future<void> changeUserData({required String userId}) async {
    await _firebaseService.cloudSync(userId: userId, val: false);
  }

  // delete transactions
  Future<void> deleteTransactions() async {
    await _localStorage.deleteTransaction();
  }

  // delete transactions
  Future<void> deleteMonthSetting() async {
    await _localStorage.deleteMonthSetting();
  }

  // wipe all data
  Future<void> wipeAllData() async {
    await Future.wait(
        [wipeLocalData(), deleteTransactions(), deleteMonthSetting()]);
  }
}
