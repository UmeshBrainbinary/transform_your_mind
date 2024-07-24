import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
  int howDoYouIndexSleep = -1;
  int whatHelped = -1;
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
    {"title":"A. ${"GoodNews".tr}","check":false},
    {"title":"B. ${"RestfulSleep".tr}","check":false},
    {"title":"C. ${"PositiveThoughts".tr}","check":false},
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
    {"title":"D. ${"Other".tr}","check":false},
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


}