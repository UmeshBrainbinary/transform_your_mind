import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';

class SettingController extends GetxController {
  RxList settingsData = [].obs;

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    settingsData.value = _SettingsData.getSettingsData;
    super.onInit();
  }
}

class _SettingsData {
  final String prefixIcon;
  final String title;
  final String suffixIcon;
  final int index;
  Widget? settings;

  _SettingsData(
      {required this.prefixIcon,
      required this.title,
      required this.suffixIcon,
      required this.index,
      this.settings});

  static ThemeController themeController = Get.find<ThemeController>();

  static get getSettingsData => [
        _SettingsData(
          prefixIcon: ImageConstant.settingArrowRight,
          title: "notifications",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 0,
        ),
        _SettingsData(
          prefixIcon: ImageConstant.settingsSubscription,
          title: "subscriptions",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 1,
        ),
        _SettingsData(
          prefixIcon: ImageConstant.settingsAccount,
          title: "accountSettings",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 2,
        ),
        _SettingsData(
            prefixIcon: ImageConstant.settingsLegals,
            title: PrefService.getBool(PrefKey.theme)
                ? "Dark Mode"
                : "Light Mode",
            suffixIcon: ImageConstant.settingArrowRight,
            index: 3,
            settings: CustomSwitch(
              value: themeController.isDarkMode.value,
              onChanged: (value) async {
                themeController.switchTheme();
                Get.forceAppUpdate();
              },
              width: 50.0,
              height: 25.0,
              activeColor: ColorConstant.themeColor,
              inactiveColor: ColorConstant.backGround,
            )),
        _SettingsData(
          prefixIcon: ImageConstant.settingsLegals,
          title: "chooseLanguage",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 4,
        ),
        _SettingsData(
          prefixIcon: ImageConstant.settingsDelete,
          title: "feedback",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 5,
        ),
        _SettingsData(
          prefixIcon: ImageConstant.settingsLegals,
          title: "contactSupport",
          suffixIcon: ImageConstant.settingArrowRight,
          index: 6,
        ),
      ];
}
