import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:transform_your_mind/presentation/auth/ragister_screen/widget/add_image.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backGround,
      appBar: CustomAppBar(
        title: "register".tr,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            top: Dimens.d200.h,
            right: null,
            left: 0,
            child: Transform.rotate(
              angle: 3.14,
              child: Image.asset(ImageConstant.bgStar, height: Dimens.d274.h),
            ),
          ),
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
                              children: [
                                Dimens.d30.h.spaceHeight,
                                ValueListenableBuilder(
                                  valueListenable: registerController.imageFile,
                                  builder: (context, value, child) {
                                    return AddImageWidget(
                                      onTap: () async {
                                        await showImagePickerActionSheet(
                                                context)
                                            ?.then((value) async {
                                          if (value != null) {
                                            registerController.imageFile.value =
                                                value;
                                          }
                                        });
                                      },
                                      onDeleteTap: () async {
                                        registerController.imageFile =
                                            ValueNotifier(null);
                                        if (registerController.image != null) {
                                          registerController.urlImage = null;
                                          //_isImageRemoved = true;
                                        }
                                      },
                                      image: registerController.imageFile.value,
                                      imageURL: registerController.urlImage,
                                    );
                                  },
                                ),
                                Dimens.d30.h.spaceHeight,
                                CommonTextField(
                                    labelText: "name".tr,
                                    hintText: "enterName".tr,
                                    controller:
                                        registerController.nameController,
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
                                        registerController.emailController,
                                    focusNode: FocusNode(),
                                    prefixIcon: Image.asset(ImageConstant.email,
                                        scale: Dimens.d4),
                                    keyboardType: TextInputType.emailAddress,
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
                                ValueListenableBuilder(
                                  valueListenable:
                                      registerController.securePass,
                                  builder: (context, value, child) {
                                    return CommonTextField(
                                      labelText:"password".tr,
                                      hintText:"enterPassword".tr,
                                      controller:
                                          registerController.passwordController,
                                      validator: (value) {
                                        if (value == "") {
                                          return "thePasswordFieldIsRequired"
                                              .tr;
                                        } else if (!isValidPassword(value,
                                            isRequired: true)) {
                                          return "pleaseEnterValidPassword".tr;
                                        }
                                        return null;
                                      },
                                      focusNode: FocusNode(),
                                      prefixIcon: Image.asset(
                                          ImageConstant.lock,
                                          scale: Dimens.d4),
                                      suffixIcon: GestureDetector(
                                          onTap: (){
                                            registerController.securePass.value = !registerController.securePass.value;
                                          },
                                          child: Transform.scale(
                                            scale: 0.38,
                                            child: Image.asset(
                                              registerController.securePass.value
                                                  ? ImageConstant.eyeClose
                                                  : ImageConstant.eyeOpen,
                                              fit: BoxFit.contain,
                                              height: 5,
                                              width: 5,
                                            ),
                                          )
                                      ),
                                      isSecure: value,
                                      //suffixTap: () => loginController.securePass.value = !loginController.securePass.value,
                                      textInputAction: TextInputAction.done,
                                    );
                                  },
                                ),
                                Dimens.d16.h.spaceHeight,
                                CommonTextField(
                                    labelText: "dateOfBirth".tr,
                                    hintText: "DD/MM/YYYY",
                                    controller: registerController.dobController,
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
                                            registerController.dobController.text = DateTimeUtils.formatDate(date);
                                            registerController.selectedDob = date;
                                          }, currentTime: registerController.selectedDob ?? DateTime.now().subtract(const Duration(days: 1)), locale: picker.LocaleType.en);
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
                                        registerController.genderController,
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
                                      registerController.isDropGender.value =
                                          !registerController
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
                                  () => registerController.isDropGender.value
                                      ? Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.d10),
                                            color: ColorConstant.white,
                                          ),
                                          child: Column(
                                              children: List.generate(
                                            registerController
                                                .genderList.length,
                                            (index) => GestureDetector(
                                                onTap: () {
                                                  registerController
                                                      .isDropGender
                                                      .value = false;
                                                  registerController
                                                          .genderController
                                                          .text =
                                                      registerController
                                                          .genderList[index];
                                                  registerController.genderList
                                                      .refresh();
                                                },
                                                child: Container(
                                                  height: Dimens.d45,
                                                  width: Get.width,
                                                  padding: EdgeInsets.only(
                                                      left: Dimens.d10,
                                                      top: Dimens.d12),
                                                  decoration: BoxDecoration(
                                                    color: registerController
                                                                .genderController
                                                                .text ==
                                                            registerController
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
                                                    registerController
                                                        .genderList[index],
                                                    style: Style.montserratMedium(
                                                        color: registerController
                                                                    .genderController
                                                                    .text ==
                                                                registerController
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
                                  () => (registerController.loader.value)
                                      ? const LoadingButton()
                                      : CommonElevatedButton(
                                          title: "register".tr,
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();

                                            registerController.loader.value = true;


                                           if(registerController.imageFile.value == null){
                                             errorToast("pleaseAddImage".tr);
                                           }  else{
                                             if (_formKey.currentState!.validate() ) {


                                               await PrefService.setValue(PrefKey.isLoginOrRegister, true);

                                               Get.toNamed(AppRoutes.dashBoardScreen);


                                               // registerController.nameController.clear();
                                               // registerController.emailController.clear();
                                               // registerController.passwordController.clear();
                                               // registerController.dobController.clear();
                                               // registerController.genderController.clear();
                                               // registerController.imageFile.value = null;

                                             }
                                           }

                                            registerController.loader.value = false;                                          },
                                        ),
                                ),
                                Dimens.d30.h.spaceHeight,
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "alreadyHaveAnAccount".tr,
                                        style: Style.montserratRegular(),
                                      ),
                                      const WidgetSpan(
                                        child: Padding(
                                            padding: EdgeInsets.all(Dimens.d4)),
                                      ),
                                      TextSpan(
                                        text: "Login".tr,
                                        style: Style.montserratSemiBold(
                                          color: ColorConstant.themeColor,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Get.toNamed(
                                            //   AppRoutes.loginScreen,
                                            // );
                                            Get.back();
                                          },
                                      ),
                                    ],
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
        ],
      )),
    );
  }
}
