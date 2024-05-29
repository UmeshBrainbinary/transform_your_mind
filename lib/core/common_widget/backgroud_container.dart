import 'package:flutter/material.dart';

class BackGroundContainer extends StatelessWidget {
  final String image;
  final bool isLeft;
  final double? top;
  final double? bottom;
  final double height;

  const BackGroundContainer({
    Key? key,
    required this.image,
    required this.isLeft,
    required this.height,
    this.top,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      right: isLeft ? null : 0,
      left: isLeft ? 0 : null,
      child: Image.asset(image, height: height),
    );
  }
}
