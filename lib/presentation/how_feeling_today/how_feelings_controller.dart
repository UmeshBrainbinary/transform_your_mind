import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_api/common_api.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_today_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/motivational_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/stress_questions.dart';

import '../../core/utils/end_points.dart';
import '../dash_board_screen/dash_board_screen.dart';

class HowFeelingsController extends GetxController{
  //_________________________________ mood questions _______________________
    TextEditingController whatPositive = TextEditingController();
    TextEditingController whatAreYouLooking = TextEditingController();
    TextEditingController whatSmallSteps = TextEditingController();
    //_________________________________ stress questions _______________________
    TextEditingController whatRelaxation  = TextEditingController();
    TextEditingController howCanYouYourSelf  = TextEditingController();
    TextEditingController whatPositiveThought  = TextEditingController();
    //_________________________________ sleep questions _______________________
    TextEditingController whatMeasures  = TextEditingController();
    TextEditingController whatHasHelped  = TextEditingController();
    TextEditingController whatParticularly  = TextEditingController();
    TextEditingController howWill  = TextEditingController();
    TextEditingController howCanEnsure  = TextEditingController();
    TextEditingController canYouDescribeHelp  = TextEditingController();


  FocusNode  whatIsYourMindFocus = FocusNode();
  int howDoYouIndex = -1;
  int howDoYouSleepWell = -1;
  int howDidYouLong = -1;
  int whatDoYouWantToAchieve = -1;
  int howDoYouIndexSleep = -1;
  int whatHelped = -1;
  int whatHelpedCan = -1;
  int whatStep = -1;
  int whatHelpedStress = -1;

  ///---1 ---
  int whatCausing = -1;
    ///---2 ---
    int houwCouldBool = -1;
    ///---1 ---  /// motivation
    int howMotivateBool = -1;
    ///---2 ---
    int whatInspireBool = -1;
    ///---3 ---
    int whichChallengeBool = -1;


  int feelPhysically = -1;
  int selectedIndex = -1;
  String? selectedOption = '';
  String? selectedOptionStress = '';
  String? selectedDidYouSleepWell = 'Yes';
  String? selectedOptionForSleep = '';
  //
  // RxList howDoYouFeelList = [
  //   {"title":"A. ${"Good".tr}","check":false},
  //   {"title":"B. ${"Neutral".tr}","check":false},
  //   {"title":"C. ${"Bad".tr}","check":false},
  // ].obs;
    RxList howDoYouFeelList = [
      {"title":"I’m feeling great!".tr,"check":false},
      {"title":"I feel good.".tr,"check":false},
      {"title":"I’m okay.".tr,"check":false},
      {"title":"I’m a bit tired.".tr,"check":false},
      {"title":"I’m staying calm and focused.".tr,"check":false},
  ].obs;
  RxList didYouSleepWell = [
    {"title": "A quiet environment".tr, "check": false},
    {"title": "A relaxing evening routine".tr, "check": false},
    {"title": "A comfortable bed".tr, "check": false},
    {
      "title": "Sufficient physical activity during the day".tr,
      "check": false
    },
    {"title": "Something else".tr, "check": false},
  ].obs;

  RxList howLongDidYouSleep = [
      {"title": "Less than 5 hours".tr, "check": false},
      {"title": "5-6 hours".tr, "check": false},
      {"title": "6-7 hours".tr, "check": false},
      {
        "title": "7-8 hours".tr,
        "check": false
      },
      {"title": "More than 8 hours".tr, "check": false},
    ].obs;

  // RxList whatHelpedYou = [
  //   {"title": "A. ${"GoodNews".tr}", "check": false},
  //   {"title": "B. ${"RestfulSleep".tr}", "check": false},
  //   {"title": "C. ${"PositiveThoughts".tr}", "check": false},
  //   {"title":"D. ${"Other".tr}","check":false},
  // ].obs;
    RxList whatHelpedYou = [
      {"title":"A restful sleep".tr,"check":false},
      {"title":"A relaxing morning routine".tr,"check":false},
      {"title":"Time for a healthy breakfast".tr,"check":false},
      {"title":"Positive thoughts".tr,"check":false},
      {"title":"Something else".tr,"check":false},
    ].obs;


