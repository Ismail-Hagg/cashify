import 'package:cashify/utils/constants.dart';
import 'package:flutter/material.dart';

class AvatarOnlineInside extends StatelessWidget {
  final double height;
  final double width;
  final bool border;
  final bool shadow;
  final ImageProvider provider;

  const AvatarOnlineInside({
    super.key,
    required this.height,
    required this.width,
    required this.border,
    required this.shadow,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
        image: DecorationImage(
          image: provider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
