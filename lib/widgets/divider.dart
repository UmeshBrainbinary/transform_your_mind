import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';


class DividerWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const DividerWidget({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

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
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 0.5,
      width: width,
    );
  }
}

