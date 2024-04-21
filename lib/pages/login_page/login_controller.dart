import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  bool _flip = false;
  bool get flip => _flip;

  bool _fuck = false;
  bool get fuck => _fuck;

  final FocusNode _focus = FocusNode();
  FocusNode get focus => _focus;

  bool _codeSent = true;
  bool get codeSent => _codeSent;
  @override
  void onClose() {
    super.onClose();
    _pageController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    _focus.addListener(focusing);
  }

  void focusing() {
    _fuck = _focus.hasFocus;
    update();
  }

  void loginViews({required int page}) {
    _pageController.jumpToPage(
      page,
    );
    _flip = page != 0;
    update();
  }
}
