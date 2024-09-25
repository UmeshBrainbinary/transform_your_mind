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


 Map yearlyText = {
    "para1(1)":"For just CHF 59.00 per year, the ",
    "para1(2)":"Premium Plus ",
    "para1(3)":"version gives you full access to all Premium content as well as ",
    "para1(4)":"exclusive access to self-hypnosis audios ",
    "para1(5)":"specifically designed to bring about profound transformations. ",

   "para2(1)":"These audios can help you ",
   "para2(2)":"overcome fears, boost your confidence ",
   "para2(3)":"or ",
   "para2(4)":"overcome challenges ",
   "para2(5)":"such as ",
   "para2(6)":"fear of flying ",
   "para2(7)":"by using the power of self-hypnosis to release old beliefs and promote positive mental change. ",
   "para2(8)":"With new topics added regularly, you will continually receive tools to support your personal growth and help you lead a more fulfilling and successful life.",
 };
  Map yearlyTextGerman = {
    "para1(1)":"Für nur 59.00 CHF pro Jahr erhältst du in der Premium Plus-Version den vollen Zugriff auf alle Premium-Inhalte sowie den ",
    "para1(2)":"exklusiven Zugang zu Selbsthypnose-Audios, ",
    "para1(3)":"vdie speziell darauf ausgelegt sind, tiefgreifende Transformationen zu bewirken. ",

    "para2(1)":"Diese Audios können dir helfen, Ängste zu überwinden, dein Selbstbewusstsein zu stärken oder Herausforderungen wie Flugangst zu meistern, indem sie die Kraft der Selbsthypnose nutzen, um alte Überzeugungen loszulassen und positive mentale Veränderungen zu fördern. Mit ",
    "para2(2)":"regelmäßig neuen Themen ",
    "para2(3)":"erhältst du kontinuierlich Tools, die dein persönliches Wachstum unterstützen und dir dabei helfen, ein erfüllteres und erfolgreicheres Leben zu führen.",
     };


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
                    Image.asset(ImageConstant.sub,),
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
          padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20),
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
               height: Get.height *0.45,
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
                       "“Change begins with a single conscious step.”".tr,
                       style: Style.nunMedium(
                           fontSize: Dimens.d14, fontWeight: FontWeight.w400,color: Colors.black
                       ),
                       textAlign: TextAlign.center,
                     ),
                     Dimens.d10.spaceHeight,
                     Text(
                       "The free version of TransformYourMind offers you the perfect introduction to making significant changes in your life. With a selection of powerful meditations and inspirational quotes to boost your daily motivation, you can begin to calm your mind and find your inner peace".tr,
                       style: Style.nunMedium(
                           fontSize: Dimens.d14, fontWeight: FontWeight.w400,color: Colors.black
                       ),
                       textAlign: TextAlign.center,
                     ),
                     Dimens.d20.spaceHeight,
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20),
                       child: Text.rich(
                           TextSpan(children: [
                             WidgetSpan(child: Padding(
                               padding: const EdgeInsets.only(bottom: 4.0),
                               child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                 shape:  BoxShape.circle,
                                 color: Colors.black
                               ),),
                             )),
                             const WidgetSpan(child: SizedBox(width: 6)),

                             TextSpan(text:  "Guided meditations:".tr,
                               style: Style.nunMedium(
                                   fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                               ),),
                             const TextSpan(text: " "),
                             TextSpan(text:  "Experience a selection of calming and supportive meditations to help you let go of stress and develop a sense of serenity and balance. “Give your mind the rest it deserves.”".tr,
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
                             WidgetSpan(child: Padding(
                               padding: const EdgeInsets.only(bottom: 4.0),
                               child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                   shape:  BoxShape.circle,
                                   color: Colors.black
                               ),),
                             )),
                             const WidgetSpan(child: SizedBox(width: 6)),
                             TextSpan(text:  "Motivational quotes:".tr,
                               style: Style.nunMedium(
                                   fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                               ),),
                             const TextSpan(text: " "),
                             TextSpan(text:  "Be guided daily by inspirational quotes that encourage you to think positively and start your day full of confidence. “Every day is a new chance to be the best you can be.”".tr,
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
          padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20),
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
                height: Get.height *0.45,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "TransformYourMind - Premium version monthly".tr,
                        style: Style.nunMedium(
                            fontSize: Dimens.d16, fontWeight: FontWeight.w700,color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Dimens.d20.spaceHeight,
                      Text.rich(
                          TextSpan(children: [
                            TextSpan(text:  "Experience the full power of TransformYourMind with the Premium version - for only 5.90 CHF per month.".tr,
                              style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                  color: Colors.black


                              ),),
                            const TextSpan(text: " "),
                            TextSpan(text: "Start with a 7-day free trial!".tr,
                              style: Style.nunMedium(
                                  fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                              ),),
                            const TextSpan(text: " "),
                            TextSpan(text:  "This premium version is your key to a mindful, balanced and emotionally empowered life. It's designed to support your long-term growth by helping you unleash your inner strength and realize your full potential.".tr,
                              style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                  color: Colors.black


                              ),),


                          ])),

                      Dimens.d10.spaceHeight,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                           Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                  shape:  BoxShape.circle,
                                  color: Colors.black
                              ),),
                            ),
                            const SizedBox(width: 6),
                            Text( "What to expect:".tr,
                              style: Style.nunMedium(
                                  fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                              ),),
                          ],
                        ),
                      ),
                      Dimens.d10.spaceHeight,

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(
                            TextSpan(children: [
                              WidgetSpan(child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                    shape:  BoxShape.circle,
                                    color: Colors.black
                                ),),
                              )),
                              const WidgetSpan(child: SizedBox(width: 6)),
                              TextSpan(text: "Gratitude journal:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "daily reflections that promote positivity and enrich your life.".tr,
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
                              WidgetSpan(child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                    shape:  BoxShape.circle,
                                    color: Colors.black
                                ),),
                              )),
                              const WidgetSpan(child: SizedBox(width: 6)),
                              TextSpan(text:  "Motivational quotes:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "Daily inspiration to pursue your goals with confidence.".tr,
                                style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),
                  
                            ]
                        ),),
                      ),


                      Dimens.d10.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(TextSpan(
                            children: [
                              WidgetSpan(child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                    shape:  BoxShape.circle,
                                    color: Colors.black
                                ),),
                              )),
                              const WidgetSpan(child: SizedBox(width: 6)),
                              TextSpan(text:  "Affirmations:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "A comprehensive library of powerful affirmations that transform your mindset.".tr,
                                style: Style.nunRegular(
                                    fontSize: Dimens.d14,
                                    fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),

                            ]
                        ),),
                      ),

                      Dimens.d10.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(TextSpan(
                            children: [
                              WidgetSpan(child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                    shape:  BoxShape.circle,
                                    color: Colors.black
                                ),),
                              )),
                              const WidgetSpan(child: SizedBox(width: 6)),
                              TextSpan(text:  "Alarm clock with meditation:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "Start the day with a peaceful meditation for more clarity and energy.".tr,
                                style: Style.nunRegular(
                                    fontSize: Dimens.d14,
                                    fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),

                            ]
                        ),),
                      ),

                      Dimens.d10.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(TextSpan(
                            children: [
                              WidgetSpan(child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                    shape:  BoxShape.circle,
                                    color: Colors.black
                                ),),
                              )),
                              const WidgetSpan(child: SizedBox(width: 6)),
                              TextSpan(text:  "Guided breathing technique:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "Reduce stress and find inner peace with targeted breathing exercises.".tr,
                                style: Style.nunRegular(
                                    fontSize: Dimens.d14,
                                    fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),

                            ]
                        ),),
                      ),

                      Dimens.d10.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(TextSpan(
                            children: [
                              WidgetSpan(child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                    shape:  BoxShape.circle,
                                    color: Colors.black
                                ),),
                              )),
                              const WidgetSpan(child: SizedBox(width: 6)),
                              TextSpan(text:  "Mindfulness training:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "anchor positive moments and strengthen your awareness.".tr,
                                style: Style.nunRegular(
                                    fontSize: Dimens.d14,
                                    fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),

                            ]
                        ),),
                      ),

                      Dimens.d10.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(TextSpan(
                            children: [
                              WidgetSpan(child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Container(height: 6,width: 6,decoration: const BoxDecoration(
                                    shape:  BoxShape.circle,
                                    color: Colors.black
                                ),),
                              )),
                              const WidgetSpan(child: SizedBox(width: 6)),
                              TextSpan(text:  "Daily psychological questions:".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),
                              const TextSpan(text: " "),
                              TextSpan(text:  "Recognize emotional patterns and promote your personal growth.".tr,
                                style: Style.nunRegular(
                                    fontSize: Dimens.d14,
                                    fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),

                            ]
                        ),),
                      ),
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
          padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20),
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
                height: Get.height *0.45,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "TransformYourMind - Premium Plus Version yearly".tr,
                        style: Style.nunMedium(
                            fontSize: Dimens.d16, fontWeight: FontWeight.w700,color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Dimens.d20.spaceHeight,



                      (PrefService.getString(PrefKey.language) =="de-DE")?
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text.rich(
                                TextSpan(children: [
                                  TextSpan(text:  "${yearlyTextGerman["para1(1)"]}".tr,
                                    style: Style.nunRegular(
                                        fontSize: Dimens.d14,
                                        fontWeight: FontWeight.w400,

                                        color: Colors.black


                                    ),),
                                  TextSpan(text:  "${yearlyTextGerman["para1(2)"]}".tr,
                                    style: Style.nunMedium(
                                        fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                    ),),

                                  TextSpan(text:  "${yearlyTextGerman["para1(3)"]}".tr,
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
                            child: Text.rich(  TextSpan(children: [
                              TextSpan(text:  "${yearlyTextGerman["para2(1)"]}".tr,
                                style: Style.nunRegular(
                                    fontSize: Dimens.d14,
                                    fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),
                              TextSpan(text:  "${yearlyTextGerman["para2(2)"]}".tr,
                                style: Style.nunMedium(
                                    fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                ),),

                              TextSpan(text:  "${yearlyTextGerman["para2(3)"]}".tr,
                                style: Style.nunRegular(
                                    fontSize: Dimens.d14,
                                    fontWeight: FontWeight.w400,

                                    color: Colors.black


                                ),),

                            ])),
                          )
                        ],
                      )
                          :Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text.rich(
                              TextSpan(children: [
                                TextSpan(text:  "${yearlyText["para1(1)"]}".tr,
                                  style: Style.nunRegular(
                                      fontSize: Dimens.d14,
                                      fontWeight: FontWeight.w400,

                                      color: Colors.black


                                  ),),
                                TextSpan(text:  "${yearlyText["para1(2)"]}".tr,
                                  style: Style.nunMedium(
                                      fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                  ),),

                                TextSpan(text:  "${yearlyText["para1(3)"]}".tr,
                                  style: Style.nunRegular(
                                      fontSize: Dimens.d14,
                                      fontWeight: FontWeight.w400,

                                      color: Colors.black


                                  ),),

                                TextSpan(text:  "${yearlyText["para1(4)"]}".tr,
                                  style: Style.nunMedium(
                                      fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                                  ),),

                                TextSpan(text:  "${yearlyText["para1(5)"]}".tr,
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
                          child: Text.rich(  TextSpan(children: [
                            TextSpan(text:  "${yearlyText["para2(1)"]}".tr,
                              style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                  color: Colors.black


                              ),),
                            TextSpan(text:  "${yearlyText["para2(2)"]}".tr,
                              style: Style.nunMedium(
                                  fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                              ),),

                            TextSpan(text:  "${yearlyText["para2(3)"]}".tr,
                              style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                  color: Colors.black


                              ),),

                            TextSpan(text:  "${yearlyText["para2(4)"]}".tr,
                              style: Style.nunMedium(
                                  fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                              ),),

                            TextSpan(text:  "${yearlyText["para2(5)"]}".tr,
                              style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                  color: Colors.black


                              ),),
                            TextSpan(text:  "${yearlyText["para2(6)"]}".tr,
                              style: Style.nunMedium(
                                  fontSize: Dimens.d14, fontWeight: FontWeight.w700,color: Colors.black
                              ),),

                            TextSpan(text:  "${yearlyText["para2(7)"]}".tr,
                              style: Style.nunRegular(
                                  fontSize: Dimens.d14,
                                  fontWeight: FontWeight.w400,

                                  color: Colors.black


                              ),),
                          ])),
                        ),
                        Dimens.d10.spaceHeight,

                        Text(
                          "With new topics added regularly, you will continually receive tools to support your personal growth and help you lead a more fulfilling and successful life.".tr,
                          style: Style.nunRegular(
                              fontSize: Dimens.d14,
                              fontWeight: FontWeight.w400,

                              color: Colors.black


                          ),),
                      ],
                    ),
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
