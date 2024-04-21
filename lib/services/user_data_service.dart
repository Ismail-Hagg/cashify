import 'dart:convert';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  // save user data
  Future<void> saveUser(UserModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(userDataKey, json.encode(model.toMap()));
  }

  // retrieve user data
  Future<UserModel> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var value = pref.getString(userDataKey);
      return UserModel.fromMap(json.decode(value.toString()));
    } catch (e) {
      return UserModel(
          username: 'username',
          email: '',
          userId: '',
          localImage: false,
          localPath: '',
          onlinePath: '',
          language: languageDev(),
          defaultCurrency: '',
          messagingToken: '',
          errorMessage: e.toString(),
          isError: true);
    }
  }

  // delete user data
  Future<void> deleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
