import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/pages/settings_page/repository.dart';
import 'package:cashify/utils/constants.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsController extends GetxController {
  final SettingRepository _repo = SettingRepository();
  final UserDataModel _userModel = Get.find<HomeController>().userModel;
  UserDataModel get userModel => _userModel;

  final bool _isIos = Get.find<HomeController>().isIos;
  bool get isIos => _isIos;

  final GloableAuthController _authControlleer = Get.find();

  late Box<UserDataModel> box;

  UserDataModel? newMod;

  List _lst = [];
  List get lst => _lst;

  @override
  void onInit() async {
    super.onInit();
    box = Hive.isBoxOpen(userBox)
        ? Hive.box<UserDataModel>(userBox)
        : await Hive.openBox(userBox);

    newMod = box.get(userData);
    update();
  }

  void func() async {
    // box.put(
    //     'user',
    //     UserDataModel(
    //         username: 'dork',
    //         email: 'email',
    //         userId: 'userId',
    //         localImage: false,
    //         localPath: 'localPath',
    //         onlinePath: 'onlinePath',
    //         language: 'language',
    //         defaultCurrency: 'defaultCurrency',
    //         messagingToken: 'messagingToken',
    //         errorMessage: 'errorMessage',
    //         phoneNumber: 'phoneNumber',
    //         wallets: [],
    //         isError: false,
    //         catagories: [],
    //         isSynced: true));

    // newMod = box.get('user')!;

    // update();
  }

  // logout
  void logout() async {
    String userId = _userModel.userId;
    await _repo.signOut();
    Get.delete<HomeController>();
    Get.delete<AllTransactionsController>();
    Get.delete<MonthSettingController>();
    _authControlleer.reload();
    await _repo.wipeAllData();
    await syncOut(userId: userId);
    Get.delete<SettingsController>();
  }

  // set user isSync field to false when user logs out fo that when he login again data is downloaded and saved
  Future<void> syncOut({required String userId}) async {
    await _repo.changeUserData(userId: userId);
  }
}
