import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/affirmation_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/audio_list.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/notification_setting_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  bool am = true;
  bool pm = false;
  Duration selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSeconds = 0;
  bool soundMute = false;
  bool playPause = false;
  List playPauseList = [];

  final String audioFilePath = 'assets/audio/audio.mp3';
  NotificationSettingController notificationSettingController =
      Get.put(NotificationSettingController());

  AffirmationController affirmationController = Get.put(AffirmationController());

  void _setAlarm(id, String filePath) async {
    DateTime alarmTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,
      selectedHour,selectedMinute,selectedSeconds);
    final alarmSettings = AlarmSettings(
        id: id,
        dateTime: alarmTime,
        assetAudioPath: filePath,
        loopAudio: true,
        vibrate: true,
        volume: 0.2,
        androidFullScreenIntent: true,
        fadeDuration: 3.0,
        notificationTitle: 'TransformYourMind',
        notificationBody: 'TransformYourMind Alarm ringing.....',
        enableNotificationOnKill: Platform.isAndroid?Platform.isAndroid:Platform.isIOS);
    await Alarm.set(
      alarmSettings: alarmSettings,
    );
  }

  @override
  void initState() {
    checkInternet();


    super.initState();
  }


  checkInternet() async {
    if (await isConnected()) {
      getAlarm();
    } else {
      showSnackBarError(context, "noInternet".tr);
    }
  }

  getAlarm() async {
    await notificationSettingController.getAffirmationAlarm();
  }

  deleteAlarm(id) async {
    await notificationSettingController.deleteAffirmation(id);
    await notificationSettingController.getAffirmationAlarm();
  }
  double currentTime = 0.0; // Current position of the audio
  double totalTime = 100.0;

