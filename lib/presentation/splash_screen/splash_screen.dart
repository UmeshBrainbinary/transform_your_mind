import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_today_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feelings_evening.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/personalisations_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String greeting = "";

  void _setGreetingBasedOnTime() {
    greeting = _getGreetingBasedOnTime();
    setState(() {});
  }

  String _getGreetingBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'goodMorning';
    } else if (hour >= 12 && hour < 17) {
      return 'goodAfternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'goodEvening';
    } else {
      return 'goodNight';
    }
  }

  @override
  void initState() {
    _setGreetingBasedOnTime();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        PrefService.getBool(PrefKey.isLoginOrRegister) == true
            ? PrefService.getBool(PrefKey.morningQuestion) == false &&
                    greeting == "goodMorning"
                ? Get.to(() => const HowFeelingTodayScreen())
                : PrefService.getBool(PrefKey.eveningQuestion) == false &&
                        greeting == "goodEvening"
                    ? Get.to(() => const HowFeelingsEvening())
                    : Get.offAllNamed(AppRoutes.dashBoardScreen)
            : PrefService.getBool(PrefKey.introSkip) == true
                ? Get.offAllNamed(AppRoutes.loginScreen)
                : Get.offAll(const PersonalizationScreenScreen(
                    intro: true,
                  ));
      } ,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          ImageConstant.splashBack,
          fit: BoxFit.fill,
          height: Get.height,
          width: Get.width,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Dimens.d88.spaceHeight,
            Image.asset(
              ImageConstant.logoSplash,
              height: Dimens.d180,
              width: Dimens.d180,
            ),
            Dimens.d100.spaceHeight,
           Image.asset(ImageConstant.text,width: 279,),
           /* SizedBox(width: 279,height: 112,
              child: Text(
                "Transform YourMind",textAlign: TextAlign.center,
                style: Style.nunRegular(fontSize: 50, color: ColorConstant.white,),
              ),
            ),*/
            Dimens.d23.spaceHeight,
            Text("CREATE YOUR BEST LIFE",style: Style.nunRegular(fontSize: 18,color: ColorConstant.white),),
            const Spacer(),
            Text("@transformyourmind.ch",style: Style.nunitoSemiBold(fontSize: 20,color: ColorConstant.white),),
            Dimens.d40.spaceHeight,

          ],
        )
      ],
    ));
  }
}
