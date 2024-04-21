import 'package:cashify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AvatarLoading extends StatelessWidget {
  final double height;
  final double width;
  final bool border;
  final bool shadow;
  const AvatarLoading({
    super.key,
    required this.height,
    required this.width,
    required this.border,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(1, 1),
                  blurRadius: 5,
                  spreadRadius: 2,
                )
              ]
            : null,
        shape: BoxShape.circle,
        border: border == true
            ? Border.all(
                color: mainColor.withOpacity(0.7),
              )
            : null,
        color: Colors.grey.shade200,
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
        duration: const Duration(milliseconds: 1500),
        color: Colors.grey.shade300);
  }
}
