import 'package:cashify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController controller;
  final TextInputAction? action;
  final Function()? obscureFunc;
  final TextInputType? type;
  final String? hint;
  final Widget? suff;
  final List<TextInputFormatter>? formatter;
  final int? maxLines;
  final bool? autoFocus;
  final Function(String str)? onSub;

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
    required this.controller,
    this.action,
    this.obscureFunc,
    this.type,
    this.hint,
    this.suff,
    this.formatter,
    this.maxLines,
    this.autoFocus,
    this.onSub,
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
              onSubmitted: onSub,
              //autofocus: autoFocus ?? false,
              maxLines: obscurepass != null ? 1 : maxLines,
              inputFormatters: formatter,
              keyboardType: type,
              textInputAction: action,
              controller: controller,
              focusNode: node,
              obscureText: obscurepass != null ? obscurepass as bool : false,
              style: TextStyle(color: textColor),
              showCursor: false,
              decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  suffixIcon: password != null
                      ? GestureDetector(
                          onTap: obscureFunc,
                          child: FaIcon(
                            obscurepass == true
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            size: width * 0.06,
                          ),
                        )
                      : suff,
                  border: InputBorder.none,
                  enabled: enable ?? true),
            ),
      ),
    );
  }
}
