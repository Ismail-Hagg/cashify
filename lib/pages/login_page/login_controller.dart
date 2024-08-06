import 'package:cashify/data_models/user_data_model.dart';
import 'package:cashify/data_models/wallet_data_model.dart';
import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/pages/login_page/repository.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toastification/toastification.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  final LoginRepository _repo = LoginRepository();

  final GloableAuthController _authController =
      Get.find<GloableAuthController>();

  final UserDataModel _userModel = Get.find<GloableAuthController>().userModel;
  UserDataModel get userModel => _userModel;

  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  bool _flip = false;
  bool get flip => _flip;

  bool _codeSent = false;
  bool get codeSent => _codeSent;

  bool _passCover = true;
  bool get passCover => _passCover;

  bool _loginLoading = false;
  bool get loginLoading => _loginLoading;

  String _picPath = "";
  String get picPath => _picPath;

  String _verificationId = "";
  String get verificationId => _verificationId;

  String _phoneNum = "";
  String get phoneNum => _phoneNum;

  Map<FieldType, FocusNode> get nodes => _nodes;
  Map<FieldType, bool> get active => _active;
  Map<FieldType, TextEditingController> get txtControllers => _txtControllers;

  final Map<FieldType, FocusNode> _nodes = {
    FieldType.email: FocusNode(),
    FieldType.password: FocusNode(),
    FieldType.username: FocusNode(),
    FieldType.phone: FocusNode(),
  };

  final Map<FieldType, bool> _active = {
    FieldType.email: false,
    FieldType.password: false,
    FieldType.username: false,
    FieldType.phone: false,
  };

  final Map<FieldType, TextEditingController> _txtControllers = {
    FieldType.email: TextEditingController(),
    FieldType.password: TextEditingController(),
    FieldType.username: TextEditingController(),
    FieldType.phone: TextEditingController(),
    FieldType.otp: TextEditingController(),
  };

  late AnimationController _loadingController;
  AnimationController get loadingController => _loadingController;

  @override
  void onClose() {
    super.onClose();
    _pageController.dispose();
    _loadingController.dispose();
    nodesDispose();
  }

  @override
  void onInit() {
    super.onInit();
    setListeners();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  void loading() {
    _loginLoading = !_loginLoading;
    if (_loginLoading) {
      _loadingController.repeat();
    } else {
      _loadingController.stop();
    }
    update();
  }

  // back button only kill app when on main login view
  void backButton() {
    if (_pageController.page == 0) {
      SystemNavigator.pop();
    } else {
      loginViews(page: 0);
    }
  }

  // dispose of the focus nodes
  void nodesDispose() {
    _nodes.forEach(
      (key, value) {
        value.dispose();
        _txtControllers[key]!.dispose();
      },
    );
  }

// setup node listeners
  void setListeners() {
    _nodes.forEach(
      (key, value) {
        value.addListener(
          () {
            if (value.hasFocus) {
              _active[key] = true;
              update();
            } else {
              _active[key] = false;
              update();
            }
          },
        );
      },
    );
  }

  // unfocus and clear
  void unclear() {
    _nodes.forEach(
      (key, value) {
        value.unfocus();
        _txtControllers[key]!.clear();
      },
    );
  }

  // change the page view
  void loginViews({required int page, bool? noFlip}) {
    _picPath = '';
    _loginLoading = false;
    _codeSent = false;
    _verificationId = '';
    _pageController.jumpToPage(
      page,
    );
    noFlip == null ? _flip = page != 0 : null;
    update();
  }

  // toggle password obscure
  void obscurePass() {
    _passCover = !_passCover;
    update();
  }

  // dismiss keyboard
  void dismissKeyboard(context) {
    FocusScope.of(context).unfocus();
  }

  // google login
  Future<void> googleLogin({required BuildContext context}) async {
    dismissKeyboard(context);
    loading();

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      loading();
      return;
    }

    try {
      GoogleSignInAuthentication gAuth = await googleUser.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      UserCredential currentUser = await _repo.signupCred(cred: credential);
      bool oldUser = await _repo.userExists(userId: currentUser.user!.uid);
      UserDataModel user = oldUser
          ? await _repo.getCurrentUser(userId: currentUser.user!.uid)
          : UserDataModel(
              username: currentUser.user!.displayName ?? '',
              email: currentUser.user!.email ?? '',
              userId: currentUser.user!.uid,
              localImage: false,
              localPath: '',
              onlinePath: currentUser.user!.photoURL ?? '',
              language: _authController.userModel.language,
              defaultCurrency: 'SAR',
              messagingToken: '',
              errorMessage: '',
              phoneNumber: currentUser.user!.phoneNumber ?? '',
              wallets: [],
              isError: false,
              catagories: [],
              isSynced: true,
            );

      await _authController.userChange(model: user).then((_) async {
        loading();
        _authController.reload();
        if (oldUser == false) {
          await _repo.uploadUser(model: user);
        }
      });
    } on FirebaseAuthException catch (e) {
      loading();
      showToast(
          // ignore: use_build_context_synchronously
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description:
              CustomText(text: getMessageFromErrorCode(errorMessage: e.code)),
          seconds: 3);
    } catch (e) {
      loading();
      showToast(
          // ignore: use_build_context_synchronously
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description: CustomText(text: e.toString()),
          seconds: 3);
      await GoogleSignIn().signOut();
      _authController.reload();
    }
  }

  // email login
  void emailLogin({required BuildContext context}) async {
    final email = _txtControllers[FieldType.email]!.text.trim();
    final pass = _txtControllers[FieldType.password]!.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      showToast(
        context: context,
        type: ToastificationType.warning,
        isEng: _userModel.language == 'en_US',
        title: CustomText(text: 'error'.tr),
        description: CustomText(text: 'complete'.tr),
        seconds: 3,
      );
      return;
    }
    loading();
    try {
      UserCredential user =
          await _repo.emailLogin(email: email, password: pass);
      UserDataModel currentUser =
          await _repo.getCurrentUser(userId: user.user!.uid);
      await _authController.userChange(model: currentUser).then((value) {
        _authController.reload();
        loading();
        unclear();
      });
    } on FirebaseAuthException catch (e) {
      loading();
      showToast(
        // ignore: use_build_context_synchronously
        context: context,
        type: ToastificationType.warning,
        isEng: _userModel.language == 'en_US',
        title: CustomText(text: 'error'.tr),
        description:
            CustomText(text: getMessageFromErrorCode(errorMessage: e.code)),
        seconds: 3,
      );
    } catch (e) {
      loading();
      showToast(
        // ignore: use_build_context_synchronously
        context: context,
        type: ToastificationType.warning,
        isEng: _userModel.language == 'en_US',
        title: CustomText(text: 'error'.tr),
        description: CustomText(text: e.toString()),
        seconds: 3,
      );
      await _repo.signOut();
    }
  }

  // email signup
  Future<void> emailSignup({required BuildContext context}) async {
    String email = _txtControllers[FieldType.email]!.text.trim();
    String pass = _txtControllers[FieldType.password]!.text.trim();
    String username = _txtControllers[FieldType.username]!.text.trim();

    dismissKeyboard(context);

    if (email == '' || pass == '' || username == '') {
      showToast(
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description: CustomText(text: 'complete'.tr),
          seconds: 3);

      return;
    }

    loading();

    try {
      UserCredential currentUser =
          await _repo.emailSignup(email: email, password: pass);
      UserDataModel user = UserDataModel(
        username: username,
        email: currentUser.user!.email ?? '',
        userId: currentUser.user!.uid,
        localImage: _picPath != '',
        localPath: _picPath,
        onlinePath: '',
        language: _authController.userModel.language,
        defaultCurrency: 'SAR',
        messagingToken: '',
        errorMessage: '',
        phoneNumber: currentUser.user!.phoneNumber ?? '',
        wallets: [WalletModel(name: 'thing', amount: 0, currency: 'USD')],
        isError: false,
        catagories: [],
        isSynced: true,
      );
      await _authController.userChange(model: user).then((_) async {
        _authController.reload();
        loading();
        unclear();
        await _repo.uploadUser(model: user);
      });
    } on FirebaseAuthException catch (e) {
      loading();
      showToast(
          // ignore: use_build_context_synchronously
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description:
              CustomText(text: getMessageFromErrorCode(errorMessage: e.code)),
          seconds: 3);
    } catch (e) {
      loading();
      showToast(
          // ignore: use_build_context_synchronously
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description: CustomText(text: e.toString()),
          seconds: 3);
      await _repo.signOut();
      _authController.reload();
    }
  }

  // make phone controller work
  void phoneController({required String phone}) {
    _phoneNum = phone;
  }

  // phone login
  Future<void> phoneLogin({required BuildContext context}) async {
    String username = _txtControllers[FieldType.username]!.text.trim();
    String phone = _txtControllers[FieldType.phone]!.text.trim();

    dismissKeyboard(context);
    // check all fields
    if (username == '' || phone == '') {
      // display error message to complete user info
      showToast(
        context: context,
        type: ToastificationType.warning,
        isEng: _userModel.language == 'en_US',
        title: CustomText(text: 'error'.tr),
        description: CustomText(text: 'complete'.tr),
        seconds: 3,
      );
      return;
    }

    try {
      loading();
      await _repo.auth.verifyPhoneNumber(
        phoneNumber: _phoneNum,
        verificationCompleted: (credential) async {},
        verificationFailed: (e) async {
          _verificationId = '';
          loading();
          showToast(
              context: context,
              type: ToastificationType.warning,
              isEng: _userModel.language == 'en_US',
              title: CustomText(text: 'error'.tr),
              description: CustomText(
                  text: getMessageFromErrorCode(errorMessage: e.code)),
              seconds: 3);
        },
        codeSent: (verificationId, resendToken) async {
          _verificationId = verificationId;
          _codeSent = true;
          loading();
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showToast(
        // ignore: use_build_context_synchronously
        context: context,
        type: ToastificationType.warning,
        isEng: _userModel.language == 'en_US',
        title: CustomText(text: 'error'.tr),
        description:
            CustomText(text: getMessageFromErrorCode(errorMessage: e.code)),
      );
    }
  }

  // veerify the otp
  void otpVerify({required String otp, required BuildContext context}) async {
    if (otp.length == 6) {
      String username = _txtControllers[FieldType.username]!.text.trim();
      String phone = _txtControllers[FieldType.phone]!.text.trim();
      dismissKeyboard(context);
      loading();
      try {
        PhoneAuthCredential creds = PhoneAuthProvider.credential(
            verificationId: _verificationId, smsCode: otp);

        UserCredential currentUser = await _repo.signupCred(cred: creds);
        bool oldUser = await _repo.userExists(userId: currentUser.user!.uid);

        UserDataModel user = oldUser
            ? await _repo.getCurrentUser(userId: currentUser.user!.uid)
            : UserDataModel(
                username: username,
                email: currentUser.user!.email ?? '',
                userId: currentUser.user!.uid,
                localImage: _picPath != '',
                localPath: _picPath,
                onlinePath: currentUser.user!.photoURL ?? '',
                language: _authController.userModel.language,
                defaultCurrency: 'SAR',
                messagingToken: '',
                errorMessage: '',
                phoneNumber: currentUser.user!.phoneNumber ?? phone,
                wallets: [],
                isError: false,
                catagories: [],
                isSynced: true,
              );

        await _authController.userChange(model: user).then((_) async {
          _authController.reload();
          loading();
          unclear();
          if (oldUser == false) {
            await _repo.uploadUser(model: user);
          }
        });
      } on FirebaseAuthException catch (e) {
        loading();
        showToast(
            // ignore: use_build_context_synchronously
            context: context,
            type: ToastificationType.warning,
            isEng: _userModel.language == 'en_US',
            title: CustomText(text: 'error'.tr),
            description:
                CustomText(text: getMessageFromErrorCode(errorMessage: e.code)),
            seconds: 3);
      } catch (e) {
        loading();
        showToast(
            // ignore: use_build_context_synchronously
            context: context,
            type: ToastificationType.warning,
            isEng: _userModel.language == 'en_US',
            title: CustomText(text: 'error'.tr),
            description: CustomText(text: e.toString()),
            seconds: 3);
        await _repo.signOut();
        _authController.reload();
      }
    }
  }

  // forgot password
  void forgotPassword() {}

  // select pic from device
  void selectPic() async {
    if (_picPath == '') {
      await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      ).then(
        (value) async {
          if (value != null) {
            _picPath = value.files.single.path.toString();

            update();
          }
        },
      );
    } else {
      _picPath = '';
      update();
    }
  }
}
