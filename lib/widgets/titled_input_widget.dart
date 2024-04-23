import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:cashify/widgets/input_widget.dart';
import 'package:flutter/material.dart';

class TitledInput extends StatelessWidget {
  final String title;
  final double titleSize;
  final Color titleColor;
  final double width;
  final Color textColor;
  final bool active;
  final bool? password;
  final bool? obscurePass;
  final bool? enabled;
  final Widget? otherInput;
  final bool? otherHere;
  final FocusNode? node;
  final TextEditingController controller;
  final TextInputAction? action;
  final Function()? obsFunc;
  final Widget? otherSuffix;
  final TextInputType? type;

  const TitledInput({
    super.key,
    required this.title,
    required this.titleSize,
    required this.titleColor,
    required this.width,
    required this.textColor,
    required this.active,
    this.password,
    this.obscurePass,
    this.enabled,
    this.otherInput,
    this.otherHere,
    this.node,
    required this.controller,
    this.action,
    this.obsFunc,
    this.otherSuffix,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          size: titleSize,
          color: titleColor,
        ),
        SizedBox(
          height: width * 0.015,
        ),
        otherHere == true
            ? otherInput ?? Container()
            : InputWidget(
                type: type,
                obscureFunc: obsFunc,
                action: action,
                controller: controller,
                node: node,
                otherInput: otherInput,
                enable: enabled,
                obscurepass: obscurePass,
                password: password,
                height: width * 0.13,
                width: width,
                active: active,
                textColor: textColor,
              )
      ],
    );
  }
}
