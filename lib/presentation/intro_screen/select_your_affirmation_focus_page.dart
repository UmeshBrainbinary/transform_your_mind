import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/custom_chip.dart';
import 'package:transform_your_mind/core/common_widget/free_trial_page.dart';
import 'package:transform_your_mind/core/common_widget/select_focus_button.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_focus_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminder_time_utils.dart';
import '../me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminders_dialog.dart';

class SelectYourAffirmationFocusPage extends StatefulWidget {
  const SelectYourAffirmationFocusPage({
    Key? key,
    required this.isFromMe,
  }) : super(key: key);

  final bool isFromMe;

  @override
  State<SelectYourAffirmationFocusPage> createState() =>
      _SelectYourAffirmationFocusPageState();
}

class _SelectYourAffirmationFocusPageState
    extends State<SelectYourAffirmationFocusPage> {
  List<Tag> listOfTags = [
    Tag("Self Care", false),
    Tag("Family", false),
    Tag("Abundance", false),
    Tag("Money", false),
    Tag("Relationship", false),
    Tag("Happiness", false),
    Tag("Business", false),
    Tag("Positivity", false),
    Tag("habits", false),
    Tag("Relationship Breakup", false),
    Tag("Diet", false),
    Tag("Giving Back", false),
    Tag("Love", false),
    Tag("Mental Health", false),
    Tag("help with stress and anxiety", false),
    Tag("Attract Love", false),
    Tag("Depression", false),
    Tag("Growth", false),
  ];

  List<String> selectedTagNames = [];
  ValueNotifier<String> selectedReminderTime = ValueNotifier('');
  ThemeController themeController = Get.find<ThemeController>();

  TextEditingController affirmationController = TextEditingController();

  ReminderTime? affirmationReminderTime;
  ReminderPeriod? affirmationReminderPeriod;

  @override
  void initState() {
    super.initState();
  }

  void _onTagTap(Tag tag) {
    setState(() {
      tag.isSelected = !tag.isSelected;
      if (tag.isSelected) {
        selectedTagNames.add(tag.name);
      } else {
        selectedTagNames.remove(tag.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "selectYourAffirmationFocus".tr,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,

        children: [
          !themeController.isDarkMode.value
              ? BackGroundContainer(
            image: ImageConstant.imgSelectFocus,
            isLeft: false,
            top: Dimens.d100.h,
            height: Dimens.d230.h,
          ) : const SizedBox(),
          Column(
            children: [
              Dimens.d40.spaceHeight,
              AutoSizeText(
                "chooseMinInterest".tr,
                textAlign: TextAlign.center,
                style: Style.montserratRegular(
                    color: themeController.isDarkMode.value
                        ? ColorConstant.white
                        : ColorConstant.black,
                    fontSize: Dimens.d14,
                    fontWeight: FontWeight.w600),
              ),
              Dimens.d24.spaceHeight,
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: listOfTags.map((tag) {
                        return GestureDetector(
                          onTap: () => _onTagTap(tag),
                          child: CustomChip(
                            label: tag.name,
                            isChipSelected: tag.isSelected,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
         /*     ValueListenableBuilder(
                  valueListenable: selectedReminderTime,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: () {
                        showRemindersDialog(context, (value, reminderPeriod) {
                          affirmationController.text =
                              value.name + reminderPeriod.desc;
                          affirmationReminderTime = value;
                          affirmationReminderPeriod = reminderPeriod;
                        },
                            prevSelectedReminder: affirmationReminderTime,
                            prevSelectedReminderPeriod:
                                affirmationReminderPeriod,
                            isAffirmations: true,
                            label: "affirmationsReminder".tr);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: Dimens.d24, right: Dimens.d24, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Text(
                                "setReminders".tr,
                                style: Style.montserratRegular(
                                    fontSize: Dimens.d16,
                                    color: themeController.isDarkMode.value
                                        ? ColorConstant.white
                                        : ColorConstant.black),
                              ),
                            ),
                            const Spacer(),
                            Dimens.d10.spaceWidth,
                            *//*  if (state is! RemindersLoadingState)
                              Text(selectedReminderTime.value,
                                  style: Style.montserratRegular(
                                      fontSize: Dimens.d16,
                                      color: Colors.black)),*//*
                            SvgPicture.asset(ImageConstant.icDownArrow,
                                height: 20),
                          ],
                        ),
                      ),
                    );
                  }),*/
              Dimens.d20.spaceHeight,
              FocusSelectButton(
                primaryBtnText: widget.isFromMe ? "save".tr : "next".tr,
                secondaryBtnText: widget.isFromMe ? '' : "skip".tr,
                isLoading: false,
                primaryBtnCallBack: () {
                  if (selectedTagNames.length >= 5) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const FreeTrialPage();
                      },
                    ));
                  } else {
                    showSnackBarError(
                        context, 'Please choose more than 5 affirmation');
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
