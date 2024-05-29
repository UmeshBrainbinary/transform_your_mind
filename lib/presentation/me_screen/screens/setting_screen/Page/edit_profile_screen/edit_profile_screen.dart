import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

class EditProfileScreen extends StatefulWidget {
   EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EditProfileController editProfileController = Get.put(EditProfileController());

 bool _isImageRemoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "editProfile".tr,
      ),
      body: SafeArea(
          child:  Padding(
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
                                        await showImagePickerActionSheet(
                                            context)
                                            ?.then((value) async {
                                          if (value != null) {
                                            editProfileController.imageFile.value =
                                                value;
                                          }
                                        });
                                      },
                                      onDeleteTap: () async {
                                        editProfileController.imageFile = ValueNotifier(null);
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
                                    focusNode: FocusNode(),
                                    prefixIcon: Transform.scale(
                                      scale: 0.5,
                                      child:
                                      SvgPicture.asset(ImageConstant.user),
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
                                    focusNode: FocusNode(),
                                    filledColor: ColorConstant.lightGrey,
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
                                    focusNode: FocusNode(),
                                    prefixIcon: Transform.scale(
                                        scale: 0.5,
                                        child: SvgPicture.asset(
                                            ImageConstant.calendar,
                                            height: Dimens.d5,
                                            width: Dimens.d5)),
                                    readOnly: true,
                                    onTap: () async{
                                      FocusScope.of(context).unfocus();
                                      await  picker.DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(1900, 3, 5),
                                          maxTime: DateTime.now().subtract(
                                              const Duration(days: 1)),
                                          theme: picker.DatePickerTheme(
                                              doneStyle: Style.montserratSemiBold(
                                                  color: ColorConstant.white),
                                              cancelStyle: Style.montserratSemiBold(color: ColorConstant.white),
                                              itemStyle: Style.montserratSemiBold(color: ColorConstant.white),
                                              backgroundColor: ColorConstant.themeColor),
                                          onChanged: (date) {},
                                          onConfirm: (date) {
                                            editProfileController.dobController.text = DateTimeUtils.formatDate(date);
                                            editProfileController.selectedDob = date;
                                          }, currentTime: editProfileController.selectedDob ?? DateTime.now().subtract(const Duration(days: 1)), locale: picker.LocaleType.en);
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
                                    focusNode: FocusNode(),
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
                                      !editProfileController
                                          .isDropGender.value;
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
                                      borderRadius: BorderRadius.circular(
                                          Dimens.d10),
                                      color: ColorConstant.white,
                                    ),
                                    child: Column(
                                        children: List.generate(
                                          editProfileController
                                              .genderList.length,
                                              (index) => GestureDetector(
                                              onTap: () {
                                                editProfileController
                                                    .isDropGender
                                                    .value = false;
                                                editProfileController
                                                    .genderController
                                                    .text =
                                                editProfileController
                                                    .genderList[index];
                                                editProfileController.genderList
                                                    .refresh();
                                              },
                                              child: Container(
                                                height: Dimens.d45,
                                                width: Get.width,
                                                padding: EdgeInsets.only(
                                                    left: Dimens.d10,
                                                    top: Dimens.d12),
                                                decoration: BoxDecoration(
                                                  color: editProfileController
                                                      .genderController
                                                      .text ==
                                                      editProfileController
                                                          .genderList[
                                                      index]
                                                      ? ColorConstant
                                                      .themeColor
                                                      : ColorConstant.white,
                                                  borderRadius: index == 0
                                                      ? BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(
                                                          Dimens.d10),
                                                      topRight:
                                                      Radius.circular(
                                                          Dimens.d10))
                                                      : index == 2
                                                      ? BorderRadius.only(
                                                      bottomLeft: Radius
                                                          .circular(
                                                          Dimens
                                                              .d10),
                                                      bottomRight:
                                                      Radius.circular(
                                                          Dimens
                                                              .d10))
                                                      : BorderRadius
                                                      .circular(
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
                                                          ? ColorConstant
                                                          .white
                                                          : ColorConstant
                                                          .black),
                                                ),
                                              )),
                                        )),
                                  )
                                      : SizedBox(),
                                ),
                                Dimens.d80.h.spaceHeight,
                                Obx(
                                      () => (editProfileController.loader.value)
                                      ? const LoadingButton()
                                      : CommonElevatedButton(
                                    title: "save".tr,
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();

                                      editProfileController.loader.value = true;


                                      if(editProfileController.imageFile.value == null){
                                        errorToast("pleaseAddImage".tr);
                                      }  else{
                                        if (_formKey.currentState!.validate() ) {




                                          Get.back();




                                        }
                                      }

                                      editProfileController.loader.value = false;                                          },
                                  ),
                                ),

                                Dimens.d80.h.spaceHeight,
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
      ),
    );
  }
}
