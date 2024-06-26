import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final int? maxline;
  final double? spacing;
  final TextOverflow? flow;
  final TextAlign? align;
  final bool? isFit;
  final AlignmentGeometry? aligning;
  const CustomText(
      {super.key,
      required this.text,
      this.size,
      this.weight,
      this.color,
      this.maxline,
      this.spacing,
      this.flow,
      this.align,
      this.isFit,
      this.aligning});

  @override
  Widget build(BuildContext context) {
    return isFit == true
        ? FittedBox(
            alignment: aligning ?? Alignment.center,
            child: Text(
              text,
              maxLines: maxline,
              textAlign: align,
              style: TextStyle(
                color: color,
                fontSize: size,
                fontWeight: weight,
                overflow: flow,
                letterSpacing: spacing,
              ),
            ),
          )
        : Text(
            text,
            maxLines: maxline,
            textAlign: align,
            style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: weight,
              overflow: flow,
              letterSpacing: spacing,
            ),
          );
  }
}
