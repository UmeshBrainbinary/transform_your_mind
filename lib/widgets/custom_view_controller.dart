import 'package:flutter/material.dart';

class CustomScrollViewWidget extends StatelessWidget {
  final Widget child;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const CustomScrollViewWidget({
    super.key,
    required this.child,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics ?? const ClampingScrollPhysics(),
      controller: controller,
      child: child,
    );
  }
}
