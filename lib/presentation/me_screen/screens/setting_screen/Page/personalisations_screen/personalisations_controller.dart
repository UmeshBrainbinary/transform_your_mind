import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';

class PersonalizationController extends GetxController {
  RxList accountData = [].obs;

  RxBool language = false.obs;
  RxBool english = false.obs;
  RxBool german = false.obs;

  @override
  void onInit() {
    accountData.value = _AccountData.getAccountData;
    String currentLanguage = PrefService.getString(PrefKey.language);
    if (currentLanguage == "en-US") {
      english.value = true;
      german.value = false;
    } else {
      english.value = false;
      german.value = true;
    }
    super.onInit();
  }

  onTapEnglish() {
    if (english.isFalse) {
      english.value = true;
      german.value = false;
    } else {
      english.value = false;
      german.value = true;
    }
  }

  Future<void> onTapChangeLan() async {
    String currentLanguage = PrefService.getString(PrefKey.language);
    Locale newLocale;

    if (currentLanguage == 'en_US') {
      language = false.obs;
      newLocale = const Locale('en', 'US');
      await PrefService.setValue(PrefKey.lanSwitch, true);
    } else {
      language = true.obs;
      newLocale = const Locale('de', 'DE');
      await PrefService.setValue(PrefKey.lanSwitch, false);
    }

    Get.updateLocale(newLocale);
    await PrefService.setValue(PrefKey.language, newLocale.toLanguageTag());
    debugPrint(
        "Language changed to ${newLocale.languageCode}_${newLocale.countryCode}");
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
