import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class PrivacyPolicyController extends GetxController {
  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));

    super.onInit();
  }
}

