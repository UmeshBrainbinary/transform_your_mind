import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class ChangePasswordController extends GetxController {


  TextEditingController currentPController = TextEditingController();
  TextEditingController newPController = TextEditingController();
  TextEditingController confirmPController = TextEditingController();

  ValueNotifier<bool> securePass = ValueNotifier(true);
  ValueNotifier<bool> securePass2 = ValueNotifier(true);
  ValueNotifier<bool> securePass3 = ValueNotifier(true);
  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.onInit();
  }

}