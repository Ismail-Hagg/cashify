import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool loading;
  final Widget? child;
  const LoadingWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.loading,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: child != null ? null : width,
      height: child != null ? null : height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    )
        .animate(
          onPlay: (controll) =>
              loading ? controll.repeat() : controll.stop(), // loop
        )
        .shimmer(
            duration: const Duration(seconds: 1), color: Colors.grey.shade100);
  }
}
