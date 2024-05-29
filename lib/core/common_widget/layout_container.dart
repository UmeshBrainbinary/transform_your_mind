import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';


class LayoutContainer extends StatelessWidget {
  final Widget child;
  final double vertical;
  final double horizontal;

  const LayoutContainer({
    Key? key,
    required this.child,
    this.vertical = Dimens.d20,
    this.horizontal = Dimens.d20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: child,
    );
  }
}
