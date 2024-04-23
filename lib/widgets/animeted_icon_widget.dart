import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class IconAnimated extends StatelessWidget {
  final String name;
  final AnimationController controller;
  final Color color;
  const IconAnimated(
      {super.key,
      required this.name,
      required this.controller,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcATop,
      ),
      child: Lottie.asset(
        name,
        controller: controller,
      ),
    );
  }
}
