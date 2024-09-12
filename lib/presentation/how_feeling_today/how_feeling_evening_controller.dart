import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_api/common_api.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_motivational.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_stress.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';

class HowFeelingEveningController extends GetxController {
  TextEditingController whatCanYouDo = TextEditingController();
  TextEditingController sleep = TextEditingController();
  TextEditingController isThereSomethingThat = TextEditingController();
  TextEditingController whatCouldHelpMaintain = TextEditingController();
  TextEditingController canYouDescribe = TextEditingController();
  TextEditingController howDidYouReactToIt = TextEditingController();
  TextEditingController whatCouldHelp = TextEditingController();
  TextEditingController whatParticularly = TextEditingController();
  TextEditingController howWill = TextEditingController();
  TextEditingController canYouDescribeHelp = TextEditingController();
  TextEditingController whatMeasures = TextEditingController();
  TextEditingController whatHasHelped = TextEditingController();
  TextEditingController canYouDescribeHow = TextEditingController();
  TextEditingController whatHelpedStay = TextEditingController();
  TextEditingController whatHelpedManage = TextEditingController();
  TextEditingController areThere = TextEditingController();

  FocusNode whatIsYourMindFocus = FocusNode();
  int howDoYouIndex = -1;
  int howDoYouIndexPositive = -1;

  int howDoYouIndexSleep = -1;

  int whatHelped = -1;

  ///---2 --
  int maintainBool = -1;
  int inspiredBool = -1;
  int concureBool = -1;

  int whatHelpedStress = -1;
  int whatHelpedStressAchieve = -1;
  int whatCausedYourStress = -1;

  ///---3
  int successBool = -1;

  int whatHelpedStressEvening = -1;
  int feelPhysically = -1;
  int selectedIndex = -1;
  String? selectedOption = '';
  String? selectedOptionStress = '';
  String? selectedOptionStressAchieve = '';
  String? selectedOptionStressEvening = '';
  String? selectedDidYouSleepWell = '';
  String? selectedOptionForSleep = '';

  // RxList howDoYouFeelList = [
  //   {"title":"A. ${"Good".tr}","check":false},
  //   {"title":"B. ${"Neutral".tr}","check":false},
  //   {"title":"C. ${"Bad".tr}","check":false},
  // ].obs;

  RxList howDoYouFeelList = [
    {"title": "A. ${"It was a great day!".tr}", "check": false},
    {"title": "B. ${"I felt good most of the time.".tr}", "check": false},
    {"title": "C. ${"My mood was up and down.".tr}", "check": false},
    {
      "title": "D. ${"I was a bit tired, but I pushed through.".tr}",
      "check": false
    },
    {
      "title": "E. ${"I stayed calm and focused throughout the day.".tr}",
      "check": false
    },
  ].obs;
  RxList whatHelpedPositive = [
    {"title": "A. ${"A restful moment or break".tr}", "check": false},
    {"title": "B. ${"A soothing activity or routine".tr}", "check": false},
    {"title": "C. ${"A healthy meal during the day".tr}", "check": false},
    {
      "title": "D. ${"Positive thoughts and self-motivation".tr}",
      "check": false
    },
    {"title": "E. ${"Something else that helped me".tr}", "check": false},
  ].obs;
  RxList whatHelpedYou = [
    {"title": "A. ${"Planning".tr}", "check": false},
    {"title": "B. ${"support".tr}", "check": false},
    {"title": "C. ${"Motivation".tr}", "check": false},
    {"title": "D. ${"Other".tr}", "check": false},
  ].obs;

  RxList maintain = [
    {"title": "A. ${"I fully utilized my motivation.".tr}", "check": false},
    {
      "title": "B. ${"I was motivated, but there were ups and downs.".tr}",
      "check": false
    },
    {
      "title": "C. ${"It was challenging, but I kept going.".tr}",
      "check": false
    },
    {
      "title": "D. ${"I stayed motivated, even though it wasn't easy.".tr}",
      "check": false
    },
    {
      "title": "E. ${"It was a calm day, but I gave it my best.".tr}",
      "check": false
    },
  ].obs;

