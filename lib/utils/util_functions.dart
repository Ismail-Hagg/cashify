// utility functions

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

// get device language
String languageDev() {
  return Get.deviceLocale.toString().substring(0, 2) == 'en'
      ? 'en_US'
      : 'ar_SA';
}

// show toast
void showToast(
    {required BuildContext context,
    Widget? title,
    ToastificationStyle? style,
    required ToastificationType type,
    required bool isEng,
    AlignmentGeometry? alignment,
    Widget? description,
    int? seconds}) {
  toastification.show(
    context: context,
    type: type,
    showProgressBar: false,
    style: style ?? ToastificationStyle.flatColored,
    direction: isEng ? TextDirection.ltr : TextDirection.rtl,
    alignment: alignment ?? Alignment.bottomCenter,
    description: description,
    title: title,
    autoCloseDuration: Duration(seconds: seconds ?? 5),
  );
}

// firebase error messages
String getMessageFromErrorCode({required String errorMessage}) {
  switch (errorMessage) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "firealready".tr;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "firewrong".tr;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "fireuser".tr;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "firedis".tr;
    case "ERROR_TOO_MANY_REQUESTS":
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "fireserver".tr;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "fireemail".tr;
    case 'invalid-verification-code':
      return 'fireverification'.tr;
    case 'INVALID_LOGIN_CREDENTIALS':
    case 'invalid-credential':
      return 'invalidcred'.tr;
    case 'invalid-phone-number':
      return 'invalidpgone'.tr;

    default:
      return "firelogin".tr;
  }
}

// show dialog
void dialogShowing({required Widget widget}) {
  Get.dialog(widget);
}
