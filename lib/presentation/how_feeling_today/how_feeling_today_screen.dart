import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feelings_controller.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/stress_questions.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class HowFeelingTodayScreen extends StatefulWidget {
  const HowFeelingTodayScreen({super.key});

  @override
  State<HowFeelingTodayScreen> createState() => _HowFeelingTodayScreenState();
}

class _HowFeelingTodayScreenState extends State<HowFeelingTodayScreen> {
  HowFeelingsController f = Get.put(HowFeelingsController());
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "MorningQuestions".tr,
        action: Row(
          children: [
            InkWell(
                onTap: (){
                  f.setQuestionsSkip( context);
                },
                child: Text("skip".tr,style:  Style.nunRegular(fontSize: 16), )),
            const SizedBox(width: 20,),
          ],
        ),
        showBack: true,
      ),
      body: GetBuilder<HowFeelingsController>(builder: (controller) {
        return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dimens.d26.spaceHeight,

              Text(
                "moodQuestions".tr,
                style: Style.nunitoBold(fontSize: 22),
              ),
              Dimens.d20.spaceHeight,
              //___________________________________ 1. _________________________
              commonTextTitle("How are you feeling right now?".tr, count: "1"),

              Dimens.d20.spaceHeight,
              GetBuilder<HowFeelingsController>(
                builder: (controller) => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.howDoYouFeelList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = controller.howDoYouFeelList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.howDoYouIndex = index;
                        });
                        controller.update();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 15, left: 20, right: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: controller.howDoYouIndex == index
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
                            controller.howDoYouIndex == index
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

              //___________________________________  2. ________________________

              commonTextTitle(
                   "What helped you start your day well?".tr,
                  count: "2"),

              Dimens.d20.spaceHeight,
              GetBuilder<HowFeelingsController>(
                builder: (controller) => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount:controller.whatHelpedYou.length,
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
              ),
              Dimens.d15.spaceHeight,


              commonTextTitle(
                 "whatCanYouToday".tr
                    ,
                  count: "3"),

              Dimens.d20.spaceHeight,
              GetBuilder<HowFeelingsController>(
                builder: (controller) => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.whatCanYouToday.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = controller.whatCanYouToday[index]
                   ;
                    return GestureDetector(
                      onTap: () {
                        controller.whatHelpedCan = index;

                        controller.update();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 15, left: 20, right: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: controller.whatHelpedCan == index
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
                            controller.whatHelpedCan == index
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

              commonTextSubtitle(controller.howDoYouIndex!=0 ||controller.howDoYouIndex==-1?"whatPositive".tr:"howCanYouMaintain".tr),
              Dimens.d20.spaceHeight,
              commonTextFiled("", controller.whatPositive),
              Dimens.d20.spaceHeight,
              commonTextSubtitle(controller.howDoYouIndex!=0 || controller.howDoYouIndex==-1?"whatAreYouLooking".tr:"isThereASpecific".tr),
              Dimens.d20.spaceHeight,
              commonTextFiled("", controller.whatAreYouLooking),
              Dimens.d20.spaceHeight,
              commonTextSubtitle(controller.howDoYouIndex!=0 || controller.howDoYouIndex==-1?"whatSmallSteps".tr:"howCanYouSpread".tr),
              Dimens.d20.spaceHeight,
              commonTextFiled("", controller.whatSmallSteps),
              Dimens.d40.spaceHeight,

              CommonElevatedButton(
                title: "next".tr,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  PrefService.setValue(PrefKey.morningQuestion, true);
                  if(controller.howDoYouIndex!=-1){
                    await controller.setQuestions("mood",context);

                  }else{
                    showSnackBarError(context, "pleaseSelectHowAreYouFelling".tr);
                  }

                },
              ),

              Dimens.d70.spaceHeight,
            ],
          ),
        ),
      );},),
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
