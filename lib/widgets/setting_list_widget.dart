import 'package:cashify/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingList extends StatelessWidget {
  final Color color;
  final Color backColor;
  final Function() action;
  final IconData icon;
  final bool loading;
  final String trailing;
  final String title;
  final bool? loadingPossible;

  const SettingList(
      {super.key,
      required this.color,
      required this.action,
      required this.icon,
      required this.loading,
      required this.trailing,
      required this.title,
      required this.backColor,
      this.loadingPossible});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: backColor,
        child: InkWell(
          splashColor: Colors.grey,
          onTap: action,
          child: ListTile(
            leading: FaIcon(
              size: 20,
              icon,
              color: color,
            ),
            trailing: loadingPossible == true && loading
                ? CircularProgressIndicator(
                    color: color,
                  )
                : CustomText(
                    text: trailing,
                  ),
            title: CustomText(
              size: 14,
              text: title,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
