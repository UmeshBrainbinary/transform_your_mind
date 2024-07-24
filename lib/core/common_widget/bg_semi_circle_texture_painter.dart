import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';


class BgSemiCircleTexture extends StatelessWidget {
  final double? topAlign;

  const BgSemiCircleTexture({super.key, this.topAlign});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: CustomPaint(
        size: const Size(
          double.infinity,
          double.infinity,
        ),
        painter: _BackGroundSemiCircleTexturePainter(topAlign: topAlign,themeController: themeController),
      ),
    );
  }
}

class _BackGroundSemiCircleTexturePainter extends CustomPainter {
  final double? topAlign;
  ThemeController? themeController;
  _BackGroundSemiCircleTexturePainter({this.topAlign,this.themeController});

  @override
  void paint(Canvas canvas, Size size) {
    Paint middleCirclePaint = Paint()
      ..color = themeController!.isDarkMode.isTrue?ColorConstant.textfieldFillColor:ColorConstant.colorbfd0d4.withOpacity(0.5)
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
