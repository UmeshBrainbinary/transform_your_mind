import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http ;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
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
    if ((widget.categoryList ?? []).isNotEmpty) {}

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    if (widget.edit == true) {
      setState(() {
        titleController.text = widget.title!;
        descController.text = widget.description!;
        dateController.text = DateFormat('dd/MM/yyyy').format(widget.date!);
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
        Get.offNamed(AppRoutes.dashBoardScreen);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? ColorConstant.black
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

                          Navigator.pushNamedAndRemoveUntil(context,
                      AppRoutes.dashBoardScreen, (route) => false);
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
          body: Stack(
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
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        maxLengthDesc),
                                  ],
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
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
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
          ),
        ),
        loader == true ? commonLoader() : const SizedBox()
      ],
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
}
