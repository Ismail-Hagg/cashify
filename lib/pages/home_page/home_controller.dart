import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/gloable_controllers/controller_view.dart';
import 'package:cashify/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeController extends GetxController {
  final UserModel _userModel = Get.find<GloableAuthController>().userModel;
  UserModel get userModel => _userModel;

  @override
  void onInit() {
    super.onInit();
    print('too sweet for me');
    Get.reload<GloableAuthController>();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAll(() => const GloableViewController());
  }
}
