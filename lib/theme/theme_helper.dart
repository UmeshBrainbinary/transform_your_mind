import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';


class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,

      navigationBarTheme: const NavigationBarThemeData(
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

    dialogTheme: const DialogTheme(backgroundColor: ColorConstant.white),
    scaffoldBackgroundColor: ColorConstant.white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: ColorConstant.black),
    ),
     bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: ColorConstant.white)
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    dialogTheme: const DialogTheme(backgroundColor: ColorConstant.textfieldFillColor),
    scaffoldBackgroundColor: ColorConstant.black,
    navigationBarTheme: const NavigationBarThemeData(
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
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: ColorConstant.white),
    ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: ColorConstant.black)

  );
}
