import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feelings_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class MotivationalQuestions extends StatelessWidget {
  MotivationalQuestions({super.key});

  HowFeelingsController feelController = Get.put(HowFeelingsController());
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
       exit(0);
    },
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.isTrue
            ? ColorConstant.darkBackground
            : ColorConstant.backGround,
        appBar: CustomAppBar(
          title: "MorningQuestions".tr,
          showBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d26.spaceHeight,

                Text(
                  "motivationQuestions".tr,
                  style: Style.nunitoBold(fontSize: 22),
                ),
                Dimens.d20.spaceHeight,
                //___________________________________ 1. _________________________________
                commonTextTitle("whatDoYouWant".tr, count: "1"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingsController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.whatDoYouWant.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.whatDoYouWant[index];
                      return GestureDetector(
                        onTap: () {
                          controller.whatDoYouWantToAchieve = index;
                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.whatDoYouWantToAchieve == index
                                      ? ColorConstant.themeColor
                                      : Colors.transparent),
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              commonText(data["title"]),
                              const Spacer(),
                              controller.whatDoYouWantToAchieve == index
                                  ? SvgPicture.asset(ImageConstant.check)
                                  : Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: themeController
                                                      .isDarkMode.isTrue
                                                  ? ColorConstant.white
                                                  : ColorConstant.black,
                                              width: 1)),
                                    )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Dimens.d15.spaceHeight,

                //___________________________________ 2. _________________________________

                commonTextTitle("whatStepCanYou".tr, count: "2"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingsController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.whatStepCanYou.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.whatStepCanYou[index];
                      return GestureDetector(
                        onTap: () {
                          controller.whatStep = index;

                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.whatStep == index
                                      ? ColorConstant.themeColor
                                      : Colors.transparent),
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              commonText(data["title"]),
                              const Spacer(),
                              controller.whatStep == index
                                  ? SvgPicture.asset(ImageConstant.check)
                                  : Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: themeController
                                                      .isDarkMode.isTrue
                                                  ? ColorConstant.white
                                                  : ColorConstant.black,
                                              width: 1)),
                                    )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),



                /// ---- 3-----
                commonTextTitle(
                    "How motivated are you to make the most of today?".tr,
                    count: "3"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingsController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:  controller.howMotivated.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.howMotivated[index];
                      return GestureDetector(
                        onTap: () {
                          controller.howMotivateBool = index;
                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.howMotivateBool == index
                                      ? ColorConstant.themeColor
                                      : Colors.transparent),
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              commonText(data["title"]),
                              const Spacer(),
                              controller.howMotivateBool == index
                                  ? SvgPicture.asset(ImageConstant.check)
                                  : Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: themeController
                                            .isDarkMode.isTrue
                                            ? ColorConstant.white
                                            : ColorConstant.black,
                                        width: 1)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Dimens.d15.spaceHeight,


                /// ---- 4-----
                 commonTextTitle(
                    "What inspired you to give your best today?".tr,
                    count: "4"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingsController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:  controller.whatInspire.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.whatInspire[index];
                      return GestureDetector(
                        onTap: () {
                          controller.whatInspireBool = index;
                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.whatInspireBool == index
                                      ? ColorConstant.themeColor
                                      : Colors.transparent),
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              commonText(data["title"]),
                              const Spacer(),
                              controller.whatInspireBool == index
                                  ? SvgPicture.asset(ImageConstant.check)
                                  : Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: themeController
                                            .isDarkMode.isTrue
                                            ? ColorConstant.white
                                            : ColorConstant.black,
                                        width: 1)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Dimens.d15.spaceHeight,


                /// ---- 5-----
               commonTextTitle(
                    "Which challenge do you want to conquer today?".tr,
                    count: "5"),

                Dimens.d20.spaceHeight,
               GetBuilder<HowFeelingsController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:  controller.whichChallenge.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.whichChallenge[index];
                      return GestureDetector(
                        onTap: () {
                          controller.whichChallengeBool = index;
                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.whichChallengeBool == index
                                      ? ColorConstant.themeColor
                                      : Colors.transparent),
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              commonText(data["title"]),
                              const Spacer(),
                              controller.whichChallengeBool == index
                                  ? SvgPicture.asset(ImageConstant.check)
                                  : Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: themeController
                                            .isDarkMode.isTrue
                                            ? ColorConstant.white
                                            : ColorConstant.black,
                                        width: 1)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Dimens.d15.spaceHeight,


                Dimens.d15.spaceHeight,
                commonTextSubtitle("whatParticularly".tr),

                Dimens.d20.spaceHeight,
                commonTextFiled("", feelController.whatParticularly),
                Dimens.d20.spaceHeight,
                commonTextSubtitle("howWill".tr),

                Dimens.d20.spaceHeight,
                commonTextFiled("", feelController.howWill),
                Dimens.d20.spaceHeight,
                commonTextSubtitle("howCanEnsure".tr),

                Dimens.d20.spaceHeight,
                commonTextFiled("", feelController.howCanEnsure),
                Dimens.d50.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Text(
                    "StartWithExercise".tr,
                    textAlign: TextAlign.center,
                    style: Style.nunRegular(fontSize: 14),
                  ),
                ),
                Dimens.d50.spaceHeight,

                CommonElevatedButton(
                  title: "letsStart".tr,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    PrefService.setValue(PrefKey.morningQuestion, true);
                    if(feelController.whatDoYouWantToAchieve!=-1){
                      feelController.setQuestions("motivation",context);
                    }else{
                      showSnackBarError(context, "pleaseSelectWhatDoYouAchieve".tr);
                    }
                    /*  if (feelController.howDoYouIndex == -1) {
                      showSnackBarError(
                          context, "Please select how do you feel right now?");
                    } else if (feelController.whatIsYourMind.text.isEmpty) {
                      showSnackBarError(context,
                          "Please write what is on your mind at a moment?");
                    } else if (feelController.particularChallenge.text.isEmpty) {
                      showSnackBarError(
                          context, "Please write particular challenge");
                    } else if (feelController.feelPhysically == -1) {
                      showSnackBarError(
                          context, "Please select how do you feel Physically?");
                    } else if (feelController.notFeelGood.text.isEmpty) {
                      showSnackBarError(
                          context, "Please write why doesn't feel good?");
                    } else if (feelController.whatThought.text.isEmpty) {
                      showSnackBarError(context,
                          "Please write what thought id going your mind?");
                    } else if (feelController.personalGoal.text.isEmpty) {
                      showSnackBarError(
                          context, "Please write your personal goals today?");
                    } else {

                    }*/
                  },
                ),

                Dimens.d70.spaceHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }

  commonTextTitle(
    String title, {
    String? count,
    double? fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$count.",
          style: Style.nunMedium(fontSize: 16),
        ),
        Dimens.d5.spaceWidth,
        Expanded(
          child:
              Text(title.tr, style: Style.nunMedium(fontSize: fontSize ?? 16)),
        )
      ],
    );
  }

  commonText(String title, {String? count, double? fontSize}) {
    return SizedBox(
        width: Get.width *0.6,
        child: Text(title.tr, style: Style.nunMedium(fontSize: fontSize ?? 16)));
  }

  commonTextSubtitle(title) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(7),
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeController.isDarkMode.isTrue
                      ? Colors.white
                      : Colors.black),
            ),
            Expanded(
                child: Text(
              title,
              style: Style.nunMedium(fontSize: 14),
            )),
          ],
        ));
  }

  commonTextFiled(title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CommonTextField(
        borderRadius: 10,
        hintText: title,
        maxLines: 4,
        controller: controller,
        focusNode: FocusNode(),
      ),
    );
  }
}
