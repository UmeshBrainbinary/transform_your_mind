import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Dimens.d120.spaceHeight,
          Center(child: Image.asset(ImageConstant.welcomeBackImage,height: 186,width: 325,)),
          Dimens.d75.spaceHeight,
        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
            child: Text(
             "${ "welcome".tr}, “ ${PrefService.getString(PrefKey.name)} ”!",
              textAlign: TextAlign.center,
              style: Style.gothamMedium(fontSize: 24),
            ),
          ),
          Dimens.d18.spaceHeight,
        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d36),
            child: Text(
              "howNice".tr,
              textAlign: TextAlign.center,
              style: Style.gothamLight(
                  fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Dimens.d56.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d18),
            child: Text(
              "powerfulExercise".tr,
              textAlign: TextAlign.center,
              style: Style.gothamMedium(fontSize: 24),
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
