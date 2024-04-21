import 'dart:io';

import 'package:cashify/utils/constants.dart';
import 'package:flutter/material.dart';

class AvatarLocal extends StatelessWidget {
  final double height;
  final double width;
  final bool border;
  final String link;
  final bool shadow;

  const AvatarLocal({
    super.key,
    required this.height,
    required this.width,
    required this.border,
    required this.link,
    required this.shadow,
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
          image: Image.file(File(link)).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
