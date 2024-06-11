import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/date_time.dart';
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
  const AddGratitudePage(
      {Key? key, this.isSaved, this.isFromMyGratitude, this.registerUser})
      : super(key: key);

  final bool? isFromMyGratitude;
  final bool? isSaved;
  final bool? registerUser;

  @override
  State<AddGratitudePage> createState() => _AddGratitudePageState();
}

class _AddGratitudePageState extends State<AddGratitudePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  ThemeController themeController = Get.find<ThemeController>();

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  ValueNotifier<int> currentLength = ValueNotifier(0);
  String? urlImage;
  bool _isImageRemoved = false;
  int gratitudeAddedCount = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? selectedImage;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.initState();
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
          title: "addGratitude".tr,
          /*   title: widget.gratitudeData != null
              ? i10n.editGratitude
              : i10n.addGratitude,*/
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
                                  descFocus.unfocus();
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
                                      locale: picker.LocaleType.en);
                                },
                                child: CommonTextField(
                                    enabled: false,
                                    labelText: "date".tr,
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: SvgPicture.asset(
                                          ImageConstant.calendar),
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
}
