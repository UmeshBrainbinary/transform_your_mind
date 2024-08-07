
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/model_class/get_screen_model.dart';
import '../../../../../../core/utils/end_points.dart';

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
    } else if(currentLanguage==""){
      english.value = true;
    }else{
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
  RxBool loader = false.obs;
  GetScreenModel getScreenModel = GetScreenModel();
  getScreen() async {

    loader.value = true;
    var request = http.Request('GET', Uri.parse(EndPoints.getScreen));



    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;

      final responseBody = await response.stream.bytesToString();

      getScreenModel = getScreenModelFromJson(responseBody);
      debugPrint("getScreenModel get data $getScreenModel");
      update(["u"]);
      update();
    }
    else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;

   update(["u"]);
   update();
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
