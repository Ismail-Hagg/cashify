// utility functions

// get device language
import 'package:get/get.dart';

String languageDev() {
  return Get.deviceLocale.toString().substring(0, 2) == 'en'
      ? 'en_US'
      : 'ar_SA';
}
