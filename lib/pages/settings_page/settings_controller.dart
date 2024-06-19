import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/hive_class.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/pages/all_transactions_page/all_transactoins_controller.dart';
import 'package:cashify/pages/home_page/home_controller.dart';
import 'package:cashify/pages/month_setting_page/month_setting_controller.dart';
import 'package:cashify/services/user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsController extends GetxController {
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  final bool _isIos = Get.find<HomeController>().isIos;
  bool get isIos => _isIos;
  final UserData _userService = UserData();

  final GloableAuthController _authControlleer = Get.find();

  late Box<List> box;

  List _lst = [];
  List get lst => _lst;

  @override
  void onInit() async {
    await Hive.initFlutter();
    Hive.isAdapterRegistered(1)
        ? null
        : Hive.registerAdapter(MyCustomObjectAdapter());
    //await Hive.close();
    box = await Hive.openBox<List>('lst');
    //box.put('name', []);
    try {
      _lst = box.get('name') ?? [];
      update();
    } catch (e) {
      print('==-=-= $e');
    }

    super.onInit();
  }

  void func() {
    print('===thing');
    print(box.get('name').runtimeType);
    for (var i = 0; i < 5; i++) {
      _lst.add(MyCustomObject('indexing', i));
      try {
        box.put(
          'name',
          _lst,
        );
      } catch (e) {
        print('==$e');
      }
    }

    update();
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
