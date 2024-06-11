import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';

class PrivacyPolicyController extends GetxController {
  RxList privacyData = [].obs;
  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    privacyData.value = _PrivacyData.getSettingsData;
    super.onInit();
  }
}


class _PrivacyData {
  final String prefixIcon;
  final String title;
  final String suffixIcon;
  final int? index;


  _PrivacyData(
      {required this.prefixIcon,
        required this.title,
        required this.suffixIcon,
        required this.index,
        });


  static get getSettingsData => [
    _PrivacyData(
      prefixIcon: ImageConstant.settingArrowRight,
      title: "personalInformation",
      suffixIcon: ImageConstant.settingArrowRight,
      index: 0,
    ),
    _PrivacyData(
      prefixIcon: ImageConstant.settingsSubscription,
      title: "passwordAndSecurity",
      suffixIcon: ImageConstant.settingArrowRight,
      index: 1,
    ),
    _PrivacyData(
      prefixIcon: ImageConstant.settingsAccount,
      title: "payments".tr,
      suffixIcon: ImageConstant.settingArrowRight,
      index: 2,
    ),


  ];
}
