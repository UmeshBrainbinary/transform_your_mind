import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget commonGradiantContainer({double? h, Color? color}) {
  return Container(
    height: h ?? 80,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          color ?? Colors.white,
          color?.withOpacity(0.9) ?? Colors.white.withOpacity(0.9),
          color?.withOpacity(0.8) ?? Colors.white.withOpacity(0.8),
          color?.withOpacity(0.7) ?? Colors.white.withOpacity(0.7),
          color?.withOpacity(0.6) ?? Colors.white.withOpacity(0.6),
          color?.withOpacity(0.5) ?? Colors.white.withOpacity(0.5),
          color?.withOpacity(0.4) ?? Colors.white.withOpacity(0.4),
          color?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
          color?.withOpacity(0.2) ?? Colors.white.withOpacity(0.2),
          color?.withOpacity(0.1) ?? Colors.white.withOpacity(0.1),
          color?.withOpacity(0.0) ?? Colors.white.withOpacity(0.0),
        ],
      ),
    ),
  );
}
Widget commonGradiantContainerBottom({double? h, Color? color}) {
  return Container(
    height: h ?? 80,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          color?.withOpacity(0.0) ?? Colors.white.withOpacity(0.0),
          color?.withOpacity(0.1) ?? Colors.white.withOpacity(0.1),
          color?.withOpacity(0.2) ?? Colors.white.withOpacity(0.2),
          color?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
          color?.withOpacity(0.4) ?? Colors.white.withOpacity(0.4),
          color?.withOpacity(0.5) ?? Colors.white.withOpacity(0.5),
          color?.withOpacity(0.6) ?? Colors.white.withOpacity(0.6),
          color?.withOpacity(0.7) ?? Colors.white.withOpacity(0.7),
          color?.withOpacity(0.8) ?? Colors.white.withOpacity(0.8),
          color?.withOpacity(0.9) ?? Colors.white.withOpacity(0.9),
          color ?? Colors.white,
        ],
      ),
    ),
  );
}
