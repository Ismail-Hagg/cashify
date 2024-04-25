import 'dart:ui';

import 'package:cashify/models/user_model.dart';
import 'package:cashify/services/user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class GloableAuthController extends GetxController {
  UserModel _userModel;
  GloableAuthController(this._userModel);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserData userData = UserData();

  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  UserModel get userModel => _userModel;

  final bool _isIos = defaultTargetPlatform == TargetPlatform.iOS;
  bool get isIos => _isIos;

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
  Future<bool> userChange({required UserModel model}) async {
    _userModel = model;
    return await userData.saveUser(model: model);
  }

  // change app language on login if needed
  void loginLangCahange() async {
    String localOne = _userModel.language.substring(0, 2);
    String localTwo = _userModel.language.substring(3, 5);

    await Get.updateLocale(Locale(localOne, localTwo));
  }
}
