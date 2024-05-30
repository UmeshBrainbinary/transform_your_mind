import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';

class SettingController extends GetxController {

   RxList settingsData = [].obs;


  @override
  void onInit() {
    settingsData.value = _SettingsData.getSettingsData;
    super.onInit();
  }

}

class _SettingsData {
  final String prefixIcon;
  final String title;
  //final String suffixIcon;
  final int index;
  Widget? settings;

  _SettingsData({
    required this.prefixIcon,
    required this.title,
    // required this.suffixIcon,
    required this.index,
    this.settings
  });

  static get getSettingsData => [
    _SettingsData(
      prefixIcon: ImageConstant.settingsNotification,
      title: "notifications".tr,
      //suffixIcon: themeManager.lottieRightArrow,
      index: 0,
    ),
    _SettingsData(
      prefixIcon: ImageConstant.settingsPersonalization,
      title: "theme".tr,
      //suffixIcon: themeManager.lottieRightArrow,
      index: 1,
    ),
    _SettingsData(
      prefixIcon: ImageConstant.settingsAccount,
      title: "account".tr,
      //suffixIcon: themeManager.lottieRightArrow,
      index: 2,
    ),
    // if (sl<LocalService>().getUserInfo()?.showSubscription ?? true)
    _SettingsData(
      prefixIcon: ImageConstant.settingsSubscription,
      title: "subscriptions".tr,
      //suffixIcon: themeManager.lottieRightArrow,
      index: 3,
    ),
    // _SettingsData(
    //   prefixIcon: ImageConstant.settingsReview,
    //   title: "leaveUsReview".tr,
    //   //suffixIcon: themeManager.lottieRightArrow,
    //   index: 4,
    // ),
    _SettingsData(
      prefixIcon: ImageConstant.settingsDelete,
      title: "deleteAccount".tr,
      //suffixIcon: themeManager.lottieRightArrow,
      index: 5,
    ),
    _SettingsData(
      prefixIcon: ImageConstant.settingsLegals,
      title: "legals".tr,
      //suffixIcon: themeManager.lottieRightArrow,
      index: 6,
    ),


  ];
}