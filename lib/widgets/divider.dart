import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';


class DividerWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const DividerWidget({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.themeColor.withOpacity(0.2),
      height: height ?? Dimens.d1,
      width: width,
    );
  }
}


class DividerWidgetBlack extends StatelessWidget {
  final double? height;
  final double? width;

  const DividerWidgetBlack({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 0.5,
      width: width,
    );
  }
}

