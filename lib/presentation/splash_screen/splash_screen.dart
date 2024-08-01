import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_motivational.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_stress.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_today_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feelings_evening.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/motivational_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/sleep_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/stress_questions.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_affirmation_focus_page.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/personalisations_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/personalisations_screen.dart';
import 'package:transform_your_mind/presentation/welcome_screen/welcome_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String greeting = "";

  GetUserModel getUserModel = GetUserModel();

  void _setGreetingBasedOnTime() {
    greeting = _getGreetingBasedOnTime();
    setState(() {});
  }
  PersonalizationController personalizationController =
  Get.put(PersonalizationController());

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
  bool checkInternetCheck = false;

  @override
  void initState() {
    setMethod();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    _setGreetingBasedOnTime();
    checkInternet();
    super.initState();
  }
  String currentLanguage = '';

  checkInternet() async {
    if (await isConnected()) {
      setState(() {
        checkInternetCheck = true;
      });

      await personalizationController.getScreen();
      currentLanguage = PrefService.getString(PrefKey.language).isEmpty
          ? "en-US"
          : PrefService.getString(PrefKey.language);
      setState(() {});
    } else {
      setState(() {
        checkInternetCheck = false;
      });
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }


  getUSer(BuildContext context) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getUser}${PrefService.getString(PrefKey.userId)}",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getUserModel = getUserModelFromJson(responseBody);
        Future.delayed(
          const Duration(seconds: 4),
              () {
            PrefService.getBool(PrefKey.isLoginOrRegister) == true
                ? getUserModel.data?.welcomeScreen == false
                ? Get.offAll(const WelcomeHomeScreen())
                : setScreens()
                : PrefService.getBool(PrefKey.introSkip) == true
                ? Get.offAllNamed(AppRoutes.loginScreen)
                : Get.offAll(const PersonalizationScreenScreen(
              intro: true,
            ));
          },
        );
        await PrefService.setValue(PrefKey.language,
            getUserModel.data!.language == "english" ? "en-US" : "de-DE");

        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {});
  }

  setMethod() async {
    if (PrefService.getBool(PrefKey.isLoginOrRegister) == true) {
      await getUSer(context);

    } else {
      Future.delayed(
        const Duration(seconds: 4),
        () {
          PrefService.getBool(PrefKey.isLoginOrRegister) == true
              ? PrefService.getBool(PrefKey.welcomeScreen) == false
                  ? Get.offAll(const WelcomeHomeScreen())
                  : setScreens()
              : PrefService.getBool(PrefKey.introSkip) == true
                  ? Get.offAllNamed(AppRoutes.loginScreen)
                  : Get.offAll(const PersonalizationScreenScreen(
                      intro: true,
                    ));
        },
      );
    }
  }

  setScreens() async {
    if (getUserModel.data?.morningMoodQuestions ??
        false == false && greeting == "goodMorning") {
      Get.offAll(() => const HowFeelingTodayScreen());
    } else if (getUserModel.data?.morningSleepQuestions ??
        false == false && greeting == "goodMorning") {
      Get.offAll(() => StressQuestions());
    } else if (getUserModel.data?.morningStressQuestions ??
        false == false && greeting == "goodMorning") {
      Get.offAll(() => SleepQuestions());
    } else if (getUserModel.data?.morningMotivationQuestions ??
        false == false && greeting == "goodMorning") {
      Get.offAll(() => MotivationalQuestions());
    } else if (getUserModel.data?.eveningMoodQuestions ??
        false == false && greeting == "goodEvening") {
      Get.offAll(() => const HowFeelingsEvening());
    } else if (getUserModel.data?.eveningStressQuestions ??
        false == false && greeting == "goodEvening") {
      Get.offAll(() => EveningStress());
    } else if (getUserModel.data?.eveningMotivationQuestions ??
        false == false && greeting == "goodEvening") {
      Get.offAll(() => EveningMotivational());
    } else {
      Get.offAll(() => const DashBoardScreen());
    }
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
