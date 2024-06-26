import 'dart:ui';

import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/local_storage/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class GloableAuthController extends GetxController {
  final UserDataModel _userModel;
  GloableAuthController(this._userModel);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  final LocalStorage localStorage = LocalStorage();

  UserDataModel get userModel => _userModel;

  final bool _isIos = defaultTargetPlatform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  final LocalStorage _localStorage = LocalStorage();

  @override
  void onInit() async {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  void reload() {
    loginLangCahange();
    update();
  }

  // update and save the user locally
  Future<void> userChange({required UserDataModel model}) async {
    await _localStorage.saveUser(model: model);
  }

  // change app language on login if needed
  void loginLangCahange() async {
    String localOne = _userModel.language.substring(0, 2);
    String localTwo = _userModel.language.substring(3, 5);

    await Get.updateLocale(Locale(localOne, localTwo));
  }
}