  RxList inspired = [
    {"title": "A. ${"I maximized my full potential.".tr}", "check": false},
    {"title": "B. ${"I sought personal satisfaction.".tr}", "check": false},
    {"title": "C. ${"I created something positive.".tr}", "check": false},
    {"title": "D. ${"I tried to make a difference.".tr}", "check": false},
    {
      "title": "E. ${"I aimed to be better than yesterday.".tr}",
      "check": false
    },
  ].obs;
  RxList concure = [
    {"title": "A. ${"With great success and confidence".tr}", "check": false},
    {"title": "B. ${"Very well, I'm satisfied".tr}", "check": false},
    {"title": "C. ${"Well, but it was challenging".tr}", "check": false},
    {"title": "D. ${"It wasn't easy, but I gave my best".tr}", "check": false},
    {"title": "E. ${"I gained valuable experience".tr}", "check": false},
  ].obs;

  RxList whatPrevented = [
    {"title": "A. ${"LackTime".tr}", "check": false},
    {"title": "B. ${"UnexpectedEvents".tr}", "check": false},
    {"title": "C. ${"LackMotivation".tr}", "check": false},
    {"title": "D. ${"NoEnergy".tr}", "check": false},
    {"title": "E. ${"Other".tr}", "check": false},
  ].obs;

  RxList whatCanYouToday = [
    {"title": "A. ${"planPositiveActivities".tr}", "check": false},
    {"title": "B. ${"TakeBreaks".tr}", "check": false},
    {"title": "C. ${"TalkSomeone".tr}", "check": false},
    {"title": "D. ${"Other".tr}", "check": false},
  ].obs;

  RxList whatCanDoMinimize = [
    {"title": "A. ${"Work".tr}", "check": false},
    {"title": "B. ${"family".tr}", "check": false},
    {"title": "C. ${"Relationship".tr}", "check": false},
    {"title": "D. ${"Health".tr}", "check": false},
    {"title": "E. ${"Finances".tr}", "check": false},
    {"title": "F. ${"Other".tr}", "check": false},
  ].obs;

  RxList success = [
    {
      "title": "A. ${"Very successful, I feel much more relaxed now".tr}",
      "check": false
    },
    {
      "title": "B. ${"Good, I used my stress management strategies".tr}",
      "check": false
    },
    {"title": "C. ${"Partially, it helped a little".tr}", "check": false},
    {
      "title": "D. ${"It was challenging, but I did my best".tr}",
      "check": false
    },
    {
      "title": "E. ${"I didn’t quite succeed, but I’l try again tomorrow".tr}",
      "check": false
    },
  ].obs;

  RxList whatHelpsYouStart = [
    {"title": "A. ${"StructuredPlan".tr}", "check": false},
    {"title": "B. ${"relaxationTechniques".tr}", "check": false},
    {"title": "C. ${"positiveMindset".tr}", "check": false},
    {"title": "D. ${"Other".tr}", "check": false},
  ].obs;
  RxList howDidYuRespond = [
    {"title": "A. ${"Well".tr}", "check": false},
    {"title": "B. ${"Moderately".tr}", "check": false},
    {"title": "C. ${"Poorly".tr}", "check": false},
  ].obs;

  RxList feelPhysicallyList = [
    {"title": "A. ${"Work".tr}", "check": false},
    {"title": "B. ${"Family".tr}", "check": false},
    {"title": "C. ${"Relationship".tr}", "check": false},
    {"title": "D. ${"Health".tr}", "check": false},
    {"title": "E. ${"Finances".tr}", "check": false},
    {"title": "F. ${"Other".tr}", "check": false},
  ].obs;

  RxList whatDoYouWant = [
    {"title": "A. ${"AGoal".tr}", "check": false},
    {"title": "B. ${"AWorkGoal".tr}", "check": false},
    {"title": "C. ${"LearnSkill".tr}", "check": false},
    {"title": "D. ${"other".tr}", "check": false},
  ].obs;

  RxList whatNegatively = [
    {"title": "A. ${"Worries".tr}", "check": false},
    {"title": "B. ${"Noise".tr}", "check": false},
    {"title": "C. ${"uncomfortableBed".tr}", "check": false},
    {"title": "D. ${"Health".tr}", "check": false},
    {"title": "E. ${"other".tr}", "check": false},
  ].obs;

  RxList whatStepCanYou = [
    {"title": "A. ${"planning".tr}", "check": false},
    {"title": "B. ${"seekingHelp".tr}", "check": false},
    {"title": "C. ${"timeManagement".tr}", "check": false},
    {"title": "D. ${"other".tr}", "check": false},
  ].obs;

  setQuestions(setting, BuildContext context) async {
    try {
      var moodData = {};
      if (setting == "mood") {
        moodData = {
          "type": "mood",
          "created_by": PrefService.getString(PrefKey.userId),
          "eveningFeeling":howDoYouIndex==0?"good":howDoYouIndex==1?"neutral":"bad",
          "feelThroughout": howDoYouIndex == 0
              ? "It was a great day!"
              : howDoYouIndex == 1
                  ? "I felt good most of the time."
                  : howDoYouIndex == 2
                      ? "My mood was up and down."
                      : howDoYouIndex == 3
                          ? "I was a bit tired, but I pushed through."
                          : howDoYouIndex == 4
                              ? "I stayed calm and focused throughout the day."
                              : "bad",

          "haveAPositive ": howDoYouIndexPositive == 0
              ? "A restful moment or break"
              : howDoYouIndexPositive == 1
                  ? "A soothing activity or routine"
                  : howDoYouIndexPositive == 2
                      ? "A healthy meal during the day"
                      : howDoYouIndexPositive == 3
                          ? "Positive thoughts and self-motivation"
                          : howDoYouIndexPositive == 4
                              ? " Something else that helped me"
                              : "bad",

          "positivelyEffected": selectedDidYouSleepWell!.isEmpty
              ? null
              : selectedDidYouSleepWell!.toLowerCase(),
          "describeThoughts": canYouDescribe.text.trim(),
          "react": howDidYouReactToIt.text.trim(),
          "positiveExperiences": whatCouldHelp.text.trim(),
          "improvedMood": isThereSomethingThat.text.trim(),
          "maintainMood": whatCouldHelpMaintain.text.trim(),
          "feelBetter": whatCouldHelp.text.trim(),
          "affectedMood": isThereSomethingThat.text.trim(),
          "strategies": whatCouldHelp.text.trim(),
        };
      } else if (setting == "sleep") {
        moodData = {
          "type": "stress",
          "created_by": PrefService.getString(PrefKey.userId),
          "eveningStress": selectedOptionStress!.isEmpty
              ? null
              : selectedOptionStress!.toLowerCase(),
          "causedStress": whatCausedYourStress == -1
              ? null
              : whatCausedYourStress == 0
                  ? "work"
                  : whatCausedYourStress == 1
                      ? "family"
                      : whatCausedYourStress == 2
                          ? "relationship"
                          : whatCausedYourStress == 3
                              ? "health"
                              : whatCausedYourStress == 4
                                  ? "finances"
                                  : "other",
          "successfulWereYou": successBool == -1
              ? null
              : successBool == 0
                  ? "Very successful, I feel much more relaxed now"
                  : successBool == 1
                      ? "Good, I used my stress management strategies"
                      : successBool == 2
                          ? "Partially, it helped a little"
                          : successBool == 3
                              ? "It was challenging, but I did my best"
                              : successBool == 4
                                  ? "I didn’t quite succeed, but I’l try again tomorro"
                                  : "other",
          "respondStress": whatHelpedStress == -1
              ? null
              : whatHelpedStress == 0
                  ? "well"
                  : whatHelpedStress == 1
                      ? "moderately"
                      : "poorly",
          "manaageStress": whatHelpedManage.text.trim(),
          "futureStress": areThere.text.trim(),
          "handleStress": canYouDescribeHow.text.trim(),
          "stressfulSituations": selectedOptionStress!.isEmpty
              ? null
              : selectedOptionStress!.toLowerCase(),
          "handleSituation": canYouDescribeHow.text.trim(),
          "stayCalm": whatHelpedStay.text.trim(),
        };
      } else {
        moodData = {
          "type": "motivation",
          "created_by": PrefService.getString(PrefKey.userId),
          "achieveToday": selectedOptionStressAchieve!.isEmpty
              ? null
              : selectedOptionStressAchieve!.toLowerCase(),
          "helpedAchieve": whatHelped == -1
              ? null
              : whatHelped == 0
                  ? "planning"
                  : whatHelped == 1
                      ? "support"
                      : whatHelped == 2
                          ? "motivation"
                          : "other",
          "maintainYourMotivation": maintainBool == -1
              ? null
              : maintainBool == 0
                  ? "I fully utilized my motivation."
                  : maintainBool == 1
                      ? "I was motivated, but there were ups and downs."
                      : maintainBool == 2
                          ? "It was challenging, but I kept going."
                          : maintainBool == 3
                              ? "I stayed motivated, even though it wasnâ€™t easy."
                              : "It was a calm day, but I gave it my best.",
          "giveYourBestToday": inspiredBool == -1
              ? null
              : inspiredBool == 0
                  ? "I maximized my full potential."
                  : inspiredBool == 1
                      ? "I sought personal satisfaction."
                      : inspiredBool == 2
                          ? "I created something positive."
                          : inspiredBool == 3
                              ? "I tried to make a difference."
                              : "I aimed to be better than yesterday.",
          "conquerYourChallenge": concureBool == -1
              ? null
              : concureBool == 0
                  ? "̌With great success and confidence"
                  : concureBool == 1
                      ? "̌Very well, I'm satisfied"
                      : concureBool == 2
                          ? "̌Well, but it was challenging"
                          : concureBool == 3
                              ? "̌It wasn't easy, but I gave my best"
                              : "̌I gained valuable experience",
          "particularlyMotivated": whatParticularly.text.trim(),
          "rewardyourself": howWill.text.trim(),
          "preventedGoal": null,
          "differentlyAchieve": whatCanYouDo.text.trim(),
          "support": sleep.text.trim()
        };
      }

      print(moodData);

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.Request('POST', Uri.parse(EndPoints.eveningQuestions));
      request.body = json.encode(moodData);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (setting == "mood") {
          updateApi(context, pKey: "eveningMoodQuestions");

          Get.to(() => EveningStress());
        } else if (setting == "sleep") {
          updateApi(context, pKey: "eveningStressQuestions");

          Get.to(() => EveningMotivational());
        } else {
          updateApi(context, pKey: "eveningMotivationQuestions");
          Get.offAll(() => const DashBoardScreen());

        /*  if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
          {
            Get.offAll(() =>  SubscriptionScreen(skip: true,));

          }
          else
          {

            Get.offAll(() => const DashBoardScreen());
          }*/
        }
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  skip( BuildContext context) async {
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

      var request = http.Request('POST', Uri.parse(EndPoints.eveningQuestions));
      request.body = json.encode(moodData);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {

          Get.offAll(() => const DashBoardScreen());

        /*  if((PrefService.getBool(PrefKey.isFreeUser) == false && PrefService.getBool(PrefKey.isSubscribed) == false))
          {
            Get.offAll(() =>  SubscriptionScreen(skip: true,));

          }
          else
          {

            Get.offAll(() => const DashBoardScreen());
          }*/

      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
