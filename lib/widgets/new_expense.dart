import 'package:cashify/utils/constants.dart';
import 'package:cashify/utils/enums.dart';
import 'package:cashify/utils/util_functions.dart';
import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExpenceTileNew extends StatelessWidget {
  final ExpenseTile type;
  final double width;
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final int? count;
  final double? ave;
  final DateTime? date;
  final double? budgetNum;
  final bool? budget;
  final String sign;
  final String? reason;

  const ExpenceTileNew({
    super.key,
    required this.type,
    required this.width,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.count,
    this.ave,
    this.date,
    this.budgetNum,
    this.budget,
    required this.sign,
    this.reason,
  });

  @override
  Widget build(BuildContext context) {
    double budgetPercent = budget == true && budgetNum != 0
        ? (int.parse(amount.toStringAsFixed(0))) /
            int.parse(budgetNum!.toStringAsFixed(0))
        : 0;
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 15, spreadRadius: 3)
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Skeletonizer(
              enabled: type == ExpenseTile.loading,
              child: Container(
                width: width * 0.16,
                height: width * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                  color: type == ExpenseTile.loading
                      ? Colors.grey.shade200
                      : color.withOpacity(0.2),
                ),
                child: type == ExpenseTile.loading
                    ? null
                    : Center(
                        child: Icon(
                          icon,
                          color: color,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            width: (width * 0.65),
            height: width * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (type == ExpenseTile.expense) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: title,
                            color: Colors.black,
                            size: 18,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: width * 0.03,
                          ),
                          if (date != null) ...[
                            CustomText(
                              text: '${date!.year}/${date!.month}/${date!.day}',
                              color: Colors.grey,
                              size: 14,
                            ),
                          ]
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            color: amount > 0 ? Colors.green : Colors.red,
                            text: '${zerosConvert(val: amount)} $sign',
                            size: 16,
                          ),
                          if (reason != null) ...[
                            SizedBox(
                              height: width * 0.03,
                            ),
                            CustomText(
                              text: reason.toString(),
                              color: Colors.black.withOpacity(0.5),
                              size: 14,
                              flow: TextOverflow.ellipsis,
                            ),
                          ]
                        ],
                      ),
                    ],
                  )
                ],
                if (type == ExpenseTile.category ||
                    type == ExpenseTile.loading) ...[
                  Skeletonizer(
                    enabled: type == ExpenseTile.loading,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: title,
                              color: Colors.black,
                              size: 18,
                              weight: FontWeight.w500,
                            ),
                            CustomText(
                              text: '${zerosConvert(val: amount)} $sign',
                              color: amount > 0 ? Colors.green : Colors.red,
                              size: 16,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: '$count Transactions',
                                color: Colors.grey,
                                size: 12,
                              ),
                              CustomText(
                                text: ' average = $ave',
                                color: Colors.grey,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                        if (budget == true) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (type != ExpenseTile.loading) ...[
                                Stack(
                                  children: [
                                    Container(
                                      width: (width * 0.65) * 0.6,
                                      height: width * 0.032,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.3),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: ((width * 0.65) * 0.6) *
                                          (budgetPercent > 1
                                              ? 1
                                              : budgetPercent),
                                      height: width * 0.032,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: (((width * 0.65) * 0.6) * 0.5),
                                      child: CustomText(
                                        text:
                                            '${(budgetPercent * 100).toStringAsFixed(0)} %',
                                        size: 10,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                              CustomText(
                                isFit: true,
                                text:
                                    '${amount.toStringAsFixed(0)}/${budgetNum!.toStringAsFixed(0)}',
                                color: Colors.grey,
                                size: 12,
                              ),
                            ],
                          )
                        ]
                      ],
                    ),
                  )
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}
