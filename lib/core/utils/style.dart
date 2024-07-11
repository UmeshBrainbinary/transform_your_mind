import 'package:flutter/material.dart';


class FontFamily {
  static String montserratBold ="Nunito-Bold";
  static String montserratMedium ="Nunito-Medium";
  static String montserratRegular = "Nunito-Regular";
  static String montserratSemiBold ="Nunito-SemiBold";


  static String cormorantGaramondBold ="Nunito-Bold";
  static String cormorantGaramondMedium ="Nunito-Medium";
  static String cormorantGaramondRegular ="Nunito-Regular";
  static String cormorantGaramondSemiBold ="Nunito-SemiBold";
  static String gothamMedium ="Nunito-Medium";
  static String gothamLight ="Nunito-Light";
  static String nunitoRegular = "Nunito-Regular";
  static String nunito = "Nunito-Light";
  static String nunitoBold = "Nunito-Bold";
  static String nunitoSemiBold = "Nunito-SemiBold";
  static String nunitoMedium = "Nunito-Medium";
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

  static TextStyle nunitoBold({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.nunitoBold,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }

  static TextStyle nunitoSemiBold({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.nunitoSemiBold,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }
  static TextStyle nunMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.nunitoMedium,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }
  static TextStyle nunLight({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.nunito,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }
  static TextStyle nunRegular({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.nunitoRegular,
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


 static TextStyle gothamMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.gothamMedium,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }
  static TextStyle gothamLight({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    FontStyle fontStyle = FontStyle.normal,
    double? fontSize,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontFamily: FontFamily.gothamLight,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize ?? 14,
      height: height,
    );
  }




}
