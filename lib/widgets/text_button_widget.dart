import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final bool isIos;
  final double? height;
  final double? width;
  final double textSize;
  final Color? color;
  final Color? textColor;
  final ButtonType type;
  final Function() onClick;
  final String text;
  final Color? borderColor;
  final Widget? loading;
  final ButtonStyle? buttonStyle;
  const ButtonWidget({
    super.key,
    required this.isIos,
    this.height,
    this.width,
    required this.textSize,
    this.color,
    required this.type,
    required this.onClick,
    required this.text,
    this.textColor,
    this.borderColor,
    this.loading,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return isIos
        ? type == ButtonType.text
            ? CupertinoButton(
                padding: const EdgeInsets.all(4),
                onPressed: onClick,
                child: loading ??
                    CustomText(
                      text: text,
                      color: textColor,
                      size: textSize,
                    ),
              )
            : type == ButtonType.outlined
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: borderColor ?? textColor ?? mainColor,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    width: width,
                    height: height,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: onClick,
                      child: loading ??
                          CustomText(
                            text: text,
                            color: textColor,
                            size: textSize,
                          ),
                    ),
                  )
                : SizedBox(
                    width: width,
                    height: height,
                    child: CupertinoButton(
                      color: color,
                      padding: const EdgeInsets.all(4),
                      onPressed: onClick,
                      child: loading ??
                          CustomText(
                            text: text,
                            color: textColor,
                            size: textSize,
                          ),
                    ),
                  )
        : type == ButtonType.text
            ? TextButton(
                style: buttonStyle,
                onPressed: onClick,
                child: loading ??
                    CustomText(
                      text: text,
                      color: textColor,
                      size: textSize,
                    ),
              )
            : type == ButtonType.raised
                ? SizedBox(
                    height: height,
                    width: width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          color,
                        ),
                      ),
                      onPressed: onClick,
                      child: loading ??
                          CustomText(
                            text: text,
                            color: textColor,
                            size: textSize,
                          ),
                    ),
                  )
                : SizedBox(
                    height: height,
                    width: width,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(
                          BorderSide(
                              color: borderColor ?? textColor ?? mainColor),
                        ),
                      ),
                      onPressed: onClick,
                      child: loading ??
                          CustomText(
                            text: text,
                            color: textColor,
                            size: textSize,
                          ),
                    ),
                  );
  }
}
