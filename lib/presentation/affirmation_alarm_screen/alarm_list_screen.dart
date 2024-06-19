import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
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
  int selectedHourIndex = 0;
  int selectedMinute = 0;
  int selectedSeconds = 0;
  bool soundMute = false;
  bool playPause = false;
  List affirmationList = [];
  final String audioFilePath = 'assets/audio/audio.mp3';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.black
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "Alarm".tr,
        showBack: true,

      ),
      body: Column(children: [
        Dimens.d10.spaceHeight,
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: affirmationList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {

                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          "9:30",
                          style: Style.montserratRegular(
                            fontSize: 30,
                          ),
                        ), Text(
                          " PM",
                          style: Style.montserratRegular(
                            fontSize: 22,
                          ),
                        ),
                        const Spacer(),
                            GestureDetector(
                              onTap: () {
                                _showAlertDialogPlayPause(context,
                                    title: affirmationList[index]["title"],
                                    des: affirmationList[index]["des"]);
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
                            _showAlertDialog(context);

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
                                _showAlertDialogDelete(context, index, true);
                              },
                          child: SvgPicture.asset(
                            ImageConstant.delete,
                            height: 18,
                            width: 18,
                            color: ColorConstant.black,
                          ),
                        ),
                        Dimens.d10.spaceWidth,
                      ],),
                      Text(
                        affirmationList[index]["title"],
                          style: Style.montserratRegular(
                            fontSize: 18,
                        ),
                      ),
                      Dimens.d10.spaceHeight,
                      Text(
                        affirmationList[index]["des"],
                        style: Style.montserratRegular(fontSize: 11),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ],),
    );
  }

  void _showAlertDialogDelete(BuildContext context, int index, bool value) {
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
              height: Dimens.d140,
              width: Dimens.d140,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "Are you sure want to delete affirmation alarms ?".tr,
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
                    setState(() {
                      affirmationList.removeAt(index);
                    });
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
      {String? title, String? des}) {
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        title!,
                        style: Style.cormorantGaramondBold(fontSize: 20),
                      ),
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(ImageConstant.close))
                    ],
                  ),
                ),
                Dimens.d15.spaceHeight,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
                  decoration: BoxDecoration(
                    color: ColorConstant.backGround,
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        ColorConstant.colorAECFD8,
                        ColorConstant.color4A6972
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        des!,
                        style: Style.montserratRegular(fontSize: 11, height: 2),
                      ),
                      SvgPicture.asset(ImageConstant.playPause),
                    ],
                  ),
                ),
                Dimens.d10.spaceHeight,
              ],
            );
          },
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context, {String? title}) {
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
                      "Edit Alarms".tr,
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
                Dimens.d26.spaceHeight,
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
                Dimens.d26.spaceHeight,
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
                Dimens.d26.spaceHeight,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                  child: CommonElevatedButton(
                    textStyle: Style.montserratRegular(
                        fontSize: Dimens.d12, color: ColorConstant.white),
                    title: "save".tr,
                    onTap: () {
                      Get.back();
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
