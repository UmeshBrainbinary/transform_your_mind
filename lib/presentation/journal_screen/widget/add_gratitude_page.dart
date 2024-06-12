import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_gratitude_page.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../../../core/utils/style.dart';

class AddGratitudePage extends StatefulWidget {
   AddGratitudePage(
      {super.key, this.isSaved, this.isFromMyGratitude, this.registerUser,this.edit,this.title,this.description,this.date});

  final bool? isFromMyGratitude;
  final bool? isSaved;
  final bool? registerUser;
  final bool? edit;
  String? title;
  String? description;
  String? date;

  @override
  State<AddGratitudePage> createState() => _AddGratitudePageState();
}

class _AddGratitudePageState extends State<AddGratitudePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

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

  File? selectedImage;
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {


      dateController.text = _formatDate(_currentDate);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    if(widget.edit==true){
    setState(() {
      titleController.text = widget.title!;
      descController.text = widget.description!;
    });
    }
    super.initState();
  }
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? ColorConstant.black
            : ColorConstant.backGround,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          showBack: widget.registerUser! ? false : true,
         // title: "addGratitude".tr,
             title: widget.edit==true
              ? "editGratitude".tr
              : "addGratitude".tr,
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
                        await PrefService.setValue(PrefKey.addGratitude, true);

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
        body: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Form(
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
                                hintText: "enterTitle".tr,
                                labelText: "title".tr,
                                controller: titleController,
                                focusNode: titleFocus,
                                nextFocusNode: descFocus,
                                prefixLottieIcon: ImageConstant.lottieTitle,
                                maxLength: maxLength,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(maxLength),
                                ],
                                validator: (value) {
                                  if (value == "") {
                                    return "pleaseEnterTitle".tr;
                                  }
                                  return null;
                                },
                              ),
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
                              GestureDetector(
                                onTap: () {

                                  setState(() {
                                    select=!select;
                                  });
                                  /*  descFocus.unfocus();
                                  titleFocus.unfocus();
                                  DateTime initialDate = dateController
                                          .text.isNotEmpty
                                      ? DateTimeUtils.parseDate(
                                                  dateController.text,
                                                  format: DateTimeUtils
                                                      .ddMMyyyyToParse)
                                              .isAfter(DateTime.now())
                                          ? DateTimeUtils.parseDate(
                                              dateController.text,
                                              format:
                                                  DateTimeUtils.ddMMyyyyToParse)
                                          : DateTime.now()
                                      : DateTime.now();
                                  picker.DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now()
                                          .subtract(const Duration(days: 1)),
                                      theme: picker.DatePickerTheme(
                                          doneStyle: Style.montserratRegular(
                                              color: ColorConstant.white),
                                          cancelStyle: Style.montserratRegular(
                                              color: ColorConstant.white),
                                          itemStyle: Style.montserratRegular(
                                              color: ColorConstant.white),
                                          backgroundColor:
                                              ColorConstant.themeColor),
                                      maxTime: DateTime(2050),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    dateController.text =
                                        DateTimeUtils.formatDate(date);
                                    FocusScope.of(context).unfocus();
                                  },
                                      currentTime: initialDate,
                                      locale: picker.LocaleType.en);*/
                                },
                                child: CommonTextField(
                                    enabled: false,
                                    labelText: "date".tr,
                                    suffixIcon: GestureDetector(
                                      onTap: () {

                                        setState(() {
                                          select=!select;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: SvgPicture.asset(
                                            ImageConstant.calendar),
                                      ),
                                    ),
                                    hintText: "DD/MM/YYYY",
                                    controller: dateController,
                                    validator: (value) {
                                      if (value == "") {
                                        return "pleaseEnterDate".tr;
                                      }
                                      return null;
                                    },
                                    focusNode: dateFocus),
                              ),
                              Dimens.d3.spaceHeight,
                              if(select == true)widgetCalendar(),
                              Dimens.d30.spaceHeight,
                              Row(
                                children: [
                                  Expanded(
                                    child: CommonElevatedButton(
                                      title: "draft".tr,
                                      outLined: true,
                                      textStyle: Style.montserratRegular(
                                          color: ColorConstant.textDarkBlue),
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          gratitudeDraftList.add({
                                            "title": titleController.text,
                                            "des": descController.text,
                                            "image": imageFile.value,
                                            "createdOn": "",
                                          });
                                          setState(() {});
                                          Get.back();
                                        }
                                      },
                                    ),
                                  ),
                                  Dimens.d20.spaceWidth,
                                  Expanded(
                                    child: CommonElevatedButton(
                                      title: "save".tr,
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          gratitudeList.add({
                                            "title": titleController.text,
                                            "des": descController.text,
                                            "image": imageFile.value,
                                            "createdOn": "",
                                          });
                                          setState(() {});
                                          if(widget.edit==true){
                                            showSnackBarSuccess(context, "gratitudeUpdated".tr);

                                          }else{
                                            showSnackBarSuccess(context, "successfullyGratitude".tr);

                                          }
                                          Get.back();
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
              ),
              /*     if (state is GratitudeLoadingState)
                Container(
                  color: Colors.transparent,
                  child: Center(
                    child: InkDropLoader(
                      size: Dimens.d50,
                      color: ColorConstant.themeColor,
                    ),
                  ),
                )*/
            ],
          );
        }),
      ),
    );
  }

  Widget widgetCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstant.white,
      ),

      decoration: BoxDecoration(color: ColorConstant.white,
      borderRadius: BorderRadius.circular(16)),
      child: CalendarCarousel<Event>(

        onDayPressed: (DateTime date, List<Event> events) {
          setState(() => _currentDate = date);
          dateController.text = "${date.day}/${date.month}/${date.year}";
         select=false;
          print('==========${_currentDate}');
        },
        weekendTextStyle:
        TextStyle(color: Colors.black, fontSize: 15), // Customize your text style
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
          if (isSelectedDay) {
            return Container(
              decoration: BoxDecoration(
                color: ColorConstant.themeColor, // Customize your selected day color
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(color: Colors.white), // Customize your selected day text style
                ),
              ),
            );
          }  else {
            return null;
          }
        },
        weekFormat: false,
        daysTextStyle: TextStyle(fontSize: 15, color: Colors.black),
        height: 300.0,
        markedDateIconBorderColor: Colors.transparent,
        childAspectRatio: 1.5,
        dayPadding: 0.0,
        prevDaysTextStyle: TextStyle(fontSize: 15),
        selectedDateTime: _currentDate,
        headerTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        dayButtonColor: Colors.white,
        weekDayBackgroundColor: Colors.white,
        markedDateMoreCustomDecoration: const BoxDecoration(color: Colors.white),
        shouldShowTransform: false,
        staticSixWeekFormat: false,
        weekdayTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
        todayButtonColor: Colors.transparent,
        selectedDayBorderColor: Colors.transparent,
        todayBorderColor: Colors.transparent,
        selectedDayButtonColor: Colors.transparent,
        daysHaveCircularBorder: false,
        todayTextStyle: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
  }
}
/*CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate = date);
        },
        weekendTextStyle:
        Style.montserratRegular(color: ColorConstant.black, fontSize: 15),
        thisMonthDayBorderColor: Colors.transparent, // Remove border for current month days
        customDayBuilder: (
            /// you can provide your own build function to make custom day containers
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
          return null;
        },
        weekFormat: false,
        daysTextStyle:
        Style.montserratRegular(fontSize: 15, color: ColorConstant.black),
        // markedDatesMap: _markedDateMap,
        height: 300.0, // Replace with Dimens.d300 if it's defined elsewhere
        markedDateIconBorderColor: Colors.transparent, // Remove border for marked dates
        childAspectRatio: 1.5,
        dayPadding: 0.0,
        prevDaysTextStyle: Style.montserratRegular(fontSize: 15),
        selectedDateTime: _currentDate,
        headerTextStyle: Style.montserratSemiBold(color: ColorConstant.black),
        dayButtonColor: ColorConstant.white,
        weekDayBackgroundColor: ColorConstant.white,
        markedDateMoreCustomDecoration: const BoxDecoration(color: Colors.white),
        shouldShowTransform: false,
        staticSixWeekFormat: false,
        weekdayTextStyle: Style.montserratSemiBold(
            fontSize: 11, color: ColorConstant.color797B86),
        todayButtonColor: Colors.transparent,
        selectedDayBorderColor: Colors.transparent,
        todayBorderColor: Colors.transparent,
        selectedDayButtonColor: ColorConstant.themeColor,
        daysHaveCircularBorder: false,
        todayTextStyle:
        Style.montserratRegular(fontSize: 15, color: ColorConstant.black),

        /// null for not rendering any border, true for circular border, false for rectangular border
      )*/