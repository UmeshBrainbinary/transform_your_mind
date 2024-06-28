import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class LoginPreviewView extends StatefulWidget {
  const LoginPreviewView({super.key});

  @override
  State<LoginPreviewView> createState() => _LoginPreviewViewState();
}

class _LoginPreviewViewState extends State<LoginPreviewView> {
  bool _isChecked = false;

  _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }
  ThemeController themeController = Get.find<ThemeController>();
@override
  void initState() {
  themeController.isDarkMode.isTrue?  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.darkBackground,
    statusBarIconBrightness: Brightness.light,
  ))  :
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstant.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: ColorConstant.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Dimens.d80.spaceHeight,
            Image.asset(
              ImageConstant.splashLogo,
              height: Dimens.d150,
              width: Dimens.d150,
            ),
            Dimens.d22.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
              child: Text(
                "wT".tr,
                textAlign: TextAlign.center,
                style: Style.gothamMedium(fontSize: 24),
              ),
            ),
            Dimens.d18.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
              child: Text(
                "awaken".tr,
                textAlign: TextAlign.center,
                style: Style.gothamLight(
                    fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            Dimens.d62.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d24),
              child: Row(
                children: [
                  Checkbox(hoverColor: ColorConstant.themeColor,
                     focusColor: ColorConstant.themeColor,
                    activeColor: ColorConstant.themeColor,
                    checkColor: ColorConstant.white,
                    value: _isChecked,
                    onChanged: _toggleCheckbox,
                  ),
                  StyledText(
                    text: '<bold>${"iAgreeThe".tr}</bold><red>${"t&m".tr}</red>\n<bold>${"ofThe".tr}</bold><red>${"privacyPolicy".tr}</red>',
                    tags: {
                      'bold': StyledTextTag(style:Style.gothamMedium(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1.5),),

                      'red': StyledTextTag(style: Style.gothamMedium(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.themeColor)),
                     // 'privacyPolicy': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    },
                  )
                 /* Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "iAgreeThe".tr,
                          style: Style.gothamMedium(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.5),
                          children: [
                            TextSpan(
                              text: "t&m".tr,
                              style: Style.gothamMedium(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.themeColor),
                            ),
                            TextSpan(
                              text: "ofThe".tr,
                              style: Style.gothamMedium(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: "privacyPolicy".tr,
                              style: Style.gothamMedium(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.themeColor),
                            ),
                          ]),
                    ),
                  )*/
                ],
              ),
            ),
            Dimens.d70.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 86),
              child: CommonElevatedButton(
                title: "login".tr,
                onTap: () {
                  if(_isChecked){
                    PrefService.setValue(PrefKey.introSkip, true);
                    Get.toNamed(AppRoutes.loginScreen);
                  }else{
                    showSnackBarError(context, "pleaseAcceptTerms".tr);
                  }
                },
              ),
            ),
            Dimens.d16.spaceHeight,
            Text(
              "Or",
              textAlign: TextAlign.center,
              style:
                  Style.gothamMedium(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Dimens.d16.spaceHeight,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 86),
              child: CommonElevatedButton(
                title: "register".tr,
                onTap: () {
                  if(_isChecked){
                    Get.toNamed(AppRoutes.registerScreen);
                  }else{
                    showSnackBarError(context, "pleaseAcceptTerms".tr);
                  }


                },
              ),
            ),
            Dimens.d52.spaceHeight,
          ],
        ),
      ),
    );
  }
}
