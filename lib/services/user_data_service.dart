import 'dart:convert';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  // save user data
  Future<bool> saveUser({required UserModel model}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(userDataKey, json.encode(model.toMap()));
  }

  // reload
  void reload() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }

  // retrieve user data
  Future<UserModel> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var value = pref.getString(userDataKey);
      return UserModel.fromMap(json.decode(value.toString()));
    } catch (e) {
      return UserModel(
        catagories: [],
        wallets: [],
        phoneNumber: '',
        username: '',
        email: '',
        userId: '',
        localImage: false,
        localPath: '',
        onlinePath: '',
        language: languageDev(),
        defaultCurrency: '',
        messagingToken: '',
        errorMessage: e.toString(),
        isError: true,
      );
    }
  }

  // delete user data
  Future<void> deleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
