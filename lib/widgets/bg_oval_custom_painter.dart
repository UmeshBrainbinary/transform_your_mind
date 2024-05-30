
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



//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(32.5,20.083);
path_0.cubicTo(19.082,20.083,8.166,30.999,8.166,44.417);
path_0.cubicTo(8.166,44.693000000000005,8.39,44.917,8.666,44.917);
path_0.lineTo(56.334,44.917);
path_0.cubicTo(56.61000000000001,44.917,56.834,44.693000000000005,56.834,44.417);
path_0.cubicTo(56.834,30.999,45.918,20.083,32.5,20.083);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}
