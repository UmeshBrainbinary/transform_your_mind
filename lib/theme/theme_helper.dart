import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';


class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     foregroundColor: Colors.white,
    //     backgroundColor: Colors.blue,
    //     textStyle: TextStyle(fontSize: 16.0),
    //   ),
    // ),

    dialogTheme: DialogTheme(backgroundColor: ColorConstant.white),
    scaffoldBackgroundColor: ColorConstant.white,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: ColorConstant.black),
    ),

  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    dialogTheme: DialogTheme(backgroundColor: ColorConstant.textfieldFillColor),
    scaffoldBackgroundColor: Colors.black,
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     foregroundColor: Colors.white, backgroundColor: Colors.orange,
    //     textStyle: TextStyle(fontSize: 16.0),
    //   ),
    // ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: ColorConstant.white),
    ),

  );
}
