import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashify/widgets/avatar/avatar_loading.dart';
import 'package:cashify/widgets/avatar/avatar_none.dart';
import 'package:cashify/widgets/avatar/avatar_online.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AvatarOnline extends StatelessWidget {
  final double width;
  final double height;
  final bool border;
  final String link;
  final bool shadow;
  const AvatarOnline({
    super.key,
    required this.width,
    required this.height,
    required this.border,
    required this.link,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: link,
      imageBuilder: (context, provider) {
        return AvatarOnlineInside(
            height: height,
            width: width,
            border: border,
            shadow: shadow,
            provider: provider);
      },
      placeholder: (context, url) {
        return AvatarLoading(
            height: height, width: width, border: border, shadow: shadow);
      },
      errorWidget: (context, url, error) {
        return AvatarNon(
          height: height,
          width: width,
          border: border,
          icon: FontAwesomeIcons.exclamation,
          color: Colors.red,
        );
      },
    );
  }
}
