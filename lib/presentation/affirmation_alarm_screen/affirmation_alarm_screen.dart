import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/affirmation_controller.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/alarm_list_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/affirmation_share_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AffirmationAlarmScreen extends StatefulWidget {
  const AffirmationAlarmScreen({super.key});

  @override
  State<AffirmationAlarmScreen> createState() => _AffirmationAlarmScreenState();
}

class _AffirmationAlarmScreenState extends State<AffirmationAlarmScreen> {
  ValueNotifier selectedCategory = ValueNotifier(null);
  ThemeController themeController = Get.find<ThemeController>();
  AffirmationController affirmationController =
      Get.put(AffirmationController());
  List categoryList = [
    {"title": "Self-Esteem"},
    {"title": "Health"},
    {"title": "Success"},
  ];
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
        title: "affirmationAlarms".tr,
        showBack: true,
        action: Padding(
          padding: const EdgeInsets.only(right: Dimens.d20),
          child: GestureDetector(
            onTap: () {
              _onAddClick(context);
            },
            child: SvgPicture.asset(
              ImageConstant.addTools,
              height: Dimens.d22,
              width: Dimens.d22,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Dimens.d30.spaceHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildCategoryDropDown(context),
                Dimens.d20.spaceWidth,
                alarmView(),
              ],
            ),
          ),
          Dimens.d20.spaceHeight,
          SingleChildScrollView(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: affirmationList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AffirmationShareScreen(
                          des: affirmationList[index]["des"],
                          title: affirmationList[index]["title"],
                        );
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: ColorConstant.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                affirmationList[index]["title"],
                                style: Style.cormorantGaramondBold(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showAlertDialog(context);
                              },
                              child: SvgPicture.asset(
                                ImageConstant.alarm,
                                height: 18,
                                width: 18,
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return AddAffirmationPage(
                                      isEdit: true,
                                      title: affirmationList[index]["title"],
                                      des: affirmationList[index]["des"],
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
                              onTap: () {},
                              child: SvgPicture.asset(
                                ImageConstant.likeTools,
                                height: 18,
                                width: 18,
                                color: ColorConstant.black,
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                          ],
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
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AffirmationShareScreen(
                          des: affirmationDraftList[index]["des"],
                          title: affirmationDraftList[index]["title"],
                        );
                      },
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: ColorConstant.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                affirmationDraftList[index]["title"],
                                style: Style.cormorantGaramondBold(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showAlertDialog(context);
                              },
                              child: SvgPicture.asset(
                                ImageConstant.alarm,
                                height: 18,
                                width: 18,
                              ),
                            ),
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
                              onTap: () {},
                              child: SvgPicture.asset(
                                ImageConstant.likeTools,
                                height: 18,
                                width: 18,
                                color: ColorConstant.black,
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                          ],
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
        ],
      ),
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

  Widget _buildCategoryDropDown(BuildContext context) {
    return Expanded(
      child: Container(
        height: Dimens.d38,
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.lightGrey),
          borderRadius: BorderRadius.circular(30),
          color: ColorConstant.themeColor,
        ),
        child: DropdownButton(
          value: selectedCategory.value,
          borderRadius: BorderRadius.circular(30),
          onChanged: (value) {
            {
              setState(() {
                selectedCategory.value = value;
              });
            }
          },
          selectedItemBuilder: (_) {
            return categoryList.map<Widget>((item) {
              bool isSelected =
                  selectedCategory.value?["title"] == item["title"];
              return Padding(
                padding: const EdgeInsets.only(left: 18, top: 8),
                child: Text(
                  item["title"] ?? '',
                  style: Style.montserratRegular(
                    fontSize: Dimens.d14,
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              );
            }).toList();
          },
          style: Style.montserratRegular(
            fontSize: Dimens.d12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          hint: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "selectCategory".tr,
              style: Style.montserratRegular(
                  fontSize: Dimens.d12, color: Colors.white),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SvgPicture.asset(
              ImageConstant.icDownArrow,
              height: 20,
              color: Colors.white,
            ),
          ),
          elevation: 16,
          itemHeight: 50,
          menuMaxHeight: 350.h,
          underline: const SizedBox(
            height: 0,
          ),
          isExpanded: true,
          dropdownColor: ColorConstant.colorECF1F3,
          items: categoryList.map<DropdownMenuItem>((item) {
            bool isSelected = selectedCategory.value?["title"] == item["title"];
            return DropdownMenuItem(
              value: item,
              child: AnimatedBuilder(
                animation: selectedCategory,
                builder: (BuildContext context, Widget? child) {
                  return child!;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    item["title"] ?? '',
                    style: Style.montserratRegular(
                      fontSize: Dimens.d14,
                      color: ColorConstant.textGreyColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget alarmView() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const AlarmListScreen();
          },
        )).then(
          (value) {
            setState(() {});
          },
        );
      },
      child: Container(
        height: Dimens.d35,
        padding: const EdgeInsets.symmetric(horizontal: 44),
        decoration: BoxDecoration(
            color: ColorConstant.themeColor,
            borderRadius: BorderRadius.circular(40)),
        child: Center(
          child: Text(
            "Alarm List".tr,
            style: Style.montserratRegular(
                fontSize: 12, color: ColorConstant.white),
          ),
        ),
      ),
    );
  }

  void _onAddClick(BuildContext context) {
    final subscriptionStatus = "SUBSCRIBED";

    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
      /*  Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const AddAffirmationPage(
            isFromMyAffirmation: true,
            isEdit: false,
          );
        },
      )).then(
        (value) {
          setState(() {});
        },
      );
    }
  }
}