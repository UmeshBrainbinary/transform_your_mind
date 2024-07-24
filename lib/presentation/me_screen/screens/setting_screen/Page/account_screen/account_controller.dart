
import 'package:get/get.dart';

import 'package:transform_your_mind/core/utils/image_constant.dart';


class AccountController extends GetxController {

  RxList accountData = [].obs;
  RxBool loader = false.obs;

  @override
  void onInit() {
    accountData.value = _AccountData.getAccountData;
    super.onInit();
  }
}

class _AccountData {
  final String prefixIcon;
  final String title;
  //final String suffixIcon;

  _AccountData({
    required this.prefixIcon,
    required this.title,
    //required this.suffixIcon,
  });

  static get getAccountData => [
    _AccountData(
      prefixIcon:   ImageConstant.edit,
          title: "personalInformation".tr,
          //suffixIcon: themeManager.lottieRightArrow,
    ),
    _AccountData(
      prefixIcon: ImageConstant.lock,
      title: "changePassword".tr,
      //suffixIcon: themeManager.lottieRightArrow,
    ),
    _AccountData(
      prefixIcon: ImageConstant.privacyPolicy,
          title: "privacySettings".tr,
          //suffixIcon: themeManager.lottieRightArrow,
    ),
  ];
}