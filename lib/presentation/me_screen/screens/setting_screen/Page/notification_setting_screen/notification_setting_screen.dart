import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/notification_setting_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminder_time_utils.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminders_dialog.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class NotificationSettingScreen extends StatefulWidget {
   NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
   final NotificationSettingController notificationSettingController = Get.put(NotificationSettingController());
   ThemeController themeController = Get.find<ThemeController>();

   TextEditingController affirmationController = TextEditingController();
   TextEditingController meditationController = TextEditingController();
   TextEditingController gratitudeController = TextEditingController();
   TextEditingController goalController = TextEditingController();
   TextEditingController ritualsController = TextEditingController();
   TextEditingController shuruController = TextEditingController();
   TextEditingController moodController = TextEditingController();
   FocusNode affirmationFocus = FocusNode();
   FocusNode meditationFocus = FocusNode();
   FocusNode gratitudeFocus = FocusNode();
   FocusNode goalFocus = FocusNode();
   FocusNode ritualsFocus = FocusNode();
   FocusNode shuruFocus = FocusNode();
   FocusNode moodFocus = FocusNode();


   ReminderTime? affirmationReminderTime;
   ReminderTime? meditationReminderTime;
   ReminderTime? gratitudeReminderTime;
   ReminderTime? goalReminderTime;
   ReminderTime? ritualsReminderTime;
   ReminderTime? shuruReminderTime;
   ReminderTime? moodReminderTime;

   ReminderPeriod? affirmationReminderPeriod;
   ReminderPeriod? meditationReminderPeriod;
   ReminderPeriod? gratitudeReminderPeriod;
   ReminderPeriod? goalReminderPeriod;
   ReminderPeriod? ritualsReminderPeriod;
   ReminderPeriod? shuruReminderPeriod;
   ReminderPeriod? moodReminderPeriod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: themeController.isDarkMode.value ? ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(

          title: "setYourReminders".tr,
      ),
      body: Padding(
        padding: Dimens.d20.paddingAll,
        child: Column(
          children: [
            Text("howManyTimesWouldYouLikeToBe".tr,
              textAlign: TextAlign.center,
              style: Style.cormorantGaramondMedium(fontSize: Dimens.d16),),
            Dimens.d24.h.spaceHeight,
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      CommonTextField(
                        hintText: "10timeInADay".tr,
                        controller: affirmationController,
                        focusNode: affirmationFocus,
                        labelText: "affirmations".tr,
                        //suffixLottieIcon: themeManager.lottieDropDown,
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
                          showRemindersDialog(context,
                                  (value, reminderPeriod) {
                                affirmationController.text =
                                    value.name + reminderPeriod.desc;
                                affirmationReminderTime = value;
                                affirmationReminderPeriod = reminderPeriod;
                              },
                              prevSelectedReminder:
                              affirmationReminderTime,
                              prevSelectedReminderPeriod:
                              affirmationReminderPeriod,
                              isAffirmations: true,
                              label: "affirmationsReminder".tr);
                        },
                      ),
                      Dimens.d16.h.spaceHeight,
                      CommonTextField(
                        hintText: "10timeInADay".tr,
                        controller: meditationController,
                        focusNode: meditationFocus,
                        labelText: "meditations".tr,
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
                          showRemindersDialog(context,
                                  (value, reminderPeriod) {
                                meditationController.text =
                                    value.name + reminderPeriod.desc;
                                meditationReminderTime = value;
                                meditationReminderPeriod = reminderPeriod;
                              },
                              prevSelectedReminder:
                              meditationReminderTime,
                              prevSelectedReminderPeriod:
                              meditationReminderPeriod,
                              label: "meditationsReminder".tr);
                        },
                      ),
                      Dimens.d16.h.spaceHeight,
                      CommonTextField(
                        hintText: "10timeInADay".tr,
                        controller: gratitudeController,
                        focusNode: gratitudeFocus,
                        labelText: "gratitudes".tr,
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
                          showRemindersDialog(context,
                                  (value, reminderPeriod) {
                                gratitudeController.text =
                                    value.name + reminderPeriod.desc;
                                gratitudeReminderTime = value;
                                gratitudeReminderPeriod = reminderPeriod;
                              },
                              prevSelectedReminder: gratitudeReminderTime,
                              prevSelectedReminderPeriod:
                              gratitudeReminderPeriod,
                              label: "gratitudesReminder".tr);
                        },
                      ),
                      Dimens.d16.h.spaceHeight,
                      CommonTextField(
                        hintText: "10timeInADay".tr,
                        controller: ritualsController,
                        focusNode: ritualsFocus,
                        labelText: "rituals".tr,
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
                          showRemindersDialog(context,
                                  (value, reminderPeriod) {
                                ritualsController.text =
                                    value.name + reminderPeriod.desc;
                                ritualsReminderTime = value;
                                ritualsReminderPeriod = reminderPeriod;
                              },
                              prevSelectedReminder: ritualsReminderTime,
                              prevSelectedReminderPeriod:
                              ritualsReminderPeriod,
                              label: "ritualsReminder".tr);
                        },
                      ),
                      Dimens.d16.h.spaceHeight,


                      SizedBox(
                        height: 30.h,
                      ),
                      // (state is RemindersUpdateLoadingState)
                      //     ? const LoadingButton()
                      //     :
                      CommonElevatedButton(
                        title: "save".tr,
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          // remindersBloc.add(
                          //   RemindersRequestEvent(
                          //       affirmationsIntervalTime:
                          //       affirmationReminderPeriod ==
                          //           ReminderPeriod.off
                          //           ? 0
                          //           : affirmationReminderTime
                          //           ?.value ??
                          //           0,
                          //       meditationsIntervalTime:
                          //       meditationReminderPeriod ==
                          //           ReminderPeriod.off
                          //           ? 0
                          //           : meditationReminderTime
                          //           ?.value ??
                          //           0,
                          //       gratitudeIntervalTime:
                          //       gratitudeReminderPeriod ==
                          //           ReminderPeriod.off
                          //           ? 0
                          //           : gratitudeReminderTime
                          //           ?.value ??
                          //           0,
                          //       goalsIntervalTime:
                          //       goalReminderPeriod ==
                          //           ReminderPeriod.off
                          //           ? 0
                          //           : goalReminderTime?.value ?? 0,
                          //       ritualsIntervalTime:
                          //       ritualsReminderPeriod == ReminderPeriod.off
                          //           ? 0
                          //           : ritualsReminderTime?.value ??
                          //           0,
                          //       moodTime: moodReminderPeriod == ReminderPeriod.off
                          //           ? 0
                          //           : moodReminderTime?.value ?? 0,
                          //       shuruTime: shuruReminderPeriod == ReminderPeriod.off
                          //           ? 0
                          //           : shuruReminderTime?.value ?? 0,
                          //       affirmationsPeriod: affirmationReminderPeriod?.value,
                          //       meditationsPeriod: meditationReminderPeriod?.value,
                          //       ritualsPeriod: ritualsReminderPeriod?.value,
                          //       gratitudePeriod: gratitudeReminderPeriod?.value,
                          //       goalsPeriod: goalReminderPeriod?.value,
                          //       moodPeriod: moodReminderPeriod?.value,
                          //       shuruPeriod: shuruReminderPeriod?.value),
                          // );
                        },
                      ),
                      Dimens.d40.h.spaceHeight,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
