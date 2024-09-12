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
import 'package:transform_your_mind/presentation/how_feeling_today/evening_motivational.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/evening_sleep.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_evening_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class EveningStress extends StatelessWidget {
  EveningStress({super.key});

  HowFeelingEveningController c = Get.put(HowFeelingEveningController());
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "${"Good evening".tr}, ${PrefService.getString(PrefKey.name)}",
        action: Row(
          children: [
            InkWell(
                onTap: (){
                  c.skip(context);
                },
                child: Text("skip".tr,style:  Style.nunRegular(fontSize: 16), )),
            const SizedBox(width: 20,),
          ],
        ),
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
            child: GetBuilder<HowFeelingEveningController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d26.spaceHeight,

             /*   Text(
                  "stressQuestions".tr,
                  style: Style.nunitoBold(fontSize: 22),
                ),
                Dimens.d20.spaceHeight,*/
                //___________________________________ 1. _________________________________
                commonTextTitle("didYouFeel".tr, count: "1"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingEveningController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.whatHelpedStress = -1;

                              controller.selectedOptionStress = "Yes";
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
                              child: controller.selectedOptionStress == "Yes"
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
                              controller.whatHelpedStress = -1;
                              controller.selectedOptionStress = "No";
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
                              child: controller.selectedOptionStress == "No"
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
                ),

                Dimens.d30.spaceHeight,

                //___________________________________ 2. _________________________________

             /*   commonTextTitle(
                    controller.selectedOptionStress == "No"
                        ? "haveThereBeenStressful".tr
                        : "whatCausedStress".tr,
                    count: "2"),  */

                commonTextTitle(
                    controller.selectedOptionStress == "No"
                        ? "haveThereBeenStressful".tr
                        : "How successful were you in relieving your stress today?".tr,
                    count: "2"),

                controller.selectedOptionStress == "No"
                    ? Column(
                        children: [
                          Dimens.d20.spaceHeight,
                          GetBuilder<HowFeelingEveningController>(
                            builder: (controller) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.whatHelpedStressEvening = -1;

                                        controller.selectedOptionStressEvening =
                                            "Yes";
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
                                        child: controller
                                                    .selectedOptionStressEvening ==
                                                "Yes"
                                            ? Center(
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorConstant
                                                        .themeColor,
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
                                        controller.whatHelpedStressEvening = -1;
                                        controller.selectedOptionStressEvening =
                                            "No";
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
                                        child: controller
                                                    .selectedOptionStressEvening ==
                                                "No"
                                            ? Center(
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorConstant
                                                        .themeColor,
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
                          ),
                          // Dimens.d30.spaceHeight,
                          // commonTextSubtitle( "canYouDescribeHow".tr),
                          // Dimens.d20.spaceHeight,
                          // commonTextFiled("", controller.canYouDescribeHow),
                          // Dimens.d30.spaceHeight,
                          // commonTextSubtitle( "whatHelpedStay".tr),
                          // Dimens.d20.spaceHeight,
                          // commonTextFiled("", controller.whatHelpedStay),
                        ],
                      )
                    :
                Column(
                        children: [
                        /*  Dimens.d20.spaceHeight,
                          GetBuilder<HowFeelingEveningController>(
                            builder: (controller) => ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.whatCanDoMinimize.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = controller.whatCanDoMinimize[index];
                                return GestureDetector(
                                  onTap: () {
                                    controller.whatCausedYourStress = index;
                                    controller.update();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 15, left: 20, right: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                controller.whatCausedYourStress ==
                                                        index
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
                                        controller.whatCausedYourStress == index
                                            ? SvgPicture.asset(
                                                ImageConstant.check)
                                            : Container(
                                                height: 18,
                                                width: 18,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: themeController
                                                                .isDarkMode
                                                                .isTrue
                                                            ? ColorConstant
                                                                .white
                                                            : ColorConstant
                                                                .black,
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
                          commonTextTitle("howDidYuRespond".tr, count: "3"),
                          Dimens.d30.spaceHeight,
                          GetBuilder<HowFeelingEveningController>(
                            builder: (controller) => ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.howDidYuRespond.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = controller.howDidYuRespond[index];
                                return GestureDetector(
                                  onTap: () {
                                    controller.whatHelpedStress = index;
                                    controller.update();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 15, left: 20, right: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                controller.whatHelpedStress ==
                                                        index
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
                                        controller.whatHelpedStress == index
                                            ? SvgPicture.asset(
                                                ImageConstant.check)
                                            : Container(
                                                height: 18,
                                                width: 18,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: themeController
                                                                .isDarkMode
                                                                .isTrue
                                                            ? ColorConstant
                                                                .white
                                                            : ColorConstant
                                                                .black,
                                                        width: 1)),
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
*/
                          //
                          // Dimens.d15.spaceHeight,
                          // commonTextTitle("How successful were you in relieving your stress today?".tr, count: "4"),

                          Dimens.d20.spaceHeight,
                          GetBuilder<HowFeelingEveningController>(
                            builder: (controller) => ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.success.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = controller.success[index];
                                return GestureDetector(
                                  onTap: () {
                                    controller.successBool = index;
                                    controller.update();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 15, left: 20, right: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                            controller.successBool ==
                                                index
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
                                        controller.successBool == index
                                            ? SvgPicture.asset(
                                            ImageConstant.check)
                                            : Container(
                                          height: 18,
                                          width: 18,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: themeController
                                                      .isDarkMode
                                                      .isTrue
                                                      ? ColorConstant
                                                      .white
                                                      : ColorConstant
                                                      .black,
                                                  width: 1)),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),


                        /*  Dimens.d15.spaceHeight,
                          commonTextSubtitle(controller.whatHelpedStress != 0
                              ? "whatCouldHaveDone".tr
                              : "whatHelpedManage".tr),
                          Dimens.d20.spaceHeight,
                          commonTextFiled("", controller.whatHelpedManage),
                          controller.whatHelpedStress != 0
                              ? const SizedBox()
                              : Dimens.d20.spaceHeight,
                          controller.whatHelpedStress != 0
                              ? const SizedBox()
                              : commonTextSubtitle("areThere".tr),
                          controller.whatHelpedStress != 0
                              ? const SizedBox()
                              : Dimens.d20.spaceHeight,
                          controller.whatHelpedStress != 0
                              ? const SizedBox()
                              : commonTextFiled(
                                  "", controller.areThere),*/
                        ],
                      ),


                /// ---- 3


                Dimens.d40.spaceHeight,

                CommonElevatedButton(
                  title: "next".tr,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    PrefService.setValue(PrefKey.eveningQuestion, true);
                    FocusScope.of(context).unfocus();
                    if (controller.selectedOptionStress!.isNotEmpty) {
                      controller.setQuestions("sleep",context);
                    } else {
                      showSnackBarError(
                          context, "pleaseSetDidYouFeelStressed".tr);
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
            );
          },
        )),
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
