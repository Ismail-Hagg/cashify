import 'package:cashify/gloable_controllers/auth_controller.dart';
import 'package:cashify/models/user_model.dart';
import 'package:cashify/models/wallet_model.dart';
import 'package:cashify/services/firebase_service.dart';
import 'package:cashify/utils/constants.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GloableAuthController _authController =
      Get.find<GloableAuthController>();

  UserModel _userModel = Get.find<GloableAuthController>().userModel;
  UserModel get userModel => _userModel;

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

  final FirebaseService _firebaseService = FirebaseService();

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
    unclear();
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
  void googleLogin({required BuildContext context}) async {
    dismissKeyboard(context);
    loading();
    await GoogleSignIn().signIn().then(
      (value) async {
        if (value != null) {
          try {
            final GoogleSignInAuthentication gAuth = await value.authentication;

            final credential = GoogleAuthProvider.credential(
                accessToken: gAuth.accessToken, idToken: gAuth.idToken);
            await _auth.signInWithCredential(credential).then(
              (user) async {
                (bool, UserModel?) callUser =
                    await userExists(userId: user.user!.uid);
                if (callUser.$1) {
                  // old user
                  print('old user =======');
                  _authController
                      .userChange(model: callUser.$2 as UserModel)
                      .then(
                    (userSet) {
                      if (userSet) {
                        // data saved
                        loading();
                        _authController.reload();
                      } else {
                        // data not saved
                        throw Exception('wrong'.tr);
                      }
                    },
                  );
                } else {
                  // new user
                  print('new user =======');
                  UserModel gModel = UserModel(
                      catagories: [],
                      wallets: [
                        Wallet(name: 'cash', amount: 0.0, currency: 'SAR')
                      ],
                      username: user.user!.displayName ?? '',
                      email: user.user!.email ?? '',
                      userId: user.user!.uid,
                      localImage: false,
                      localPath: '',
                      onlinePath: user.user!.photoURL ?? '',
                      language: _authController.userModel.language,
                      defaultCurrency: 'SAR',
                      messagingToken: '',
                      errorMessage: '',
                      phoneNumber: user.user!.phoneNumber ?? '',
                      isError: false);
                  _authController.userChange(model: gModel).then(
                    (userSet) async {
                      if (userSet) {
                        loading();
                        _authController.reload();
                        await _firebaseService.addUsers(model: gModel);
                      } else {
                        throw Exception('wrong'.tr);
                      }
                    },
                  );
                }
              },
            );
          } on FirebaseAuthException catch (e) {
            loading();
            showToast(
                // ignore: use_build_context_synchronously
                context: context,
                type: ToastificationType.warning,
                isEng: _userModel.language == 'en_US',
                title: CustomText(text: 'error'.tr),
                description: CustomText(
                    text: getMessageFromErrorCode(errorMessage: e.code)),
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
        } else {
          loading();
        }
      },
    );
  }

  // email login
  void emailLogin({required BuildContext context}) async {
    String email = _txtControllers[FieldType.email]!.text.trim();
    String pass = _txtControllers[FieldType.password]!.text.trim();
    dismissKeyboard(context);

    if (email != '' && pass != '') {
      loading();
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: pass)
            .then(
          (user) {
            _firebaseService.getCurrentUser(userId: user.user!.uid).then(
              (value) {
                _authController
                    .userChange(
                  model:
                      UserModel.fromMap(value.data() as Map<String, dynamic>),
                )
                    .then(
                  (userSet) {
                    if (userSet) {
                      _authController.reload();
                      loading();
                      unclear();
                    } else {
                      loading();
                      // user is not saved
                      throw Exception('wrong'.tr);
                    }
                  },
                );
              },
            );
          },
        );
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
        await _auth.signOut();
        _authController.reload();
      }
    } else {
      // display error message to complete user info
      showToast(
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description: CustomText(text: 'complete'.tr),
          seconds: 3);
    }
  }

  // email signup
  void emailSignup({required BuildContext context}) async {
    String email = _txtControllers[FieldType.email]!.text.trim();
    String pass = _txtControllers[FieldType.password]!.text.trim();
    String username = _txtControllers[FieldType.username]!.text.trim();

    dismissKeyboard(context);
    // check all fields
    if (email != '' && pass != '' && username != '') {
      // start
      loading();

      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: pass)
            .then(
          (user) {
            _userModel = UserModel(
                catagories: [],
                wallets: [Wallet(name: 'cash', amount: 0.0, currency: 'SAR')],
                username: username,
                email: email,
                userId: user.user!.uid,
                localImage: _picPath != '',
                localPath: _picPath,
                onlinePath: user.user!.photoURL ?? '',
                language: _userModel.language,
                defaultCurrency: 'SAR',
                messagingToken: '',
                errorMessage: '',
                phoneNumber: user.user!.phoneNumber ?? '',
                isError: false);
            _authController.userChange(model: _userModel).then(
              (userSet) async {
                if (userSet) {
                  // user is saved
                  _authController.reload();
                  loading();
                  unclear();
                  await _firebaseService.addUsers(model: _userModel);
                } else {
                  // user is not saved
                  throw Exception('wrong'.tr);
                }
              },
            );
          },
        );
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
        await _auth.signOut();
        _authController.reload();
      }
    } else {
      // display error message to complete user info
      showToast(
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description: CustomText(text: 'complete'.tr),
          seconds: 3);
    }
  }

  // make phone controller work
  void phoneController({required String phone}) {
    _phoneNum = phone;
  }

  // phone login
  void phoneLogin({required BuildContext context}) async {
    String username = _txtControllers[FieldType.username]!.text.trim();
    String phone = _txtControllers[FieldType.phone]!.text.trim();

    dismissKeyboard(context);
    // check all fields
    if (username != '' && phone != '') {
      try {
        loading();
        await _auth.verifyPhoneNumber(
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
        // ignore: use_build_context_synchronously
        showToast(
            context: context,
            type: ToastificationType.warning,
            isEng: _userModel.language == 'en_US',
            title: CustomText(text: 'error'.tr),
            description:
                CustomText(text: getMessageFromErrorCode(errorMessage: e.code)),
            seconds: 3);
      }
    } else {
      // display error message to complete user info
      showToast(
          context: context,
          type: ToastificationType.warning,
          isEng: _userModel.language == 'en_US',
          title: CustomText(text: 'error'.tr),
          description: CustomText(text: 'complete'.tr),
          seconds: 3);
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
        await _auth.signInWithCredential(creds).then(
          (user) async {
            (bool, UserModel?) callUser =
                await userExists(userId: user.user!.uid, upload: true);
            if (callUser.$1) {
              // old user
              _authController.userChange(model: callUser.$2 as UserModel).then(
                (userSet) {
                  if (userSet) {
                    // data saved
                    loading();
                    _authController.reload();
                  } else {
                    // data not saved
                    throw Exception('wrong'.tr);
                  }
                },
              );
            } else {
              // new user

              UserModel phoneModel = UserModel(
                  catagories: [],
                  wallets: [Wallet(name: 'cash', amount: 0.0, currency: 'SAR')],
                  username: username,
                  email: user.user!.email ?? '',
                  userId: user.user!.uid,
                  localImage: _picPath != '',
                  localPath: _picPath,
                  onlinePath: user.user!.photoURL ?? '',
                  language: _userModel.language,
                  defaultCurrency: 'SAR',
                  messagingToken: '',
                  errorMessage: '',
                  phoneNumber: user.user!.phoneNumber ?? phone,
                  isError: false);

              _authController.userChange(model: phoneModel).then(
                (userSet) async {
                  if (userSet) {
                    loading();
                    _authController.reload();
                    await _firebaseService.addUsers(model: phoneModel);
                  } else {
                    throw Exception('wrong'.tr);
                  }
                },
              );
            }
          },
        );
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
        await _auth.signOut();
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

  // check if the user exists
  Future<(bool, UserModel?)> userExists(
      {required String userId, bool? upload}) async {
    var user = await _firebaseService.getCurrentUser(userId: userId);
    return (
      user.exists,
      user.exists
          ? UserModel.fromMap(
              user.data() as Map<String, dynamic>,
            )
          : null
    );
  }
}
