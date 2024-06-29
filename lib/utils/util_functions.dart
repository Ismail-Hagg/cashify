// utility functions

import 'package:cashify/widgets/modal_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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

// converto data to icon data
IconData iconConvert({required String code}) {
  return IconData(
    int.parse(
      code.substring(
        0,
        code.indexOf('-'),
      ),
    ),
    fontFamily: code.substring(
      (code.indexOf('-') + 1),
    ),
  );
}

// convert data to colot
Color colorConvert({required int code}) {
  return Color(
    code,
  );
}

// remove zeros from double
String zerosConvert({required double val}) {
  bool whole = val % 1 == 0;
  int whileNum = whole ? val.toInt() : 0;
  String newVal = whole ? whileNum.toString() : val.toStringAsFixed(2);
  return newVal;
}

// decide if time is in period
bool isTimeInPeriod(
    {required DateTime start, required DateTime end, required DateTime time}) {
  return time.isAfter(start) &&
      time.isBefore(
          end.add(const Duration(hours: 23, minutes: 59, seconds: 59)));
}

// show modal
void showModal(
    {Function()? dissBarr,
    required Function() xFunction,
    Function()? dissDrag,
    required BuildContext context,
    required String title,
    required Widget child,
    required Widget button}) {
  WoltModalSheet.show(
    onModalDismissedWithBarrierTap: dissBarr,
    onModalDismissedWithDrag: dissDrag,
    context: context,
    modalTypeBuilder: (context) => WoltModalType.bottomSheet,
    pageListBuilder: (modalSheetContext) {
      return [
        modalPage(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          leadingButtonFunction: xFunction,
          context: modalSheetContext,
          title: title,
          child: child,
          button: Padding(padding: const EdgeInsets.all(16.0), child: button),
        )
      ];
    },
  );
}
