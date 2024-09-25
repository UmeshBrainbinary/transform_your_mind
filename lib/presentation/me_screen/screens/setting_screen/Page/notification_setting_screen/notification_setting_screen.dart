import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/alarm_list_screen.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/notification_setting_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/widget/reminder_time_utils.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:flutter/services.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

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
  void initState() {


    super.initState();
  }


final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    //statusBarSet(themeController);
    return Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? ColorConstant.darkBackground
            : ColorConstant.backGround,
        appBar: CustomAppBar(
          title: "setYourReminders".tr,
        ),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.d100),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile1Dark
                      : ImageConstant.profile1),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.d120),
                  child: SvgPicture.asset(themeController.isDarkMode.isTrue
                      ? ImageConstant.profile2Dark
                      : ImageConstant.profile2),
                )),
            Padding(
              padding: Dimens.d20.paddingAll,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GestureDetector(onTap: () {

                    },
                      child: Text(
                        "howManyTimesWouldYouLikeToBe".tr,
                        textAlign: TextAlign.center,
                        style: Style.nunRegular(fontSize: Dimens.d14),
                      ),
                    ),
                  ),
                  Dimens.d21.h.spaceHeight,
                  Expanded(
                    child: Stack(
                      children: [
                        ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            Text(
                              "affirmations".tr,
                              style: Style.nunitoSemiBold(fontSize: 14),
                            ),
                            Dimens.d20.h.spaceHeight,
                            Container(height: 47,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.2),
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode.value
                                    ? ColorConstant.textfieldFillColor
                                    : ColorConstant.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.d10,
                                vertical: Dimens.d5,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Dimens.d12.spaceWidth,
                                  Expanded(
                                    child: Text(
                                      "affirmationReminder".tr,
                                      style: Style.nunMedium().copyWith(
                                        letterSpacing: Dimens.d0_16,

                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: CustomSwitchD(
                                      value: themeController.isDarkMode.value,
                                      onChanged: (value) async {},
                                      width: 43.0,
                                      height: 23.0,
                                      activeColor: ColorConstant.themeColor,
                                      inactiveColor:themeController.isDarkMode.isTrue?ColorConstant.darkBackground: ColorConstant.backGround,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Dimens.d20.h.spaceHeight,
                            Text(
                              "motivationalMessages".tr,
                              style: Style.montserratSemiBold(fontSize: 14),
                            ),
                            Dimens.d16.h.spaceHeight,
                            Container(height: 47,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.2),
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode.value
                                    ? ColorConstant.textfieldFillColor
                                    : ColorConstant.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.d10,
                                vertical: Dimens.d5,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Dimens.d12.spaceWidth,
                                  Expanded(
                                    child: Text(
                                      "motivationalReminder".tr,
                                      style: Style.nunMedium().copyWith(
                                        letterSpacing: Dimens.d0_16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: CustomSwitchD(
                                      value: themeController.isDarkMode.value,
                                      onChanged: (value) async {},
                                      width: 43.0,
                                      height: 23.0,
                                      activeColor: ColorConstant.themeColor,
                                      inactiveColor:themeController.isDarkMode.isTrue?ColorConstant.darkBackground: ColorConstant.backGround,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Dimens.d20.h.spaceHeight,
                            Text(
                              "AffirmationAlarmsList".tr,
                              style: Style.montserratSemiBold(fontSize: 14),
                            ),
                            Dimens.d10.spaceHeight,
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const AlarmListScreen();
                                  },
                                ));
                              },
                              child: Container(height: 47,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1.2),
                                decoration: BoxDecoration(
                                  color: themeController.isDarkMode.value
                                      ? ColorConstant.textfieldFillColor
                                      : ColorConstant.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d10,
                                  vertical: Dimens.d5,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Dimens.d12.spaceWidth,
                                    Expanded(
                                      child: Text(
                                        "Alarms List".tr,
                                        style:
                                            Style.nunMedium().copyWith(
                                          letterSpacing: Dimens.d0_16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          ImageConstant.settingArrowRight,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? ColorConstant.white
                                                  : ColorConstant.black),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!audioPlayerController.isVisible.value) {
                return const SizedBox.shrink();
              }

              final currentPosition =
                  audioPlayerController.positionStream.value ??
                      Duration.zero;
              final duration =
                  audioPlayerController.durationStream.value ??
                      Duration.zero;
              final isPlaying = audioPlayerController.isPlaying.value;

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          Dimens.d24,
                        ),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return NowPlayingScreen(
                        audioData: audioDataStore!,
                      );
                    },
                  );
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 72,
                    width: Get.width,
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            ColorConstant.colorB9CCD0,
                            ColorConstant.color86A6AE,
                            ColorConstant.color86A6AE,
                          ], // Your gradient colors
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                        ),
                        color: ColorConstant.themeColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonLoadImage(
                                borderRadius: 6.0,
                                url: audioDataStore!.image!,
                                width: 47,
                                height: 47),
                            Dimens.d12.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  if (isPlaying) {
                                    await audioPlayerController
                                        .pause();
                                  } else {
                                    await audioPlayerController
                                        .play();
                                  }
                                },
                                child: SvgPicture.asset(
                                  isPlaying
                                      ? ImageConstant.pause
                                      : ImageConstant.play,
                                  height: 17,
                                  width: 17,
                                )),
                            Dimens.d10.spaceWidth,
                            Expanded(
                              child: Text(
                                audioDataStore!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Style.nunRegular(
                                    fontSize: 12,
                                    color: ColorConstant.white),
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  await audioPlayerController.reset();
                                },
                                child: SvgPicture.asset(
                                  ImageConstant.closePlayer,
                                  color: ColorConstant.white,
                                  height: 24,
                                  width: 24,
                                )),
                            Dimens.d10.spaceWidth,
                          ],
                        ),
                        Dimens.d8.spaceHeight,
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor:
                            ColorConstant.white.withOpacity(0.2),
                            inactiveTrackColor:
                            ColorConstant.color6E949D,
                            trackHeight: 1.5,
                            thumbColor: ColorConstant.transparent,
                            thumbShape: SliderComponentShape.noThumb,
                            overlayColor: ColorConstant.backGround
                                .withAlpha(32),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius:
                                16.0), // Customize the overlay shape and size
                          ),
                          child: SizedBox(
                            height: 2,
                            child: Slider(
                              thumbColor: Colors.transparent,
                              activeColor: ColorConstant.backGround,
                              value: currentPosition.inMilliseconds
                                  .toDouble(),
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                audioPlayerController
                                    .seekForMeditationAudio(
                                    position: Duration(
                                        milliseconds:
                                        value.toInt()));
                              },
                            ),
                          ),
                        ),
                        Dimens.d5.spaceHeight,
                      ],
                    ),
                  ),
                ),
              );
            }),

          ],
        ));
  }
}


class CustomSwitchD extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  const CustomSwitchD({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 50.0,
    this.height = 20.0,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
  });

  @override
  _CustomSwitchDState createState() => _CustomSwitchDState();
}

class _CustomSwitchDState extends State<CustomSwitchD> {
  late bool _value;
  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: _value ? widget.activeColor : widget.inactiveColor,
        ),
        child: Row(
          mainAxisAlignment:
          _value ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: widget.height - 5,
              height: widget.height - 5,
              margin: const EdgeInsets.all(3),
              decoration:   const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstant.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmService {
  static const MethodChannel _channel = MethodChannel('com.example.alarm');

  Future<void> setAlarm(String dateTime) async {
    try {
      await _channel.invokeMethod('setAlarm', {"dateTime": dateTime});
    } on PlatformException catch (e) {
      print("Failed to set alarm: ${e.message}");
    }
  }
}
