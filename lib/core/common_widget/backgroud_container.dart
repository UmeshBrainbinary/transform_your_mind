import 'package:flutter/material.dart';


class BackGroundContainer extends StatelessWidget {
  final String image;
  final bool isLeft;
  final double? top;
  final double? bottom;
  final double height;

  const BackGroundContainer({
    super.key,
    required this.image,
    required this.isLeft,
    required this.height,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      right: isLeft ? null : 0,
      left: isLeft ? 0 : null,
      child: Image.asset(image, height: height),
    );
  }
}
/*


statusBarSet(ThemeController themeController){
  themeController.isDarkMode.isTrue?  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.darkBackground,
    statusBarIconBrightness: Brightness.light,
  ))  :
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.backGround,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

}
statusBarSetWhite(ThemeController themeController){
  themeController.isDarkMode.isTrue?  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.darkBackground,
    statusBarIconBrightness: Brightness.light,
  ))  :
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.white,
    statusBarIconBrightness: Brightness.dark,
  ));

}

menuBarSet(ThemeController themeController){
  themeController.isDarkMode.isTrue?  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.darkBackground,
    statusBarIconBrightness: Brightness.light,
  ))  :
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.backGround,
    statusBarIconBrightness: Brightness.dark,
  ));

}

*/
