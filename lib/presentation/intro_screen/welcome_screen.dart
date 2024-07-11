import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeController themeController =Get.find<ThemeController>();
    return Scaffold(backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Dimens.d120.spaceHeight,
          Center(child: Image.asset(ImageConstant.welcomeBackImage,height: 186,width: 325,)),
          Dimens.d65.spaceHeight,
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
            child: Text(
             "${"welcome".tr}, “ ${PrefService.getString(PrefKey.name)} ”!",
              textAlign: TextAlign.center,
              style: Style.gothamLight(fontSize: 24,fontWeight: FontWeight.w600),
            ),
          ),
          Dimens.d14.spaceHeight,
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
            child: Text(
              "howNice".tr,
              textAlign: TextAlign.center,
              style: Style.gothamLight(
                  fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Dimens.d45.spaceHeight,
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d40),
              child: Text(
              "powerfulExercise".tr,
              textAlign: TextAlign.center,
                style: Style.gothamLight(
                    fontSize: 19, fontWeight: FontWeight.w600),
              ),
          ),
          Dimens.d40.spaceHeight,
            Padding(
            padding: const EdgeInsets.all(30),
            child: CommonElevatedButton(title: "letsStart".tr, onTap: () {
           //Get.offAllNamed(AppRoutes.breathScreen);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
             return BreathScreen(skip: true,);
           },));
            },),
          ),
          ],),
      ),
    );
  }
}
