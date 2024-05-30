import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';


class BgSemiCircleTexture extends StatelessWidget {
  final double? topAlign;

  const BgSemiCircleTexture({Key? key, this.topAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: CustomPaint(
        size: const Size(
          double.infinity,
          double.infinity,
        ),
        painter: _BackGroundSemiCircleTexturePainter(topAlign: topAlign),
      ),
    );
  }
}

class _BackGroundSemiCircleTexturePainter extends CustomPainter {
  final double? topAlign;

  _BackGroundSemiCircleTexturePainter({this.topAlign});

  @override
  void paint(Canvas canvas, Size size) {
    Paint middleCirclePaint = Paint()
      ..color = ColorConstant.themeColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width / 2, topAlign ?? size.height * Dimens.d1_27),
        size.height,
        middleCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
