import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';

class PersonalisationsController extends GetxController{


  RxList accountData = [].obs;

  RxBool language = false.obs;

  @override
  void onInit() {
    accountData.value = _AccountData.getAccountData;
    super.onInit();
  }

}

class _AccountData {

  final String title;
  //final String suffixIcon;

  _AccountData({

    required this.title,
    //required this.suffixIcon,
  });

  static get getAccountData => [
    _AccountData(

      title: "theme".tr,
      //suffixIcon: themeManager.lottieRightArrow,
    ),
    _AccountData(

      title: "language".tr,
      //suffixIcon: themeManager.lottieRightArrow,
    ),

  ];
}