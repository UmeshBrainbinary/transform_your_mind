import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';


class MessageView extends StatelessWidget {
  const MessageView({
    required this.title,
    required this.details,
    super.key,
  });

  final String title;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Style.nunRegular(
            height: Dimens.d1_4,
            color: ColorConstant.themeColor,
          ).copyWith(
            letterSpacing: Dimens.d0_16,
          ),
          textAlign: TextAlign.center,
        ),
        Dimens.d15.spaceHeight,
        Text(
          details,
          style: Style.nunRegular(
            color: ColorConstant.themeColor,
            fontSize: Dimens.d14,
            height: Dimens.d1_71,
          ).copyWith(
            letterSpacing: -Dimens.d0_48,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