    RxList whatCanYouToday = [
    {"title":"planPositiveActivities".tr,"check":false},
    {"title":"TakeBreaks".tr,"check":false},
    {"title":"TalkSomeone".tr,"check":false},
    {"title":"Other".tr,"check":false},
  ].obs;

  RxList whatCanDoMinimize = [
    {"title":"ListenAudio".tr,"check":false},
    {"title":"BreathingTechnique".tr,"check":false},
    {"title":"SpendOutdoors".tr,"check":false},
    {"title":"TalkFrd".tr,"check":false},
    {"title":"Other".tr,"check":false},
  ].obs;
/// ---- 1-----
    RxList whatIsCausing = [
      {"title":"An upcoming task or deadline".tr,"check":false},
      {"title":"Personal obligations".tr,"check":false},
      {"title":"Health concerns".tr,"check":false},
      {"title":"General tension or nervousness".tr,"check":false},
      {"title":"Something else".tr,"check":false},
    ].obs;


    /// ---- 2-----
    RxList howCould = [
      {"title":"Through breathing exercises or audios".tr,"check":false},
      {"title":"By taking a short break".tr,"check":false},
      {"title":"Through movement or a walk".tr,"check":false},
      {"title":"By setting priorities and planning the day".tr,"check":false},
      {"title":"By talking to someone I trust".tr,"check":false},
    ].obs;

    /// ---- 3-----
    RxList howMotivated = [
      {"title":"I can’t wait to get started!".tr,"check":false},
      {"title":"I feel full of energy and drive.".tr,"check":false},
      {"title":"I’m ready to start the day.".tr,"check":false},
      {"title":"I’m taking my time to get going.".tr,"check":false},
      {"title":"I’m starting off a bit slower today.".tr,"check":false},
    ].obs;
    /// ---- 4-----
    RxList whatInspire = [
      {"title":"Maximizing my full potential".tr,"check":false},
      {"title":"The desire to achieve my goals".tr,"check":false},
      {"title":"The pursuit of personal satisfaction".tr,"check":false},
      {"title":"The goal of being better than yesterday".tr,"check":false},
      {"title":"Something else".tr,"check":false},
    ].obs;

    /// ---- 5 -----
    RxList whichChallenge = [
      {"title":"An exciting task at work or school".tr,"check":false},
      {"title":"Learning or trying something new".tr,"check":false},
      {"title":"Staying calm and relaxed throughout the day".tr,"check":false},
      {"title":"Taking a step towards an important goal".tr,"check":false},
      {"title":"Overcoming a personal boundary".tr,"check":false},
    ].obs;



  RxList whatHelpsYouStart = [
    {"title":"StructuredPlan".tr,"check":false},
    {"title":"relaxationTechniques".tr,"check":false},
    {"title":"positiveMindset".tr,"check":false},
    {"title":"Other".tr,"check":false},
  ].obs;

 RxList feelPhysicallyList = [
    {"title":"Work".tr,"check":false},
    {"title":"Family".tr,"check":false},
    {"title":"Relationship".tr,"check":false},
    {"title":"Health".tr,"check":false},
    {"title":"Finances".tr,"check":false},
    {"title":"Other".tr,"check":false},
  ].obs;

  RxList whatDoYouWant = [
    {"title":"AGoal".tr,"check":false},
    {"title":"AWorkGoal".tr,"check":false},
    {"title":"LearnSkill".tr,"check":false},
    {"title":"other".tr,"check":false},
  ].obs;

