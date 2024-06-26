import 'package:cashify/utils/enums.dart';
import 'package:cashify/widgets/avatar/avatar_cashed.dart';
import 'package:cashify/widgets/avatar/avatar_loading.dart';
import 'package:cashify/widgets/avatar/avatar_local.dart';
import 'package:cashify/widgets/avatar/avatar_none.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final AvatarType type;
  final double height;
  final double width;
  final String link;
  final bool border;
  final bool shadow;
  final Color? borderColor;
  const Avatar({
    super.key,
    required this.type,
    required this.height,
    required this.width,
    required this.link,
    this.borderColor,
    required this.border,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return type == AvatarType.none
        ? AvatarNon(height: height, width: width, border: border)
        : type == AvatarType.local
            ? AvatarLocal(
                height: height,
                width: width,
                border: border,
                link: link,
                shadow: shadow)
            : type == AvatarType.online
                ? AvatarOnline(
                    borderColor: borderColor,
                    height: height,
                    width: width,
                    border: border,
                    link: link,
                    shadow: shadow)
                : AvatarLoading(
                    height: height,
                    width: width,
                    border: border,
                    shadow: shadow,
                  );
  }
}
