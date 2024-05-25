import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';


class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        textStyle: TextStyle(fontSize: 16.0),
      ),
    ),
    //backgroundColor: Colors.white,

    scaffoldBackgroundColor: ColorConstant.backGround,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.black),
    ),

  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    //backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.orange,
        textStyle: TextStyle(fontSize: 16.0),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.white),
    ),

  );
}
