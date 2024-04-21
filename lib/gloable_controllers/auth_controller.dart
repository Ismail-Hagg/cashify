import 'package:cashify/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class GloableAuthController extends GetxController {
  UserModel _userModel;
  GloableAuthController(this._userModel);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  UserModel get userModel => _userModel;

  final bool _isIos = defaultTargetPlatform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  @override
  void onInit() async {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
    print(_isIos);
  }
}
