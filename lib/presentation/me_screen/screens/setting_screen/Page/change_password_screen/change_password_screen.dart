import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/change_password_screen/change_password_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ChangePasswordController changePasswordController = Get.put(ChangePasswordController());

  ThemeController themeController = Get.find<ThemeController>();

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
        appBar: CustomAppBar(
          title: "changePassword".tr,
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
                                children: [
                                  Dimens.d25.spaceHeight,
                                  ValueListenableBuilder(
                                    valueListenable:
                                        changePasswordController.securePass3,
                                    builder: (context, value, child) {
                                      return CommonTextField(
                                        labelText: "currentPassword".tr,
                                        hintText: "enterCurrentPassword".tr,
                                        controller: changePasswordController
                                            .currentPController,
                                        validator: (value) {
                                          if (value == "") {
                                            return "thePasswordFieldIsRequired"
                                                .tr;
                                          }
                                          //  else if(!isValidPassword(value, isRequired: true)){
                                          //   return "pleaseEnterValidPassword".tr;
                                          // }
                                          return null;
                                        },
                                        focusNode: FocusNode(),
                                        prefixIcon: Image.asset(
                                            ImageConstant.lock,
                                            scale: Dimens.d4),
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              changePasswordController
                                                      .securePass3.value =
                                                  !changePasswordController
                                                      .securePass3.value;
                                            },
                                            child: Transform.scale(
                                              scale: 0.38,
                                              child: Image.asset(
                                                changePasswordController
                                                        .securePass3.value
                                                    ? ImageConstant.eyeClose
                                                    : ImageConstant.eyeOpen,
                                                fit: BoxFit.contain,
                                                height: 5,
                                                width: 5,
                                              ),
                                            )),
                                        isSecure: value,
                                        textInputAction: TextInputAction.done,
                                      );
                                    },
                                  ),
                                  Dimens.d23.spaceHeight,
                                  ValueListenableBuilder(
                                    valueListenable:
                                        changePasswordController.securePass,
                                    builder: (context, value, child) {
                                      return CommonTextField(
                                        labelText: "newPassword".tr,
                                        hintText: "enterNewPasswordHint".tr,
                                        controller: changePasswordController
                                            .newPController,
                                        validator: (value) {
                                          if (value == "") {
                                            return "theNewPasswordFieldIsRequired"
                                                .tr;
                                          } else if (!isValidPassword(value,
                                              isRequired: true)) {
                                            return "pleaseEnterValidPassword"
                                                .tr;
                                          }
                                          return null;
                                        },
                                        focusNode: FocusNode(),
                                        prefixIcon: Image.asset(
                                            ImageConstant.lock,
                                            scale: Dimens.d4),
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              changePasswordController
                                                      .securePass.value =
                                                  !changePasswordController
                                                      .securePass.value;
                                            },
                                            child: Transform.scale(
                                              scale: 0.38,
                                              child: Image.asset(
                                                changePasswordController
                                                        .securePass.value
                                                    ? ImageConstant.eyeClose
                                                    : ImageConstant.eyeOpen,
                                                fit: BoxFit.contain,
                                                height: 5,
                                                width: 5,
                                              ),
                                            )),
                                        isSecure: value,
                                        textInputAction: TextInputAction.done,
                                      );
                                    },
                                  ),
                                  Dimens.d23.spaceHeight,
                                  ValueListenableBuilder(
                                    valueListenable:
                                        changePasswordController.securePass2,
                                    builder: (context, value, child) {
                                      return CommonTextField(
                                        labelText: "confirmNewPassword".tr,
                                        hintText: "enterConfirmNewPassword".tr,
                                        controller: changePasswordController
                                            .confirmPController,
                                        validator: (value) {
                                          if (value == "") {
                                            return "theConfirmPasswordFieldIsRequired"
                                                .tr;
                                          } else if (value !=
                                              changePasswordController
                                                  .newPController.text) {
                                            return "passwordsDoNotMatch".tr;
                                          } else if (!isValidPassword(value,
                                              isRequired: true)) {
                                            return "pleaseEnterValidPassword"
                                                .tr;
                                          }
                                          return null;
                                        },
                                        focusNode: FocusNode(),
                                        prefixIcon: Image.asset(
                                            ImageConstant.lock,
                                            scale: Dimens.d4),
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              changePasswordController
                                                      .securePass2.value =
                                                  !changePasswordController
                                                      .securePass2.value;
                                            },
                                            child: Transform.scale(
                                              scale: 0.38,
                                              child: Image.asset(
                                                changePasswordController
                                                        .securePass2.value
                                                    ? ImageConstant.eyeClose
                                                    : ImageConstant.eyeOpen,
                                                fit: BoxFit.contain,
                                                height: 5,
                                                width: 5,
                                              ),
                                            )),
                                        isSecure: value,
                                        textInputAction: TextInputAction.done,
                                      );
                                    },
                                  ),
                                  Dimens.d120.spaceHeight,
                                  CommonElevatedButton(
                                    title: "confirmPassword".tr,
                                    onTap: () {
                                      FocusScope.of(context).unfocus();

                                      if (_formKey.currentState!.validate()) {
                                        changePasswordController.resetPasswordApi(context);
                                       // Get.back();
                                      }
                                    },
                                  )
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
        ),
      ),
    );
  }
}
