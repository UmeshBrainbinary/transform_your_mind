import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_motivational.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_stress.dart';

class HowFeelingEveningController extends GetxController{
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



  FocusNode  whatIsYourMindFocus = FocusNode();
  int howDoYouIndex = -1;
  int howDoYouIndexSleep = -1;
  int whatHelped = -1;
  int whatHelpedStress = -1;
  int whatHelpedStressAchieve = -1;
  int whatCausedYourStress = -1;
  int whatHelpedStressEvening = -1;
  int feelPhysically = -1;
  int selectedIndex = -1;
  String? selectedOption = '';
  String? selectedOptionStress = '';
  String? selectedOptionStressAchieve = '';
  String? selectedOptionStressEvening = '';
  String? selectedDidYouSleepWell = '';
  String? selectedOptionForSleep = '';

  RxList howDoYouFeelList = [
    {"title":"A. ${"Good".tr}","check":false},
    {"title":"B. ${"Neutral".tr}","check":false},
    {"title":"C. ${"Bad".tr}","check":false},
  ].obs;
  RxList whatHelpedYou = [
    {"title":"A. ${"Planning".tr}","check":false},
    {"title":"B. ${"support".tr}","check":false},
    {"title":"C. ${"Motivation".tr}","check":false},
    {"title":"D. ${"Other".tr}","check":false},
  ].obs;
  RxList whatPrevented = [
    {"title":"A. ${"LackTime".tr}","check":false},
    {"title":"B. ${"UnexpectedEvents".tr}","check":false},
    {"title":"C. ${"LackMotivation".tr}","check":false},
    {"title":"D. ${"NoEnergy".tr}","check":false},
    {"title":"E. ${"Other".tr}","check":false},
  ].obs;

  RxList whatCanYouToday = [
    {"title":"A. ${"planPositiveActivities".tr}","check":false},
    {"title":"B. ${"TakeBreaks".tr}","check":false},
    {"title":"C. ${"TalkSomeone".tr}","check":false},
    {"title":"D. ${"Other".tr}","check":false},
  ].obs;

  RxList whatCanDoMinimize = [
    {"title":"A. ${"Work".tr}","check":false},
    {"title":"B. ${"family".tr}","check":false},
    {"title":"C. ${"Relationship".tr}","check":false},
    {"title":"D. ${"Health".tr}","check":false},
    {"title":"E. ${"Finances".tr}","check":false},
    {"title":"F. ${"Other".tr}","check":false},
  ].obs;
  RxList whatHelpsYouStart = [
    {"title":"A. ${"StructuredPlan".tr}","check":false},
    {"title":"B. ${"relaxationTechniques".tr}","check":false},
    {"title":"C. ${"positiveMindset".tr}","check":false},
    {"title":"D. ${"Other".tr}","check":false},
  ].obs;
  RxList  howDidYuRespond= [
    {"title":"A. ${"Well".tr}","check":false},
    {"title":"B. ${"Moderately".tr}","check":false},
    {"title":"C. ${"Poorly".tr}","check":false},
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
    {"title":"C. ${"other".tr}","check":false},
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

  setQuestions(setting) async {
    try {
      var moodData = {};
       if (setting == "mood") {
       moodData = {
         "type": "mood",
         "created_by": PrefService.getString(PrefKey.userId),
         "eveningFeeling":howDoYouIndex==0?"good":howDoYouIndex==1?"neutral":"bad",
          "positivelyEffected": selectedDidYouSleepWell!.isEmpty
              ? null
              : selectedDidYouSleepWell!.toLowerCase(),
          "describeThoughts":canYouDescribe.text.trim(),
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
          "particularlyMotivated": whatParticularly.text.trim(),
          "rewardyourself": howWill.text.trim(),
          "preventedGoal": null,
          "differentlyAchieve": whatCanYouDo.text.trim(),
          "support": sleep.text.trim()
        };
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.Request(
          'POST', Uri.parse(EndPoints.eveningQuestions));
      request.body = json.encode(moodData);
      request.headers.addAll(headers);


      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (setting == "mood") {
          Get.to(() =>  EveningStress());
        }else if(setting == "sleep"){
          Get.to(() =>  EveningMotivational());
        }else{
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