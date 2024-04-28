import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CatagoryIndicator extends StatelessWidget {
  final double width;
  final Color color;
  final String catagory;
  final bool loading;
  final double? adjustedWidth;
  final bool scrolable;

  const CatagoryIndicator({
    super.key,
    required this.width,
    required this.color,
    required this.catagory,
    required this.loading,
    this.adjustedWidth,
    required this.scrolable,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: loading
          ? Row(
              children: [
                Container(
                  height: width * 0.06,
                  width: (width * 0.3) - 8,
                  color: Colors.grey.shade300,
                ),
              ],
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: const Duration(milliseconds: 1400), color: shadowColor)
          : Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                    height: scrolable ? width * 0.04 : width * 0.03,
                    width: scrolable ? width * 0.04 : width * 0.03,
                  ),
                ),
                // CustomText(text: catagory)
                ButtonWidget(
                    buttonStyle: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                    isIos: false,
                    textSize: 14,
                    type: ButtonType.text,
                    onClick: () {},
                    text: catagory)
              ],
            ),
    );
  }
}
