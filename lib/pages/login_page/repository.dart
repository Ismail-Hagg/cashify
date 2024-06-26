import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
  final FirebaseService _firebaseService = FirebaseService();

  // email login
  Future<UserCredential> emailLogin(
      {required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // email signup
  Future<UserCredential> emailSignup({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // sign up with credential
  Future<UserCredential> signupCred({required AuthCredential cred}) async {
    return await _auth.signInWithCredential(cred);
  }

  // check if user exists
  Future<bool> userExists({required String userId}) async {
    var user = await _firebaseService.getCurrentUser(userId: userId);
    return user.exists;
  }

  // get the current user
  Future<UserDataModel> getCurrentUser({required String userId}) async {
    var user = await _firebaseService.getCurrentUser(userId: userId);
    return convertToModel(data: user.data() as Map<String, dynamic>);
  }

  // convert user data from map to model
  UserDataModel convertToModel({required Map<String, dynamic> data}) {
    return UserDataModel.fromMap(data);
  }

  // upload user data to backend
  Future<void> uploadUser({required UserDataModel model}) async {
    await _firebaseService.addUsers(model: model);
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
