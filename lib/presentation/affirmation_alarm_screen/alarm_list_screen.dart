import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/audio_list.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/notification_setting_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:voice_message_package/voice_message_package.dart';

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
  int selectedHourIndex = 0;
  int selectedMinute = 0;
  int selectedSeconds = 0;
  bool soundMute = false;
  bool playPause = false;

  final String audioFilePath = 'assets/audio/audio.mp3';
  NotificationSettingController notificationSettingController =
      Get.put(NotificationSettingController());

  @override
  void initState() {
    getAlarm();
    super.initState();
  }

  getAlarm() async {
    await notificationSettingController.getAffirmationAlarm();
  }

  deleteAlarm(id) async {
    await notificationSettingController.deleteAffirmation(id);
    await notificationSettingController.getAffirmationAlarm();
  }

  @override
  Widget build(BuildContext context) {
    //statusBarSet(themeController);

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
            body: GetBuilder<NotificationSettingController>(
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
                                  color: ColorConstant.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${controller.alarmModel.data?[index].hours}:${controller.alarmModel.data?[index].minutes} ",
                                        style: Style.montserratRegular(
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        controller
                                                .alarmModel.data?[index].time ??
                                            "",
                                        style: Style.montserratRegular(
                                          fontSize: 22,
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          _showAlertDialogPlayPause(context,
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
                                        ),
                                      ),
                                      Dimens.d10.spaceWidth,
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
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
                                            } else {
                                              pm = true;
                                            }
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
                                          color: ColorConstant.black,
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
                                          color: ColorConstant.black,
                                        ),
                                      ),
                                      Dimens.d10.spaceWidth,
                                    ],
                                  ),
                                  Text(
                                    controller.alarmModel.data?[index].name ??
                                        "",
                                    style: Style.montserratRegular(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Dimens.d10.spaceHeight,
                                  Text(
                                    controller.alarmModel.data?[index]
                                            .description ??
                                        "",
                                    style:
                                        Style.montserratRegular(fontSize: 11),
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
        return AlertDialog(
          //backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          actions: <Widget>[
            Dimens.d18.spaceHeight,
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      ImageConstant.close,
                    ))),
            Center(
                child: SvgPicture.asset(
              ImageConstant.deleteAffirmation,
              height: Dimens.d96,
              width:  Dimens.d96,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "areYouSureDeleteAlarm".tr,
                  style: Style.montserratRegular(
                    fontSize: Dimens.d14,
                  )),
            ),
            Dimens.d24.spaceHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonElevatedButton(
                  height: 33,
                  textStyle: Style.montserratRegular(
                      fontSize: Dimens.d12, color: ColorConstant.white),
                  title: "Delete".tr,
                  onTap: () {
                    deleteAlarm(id);
                    setState(() {});
                    Get.back();
                  },
                ),
                Container(
                  height: 33,
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
                      style: Style.montserratRegular(fontSize: 14),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void _showAlertDialogPlayPause(BuildContext context,
      {String? title, String? des, String? mp3}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              backgroundColor: ColorConstant.backGround,
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
                                Get.back();
                              },
                              child: SvgPicture.asset(ImageConstant.close)),
                          Dimens.d20.spaceWidth,
                        ],
                      ),
                    ),
                    Dimens.d15.spaceHeight,
                    Container(
                      height: Dimens.d46,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConstant.white),
                      child: Row(
                        children: [
                          Dimens.d10.spaceWidth,
                          Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstant.themeColor),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState.call(() {
                                    playPause = !playPause;
                                  });
                                },
                                child: SvgPicture.asset(
                                  playPause
                                      ? ImageConstant.pauseAudio
                                      : ImageConstant.play,
                                  height: 10,
                                  width: 10,
                                  color: ColorConstant.black,
                                ),
                              ),
                            ),
                          ),
                          /*  Dimens.d10.spaceWidth,
                          Text("0:32",style: Style.montserratRegular(fontSize: 11),),
                          Dimens.d10.spaceWidth,*/
                          VoiceMessageView(
                            size: 0.0,
                            controller: VoiceController(
                              audioSrc: mp3!,
                              onComplete: () {
                                /// do something on complete
                              },
                              onPause: () {
                                /// do something on pause
                              },
                              onPlaying: () {
                                /// do something on playing
                              },
                              maxDuration: const Duration(minutes: 5),
                              isFile: false,
                            ),
                            activeSliderColor: ColorConstant.themeColor,
                            innerPadding: 0.0,
                            cornerRadius: 0.0,
                            circlesColor: Colors.transparent,
                            circlesTextStyle: const TextStyle(fontSize: 0.0),
                            counterTextStyle: const TextStyle(fontSize: 0.0),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState.call(() {
                                  soundMute = !soundMute;
                                });
                              },
                              child: SvgPicture.asset(
                                soundMute
                                    ? ImageConstant.soundMute
                                    : ImageConstant.soundMax,
                                height: Dimens.d22,
                                width: Dimens.d22,
                              )),
                          Dimens.d10.spaceWidth,
                        ],
                      ),
                    ),
                    Dimens.d10.spaceHeight,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  void _showAlertDialog(BuildContext context, id, {String? title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              //backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              actions: <Widget>[
                Dimens.d18.spaceHeight,
                Row(
                  children: [
                    Text(
                      "newAlarms".tr,
                      style: Style.montserratRegular(fontSize: 20),
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
                                am = true;
                                pm = false;
                              });
                            },
                            child: Container(
                                width: Dimens.d49,
                                decoration: BoxDecoration(
                                    color: am == true
                                        ? ColorConstant.themeColor
                                        : ColorConstant.white,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Center(
                                  child: Text(
                                    "AM",
                                    style: Style.montserratRegular(
                                        fontSize: 12,
                                        color: am == true
                                            ? ColorConstant.white
                                            : ColorConstant.black),
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState.call(() {
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
                                        : ColorConstant.white,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Center(
                                  child: Text(
                                    "PM",
                                    style: Style.montserratRegular(
                                        fontSize: 12,
                                        color: pm == true
                                            ? ColorConstant.white
                                            : ColorConstant.black),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Dimens.d10.spaceHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "hours".tr,
                      style: Style.montserratRegular(fontSize: 12),
                    ),
                    Text(
                      "minutes".tr,
                      style: Style.montserratRegular(fontSize: 12),
                    ),
                    Text(
                      "seconds".tr,
                      style: Style.montserratRegular(fontSize: 12),
                    ),
                  ],
                ),
                Dimens.d10.spaceHeight,

                Row(
                  children: [
                    NumberPicker(
                      zeroPad: true,
                      value: selectedHour,
                      minValue: 0,
                      textStyle: Style.montserratRegular(
                          fontSize: 14, color: ColorConstant.colorCACACA),
                      selectedTextStyle: Style.montserratBold(
                          fontSize: 22, color: ColorConstant.themeColor),
                      maxValue: 24,
                      itemHeight: 50,
                      itemWidth: 50,
                      onChanged: (value) =>
                          setState(() => selectedHour = value),
                    ),
                    const Spacer(),
                    numericSymbol(),
                    const Spacer(),
                    NumberPicker(
                      zeroPad: true,
                      value: selectedMinute,
                      minValue: 0,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: Style.montserratRegular(
                          fontSize: 14, color: ColorConstant.colorCACACA),
                      selectedTextStyle: Style.montserratBold(
                          fontSize: 22, color: ColorConstant.themeColor),
                      maxValue: 60,
                      onChanged: (value) =>
                          setState(() => selectedMinute = value),
                    ),
                    const Spacer(),
                    numericSymbol(),
                    const Spacer(),
                    NumberPicker(
                      zeroPad: true,
                      value: selectedSeconds,
                      minValue: 0,
                      itemHeight: 50,
                      itemWidth: 50,
                      textStyle: Style.montserratRegular(
                          fontSize: 14, color: ColorConstant.colorCACACA),
                      selectedTextStyle: Style.montserratBold(
                          fontSize: 22, color: ColorConstant.themeColor),
                      maxValue: 60,
                      onChanged: (value) =>
                          setState(() => selectedSeconds = value),
                    ),
                  ],
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
                    BoxDecoration(color: ColorConstant.backGround,borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Dimens.d14.spaceWidth,
                        Text(
                          "sound".tr,
                          style: Style.montserratRegular(fontSize: 14),
                        ),
                        const Spacer(),
                        Text(
                          "default".tr,
                          style: Style.montserratRegular(
                              fontSize: 14, color: ColorConstant.color787878),
                        ),
                        SvgPicture.asset(ImageConstant.settingArrowRight,color: ColorConstant.color787878,),
                        Dimens.d14.spaceWidth,

                      ],
                    ),
                  ),
                ),
                Dimens.d20.spaceHeight,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                  child: CommonElevatedButton(
                    textStyle: Style.montserratRegular(
                        fontSize: Dimens.d12, color: ColorConstant.white),
                    title: "save".tr,
                    onTap: () async {
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
}
