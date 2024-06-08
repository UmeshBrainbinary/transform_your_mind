import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
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
                        Dimens.d10.spaceWidth,
                        GestureDetector(
                          onTap: () {
                            _showAlertDialog(context);

                            /*       Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddAffirmationPage(
                                  isEdit: true,
                                  title: affirmationList[index]["title"],
                                  des: affirmationList[index]["des"],
                                  isFromMyAffirmation: true,
                                );
                              },
                            ));*/
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
                            affirmationList.removeAt(index);
                            setState(() {

                            });
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
                        style: Style.cormorantGaramondBold(
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
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: affirmationDraftList.length,
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
                        Dimens.d10.spaceWidth,
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddAffirmationPage(
                                  isEdit: true,
                                  title: affirmationDraftList[index]["title"],
                                  des: affirmationDraftList[index]["des"],
                                  isFromMyAffirmation: true,
                                );
                              },
                            ));
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
                            affirmationDraftList.removeAt(index);
                            setState(() {

                            });
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
                        affirmationDraftList[index]["title"],
                        style: Style.cormorantGaramondBold(
                          fontSize: 18,
                        ),
                      ),
                      Dimens.d10.spaceHeight,
                      Text(
                        affirmationDraftList[index]["des"],
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
  void _showAlertDialog(BuildContext context) {
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
                      "New Alarms".tr,
                      style: Style.cormorantGaramondBold(fontSize: 20),
                    ),
                    const Spacer(),
                    Container(
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
                SizedBox(
                  height: 100,
                  width: Get.width,
                  child: CupertinoTimerPicker(
                    backgroundColor: Colors.transparent,
                    mode: CupertinoTimerPickerMode.hms,
                    initialTimerDuration: selectedDuration,
                    onTimerDurationChanged: (Duration newDuration) {
                      setState(() {
                        selectedDuration = newDuration;
                      });
                    },
                  ),
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

}
