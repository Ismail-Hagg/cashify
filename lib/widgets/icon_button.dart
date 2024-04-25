import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconButtonPlatform extends StatelessWidget {
  final bool isIos;
  final IconData icon;
  final Color color;
  final Function() click;
  final double? size;
  const IconButtonPlatform(
      {super.key,
      required this.isIos,
      required this.icon,
      required this.color,
      required this.click,
      this.size});

  @override
  Widget build(BuildContext context) {
    return isIos
        ? CupertinoButton(
            onPressed: click,
            child: FaIcon(
              size: size,
              icon,
              color: color,
            ),
          )
        : IconButton(
            splashRadius: 10,
            onPressed: click,
            icon: FaIcon(
              size: size,
              icon,
              color: color,
            ),
          );
  }
}
