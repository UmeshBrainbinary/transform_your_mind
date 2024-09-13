import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
import 'package:transform_your_mind/presentation/welcome_screen/welcome_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
class FreeTrialPage extends StatefulWidget {
  const FreeTrialPage({super.key});
  static const freeTrial = '/freeTrial';

  @override
  State<FreeTrialPage> createState() => _FreeTrialPageState();
}

class _FreeTrialPageState extends State<FreeTrialPage>
    with TickerProviderStateMixin {
  late final AnimationController _lottieBgController;
  late final AnimationController _lottieFWController;
List plans = [false,false,false];
  String greeting = "";
  @override
  void initState() {
    super.initState();
    _setGreetingBasedOnTime();
getUSer(context, greeting);
    _lottieBgController = AnimationController(vsync: this);
    _lottieFWController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieBgController.dispose();
    _lottieFWController.dispose();
    super.dispose();
  }
 ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
   /*statusBarSet(themeController);*/
    return Scaffold(backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.white,
      body: Stack(
        children: [
        /*  Align(
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
                padding: const EdgeInsets.only(bottom: Dimens.d120),
                child: SvgPicture.asset(themeController.isDarkMode.isTrue
                    ? ImageConstant.profile2Dark
                    : ImageConstant.profile2),
              )),*/
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment:Alignment.topCenter,
                  children: [
                    Container(
                      child: Image.asset(ImageConstant.sub,),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 30 ),
                        child: InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Icon(Icons.close,  color: themeController.isDarkMode.isTrue?Colors.white:Colors.black,),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20,top: 30),
                        child: InkWell(
                          onTap: () async {
                            await PrefService.setValue(PrefKey.premium, true);
                            await PrefService.setValue(PrefKey.subscription, true);
                            await PrefService.setValue(
                                PrefKey.firstTimeRegister, true);
                            await PrefService.setValue(PrefKey.addGratitude, true);
                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (context) {
                            //     return const WelcomeHomeScreen();
                            //   },
                            // ));



                            if (getUserModel.data
                                ?.morningMoodQuestions ??
                                false == false &&
                                    greeting == "goodMorning") {
                              Get.offAll(() =>  SleepQuestions());
                            }
                            else if (getUserModel.data
                                ?.morningSleepQuestions ??
                                false == false &&
                                    greeting == "goodMorning") {
                              Get.offAll(() => StressQuestions());
                            } else if (getUserModel.data
                                ?.morningStressQuestions ??
                                false == false &&
                                    greeting == "goodMorning") {
                              Get.offAll(() => const HowFeelingTodayScreen());
                            } else if (getUserModel.data
                                ?.morningMotivationQuestions ??
                                false == false &&
                                    greeting == "goodMorning") {
                              Get.offAll(() => MotivationalQuestions());
                            } else if (getUserModel.data
                                ?.eveningMoodQuestions ??
                                false == false &&
                                    greeting == "goodEvening") {
                              Get.offAll(() => const HowFeelingsEvening());
                            } else if (getUserModel.data
                                ?.eveningStressQuestions ??
                                false == false &&
                                    greeting == "goodEvening") {
                              Get.offAll(() => EveningStress());
                            } else if (getUserModel.data
                                ?.eveningMotivationQuestions ??
                                false == false &&
                                    greeting == "goodEvening") {
                              Get.offAll(() => EveningMotivational());
                            } else {


                              Get.offAll(() => const DashBoardScreen());
                              /*if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
                                    {
                                      Get.offAll(() =>  SubscriptionScreen(skip: true,));

                                    }
                                    else
                                    {

                                      Get.offAll(() => const DashBoardScreen());
                                    }*/
                            }


                          },
                          child: Text(
                            "skip".tr,
                            style: Style.nunRegular(
                              fontSize: Dimens.d18,
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.white
                                  : ColorConstant.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Text(
                      "PREMIUM",
                      style: Style.nunitoBold(
                        fontSize: Dimens.d16,
                        color: ColorConstant.themeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 5,),
                    Image.asset(ImageConstant.star,width: 25,height: 25,),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Text(
                  "Try it for free".tr,
                  style: Style.nunitoBold(
                    fontSize: Dimens.d28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Dimens.d10.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 43),
                  child: Text(
                    "Unleash your full potential with TransformYourMind!".tr,
                    style: Style.nunMedium(
                        fontSize: Dimens.d14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Dimens.d10.spaceHeight,
                Dimens.d10.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Text(
                      "PREMIUM PLUS",
                      style: Style.nunitoBold(
                        fontSize: Dimens.d16,
                        color: ColorConstant.themeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 5,),
                    Image.asset(ImageConstant.star,width: 25,height: 25,),
                    Image.asset(ImageConstant.star,width: 25,height: 25,),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Text(
                  "Unlock all functions".tr,
                  style: Style.nunitoBold(
                    fontSize: Dimens.d28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Dimens.d10.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 43),
                  child: Text(
                    "and create your best life".tr,
                    style: Style.nunMedium(
                        fontSize: Dimens.d18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              /*  Dimens.d10.spaceHeight,
                Text(
                  "Unlock all functions".tr,
                  style: Style.nunitoBold(
                    fontSize: Dimens.d24,
                  ),
                  textAlign: TextAlign.center,
                ),
                Dimens.d10.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "From affirmations and deep meditation to transformative self-hypnosis audios, your personal well-being barometer and mindfulness training.".tr,
                    style: Style.nunMedium(
                        fontSize: Dimens.d14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),*/
                Dimens.d20.spaceHeight,
           /* const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Text(
                  //   "Premium",
                  //   style: Style.nunMedium(
                  //       fontSize: Dimens.d12, fontWeight: FontWeight.w400),
                  //   textAlign: TextAlign.center,
                  // ),
                  // Dimens.d10.spaceHeight,
                  // Text(
                  //   "Try it for free".tr,
                  //   style: Style.nunMedium(
                  //       fontSize: Dimens.d12, fontWeight: FontWeight.w400),
                  //   textAlign: TextAlign.center,
                  // ),
                  //Dimens.d10.spaceHeight,
                  // Text(
                  //   "Unlock your full potential with TransformYourMind!".tr,
                  //   style: Style.nunMedium(
                  //       fontSize: Dimens.d15, fontWeight: FontWeight.w700),
                  //   textAlign: TextAlign.center,
                  // ),
                  // Dimens.d10.spaceHeight,
                  // Text(
                  //   "Unlock all features - from powerful ones Affirmations and deep meditations to transforming self-hypnosis audios, yours personal well-being barometer and Mindfulness training.".tr,
                  //   style: Style.nunMedium(
                  //       fontSize: Dimens.d12, fontWeight: FontWeight.w400),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
            ),*/

                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 10),
                  child: GestureDetector(
                    onTap: (){
                      plans = [false,false,false];
                      plans[0] =true;
                      setState((){});
                      showBottomSheetFree(context: context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color:plans[0] == true
                            ? ColorConstant.color769AA3.withOpacity(0.10)
                            : themeController.isDarkMode.isTrue
                            ? ColorConstant.transparent
                            : Colors.transparent,
                        border: Border.all(
                          color: plans[0] == true
                              ? themeController.isDarkMode.isTrue
                              ? ColorConstant.colorE3E1E1.withOpacity(0.2)
                              : ColorConstant.colorE3E1E1
                              : themeController.isDarkMode.isTrue
                              ?Colors.transparent
                              : Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              plans[0]
                                  ? Container(
                                height: Dimens.d20,
                                width: Dimens.d20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  height: Dimens.d10,
                                  width: Dimens.d10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),

                              )
                                  : Container(
                                height: Dimens.d20,
                                width: Dimens.d20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),
                              ),
                              Dimens.d10.spaceWidth,
                              Text(
                                "Free".tr,
                                style: Style.montserratBold(fontSize: 14),
                              ),
                            ],
                          ),
                          Dimens.d5.spaceHeight,
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'With selected functions'.tr,
                                  style: Style.nunRegular(
                                    fontSize: 13,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.colorBFBFBF:ColorConstant.color797777,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5),
                  child: GestureDetector(
                    onTap: (){
                      plans = [false,false,false];
                      plans[1] =true;
                      setState((){});
                      showBottomSheetMonthly(context: context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color:     plans[1] == true
                      ? ColorConstant.color769AA3.withOpacity(0.10)
                          : themeController.isDarkMode.isTrue
                    ? ColorConstant.transparent
                        : Colors.transparent,
                      border: Border.all(
                        color: plans[1] == true
                            ? themeController.isDarkMode.isTrue
                            ? ColorConstant.colorE3E1E1.withOpacity(0.2)
                            : ColorConstant.colorE3E1E1
                            : themeController.isDarkMode.isTrue
                            ?Colors.transparent
                            : Colors.transparent,
                        width: 1,
                      ),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              plans[1]
                                  ? Container(
                                height: Dimens.d20,
                                width: Dimens.d20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  height: Dimens.d10,
                                  width: Dimens.d10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),

                              )
                                  : Container(
                                height: Dimens.d24,
                                width: Dimens.d24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),
                              ),
                              Dimens.d10.spaceWidth,
                              Text(
                                "Premium / Monthly - 7 days free".tr,
                                style: Style.montserratBold(fontSize: 14),
                              ),
                            ],
                          ),
                          Dimens.d5.spaceHeight,
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '7 days free, then CHF 5.90 / month'.tr,
                                  style: Style.nunRegular(
                                    fontSize: 13,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.colorBFBFBF:ColorConstant.color797777,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: GestureDetector(

                    onTap: (){
                      plans = [false,false,false];
                      plans[2] =true;
                      setState((){});
                      showBottomSheetYearly(context: context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color:plans[2] == true
                            ? ColorConstant.color769AA3.withOpacity(0.10)
                            : themeController.isDarkMode.isTrue
                            ? ColorConstant.transparent
                            : Colors.transparent,
                        border: Border.all(
                          color: plans[2] == true
                              ? themeController.isDarkMode.isTrue
                              ? ColorConstant.colorE3E1E1.withOpacity(0.2)
                              : ColorConstant.colorE3E1E1
                              : themeController.isDarkMode.isTrue
                              ?Colors.transparent
                              : Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              plans[2]
                                  ? Container(
                                height: Dimens.d20,
                                width: Dimens.d20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  height: Dimens.d10,
                                  width: Dimens.d10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),

                              )
                                  : Container(
                                height: Dimens.d24,
                                width: Dimens.d24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.white
                                        : ColorConstant.black,
                                  ),
                                ),
                              ),
                              Dimens.d10.spaceWidth,
                              Text(
                                "Premium Plus / Annually".tr,
                                style: Style.montserratBold(fontSize: 14),
                              ),
                            ],
                          ),
                          Dimens.d5.spaceHeight,
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CHF 59.90 / year'.tr,
                                  style: Style.nunRegular(
                                    fontSize: 13,
                                    color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.colorBFBFBF:ColorConstant.color797777,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               /* const _DescriptionPoints(
                  title: "journalInput",
                ),
                const _DescriptionPoints(
                  title: "transOrSleep",
                ),
                const _DescriptionPoints(
                  title: "dailyProvide",
                ),
                const _DescriptionPoints(
                  title: "focusedAffirmations",
                ),
                const _DescriptionPoints(
                  title: "dailyProvideReminder",
                ),*/
                Dimens.d30.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: CommonElevatedButton(
                    textStyle: Style.nunRegular(
                        fontSize: 17, color: ColorConstant.white),
                    title: "Start your feel-good week".tr,
                    onTap: () async {
                      await PrefService.setValue(PrefKey.premium, true);
                      await PrefService.setValue(PrefKey.subscription, true);
                      await PrefService.setValue(
                          PrefKey.firstTimeRegister, true);
                      await PrefService.setValue(PrefKey.addGratitude, true);
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) {
                      //     return const WelcomeHomeScreen();
                      //   },
                      // ));



                      if (getUserModel.data
                          ?.morningMoodQuestions ??
                          false == false &&
                              greeting == "goodMorning") {
                        Get.offAll(() =>  SleepQuestions());
                      }
                      else if (getUserModel.data
                          ?.morningSleepQuestions ??
                          false == false &&
                              greeting == "goodMorning") {
                        Get.offAll(() => StressQuestions());
                      } else if (getUserModel.data
                          ?.morningStressQuestions ??
                          false == false &&
                              greeting == "goodMorning") {
                        Get.offAll(() => const HowFeelingTodayScreen());
                      } else if (getUserModel.data
                          ?.morningMotivationQuestions ??
                          false == false &&
                              greeting == "goodMorning") {
                        Get.offAll(() => MotivationalQuestions());
                      } else if (getUserModel.data
                          ?.eveningMoodQuestions ??
                          false == false &&
                              greeting == "goodEvening") {
                        Get.offAll(() => const HowFeelingsEvening());
                      } else if (getUserModel.data
                          ?.eveningStressQuestions ??
                          false == false &&
                              greeting == "goodEvening") {
                        Get.offAll(() => EveningStress());
                      } else if (getUserModel.data
                          ?.eveningMotivationQuestions ??
                          false == false &&
                              greeting == "goodEvening") {
                        Get.offAll(() => EveningMotivational());
                      } else {


                        Get.offAll(() => const DashBoardScreen());
                        /*if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
                                    {
                                      Get.offAll(() =>  SubscriptionScreen(skip: true,));

                                    }
                                    else
                                    {

                                      Get.offAll(() => const DashBoardScreen());
                                    }*/
                      }


                    },
                  ),
                ),
                Dimens.d10.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageConstant.alert,height: 20,width: 20),
                      const SizedBox(width: 5,),
                      Text(
                        "Backed by the App Store. Can be canceled at any time.".tr,
                        style: Style.nunMedium(
                            fontSize: Dimens.d12, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Dimens.d10.spaceHeight,

              ],
            ),
          ),
          // const SizedBox(
          //   height: Dimens.d100,
          //   child: CustomAppBar(title: ''),
          // )
        ],
      ),
    );
  }

  GetUserModel getUserModel = GetUserModel();
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
  getUSer(BuildContext context, greeting) async {
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

        if(getUserModel.data!.language !=null) {
          await PrefService.setValue(PrefKey.language,
              getUserModel.data!.language == "english" ? "en-US" : "de-DE");
        }


        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");
        await PrefService.setValue(
            PrefKey.isFreeUser, getUserModel.data?.isFreeVersion ?? false);
        await PrefService.setValue(
            PrefKey.isSubscribed, getUserModel.data?.isSubscribed ?? false);
        await PrefService.setValue(
            PrefKey.subId, getUserModel.data?.subscriptionId ?? '');
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {

      debugPrint(e.toString());
    }

  }

  showBottomSheetFree({required BuildContext context}){
    showModalBottomSheet(context: context,
        backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
    topLeft: Radius.circular(30.0),
    ),
    ),
        builder: (context){
      return SizedBox(
        height: Get.height *0.8,
        child:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: ColorConstant.black.withOpacity(0.15)),
                      child: const Icon(Icons.close, color: Colors.black),
                    ),),
              ),
              Dimens.d6.spaceHeight,

             SizedBox(
               height: Get.height *0.4,
               child: SingleChildScrollView(
                 child: Column(
                   children: [
                     Text(
                       "TransformYourMind - Free Version".tr,
                       style: Style.nunMedium(
                           fontSize: Dimens.d16, fontWeight: FontWeight.w700,color: Colors.black
                       ),
                       textAlign: TextAlign.center,
                     ),
                     Dimens.d20.spaceHeight,
                     Text(
                       "The free version of TransformYourMind is the perfect introduction to fostering meaningful change in your life.".tr,
                       style: Style.nunMedium(
                           fontSize: Dimens.d14, fontWeight: FontWeight.w400,color: Colors.black
                       ),
                       textAlign: TextAlign.center,
                     ),
                     Dimens.d10.spaceHeight,
                 
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20),
                       child: Text.rich(
                           TextSpan(children: [
                             TextSpan(text:  "Guided Meditations:".tr,
                               style: Style.nunMedium(
                                   fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                               ),),
                             const TextSpan(text: " "),
                             TextSpan(text:  "Experience calming, supportive meditations designed to reduce stress and promote inner peace, helping you take the first step toward a more balanced and harmonious mind.".tr,
                               style: Style.nunRegular(
                                   fontSize: Dimens.d14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.black
                 
                 
                 
                               ),),
                           ])),
                     ),
                     Dimens.d10.spaceHeight,
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20),
                       child: Text.rich(TextSpan(
                           children: [
                             TextSpan(text:  "Daily Affirmations:".tr,
                               style: Style.nunMedium(
                                   fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                               ),),
                             const TextSpan(text: " "),
                             TextSpan(text:  "Start each day with a curated selection of powerful affirmations to cultivate a positive mindset and set the tone for success.".tr,
                               style: Style.nunRegular(
                                   fontSize: Dimens.d14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.black
                 
                 
                               ),),
                 
                           ]
                       ),),
                     )
                   ],
                 ),
               ),
             ),


            ],
          ),
        ),
      );
    });
  }
  showBottomSheetMonthly({required BuildContext context}){
    showModalBottomSheet(context: context,
        backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
    topLeft: Radius.circular(30.0),
    ),
    ),
        builder: (context){
      return SizedBox(
        height: Get.height *0.8,
        child:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: ColorConstant.black.withOpacity(0.15)),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),),
              ),
              Dimens.d6.spaceHeight,

              SizedBox(
                height: Get.height *0.4,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "TransformYourMind - Monthly Premium Version".tr,
                        style: Style.nunMedium(
                            fontSize: Dimens.d16, fontWeight: FontWeight.w700,color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Dimens.d20.spaceHeight,
                      Text(
                        "Experience the full benefits of TransformYourMind with the Premium Version, available for just 5.90 CHF per month. Start with a 7-day free trial and discover how our advanced tools can transform your mental well-being. Designed to support long-term growth, the Premium plan helps you cultivate mindfulness, positivity, and emotional resilience.".tr,
                        style: Style.nunMedium(
                            fontSize: Dimens.d14, fontWeight: FontWeight.w400,color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Dimens.d10.spaceHeight,
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(
                            TextSpan(children: [
                              TextSpan(text: "Gratitude Journal:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "Key features include the Gratitude Journal, which allows you to document daily reflections, and Extended Daily Affirmations, giving you access to a vast library or the option to create your own. The Customizable Affirmations Alarm Clock helps you start each day with positive, personalized affirmations.".tr,
                                style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),
                            ])),
                      ),
                      Dimens.d10.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(TextSpan(
                            children: [
                              TextSpan(text:  "Mindfulness Training:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "Additionally, Mindfulness Training enables you to capture and replay positive moments, while Daily Psychological Questions promote self-awareness by tracking your emotional patterns and progress through visual charts. Together, these tools empower you to lead a more mindful, balanced, and fulfilling life.".tr,
                                style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),
                  
                            ]
                        ),),
                      )
                  
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
  showBottomSheetYearly({required BuildContext context}){
    showModalBottomSheet(context: context,
        backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
    topLeft: Radius.circular(30.0),
    ),
    ),
        builder: (context){
      return SizedBox(
        height: Get.height *0.8,
        child:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: ColorConstant.black.withOpacity(0.15)),
                      child: const Icon(Icons.close, color: Colors.black),
                    ),),
              ),
              Dimens.d6.spaceHeight,

              SizedBox(
                height: Get.height *0.4,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "TransformYourMind - Annually Premium Version".tr,
                        style: Style.nunMedium(
                            fontSize: Dimens.d16, fontWeight: FontWeight.w700,color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Dimens.d20.spaceHeight,
                      Text(
                        "For just 59.90 CHF per year, the Premium Version offers a wealth of advanced features designed to elevate your mental well-being. Start with a 7-day free trial to explore how TransformYourMind can enrich your life.".tr,
                        style: Style.nunMedium(
                            fontSize: Dimens.d14, fontWeight: FontWeight.w400,color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Dimens.d10.spaceHeight,
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(
                            TextSpan(children: [
                              TextSpan(text:  "Extended Daily Affirmations:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "Features include the Gratitude Journal to track daily reflections and Extended Daily Affirmations, providing a wide library or the option to create personalized affirmations. The Customizable Affirmations Alarm Clock sets a positive tone for your day with tailored messages.".tr,
                                style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),
                            ])),
                      ),
                      Dimens.d10.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(TextSpan(
                            children: [
                              TextSpan(text:  "Self-Hypnosis Audios:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "A standout feature is the regularly updated Self-Hypnosis Audios, designed to target specific areas of personal growth. Whether you want to overcome anxiety, boost self-confidence, or conquer fears like flying, these audios use the power of self-hypnosis to help you make profound mental shifts. ".tr,
                                style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),
                  
                            ]
                        ),),
                      )
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      );
    });
  }
}


class _DescriptionPoints extends StatelessWidget {
  final String title;

  const _DescriptionPoints({required this.title});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.d40, vertical: Dimens.d10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(margin: const EdgeInsets.only(top: 7),
            height: 8,
            width: 8,
            decoration:  BoxDecoration(
                color: themeController.isDarkMode.isTrue?Colors.white:ColorConstant.black, shape: BoxShape.circle),
          ),
          Dimens.d16.spaceWidth,
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title.tr,
                style: Style.nunMedium(
                  fontSize: Dimens.d16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
