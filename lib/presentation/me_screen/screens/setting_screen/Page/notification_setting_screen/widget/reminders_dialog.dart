

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminder_time_utils.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';

Future<void> showRemindersDialog(
  BuildContext context,
  Function(ReminderTime, ReminderPeriod) onSave, {
  ReminderTime? prevSelectedReminder,
  ReminderPeriod? prevSelectedReminderPeriod,
  bool isAffirmations = false,
  required String label,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      ReminderTime selectedReminderTime =
          prevSelectedReminder ?? ReminderTime.reminderTime1;
      ReminderPeriod selectedReminderPeriod =
          prevSelectedReminderPeriod ?? ReminderPeriod.daily;
      return StatefulBuilder(
        builder: (context, setStateSFBuilder) {
          updatePeriod(ReminderPeriod period) {
            selectedReminderPeriod = period;
            selectedReminderTime = selectedReminderPeriod.value == 0
                ? ReminderTime.reminderTime0
                : ReminderTime.reminderTime1;
            setStateSFBuilder(() {});
          }

          TextEditingController controller = TextEditingController(
              text: selectedReminderTime.name + selectedReminderPeriod.desc);
          FocusNode focusNode = FocusNode();

          ThemeController themeController = Get.find<ThemeController>();

          return Dialog(
            backgroundColor: ColorConstant.transparent,
            alignment: Alignment.center,
            insetPadding: Dimens.d20.paddingAll,
            child: Container(
              padding: Dimens.d20.paddingAll,
              decoration: BoxDecoration(
                color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.backGround,
                borderRadius: Dimens.d16.radiusAll,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: Style.nunMedium(
                            fontSize: Dimens.d18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close)
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: Dimens.d16,
                      bottom: Dimens.d32,
                    ),
                    child: Divider(),
                  ),
                  Text(
                    "selectReminderDuration".tr,
                    style: Style.nunMedium(
                      color: ColorConstant.grey,
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: ReminderPeriod.values.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _RadioWidgetReminderPeriod(
                          reminderTime: ReminderPeriod.values[index],
                          onTap: () =>
                              updatePeriod(ReminderPeriod.values[index]),
                          isSelected: selectedReminderPeriod ==
                              ReminderPeriod.values[index],
                        );
                      }),
                  Dimens.d30.spaceHeight,
                  if (selectedReminderPeriod != ReminderPeriod.off)
                    Text(
                      "selectNumberOfTimesYouWantReminder".tr + selectedReminderPeriod.desc,
                      style: Style.nunMedium(
                        color: ColorConstant.grey,
                      ),
                    ),
                  if (selectedReminderPeriod != ReminderPeriod.off)
                    CommonTextField(
                      hintText: "1timeInAMonth".tr,
                      controller: controller,
                      focusNode: focusNode,
                      labelText: '',
                       filledColor: themeController.isDarkMode.value ? ColorConstant.lightBlack : ColorConstant.white,
                      suffixIcon: Transform.scale(
                        scale: 0.38,
                        child:  Transform.rotate(
                          angle: 3.12,
                          child: SvgPicture.asset(
                            ImageConstant.icUpArrow,
                            height: Dimens.d18.h,
                            color: ColorConstant.themeColor,
                          ),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        showReminderIntervalsDialog(context, (value) {
                          controller.text =
                              value.name + selectedReminderPeriod.desc;
                          selectedReminderTime = value;
                        },
                            prevSelectedReminder: selectedReminderTime,
                            isAffirmations: isAffirmations,
                            selectedReminderPeriod: selectedReminderPeriod);
                      },
                    ),
                  Dimens.d32_5.spaceHeight,
                  CommonElevatedButton(
                    title: "update".tr,
                    onTap: () {
                      onSave(
                          selectedReminderPeriod == ReminderPeriod.off
                              ? ReminderTime.reminderTime0
                              : selectedReminderTime,
                          selectedReminderPeriod);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showReminderIntervalsDialog(
  BuildContext context,
  Function(ReminderTime) onSave, {
  ReminderTime? prevSelectedReminder,
  required ReminderPeriod selectedReminderPeriod,
  bool isAffirmations = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      ReminderTime selectedReminderTime =
          prevSelectedReminder ?? ReminderTime.reminderTime1;
      return StatefulBuilder(
        builder: (context, setStateSFBuilder) {
          update(ReminderTime period) {
            selectedReminderTime = period;
            setStateSFBuilder(() {});
            onSave(selectedReminderTime);
            Navigator.pop(context);
          }
          ThemeController themeController = Get.find<ThemeController>();
          return Dialog(
            backgroundColor: ColorConstant.transparent,
            alignment: Alignment.center,
            insetPadding: Dimens.d20.paddingAll,
            child: Container(
              padding: Dimens.d20.paddingAll,
              decoration: BoxDecoration(
                color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white,
                borderRadius: Dimens.d16.radiusAll,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "selectReminderTime".tr,
                    style: Style.nunMedium(
                      color: ColorConstant.grey,
                    ),
                  ),
                  Dimens.d20.spaceHeight,
                  _RadioWidget(
                    reminderTime: ReminderTime.reminderTime1,
                    selectedReminderPeriod: selectedReminderPeriod,
                    onTap: () => update(ReminderTime.reminderTime1),
                    isSelected:
                        selectedReminderTime == ReminderTime.reminderTime1,
                  ),
                  Dimens.d10.spaceHeight,
                  _RadioWidget(
                    selectedReminderPeriod: selectedReminderPeriod,
                    reminderTime: ReminderTime.reminderTime3,
                    onTap: () => update(ReminderTime.reminderTime3),
                    isSelected:
                        selectedReminderTime == ReminderTime.reminderTime3,
                  ),
                  Dimens.d10.spaceHeight,
                  _RadioWidget(
                    selectedReminderPeriod: selectedReminderPeriod,
                    reminderTime: ReminderTime.reminderTime5,
                    onTap: () => update(ReminderTime.reminderTime5),
                    isSelected:
                        selectedReminderTime == ReminderTime.reminderTime5,
                  ),
                  if (selectedReminderPeriod != ReminderPeriod.weekly) ...[
                    Dimens.d10.spaceHeight,
                    _RadioWidget(
                      selectedReminderPeriod: selectedReminderPeriod,
                      reminderTime: ReminderTime.reminderTime8,
                      onTap: () => update(ReminderTime.reminderTime8),
                      isSelected:
                          selectedReminderTime == ReminderTime.reminderTime8,
                    ),
                    Dimens.d10.spaceHeight,
                    _RadioWidget(
                      reminderTime: ReminderTime.reminderTime10,
                      selectedReminderPeriod: selectedReminderPeriod,
                      onTap: () => update(ReminderTime.reminderTime10),
                      isSelected:
                          selectedReminderTime == ReminderTime.reminderTime10,
                    ),
                  ] else ...[
                    Dimens.d10.spaceHeight,
                    _RadioWidget(
                      selectedReminderPeriod: selectedReminderPeriod,
                      reminderTime: ReminderTime.reminderTime7,
                      onTap: () => update(ReminderTime.reminderTime7),
                      isSelected:
                          selectedReminderTime == ReminderTime.reminderTime7,
                    ),
                  ],
                  /* Dimens.d32_5.spaceHeight,
                  CommonElevatedButton(
                    title: i10n.save,
                    onTap: () {

                    },
                  ),*/
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _RadioWidget extends StatelessWidget {
  final ReminderTime reminderTime;
  final ReminderPeriod selectedReminderPeriod;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioWidget({
    super.key,
    required this.reminderTime,
    required this.selectedReminderPeriod,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap.call,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.d10),
        child: Row(
          children: [
            Container(
              height: Dimens.d20,
              width: Dimens.d20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? ColorConstant.themeColor
                      : ColorConstant.grey,
                  width: Dimens.d1,
                ),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Container(
                      margin: const EdgeInsets.all(Dimens.d5),
                      decoration: const BoxDecoration(
                        color: ColorConstant.themeColor,
                        shape: BoxShape.circle,
                      ),
                      width: Dimens.d7_5,
                      height: Dimens.d7_5,
                    )
                  : const Offstage(),
            ),
            Dimens.d12.spaceWidth,
            Text(
              reminderTime.name + selectedReminderPeriod.desc,
              style: Style.nunRegular(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioWidgetReminderPeriod extends StatelessWidget {
  final ReminderPeriod reminderTime;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioWidgetReminderPeriod({
    super.key,
    required this.reminderTime,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap.call,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.d15),
        child: Row(
          children: [
            Container(
              height: Dimens.d20,
              width: Dimens.d20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? ColorConstant.themeColor
                      : ColorConstant.grey,
                  width: Dimens.d1,
                ),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Container(
                      margin: const EdgeInsets.all(Dimens.d5),
                      decoration: const BoxDecoration(
                        color: ColorConstant.themeColor,
                        shape: BoxShape.circle,
                      ),
                      width: Dimens.d7_5,
                      height: Dimens.d7_5,
                    )
                  : const Offstage(),
            ),
            Dimens.d12.spaceWidth,
            Text(
              reminderTime.name,
              style: Style.nunRegular(),
            ),
          ],
        ),
      ),
    );
  }
}
