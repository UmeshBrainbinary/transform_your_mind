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
import 'package:transform_your_mind/presentation/how_feeling_today/sleep_questions.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class StressQuestions extends StatelessWidget {
  StressQuestions({super.key});

  HowFeelingsController c = Get.put(HowFeelingsController());
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "MorningQuestions".tr,
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(child: GetBuilder<HowFeelingsController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d26.spaceHeight,

                Text(
                  "stressQuestions".tr,
                  style: Style.nunitoBold(fontSize: 22),
                ),
                Dimens.d20.spaceHeight,
                //___________________________________ 1. _________________________________
                commonTextTitle("doYouFeelStressed".tr, count: "1"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingsController>(
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

                commonTextTitle(
                    controller.selectedOptionStress == "No"
                        ? "whatHelpsYouStart".tr
                        : "whatCanYouDoToMinimize".tr,
                    count: "2"),

                Dimens.d20.spaceHeight,
                GetBuilder<HowFeelingsController>(
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.selectedOptionStress == "No"
                        ? controller.whatHelpsYouStart.length
                        : controller.whatCanDoMinimize.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = controller.selectedOptionStress == "No"
                          ? controller.whatHelpsYouStart[index]
                          : controller.whatCanDoMinimize[index];
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
                                  color: controller.whatHelpedStress == index
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
                commonTextSubtitle(controller.selectedOptionStress == "No"
                    ? "whatHabits".tr
                    : "whatRelaxation".tr),

                Dimens.d20.spaceHeight,
                commonTextFiled("", controller.whatRelaxation),
                Dimens.d20.spaceHeight,
                commonTextSubtitle(controller.selectedOptionStress == "No"
                    ? "howCanEncourage".tr
                    :"howCanYouYourSelf".tr),

                Dimens.d20.spaceHeight,
                commonTextFiled("", controller.howCanYouYourSelf),
                controller.selectedOptionStress == "No"?const SizedBox():Dimens.d20.spaceHeight,
                controller.selectedOptionStress == "No"?const SizedBox():commonTextSubtitle("whatPositiveThought".tr),

                controller.selectedOptionStress == "No"?const SizedBox():Dimens.d20.spaceHeight,
                controller.selectedOptionStress == "No"?const SizedBox():commonTextFiled("", controller.whatPositiveThought),
                Dimens.d40.spaceHeight,

                CommonElevatedButton(
                  title: "next".tr,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    PrefService.setValue(PrefKey.morningQuestion, true);
                    if(controller.selectedOptionStress!.isNotEmpty){
                      controller.setQuestions("stress");
                    }else{
                      showSnackBarError(context, "pleaseSelectDoYouFeel".tr);
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
    return Text(title.tr, style: Style.nunMedium(fontSize: fontSize ?? 16));
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
