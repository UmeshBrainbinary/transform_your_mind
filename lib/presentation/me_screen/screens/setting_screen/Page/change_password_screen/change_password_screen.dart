import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/core/utils/validation_functions.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/change_password_screen/change_password_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  String? title;

  ChangePasswordScreen({super.key, this.title = ""});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ChangePasswordController changePasswordController = Get.put(ChangePasswordController());

  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    changePasswordController.currentPController = TextEditingController();
    changePasswordController.newPController = TextEditingController();
    changePasswordController.confirmPController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //statusBarSet(themeController);
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title:
            widget.title == "change" ? "changePassword".tr : "newPassword".tr,
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
                                Dimens.d23.spaceHeight,
                                widget.title == ""
                                    ? const SizedBox()
                                    : ValueListenableBuilder(
                                        valueListenable:
                                            changePasswordController.current,
                                        builder: (context, value, child) {
                                          return CommonTextField(
                                            labelText: "currentPassword".tr,
                                            hintText:
                                                "enterCurrentPasswordHint".tr,
                                            hintStyle: const TextStyle(fontSize: 14),
                                            textStyle: const TextStyle(fontSize: 14),
                                            controller: changePasswordController
                                                .currentPController,
                                            validator: (value) {
                                              if (value == "") {
                                                return "theCurrentPasswordFieldIsRequired"
                                                    .tr;
                                              } else if (!isValidPassword(value,
                                                  isRequired: true)) {
                                                return "pleaseEnterValidPassword"
                                                    .tr;
                                              }
                                              return null;
                                            },
                                            focusNode:changePasswordController.currentFocus,

                                            prefixIcon: Image.asset(
                                                ImageConstant.lock,
                                                scale: Dimens.d4,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                              ColorConstant.hintText,),
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  changePasswordController
                                                          .current.value =
                                                      !changePasswordController
                                                          .current.value;
                                                },
                                                child: Transform.scale(
                                                  scale: 0.38,
                                                  child: Image.asset(
                                                    changePasswordController
                                                            .current.value
                                                        ? ImageConstant.eyeClose
                                                        : ImageConstant.eyeOpen,
                                                    fit: BoxFit.contain,
                                                    height: 5,
                                                    width: 5,
                                                    color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                                    ColorConstant.hintText,
                                                  ),
                                                )),
                                            isSecure: value,
                                            textInputAction:
                                                TextInputAction.done,
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
                                      hintStyle: const TextStyle(fontSize: 14),
                                      textStyle: const TextStyle(fontSize: 14),
                                      controller: changePasswordController
                                          .newPController,
                                      validator: (value) {
                                        if (value == "") {
                                          return "theNewPasswordFieldIsRequired"
                                              .tr;
                                        } else if (!isValidPassword(value,
                                            isRequired: true)) {
                                          return "pleaseEnterValidPassword".tr;
                                        }
                                        return null;
                                      },
                                      focusNode:changePasswordController.newFocus,

                                      prefixIcon: Image.asset(
                                          ImageConstant.lock,
                                          scale: Dimens.d4,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                        ColorConstant.hintText,),
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
                                              width: 5,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                            ColorConstant.hintText,
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
                                      hintStyle: const TextStyle(fontSize: 14),
                                      textStyle: const TextStyle(fontSize: 14),
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
                                          return "pleaseEnterValidPassword".tr;
                                        }
                                        return null;
                                      },
                                      focusNode:changePasswordController.confirmFocus,
                                      prefixIcon: Image.asset(
                                          ImageConstant.lock,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                      ColorConstant.hintText,
                                          scale: Dimens.d4),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            changePasswordController
                                                    .securePass2.value =
                                                !changePasswordController
                                                    .securePass2.value;
                                            FocusScope.of(context).unfocus();
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
                                              width: 5,color: themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF:
                                            ColorConstant.hintText,
                                            ),
                                          )),
                                      isSecure: value,
                                      textInputAction: TextInputAction.done,
                                    );
                                  },
                                ),
                                Dimens.d120.spaceHeight,
                                CommonElevatedButton(
                                  title: "save".tr,textStyle: Style.nunMedium(fontSize: 20,color: ColorConstant.white),
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      if (!widget.title!.isNotEmpty) {
                                        if (await isConnected()) {
                                          changePasswordController
                                              .resetPasswordApi(context);
                                        } else {
                                          showSnackBarError(
                                              context, "noInternet".tr);
                                        }
                                      } else {
                                        if (changePasswordController
                                            .currentPController.text ==
                                            changePasswordController
                                                .newPController.text) {
                                          showSnackBarError(context, "youCanNotSet".tr);
                                        } else {
                                          if (await isConnected()) {
                                            changePasswordController
                                                .changePasswordApi(context);
                                          } else {
                                            showSnackBarError(
                                                context, "noInternet".tr);
                                          }
                                        }
                                      }
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
          Obx(
            () => changePasswordController.loader.isTrue
                ? commonLoader()
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}

