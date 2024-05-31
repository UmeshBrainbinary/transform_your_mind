import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';


class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    isDarkMode.value = PrefService.getBool(PrefKey.isDarkTheme);

  }



  Future<void> saveThemeToBox(bool isDarkMode) async{
    await PrefService.setValue(PrefKey.isDarkTheme, isDarkMode);
  }

  void switchTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    saveThemeToBox(isDarkMode.value);
    //setThemeWiseColor();
}


  //
  // Rx<Color> containerColor = ColorConstant.white.obs;
  //
  //
  //
  // void setThemeWiseColor() {
  //   if(isDarkMode.value)
  //   {
  //     containerColor.value = ColorConstant.textfieldFillColor;
  //   }
  //   else{
  //     containerColor.value = ColorConstant.white;
  //   }
  // }

}


