import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TeamLogo extends StatelessWidget {
  final String url;
  final TeamLogoStyle style;

  const TeamLogo({
    Key key,
    this.url,
    this.style = TeamLogoStyle.Normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size;
    switch (style) {
      case TeamLogoStyle.Small:
        size = 16;
        break;
      case TeamLogoStyle.Normal:
        size = 32;
        break;
    }

    if (url.endsWith("svg")) {
      return SvgPicture.network(
        url,
        height: size,
        width: size,
      );
    } else {
      return CircleAvatar(
        radius: size / 2,
        child: ClipOval(
          child: Image.network(
            url,
            height: size,
            width: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}

enum TeamLogoStyle { Small, Normal }
