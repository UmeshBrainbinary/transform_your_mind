import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
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
          title: "newPassword".tr,
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
                                    title: "submit".tr,
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
void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        //backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0), // Set border radius
        ),
        actions: <Widget>[
          Dimens.d27.spaceHeight,
          Center(child: SvgPicture.asset(ImageConstant.passwordCheck,height: Dimens.d100, width: Dimens.d100,)),
          Dimens.d8.spaceHeight,

          Center(
            child: Text("passwordChanged".tr,
                textAlign: TextAlign.center,
                style: Style.cormorantGaramondBold(
                  fontSize: Dimens.d22,
                  fontWeight: FontWeight.w700,
                )),
          ),
          Dimens.d7.spaceHeight,
          Center(
            child: Text(
                textAlign: TextAlign.center,
                "yourPassword".tr,
                style: Style.montserratRegular(
                  fontSize: Dimens.d12,
                  fontWeight: FontWeight.w400,
                )),
          ),
          Dimens.d31.spaceHeight,
          Padding(
            padding:   EdgeInsets.symmetric(horizontal: Dimens.d70.h),
            child: CommonElevatedButton(title: "ok".tr, onTap: () {
              Get.back();
            },),
          )
        ],
      );
    },
  );
}
