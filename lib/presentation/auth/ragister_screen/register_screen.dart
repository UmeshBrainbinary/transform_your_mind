import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/widget/add_image.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterController registerController = Get.put(RegisterController());
  var birthDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  DateTime? picked;
  ThemeController themeController = Get.find<ThemeController>();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? ColorConstant.darkBackground
              : ColorConstant.backGround,
          appBar: CustomAppBar(centerTitle: true,showBack: false,
            titleStyle:   Style.nunitoSemiBold(
              fontSize: Dimens.d30,
              color: themeController.isDarkMode.value
                  ? ColorConstant.white
                  : ColorConstant.black),
            title: "register".tr,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
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
                                    await showImagePickerActionSheet(context)
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
                            Dimens.d35.h.spaceHeight,
                            CommonTextField(
                                labelText: "name".tr,
                                hintText: "enterName".tr,
                                controller: registerController.nameController,
                                focusNode: registerController.nameFocus,
                                prefixIcon: Transform.scale(
                                  scale: 0.5,
                                  child: SvgPicture.asset(ImageConstant.user,   color: themeController.isDarkMode.isTrue
                                      ? ColorConstant.colorBFBFBF
                                      : ColorConstant.color545454,),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.trim()=="") {
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
                                focusNode: registerController.emailFocus,
                                prefixIcon: Image.asset(ImageConstant.email,   color: themeController.isDarkMode.isTrue
                                    ? ColorConstant.colorBFBFBF
                                    : ColorConstant.color545454,
                                    scale: Dimens.d4),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.trim() == "") {
                                    return "theEmailFieldIsRequired".tr;
                                  } else if (!isValidEmail(value,
                                      isRequired: true)) {
                                    return "pleaseEnterValidEmail".tr;
                                  }
                                  return null;
                                }),
                            Dimens.d16.h.spaceHeight,
                            ValueListenableBuilder(
                              valueListenable: registerController.securePass,
                              builder: (context, value, child) {
                                return CommonTextField(
                                  labelText: "password".tr,
                                  hintText: "enterPassword".tr,
                                  controller:
                                      registerController.passwordController,
                                  validator: (value) {
                                    if (value!.trim() == "") {
                                      return "thePasswordFieldIsRequired".tr;
                                    } else if (!isValidPassword(value,
                                        isRequired: true)) {
                                      return "pleaseEnterValidPassword".tr;
                                    }
                                    return null;
                                  },
                                  focusNode: registerController.passwordFocus,

                                  prefixIcon: Image.asset(ImageConstant.lock,   color: themeController.isDarkMode.isTrue
                                      ? ColorConstant.colorBFBFBF
                                      : ColorConstant.color545454,
                                      scale: Dimens.d4),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        registerController.securePass.value =
                                            !registerController
                                                .securePass.value;
                                      },
                                      child: Transform.scale(
                                        scale: 0.38,
                                        child: Image.asset(
                                          registerController.securePass.value
                                              ? ImageConstant.eyeClose
                                              : ImageConstant.eyeOpen,   color: themeController.isDarkMode.isTrue
                                            ? ColorConstant.colorBFBFBF
                                            : ColorConstant.color545454,
                                          fit: BoxFit.contain,
                                          height: 5,
                                          width: 5,
                                        ),
                                      )),
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
                                focusNode: registerController.dobFocus,
                                prefixIcon: Transform.scale(
                                    scale: 0.5,
                                    child: SvgPicture.asset(
                                        ImageConstant.calendar,   color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.colorBFBFBF
                                        : ColorConstant.color545454,
                                        height: Dimens.d5,
                                        width: Dimens.d5)),
                                readOnly: true,
                                onTap: () async {
                                  datePicker(context);

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
                                focusNode: registerController.genderFocus,
                                prefixIcon: Transform.scale(
                                    scale: 0.5,
                                    child: SvgPicture.asset(
                                        ImageConstant.gender,
                                        height: Dimens.d5,   color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.colorBFBFBF
                                        : ColorConstant.color545454,
                                        width: Dimens.d5)),
                                readOnly: true,
                                suffixIcon: Transform.scale(
                                    scale: 0.5,
                                    child: SvgPicture.asset(
                                        ImageConstant.downArrow,   color: themeController.isDarkMode.isTrue
                                        ? ColorConstant.colorBFBFBF
                                        : ColorConstant.color545454,
                                        height: Dimens.d5,
                                        width: Dimens.d5)),
                                onTap: () {
                                  registerController.isDropGender.value =
                                      !registerController.isDropGender.value;
                                },
                                validator: (value) {
                                  if (value == null || value ==''
                                      // ||
                                      // (!isText(value, isRequired: true))
                                  ) {
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorConstant.black.withOpacity(0.1),
                                            blurRadius: 30,spreadRadius: 0.0,

                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(Dimens.d10),
                                        color: ColorConstant.white,
                                      ),
                                      child: Column(
                                          children: List.generate(
                                        registerController.genderList.length,
                                        (index) => GestureDetector(
                                            onTap: () {
                                              registerController
                                                  .isDropGender.value = false;
                                              registerController
                                                      .genderController.text =
                                                  registerController
                                                      .genderList[index];
                                              registerController.genderList
                                                  .refresh();
                                            },
                                            child: Container(
                                              height: Dimens.d45,
                                              width: Get.width,

                                              padding: const EdgeInsets.only(
                                                  left: Dimens.d10,
                                                  top: Dimens.d12),
                                              decoration: BoxDecoration(
                                                color: registerController
                                                            .genderController
                                                            .text ==
                                                        registerController
                                                            .genderList[index]
                                                    ? ColorConstant.themeColor
                                                    : themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor:ColorConstant.white,
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
                                                                    Dimens
                                                                        .d10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    Dimens
                                                                        .d10))
                                                        : BorderRadius.circular(
                                                            Dimens.d0),
                                              ),
                                              child: Text(
                                                registerController
                                                    .genderList[index],
                                                style: Style.nunMedium(
                                                    color: registerController
                                                                .genderController
                                                                .text ==
                                                            registerController
                                                                    .genderList[
                                                                index]
                                                        ? ColorConstant.white
                                                        : themeController.isDarkMode.isTrue?ColorConstant.white:ColorConstant
                                                            .black),
                                              ),
                                            )),
                                      )),
                                    )
                                  : const SizedBox(),
                            ),
                            Dimens.d80.h.spaceHeight,
                            CommonElevatedButton(height: Dimens.d46,
                              title: "register".tr,
                              onTap: () async {
                                registerController.genderFocus.unfocus();
                                registerController.emailFocus.unfocus();
                                registerController.nameFocus.unfocus();
                                registerController.dobFocus.unfocus();

                                if (_formKey.currentState!.validate()) {
                                    registerController.onTapRegister(context,registerController.imageFile);
                                  }

                              },
                            ),
                            Dimens.d30.h.spaceHeight,
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "alreadyHaveAnAccount".tr,
                                    style: Style.nunRegular(
                                        color:
                                            themeController.isDarkMode.value
                                                ? ColorConstant.white
                                                : ColorConstant.black),
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
                );
              },
            ),
          ),
        ),
        Obx(
              () => registerController.loader.value == true
              ? commonLoader()
              : const SizedBox(),
        ),

      ],
    );
  }


  datePicker(context,) async {
    FocusScope.of(context).unfocus();
    picked = await  showDatePicker(

      builder: (context, child) {
        TextStyle customTextStyle = Style.nunMedium(fontSize: 15,color: Colors.black);
        TextStyle editedTextStyle = customTextStyle.copyWith(color: Colors.red); // Define the edited text style
        TextStyle selectedDateTextStyle = Style.nunitoBold(fontSize: 15,color: themeController.isDarkMode.isTrue?Colors.white:
        Colors.black); // Define the style for the selected date

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
      //locale :PrefService.getString(PrefKey.language) == "de-DE"? const Locale('de', 'DE') :const Locale('en', 'US'),
      firstDate: DateTime(1901),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      birthDate = DateFormat('dd/MM/yyyy').format(picked!);
      registerController.dobController.text = birthDate;
    }
  }


}
