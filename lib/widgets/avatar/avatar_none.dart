import 'package:cashify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AvatarNon extends StatelessWidget {
  final double height;
  final double width;
  final bool border;
  final IconData? icon;
  final Color? color;
  final Color? borderColor;
  const AvatarNon(
      {super.key,
      required this.height,
      required this.width,
      this.borderColor,
      required this.border,
      this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border == true
            ? Border.all(
                color: borderColor ?? mainColor.withOpacity(0.7),
              )
            : null,
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: FaIcon(
          color: color,
          icon ?? FontAwesomeIcons.user,
          size: width * 0.35,
        ),
      ),
    );
  }
}
