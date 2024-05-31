import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';


class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,

      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(
            color: Colors.black, // Icon color
          ),)
      ),
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
     bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ColorConstant.white)
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    dialogTheme: DialogTheme(backgroundColor: ColorConstant.textfieldFillColor),
    scaffoldBackgroundColor: ColorConstant.black,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      iconTheme: WidgetStatePropertyAll(IconThemeData(
        color: Colors.white, // Icon color
      ),)
    ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     foregroundColor: Colors.white, backgroundColor: Colors.orange,
    //     textStyle: TextStyle(fontSize: 16.0),
    //   ),
    // ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: ColorConstant.white),
    ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: ColorConstant.black)

  );
}
