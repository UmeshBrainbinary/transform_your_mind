import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';


class LottieIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final double height;
  final double width;
  final double iconHeight;
  final double iconWidth;
  final bool repeat;

  const LottieIconButton(
      {Key? key,
      required this.icon,
      required this.onTap,
      this.height = Dimens.d56,
      this.width = Dimens.d56,
      this.iconHeight = Dimens.d24,
      this.iconWidth = Dimens.d24,
      this.repeat = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: Dimens.d28.radiusAll,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Lottie.asset(icon,
            //key: widget.key,
            height: iconHeight,
            width: iconWidth,
            fit: BoxFit.cover,
            repeat: repeat,
            reverse: false),
      ),
    );
  }
}