final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          appBar: CustomAppBar(
            title: "Alarm".tr,
            showBack: true,
          ),
            body: Stack(
              children: [
                GetBuilder<NotificationSettingController>(
                  id: "update",
                  builder: (controller) {
                    return  (controller.alarmModel.data??[]).isNotEmpty
                        ? SingleChildScrollView(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.alarmModel.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: themeController.isDarkMode.isTrue
                                          ? ColorConstant.textfieldFillColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${controller.alarmModel.data?[index].hours}:${controller.alarmModel.data?[index].minutes} ",
                                            style: Style.nunRegular(
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            controller
                                                    .alarmModel.data?[index].time ??
                                                "",
                                            style: Style.nunRegular(
                                              fontSize: 22,
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              controller.audioPlayer.seek(Duration.zero);
                                              _showAlertDialogPlayPause(context,
                                                  index: index,
                                                  mp3: controller.alarmModel
                                                          .data?[index].audioFile ??
                                                      "",
                                                  title: controller.alarmModel
                                                          .data?[index].name ??
                                                      "",
                                                  des: controller
                                                          .alarmModel
                                                          .data?[index]
                                                          .description ??
                                                      "");
                                            },
                                            child: SvgPicture.asset(
                                              ImageConstant.playAffirmation,
                                              height: 18,
                                              width: 18,
                                              color:
                                                  themeController.isDarkMode.isTrue
                                                      ? ColorConstant.white
                                                      : Colors.black,
                                            ),
                                          ),
                                          Dimens.d10.spaceWidth,
                                          GestureDetector(
                                            onTap: () {
                                              selectedHour = controller.alarmModel
                                                  .data![index].hours ??
                                                  0;
                                              selectedMinute = controller
                                                  .alarmModel
                                                  .data![index]
                                                  .minutes ??
                                                  0;
                                              selectedSeconds = controller
                                                  .alarmModel
                                                  .data![index]
                                                  .seconds ??
                                                  0;
                                              if (controller.alarmModel
                                                  .data![index].time ==
                                                  "AM") {
                                                am = true;
                                                pm = false;
                                              } else {
                                                pm = true;
                                                am = false;
                                              }
                                              setState(() {
                                                debugPrint("selectedSeconds $selectedSeconds");
                                                debugPrint("selectedMinute $selectedMinute");
                                                debugPrint("selectedHour $selectedHour");


                                              });
                                              setState.call(() {


                                              });
                                              _showAlertDialog(context, controller
                                                  .alarmModel.data![index].id
                                                /*
                                                  title: "",

                                                  id: controller
                                                      .alarmModel.data![index].id,
                                                  second: selectedSeconds*/);
                                            },
                                            child: SvgPicture.asset(
                                              ImageConstant.editTools,
                                              height: 18,
                                              width: 18,
                                              color:
                                                  themeController.isDarkMode.isTrue
                                                      ? ColorConstant.white
                                                      : Colors.black,
                                            ),
                                          ),
                                          Dimens.d10.spaceWidth,
                                          GestureDetector(
                                            onTap: () {
                                              _showAlertDialogDelete(
                                                  context,
                                                  index,
                                                  true,
                                                  controller
                                                      .alarmModel.data?[index].id);
                                            },
                                            child: SvgPicture.asset(
                                              ImageConstant.delete,
                                              height: 18,
                                              width: 18,
                                              color:
                                                  themeController.isDarkMode.isTrue
                                                      ? ColorConstant.white
                                                      : Colors.black,
                                            ),
                                          ),
                                          Dimens.d10.spaceWidth,
                                        ],
                                      ),
                                      Text(
                                        controller.alarmModel.data?[index].name ??
                                            "",
                                        style: Style.nunRegular(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Dimens.d10.spaceHeight,
                                      Text(
                                        maxLines: 2,
                                        controller.alarmModel.data?[index]
                                                .description ??
                                            "",
                                        style: Style.nunRegular(fontSize: 14),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: SizedBox(
                              height: Get.height - 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    themeController.isDarkMode.isTrue?ImageConstant.darkData:ImageConstant
                                        .noData,height: 158,width: 200,),
                                  Text(
                                    "dataNotFound".tr,
                                    style: Style.montserratBold(fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                          );
                  },
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
            )),
        GetBuilder<NotificationSettingController>(
          id: "update",
          builder: (controller) {
            return controller.loader.isTrue
                ? commonLoader()
                : const SizedBox();
          },)
      ],
    );
  }

  void _showAlertDialogDelete(
      BuildContext context, int index, bool value, String? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(contentPadding: EdgeInsets.zero,
          backgroundColor:themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          content: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Dimens.d18.spaceHeight,
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SvgPicture.asset(
                          ImageConstant.close,color: themeController.isDarkMode.isTrue?ColorConstant.white:ColorConstant.black,
                        ),
                      ))),
              Dimens.d23.spaceHeight,

              Center(
                  child: SvgPicture.asset(
                    ImageConstant.deleteAffirmation,
                    height: Dimens.d96,
                    width: Dimens.d96,
                  )),
              Dimens.d26.spaceHeight,
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                      textAlign: TextAlign.center,
                      "areYouSureDeleteAlarm".tr,
                      style: Style.nunRegular(
                        fontSize: Dimens.d15,
                      )),
                ),
              ),
              Dimens.d24.spaceHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),

                  CommonElevatedButton(
                    height: 33,width: 94,

                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: Dimens.d28),
                    textStyle: Style.nunRegular(
                        fontSize: Dimens.d12, color: ColorConstant.white),
                    title: "delete".tr,
                    onTap: () async {
                      if (await isConnected()) {
                        deleteAlarm(id);
                      } else {
                        showSnackBarError(context, "noInternet".tr);
                      }

                      setState(() {});
                      Get.back();
                    },
                  ),
                  Dimens.d20.spaceWidth,
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 33,width: 93,

                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 21,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(color: ColorConstant.themeColor)),
                      child: Center(
                        child: Text(
                          "cancel".tr,
                          style: Style.nunRegular(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                ],
              ),
              Dimens.d20.spaceHeight,

            ],),
        );
      },
    );

  }

  void _showAlertDialogPlayPause(BuildContext context,
      {String? title, String? des, String? mp3,int? index}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: ()async{
            notificationSettingController.audioPlayer.pause();
            return true;
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              setState.call((){});
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: themeController.isDarkMode.isTrue
                    ? ColorConstant.textfieldFillColor
                    : ColorConstant.backGround,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.0), // Set border radius
                ),
                content: SizedBox(
                  height: Dimens.d120,
                  width: Get.width,
                  child: Column(
                    children: [
                      Dimens.d14.spaceHeight,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Dimens.d20.spaceWidth,
                            Text(
                              "Audio".tr,
                              style: Style.cormorantGaramondBold(fontSize: 20),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  notificationSettingController.audioPlayer.pause();

                                  Get.back();
                                  setState.call((){});

                                },
                                child: SvgPicture.asset(
                                  ImageConstant.close,
                                  color: themeController.isDarkMode.isTrue
                                      ? ColorConstant.white
                                      : ColorConstant.black,
                                )),
                            Dimens.d20.spaceWidth,
                          ],
                        ),
                      ),
                      Dimens.d15.spaceHeight,
                      GetBuilder<NotificationSettingController>(
                        id: "Slide",
                        builder: (controller) {
                          final currentPosition =
                              controller.positionStream.value ??
                                  Duration.zero;

                          final duration =
                              controller.durationStream.value ??
                                  Duration.zero;
                          return Container(
                            height: Dimens.d46,
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode.isTrue?ColorConstant.color394750:ColorConstant.white),
                            child: Row(
                              children: [
                                Dimens.d10.spaceWidth,
                                GestureDetector(
                                  onTap: () async {
                                    if( (notificationSettingController.alarmModel
                                        .data?[index ?? 0].sound ?? 0) ==0){
                                      await notificationSettingController.setUrl(
                                          ImageConstant.bgAudio1
                                        //"https://media.shoorah.io/admins/shoorah_pods/audio/1682951517-7059.mp3"
                                      );
                                    }
                                    else
                                    {
                                      await notificationSettingController.setUrl(
                                          ImageConstant.bgAudio2
                                        //"https://media.shoorah.io/admins/shoorah_pods/audio/1682951517-7059.mp3"
                                      );
                                    }

                                    if (notificationSettingController.isPlaying.value) {
                                      await notificationSettingController
                                          .pause();
                                      notificationSettingController.update();
                                    } else {
                                      await notificationSettingController
                                          .play();
                                      notificationSettingController.update();

                                    }
                                    setState((){

                                    });
                                    setState.call((){

                                    });
                                  },
                                  child: Container(
                                    height: 28,
                                    width: 28,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorConstant.themeColor),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        notificationSettingController.isPlaying.value
                                            ? ImageConstant.pauseAudio
                                            : ImageConstant.play,
                                        height: 10,
                                        width: 10,
                                        color:  themeController.isDarkMode.isTrue?Colors.white:ColorConstant.black,
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor:
                                      ColorConstant.white.withOpacity(0.2),
                                      inactiveTrackColor:
                                      ColorConstant.colorADADAD,
                                      trackHeight: 1.5,
                                      thumbColor: ColorConstant.themeColor,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 8.0, // Decrease thumb height by adjusting the radius
                                      ),
                                      // Customize the overlay shape and size
                                    ),
                                    child: Slider(
                                      thumbColor: ColorConstant.themeColor,
                                      min: 0,
                                      activeColor: ColorConstant.themeColor,
                                      onChanged: (double value) {
                                        setState.call(() {
                                          controller
                                              .seekForMeditationAudio(
                                              position: Duration(
                                                  milliseconds:
                                                  value.toInt()));
                                        });
                                        setState(() {});
                                      },
                                      value: currentPosition.inMilliseconds
                                          .toDouble(),
                                      max: duration.inMilliseconds.toDouble(),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState.call(() {
                                        soundMute = !soundMute;
                                        if (soundMute) {
                                          notificationSettingController.audioPlayer.setVolume(0);
                                        } else {
                                          notificationSettingController.audioPlayer.setVolume(1);
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      soundMute
                                          ? ImageConstant.soundMute
                                          : ImageConstant.soundMax,
                                      height: Dimens.d22,
                                      width: Dimens.d22,
                                      color:  themeController.isDarkMode.isTrue?Colors.white:Colors.black,
                                    )),
                                Dimens.d10.spaceWidth,
                              ],
                            ),
                          );
                        }
                      ),
                      Dimens.d10.spaceHeight,
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        affirmationController = Get.put(AffirmationController());

        affirmationController.audioPlayer.pause();
      });
    },);
  }

  void _showAlertDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor:Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              actions: <Widget>[
                Dimens.d18.spaceHeight,
                Row(
                  children: [
                    Text(
                      "editAlarms".tr,
                      style: Style.nunRegular(fontSize: 20),
                    ),
                    const Spacer(),
                    Container(
                      height: 26,
                      width: Dimens.d100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(color: ColorConstant.colorBFBFBF)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {

                              setState.call(() {
                                selectedHour = 1;
                                selectedMinute = 1;
                                selectedSeconds = 1;
                                am = true;
                                pm = false;
                              });
                            },
                            child: Container(
                                width: Dimens.d49,
                                decoration: BoxDecoration(
                                    color: am == true
                                        ? ColorConstant.themeColor
                                        :themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor: ColorConstant.white,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Center(
                                  child: Text(
                                    "AM",
                                    style: Style.nunRegular(
                                        fontSize: 12,
                                        color: am == true
                                            ? ColorConstant.white
                                            :themeController.isDarkMode.isTrue?ColorConstant.white: ColorConstant.black),
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState.call(() {
                                selectedHour = 1;
                                selectedMinute = 1;
                                selectedSeconds = 1;
                                am = false;
                                pm = true;
                              });
                            },
                            child: Container(
                                height: 26,
                                width: Dimens.d49,
                                decoration: BoxDecoration(
                                    color: pm == true
                                        ? ColorConstant.themeColor
                                        :themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor: ColorConstant.white,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Center(
                                  child: Text(
                                    "PM",
                                    style: Style.nunRegular(
                                        fontSize: 12,
                                        color: pm == true
                                            ? ColorConstant.white
                                            : themeController.isDarkMode.isTrue?ColorConstant.white: ColorConstant.black),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Dimens.d15.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Dimens.d30.spaceWidth,
                    Text(
                      "hours".tr,
                      style: Style.nunRegular(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      "minutes".tr,
                      style: Style.nunRegular(fontSize: 14),
                    ),
                    const Spacer(),

                    Text(
                      "seconds".tr,
                      style: Style.nunRegular(fontSize: 14),
                    ),
                    Dimens.d20.spaceWidth,

                  ],
                ),
                Dimens.d10.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      NumberPicker(
                        infiniteLoop: true,
                        zeroPad: true,
                        value: selectedHour,
                        minValue: 0,
                        textStyle: Style.nunRegular(
                          fontSize: 14,
                          color: ColorConstant.colorCACACA,
                        ),
                        selectedTextStyle: Style.montserratBold(
                          fontSize: 22,
                          color: ColorConstant.themeColor,
                        ),
                        maxValue: am ? 12 : 24,
                        itemHeight: 50,
                        itemWidth: 50,
                        onChanged: (value) =>
                            setState(() => selectedHour = value),
                      ),
                      const Spacer(),
                      numericSymbol(),
                      const Spacer(),
                      NumberPicker(
                        infiniteLoop: true,
                        zeroPad: true,
                        value: selectedMinute,
                        minValue: 0,
                        itemHeight: 50,
                        itemWidth: 50,
                        textStyle: Style.nunRegular(
                          fontSize: 14,
                          color: ColorConstant.colorCACACA,
                        ),
                        selectedTextStyle: Style.montserratBold(
                          fontSize: 22,
                          color: ColorConstant.themeColor,
                        ),
                        maxValue: 59,
                        onChanged: (value) =>
                            setState(() => selectedMinute = value),
                      ),
                      const Spacer(),
                      numericSymbol(),
                      const Spacer(),
                      NumberPicker(
                        infiniteLoop: true,
                        zeroPad: true,
                        value: selectedSeconds,
                        minValue: 0,
                        itemHeight: 50,
                        itemWidth: 50,
                        textStyle: Style.nunRegular(
                          fontSize: 14,
                          color: ColorConstant.colorCACACA,
                        ),
                        selectedTextStyle: Style.montserratBold(
                          fontSize: 22,
                          color: ColorConstant.themeColor,
                        ),
                        maxValue: 59,
                        onChanged: (value) =>
                            setState(() => selectedSeconds = value),
                      ),
                    ],
                  ),

                ),

                GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AudioList();
                  },));
                },
                  child: Container(
                    height: Dimens.d51,
                    width: Get.width,
                    decoration:
                    BoxDecoration(color: themeController.isDarkMode.isTrue?ColorConstant.color394750:ColorConstant.backGround,borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Dimens.d14.spaceWidth,
                        Text(
                          "sound".tr,
                          style: Style.nunRegular(fontSize: 14,color:themeController.isDarkMode.isTrue?ColorConstant.white: ColorConstant.black),
                        ),
                        const Spacer(),
                        Text(
                          "default".tr,
                          style: Style.nunRegular(
                              fontSize: 14, color:themeController.isDarkMode.isTrue?ColorConstant.white: ColorConstant.color787878),
                        ),
                        SvgPicture.asset(
                          ImageConstant.settingArrowRight,
                          color: themeController.isDarkMode.isTrue?Colors.white:ColorConstant.color787878,
                          height: 25,
                        ),
                        Dimens.d14.spaceWidth,
                      ],
                    ),
                  ),
                ),
                Dimens.d20.spaceHeight,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                  child: CommonElevatedButton(height: 38,width: 153,
                    textStyle: Style.nunRegular(
                        fontSize: Dimens.d16, color: ColorConstant.white),
                    title: "update".tr,
                    onTap: () async {
                    if(Platform.isIOS){
                      downloadAudioFile("https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3");

                        //_setAlarm(1, "assets/audio/audio.mp3");
                      }else{
                        _setAlarm(1, "assets/audio/audio.mp3");

                        //downloadAudioFile("https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3");

                    }

                      await notificationSettingController.editAffirmation(
                          context: context,
                          id: id,
                          seconds: selectedSeconds,
                          minutes: selectedMinute,
                          hours: selectedHour,
                          time: am==true?"AM":"PM");
                      await notificationSettingController.getAffirmationAlarm();
                    },
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }


  Widget numericSymbol() {
    return Text(":",
        style: Style.montserratBold(
            fontSize: 22, color: ColorConstant.themeColor));
  }
  Future<void> downloadAudioFile(String url) async {
    // Get the download path
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/audio_file.mp3';

    // Download the file
    final response = await http.get(Uri.parse(url));

    // Check if the file was downloaded successfully
    if (response.statusCode == 200) {
      // Save the file to the download path
      response.bodyBytes.first;
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      _setAlarm(1,filePath);
      print('Audio file downloaded and saved to $filePath');
    } else {
      print('Failed to download audio file');
    }
  }
}
