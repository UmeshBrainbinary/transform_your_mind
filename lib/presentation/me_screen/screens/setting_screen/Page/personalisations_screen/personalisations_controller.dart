import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';

class PersonalisationsController extends GetxController{


  RxList accountData = [].obs;

  RxBool language = false.obs;

  @override
  void onInit() {
    accountData.value = _AccountData.getAccountData;
    super.onInit();
  }

  Future<void> onTapChangeLan() async {
    String currentLanguage = PrefService.getString(PrefKey.language);
    Locale newLocale;

    if (currentLanguage == 'en_US') {
      newLocale = const Locale('en', 'US');
    } else {
      newLocale = const Locale('de', 'DE');
    }

    Get.updateLocale(newLocale);
    await PrefService.setValue(PrefKey.language, newLocale.toLanguageTag());
    debugPrint("Language changed to ${newLocale.languageCode}_${newLocale.countryCode}");
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