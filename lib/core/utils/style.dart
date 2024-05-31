import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:transform_your_mind/core/utils/color_constant.dart';


class FontFamily {
  static String montserratBold ="Montserrat-Bold";
  static String montserratMedium ="Montserrat-Medium";
  static String montserratRegular ="Montserrat-Regular";
  static String montserratSemiBold ="Montserrat-SemiBold";


  static String cormorantGaramondBold ="CormorantGaramond-Bold";
  static String cormorantGaramondMedium ="CormorantGaramond-Medium";
  static String cormorantGaramondRegular ="CormorantGaramond-Regular";
  static String cormorantGaramondSemiBold ="CormorantGaramond-SemiBold";

}

class Style {

  static TextStyle montserratBold({
    Color? color ,
    FontWeight fontWeight = FontWeight.w700,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color ,
      fontFamily: FontFamily.montserratBold,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }

  static TextStyle montserratMedium({
    Color? color ,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.montserratMedium,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }


  static TextStyle montserratRegular({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.montserratRegular,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }

  static TextStyle montserratSemiBold({
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.montserratSemiBold,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }

  ///---------------

  static TextStyle cormorantGaramondBold({
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.cormorantGaramondBold,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }

  static TextStyle cormorantGaramondMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.cormorantGaramondMedium,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }


  static TextStyle cormorantGaramondRegular({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.cormorantGaramondRegular,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }

  static TextStyle cormorantGaramondSemiBold({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.cormorantGaramondSemiBold,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }




}
