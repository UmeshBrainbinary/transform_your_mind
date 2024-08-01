import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  ProfileController profileController = Get.find<ProfileController>();
  String currentLanguage = PrefService.getString(PrefKey.language);

  @override
  void initState() {
    profileController.getPrivacy();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "privacySettings".tr),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d100),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile1Dark
                      : ImageConstant.profile1),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d400),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile2Dark
                      : ImageConstant.profile2),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimens.d30.spaceHeight,
                  Text(
                    "PrivacyPolicy".tr,
                    style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: themeController.isDarkMode.isTrue
                            ? ColorConstant.white
                            : ColorConstant.black),
                  ),
                  Dimens.d10.spaceHeight,
                  currentLanguage == "en-US"
                      ? Html(
                          style: {
                      "p": Style(
                          fontFamily: 'Montserrat-Medium',
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.w400,
                          color: themeController.isDarkMode.isTrue
                              ? ColorConstant.white
                              : ColorConstant.black),
                      "strong": Style(
                          fontFamily: 'Montserrat-Bold',
                          fontSize: FontSize(14.0),
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode.isTrue
                              ? ColorConstant.white
                              : ColorConstant.black),
                    },
                    data: """
            ${profileController.privacyModel.data?.description ?? ""}
          """,
                        )
                      : Html(
                          style: {
                            "p": Style(
                                fontFamily: 'Montserrat-Medium',
                                fontSize: FontSize(14.0),
                                fontWeight: FontWeight.w400,
                                color: themeController.isDarkMode.isTrue
                                    ? ColorConstant.white
                                    : ColorConstant.black),
                            "strong": Style(
                                fontFamily: 'Montserrat-Bold',
                                fontSize: FontSize(14.0),
                                fontWeight: FontWeight.bold,
                                color: themeController.isDarkMode.isTrue
                                    ? ColorConstant.white
                                    : ColorConstant.black),
                          },
                          data: """
            ${profileController.privacyModel.data?.gDescription ?? ""}
          """,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
