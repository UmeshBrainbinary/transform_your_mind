import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';


class TabText extends StatelessWidget {
  final String text;
  final double value;
  final double selectedIndex;
  final EdgeInsets? padding;
  final double textHeight;
  final double? fontSize;

  const TabText({
    Key? key,
    required this.text,
    required this.value,
    required this.selectedIndex,
    this.padding,
    this.textHeight = Dimens.d1_5,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: Dimens.d10),
      child: Text(
        text,
        style: TextStyle(
          height: textHeight,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
