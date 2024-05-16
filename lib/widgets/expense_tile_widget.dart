import 'package:cashify/utils/constants.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenceTile extends StatelessWidget {
  final bool loading;
  final double width;
  final Color color;
  final String title;
  final String subtitle;
  final String amount;
  final String? ave;
  final bool budget;
  final IconData icon;
  final EdgeInsets padding;
  final String? budgetKeeping;
  final double? budgetPercent;
  final bool? aveFit;
  final Widget? transferInfo;

  const ExpenceTile(
      {super.key,
      required this.width,
      required this.color,
      required this.title,
      required this.subtitle,
      required this.amount,
      this.ave,
      required this.budget,
      required this.icon,
      required this.padding,
      this.budgetKeeping,
      this.budgetPercent,
      required this.loading,
      this.aveFit,
      this.transferInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 0),
              blurRadius: 5,
            )
          ],
          color: forgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.15,
                height: width * 0.15,
                decoration: BoxDecoration(
                  color:
                      loading ? Colors.grey.shade100 : color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: loading ? Container() : FaIcon(icon, color: color),
                ),
              ),
            ),
            SizedBox(
              width: ((width * 0.85) - 40) * 0.75,
              height: width * 0.15,
              child: Column(
                mainAxisAlignment: budget
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    size: 15,
                    align: TextAlign.left,
                    color: color,
                  ),
                  CustomText(
                    text: subtitle,
                    size: 12,
                    color: Colors.grey.shade500,
                  ),
                  if (budget) ...[
                    transferInfo ??
                        Stack(
                          children: [
                            Container(
                              width: ((width * 0.85) - 40) * 0.7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: loading ? null : color.withOpacity(0.15),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: loading
                                  ? CustomText(
                                      text: subtitle,
                                    )
                                  : null,
                            ),
                            Container(
                              width: (((width * 0.85) - 40) * 0.7) *
                                  (budgetPercent as double),
                              height: 7,
                              decoration: BoxDecoration(
                                color: loading ? null : color,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        )
                  ]
                ],
              ),
            ),
            SizedBox(
              width: ((width * 0.85) - 40) * 0.23,
              height: width * 0.15,
              child: Column(
                mainAxisAlignment: budget
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: amount,
                    size: 15,
                    align: TextAlign.left,
                    color: color,
                  ),
                  if (ave != null) ...[
                    CustomText(
                      maxline: 1,
                      isFit: aveFit ?? true,
                      flow: TextOverflow.ellipsis,
                      text: ave as String,
                      size: 12,
                      color: Colors.grey.shade500,
                    )
                  ],
                  if (budget) ...[
                    transferInfo == null
                        ? CustomText(
                            maxline: 1,
                            isFit: true,
                            text: budgetKeeping as String,
                            size: 12,
                            color: Colors.grey.shade500,
                          )
                        : Container(),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
