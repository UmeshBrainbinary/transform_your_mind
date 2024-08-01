import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/common_api/common_api.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/motivational_questions.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/sleep_questions.dart';
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
  int whatDoYouWantToAchieve = -1;
  int howDoYouIndexSleep = -1;
  int whatHelped = -1;
  int whatStep = -1;
  int whatHelpedStress = -1;
  int feelPhysically = -1;
  int selectedIndex = -1;
  String? selectedOption = '';
  String? selectedOptionStress = '';
  String? selectedDidYouSleepWell = '';
  String? selectedOptionForSleep = '';

  RxList howDoYouFeelList = [
    {"title":"A. ${"Good".tr}","check":false},
    {"title":"B. ${"Neutral".tr}","check":false},
    {"title":"C. ${"Bad".tr}","check":false},
  ].obs;
  RxList whatHelpedYou = [
    {"title": "A. ${"GoodNews".tr}", "check": false},
    {"title": "B. ${"RestfulSleep".tr}", "check": false},
    {"title": "C. ${"PositiveThoughts".tr}", "check": false},
    {"title":"D. ${"Other".tr}","check":false},
  ].obs;

  RxList whatCanYouToday = [
    {"title":"A. ${"planPositiveActivities".tr}","check":false},
    {"title":"B. ${"TakeBreaks".tr}","check":false},
    {"title":"C. ${"TalkSomeone".tr}","check":false},
    {"title":"D. ${"Other".tr}","check":false},
  ].obs;

  RxList whatCanDoMinimize = [
    {"title":"A. ${"ListenAudio".tr}","check":false},
    {"title":"B. ${"BreathingTechnique".tr}","check":false},
    {"title":"C. ${"SpendOutdoors".tr}","check":false},
    {"title":"D. ${"TalkFrd".tr}","check":false},
    {"title":"E. ${"Other".tr}","check":false},
  ].obs;
  RxList whatHelpsYouStart = [
    {"title":"A. ${"StructuredPlan".tr}","check":false},
    {"title":"B. ${"relaxationTechniques".tr}","check":false},
    {"title":"C. ${"positiveMindset".tr}","check":false},
    {"title":"D. ${"Other".tr}","check":false},
  ].obs;

 RxList feelPhysicallyList = [
    {"title":"A. ${"Work".tr}","check":false},
    {"title":"B. ${"Family".tr}","check":false},
    {"title":"C. ${"Relationship".tr}","check":false},
    {"title":"D. ${"Health".tr}","check":false},
    {"title":"E. ${"Finances".tr}","check":false},
    {"title":"F. ${"Other".tr}","check":false},
  ].obs;

  RxList whatDoYouWant = [
    {"title":"A. ${"AGoal".tr}","check":false},
    {"title":"B. ${"AWorkGoal".tr}","check":false},
    {"title":"C. ${"LearnSkill".tr}","check":false},
    {"title":"D. ${"other".tr}","check":false},
  ].obs;

  RxList whatNegatively = [
    {"title":"A. ${"Worries".tr}","check":false},
    {"title":"B. ${"Noise".tr}","check":false},
    {"title":"C. ${"uncomfortableBed".tr}","check":false},
    {"title":"D. ${"Health".tr}","check":false},
    {"title":"E. ${"other".tr}","check":false},
  ].obs;
  RxList whatStepCanYou = [
    {"title":"A. ${"planning".tr}","check":false},
    {"title":"B. ${"seekingHelp".tr}","check":false},
    {"title":"C. ${"timeManagement".tr}","check":false},
    {"title":"D. ${"other".tr}","check":false},
  ].obs;

  setQuestions(setting, BuildContext context,) async {
    try {
      var moodData = {};
      if (setting == "mood") {
        moodData = {
          "type": "mood",
          "created_by": PrefService.getString(PrefKey.userId),
          "morningFeeling": howDoYouIndex == 0
              ? "good"
              : howDoYouIndex == 1
                  ? "neutral"
                  : "bad",
          "morningHelp": whatHelped == -1
              ? null
              : whatHelped == 0
                  ? "goodNews"
                  : whatHelped == 1
                      ? "restfulSleep"
                      : whatHelped == 2
                          ? "positiveThoughts"
                          : "other",
          "positiveFeeling": whatPositive.text.trim(),
          "morningGoal": whatAreYouLooking.text.trim(),
          "goodMood": whatSmallSteps.text.trim(),
          "improveMood": whatHelped == -1
              ? null
              : whatHelped == 0
                  ? "planPositiveActivities"
                  : whatHelped == 1
                      ? "takeBreaks"
                      : whatHelped == 2
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
                  ? "worries"
                  : howDoYouIndexSleep == 1
                      ? "noise"
                      : howDoYouIndexSleep == 2
                          ? "uncomfortableBed"
                          : howDoYouIndexSleep == 3
                              ? "health"
                              : "other",
          "improveSleep": whatMeasures.text.trim(),
          "helpedSleep": whatHasHelped.text.trim().isEmpty
              ? null
              : whatHasHelped.text.trim(),
        };
      } else if (setting == "stress") {
        moodData = {
          "type": "stress",
          "created_by": PrefService.getString(PrefKey.userId),
          "morningStress": selectedOptionStress!.toLowerCase(),
          "minimizeStress": selectedOptionStress == "Yes"
              ? whatHelpedStress == -1
                  ? null
                  : whatHelpedStress == 0
                      ? "listenToAudio"
                      : whatHelpedStress == 1
                          ? "breathingTechnique"
                          : whatHelpedStress == 2
                              ? "spendTimeOutdoors"
                              : whatHelpedStress == 3
                                  ? "talkToFriend"
                                  : "other"
              : whatHelpedStress == -1
                  ? null
                  : null,
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
      } else {
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
          "particularlyMotivates": whatParticularly.text.trim(),
          "rewardYourself": howWill.text.trim(),
          "ensureStay": howCanEnsure.text.trim()
        };
      }

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
          if (setting == "mood") {
            updateApi(context,pKey: "eveningMotivationQuestions");

            Get.to(() => StressQuestions());
          } else if (setting == "stress") {
            updateApi(context,pKey: "eveningMotivationQuestions");

            Get.to(() => SleepQuestions());
          } else if (setting == "sleep") {
            updateApi(context,pKey: "eveningMotivationQuestions");

            Get.to(() => MotivationalQuestions());
          } else {
            updateApi(context,pKey: "eveningMotivationQuestions");

            Get.offAll(() => const DashBoardScreen());
          }
        }
        else {
          debugPrint(response.reasonPhrase);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
}