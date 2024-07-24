import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HowFeelingEveningController extends GetxController{
  TextEditingController whatCanYouDo = TextEditingController();
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
  int whatHelpedStressEvening = -1;
  int feelPhysically = -1;
  int selectedIndex = -1;
  String? selectedOption = '';
  String? selectedOptionStress = '';
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

}