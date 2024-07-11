import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http ;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_gratitude_page.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../../../core/utils/style.dart';
class AddGratitudePage extends StatefulWidget {
  AddGratitudePage(
      {super.key,
      this.isSaved,
      this.isFromMyGratitude,
      this.registerUser,
      this.edit,
      this.title,
      this.description,
      this.id,
      this.categoryList,
      this.date});

  final bool? isFromMyGratitude;
  final bool? isSaved;
  final bool? registerUser;
  final bool? edit;
  String? title;
  String? description;
  DateTime? date;
  String? id;
  List? categoryList;
  @override
  State<AddGratitudePage> createState() => _AddGratitudePageState();
}

class _AddGratitudePageState extends State<AddGratitudePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool drop = false;
  ThemeController themeController = Get.find<ThemeController>();
  List addGratitudeData = [];
  bool select = false;

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  ValueNotifier<int> currentLength = ValueNotifier(0);
  String? urlImage;
  int gratitudeAddedCount = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime todayDate = DateTime.now();
  bool? loader = false;
  File? selectedImage;
  DateTime _currentDate = DateTime.now();
  ValueNotifier selectedCategory = ValueNotifier(null);

  @override
  void initState() {
/*    if ((widget.categoryList ?? []).isNotEmpty) {}
    if (widget.edit == true) {
      setState(() {
        titleController.text = widget.title!;
        descController.text = widget.description!;
        dateController.text = DateFormat('dd/MM/yyyy').format(widget.date!);
      });
    }*/
    if ((widget.categoryList ?? []).isNotEmpty) {
      setState(() {
        addGratitudeData = widget.categoryList!;
      });
    }
    super.initState();
  }
  CommonModel commonModel = CommonModel();

  addGratitude(bool? registerUser) async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}add-gratitude'));
    request.body = json.encode({
      "name": titleController.text,
      "description":descController.text,
      "date": dateController.text = DateFormat('dd/MM/yyyy').format(todayDate),
      "created_by":PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      commonModel = commonModelFromJson(responseBody);
      if (registerUser == true) {
        Get.offAllNamed( AppRoutes.dashBoardScreen);
      } else {
        Get.back();
      }
      showSnackBarSuccess(context, "gratitudeAdded".tr);
    } else {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message??"");

    }
    setState(() {
      loader = false;
    });
  }
  updateGratitude() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'POST', Uri.parse('${EndPoints.baseUrl}update-gratitude?id=${widget.id}'));
    request.body = json.encode({
      "name": titleController.text,
      "description":descController.text,
      "date": dateController.text,
      "created_by":PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      commonModel = commonModelFromJson(responseBody);
      Get.back();
      showSnackBarSuccess(context, "gratitudeUpdate".tr);
    } else {
      final responseBody = await response.stream.bytesToString();
      setState(() {
        loader = false;
      });
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message??"");

    }
    setState(() {
      loader = false;
    });
  }

  TextEditingController addGratitudeText = TextEditingController();
  FocusNode gratitudeFocus = FocusNode();
  int totalIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            showBack: widget.registerUser! ? false : true,
            title: widget.edit == true ? "editGratitude".tr : "addGratitude".tr,
            action: !(widget.isFromMyGratitude!)
                ? Row(children: [
                    GestureDetector(
                        onTap: () {},
                        child: Text(
                          "skip".tr,
                          style: Style.montserratRegular(
                              color: themeController.isDarkMode.value
                                  ? ColorConstant.white
                                  : ColorConstant.black),
                        )),
                    Dimens.d20.spaceWidth,
                  ])
                : widget.registerUser!
                    ? GestureDetector(
                        onTap: () async {
                          await PrefService.setValue(
                              PrefKey.firstTimeRegister, true);
                          await PrefService.setValue(
                              PrefKey.addGratitude, true);

                       Get.offAllNamed( AppRoutes.dashBoardScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "skip".tr,
                    style: Style.montserratRegular(
                        fontSize: Dimens.d15,
                        color: themeController.isDarkMode.value
                            ? ColorConstant.white
                            : ColorConstant.black),
                  ),
                ))
                : const SizedBox.shrink(),
          ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Dimens.d20.spaceHeight,
                  Text(
                    "10Things".tr,
                    style: Style.montserratRegular(fontSize: 16),
                  ),
                  Dimens.d20.spaceHeight,
                  Expanded(
                    child: ListView.builder(
                      itemCount: addGratitudeData.length + 1,
                      // Increased the itemCount by 1 to accommodate the "+" icon
                      itemBuilder: (context, index) {
                        totalIndex = index;
                        if (index == addGratitudeData.length) {
                          return Column(
                            children: [
                              Dimens.d32.spaceHeight,
                              GestureDetector(
                                  onTap: () {
                                    if (totalIndex != 10) {
                                      addGratitudeText.clear();
                                      _showAlertDialog(
                                          context: context,
                                          value: false,
                                          index: index);
                                    } else {
                                      showSnackBarError(
                                          context, "youCanAdd10".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                      ImageConstant.addGratitude)),
                              Dimens.d32.spaceHeight,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CommonElevatedButton(
                                  textStyle: Style.montserratRegular(
                                      fontSize: 20, color: ColorConstant.white),
                                  title: "save".tr,
                                  onTap: () async {
                                    setState(() {
                                      gratitudeList = addGratitudeData;
                                    });
                                    Get.back();
                                  },
                                ),
                              ),
                              Dimens.d32.spaceHeight,
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: commonContainer(
                                des: addGratitudeData[index]["title"],
                                date: "${index + 1}",
                                day: "TUE",
                                index: index),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
            /*Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: LayoutContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextField(
                                  hintText: widget.registerUser!
                                      ? "enterCategory".tr
                                      : (widget.categoryList ?? []).isNotEmpty
                                          ? "enterSeCategory".tr
                                          : "enterCategory".tr,
                                  labelText: "Category".tr,
                                  controller: titleController,
                                  focusNode: titleFocus,
                                  nextFocusNode: descFocus,
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            drop = !drop;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          ImageConstant.downArrow,
                                          color: (widget.categoryList ?? [])
                                                  .isNotEmpty
                                              ? ColorConstant.black
                                              : Colors.transparent,
                                        )),
                                  ),
                                  validator: (value) {
                                    if (value == "") {
                                      return "pleaseEnterTitle".tr;
                                    }
                                    return null;
                                  },
                                ),
                                Dimens.d22.spaceHeight,
                                CommonTextField(
                                  hintText: "enterDescription".tr,
                                  labelText: "description".tr,
                                  controller: descController,
                                  focusNode: descFocus,
                                  transform:
                                      Matrix4.translationValues(0, -108, 0),
                                  prefixLottieIcon:
                                      ImageConstant.lottieDescription,
                                  maxLines: 15,
                                  maxLength: maxLengthDesc,
                                  onChanged: (value) {
                                    currentLength.value =
                                        descController.text.length;
                                  },
                                  validator: (value) {
                                    if (value == "") {
                                      return "pleaseEnterDescription".tr;
                                    }
                                    return null;
                                  },

                                ),
                                Dimens.d30.spaceHeight,
                                Row(
                                  children: [
                                    if (widget.edit == true)
                                      Expanded(
                                        child: CommonElevatedButton(
                                          title: "Cancel".tr,
                                          outLined: true,
                                          textStyle: Style.montserratRegular(
                                              color:
                                                  ColorConstant.textDarkBlue),
                                          onTap: () async {
                                            Get.back();
                                          },
                                        ),
                                      ),
                                    Dimens.d20.spaceWidth,
                                    Expanded(
                                      child: CommonElevatedButton(
                                         textStyle: Style.montserratRegular(fontSize: 20,color: ColorConstant.white),
                                        title: widget.edit == true
                                            ? "Update".tr
                                            : "save".tr,
                                        onTap: () async {
                                          titleFocus.unfocus();
                                          descFocus.unfocus();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (widget.edit == true) {
                                              updateGratitude();
                                            } else {
                                              PrefService.setValue(
                                                  PrefKey
                                                      .firstTimeUserGratitude,
                                                  true);

                                              addGratitude(widget.registerUser);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      ///buttons

                      Dimens.d10.spaceHeight,
                    ],
                  ),
                );
              }),
              if (drop)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(top: Dimens.d110, right: 20),
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode.isTrue
                          ? ColorConstant.textfieldFillColor
                          : ColorConstant.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // How much the shadow spreads
                          blurRadius: 5, // The blur radius of the shadow
                          offset: const Offset(
                              0, 3), // Changes the position of the shadow
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: widget.categoryList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: GestureDetector(
                              onTap: () {
                                titleController.text =
                                    widget.categoryList?[index] ?? "";
                                drop = false;
                                setState(() {});
                              },
                              child: Text(
                                widget.categoryList?[index] ?? "",
                                style: Style.gothamLight(fontSize: 14),
                              )),
                        );
                      },
                    ),
                  ),
                )
              else
                const SizedBox()
            ],
          ),*/
            ),
        loader == true ? commonLoader() : const SizedBox()
      ],
    );
  }

  void _showAlertDialog(
      {String? id, BuildContext? context, int? index, bool? value}) {
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Dimens.d10.spaceHeight,
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              ImageConstant.close,
                              height: 20,
                              width: 20,
                            ))),
                    Dimens.d15.spaceHeight,
                    CommonTextField(
                        borderRadius: Dimens.d10,
                        filledColor: themeController.isDarkMode.isTrue
                            ? ColorConstant.darkBackground
                            : ColorConstant.colorECECEC,
                        hintText: "typeGratitude".tr,
                        maxLines: 5,
                        controller: addGratitudeText,
                        focusNode: gratitudeFocus),
                    Dimens.d30.spaceHeight,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
                      child: CommonElevatedButton(
                        height: Dimens.d33,
                        textStyle: Style.montserratRegular(
                          fontSize: Dimens.d18,
                          color: ColorConstant.white,
                        ),
                        title: value == true ? "update".tr : "add".tr,
                        onTap: () async {
                          if (value == true) {
                            setState.call(() {
                              addGratitudeData[index!]["title"] =
                                  addGratitudeText.text;
                            });
                            Get.back();
                          } else {
                            setState.call(() {
                              addGratitudeData
                                  .add({"title": addGratitudeText.text});
                            });
                            Get.back();
                          }
                        },
                      ),
                    ),
                    Dimens.d20.spaceHeight,
                    value == false
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "cancel".tr,
                              style: Style.montserratRegular(fontSize: 14),
                            )),
                    value == false ? const SizedBox() : Dimens.d20.spaceHeight,
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then(
      (value) {
        setState(() {});
      },
    );
  }

  Widget commonContainer({String? date, String? day, String? des, int? index}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: themeController.isDarkMode.isTrue
            ? ColorConstant.textfieldFillColor
            : ColorConstant.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 63,
            width: 63,
            decoration: BoxDecoration(
              color: ColorConstant.themeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dimens.d3.spaceHeight,
                Text(
                  day ?? "",
                  style: Style.gothamLight(
                    fontSize: 10,
                    color: ColorConstant.white,
                  ),
                ),
                Text(
                  date ?? "",
                  style: Style.gothamMedium(
                    fontSize: 30,
                    color: ColorConstant.white,
                  ),
                ),
              ],
            ),
          ),
          Dimens.d13.spaceWidth,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Dimens.d2.spaceHeight,
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    color: themeController.isDarkMode.isTrue
                        ? ColorConstant.textfieldFillColor
                        : ColorConstant.white,
                    child: SvgPicture.asset(
                      ImageConstant.moreVert,
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  addGratitudeText.text = des!;
                                  _showAlertDialog(
                                      context: context,
                                      value: true,
                                      index: index);
                                },
                                child: Container(
                                  height: 28,
                                  width: 86,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConstant.color5B93FF
                                        .withOpacity(0.05),
                                  ),
                                  child: Row(
                                    children: [
                                      Dimens.d5.spaceWidth,
                                      SvgPicture.asset(
                                        ImageConstant.editTools,
                                        color: ColorConstant.color5B93FF,
                                      ),
                                      Dimens.d5.spaceWidth,
                                      Text(
                                        'edit'.tr,
                                        style: Style.montserratRegular(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.color5B93FF,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              Dimens.d15.spaceHeight,
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  _showAlertDialogDelete(context, 1, 0);
                                },
                                child: Container(
                                  height: 28,
                                  width: 86,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConstant.colorE71D36
                                        .withOpacity(0.05),
                                  ),
                                  child: Row(
                                    children: [
                                      Dimens.d5.spaceWidth,
                                      SvgPicture.asset(
                                        ImageConstant.delete,
                                        color: ColorConstant.colorE71D36,
                                      ),
                                      Dimens.d5.spaceWidth,
                                      Text(
                                        'delete'.tr,
                                        style: Style.montserratRegular(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.colorE71D36,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
                Dimens.d2.spaceHeight,
                SizedBox(
                  width: 240,
                  child: Text(
                    des ?? "",
                    maxLines: 2,
                    style: Style.montserratRegular(
                      height: 2,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetCalendar(StateSetter setState) {
    return Container(
        height: 350,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: themeController.isDarkMode.isTrue
              ? ColorConstant.textfieldFillColor
              : ColorConstant.white,
        ),
        child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events) {
            if (date.isBefore(DateTime.now())) {
              setState.call(() => _currentDate = date);

              print("==========$_currentDate");
              setState.call(() {
                dateController.text = DateFormat('dd/MM/yyyy').format(date);
                select = false;
              });
              setState((){});
            }

          },

          weekendTextStyle: Style.montserratRegular(
              fontSize: 15,
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.white
                  : ColorConstant.black),
          // Customize your text style
          thisMonthDayBorderColor: Colors.transparent,
          customDayBuilder: (
            bool isSelectable,
            int index,
            bool isSelectedDay,
            bool isToday,
            bool isPrevMonthDay,
            TextStyle textStyle,
            bool isNextMonthDay,
            bool isThisMonthDay,
            DateTime day,
          ) {
            if (day.isAfter(DateTime.now())) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: Dimens.d32,
                width: Dimens.d32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: Style.montserratRegular(
                        fontSize: 15,
                        color: Colors
                            .grey), // Customize your future day text style
                  ),
                ),
              );
            } else if (isSelectedDay) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: Dimens.d32,
                width: Dimens.d32,
                decoration: BoxDecoration(
                  color: ColorConstant.themeColor,
                  // Customize your selected day color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: Style.montserratRegular(
                        fontSize: 15,
                        color: ColorConstant
                            .white), // Customize your selected day text style
                  ),
                ),
              );
            } else {
              return null;
            }
          },
          weekFormat: false,
          daysTextStyle: Style.montserratRegular(
              fontSize: 15,
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.white
                  : ColorConstant.black),
          height: 300.0,
          markedDateIconBorderColor: Colors.transparent,
          childAspectRatio: 1.5,
          dayPadding: 0.0,
          prevDaysTextStyle: Style.montserratRegular(fontSize: 15),
          selectedDateTime: _currentDate,
          headerTextStyle: Style.montserratRegular(
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.white
                  : ColorConstant.black,
              fontWeight: FontWeight.bold),
          dayButtonColor: themeController.isDarkMode.isTrue
              ? ColorConstant.textfieldFillColor
              : Colors.white,
          weekDayBackgroundColor: themeController.isDarkMode.isTrue
              ? ColorConstant.textfieldFillColor
              : Colors.white,
          markedDateMoreCustomDecoration: BoxDecoration(
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.black
                  : Colors.white),
          shouldShowTransform: false,
          staticSixWeekFormat: false,
          weekdayTextStyle: Style.montserratRegular(
              fontSize: 11,
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.white
                  : ColorConstant.color797B86,
              fontWeight: FontWeight.bold),
          todayButtonColor: Colors.transparent,
          selectedDayBorderColor: Colors.transparent,
          todayBorderColor: Colors.transparent,
          selectedDayButtonColor: Colors.transparent,
          daysHaveCircularBorder: false,
          todayTextStyle: Style.montserratRegular(
              fontSize: 15,
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.white
                  : ColorConstant.black),
        ));
  }

  void _showAlertDialogDelete(BuildContext context, int index, id) {
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
              width: Dimens.d96,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "areYouSureDeleteGratitude".tr,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: Dimens.d28),
                  textStyle: Style.montserratRegular(
                      fontSize: Dimens.d12, color: ColorConstant.white),
                  title: "delete".tr,
                  onTap: () async {
                    Get.back();
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
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
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
