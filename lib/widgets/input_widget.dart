import 'package:cashify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final bool active;
  final Color? textColor;
  final bool? password;
  final bool? obscurepass;
  final bool? enable;
  final Widget? otherInput;
  final FocusNode? node;

  const InputWidget({
    super.key,
    required this.height,
    required this.width,
    this.color,
    required this.active,
    this.textColor,
    this.password,
    this.obscurepass,
    this.enable,
    this.otherInput,
    this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: active ? mainColor : Colors.transparent),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: password == true ? 8.0 : 0),
        child: otherInput ??
            TextField(
              focusNode: node,
              obscureText: obscurepass != null ? obscurepass as bool : false,
              style: TextStyle(color: textColor),
              showCursor: false,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  suffixIcon: password != null
                      ? FaIcon(
                          obscurepass == true
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          size: width * 0.06,
                        )
                      : null,
                  border: InputBorder.none,
                  enabled: enable ?? true),
            ),
      ),
    );
  }
}
