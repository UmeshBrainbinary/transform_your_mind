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
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_evening_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
class EveningMotivational extends StatelessWidget {
   EveningMotivational({super.key});

   HowFeelingEveningController feelController = Get.put(HowFeelingEveningController());
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title:"${"Good evening".tr}, ${PrefService.getString(PrefKey.name)}",
        action: Row(
          children: [
            InkWell(
                onTap: (){
                  feelController.skip(context);
                },
                child: Text("skip".tr,style:  Style.nunRegular(fontSize: 16), )),
            const SizedBox(width: 20,),
          ],
        ),
        showBack: true,
      ),
      body: GetBuilder<HowFeelingEveningController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d26.spaceHeight,

                // Text(
                //   "motivationQuestions".tr,
                //   style: Style.nunitoBold(fontSize: 22),
                // ),
                //Dimens.d20.spaceHeight,
                //___________________________________ 1. _________________________________
       /*         commonTextTitle("DidYouAchieve".tr, count: "1"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingEveningController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                                controller.whatHelpedStressAchieve = -1;

                                controller.selectedOptionStressAchieve = "Yes";
                              controller.update();
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorConstant.themeColor,
                                  width: 1, // Increase border width
                                ),
                              ),
                                child: controller.selectedOptionStressAchieve ==
                                        "Yes"
                                    ? Center(
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorConstant.themeColor,
                                  ),
                                ),
                              )
                                  : const SizedBox(),
                            ),
                          ),
                          Dimens.d10.spaceWidth,
                          Text(
                            "yes".tr,
                            style: Style.nunMedium(fontSize: 12),
                          ),
                          Dimens.d40.spaceWidth,
                          GestureDetector(
                            onTap: () {
                                controller.whatHelpedStressAchieve = -1;

                                controller.selectedOptionStressAchieve =
                              "Partially";
                              controller.update();
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorConstant.themeColor,
                                  width: 1, // Increase border width
                                ),
                              ),
                                child: controller.selectedOptionStressAchieve ==
                                        "Partially"
                                    ? Center(
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorConstant.themeColor,
                                  ),
                                ),
                              )
                                  : const SizedBox(),
                            ),
                          ),
                          Dimens.d10.spaceWidth,
                          Text(
                            "Partially".tr,
                            style: Style.nunMedium(fontSize: 12),
                          ),
                          Dimens.d40.spaceWidth,
                          GestureDetector(
                            onTap: () {
                                controller.whatHelpedStressAchieve = -1;
                                controller.selectedOptionStressAchieve = "No";
                                controller.update();
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorConstant.themeColor,
                                  width: 1, // Increase border width
                                ),
                              ),
                                child: controller.selectedOptionStressAchieve ==
                                        "No"
                                    ? Center(
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorConstant.themeColor,
                                  ),
                                ),
                              )
                                  : const SizedBox(),
                            ),
                          ),
                          Dimens.d10.spaceWidth,
                          Text(
                            "no".tr,
                            style: Style.nunMedium(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),*/

                //___________________________________ 3. _________________________________
                //Dimens.d20.spaceHeight,
                commonTextTitle("How well did you maintain your motivation today?".tr, count: "1"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingEveningController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.maintain.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.maintain[index];
                      return GestureDetector(
                        onTap: () {
                          controller.maintainBool = index;

                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.maintainBool == index
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
                              controller.maintainBool == index
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

                //___________________________________ 4. _________________________________
                Dimens.d20.spaceHeight,
                commonTextTitle("What inspired you to give your best today?".tr, count: "2"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingEveningController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.inspired.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.inspired[index];
                      return GestureDetector(
                        onTap: () {
                          controller.inspiredBool = index;

                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.inspiredBool == index
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
                              controller.inspiredBool == index
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
                //___________________________________ 5. _________________________________
                Dimens.d20.spaceHeight,
                commonTextTitle("How well did you conquer your challenge today?".tr, count: "3"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingEveningController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.concure.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.concure[index];
                      return GestureDetector(
                        onTap: () {
                          controller.concureBool = index;

                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.concureBool == index
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
                              controller.concureBool == index
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
                //Dimens.d20.spaceHeight,
                //___________________________________ 2. _________________________________

                  controller.selectedOptionStressAchieve == "No"
                      ? Column(
                          children: [
                  //           commonTextTitle("whatPrevented".tr, count: "5"),
                  // Dimens.d20.spaceHeight,
                  // GetBuilder<HowFeelingEveningController>(
                  //   builder: (controller) => ListView.builder(
                  //     padding: EdgeInsets.zero,
                  //     itemCount: controller.whatPrevented.length,
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemBuilder: (context, index) {
                  //       var data = controller.whatPrevented[index];
                  //       return GestureDetector(
                  //         onTap: () {
                  //           controller.whatHelped = index;
                  //
                  //           controller.update();
                  //         },
                  //         child: Container(
                  //           margin: const EdgeInsets.only(
                  //               bottom: 15, left: 20, right: 20),
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 13, vertical: 10),
                  //           decoration: BoxDecoration(
                  //               border: Border.all(
                  //                   color: controller.whatHelped == index
                  //                       ? ColorConstant.themeColor
                  //                       : Colors.transparent),
                  //               color: themeController.isDarkMode.isTrue
                  //                   ? ColorConstant.textfieldFillColor
                  //                   : ColorConstant.white,
                  //               borderRadius: BorderRadius.circular(8)),
                  //           child: Row(
                  //             children: [
                  //               commonText(data["title"]),
                  //               const Spacer(),
                  //               controller.whatHelped == index
                  //                   ? SvgPicture.asset(ImageConstant.check)
                  //                   : Container(
                  //                 height: 18,
                  //                 width: 18,
                  //                 decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     border: Border.all(
                  //                         color: themeController
                  //                             .isDarkMode.isTrue
                  //                             ? ColorConstant.white
                  //                             : ColorConstant.black,
                  //                         width: 1)),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // Dimens.d20.spaceHeight,
                  // commonTextSubtitle("whatCanYouDo".tr),
                  //
                  // Dimens.d20.spaceHeight,
                  // commonTextFiled("", feelController.whatCanYouDo),
                  // Dimens.d20.spaceHeight,
                  // commonTextSubtitle("whatSupport".tr),
                  //
                  // Dimens.d20.spaceHeight,
                  //           commonTextFiled("", feelController.sleep),
                  //           Dimens.d20.spaceHeight,

                ],):
                  Column(children: [
                 /* commonTextTitle("whatHelpedYou".tr, count: "5"),

                  Dimens.d20.spaceHeight,
                  GetBuilder<HowFeelingEveningController>(
                    builder: (controller) => ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.whatHelpedYou.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var data = controller.whatHelpedYou[index];
                        return GestureDetector(
                          onTap: () {
                            controller.whatHelped = index;

                            controller.update();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 15, left: 20, right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: controller.whatHelped == index
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
                                controller.whatHelped == index
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
                  ),*/

                  //Dimens.d15.spaceHeight,
                  // commonTextSubtitle("whatParticularly".tr),
                  //
                  // Dimens.d20.spaceHeight,
                  // commonTextFiled("", feelController.whatParticularly),
                  // Dimens.d20.spaceHeight,
                  // commonTextSubtitle("HowYourself".tr),
                  //
                  // Dimens.d20.spaceHeight,
                  // commonTextFiled("", feelController.howWill),
                ],),






                Dimens.d40.spaceHeight,
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
                      if (feelController
                          .maintainBool != -1) {
                        feelController.setQuestions("motivational",context);
                      } else {
                        showSnackBarError(context, "pleaseAddDoYou".tr);
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
        );
      },),
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
