import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/services/user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsController extends GetxController {
  UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;
  final UserData _userService = UserData();

  final GloableAuthController _authControlleer = Get.find();

  @override
  void onInit() async {
    super.onInit();
    print(_authControlleer.userModel.email);
    _userModel = Get.find<HomeController>().userModel;
    print(_userModel.email);

    //_userModel = await _userService.getUserData();
  }

  // logout
  void logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await _authControlleer.userData.deleteUser();
    Get.delete<HomeController>();
    Get.delete<AllTransactionsController>();
    Get.delete<MonthSettingController>();
    _authControlleer.reload();
    Get.delete<SettingsController>();
  }
}
