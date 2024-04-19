import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {'welcome': 'Welcome to Cashify'},
        'ar_SA': {'welcome': 'اهلا بكم في كاشيفاي'}
      };
}