  // RxList whatNegatively = [
  //   {"title":"A. ${"Worries".tr}","check":false},
  //   {"title":"B. ${"Noise".tr}","check":false},
  //   {"title":"C. ${"uncomfortableBed".tr}","check":false},
  //   {"title":"D. ${"Health".tr}","check":false},
  //   {"title":"E. ${"other".tr}","check":false},
  // ].obs;
    ///----1----
    RxList whatNegatively = [
      {"title":"Racing thoughts".tr,"check":false},
      {"title":"Noise or external disturbances".tr,"check":false},
      {"title":"Uncomfortable bed or sleeping position".tr,"check":false},
      {"title":"Health issues".tr,"check":false},
      {"title":"Something else".tr,"check":false},
    ].obs;
  RxList whatStepCanYou = [
    {"title":"planning".tr,"check":false},
    {"title":"seekingHelp".tr,"check":false},
    {"title":"timeManagement".tr,"check":false},
    {"title":"other".tr,"check":false},
  ].obs;

  setQuestions(setting, BuildContext context,) async {
    try {
      var moodData = {};
      if (setting == "mood") {
        moodData = {
          "type": "mood",
          "created_by": PrefService.getString(PrefKey.userId),
          "morningFeeling":     howDoYouIndex == 0
                        ? "good"
                         :howDoYouIndex == 1
                        ? "neutral"
                        : "bad",

             "youFeelingRight": howDoYouIndex == 0
              ? "I’m feeling great!"
              : howDoYouIndex == 1
                  ? "I feel good."
                  : howDoYouIndex == 2?
                  "I’m okay.":howDoYouIndex == 3?"I’m a bit tired.":
          howDoYouIndex == 4?"I’m staying calm and focused.":
          "bad",

          "morningHelp": whatHelped == -1
              ? null
              : whatHelped == 0
                  ? "goodNews"
                  : whatHelped == 1
                      ? "restfulSleep"
                      : whatHelped == 2
                          ? "positiveThoughts"
                          : "other",

          "helpedYouStart": whatHelped == -1
              ? null
              : whatHelped == 0
                  ? "A restful sleep"
                  : whatHelped == 1
                      ? "A relaxing morning routine"
                      : whatHelped == 2
                          ? "Time for a healthy breakfas"
                          : whatHelped == 3?"Positive thoughts":"others",
          "positiveFeeling": whatPositive.text.trim(),
          "morningGoal": whatAreYouLooking.text.trim(),
          "goodMood": whatSmallSteps.text.trim(),
          "improveMood": whatHelpedCan == -1
              ? null
              : whatHelpedCan == 0
                  ? "planPositiveActivities"
                  : whatHelpedCan == 1
                      ? "takeBreaks"
                      : whatHelpedCan == 2
                          ? "talkToSomeone"
                          : "other",
          "positiveActivity": whatPositive.text.trim(),
          "morningForward": whatAreYouLooking.text.trim(),
          "morningSteps": whatSmallSteps.text.trim()
        };
      } else if (setting == "sleep") {
        moodData = {
          "type": "sleep",
          "created_by": PrefService.getString(PrefKey.userId),
          "morningSleep": selectedDidYouSleepWell!.toLowerCase(),
          "helpesSleep": selectedOptionForSleep!.toLowerCase().isEmpty
              ? null
              : selectedOptionForSleep!.toLowerCase(),
          "decribehelp": canYouDescribeHelp.text.trim(),
          "negativelyAffected": howDoYouIndexSleep == -1
              ? null
              : howDoYouIndexSleep == 0
                  ? "Racing thoughts"
                  : howDoYouIndexSleep == 1
                      ? "Noise or external disturbances"
                      : howDoYouIndexSleep == 2
                          ? "Uncomfortable bed or sleeping position"
                          : howDoYouIndexSleep == 3
                              ? "Health issues"
                              : "Something else",
          "improveSleep": whatMeasures.text.trim(),
          "helpedSleep": howDoYouSleepWell == 1
              ? "A quiet environment"
              : howDoYouSleepWell == 2
                  ? "A relaxing evening routine"
                  : howDoYouSleepWell == 3
                      ? "A comfortable bed"
                      : howDoYouSleepWell == 4
                          ? "Sufficient physical activity during the day"
                          : "Something else",
          "longSleep": howDidYouLong == 1
              ? "Less than 5 hours"
              : howDidYouLong == 2
                  ? "5-6 hours"
                  : howDidYouLong == 3
                      ? "6-7 hours"
                      : howDidYouLong == 4
                          ? "6-7 hours"
                          : "More than 8 hours",
        };
      }
      else if (setting == "stress") {
        moodData = {
          "type": "stress",
          "feelingStressed"
          :selectedOptionStress!.toLowerCase(),
          "created_by": PrefService.getString(PrefKey.userId),
          "morningStress": selectedOptionStress!.toLowerCase(),
          "minimizeStress": selectedOptionStress == "Yes"
              ? whatHelpedStress == -1
              ? null
              : whatHelpedStress == 0
              ? "ListenAudio"
              : whatHelpedStress == 1
              ? "BreathingTechnique"
              : whatHelpedStress == 2
              ? "SpendOutdoors"
              : whatHelpedStress == 3
              ? "TalkFrd"
              : "Other"
              : whatHelpedStress == -1
              ? null
              : null,
          "causingYourStress":
          whatCausing == -1
                  ? null
                  : whatCausing == 0
                      ? "An upcoming task or deadline"
                      : whatCausing == 1
                          ? "Personal obligations"
                          : whatCausing == 2
                              ? "Health concerns"
                              : whatCausing == 3
                                  ? "General tension or nervousness"
                                  : "Something else",

                    "relieveThisStress":houwCouldBool == -1
    ? null
        : houwCouldBool == 0
    ? "Through breathing exercises or audios"
        : houwCouldBool == 1
    ? "By taking a short break"
        : houwCouldBool == 2
    ? "Through movement or a walk"
        : houwCouldBool == 3
    ? "By setting priorities and planning the day"
        : "By talking to someone I trust",
          "relaxaionTechniques": whatRelaxation.text.trim(),
          "treatYourself": howCanYouYourSelf.text.trim(),
          "positiveThoughts": whatPositiveThought.text.trim(),
          "stressFree": selectedOptionStress == "No"
              ? whatHelpedStress == -1
                  ? null
                  : whatHelpedStress == 0
                      ? "structuredPlan"
                      : whatHelpedStress == 1
                          ? "relaxationTechniques"
                          : whatHelpedStress == 2
                              ? "positiveMindset"
                              : "other"
              : whatHelpedStress == -1
                  ? null
                  : null,
          "morningHabit": whatRelaxation.text.trim(),
          "stayStressFree": howCanYouYourSelf.text.trim()
        };
      }
      else {
        moodData = {
          "type": "motivation",
          "created_by": PrefService.getString(PrefKey.userId),
          "achieveToday": whatDoYouWantToAchieve == -1
              ? null
              : whatDoYouWantToAchieve == 0
                  ? "aPersonalGoal"
                  : whatDoYouWantToAchieve == 1
                      ? "aWorkGoal"
                      : whatDoYouWantToAchieve == 2
                          ? "learnaNewSkill"
                          : "other",
          "stepsAchieve": whatStep == -1
              ? null
              : whatStep == 0
                  ? "planning"
                  : whatStep == 1
                      ? "seekingHelp"
                      : whatStep == 2
                          ? "timeManagement"
                          : "other",



          "motivatedAreYou":howMotivateBool ==-1?null:
    howMotivateBool ==0?"I can’t wait to get started!": howMotivateBool ==1?"I feel full of energy and drive."
    : howMotivateBool ==2?"I’m ready to start the day."  : howMotivateBool ==3?"I’m taking my time to get going."
        : howMotivateBool ==4?"I’m starting off a bit slower today":"others",

          "inspiresYoutoGive":whatInspireBool ==-1?null:
    whatInspireBool ==0?"Maximizing my full potential": whatInspireBool ==1?"The desire to achieve my goals"
        : whatInspireBool ==2?"The pursuit of personal satisfaction"  : whatInspireBool ==3?"The goal of being better than yesterda"
        : whatInspireBool ==4?" Something else":"others",

          "challengeDoYou":whichChallengeBool ==-1?null:
    whichChallengeBool ==0?"An exciting task at work or school": whichChallengeBool ==1?"Learning or trying something new"
        : whichChallengeBool ==2?"Staying calm and relaxed throughout the day"  : whichChallengeBool ==3?"Taking a step towards an important goal"
        : whichChallengeBool ==4?" Overcoming a personal boundary":"others",
          "particularlyMotivates": whatParticularly.text.trim(),
          "rewardYourself": howWill.text.trim(),
          "ensureStay": howCanEnsure.text.trim()
        };
      }
print(moodData);

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.Request(
            'POST', Uri.parse(EndPoints.morningQuestions));
        request.body = json.encode(moodData);
        request.headers.addAll(headers);


        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
//           if (setting == "mood") {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//
//             Get.to(() => StressQuestions());
//           } else if (setting == "stress") {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//
//             Get.to(() => SleepQuestions());
//           } else if (setting == "sleep") {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//
//             Get.to(() => MotivationalQuestions());
//           } else {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//             Get.offAll(() => const DashBoardScreen());
//
//
// /*
//             if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
//             {
//               Get.offAll(() =>  SubscriptionScreen(skip: false,));
//
//             }
//             else
//             {
//
//               Get.offAll(() => const DashBoardScreen());
//             }*/
//           }


          if (setting == "sleep") {
            updateApi(context,pKey: "eveningMotivationQuestions");

            Get.to(() => const HowFeelingTodayScreen());
          } else if (setting == "mood") {
            updateApi(context,pKey: "eveningMotivationQuestions");

            Get.to(() => StressQuestions());
          } else if (setting == "stress") {
            updateApi(context,pKey: "eveningMotivationQuestions");

            Get.to(() => MotivationalQuestions());
          } else {
            updateApi(context,pKey: "eveningMotivationQuestions");
            Get.offAll(() => const DashBoardScreen());


/*
            if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
            {
              Get.offAll(() =>  SubscriptionScreen(skip: false,));

            }
            else
            {

              Get.offAll(() => const DashBoardScreen());
            }*/
          }
        }
        else {
          debugPrint(response.reasonPhrase);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  setQuestionsSkip( BuildContext context,) async {
    try {
      var moodData = {};

        moodData = {
          "created_by": PrefService.getString(PrefKey.userId),
        };

print(moodData);

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.Request(
            'POST', Uri.parse(EndPoints.morningQuestions));
        request.body = json.encode(moodData);
        request.headers.addAll(headers);


        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
//           if (setting == "mood") {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//
//             Get.to(() => StressQuestions());
//           } else if (setting == "stress") {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//
//             Get.to(() => SleepQuestions());
//           } else if (setting == "sleep") {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//
//             Get.to(() => MotivationalQuestions());
//           } else {
//             updateApi(context,pKey: "eveningMotivationQuestions");
//             Get.offAll(() => const DashBoardScreen());
//
//
// /*
//             if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
//             {
//               Get.offAll(() =>  SubscriptionScreen(skip: false,));
//
//             }
//             else
//             {
//
//               Get.offAll(() => const DashBoardScreen());
//             }*/
//           }



            updateApi(context,pKey: "eveningMotivationQuestions");
            Get.offAll(() => const DashBoardScreen());


/*
            if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
            {
              Get.offAll(() =>  SubscriptionScreen(skip: false,));

            }
            else
            {

              Get.offAll(() => const DashBoardScreen());
            }*/

        }
        else {
          debugPrint(response.reasonPhrase);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
}