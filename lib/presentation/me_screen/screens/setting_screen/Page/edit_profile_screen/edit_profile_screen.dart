import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/edit_profile_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/widget/add_image.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  ThemeController themeController = Get.find<ThemeController>();


  @override
  void initState() {

    editProfileController.emailController.text =
        PrefService.getString(PrefKey.email);
    super.initState();
  }
  var birthDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  DateTime? picked;
  final audioPlayerController = Get.find<NowPlayingController>();
  @override
  Widget build(BuildContext context) {
    //statusBarSet(themeController);
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "personalInformation".tr,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraint.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Dimens.d30.h.spaceHeight,
                               GetBuilder<EditProfileController>(id: "edit",
                                 builder: (controller) {
                                 return  ValueListenableBuilder(
                                   valueListenable: editProfileController.imageFile,
                                   builder: (context, value, child) {
                                     return AddImageEditWidget(
                                       onTap: () async {
                                         await showImagePickerActionSheet(context)
                                             ?.then((value) async {
                                           if (value != null) {

                                             editProfileController.imageFile.value = value;
                                           }
                                         });
                                       },
                                       onDeleteTap: () async {
                                         editProfileController.imageFile =
                                             ValueNotifier(null);
                                         if (editProfileController.image != null) {
                                           editProfileController.urlImage = null;
                                         }

                                         setState(() {});
                                       },
                                       image: editProfileController.imageFile.value,
                                       imageURL: editProfileController.urlImage,
                                     );
                                   },
                                 );
                               },),
                                Dimens.d30.h.spaceHeight,
                                CommonTextField(
                                    labelText: "name".tr,
                                    hintText: "enterName".tr,
                                    controller:
                                        editProfileController.nameController,
                                    focusNode: editProfileController.name,
                                    prefixIcon: Transform.scale(
                                      scale: 0.5,
                                      child: SvgPicture.asset(ImageConstant.user,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                      ColorConstant.hintText,),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.trim() ==""/*||
                                          (!isText(value, isRequired: true))*/) {
                                        return "theNameFieldIsRequired".tr;
                                      }
                                      return null;
                                    }),
                                Dimens.d16.h.spaceHeight,
                                CommonTextField(
                                    labelText: "email".tr,
                                    hintText: "enterEmail".tr,
                                    controller:
                                        editProfileController.emailController,
                                    focusNode: editProfileController.email,

                                    prefixIcon: Image.asset(ImageConstant.email,
                                        scale: Dimens.d4,
                                      color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                      ColorConstant.hintText,),
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value == "") {
                                        return "theEmailFieldIsRequired".tr;
                                      } else if (!isValidEmail(value,
                                          isRequired: true)) {
                                        return "pleaseEnterValidEmail".tr;
                                      }
                                      return null;
                                    }),
                                Dimens.d16.h.spaceHeight,
                                CommonTextField(
                                    labelText: "dateOfBirth".tr,
                                    hintText: "DD/MM/YYYY",
                                    controller: editProfileController.dobController,
                                    focusNode: editProfileController.dob,
                                    prefixIcon: Transform.scale(
                                        scale: 0.5,
                                        child: SvgPicture.asset(
                                            ImageConstant.calendar,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                        ColorConstant.hintText,
                                            height: Dimens.d5,
                                            width: Dimens.d5)),
                                    readOnly: true,
                                    onTap: () async {
                                      datePicker(context,editProfileController);

                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "theDateOfBirthFieldIsRequired".tr;
                                      }
                                      return null;
                                    }),
                                Dimens.d16.h.spaceHeight,
                                CommonTextField(
                                    labelText: "gender".tr,
                                    hintText: "selectGender".tr,
                                    controller:
                                        editProfileController.genderController,
                                    focusNode: editProfileController.gender,
                                    prefixIcon: Transform.scale(
                                        scale: 0.5,
                                        child: SvgPicture.asset(
                                            ImageConstant.gender,
                                            height: Dimens.d5,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                        ColorConstant.hintText,
                                            width: Dimens.d5)),
                                    readOnly: true,
                                    suffixIcon: Transform.scale(
                                        scale: 0.5,
                                        child: SvgPicture.asset(
                                            ImageConstant.downArrow,
                                            height: Dimens.d5,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                        ColorConstant.hintText,
                                            width: Dimens.d5)),
                                    onTap: () {
                                      editProfileController.isDropGender.value =
                                          !editProfileController.isDropGender.value;
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          (!isText(value, isRequired: true))) {
                                        return "theGenderFieldIsRequired".tr;
                                      }
                                      return null;
                                    }),
                                Dimens.d5.h.spaceHeight,
                                Obx(
                                  () => editProfileController.isDropGender.value
                                      ? Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(Dimens.d10),
                                            color: ColorConstant.white,
                                          ),
                                          child: Column(
                                              children: List.generate(
                                            editProfileController.genderList.length,
                                            (index) => GestureDetector(
                                                onTap: () {
                                                  editProfileController
                                                      .isDropGender.value = false;
                                                  editProfileController
                                                          .genderController.text =
                                                      editProfileController
                                                          .genderList[index];
                                                  editProfileController.genderList
                                                      .refresh();
                                                },
                                                child: Container(
                                                  height: Dimens.d45,
                                                  width: Get.width,
                                                  padding: const EdgeInsets.only(
                                                      left: Dimens.d10,
                                                      top: Dimens.d12),
                                                  decoration: BoxDecoration(
                                                    color: editProfileController
                                                                .genderController
                                                                .text ==
                                                            editProfileController
                                                                .genderList[index]
                                                        ? ColorConstant.themeColor
                                                        : themeController.isDarkMode.isTrue?
                                                    ColorConstant.color29363E:ColorConstant.white,
                                                    borderRadius: index == 0
                                                        ? const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    Dimens.d10),
                                                            topRight:
                                                                Radius.circular(
                                                                    Dimens.d10))
                                                        : index == 2
                                                            ? const BorderRadius
                                                                .only(
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                        Dimens.d10),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                        Dimens.d10))
                                                            : BorderRadius.circular(
                                                                Dimens.d0),
                                                  ),
                                                  child: Text(
                                                    editProfileController
                                                        .genderList[index],
                                                    style: Style.nunMedium(
                                                        color: editProfileController
                                                                    .genderController
                                                                    .text ==
                                                                editProfileController
                                                                        .genderList[
                                                                    index]
                                                            ? ColorConstant.white
                                                            : themeController.isDarkMode.isTrue?ColorConstant.white:ColorConstant.black),
                                                  ),
                                                )),
                                          )),
                                        )
                                      : const SizedBox(),
                                ),
                                Dimens.d30.h.spaceHeight,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimens.d50),
                                  child: CommonElevatedButton(
                                      textStyle: Style.nunRegular(
                                          fontSize: Dimens.d20,
                                          color: ColorConstant.white),
                                      title: "update".tr,
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState!
                                            .validate()) {
                                          if (await isConnected()) {
                                            await editProfileController
                                                .updateUser(context);
                                            editProfileController.getUser();
                                          } else {
                                            showSnackBarError(
                                                context, "noInternet".tr);
                                          }
                                        }
                                      }
                                  ),
                                ),
                                Dimens.d50.h.spaceHeight,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        Obx(() =>   editProfileController.loader.isTrue?commonLoader():const SizedBox(),),
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
      ),
    );
  }

  Widget widgetCalendar() {
    return Container(
      height: 350,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstant.white,
      ),
      child: GetBuilder<EditProfileController>(
        builder: (controller) {
          return CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) {
              setState(() => controller.currentDate = date);
              controller.dobController.text = DateFormat('dd/MM/yyyy').format(date);
                /*  "${date.day}/${date.month}/${date.year}";*/
              controller.select = false;
              print('==========${controller.currentDate}');
            },
            weekendTextStyle: Style.nunRegular(fontSize: 15,color: ColorConstant.black),
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
                      style: Style.nunRegular(fontSize: 15, color: Colors.grey), // Customize your future day text style
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
                      style: Style.nunRegular(
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
            daysTextStyle: Style.nunRegular(fontSize: 15,color: ColorConstant.black),
            height: 300.0,
            markedDateIconBorderColor: Colors.transparent,
            childAspectRatio: 1.5,
            dayPadding: 0.0,
            prevDaysTextStyle: Style.nunRegular(fontSize: 15),
            selectedDateTime: controller.currentDate,
            headerTextStyle:
            Style.nunRegular(color: ColorConstant.black,fontWeight: FontWeight.bold),
            dayButtonColor: Colors.white,
            weekDayBackgroundColor: Colors.white,
            markedDateMoreCustomDecoration:
                const BoxDecoration(color: Colors.white),
            shouldShowTransform: false,
            staticSixWeekFormat: false,
            weekdayTextStyle:Style.nunRegular(fontSize: 11,color: ColorConstant.color797B86,fontWeight: FontWeight.bold),
            todayButtonColor: Colors.transparent,
            selectedDayBorderColor: Colors.transparent,
            todayBorderColor: Colors.transparent,
            selectedDayButtonColor: Colors.transparent,
            daysHaveCircularBorder: false,
            todayTextStyle: Style.nunRegular(fontSize: 15,color: ColorConstant.black),
          );
        },
      ),
    );
  }

  datePicker(context, EditProfileController editProfileController) async {
    FocusScope.of(context).unfocus();
    picked = await  showDatePicker(
      builder: (context, child) {
        TextStyle customTextStyle = Style.nunMedium(fontSize: 15,color: Colors.black);
        TextStyle editedTextStyle = customTextStyle.copyWith(color: Colors.red); // Define the edited text style


        return Theme(
          data: ThemeData.light().copyWith(focusColor: ColorConstant.themeColor,
              colorScheme:  ColorScheme.light(
                primary: ColorConstant.themeColor,
                onPrimary: Colors.white,
                onBackground: Colors.white,
                background: Colors.white,
                surface:themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor: ColorConstant.white,
                surfaceTint:themeController.isDarkMode.isTrue?ColorConstant.color7A7A7A: ColorConstant.themeColor,
                onSurface:themeController.isDarkMode.isTrue?Colors.white: ColorConstant.black,
              ),


              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ), dialogTheme: const DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Remove border radius
                ),elevation: 0.0,
                insetPadding: EdgeInsets.all(0), // Remove padding around the dialog
              ),
              textTheme: TextTheme(
                bodyLarge:customTextStyle,
                bodyMedium: customTextStyle,
                bodySmall: customTextStyle,
                displayLarge: customTextStyle,
                displayMedium: customTextStyle,
                titleLarge: customTextStyle,
                displaySmall: customTextStyle,
                headlineMedium: customTextStyle,
                headlineSmall: customTextStyle,
                labelLarge: customTextStyle,
                labelMedium: customTextStyle,
                labelSmall: customTextStyle,
                titleMedium: editedTextStyle,
                titleSmall: editedTextStyle,

              )),
          child: child!,
        );
      },

      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      birthDate = DateFormat('dd/MM/yyyy').format(picked!);
      // birthDate = DateFormat("yyyy-MM-dd").format(picked!);
      editProfileController.dobController.text = birthDate;
      setState(() {

      });
    }
  }
}
