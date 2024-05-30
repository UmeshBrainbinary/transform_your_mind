import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/common_gradiant_container.dart';
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
import 'package:transform_your_mind/widgets/custom_appbar.dart';


class SelectYourAffirmationFocusPage extends StatefulWidget {
  const SelectYourAffirmationFocusPage({
    Key? key,
    required this.isFromMe,
  }) : super(key: key);
  static const selectAffirmationFocus = '/selectAffirmationFocus';

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
      appBar: const CustomAppBar(
        title: "Select Your Affirmation Focus",
      ),
      body:Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackGroundContainer(
            image:ImageConstant.imgSelectFocus,
            isLeft: true,
            top: Dimens.d160.h,
            height: Dimens.d230.h,
          ),
          Column(
            children: [
              Dimens.d40.spaceHeight,
              AutoSizeText(
                "chooseMinInterest",
                textAlign: TextAlign.center,
                style: Style.montserratRegular(
                    color: Colors.black,
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
              ValueListenableBuilder(
                  valueListenable: selectedReminderTime,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: () {
                    /*    showRemindersDialog(context,
                                (value, reminderPeriod) {
                              selectedReminderTime.value = value.name ==
                                  '0 time '
                                  ? 'Off'
                                  : value.name + reminderPeriod.desc;
                              affirmationReminderTime = value;
                              affirmationReminderPeriod =
                                  reminderPeriod;
                            },
                            prevSelectedReminder:
                            affirmationReminderTime,
                            prevSelectedReminderPeriod:
                            affirmationReminderPeriod,
                            isAffirmations: true,
                            label: "Affirmation Reminder");*/
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: Dimens.d24,
                            right: Dimens.d24,
                            top: 20),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Text(
                                "Set Reminders",
                                style: Style.montserratRegular(
                                    fontSize: Dimens.d16,
                                    color: Colors.black),
                              ),
                            ),
                            const Spacer(),
                            Dimens.d10.spaceWidth,
                          /*  if (state is! RemindersLoadingState)
                              Text(selectedReminderTime.value,
                                  style: Style.montserratRegular(
                                      fontSize: Dimens.d16,
                                      color: Colors.black)),*/
                            SvgPicture.asset(ImageConstant.icDownArrow,
                                height: 20),
                          ],
                        ),
                      ),
                    );
                  }),
              Dimens.d20.spaceHeight,
              FocusSelectButton(
                primaryBtnText:
                widget.isFromMe ? "Save" : "Next",
                secondaryBtnText: widget.isFromMe ? '' : "Skip",
                isLoading:false,
                primaryBtnCallBack: () {
                  if (selectedTagNames.length >= 5) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return const FreeTrialPage();
                  },));

                  } else {
                    showSnackBarError(context,
                        'Please choose more then 5 affirmation');
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
