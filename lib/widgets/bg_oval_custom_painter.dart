
import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class BgOvalCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height);
    path_0.lineTo(size.width * 1.006339, size.height);
    path_0.cubicTo(size.width * 0.8467653, size.height * 0.3491652,
        size.width * 0.6779040, 0, size.width * 0.5031680, 0);
    path_0.cubicTo(size.width * 0.3284347, 0, size.width * 0.1595715,
        size.height * 0.3491652, 0, size.height);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = ColorConstant.themeColor;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



class BgOvalCustomPainterVoice extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height);
    path_0.lineTo(size.width * 1.006339, size.height);
    path_0.cubicTo(size.width * 0.8467653, size.height * 0.3491652,
        size.width * 0.6779040, 0, size.width * 0.5031680, 0);
    path_0.cubicTo(size.width * 0.3284347, 0, size.width * 0.1595715,
        size.height * 0.3491652, 0, size.height);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = ColorConstant.themeColor;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class BgOvalCustomPainterLogin extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height+1);
    path_0.lineTo(size.width * 1.006339, size.height);
    path_0.cubicTo(size.width * 0.8467653, size.height * 0.3491652,
        size.width * 0.6779040, 0, size.width * 0.5031680, 0);
    path_0.cubicTo(size.width * 0.3284347, 0, size.width * 0.1595715,
        size.height * 0.3491652, 0, size.height);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = ColorConstant.themeColor;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
