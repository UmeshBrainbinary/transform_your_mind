import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/date_time.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/toast_message.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/edit_profile_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/widget/add_image.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class EditProfileScreen extends StatefulWidget {
   EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EditProfileController editProfileController = Get.put(EditProfileController());

  ThemeController themeController = Get.find<ThemeController>();

 bool _isImageRemoved = false;

 @override
  void initState() {
    editProfileController.emailController.text = PrefService.getString(PrefKey.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: themeController.isDarkMode.value ? ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(
          title: "personalInformation".tr,
        ),
      body: Padding(
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
                            ValueListenableBuilder(
                              valueListenable: editProfileController.imageFile,
                              builder: (context, value, child) {
                                return AddImageEditWidget(
                                  onTap: () async {
                                    await showImagePickerActionSheet(context)
                                        ?.then((value) async {
                                      if (value != null) {
                                        editProfileController.imageFile.value =
                                            value;
                                      }
                                    });
                                  },
                                  onDeleteTap: () async {
                                    editProfileController.imageFile =
                                        ValueNotifier(null);
                                    if (editProfileController.image != null) {
                                      editProfileController.urlImage = null;
                                      _isImageRemoved = true;
                                    }

                                    setState(() {});
                                  },
                                  image: editProfileController.imageFile.value,
                                  imageURL: editProfileController.urlImage,
                                );
                              },
                            ),
                            Dimens.d30.h.spaceHeight,
                            CommonTextField(
                                labelText: "name".tr,
                                hintText: "enterName".tr,
                                controller:
                                    editProfileController.nameController,
                                focusNode: editProfileController.name,
                                prefixIcon: Transform.scale(
                                  scale: 0.5,
                                  child: SvgPicture.asset(ImageConstant.user),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null ||
                                      (!isText(value, isRequired: true))) {
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
                                filledColor: themeController.isDarkMode.value
                                    ? ColorConstant.lightGrey2
                                    : ColorConstant.lightGrey,
                                prefixIcon: Image.asset(ImageConstant.email,
                                    scale: Dimens.d4),
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
                                        ImageConstant.calendar,
                                        height: Dimens.d5,
                                        width: Dimens.d5)),
                                readOnly: true,
                                onTap: ()  {
                                 showDialog(context: context, builder: (context) {
                                   return Column(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Container(
                                           height: 300,
                                           child: widgetCalendar()),
                                     ],
                                   );
                                 },);
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
                                        height: Dimens.d5,
                                        width: Dimens.d5)),
                                readOnly: true,
                                suffixIcon: Transform.scale(
                                    scale: 0.5,
                                    child: SvgPicture.asset(
                                        ImageConstant.downArrow,
                                        height: Dimens.d5,
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
                                                    : ColorConstant.white,
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
                                                style: Style.montserratMedium(
                                                    color: editProfileController
                                                                .genderController
                                                                .text ==
                                                            editProfileController
                                                                    .genderList[
                                                                index]
                                                        ? ColorConstant.white
                                                        : ColorConstant.black),
                                              ),
                                            )),
                                      )),
                                    )
                                  : const SizedBox(),
                            ),
                            Dimens.d30.h.spaceHeight,
                            Obx(
                              () => (editProfileController.loader.value)
                                  ? const LoadingButton()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimens.d50),
                                      child: CommonElevatedButton(
                                        title: "update".tr,
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          editProfileController.loader.value = true;


                                          if (editProfileController
                                                  .imageFile.value ==
                                              null) {
                                            errorToast("pleaseAddImage".tr);
                                          } else {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              editProfileController.updateUser(context);
                                            }
                                          }

                                          editProfileController.loader.value = false;
                                  },
                                ),
                              ),
                            ),
                            Dimens.d50.h.spaceHeight,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //commonGradiantContainer(color: AppColors.backgroundWhite, h: 20)
              ],
            );
          },
        ),
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

      child: GetBuilder<EditProfileController>(
        builder: ( controller) {
          return CalendarCarousel<Event>(

            onDayPressed: (DateTime date, List<Event> events) {
              setState(() => controller.currentDate = date);
              controller.dobController.text = "${date.day}/${date.month}/${date.year}";
              controller.select=false;
              print('==========${controller.currentDate}');
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
            selectedDateTime: controller.currentDate,
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
          );
        },
      ),
    );
  }

}
